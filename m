Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:11373 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbZEDSax (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 14:30:53 -0400
Received: by yx-out-2324.google.com with SMTP id 3so2318094yxj.1
        for <linux-wireless@vger.kernel.org>; Mon, 04 May 2009 11:30:53 -0700 (PDT)
Message-ID: <49FF3453.7020802@gmail.com>
Date: Mon, 04 May 2009 14:30:43 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: report operating frequency rather than current
References: <1241452330.8683.49.camel@johannes.local>	 <49FF2AE5.6040104@gmail.com> <1241460130.8683.85.camel@johannes.local>	 <49FF2FE8.8010004@gmail.com> <1241460944.8683.92.camel@johannes.local>
In-Reply-To: <1241460944.8683.92.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Mon, 2009-05-04 at 14:11 -0400, Richard Farina wrote:
>
>   
>> Yes, and at what point does it seem like a good idea to hide the channel 
>> the wifi card is on?  If I set channel 11 and it is scanning instead of 
>> locked on channel 11 then I should see the current channel the hardware 
>> is on.  This seems like an aweful idea to me, granted, it may help a few 
>> people that don't understand how scanning works, but hiding the truth is 
>> never a good idea. NACK.
>>     
>
> It's not really about hiding the truth. Besides, many many devices are
> _already_ "hiding the truth" (to use your words) because they do
> scanning in firmware and you never know what channel they're on (e.g.
> all Intel wireless hardware).
>
> I think it's completely pointless for us to reply to the question "what
> channel am I on" with the answer "currently the receiver is tuned to
> 132", when we can say "you're associated to a network on channel 11".
>
>   
And if the card claims to be associated but ends up stuck on another 
channel?  I can't see a good reason for this at all but if no one agrees 
with me then it is well without your power to simply overrule me.

I think it is an awful idea, and intel being broken isn't an excuse to 
break everything else.  If the card isn't on the right channel because 
of some random failure this patch ensures there is no way to 
troubleshoot.  If you want to display current channel that is the 
hardware channel, if you want to display "Channel the AP I'm associated 
to is on" then call it something other than "Current Channel"

My 0.02.

Thanks,
Rick Farina

> After all, we don't unset the SSID/BSSID when scanning either, even
> though we're currently not talking to the AP.
>
> johannes
>   

