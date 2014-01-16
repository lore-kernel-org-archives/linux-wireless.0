Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:35364 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbaAPOAB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 09:00:01 -0500
Received: by mail-la0-f42.google.com with SMTP id hr13so536037lab.1
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jan 2014 06:00:00 -0800 (PST)
Message-ID: <52D7E5DA.1060900@gmail.com> (sfid-20140116_150006_205539_63103AE8)
Date: Thu, 16 Jan 2014 14:59:54 +0100
From: Pontus Fuchs <pontus.fuchs@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] nl80211: Reset split_start on error path when split dump
 is not used
References: <1389879279-20832-1-git-send-email-pontus.fuchs@gmail.com>		 (sfid-20140116_143453_482265_044A6882) <1389879668.4345.5.camel@jlt4.sipsolutions.net>	 <52D7E3C1.4090308@gmail.com> (sfid-20140116_145102_990344_1690246A) <1389880396.4345.6.camel@jlt4.sipsolutions.net>
In-Reply-To: <1389880396.4345.6.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-01-16 14:53, Johannes Berg wrote:

>>> @@ -1680,6 +1680,7 @@ static int nl80211_dump_wiphy(struct sk_buff *skb, struct netlink_callback *cb)
>>>    				    !skb->len &&
>>>    				    cb->min_dump_alloc < 4096) {
>>>    					cb->min_dump_alloc = 4096;
>>> +					state->split_start = 0;
>>>    					rtnl_unlock();
>>>    					return 1;
>>>    				}
>>
>> Will that not cause problem if split scan is in use and one of the split
>> chunks needs to be resent due to EMSGSIZE?
>
> That's not supposed to happen, and the "!skb->len" check should catch
> it.
>
> johannes

Ok. Thanks. Lets go for that version then.

//Pontus


