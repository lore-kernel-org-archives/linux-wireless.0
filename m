Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42318 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab3FLU6q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 16:58:46 -0400
Message-ID: <51B8E101.2050503@candelatech.com> (sfid-20130612_225849_144928_67A5EEEC)
Date: Wed, 12 Jun 2013 13:58:41 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: kmemleak report related to ieee80211_start_tx_ba_session, tid_start_tx
 locking issues?
References: <51B8BC3E.40905@candelatech.com>  (sfid-20130612_202155_810155_8B14A60D) <1371069960.8601.35.camel@jlt4.sipsolutions.net>
In-Reply-To: <1371069960.8601.35.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/12/2013 01:46 PM, Johannes Berg wrote:
> On Wed, 2013-06-12 at 11:21 -0700, Ben Greear wrote:
>
>> In ieee80211_start_tx_ba_session we are accessing and assigning the tid_start_tx
>> without holding the ampdu_mlme.mtx mutex.
>>
>> 	spin_lock_bh(&sta->lock);
>> .....
>> 	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
>> 	/* check if the TID is not in aggregation flow already */
>> 	if (tid_tx || sta->ampdu_mlme.tid_start_tx[tid]) {
>>
>> ....
>>
>> 	/*
>> 	 * Finally, assign it to the start array; the work item will
>> 	 * collect it and move it to the normal array.
>> 	 */
>> 	sta->ampdu_mlme.tid_start_tx[tid] = tid_tx;
>>
>>
>> Elsewhere, in ieee80211_ba_session_work, we access the tid_start_tx
>> without the sta->lock held, but with the ampdu_mlme.mtx held.
>
> Yeah, that seems wrong.
>
>> I think we should probably hold ampdu_mlme.mtx in ieee80211_start_tx_ba_session
>> or make sure we hold sta->lock in ieee80211_ba_session_work.
>
> Can't hold the mutex there, but we can do the lock (I'll comment on your
> patch separately)
>
>> unreferenced object 0xffff880219b4de40 (size 192):
>>     comm "softirq", pid 0, jiffies 4296416789 (age 1257.971s)
>>     hex dump (first 32 bytes):
>>       00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>       00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>     backtrace:
>>       [<ffffffff815bc02c>] kmemleak_alloc+0x73/0x98
>>       [<ffffffff8117d4b4>] slab_post_alloc_hook+0x28/0x2a
>>       [<ffffffff8117f4a6>] kmem_cache_alloc_trace+0xa5/0xcc
>>       [<ffffffffa0365221>] ieee80211_start_tx_ba_session+0x24b/0x360 [mac80211]
>>       [<ffffffffa03a98f3>] minstrel_ht_tx_status+0x79a/0x7a9 [mac80211]
>>       [<ffffffffa035d1cd>] ieee80211_tx_status+0x3af/0x947 [mac80211]
>
> When did this report get printed?

I have a system with 100 or so stations constantly trying to
associate with a set of APs that can handle < 100.  This
effectively causes constant churn of re-associations and
associated logic...

Good for shaking out bugs it seems :)

These and other leaks show up after a few minutes of
running this test scenario.  It's not a huge number of
leaks, however...so usually stations go away w/out leaking.

> I have a feeling what happens is that start is requested, and then
> before ieee80211_ba_session_work() gets a chance to run the station is
> destroyed.
>
> Should probably have something like this:
>
> diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
> index b429798..aaf68d2 100644
> --- a/net/mac80211/sta_info.c
> +++ b/net/mac80211/sta_info.c
> @@ -149,6 +149,7 @@ static void cleanup_single_sta(struct sta_info *sta)
>   	 * directly by station destruction.
>   	 */
>   	for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
> +		kfree(sta->ampdu_mlme.tid_start_tx[i]);
>   		tid_tx = rcu_dereference_raw(sta->ampdu_mlme.tid_tx[i]);
>   		if (!tid_tx)
>   			continue;

Looks reasonable to me.  I was about to start testing similar logic
in sta_info_free(), but likely your patch is more proper.

I'll give it a try now.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

