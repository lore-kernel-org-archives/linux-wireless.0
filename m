Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:35883 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbcENRvE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 May 2016 13:51:04 -0400
Received: by mail-io0-f177.google.com with SMTP id i75so162754383ioa.3
        for <linux-wireless@vger.kernel.org>; Sat, 14 May 2016 10:51:03 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, fred.veldini@gmail.com,
	Bob Copeland <me@bobcopeland.com>, stable@vger.kernel.org
Subject: [PATCH] mac80211: mesh: flush mesh paths early in sta destroy
Date: Sat, 14 May 2016 13:49:58 -0400
Message-Id: <1463248198-3926-1-git-send-email-me@bobcopeland.com> (sfid-20160514_195110_936600_4D170E2F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, the mesh paths associated with a nexthop station are cleaned
up in the following code path:

    __sta_info_destroy_part1
    synchronize_net()
    __sta_info_destroy_part2
     -> cleanup_single_sta
       -> mesh_sta_cleanup
         -> mesh_plink_deactivate
           -> mesh_path_flush_by_nexthop

However, there are a couple of problems here:

1) the paths aren't flushed at all if the MPM is running in userspace
   (e.g. when using wpa_supplicant or authsae)

2) there is no synchronize_rcu between removing the path and readers
   accessing the nexthop, which means the following race is possible:

CPU0                            CPU1
~~~~                            ~~~~
                                sta_info_destroy_part1()
                                synchronize_net()
rcu_read_lock()
mesh_nexthop_resolve()
  mpath = mesh_path_lookup()
                                [...] -> mesh_path_flush_by_nexthop()
  sta = rcu_dereference(
    mpath->next_hop)
                                kfree(sta)
  access sta <-- CRASH

Fix both of these by unconditionally flushing paths in part1 of sta
destroy.  The synchronize_net() will then happen after paths
are flushed, preventing mesh_path_lookup from finding a path with
the to-be-freed nexthop sta.

Also, add a new sta bit and a check in mesh_path_assign_nexthop() to
avoid adding it back between the flush and the synchronize_net().

Fixes this crash:

[  348.529295] BUG: unable to handle kernel paging request at 00020040
[  348.530014] IP: [<f929245d>] ieee80211_mps_set_frame_flags+0x40/0xaa [mac80211]
[  348.530014] *pde = 00000000
[  348.530014] Oops: 0000 [#1] PREEMPT
[  348.530014] Modules linked in: drbg ansi_cprng ctr ccm ppp_generic slhc ipt_MASQUERADE nf_nat_masquerade_ipv4 8021q ]
[  348.530014] CPU: 0 PID: 20597 Comm: wget Tainted: G           O 4.6.0-rc5-wt=V1 #1
[  348.530014] Hardware name: To Be Filled By O.E.M./To be filled by O.E.M., BIOS 080016  11/07/2014
[  348.530014] task: f64fa280 ti: f4f9c000 task.ti: f4f9c000
[  348.530014] EIP: 0060:[<f929245d>] EFLAGS: 00010246 CPU: 0
[  348.530014] EIP is at ieee80211_mps_set_frame_flags+0x40/0xaa [mac80211]
[  348.530014] EAX: f4ce63e0 EBX: 00000088 ECX: f3788416 EDX: 00020008
[  348.530014] ESI: 00000000 EDI: 00000088 EBP: f6409a4c ESP: f6409a40
[  348.530014]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  348.530014] CR0: 80050033 CR2: 00020040 CR3: 33190000 CR4: 00000690
[  348.530014] Stack:
[  348.530014]  00000000 f4ce63e0 f5f9bd80 f6409a64 f9291d80 0000ce67 f5d51e00 f4ce63e0
[  348.530014]  f3788416 f6409a80 f9291dc1 f4ce8320 f4ce63e0 f5d51e00 f4ce63e0 f4ce8320
[  348.530014]  f6409a98 f9277f6f 00000000 00000000 0000007c 00000000 f6409b2c f9278dd1
[  348.530014] Call Trace:
[  348.530014]  [<f9291d80>] mesh_nexthop_lookup+0xbb/0xc8 [mac80211]
[  348.530014]  [<f9291dc1>] mesh_nexthop_resolve+0x34/0xd8 [mac80211]
[  348.530014]  [<f9277f6f>] ieee80211_xmit+0x92/0xc1 [mac80211]
[  348.530014]  [<f9278dd1>] __ieee80211_subif_start_xmit+0x807/0x83c [mac80211]
[  348.530014]  [<c04df012>] ? sch_direct_xmit+0xd7/0x1b3
[  348.530014]  [<c022a8c6>] ? __local_bh_enable_ip+0x5d/0x7b
[  348.530014]  [<f956870c>] ? nf_nat_ipv4_out+0x4c/0xd0 [nf_nat_ipv4]
[  348.530014]  [<f957e036>] ? iptable_nat_ipv4_fn+0xf/0xf [iptable_nat]
[  348.530014]  [<c04c6f45>] ? netif_skb_features+0x14d/0x30a
[  348.530014]  [<f9278e10>] ieee80211_subif_start_xmit+0xa/0xe [mac80211]
[  348.530014]  [<c04c769c>] dev_hard_start_xmit+0x1f8/0x267
[  348.530014]  [<c04c7261>] ?  validate_xmit_skb.isra.120.part.121+0x10/0x253
[  348.530014]  [<c04defc6>] sch_direct_xmit+0x8b/0x1b3
[  348.530014]  [<c04c7a9c>] __dev_queue_xmit+0x2c8/0x513
[  348.530014]  [<c04c7cfb>] dev_queue_xmit+0xa/0xc
[  348.530014]  [<f91bfc7a>] batadv_send_skb_packet+0xd6/0xec [batman_adv]
[  348.530014]  [<f91bfdc4>] batadv_send_unicast_skb+0x15/0x4a [batman_adv]
[  348.530014]  [<f91b5938>] batadv_dat_send_data+0x27e/0x310 [batman_adv]
[  348.530014]  [<f91c30b5>] ? batadv_tt_global_hash_find.isra.11+0x8/0xa [batman_adv]
[  348.530014]  [<f91b63f3>] batadv_dat_snoop_outgoing_arp_request+0x208/0x23d [batman_adv]
[  348.530014]  [<f91c0cd9>] batadv_interface_tx+0x206/0x385 [batman_adv]
[  348.530014]  [<c04c769c>] dev_hard_start_xmit+0x1f8/0x267
[  348.530014]  [<c04c7261>] ?  validate_xmit_skb.isra.120.part.121+0x10/0x253
[  348.530014]  [<c04defc6>] sch_direct_xmit+0x8b/0x1b3
[  348.530014]  [<c04c7a9c>] __dev_queue_xmit+0x2c8/0x513
[  348.530014]  [<f80cbd2a>] ? igb_xmit_frame+0x57/0x72 [igb]
[  348.530014]  [<c04c7cfb>] dev_queue_xmit+0xa/0xc
[  348.530014]  [<f843a326>] br_dev_queue_push_xmit+0xeb/0xfb [bridge]
[  348.530014]  [<f843a35f>] br_forward_finish+0x29/0x74 [bridge]
[  348.530014]  [<f843a23b>] ? deliver_clone+0x3b/0x3b [bridge]
[  348.530014]  [<f843a714>] __br_forward+0x89/0xe7 [bridge]
[  348.530014]  [<f843a336>] ? br_dev_queue_push_xmit+0xfb/0xfb [bridge]
[  348.530014]  [<f843a234>] deliver_clone+0x34/0x3b [bridge]
[  348.530014]  [<f843a68b>] ? br_flood+0x95/0x95 [bridge]
[  348.530014]  [<f843a66d>] br_flood+0x77/0x95 [bridge]
[  348.530014]  [<f843a809>] br_flood_forward+0x13/0x1a [bridge]
[  348.530014]  [<f843a68b>] ? br_flood+0x95/0x95 [bridge]
[  348.530014]  [<f843b877>] br_handle_frame_finish+0x392/0x3db [bridge]
[  348.530014]  [<c04e9b2b>] ? nf_iterate+0x2b/0x6b
[  348.530014]  [<f843baa6>] br_handle_frame+0x1e6/0x240 [bridge]
[  348.530014]  [<f843b4e5>] ? br_handle_local_finish+0x6a/0x6a [bridge]
[  348.530014]  [<c04c4ba0>] __netif_receive_skb_core+0x43a/0x66b
[  348.530014]  [<f843b8c0>] ? br_handle_frame_finish+0x3db/0x3db [bridge]
[  348.530014]  [<c023cea4>] ? resched_curr+0x19/0x37
[  348.530014]  [<c0240707>] ? check_preempt_wakeup+0xbf/0xfe
[  348.530014]  [<c0255dec>] ? ktime_get_with_offset+0x5c/0xfc
[  348.530014]  [<c04c4fc1>] __netif_receive_skb+0x47/0x55
[  348.530014]  [<c04c57ba>] netif_receive_skb_internal+0x40/0x5a
[  348.530014]  [<c04c61ef>] napi_gro_receive+0x3a/0x94
[  348.530014]  [<f80ce8d5>] igb_poll+0x6fd/0x9ad [igb]
[  348.530014]  [<c0242bd8>] ? swake_up_locked+0x14/0x26
[  348.530014]  [<c04c5d29>] net_rx_action+0xde/0x250
[  348.530014]  [<c022a743>] __do_softirq+0x8a/0x163
[  348.530014]  [<c022a6b9>] ? __hrtimer_tasklet_trampoline+0x19/0x19
[  348.530014]  [<c021100f>] do_softirq_own_stack+0x26/0x2c
[  348.530014]  <IRQ>
[  348.530014]  [<c022a957>] irq_exit+0x31/0x6f
[  348.530014]  [<c0210eb2>] do_IRQ+0x8d/0xa0
[  348.530014]  [<c058152c>] common_interrupt+0x2c/0x40
[  348.530014] Code: e7 8c 00 66 81 ff 88 00 75 12 85 d2 75 0e b2 c3 b8 83 e9 29 f9 e8 a7 5f f9 c6 eb 74 66 81 e3 8c 005
[  348.530014] EIP: [<f929245d>] ieee80211_mps_set_frame_flags+0x40/0xaa [mac80211] SS:ESP 0068:f6409a40
[  348.530014] CR2: 0000000000020040
[  348.530014] ---[ end trace 48556ac26779732e ]---
[  348.530014] Kernel panic - not syncing: Fatal exception in interrupt
[  348.530014] Kernel Offset: disabled

Cc: stable@vger.kernel.org
Reported-by: Fred Veldini <fred.veldini@gmail.com>
Tested-by: Fred Veldini <fred.veldini@gmail.com>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
>From git history, this appears to go back to earliest commits adding
authsae support.  I reproduced in a 4.4 kernel, which predates all of
the mesh pathtable rework, though it is harder to hit there than in
the current code.

This is slightly different from the version Fred tested (CCed) --
the version I sent him didn't have the BLOCK_MPATH part, but that
seems necessary to me to prevent re-adding in hwmp_route_info_get().
But I can reproduce the above crash and this patch fixes it for
me.
---
 net/mac80211/mesh_pathtbl.c |  4 ++++
 net/mac80211/sta_info.c     | 10 ++++++++++
 net/mac80211/sta_info.h     |  2 ++
 3 files changed, 16 insertions(+)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 6db2ddfa0695..798c522b6522 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -87,6 +87,10 @@ void mesh_path_assign_nexthop(struct mesh_path *mpath, struct sta_info *sta)
 	struct ieee80211_hdr *hdr;
 	unsigned long flags;
 
+	/* sta is being deleted, don't add back */
+	if (test_sta_flag(sta, WLAN_STA_BLOCK_MPATH))
+		return;
+
 	rcu_assign_pointer(mpath->next_hop, sta);
 
 	spin_lock_irqsave(&mpath->frame_queue.lock, flags);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 5ccfdbd406bd..f2a1bfa53c04 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -914,6 +914,16 @@ static int __must_check __sta_info_destroy_part1(struct sta_info *sta)
 	list_del_rcu(&sta->list);
 	sta->removed = true;
 
+	/*
+	 * Remove all path table references to the station (and prevent
+	 * adding new ones) so that new mesh transmissions won't use it
+	 * as a next hop.
+	 */
+	if (ieee80211_vif_is_mesh(&sdata->vif)) {
+		set_sta_flag(sta, WLAN_STA_BLOCK_MPATH);
+		mesh_path_flush_by_nexthop(sta);
+	}
+
 	drv_sta_pre_rcu_remove(local, sta->sdata, sta);
 
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index c8b8ccc370eb..65ecd3746c3b 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -70,6 +70,7 @@
  * @WLAN_STA_MPSP_RECIPIENT: local STA is recipient of a MPSP.
  * @WLAN_STA_PS_DELIVER: station woke up, but we're still blocking TX
  *	until pending frames are delivered
+ * @WLAN_STA_BLOCK_MPATH: block adding this station as a mesh path
  *
  * @NUM_WLAN_STA_FLAGS: number of defined flags
  */
@@ -100,6 +101,7 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_MPSP_OWNER,
 	WLAN_STA_MPSP_RECIPIENT,
 	WLAN_STA_PS_DELIVER,
+	WLAN_STA_BLOCK_MPATH,
 
 	NUM_WLAN_STA_FLAGS,
 };
-- 
2.6.1

