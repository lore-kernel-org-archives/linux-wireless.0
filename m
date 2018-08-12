Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59462 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbeHLFUf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 12 Aug 2018 01:20:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Sun, 12 Aug 2018 08:14:17 +0530
From: Sriram R <srirrama@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFCv2 2/2] mac80211: Add support for per-rate rx statistics
In-Reply-To: <1529065504.10037.18.camel@sipsolutions.net>
References: <1527514479-6696-1-git-send-email-srirrama@codeaurora.org>
 <1527514479-6696-3-git-send-email-srirrama@codeaurora.org>
 <1529065504.10037.18.camel@sipsolutions.net>
Message-ID: <655af9bf3136aefda93b137f80b9e726@codeaurora.org> (sfid-20180812_044915_214232_034AE3FB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-06-15 17:55, Johannes Berg wrote:
> Why did you change to rhashtable?
Hi Johannes,
I wanted to give a try with rhashtable and get your thoughts, since it 
gave below flexibility to original patch,
1. avoids creating static memory when userspace starts accumulating 
stats. 36 rate entries were used in original patch based on 10 (MCS 
count) * 3 (entries per mcs)+ 6 escape entries, which would also 
increase with HE supported now.
2. avoids restricting to only 3 entries per MCS in the table. Using 
hashtable gave flexibility to add/read the table dynamically based on 
encoded rate key.
> 
> That seems very strange, since we explicitly want to limit the number 
> of
> entries, but rhashtable will grow/shrink as required.
Yes you're right ,it might grow but, as per this patch when Packet count 
is greater
than 65000 in an exntry or when the number of rate table/hashtable 
entries exceed a count of MAX_RATE_TABLE_ELEMS (10 was used in this 
patch), the complete table is dumped to userspace and new stats starts 
getting collected in a new table after we flush the old one.
Hence with this approach also the memory consumption is limited similar 
to the original patch.
> 
> I think I liked my approach better since it allowed us to clearly limit
> the memory consumption for this.
Sure Johannes, Could you please let me know if i can rebase your patch 
and send it(with corresponding additional entries for HE MCS). Also as 
mentioned above this patch also limits the memory consumption when the 
rate table size exceeds MAX_RATE_TABLE_ELEMS.
> 
> johannes
