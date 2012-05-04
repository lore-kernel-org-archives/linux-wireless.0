Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16456 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757115Ab2EDNnS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2012 09:43:18 -0400
Date: Fri, 04 May 2012 08:43:12 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Fix 'suspicious RCU usage' warning
Message-ID: <4fa3dcf0.+lkNsTVufgE2rrvO%Larry.Finger@lwfinger.net> (sfid-20120504_154322_935998_9EBD215E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

When running kernel 3.4-rc2 from wireless testing, the following is logged:

 [ INFO: suspicious RCU usage. ]
 3.4.0-rc2-wl+ #222 Not tainted
 -------------------------------
 net/mac80211/sta_info.h:449 suspicious rcu_dereference_protected() usage!

 other info that might help us debug this:


 rcu_scheduler_active = 1, debug_locks = 0
 1 lock held by swapper/1/0:
  #0:  (&tid_tx->session_timer){+.-...}, at: [<ffffffff8104850a>] run_timer_softirq+0xfa/0x6e0

 stack backtrace:
 Pid: 0, comm: swapper/1 Not tainted 3.4.0-rc2-wl+ #222
 Call Trace:
  <IRQ>  [<ffffffff81092fdd>] lockdep_rcu_suspicious+0xfd/0x130
  [<ffffffffa05db673>] sta_tx_agg_session_timer_expired+0xe3/0x100 [mac80211]
  [<ffffffff81048595>] run_timer_softirq+0x185/0x6e0
  [<ffffffff8104850a>] ? run_timer_softirq+0xfa/0x6e0
  [<ffffffffa05db590>] ? ieee80211_stop_tx_ba_session+0x240/0x240 [mac80211]
  [<ffffffff81040156>] __do_softirq+0xc6/0x3f0
  [<ffffffff8139c934>] ? _raw_spin_lock+0x44/0x50
  [<ffffffff8139d0f6>] ? _raw_spin_unlock+0x26/0x40
  [<ffffffff8139f24c>] call_softirq+0x1c/0x30
  [<ffffffff81004785>] do_softirq+0x85/0xc0
  [<ffffffff810407b6>] irq_exit+0xa6/0xe0
  [<ffffffff8100424e>] do_IRQ+0x5e/0xd0
  [<ffffffff8139d56c>] common_interrupt+0x6c/0x6c
  <EOI>  [<ffffffff8100c042>] ? default_idle+0x62/0x4f0
  [<ffffffff8100c040>] ? default_idle+0x60/0x4f0
  [<ffffffff8100c524>] amd_e400_idle+0x54/0x100
  [<ffffffff8100ce96>] cpu_idle+0x96/0xe0
  [<ffffffff8138fbc6>] start_secondary+0x1b7/0x1bb

Reported-and-tested-by:: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This patch affects 3.4.

Larry
---

Index: wireless-testing-new/net/mac80211/agg-tx.c
===================================================================
--- wireless-testing-new.orig/net/mac80211/agg-tx.c
+++ wireless-testing-new/net/mac80211/agg-tx.c
@@ -421,16 +421,22 @@ static void sta_tx_agg_session_timer_exp
 	struct tid_ampdu_tx *tid_tx;
 	unsigned long timeout;
 
-	tid_tx = rcu_dereference_protected_tid_tx(sta, *ptid);
-	if (!tid_tx)
+	rcu_read_lock();
+	tid_tx = rcu_dereference(sta->ampdu_mlme.tid_tx[*ptid]);
+	if (!tid_tx) {
+		rcu_read_unlock();
 		return;
+	}
 
 	timeout = tid_tx->last_tx + TU_TO_JIFFIES(tid_tx->timeout);
 	if (time_is_after_jiffies(timeout)) {
 		mod_timer(&tid_tx->session_timer, timeout);
+		rcu_read_unlock();
 		return;
 	}
 
+	rcu_read_unlock();
+
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "tx session timer expired on tid %d\n", (u16)*ptid);
 #endif
