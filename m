Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f133.google.com ([209.85.221.133]:50493 "EHLO
	mail-qy0-f133.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbZEEScw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2009 14:32:52 -0400
Received: by qyk39 with SMTP id 39so1618604qyk.33
        for <linux-wireless@vger.kernel.org>; Tue, 05 May 2009 11:32:51 -0700 (PDT)
Message-ID: <4A008649.1000007@gmail.com>
Date: Tue, 05 May 2009 14:32:41 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: Kalle Valo <kalle.valo@iki.fi>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: report operating frequency rather than current
References: <1241452330.8683.49.camel@johannes.local>	<49FF2AE5.6040104@gmail.com> <1241460130.8683.85.camel@johannes.local>	<49FF2FE8.8010004@gmail.com> <20090504181357.GA19022@tuxdriver.com> <87eiv49k6o.fsf@litku.valot.fi>
In-Reply-To: <87eiv49k6o.fsf@litku.valot.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo wrote:
> "John W. Linville" <linville@tuxdriver.com> writes:
>
>   
>>> Yes, and at what point does it seem like a good idea to hide the channel  
>>> the wifi card is on?  If I set channel 11 and it is scanning instead of  
>>> locked on channel 11 then I should see the current channel the hardware  
>>> is on.  This seems like an aweful idea to me, granted, it may help a few  
>>> people that don't understand how scanning works, but hiding the truth is  
>>> never a good idea. NACK.
>>>       
>> I can see what you mean, but I think showing seemingly random
>> fluctuations in channel assignments is at best distracting.  Don't you
>> agree that most people are more interested in seeing the configuration
>> state than the transient state of the hardware?
>>     
>
> I agree, it's very distracting. And while doing mac80211 software scan
> the device is on a channel approximately 30 ms with queues stopped, so
> no data is transfered at that time. I don't see any benefit from
> reporting this value to user space: "Hey, I'm on channel 5 now but by
> the time to you read this I will be on channel 6 already."
>
> If people want to follow how mac80211 changes the frequency during scan,
> the proper way is to add debug messages for op_config() calls. I saw
> that Johannes was already working on that.
>
>   
To be honest, I would be perfectly happy with this patch if something 
like a scanning "flag" were to be show in the output if that is what is 
happening.  I don't so much need to see the current channel (when in sta 
mode at least) as I need to know that the card is scanning if it is not 
currently on the channel the AP is on.  I'd be very happy to simply see 
it say "scanning" next to the channel or some such when this occurs.

thanks,
Rick Farina

