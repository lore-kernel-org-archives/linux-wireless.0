Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58938 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884Ab3FLSVv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 14:21:51 -0400
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r5CILo9V017833
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 12 Jun 2013 11:21:51 -0700
Message-ID: <51B8BC3E.40905@candelatech.com> (sfid-20130612_202155_810155_8B14A60D)
Date: Wed, 12 Jun 2013 11:21:50 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: kmemleak report related to ieee80211_start_tx_ba_session, tid_start_tx
 locking issues?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is on 3.9.5+

I see a fair amount of these.  Once again, the locking is tricky
for my poor brain, but I am suspicious of this part of things.

It seems that ampdu_mlme.mtx is used to protect the tid
arrays (although sta->lock also applies to part of it).

In ieee80211_start_tx_ba_session we are accessing and assigning the tid_start_tx
without holding the ampdu_mlme.mtx mutex.

	spin_lock_bh(&sta->lock);
.....
	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
	/* check if the TID is not in aggregation flow already */
	if (tid_tx || sta->ampdu_mlme.tid_start_tx[tid]) {

....

	/*
	 * Finally, assign it to the start array; the work item will
	 * collect it and move it to the normal array.
	 */
	sta->ampdu_mlme.tid_start_tx[tid] = tid_tx;


Elsewhere, in ieee80211_ba_session_work, we access the tid_start_tx
without the sta->lock held, but with the ampdu_mlme.mtx held.

I think we should probably hold ampdu_mlme.mtx in ieee80211_start_tx_ba_session
or make sure we hold sta->lock in ieee80211_ba_session_work.


unreferenced object 0xffff880219b4de40 (size 192):
   comm "softirq", pid 0, jiffies 4296416789 (age 1257.971s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<ffffffff815bc02c>] kmemleak_alloc+0x73/0x98
     [<ffffffff8117d4b4>] slab_post_alloc_hook+0x28/0x2a
     [<ffffffff8117f4a6>] kmem_cache_alloc_trace+0xa5/0xcc
     [<ffffffffa0365221>] ieee80211_start_tx_ba_session+0x24b/0x360 [mac80211]
     [<ffffffffa03a98f3>] minstrel_ht_tx_status+0x79a/0x7a9 [mac80211]
     [<ffffffffa035d1cd>] ieee80211_tx_status+0x3af/0x947 [mac80211]
     [<ffffffffa06e86fa>] ath_txq_unlock_complete+0xb0/0xbb [ath9k]
     [<ffffffffa06e8992>] ath_tx_edma_tasklet+0x28d/0x2a4 [ath9k]
     [<ffffffffa06e33cd>] ath9k_tasklet+0x111/0x150 [ath9k]
     [<ffffffff8109d6d3>] tasklet_action+0x7d/0xcc
     [<ffffffff8109db2c>] __do_softirq+0x114/0x254
     [<ffffffff8109dcfe>] irq_exit+0x4b/0xa8
     [<ffffffff815d481d>] do_IRQ+0x9d/0xb4
     [<ffffffff815cc8ed>] ret_from_intr+0x0/0x15
     [<ffffffff814c8efb>] cpuidle_enter_tk+0x10/0x12
     [<ffffffff814c89b5>] cpuidle_enter_state+0x17/0x3f

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

