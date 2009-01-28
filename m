Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:59715 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428AbZA1G3V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 01:29:21 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2009 22:29:21 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18815.64105.277801.61931@gargle.gargle.HOWL> (sfid-20090128_072926_317075_48941A55)
Date: Wed, 28 Jan 2009 11:55:45 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH] ath9k: Fix lockdep warning
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the lockdep warning shown below, and also
initializes the starting sequence number when starting a TX
aggregation session.

 =============================================
 [ INFO: possible recursive locking detected ]
 2.6.29-rc2-wl #21
 ---------------------------------------------
 swapper/0 is trying to acquire lock:
  (_xmit_IEEE80211#2){-+..}, at: [<ffffffff80456d71>] __qdisc_run+0x221/0x290

 but task is already holding lock:
  (_xmit_IEEE80211#2){-+..}, at: [<ffffffff80456d71>] __qdisc_run+0x221/0x290

 other info that might help us debug this:
 7 locks held by swapper/0:
  #0:  (rcu_read_lock){..--}, at: [<ffffffff80442a63>] dev_queue_xmit+0x53/0x620
  #1:  (_xmit_ETHER#2){-+..}, at: [<ffffffff80456d71>] __qdisc_run+0x221/0x290
  #2:  (rcu_read_lock){..--}, at: [<ffffffff80442a63>] dev_queue_xmit+0x53/0x620
  #3:  (_xmit_IEEE80211#2){-+..}, at: [<ffffffff80456d71>] __qdisc_run+0x221/0x290
  #4:  (rcu_read_lock){..--}, at: [<ffffffffa0154919>] ieee80211_master_start_xmit+0x219/0x6c0 [mac80211]
  #5:  (rcu_read_lock){..--}, at: [<ffffffffa01427c6>] ieee80211_start_tx_ba_session+0x66/0x4e0 [mac80211]
  #6:  (rcu_read_lock){..--}, at: [<ffffffff80442a63>] dev_queue_xmit+0x53/0x620

 stack backtrace:
 Pid: 0, comm: swapper Not tainted 2.6.29-rc2-wl #21
 Call Trace:
  <IRQ>  [<ffffffff8026c329>] __lock_acquire+0x1be9/0x1c40
  [<ffffffff80442af1>] dev_queue_xmit+0xe1/0x620
  [<ffffffff8026a8cc>] __lock_acquire+0x18c/0x1c40
  [<ffffffff8026c3d5>] lock_acquire+0x55/0x70
  [<ffffffff80456d71>] __qdisc_run+0x221/0x290
  [<ffffffff804dbeb9>] _spin_lock+0x39/0x50
  [<ffffffff80456d71>] __qdisc_run+0x221/0x290
  [<ffffffff804dbd2f>] _spin_unlock+0x1f/0x50
  [<ffffffff80456d71>] __qdisc_run+0x221/0x290
  [<ffffffff80442d18>] dev_queue_xmit+0x308/0x620
  [<ffffffff80442a63>] dev_queue_xmit+0x53/0x620
  [<ffffffffa0142a63>] ieee80211_start_tx_ba_session+0x303/0x4e0 [mac80211]
  [<ffffffffa01427c6>] ieee80211_start_tx_ba_session+0x66/0x4e0 [mac80211]
  [<ffffffffa0149dae>] rate_control_get_rate+0xae/0xc0 [mac80211]
  [<ffffffffa01526b5>] invoke_tx_handlers+0x655/0x1000 [mac80211]
  [<ffffffff802699fd>] mark_held_locks+0x4d/0x90
  [<ffffffff804dbcf5>] _spin_unlock_irqrestore+0x65/0x80
  [<ffffffffa0151aaa>] __ieee80211_tx_prepare+0x16a/0x310 [mac80211]
  [<ffffffffa0151adc>] __ieee80211_tx_prepare+0x19c/0x310 [mac80211]
  [<ffffffff80439cc2>] pskb_expand_head+0x112/0x190
  [<ffffffffa0154986>] ieee80211_master_start_xmit+0x286/0x6c0 [mac80211]
  [<ffffffffa0154919>] ieee80211_master_start_xmit+0x219/0x6c0 [mac80211]
  [<ffffffff8026a8cc>] __lock_acquire+0x18c/0x1c40
  [<ffffffff80456d8e>] __qdisc_run+0x23e/0x290
  [<ffffffff80442d18>] dev_queue_xmit+0x308/0x620
  [<ffffffff80442a63>] dev_queue_xmit+0x53/0x620
  [<ffffffffa0154221>] ieee80211_subif_start_xmit+0x4a1/0x980 [mac80211]
  [<ffffffffa0153f18>] ieee80211_subif_start_xmit+0x198/0x980 [mac80211]
  [<ffffffff80456d8e>] __qdisc_run+0x23e/0x290
  [<ffffffff80442d18>] dev_queue_xmit+0x308/0x620
  [<ffffffff80442a63>] dev_queue_xmit+0x53/0x620
  [<ffffffffa028ecfd>] ip6_output+0x62d/0x1230 [ipv6]
  [<ffffffff8024ca00>] __mod_timer+0xb0/0xd0
  [<ffffffffa02ad25a>] mld_sendpack+0x3fa/0x4a0 [ipv6]
  [<ffffffffa02ace60>] mld_sendpack+0x0/0x4a0 [ipv6]
  [<ffffffffa02adf90>] mld_ifc_timer_expire+0x0/0x340 [ipv6]
  [<ffffffffa02ae219>] mld_ifc_timer_expire+0x289/0x340 [ipv6]
  [<ffffffffa02adf90>] mld_ifc_timer_expire+0x0/0x340 [ipv6]
  [<ffffffff8024c097>] run_timer_softirq+0x147/0x220
  [<ffffffff802473fb>] __do_softirq+0x9b/0x180
  [<ffffffff80265516>] tick_dev_program_event+0x36/0xb0
  [<ffffffff8020d77c>] call_softirq+0x1c/0x30
  [<ffffffff8020f2c5>] do_softirq+0x65/0xb0
  [<ffffffff80246ebd>] irq_exit+0x9d/0xc0
  [<ffffffff80221db6>] smp_apic_timer_interrupt+0x86/0xd0
  [<ffffffff8020d1b3>] apic_timer_interrupt+0x13/0x20

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/rc.c   |   30 ++++++++++++++----------------
 drivers/net/wireless/ath9k/xmit.c |    1 +
 2 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index eb557ad..61c86c4 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -1479,6 +1479,20 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
 			 (is_underrun) ? ATH_11N_TXMAXTRY :
 			 tx_info_priv->tx.ts_longretry);
 
+	/* Check if aggregation has to be enabled for this tid */
+	if (conf_is_ht(&sc->hw->conf)) {
+		if (ieee80211_is_data_qos(fc)) {
+			u8 *qc, tid;
+			struct ath_node *an;
+
+			qc = ieee80211_get_qos_ctl(hdr);
+			tid = qc[0] & 0xf;
+			an = (struct ath_node *)sta->drv_priv;
+
+			if(ath_tx_aggr_check(sc, an, tid))
+				ieee80211_start_tx_ba_session(sc->hw, hdr->addr1, tid);
+		}
+	}
 exit:
 	kfree(tx_info_priv);
 }
@@ -1490,7 +1504,6 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	struct sk_buff *skb = txrc->skb;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ath_softc *sc = priv;
-	struct ieee80211_hw *hw = sc->hw;
 	struct ath_rate_priv *ath_rc_priv = priv_sta;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	int is_probe = 0;
@@ -1508,21 +1521,6 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	/* Find tx rate for unicast frames */
 	ath_rc_ratefind(sc, ath_rc_priv, ATH_11N_TXMAXTRY, 4,
 			tx_info, &is_probe, false);
-
-	/* Check if aggregation has to be enabled for this tid */
-	if (conf_is_ht(&hw->conf)) {
-		if (ieee80211_is_data_qos(fc)) {
-			u8 *qc, tid;
-			struct ath_node *an;
-
-			qc = ieee80211_get_qos_ctl(hdr);
-			tid = qc[0] & 0xf;
-			an = (struct ath_node *)sta->drv_priv;
-
-			if(ath_tx_aggr_check(sc, an, tid))
-				ieee80211_start_tx_ba_session(hw, hdr->addr1, tid);
-		}
-	}
 }
 
 static void ath_rate_init(void *priv, struct ieee80211_supported_band *sband,
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 007ca91..d483f3c 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -677,6 +677,7 @@ int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
 		txtid = ATH_AN_2_TID(an, tid);
 		txtid->state |= AGGR_ADDBA_PROGRESS;
 		ath_tx_pause_tid(sc, txtid);
+		*ssn = txtid->seq_start;
 	}
 
 	return 0;
-- 
1.6.1

