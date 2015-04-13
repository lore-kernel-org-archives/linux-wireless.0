Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:33102 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462AbbDMV0c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2015 17:26:32 -0400
Received: by igbpi8 with SMTP id pi8so35356799igb.0
        for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2015 14:26:31 -0700 (PDT)
Date: Mon, 13 Apr 2015 17:26:28 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sven Eckelmann <sven@narfation.org>,
	linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
	Sven Eckelmann <sven@open-mesh.com>,
	Arik Nemtsov <arik@wizery.com>, liad.kaufman@intel.com
Subject: Re: [RFC v3] mac80211: lock rate control
Message-ID: <20150413212628.GA7869@localhost> (sfid-20150413_232637_706628_8D359557)
References: <1426061656-17546-1-git-send-email-sven@narfation.org>
 <1426185468.1885.17.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1426185468.1885.17.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 12, 2015 at 07:37:48PM +0100, Johannes Berg wrote:
> Another option might be to let mesh use a different spinlock, but then
> we'd have to be careful not to cause a lock->mesh_lock dependency since
> that would again lead to a lock->mesh_lock->rate_ctrl_lock dependency,
> which is still buggy since the aggregation code paths cause the other
> dependency.

I don't think this will be too bad.

With the below patch applied, I no longer get a lockdep complaint
when starting an HT mesh with the RC patch applied.

For completeness, lockdep complaint with the RC patch and without the
new spinlock patch looks like this:

======================================================
[ INFO: possible circular locking dependency detected ]
4.0.0-rc6-wl+ #53 Not tainted
-------------------------------------------------------
swapper/1/0 is trying to acquire lock:
 (&(&sta->lock)->rlock){+.-...}, at: [<ffffffffa0504b32>] ieee80211_start_tx_ba_session+0x29e/0x556 [mac80211]

but task is already holding lock:
 (&(&sta->rate_ctrl_lock)->rlock){+.-...}, at: [<ffffffffa0514fc0>] rate_control_get_rate+0xa7/0x113 [mac80211]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&(&sta->rate_ctrl_lock)->rlock){+.-...}:
       [<ffffffff8107ff90>] __lock_acquire+0x9ca/0xadc
       [<ffffffff8108084b>] lock_acquire+0x1b9/0x248
       [<ffffffff8144ccd7>] _raw_spin_lock_bh+0x45/0x78
       [<ffffffffa056d254>] mesh_sta_info_init+0x190/0x9ef [mac80211]
       [<ffffffffa056ddda>] mesh_sta_info_get+0x327/0x343 [mac80211]
       [<ffffffffa056f4eb>] mesh_rx_plink_frame+0x499/0x8e2 [mac80211]
       [<ffffffffa056a522>] ieee80211_mesh_rx_queued_mgmt+0xb6/0xe0 [mac80211]
       [<ffffffffa050fc10>] ieee80211_iface_work+0x2ea/0x378 [mac80211]
       [<ffffffff81058fc6>] process_one_work+0x309/0x68f
       [<ffffffff810595bf>] worker_thread+0x244/0x34e
       [<ffffffff8105de5a>] kthread+0xf8/0x100
       [<ffffffff8144d7c8>] ret_from_fork+0x58/0x90

-> #0 (&(&sta->lock)->rlock){+.-...}:
       [<ffffffff8107ca97>] validate_chain.isra.35+0x8da/0xf4b
       [<ffffffff8107ff90>] __lock_acquire+0x9ca/0xadc
       [<ffffffff8108084b>] lock_acquire+0x1b9/0x248
       [<ffffffff8144ccd7>] _raw_spin_lock_bh+0x45/0x78
       [<ffffffffa0504b32>] ieee80211_start_tx_ba_session+0x29e/0x556 [mac80211]
       [<ffffffffa057694c>] minstrel_ht_get_rate+0xd3/0x396 [mac80211]
       [<ffffffffa0514fd5>] rate_control_get_rate+0xbc/0x113 [mac80211]
       [<ffffffffa052a3bf>] invoke_tx_handlers+0x1199/0x120a [mac80211]
       [<ffffffffa052b022>] ieee80211_tx+0x93/0xc7 [mac80211]
       [<ffffffffa052c91c>] ieee80211_xmit+0xcf/0xd8 [mac80211]
       [<ffffffffa052ce43>] __ieee80211_subif_start_xmit+0xfd/0x163 [mac80211]
       [<ffffffffa052ceb9>] ieee80211_subif_start_xmit+0x10/0x14 [mac80211]
       [<ffffffff8139ff5d>] dev_hard_start_xmit+0x45c/0x6ef
       [<ffffffff813bd2ef>] sch_direct_xmit+0x9d/0x1ca
       [<ffffffff813a0670>] __dev_queue_xmit+0x480/0x7af
       [<ffffffff813a09bf>] dev_queue_xmit+0x10/0x12
       [<ffffffff813a8776>] neigh_resolve_output+0x1b3/0x1ce
       [<ffffffff813abb5e>] neigh_update+0x40e/0x5c8
       [<ffffffff81401196>] arp_process+0x5e3/0x63b
       [<ffffffff814012d8>] arp_rcv+0xea/0x135
       [<ffffffff8139c8d5>] __netif_receive_skb_core+0xa40/0xb6a
       [<ffffffff8139ce6e>] __netif_receive_skb+0x53/0x65
       [<ffffffff8139d120>] netif_receive_skb_internal+0x15d/0x1c0
       [<ffffffff8139d2ac>] netif_receive_skb+0x129/0x195
       [<ffffffffa05239d6>] ieee80211_deliver_skb+0x108/0x14d [mac80211]
       [<ffffffffa0525b6c>] ieee80211_rx_handlers+0x16d7/0x1dec [mac80211]
       [<ffffffffa0526c8f>] ieee80211_prepare_and_rx_handle+0xa0e/0xae9 [mac80211]
       [<ffffffffa0527549>] ieee80211_rx+0x7df/0x9e1 [mac80211]
       [<ffffffffa03c8abb>] ath_rx_tasklet+0x9a5/0xaf3 [ath9k]
       [<ffffffffa03c65bc>] ath9k_tasklet+0x14c/0x1d2 [ath9k]
       [<ffffffff81046057>] tasklet_action+0xb1/0xc2
       [<ffffffff810455c0>] __do_softirq+0x1ff/0x506
       [<ffffffff81045ab4>] irq_exit+0x41/0x5e
       [<ffffffff81450218>] do_IRQ+0xb8/0xd2
       [<ffffffff8144e3af>] ret_from_intr+0x0/0x13
       [<ffffffff8100bed2>] arch_cpu_idle+0xf/0x11
       [<ffffffff8107735a>] cpu_startup_entry+0x3d3/0x4a5
       [<ffffffff81029ec3>] start_secondary+0x121/0x141

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&(&sta->rate_ctrl_lock)->rlock);
                               lock(&(&sta->lock)->rlock);
                               lock(&(&sta->rate_ctrl_lock)->rlock);
  lock(&(&sta->lock)->rlock);

 *** DEADLOCK ***

9 locks held by swapper/1/0:
 #0:  (&(&sc->sc_pcu_lock)->rlock){+.-...}, at: [<ffffffffa03c64a9>] ath9k_tasklet+0x39/0x1d2 [ath9k]
 #1:  (rcu_read_lock){......}, at: [<ffffffffa0526eaf>] ieee80211_rx+0x145/0x9e1 [mac80211]
 #2:  (&(&local->rx_path_lock)->rlock){+.-...}, at: [<ffffffffa05244c8>] ieee80211_rx_handlers+0x33/0x1dec [mac80211]
 #3:  (rcu_read_lock){......}, at: [<ffffffff8139c022>] __netif_receive_skb_core+0x18d/0xb6a
 #4:  (rcu_read_lock){......}, at: [<ffffffff813abaab>] neigh_update+0x35b/0x5c8
 #5:  (rcu_read_lock_bh){......}, at: [<ffffffff813a024c>] __dev_queue_xmit+0x5c/0x7af
 #6:  (_xmit_ETHER#2){+.-...}, at: [<ffffffff813bd2c7>] sch_direct_xmit+0x75/0x1ca
 #7:  (rcu_read_lock){......}, at: [<ffffffffa052cd77>] __ieee80211_subif_start_xmit+0x31/0x163 [mac80211]
 #8:  (&(&sta->rate_ctrl_lock)->rlock){+.-...}, at: [<ffffffffa0514fc0>] rate_control_get_rate+0xa7/0x113 [mac80211]

stack backtrace:
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 4.0.0-rc6-wl+ #53
Hardware name: Supermicro C2SBX/C2SBX, BIOS 1.2a       12/19/2008
 ffffffff820422f0 ffff88025f003158 ffffffff81446a10 0000000000000000
 ffffffff82042100 ffff88025f0031a8 ffffffff81444afe 0000000000000009
 ffff88025e9ca250 ffff88025f0031a8 ffff88025e9cab58 ffff88025e9ca250
Call Trace:
 <IRQ>  [<ffffffff81446a10>] dump_stack+0x4c/0x65
 [<ffffffff81444afe>] print_circular_bug+0x2ad/0x2be
 [<ffffffff8107ca97>] validate_chain.isra.35+0x8da/0xf4b
 [<ffffffff8107ff90>] __lock_acquire+0x9ca/0xadc
 [<ffffffff8107e64b>] ? __lock_is_held+0x31/0x52
 [<ffffffff8108084b>] lock_acquire+0x1b9/0x248
 [<ffffffffa0504b32>] ? ieee80211_start_tx_ba_session+0x29e/0x556 [mac80211]
 [<ffffffffa054e06f>] ? __sdata_dbg+0x153/0x1d5 [mac80211]
 [<ffffffff8144ccd7>] _raw_spin_lock_bh+0x45/0x78
 [<ffffffffa0504b32>] ? ieee80211_start_tx_ba_session+0x29e/0x556 [mac80211]
 [<ffffffffa0504b32>] ieee80211_start_tx_ba_session+0x29e/0x556 [mac80211]
 [<ffffffffa057694c>] minstrel_ht_get_rate+0xd3/0x396 [mac80211]
 [<ffffffffa0514fd5>] rate_control_get_rate+0xbc/0x113 [mac80211]
 [<ffffffffa052a3bf>] invoke_tx_handlers+0x1199/0x120a [mac80211]
 [<ffffffff8107e64b>] ? __lock_is_held+0x31/0x52
 [<ffffffffa052b022>] ieee80211_tx+0x93/0xc7 [mac80211]
 [<ffffffffa0571dc9>] ? mesh_nexthop_resolve+0x30/0x1b1 [mac80211]
 [<ffffffffa052c91c>] ieee80211_xmit+0xcf/0xd8 [mac80211]
 [<ffffffffa052ce43>] __ieee80211_subif_start_xmit+0xfd/0x163 [mac80211]
 [<ffffffffa052cd77>] ? __ieee80211_subif_start_xmit+0x31/0x163 [mac80211]
 [<ffffffffa052ceb9>] ieee80211_subif_start_xmit+0x10/0x14 [mac80211]
 [<ffffffff8139ff5d>] dev_hard_start_xmit+0x45c/0x6ef
 [<ffffffff813bd2ef>] sch_direct_xmit+0x9d/0x1ca
 [<ffffffff813a0670>] __dev_queue_xmit+0x480/0x7af
 [<ffffffff813a024c>] ? __dev_queue_xmit+0x5c/0x7af
 [<ffffffff813a09bf>] dev_queue_xmit+0x10/0x12
 [<ffffffff813a8776>] neigh_resolve_output+0x1b3/0x1ce
 [<ffffffff813abb5e>] ? neigh_update+0x40e/0x5c8
 [<ffffffff813cc8bc>] ? ipv4_neigh_lookup+0x220/0x257
 [<ffffffff813cc6e1>] ? ipv4_neigh_lookup+0x45/0x257
 [<ffffffff813abb5e>] neigh_update+0x40e/0x5c8
 [<ffffffff813abaab>] ? neigh_update+0x35b/0x5c8
 [<ffffffff81401196>] arp_process+0x5e3/0x63b
 [<ffffffff814012d8>] arp_rcv+0xea/0x135
 [<ffffffff8139c8d5>] __netif_receive_skb_core+0xa40/0xb6a
 [<ffffffff8139c022>] ? __netif_receive_skb_core+0x18d/0xb6a
 [<ffffffff810a01b6>] ? ktime_get_with_offset+0x8e/0x111
 [<ffffffff8139ce6e>] __netif_receive_skb+0x53/0x65
 [<ffffffff8139d120>] netif_receive_skb_internal+0x15d/0x1c0
 [<ffffffff8139d2ac>] netif_receive_skb+0x129/0x195
 [<ffffffffa05239d6>] ieee80211_deliver_skb+0x108/0x14d [mac80211]
 [<ffffffffa0525b6c>] ieee80211_rx_handlers+0x16d7/0x1dec [mac80211]
 [<ffffffff8106cc53>] ? sched_clock_local+0x12/0x75
 [<ffffffff8107e64b>] ? __lock_is_held+0x31/0x52
 [<ffffffffa0526c8f>] ieee80211_prepare_and_rx_handle+0xa0e/0xae9 [mac80211]
 [<ffffffff8107e64b>] ? __lock_is_held+0x31/0x52
 [<ffffffffa0527549>] ieee80211_rx+0x7df/0x9e1 [mac80211]
 [<ffffffffa0526eaf>] ? ieee80211_rx+0x145/0x9e1 [mac80211]
 [<ffffffffa03c8abb>] ath_rx_tasklet+0x9a5/0xaf3 [ath9k]
 [<ffffffffa03c65bc>] ath9k_tasklet+0x14c/0x1d2 [ath9k]
 [<ffffffff81046057>] tasklet_action+0xb1/0xc2
 [<ffffffff810455c0>] __do_softirq+0x1ff/0x506
 [<ffffffff81045ab4>] irq_exit+0x41/0x5e
 [<ffffffff81450218>] do_IRQ+0xb8/0xd2
 [<ffffffff8144e3af>] common_interrupt+0x6f/0x6f
 <EOI>  [<ffffffff8100b63b>] ? default_idle+0xbb/0x1fb
 [<ffffffff8100b639>] ? default_idle+0xb9/0x1fb
 [<ffffffff8100bed2>] arch_cpu_idle+0xf/0x11
 [<ffffffff8107735a>] cpu_startup_entry+0x3d3/0x4a5
 [<ffffffff810a575a>] ? clockevents_register_device+0xf0/0xf9
 [<ffffffff81029ec3>] start_secondary+0x121/0x141

patch:

mac80211: introduce plink lock for plink fields

The mesh plink code uses sta->lock to serialize access to the
plink state fields between the peer link state machine and the
peer link timer.  Some paths (e.g. those involving
mps_qos_null_tx()) unfortunately hold this spinlock across
frame tx, which is soon to be disallowed.  Add a new spinlock
just for plink access.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 net/mac80211/mesh_plink.c |   37 ++++++++++++++++++++-----------------
 net/mac80211/sta_info.c   |    1 +
 net/mac80211/sta_info.h   |    5 ++++-
 3 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 60d737f..ac843fc 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -72,10 +72,11 @@ static bool rssi_threshold_check(struct ieee80211_sub_if_data *sdata,
  *
  * @sta: mesh peer link to restart
  *
- * Locking: this function must be called holding sta->lock
+ * Locking: this function must be called holding sta->plink_lock
  */
 static inline void mesh_plink_fsm_restart(struct sta_info *sta)
 {
+	lockdep_assert_held(&sta->plink_lock);
 	sta->plink_state = NL80211_PLINK_LISTEN;
 	sta->llid = sta->plid = sta->reason = 0;
 	sta->plink_retries = 0;
@@ -213,13 +214,15 @@ static u32 mesh_set_ht_prot_mode(struct ieee80211_sub_if_data *sdata)
  * All mesh paths with this peer as next hop will be flushed
  * Returns beacon changed flag if the beacon content changed.
  *
- * Locking: the caller must hold sta->lock
+ * Locking: the caller must hold sta->plink_lock
  */
 static u32 __mesh_plink_deactivate(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	u32 changed = 0;
 
+	lockdep_assert_held(&sta->plink_lock);
+
 	if (sta->plink_state == NL80211_PLINK_ESTAB)
 		changed = mesh_plink_dec_estab_count(sdata);
 	sta->plink_state = NL80211_PLINK_BLOCKED;
@@ -244,13 +247,13 @@ u32 mesh_plink_deactivate(struct sta_info *sta)
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	u32 changed;
 
-	spin_lock_bh(&sta->lock);
+	spin_lock_bh(&sta->plink_lock);
 	changed = __mesh_plink_deactivate(sta);
 	sta->reason = WLAN_REASON_MESH_PEER_CANCELED;
 	mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_CLOSE,
 			    sta->sta.addr, sta->llid, sta->plid,
 			    sta->reason);
-	spin_unlock_bh(&sta->lock);
+	spin_unlock_bh(&sta->plink_lock);
 
 	return changed;
 }
@@ -387,7 +390,7 @@ static void mesh_sta_info_init(struct ieee80211_sub_if_data *sdata,
 	sband = local->hw.wiphy->bands[band];
 	rates = ieee80211_sta_get_rates(sdata, elems, band, &basic_rates);
 
-	spin_lock_bh(&sta->lock);
+	spin_lock_bh(&sta->plink_lock);
 	sta->last_rx = jiffies;
 
 	/* rates and capabilities don't change during peering */
@@ -419,7 +422,7 @@ static void mesh_sta_info_init(struct ieee80211_sub_if_data *sdata,
 	else
 		rate_control_rate_update(local, sband, sta, changed);
 out:
-	spin_unlock_bh(&sta->lock);
+	spin_unlock_bh(&sta->plink_lock);
 }
 
 static struct sta_info *
@@ -552,7 +555,7 @@ static void mesh_plink_timer(unsigned long data)
 	if (sta->sdata->local->quiescing)
 		return;
 
-	spin_lock_bh(&sta->lock);
+	spin_lock_bh(&sta->plink_lock);
 
 	/* If a timer fires just before a state transition on another CPU,
 	 * we may have already extended the timeout and changed state by the
@@ -563,7 +566,7 @@ static void mesh_plink_timer(unsigned long data)
 		mpl_dbg(sta->sdata,
 			"Ignoring timer for %pM in state %s (timer adjusted)",
 			sta->sta.addr, mplstates[sta->plink_state]);
-		spin_unlock_bh(&sta->lock);
+		spin_unlock_bh(&sta->plink_lock);
 		return;
 	}
 
@@ -573,7 +576,7 @@ static void mesh_plink_timer(unsigned long data)
 		mpl_dbg(sta->sdata,
 			"Ignoring timer for %pM in state %s (timer deleted)",
 			sta->sta.addr, mplstates[sta->plink_state]);
-		spin_unlock_bh(&sta->lock);
+		spin_unlock_bh(&sta->plink_lock);
 		return;
 	}
 
@@ -619,7 +622,7 @@ static void mesh_plink_timer(unsigned long data)
 	default:
 		break;
 	}
-	spin_unlock_bh(&sta->lock);
+	spin_unlock_bh(&sta->plink_lock);
 	if (action)
 		mesh_plink_frame_tx(sdata, action, sta->sta.addr,
 				    sta->llid, sta->plid, reason);
@@ -674,16 +677,16 @@ u32 mesh_plink_open(struct sta_info *sta)
 	if (!test_sta_flag(sta, WLAN_STA_AUTH))
 		return 0;
 
-	spin_lock_bh(&sta->lock);
+	spin_lock_bh(&sta->plink_lock);
 	sta->llid = mesh_get_new_llid(sdata);
 	if (sta->plink_state != NL80211_PLINK_LISTEN &&
 	    sta->plink_state != NL80211_PLINK_BLOCKED) {
-		spin_unlock_bh(&sta->lock);
+		spin_unlock_bh(&sta->plink_lock);
 		return 0;
 	}
 	sta->plink_state = NL80211_PLINK_OPN_SNT;
 	mesh_plink_timer_set(sta, sdata->u.mesh.mshcfg.dot11MeshRetryTimeout);
-	spin_unlock_bh(&sta->lock);
+	spin_unlock_bh(&sta->plink_lock);
 	mpl_dbg(sdata,
 		"Mesh plink: starting establishment with %pM\n",
 		sta->sta.addr);
@@ -700,10 +703,10 @@ u32 mesh_plink_block(struct sta_info *sta)
 {
 	u32 changed;
 
-	spin_lock_bh(&sta->lock);
+	spin_lock_bh(&sta->plink_lock);
 	changed = __mesh_plink_deactivate(sta);
 	sta->plink_state = NL80211_PLINK_BLOCKED;
-	spin_unlock_bh(&sta->lock);
+	spin_unlock_bh(&sta->plink_lock);
 
 	return changed;
 }
@@ -758,7 +761,7 @@ static u32 mesh_plink_fsm(struct ieee80211_sub_if_data *sdata,
 	mpl_dbg(sdata, "peer %pM in state %s got event %s\n", sta->sta.addr,
 		mplstates[sta->plink_state], mplevents[event]);
 
-	spin_lock_bh(&sta->lock);
+	spin_lock_bh(&sta->plink_lock);
 	switch (sta->plink_state) {
 	case NL80211_PLINK_LISTEN:
 		switch (event) {
@@ -872,7 +875,7 @@ static u32 mesh_plink_fsm(struct ieee80211_sub_if_data *sdata,
 		 */
 		break;
 	}
-	spin_unlock_bh(&sta->lock);
+	spin_unlock_bh(&sta->plink_lock);
 	if (action) {
 		mesh_plink_frame_tx(sdata, action, sta->sta.addr,
 				    sta->llid, sta->plid, sta->reason);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 12971b7..53ab4bd 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -295,6 +295,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	INIT_WORK(&sta->ampdu_mlme.work, ieee80211_ba_session_work);
 	mutex_init(&sta->ampdu_mlme.mtx);
 #ifdef CONFIG_MAC80211_MESH
+	spin_lock_init(&sta->plink_lock);
 	if (ieee80211_vif_is_mesh(&sdata->vif) &&
 	    !sdata->u.mesh.user_mpm)
 		init_timer(&sta->plink_timer);
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 5c164fb..40ad52e 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -299,6 +299,7 @@ struct sta_ampdu_mlme {
  * @tid_seq: per-TID sequence numbers for sending to this STA
  * @ampdu_mlme: A-MPDU state machine state
  * @timer_to_tid: identity mapping to ID timers
+ * @plink_lock: serialize access to plink fields
  * @llid: Local link ID
  * @plid: Peer link ID
  * @reason: Cancel reason on PLINK_HOLDING state
@@ -422,9 +423,10 @@ struct sta_info {
 
 #ifdef CONFIG_MAC80211_MESH
 	/*
-	 * Mesh peer link attributes
+	 * Mesh peer link attributes, protected by plink_lock.
 	 * TODO: move to a sub-structure that is referenced with pointer?
 	 */
+	spinlock_t plink_lock;
 	u16 llid;
 	u16 plid;
 	u16 reason;
@@ -432,6 +434,7 @@ struct sta_info {
 	enum nl80211_plink_state plink_state;
 	u32 plink_timeout;
 	struct timer_list plink_timer;
+
 	s64 t_offset;
 	s64 t_offset_setpoint;
 	/* mesh power save */
-- 
1.7.10.4



-- 
Bob Copeland %% http://bobcopeland.com/
