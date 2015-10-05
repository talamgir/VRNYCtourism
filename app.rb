require "sinatra"
require "mandrill"

enable :sessions

get "/home" do
  erb :contactus
end

post '/confirm' do 
  puts params.inspect
  message = params["message"]
  mandrill = Mandrill::API.new ENV['rlt8fbn1ZKzqbfNeRkumow']
    message = {
              :subject=> "Reservation Confirmation for VRNYC",
              :to=> [{
                      :email=> "#{params[:user_email]}",
                      :name=> "VRNYC Experience",
                    }],
              :from_email=> "talamgir@law.gwu.edu",
              :html=> "<html>#{params[:user_input]}," + "you are confirmed for your reservation, your comments were " + "#{params[:user_story]}</html>"
              # :message=> "#{params[:user_name]}," + "you are confirmed for your reservation, your comments were " + "#{params[:user_story]}"
            }
            
  sending = mandrill.messages.send(message)
  puts sending

  ## Redirect
  user_input = params[:user_input]
  session[ :message_name] = "#{user_input}"

  user_email = params[:user_email]
  session[ :message_email] = "#{user_email}"

  user_story = params[:user_story]
  session[ :message_story] = "#{user_story}"

  redirect "/confirmation"
end

get '/confirmation' do

  @message_name = session.delete(:message_name)
  @message_email = session.delete(:message_email)
  @message_story = session.delete(:message_story)
  erb :confirmation

  # :locals => {:user_input => params[:user_input], :user_email=> params[:user_email], :user_story => params[:user_story]}
end
