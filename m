Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:55100 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753343AbXC2Ljk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2007 07:39:40 -0400
Message-ID: <460BA3FE.3000700@warmcat.com>
Date: Thu, 29 Mar 2007 12:33:18 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/4] mac80211: Monitor mode radiotap-based packet injection
References: <20070320103955.600509703@warmcat.com>	 <20070320104104.837354764@warmcat.com>	 <1174501733.3944.28.camel@johannes.berg>  <460B9F8C.3040701@warmcat.com> <1175167176.8807.53.camel@johannes.berg>
In-Reply-To: <1175167176.8807.53.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Thu, 2007-03-29 at 12:14 +0100, Andy Green wrote:
> 
>>>> +	static const u8 radiotap_entry_sizes[] = {
>>>> +		8, /* IEEE80211_RADIOTAP_TSFT */
>>>> +		1, /* IEEE80211_RADIOTAP_FLAGS */
>>> [...]
>>>
>>> I'd prefer C99 style for this.
>> Shocked that stuff from as late as 1999 is allowed.  I normally use // 
>> myself, I was making a special effort.
> 
> Oh, dang, that was ambiguous. I was thinking
> static const u8 radiotap_entry_sizes[] = {
> 	[IEEE80211_RADIOTAP_TSFT] = 8,
> 	...

Ha, well I will fix that up then.  I couldn't really understand how the 
coding style that insists to turn code into 80-col Bonsai Kittens can 
also allow //.

>> The idea here is to synthesize an rx packet later after the tx has 
>> happened, reflecting the tx status back to userspace that way (if he 
>> elects to listen out for them)?
> 
> Yeah. Michael Wu says we don't need the magic cookie though.

I missed this conversation evidently, didn't find it just now either. 
In case the plan is to block the thread doing the injection until the 
packet has gone out and is retired and can return an "acknowledged" 
status direct to the send()er, throughput is an issue.

-Andy
