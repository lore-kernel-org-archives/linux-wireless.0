Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f185.google.com ([209.85.216.185]:45804 "EHLO
	mail-px0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199AbZGOR7j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 13:59:39 -0400
Received: by pxi15 with SMTP id 15so1719836pxi.33
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2009 10:59:39 -0700 (PDT)
From: Andrey Yurovsky <andrey@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	Andrey Yurovsky <andrey@cozybit.com>
Subject: [PATCH] mac80211: don't sleep in mesh_path_add allocation
Date: Wed, 15 Jul 2009 11:02:16 -0700
Message-Id: <1247680936-21513-1-git-send-email-andrey@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mesh_path_add allocates an mpath and a node but it is called with RCU
held.  Use the GFP_ATOMIC flag to prevent these allocations from
sleeping since otherwise we can hit the following sleep-while-atomic:

[425889.502761] BUG: scheduling while atomic: ping/23249/0x10000100
[425889.503220] Modules linked in: ath5k mac80211 ath [last unloaded:
ath]
[425889.504563] Pid: 23249, comm: ping Not tainted 2.6.31-rc2-wl #13
[425889.505034] Call Trace:
[425889.505441]  [<c1026534>] __schedule_bug+0x48/0x4d
[425889.506056]  [<c13e9945>] schedule+0x8c/0x792
[425889.506659]  [<c10047b9>] ? handle_irq+0x3b/0x46
[425889.507138]  [<c1003f9b>] ? do_IRQ+0x80/0x96
[425889.507727]  [<c10030c9>] ? common_interrupt+0x29/0x30
[425889.508227]  [<c102c092>] ? vprintk+0x2a7/0x2ca
[425889.508809]  [<c1027f09>] __cond_resched+0x16/0x2c
[425889.509286]  [<c13ea139>] _cond_resched+0x24/0x2f
[425889.509881]  [<c109a164>] __kmalloc+0x87/0x110
[425889.510636]  [<c853d774>] ? kzalloc+0xb/0xd [mac80211]
[425889.511572]  [<c853d774>] kzalloc+0xb/0xd [mac80211]
[425889.512513]  [<c853e165>] mesh_path_add+0x289/0x29a [mac80211]
[425889.513498]  [<c853f285>] mesh_nexthop_lookup+0x3c/0x164 [mac80211]
[425889.514477]  [<c85365a4>] ieee80211_xmit+0xef/0x2ab [mac80211]
[425889.515438]  [<c853757d>] ieee80211_subif_start_xmit+0x69a/0x6b5
[mac80211]
[425889.516174]  [<c130ecb6>] dev_hard_start_xmit+0x20e/0x2a1
[425889.516841]  [<c10300fc>] ? local_bh_enable_ip+0x8/0xa
[425889.517340]  [<c131cb53>] __qdisc_run+0xbf/0x1a0
[425889.517897]  [<c130f08a>] dev_queue_xmit+0x25b/0x350
[425889.518364]  [<c13143fe>] neigh_resolve_output+0x1e7/0x231
[425889.519012]  [<c133a0d0>] ip_finish_output2+0x1a5/0x1cf
[425889.519677]  [<c133a159>] ip_finish_output+0x5f/0x62
[425889.520183]  [<c133a1e6>] ip_output+0x8a/0x8f
[425889.520804]  [<c13395ed>] ip_local_out+0x18/0x1b
[425889.521310]  [<c1339860>] ip_push_pending_frames+0x270/0x2ce
[425889.521956]  [<c135077f>] raw_sendmsg+0x5f0/0x671
[425889.522451]  [<c1357e4a>] inet_sendmsg+0x3b/0x48
[425889.523061]  [<c1301ee4>] __sock_sendmsg+0x45/0x4e
[425889.523686]  [<c130266d>] sock_sendmsg+0xb8/0xce
[425889.524182]  [<c103cb47>] ? autoremove_wake_function+0x0/0x33
[425889.525104]  [<c8535061>] ? __ieee80211_rx+0x4a7/0x4f6 [mac80211]
[425889.525941]  [<c858663f>] ? ath5k_rxbuf_setup+0x6d/0x8d [ath5k]
[425889.526749]  [<c857c46d>] ? ath5k_hw_setup_rx_desc+0x0/0x66 [ath5k]
[425889.527329]  [<c1176549>] ? copy_from_user+0x2a/0x111
[425889.528004]  [<c1309805>] ? verify_iovec+0x40/0x6f
[425889.528634]  [<c13027c2>] sys_sendmsg+0x13f/0x192
[425889.529139]  [<c1043d6a>] ? getnstimeofday+0x52/0xd2
[425889.529782]  [<c1040beb>] ? sched_clock_cpu+0x8d/0x2e9
[425889.530301]  [<c1021d53>] ? task_tick_fair+0x1d/0x9e
[425889.530922]  [<c1028372>] ? scheduler_tick+0xc8/0x1df
[425889.531412]  [<c103f29a>] ? hrtimer_run_pending+0x2d/0xa7
[425889.532017]  [<c103373d>] ? run_timer_softirq+0x32/0x190
[425889.532632]  [<c13037ff>] sys_socketcall+0x153/0x183
[425889.533103]  [<c1003f9b>] ? do_IRQ+0x80/0x96
[425889.533694]  [<c1002ab5>] syscall_call+0x7/0xb

Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
---
 net/mac80211/mesh_pathtbl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 1ede8cb..42237fd 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -204,11 +204,11 @@ int mesh_path_add(u8 *dst, struct ieee80211_sub_if_data *sdata)
 		return -ENOSPC;
 
 	err = -ENOMEM;
-	new_mpath = kzalloc(sizeof(struct mesh_path), GFP_KERNEL);
+	new_mpath = kzalloc(sizeof(struct mesh_path), GFP_ATOMIC);
 	if (!new_mpath)
 		goto err_path_alloc;
 
-	new_node = kmalloc(sizeof(struct mpath_node), GFP_KERNEL);
+	new_node = kmalloc(sizeof(struct mpath_node), GFP_ATOMIC);
 	if (!new_node)
 		goto err_node_alloc;
 
-- 
1.5.6.3

