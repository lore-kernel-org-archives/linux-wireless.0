Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:50786 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726954AbeH1MvH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 08:51:07 -0400
Message-ID: <1535446818.5895.15.camel@sipsolutions.net> (sfid-20180828_110030_847562_DF46E726)
Subject: Re: [RFCv2 2/2] mac80211: Add support for per-rate rx statistics
From: Johannes Berg <johannes@sipsolutions.net>
To: Sriram R <srirrama@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 28 Aug 2018 11:00:18 +0200
In-Reply-To: <655af9bf3136aefda93b137f80b9e726@codeaurora.org>
References: <1527514479-6696-1-git-send-email-srirrama@codeaurora.org>
         <1527514479-6696-3-git-send-email-srirrama@codeaurora.org>
         <1529065504.10037.18.camel@sipsolutions.net>
         <655af9bf3136aefda93b137f80b9e726@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Sorry for the late reply, my work hours are limited right now.

> I wanted to give a try with rhashtable and get your thoughts, since it 
> gave below flexibility to original patch,
> 1. avoids creating static memory when userspace starts accumulating 
> stats. 36 rate entries were used in original patch based on 10 (MCS 
> count) * 3 (entries per mcs)+ 6 escape entries, which would also 
> increase with HE supported now.

True, but rhashtable also has very significant overhead. I suspect it's
around the same order of magnitude as the allocation you need to keep
all the 36 entries?

struct rhashtable is probably already ~120 bytes on 64-bit systems (very
rough counting), and a single bucket table is >64, so you already have
close to 200 bytes for just the basic structures, without *any* entries.
And a significant amount of code too.

36 rate entries could probably be kept - I don't think you really need
to go more than that since you're not going to switch HT/VHT/HE all the
time, so that's only about 360 bytes total. You haven't gained much, but
made it much more complex, doing much more allocations (create
new/destroy old entries) etc.

I don't really see much value in that.

> 2. avoids restricting to only 3 entries per MCS in the table. Using 
> hashtable gave flexibility to add/read the table dynamically based on 
> encoded rate key.

Yes but if you don't limit, you end up with run-away memory consumption
again.

> Yes you're right ,it might grow but, as per this patch when Packet count 
> is greater
> than 65000 in an exntry or when the number of rate table/hashtable 
> entries exceed a count of MAX_RATE_TABLE_ELEMS (10 was used in this 
> patch), the complete table is dumped to userspace and new stats starts 
> getting collected in a new table after we flush the old one.
> Hence with this approach also the memory consumption is limited similar 
> to the original patch.

Right, so you limit to 10 entries, which is a total of

 ~120 + ~72 + 10 x (10 /* data */ + 3*8) = 524

in 12 different allocations. I don't think that's going to be much
better, and you seemed to think that the 10 would be commonly hit
(otherwise having a relatively small limit of 36 shouldn't be an issue)

So - I don't really see any advantage here, do you?

johannes
