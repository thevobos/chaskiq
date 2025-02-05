# frozen_string_literal: true

module Mutations
  module QuickReplies
    class DeleteQuickReply < Mutations::BaseMutation
      field :quick_reply, Types::QuickReplyType, null: false
      field :errors, Types::JsonType, null: false
      argument :app_key, String, required: true
      argument :id, String, required: true

      # , lang:)
      def resolve(app_key:, id:)
        app = current_user.apps.find_by(key: app_key)
        quick_reply = app.quick_replies.find(id)

        authorize! quick_reply, to: :can_manage_quick_replies?, with: AppPolicy, context: {
          app:
        }

        quick_reply.destroy

        {
          quick_reply:,
          errors: quick_reply.errors
        }
      end

      def current_user
        context[:current_user]
      end
    end
  end
end
