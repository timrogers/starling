module Starling
  module Middlewares
    class RaiseStarlingErrors < Faraday::Response::Middleware
      ERROR_STATUSES = 400..599

      def on_complete(env)
        return unless !json?(env) && ERROR_STATUSES.include?(env.status)
        raise Errors::ApiError, env
      end

      private

      def json?(env)
        env.response_headers.fetch('Content-Type', '')
           .include?('application/json')
      end
    end
  end
end

Faraday::Response.register_middleware(
  raise_starling_errors: Starling::Middlewares::RaiseStarlingErrors
)
