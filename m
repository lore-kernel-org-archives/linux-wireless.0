Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41932 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab3FQTJN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 15:09:13 -0400
Message-ID: <51BF5ED4.9010704@candelatech.com> (sfid-20130617_210916_835053_92650BEE)
Date: Mon, 17 Jun 2013 12:09:08 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Lots of confusion on bss refcounting.
References: <51BF5A53.8050100@candelatech.com>  (sfid-20130617_205007_448068_E9E81DD2) <1371495758.8168.3.camel@jlt4.sipsolutions.net>
In-Reply-To: <1371495758.8168.3.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/17/2013 12:02 PM, Johannes Berg wrote:
> On Mon, 2013-06-17 at 11:49 -0700, Ben Greear wrote:
>
>> We create an assoc_data, assign a bss pointer in ieee80211_mgd_assoc,
>> but do not claim a reference.
>
> Heh, yeah, I was actually looking at this code too but didn't have time
> today to finish my thoughts ...
>
>> Later, when deleting the assoc_data, the ref is not freed either,
>> except in one error path where it is explicitly freed:
>>
>> 		if (!ieee80211_assoc_success(sdata, *bss, mgmt, len)) {
>> 			/* oops -- internal error -- send timeout for now */
>> 			ieee80211_destroy_assoc_data(sdata, false);
>> 			cfg80211_put_bss(sdata->local->hw.wiphy, *bss);
>> 			return RX_MGMT_CFG80211_ASSOC_TIMEOUT;
>> 		}
>>
>> This seems ripe for bugs, if not already buggy.
>>
>> Maybe we should be more explicit about always grabbing a ref when
>> we take a reference to the pointer, and always put it when we
>> destroy the pointer?
>
> I think the reference is actually given to mac80211 by cfg80211 in
> cfg80211_mlme_assoc(), so we shouldn't need to grab a reference?
> Although I'm certainly willing to change this and make cfg80211 always
> put the reference after calling rdev_assoc() so that the driver/mac80211
> would be responsible for obtaining its own if it needs to hang on to the
> struct.
>
> This does seem broken though.

The bss reference is passed back, and through luck or careful programming,
it *seems* that all paths related to calling ieee80211_rx_mgmt_assoc_resp
managed to consume the bss.

I haven't figured out yet why this is not an erroneous put since I didn't
find the reference taken in the first place.

I'm going to work on making some changes to the ref counting scheme
a bit.  I'd rather have the code perhaps take and put a few refs
it might otherwise skip to keep the ownership cleaner and make
the code easier to debug and understand...

I'll post some for RFC when I make some progress.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

