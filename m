Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f133.google.com ([209.85.221.133]:60237 "EHLO
	mail-qy0-f133.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932181AbZEDSMF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 14:12:05 -0400
Received: by qyk39 with SMTP id 39so358444qyk.33
        for <linux-wireless@vger.kernel.org>; Mon, 04 May 2009 11:12:04 -0700 (PDT)
Message-ID: <49FF2FE8.8010004@gmail.com>
Date: Mon, 04 May 2009 14:11:52 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: report operating frequency rather than current
References: <1241452330.8683.49.camel@johannes.local>	 <49FF2AE5.6040104@gmail.com> <1241460130.8683.85.camel@johannes.local>
In-Reply-To: <1241460130.8683.85.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Mon, 2009-05-04 at 13:50 -0400, Richard Farina wrote:
>   
>> Johannes Berg wrote:
>>     
>>> It's not very helpful to see, in iwconfig, the current frequency
>>> the card is tuned to if that frequency is currently somewhere
>>> across the board because we're scanning. Since we keep track of
>>> the frequency the user wants, display that instead.
>>>
>>> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>>> ---
>>>  net/mac80211/wext.c |    2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> --- wireless-testing.orig/net/mac80211/wext.c	2009-05-04 17:41:53.000000000 +0200
>>> +++ wireless-testing/net/mac80211/wext.c	2009-05-04 17:42:02.000000000 +0200
>>> @@ -185,7 +185,7 @@ static int ieee80211_ioctl_giwfreq(struc
>>>  	if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
>>>  		return cfg80211_ibss_wext_giwfreq(dev, info, freq, extra);
>>>  
>>> -	freq->m = local->hw.conf.channel->center_freq;
>>> +	freq->m = local->oper_channel->center_freq;
>>>  	freq->e = 6;
>>>  
>>>  	return 0;
>>>
>>>
>>>   
>>>       
>> Nack.  People should see the hardware channel. If I set channel 6 and my 
>> wifi card is on channel 11 I need to see 11 not 6.  Doesn't make any 
>> sense to show some imaginary idealistic "I wish it was on channel 6" 
>> when the hardware is on channel 11.  Am I missing something here?
>>     
>
> Umm, if _you_ set channel 11 then you _will_ see channel 11. It's just
> that when it's scanning and happens to be on channel 132 instead of 11,
> while you previously set 11, you will _after_ this patch see 11, not
> 132.
>
>   
Yes, and at what point does it seem like a good idea to hide the channel 
the wifi card is on?  If I set channel 11 and it is scanning instead of 
locked on channel 11 then I should see the current channel the hardware 
is on.  This seems like an aweful idea to me, granted, it may help a few 
people that don't understand how scanning works, but hiding the truth is 
never a good idea. NACK.

-Rick Farina

> johannes
>   

