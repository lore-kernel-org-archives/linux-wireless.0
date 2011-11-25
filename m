Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754016Ab1KYLGi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Nov 2011 06:06:38 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Stanislaw Gruszka <sgruszka@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] rtlwifi: fix lps_lock deadlock
Date: Fri, 25 Nov 2011 12:08:47 +0100
Message-Id: <1322219327-23148-1-git-send-email-sgruszka@redhat.com> (sfid-20111125_120643_295278_C5278266)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rtl_lps_leave can be called from interrupt context, so we have to
disable interrups when taking lps_lock.

Below is full lockdep info about deadlock:

[   93.815269] =================================
[   93.815390] [ INFO: inconsistent lock state ]
[   93.815472] 2.6.41.1-3.offch.fc15.x86_64.debug #1
[   93.815556] ---------------------------------
[   93.815635] inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
[   93.815743] swapper/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
[   93.815832]  (&(&rtlpriv->locks.lps_lock)->rlock){+.?...}, at: [<ffffffffa025dad6>] rtl_lps_leave+0x26/0x103 [rtlwifi]
[   93.815947] {SOFTIRQ-ON-W} state was registered at:
[   93.815947]   [<ffffffff8108e10d>] __lock_acquire+0x369/0xd0c
[   93.815947]   [<ffffffff8108efb3>] lock_acquire+0xf3/0x13e
[   93.815947]   [<ffffffff814e981d>] _raw_spin_lock+0x45/0x79
[   93.815947]   [<ffffffffa025de34>] rtl_swlps_rf_awake+0x5a/0x76 [rtlwifi]
[   93.815947]   [<ffffffffa025aec0>] rtl_op_config+0x12a/0x32a [rtlwifi]
[   93.815947]   [<ffffffffa01d614b>] ieee80211_hw_config+0x124/0x129 [mac80211]
[   93.815947]   [<ffffffffa01e0af3>] ieee80211_dynamic_ps_disable_work+0x32/0x47 [mac80211]
[   93.815947]   [<ffffffff81075aa5>] process_one_work+0x205/0x3e7
[   93.815947]   [<ffffffff81076753>] worker_thread+0xda/0x15d
[   93.815947]   [<ffffffff8107a119>] kthread+0xa8/0xb0
[   93.815947]   [<ffffffff814f3184>] kernel_thread_helper+0x4/0x10
[   93.815947] irq event stamp: 547822
[   93.815947] hardirqs last  enabled at (547822): [<ffffffff814ea1a7>] _raw_spin_unlock_irqrestore+0x45/0x61
[   93.815947] hardirqs last disabled at (547821): [<ffffffff814e9987>] _raw_spin_lock_irqsave+0x22/0x8e
[   93.815947] softirqs last  enabled at (547790): [<ffffffff810623ed>] _local_bh_enable+0x13/0x15
[   93.815947] softirqs last disabled at (547791): [<ffffffff814f327c>] call_softirq+0x1c/0x30
[   93.815947]
[   93.815947] other info that might help us debug this:
[   93.815947]  Possible unsafe locking scenario:
[   93.815947]
[   93.815947]        CPU0
[   93.815947]        ----
[   93.815947]   lock(&(&rtlpriv->locks.lps_lock)->rlock);
[   93.815947]   <Interrupt>
[   93.815947]     lock(&(&rtlpriv->locks.lps_lock)->rlock);
[   93.815947]
[   93.815947]  *** DEADLOCK ***
[   93.815947]
[   93.815947] no locks held by swapper/0.
[   93.815947]
[   93.815947] stack backtrace:
[   93.815947] Pid: 0, comm: swapper Not tainted 2.6.41.1-3.offch.fc15.x86_64.debug #1
[   93.815947] Call Trace:
[   93.815947]  <IRQ>  [<ffffffff814dfd00>] print_usage_bug+0x1e7/0x1f8
[   93.815947]  [<ffffffff8101a849>] ? save_stack_trace+0x2c/0x49
[   93.815947]  [<ffffffff8108d55c>] ? print_irq_inversion_bug.part.18+0x1a0/0x1a0
[   93.815947]  [<ffffffff8108dc8a>] mark_lock+0x106/0x220
[   93.815947]  [<ffffffff8108e099>] __lock_acquire+0x2f5/0xd0c
[   93.815947]  [<ffffffff810152af>] ? native_sched_clock+0x34/0x36
[   93.830125]  [<ffffffff810152ba>] ? sched_clock+0x9/0xd
[   93.830125]  [<ffffffff81080181>] ? sched_clock_local+0x12/0x75
[   93.830125]  [<ffffffffa025dad6>] ? rtl_lps_leave+0x26/0x103 [rtlwifi]
[   93.830125]  [<ffffffff8108efb3>] lock_acquire+0xf3/0x13e
[   93.830125]  [<ffffffffa025dad6>] ? rtl_lps_leave+0x26/0x103 [rtlwifi]
[   93.830125]  [<ffffffff814e981d>] _raw_spin_lock+0x45/0x79
[   93.830125]  [<ffffffffa025dad6>] ? rtl_lps_leave+0x26/0x103 [rtlwifi]
[   93.830125]  [<ffffffff81422467>] ? skb_dequeue+0x62/0x6d
[   93.830125]  [<ffffffffa025dad6>] rtl_lps_leave+0x26/0x103 [rtlwifi]
[   93.830125]  [<ffffffffa025f677>] _rtl_pci_ips_leave_tasklet+0xe/0x10 [rtlwifi]
[   93.830125]  [<ffffffff8106281f>] tasklet_action+0x8d/0xee
[   93.830125]  [<ffffffff810629ce>] __do_softirq+0x112/0x25a
[   93.830125]  [<ffffffff814f327c>] call_softirq+0x1c/0x30
[   93.830125]  [<ffffffff81010bf6>] do_softirq+0x4b/0xa1
[   93.830125]  [<ffffffff81062d7d>] irq_exit+0x5d/0xcf
[   93.830125]  [<ffffffff814f3b7e>] do_IRQ+0x8e/0xa5
[   93.830125]  [<ffffffff814ea533>] common_interrupt+0x73/0x73
[   93.830125]  <EOI>  [<ffffffff8108b825>] ? trace_hardirqs_off+0xd/0xf
[   93.830125]  [<ffffffff812bb6d5>] ? intel_idle+0xe5/0x10c
[   93.830125]  [<ffffffff812bb6d1>] ? intel_idle+0xe1/0x10c
[   93.830125]  [<ffffffff813f8d5e>] cpuidle_idle_call+0x11c/0x1fe
[   93.830125]  [<ffffffff8100e2ef>] cpu_idle+0xab/0x101
[   93.830125]  [<ffffffff814c6373>] rest_init+0xd7/0xde
[   93.830125]  [<ffffffff814c629c>] ? csum_partial_copy_generic+0x16c/0x16c
[   93.830125]  [<ffffffff81d4bbb0>] start_kernel+0x3dd/0x3ea
[   93.830125]  [<ffffffff81d4b2c4>] x86_64_start_reservations+0xaf/0xb3
[   93.830125]  [<ffffffff81d4b140>] ? early_idt_handlers+0x140/0x140
[   93.830125]  [<ffffffff81d4b3ca>] x86_64_start_kernel+0x102/0x111

Reported-and-tested-by: Oliver Paukstadt <pstadt@sourcentral.org>
Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rtlwifi/ps.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/ps.c b/drivers/net/wireless/rtlwifi/ps.c
index db52628..55c8e50 100644
--- a/drivers/net/wireless/rtlwifi/ps.c
+++ b/drivers/net/wireless/rtlwifi/ps.c
@@ -395,7 +395,7 @@ void rtl_lps_enter(struct ieee80211_hw *hw)
 	if (mac->link_state != MAC80211_LINKED)
 		return;
 
-	spin_lock(&rtlpriv->locks.lps_lock);
+	spin_lock_irq(&rtlpriv->locks.lps_lock);
 
 	/* Idle for a while if we connect to AP a while ago. */
 	if (mac->cnt_after_linked >= 2) {
@@ -407,7 +407,7 @@ void rtl_lps_enter(struct ieee80211_hw *hw)
 		}
 	}
 
-	spin_unlock(&rtlpriv->locks.lps_lock);
+	spin_unlock_irq(&rtlpriv->locks.lps_lock);
 }
 
 /*Leave the leisure power save mode.*/
@@ -416,8 +416,9 @@ void rtl_lps_leave(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	unsigned long flags;
 
-	spin_lock(&rtlpriv->locks.lps_lock);
+	spin_lock_irqsave(&rtlpriv->locks.lps_lock, flags);
 
 	if (ppsc->fwctrl_lps) {
 		if (ppsc->dot11_psmode != EACTIVE) {
@@ -438,7 +439,7 @@ void rtl_lps_leave(struct ieee80211_hw *hw)
 			rtl_lps_set_psmode(hw, EACTIVE);
 		}
 	}
-	spin_unlock(&rtlpriv->locks.lps_lock);
+	spin_unlock_irqrestore(&rtlpriv->locks.lps_lock, flags);
 }
 
 /* For sw LPS*/
@@ -539,9 +540,9 @@ void rtl_swlps_rf_awake(struct ieee80211_hw *hw)
 		RT_CLEAR_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM);
 	}
 
-	spin_lock(&rtlpriv->locks.lps_lock);
+	spin_lock_irq(&rtlpriv->locks.lps_lock);
 	rtl_ps_set_rf_state(hw, ERFON, RF_CHANGE_BY_PS);
-	spin_unlock(&rtlpriv->locks.lps_lock);
+	spin_unlock_irq(&rtlpriv->locks.lps_lock);
 }
 
 void rtl_swlps_rfon_wq_callback(void *data)
@@ -574,9 +575,9 @@ void rtl_swlps_rf_sleep(struct ieee80211_hw *hw)
 	if (rtlpriv->link_info.busytraffic)
 		return;
 
-	spin_lock(&rtlpriv->locks.lps_lock);
+	spin_lock_irq(&rtlpriv->locks.lps_lock);
 	rtl_ps_set_rf_state(hw, ERFSLEEP, RF_CHANGE_BY_PS);
-	spin_unlock(&rtlpriv->locks.lps_lock);
+	spin_unlock_irq(&rtlpriv->locks.lps_lock);
 
 	if (ppsc->reg_rfps_level & RT_RF_OFF_LEVL_ASPM &&
 		!RT_IN_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM)) {
-- 
1.7.1

