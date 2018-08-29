Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39276 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727316AbeH2SFG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 14:05:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 29 Aug 2018 19:37:57 +0530
From: Sriram R <srirrama@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFCv2 2/2] mac80211: Add support for per-rate rx statistics
In-Reply-To: <1535446818.5895.15.camel@sipsolutions.net>
References: <1527514479-6696-1-git-send-email-srirrama@codeaurora.org>
 <1527514479-6696-3-git-send-email-srirrama@codeaurora.org>
 <1529065504.10037.18.camel@sipsolutions.net>
 <655af9bf3136aefda93b137f80b9e726@codeaurora.org>
 <1535446818.5895.15.camel@sipsolutions.net>
Message-ID: <a9d2eb34e3f814523d354252fc639c5b@codeaurora.org> (sfid-20180829_160815_253227_92D56C9E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-08-28 14:30, Johannes Berg wrote:
> Hi,
> 
> Sorry for the late reply, my work hours are limited right now.
> 
>> I wanted to give a try with rhashtable and get your thoughts, since it
>> gave below flexibility to original patch,
>> 1. avoids creating static memory when userspace starts accumulating
>> stats. 36 rate entries were used in original patch based on 10 (MCS
>> count) * 3 (entries per mcs)+ 6 escape entries, which would also
>> increase with HE supported now.
> 
> True, but rhashtable also has very significant overhead. I suspect it's
> around the same order of magnitude as the allocation you need to keep
> all the 36 entries?
> 
> struct rhashtable is probably already ~120 bytes on 64-bit systems 
> (very
> rough counting), and a single bucket table is >64, so you already have
> close to 200 bytes for just the basic structures, without *any* 
> entries.
> And a significant amount of code too.
> 
> 36 rate entries could probably be kept - I don't think you really need
> to go more than that since you're not going to switch HT/VHT/HE all the
> time, so that's only about 360 bytes total. You haven't gained much, 
> but
> made it much more complex, doing much more allocations (create
> new/destroy old entries) etc.
> 
> I don't really see much value in that.
> 
Okay Johannes. I'll revive this patch based on your approach
and submit for review.

Thanks,
Sriram.R
>> 2. avoids restricting to only 3 entries per MCS in the table. Using
>> hashtable gave flexibility to add/read the table dynamically based on
>> encoded rate key.
> 
> Yes but if you don't limit, you end up with run-away memory consumption
> again.
> 
>> Yes you're right ,it might grow but, as per this patch when Packet 
>> count
>> is greater
>> than 65000 in an exntry or when the number of rate table/hashtable
>> entries exceed a count of MAX_RATE_TABLE_ELEMS (10 was used in this
>> patch), the complete table is dumped to userspace and new stats starts
>> getting collected in a new table after we flush the old one.
>> Hence with this approach also the memory consumption is limited 
>> similar
>> to the original patch.
> 
> Right, so you limit to 10 entries, which is a total of
> 
>  ~120 + ~72 + 10 x (10 /* data */ + 3*8) = 524
> 
> in 12 different allocations. I don't think that's going to be much
> better, and you seemed to think that the 10 would be commonly hit
> (otherwise having a relatively small limit of 36 shouldn't be an issue)
> 
> So - I don't really see any advantage here, do you?
> 
> johannes
