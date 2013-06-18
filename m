Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55791 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933051Ab3FRVga (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 17:36:30 -0400
Message-ID: <51C0D2D8.3080207@candelatech.com> (sfid-20130618_233639_394762_E90AF0A6)
Date: Tue, 18 Jun 2013 14:36:24 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Lots of confusion on bss refcounting.
References: <51BF5A53.8050100@candelatech.com>    (sfid-20130617_205007_448068_E9E81DD2) <1371495758.8168.3.camel@jlt4.sipsolutions.net>   <51BF5ED4.9010704@candelatech.com> <51BF8040.2000408@candelatech.com>   <51BFAA34.1020407@candelatech.com>  <1371559771.8318.12.camel@jlt4.sipsolutions.net>  <51C08119.3000407@candelatech.com> <1371570723.22256.0.camel@jlt4.sipsolutions.net>
In-Reply-To: <1371570723.22256.0.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/18/2013 08:52 AM, Johannes Berg wrote:
>
>>> You mean ->current_bss? That should be handled in all the callbacks in
>>> sme.c or so
>>
>> Looks like much of the action happens on work-queues.  I'm wondering if
>> we managed to delete wdev objects before we have completely cleaned up
>> in some cases...
>
> Don't we flush work structs appropriately?

I'm still seeing leaks after all those patches I posted...so I'm still
looking.  The leaked bss objects have a quite large refcount, in the
hundreds after an hour or so of running, so this is probably more than
a strange race somewhere.


This code looks questionable in wireless/mlme.c

int __cfg80211_mlme_assoc()
.....

It grabs a reference using cfg80211_get_bss, but it only
does a put on the reference if there was an error code.

The __cfg80211_mlme_auth a bit above always does a put on
the reference.

I'm thinking mlme_assoc should also always do put.  Any
reason you can think of otherwise?

Thanks,
Ben

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

