Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:48388 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059Ab1BNPyF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 10:54:05 -0500
Message-ID: <4D595018.3080609@neratec.com>
Date: Mon, 14 Feb 2011 16:54:00 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] nl80211: interface update
References: <1297252905-29739-1-git-send-email-zefir.kurtisi@neratec.com>	 <1297252905-29739-2-git-send-email-zefir.kurtisi@neratec.com> <1297678858.3785.20.camel@jlt3.sipsolutions.net>
In-Reply-To: <1297678858.3785.20.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/14/2011 11:20 AM, Johannes Berg wrote:
> I'm thinking this is [RFC] really?
> 
>> @@ -1076,6 +1078,10 @@ enum nl80211_attrs {
>>  
>>  	/* add attributes here, update the policy in nl80211.c */
>>  
>> +	NL80211_DFSEVENT_ATTR_FREQ,
>> +	NL80211_DFSEVENT_ATTR_TS,
>> +	NL80211_DFSEVENT_ATTR_WIDTH,
> 
> I think it would be preferable to create a new DFS_EVENT attribute (also
> note that all attributse should be prefixed by NL80211_ATTR_) and then
> nest data into it.
> 
> However, why is the TS/width data needed at all?
> 
> johannes
> 
Thanks for the review.

I will follow Your suggestions in case we decided to take the approach of 
DFS handling done in userspace (we most probably will not).

FYI, TS and width are the attributes of radar pulse events that a DFS pattern 
detector is fed with. In fact, the width is inaccurate (e.g. with Atheros 
chipsets) for most test patterns, so you basically have a series of time 
stamps to do the pattern matching.



Cheers
Zefir


