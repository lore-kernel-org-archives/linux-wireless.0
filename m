Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1390 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294Ab0LZRkl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Dec 2010 12:40:41 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com, br1@einfach.org
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH] ath5k: fix cycle counter inconsistent locking
Date: Sun, 26 Dec 2010 12:10:05 -0500
Message-Id: <1293383405-25844-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath5k_reset is called from process context and takes the cc_lock
with plain spin_lock(), but cc_lock can also be taken from tasklets
in softirq context.  Thus we need to at least use spin_lock_bh.

This fixes the following lockdep warning:

[   19.967874] sky2 0000:01:00.0: eth0: enabling interface
[   19.982761] ieee80211 phy0: device now idle
[   20.904809] NET: Registered protocol family 17
[   21.243857] ieee80211 phy0: device no longer idle - scanning
[   21.404343]
[   21.404346] =================================
[   21.404450] [ INFO: inconsistent lock state ]
[   21.404518] 2.6.37-rc7-wl+ #242
[   21.404582] ---------------------------------
[   21.404650] inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
[   21.404721] kworker/u:4/982 [HC0[0]:SC1[3]:HE1:SE0] takes:
[   21.404792]  (&(&common->cc_lock)->rlock){+.?...}, at: [<f8115780>] ath5k_ani_calibration+0x29/0x5d9 [ath5k]
[   21.405011] {SOFTIRQ-ON-W} state was registered at:
[   21.405011]   [<c105cadd>] __lock_acquire+0x62f/0x13c1
[   21.405011]   [<c105d944>] lock_acquire+0xd5/0xf1
[   21.405011]   [<c12c978d>] _raw_spin_lock+0x45/0x72
[   21.405011]   [<f8111533>] ath5k_reset+0x2c0/0x349 [ath5k]
[   21.405011]   [<f8111a7a>] ath5k_start+0xb8/0x139 [ath5k]
[   21.405011]   [<f849c714>] ieee80211_do_open+0x13f/0x819 [mac80211]
[   21.405011]   [<f849ce51>] ieee80211_open+0x63/0x66 [mac80211]
[   21.405011]   [<c1258b2e>] __dev_open+0x8d/0xb6
[   21.405011]   [<c1255c64>] __dev_change_flags+0x9d/0x114
[   21.405011]   [<c1258a75>] dev_change_flags+0x18/0x44
[   21.405011]   [<c1262990>] do_setlink+0x23f/0x521
[   21.405011]   [<c1262d58>] rtnl_setlink+0xe6/0xea
[   21.405011]   [<c126347c>] rtnetlink_rcv_msg+0x18a/0x1a0
[   21.405011]   [<c126d5f0>] netlink_rcv_skb+0x35/0x7b
[   21.405011]   [<c12632eb>] rtnetlink_rcv+0x20/0x27
[   21.405011]   [<c126d370>] netlink_unicast+0x1bb/0x21e
[   21.405011]   [<c126db21>] netlink_sendmsg+0x23b/0x288
[   21.405011]   [<c124823c>] sock_sendmsg+0xac/0xc4
[   21.405011]   [<c1248680>] sys_sendmsg+0x152/0x1a2
[   21.405011]   [<c1249b0d>] sys_socketcall+0x214/0x275
[   21.405011]   [<c10029d0>] sysenter_do_call+0x12/0x36
[   21.405011] irq event stamp: 138032
[   21.405011] hardirqs last  enabled at (138032): [<c12ca252>] _raw_spin_unlock_irqrestore+0x3b/0x5e
[   21.405011] hardirqs last disabled at (138031): [<c12c98cc>] _raw_spin_lock_irqsave+0x18/0x7e
[   21.405011] softirqs last  enabled at (138024): [<f84a570e>] ieee80211_tx_skb+0x47/0x49 [mac80211]
[   21.405011] softirqs last disabled at (138027): [<c100452b>] do_softirq+0x63/0xb4
[   21.405011]
[   21.405011] other info that might help us debug this:
[   21.405011] 3 locks held by kworker/u:4/982:
[   21.405011]  #0:  (name){+.+.+.}, at: [<c1046158>] process_one_work+0x1b8/0x41b
[   21.405011]  #1:  ((&(&local->scan_work)->work)){+.+.+.}, at: [<c1046158>] process_one_work+0x1b8/0x41b
[   21.405011]  #2:  (&local->mtx){+.+.+.}, at: [<f84920fb>] ieee80211_scan_work+0x32/0x4a4 [mac80211]
[   21.405011]
[   21.405011] stack backtrace:
[   21.405011] Pid: 982, comm: kworker/u:4 Not tainted 2.6.37-rc7-wl+ #242
[   21.405011] Call Trace:
[   21.405011]  [<c12c6e68>] ? printk+0x1d/0x25
[   21.405011]  [<c105a742>] print_usage_bug+0x181/0x18b
[   21.405011]  [<c105b196>] ? check_usage_forwards+0x0/0xb6
[   21.405011]  [<c105a9ec>] mark_lock+0x2a0/0x4aa
[   21.405011]  [<c1059f6d>] ? trace_hardirqs_off+0xb/0xd
[   21.405011]  [<c105ca68>] __lock_acquire+0x5ba/0x13c1
[   21.405011]  [<c1059eed>] ? trace_hardirqs_off_caller+0x18/0x8d
[   21.405011]  [<c1059f6d>] ? trace_hardirqs_off+0xb/0xd
[   21.405011]  [<c1050411>] ? local_clock+0x2c/0x4f
[   21.405011]  [<c1059e00>] ? save_trace+0x2/0xa0
[   21.405011]  [<c105ac39>] ? mark_held_locks+0x43/0x5b
[   21.405011]  [<c12ca252>] ? _raw_spin_unlock_irqrestore+0x3b/0x5e
[   21.405011]  [<f8115780>] ? ath5k_ani_calibration+0x29/0x5d9 [ath5k]
[   21.405011]  [<c105d944>] lock_acquire+0xd5/0xf1
[   21.405011]  [<f8115780>] ? ath5k_ani_calibration+0x29/0x5d9 [ath5k]
[   21.405011]  [<c12c9b1a>] _raw_spin_lock_bh+0x4a/0x77
[   21.405011]  [<f8115780>] ? ath5k_ani_calibration+0x29/0x5d9 [ath5k]
[   21.405011]  [<f8115780>] ath5k_ani_calibration+0x29/0x5d9 [ath5k]
[   21.405011]  [<c105ac39>] ? mark_held_locks+0x43/0x5b
[   21.405011]  [<f8113496>] ath5k_tasklet_ani+0x1d/0x27 [ath5k]
[   21.405011]  [<c1037304>] tasklet_action+0x96/0x137
[   21.405011]  [<c10379b5>] __do_softirq+0xde/0x1c3
[   21.405011]  [<c10b0cef>] ? arch_get_unmapped_area_topdown+0x3b/0x127
[   21.405011]  [<c10378d7>] ? __do_softirq+0x0/0x1c3
[   21.405011]  <IRQ>  [<c1036dee>] ? irq_exit+0x3d/0x49
[   21.405011]  [<c1003b4f>] ? do_IRQ+0x98/0xac
[   21.405011]  [<c1002eee>] ? common_interrupt+0x2e/0x34
[   21.405011]  [<c103007b>] ? sys_unshare+0x57/0x226
[   21.405011]  [<c1047fee>] ? queue_delayed_work+0x1/0x27
[   21.405011]  [<f84a83a0>] ? ieee80211_queue_delayed_work+0x2e/0x33 [mac80211]
[   21.405011]  [<f8492528>] ? ieee80211_scan_work+0x45f/0x4a4 [mac80211]
[   21.405011]  [<c104620e>] ? process_one_work+0x26e/0x41b
[   21.405011]  [<c1046158>] ? process_one_work+0x1b8/0x41b
[   21.405011]  [<f84920c9>] ? ieee80211_scan_work+0x0/0x4a4 [mac80211]
[   21.405011]  [<c10466b6>] ? worker_thread+0x18a/0x2a5
[   21.405011]  [<c12ca25e>] ? _raw_spin_unlock_irqrestore+0x47/0x5e
[   21.405011]  [<c104652c>] ? worker_thread+0x0/0x2a5
[   21.405011]  [<c104abe7>] ? kthread+0x67/0x6c
[   21.405011]  [<c104ab80>] ? kthread+0x0/0x6c
[   21.405011]  [<c1002efa>] ? kernel_thread_helper+0x6/0x10

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index e4ec40c..63ef7ff 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2703,11 +2703,11 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan,
 
 	/* clear survey data and cycle counters */
 	memset(&sc->survey, 0, sizeof(sc->survey));
-	spin_lock(&common->cc_lock);
+	spin_lock_bh(&common->cc_lock);
 	ath_hw_cycle_counters_update(common);
 	memset(&common->cc_survey, 0, sizeof(common->cc_survey));
 	memset(&common->cc_ani, 0, sizeof(common->cc_ani));
-	spin_unlock(&common->cc_lock);
+	spin_unlock_bh(&common->cc_lock);
 
 	/*
 	 * Change channels and update the h/w rate map if we're switching;
-- 
1.7.1.1


