Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:23932 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948Ab1FXMIQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2011 08:08:16 -0400
Received: from mail.atheros.com ([10.234.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jun 2011 05:07:40 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2] ath9k: Fix locking issue during tx completion
Date: Fri, 24 Jun 2011 17:38:13 +0530
Message-ID: <1308917293-7828-1-git-send-email-rmanoharan@atheros.com> (sfid-20110624_140820_062721_65111BFB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

The received tx status of aggregated frame without BlockAck may
cause deaf state in AR5416 cards. So the driver does a reset to
recover. When this happens, we release the pcu_lock before doing
a reset as ath_rest acquires pcu_lock. This is ugly and also not
atomic. Fixing this addresses the TX DMA failure also.

ath_tx_complete_aggr can be called from different paths which
takes different variants of spin_lock. This patch also addresses
the following warning.

WARNING: at kernel/timer.c:1011 del_timer_sync+0x4e/0x50()
Call Trace:
 <IRQ>  [<ffffffff8104be3a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8104be85>] warn_slowpath_null+0x15/0x20
 [<ffffffff8105915e>] del_timer_sync+0x4e/0x50
 [<ffffffffa03726be>] ath_reset+0x3e/0x210 [ath9k]
 [<ffffffff8135cdaf>] ? _raw_spin_unlock_bh+0x1f/0x30
 [<ffffffffa037760a>] ath_tx_complete_aggr.isra.26+0x54a/0xa40 [ath9k]

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
v2: spin_lock_bh replaced by spin_lock bh context
 drivers/net/wireless/ath/ath9k/beacon.c |    2 ++
 drivers/net/wireless/ath/ath9k/main.c   |   13 +++++++++----
 drivers/net/wireless/ath/ath9k/xmit.c   |    7 +++----
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 0b6e3b6..e19a230 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -385,7 +385,9 @@ void ath_beacon_tasklet(unsigned long data)
 			ath_dbg(common, ATH_DBG_BSTUCK,
 				"beacon is officially stuck\n");
 			sc->sc_flags |= SC_OP_TSF_RESET;
+			spin_lock(&sc->sc_pcu_lock);
 			ath_reset(sc, true);
+			spin_unlock(&sc->sc_pcu_lock);
 		}
 
 		return;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 5ae303b..9098aaa 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -617,8 +617,11 @@ void ath_hw_check(struct work_struct *work)
 	ath_dbg(common, ATH_DBG_RESET, "Possible baseband hang, "
 		"busy=%d (try %d)\n", busy, sc->hw_busy_count + 1);
 	if (busy >= 99) {
-		if (++sc->hw_busy_count >= 3)
+		if (++sc->hw_busy_count >= 3) {
+			spin_lock_bh(&sc->sc_pcu_lock);
 			ath_reset(sc, true);
+			spin_unlock_bh(&sc->sc_pcu_lock);
+		}
 	} else if (busy >= 0)
 		sc->hw_busy_count = 0;
 
@@ -637,7 +640,9 @@ static void ath_hw_pll_rx_hang_check(struct ath_softc *sc, u32 pll_sqsum)
 			/* Rx is hung for more than 500ms. Reset it */
 			ath_dbg(common, ATH_DBG_RESET,
 				"Possible RX hang, resetting");
+			spin_lock_bh(&sc->sc_pcu_lock);
 			ath_reset(sc, true);
+			spin_unlock_bh(&sc->sc_pcu_lock);
 			count = 0;
 		}
 	} else
@@ -674,7 +679,9 @@ void ath9k_tasklet(unsigned long data)
 
 	if ((status & ATH9K_INT_FATAL) ||
 	    (status & ATH9K_INT_BB_WATCHDOG)) {
+		spin_lock(&sc->sc_pcu_lock);
 		ath_reset(sc, true);
+		spin_unlock(&sc->sc_pcu_lock);
 		return;
 	}
 
@@ -980,7 +987,6 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 	del_timer_sync(&common->ani.timer);
 
 	ath9k_ps_wakeup(sc);
-	spin_lock_bh(&sc->sc_pcu_lock);
 
 	ieee80211_stop_queues(hw);
 
@@ -1023,7 +1029,6 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 	}
 
 	ieee80211_wake_queues(hw);
-	spin_unlock_bh(&sc->sc_pcu_lock);
 
 	/* Start ANI */
 	if (!common->disable_ani)
@@ -2326,9 +2331,9 @@ static void ath9k_flush(struct ieee80211_hw *hw, bool drop)
 	ath9k_ps_wakeup(sc);
 	spin_lock_bh(&sc->sc_pcu_lock);
 	drain_txq = ath_drain_all_txq(sc, false);
-	spin_unlock_bh(&sc->sc_pcu_lock);
 	if (!drain_txq)
 		ath_reset(sc, false);
+	spin_unlock_bh(&sc->sc_pcu_lock);
 	ath9k_ps_restore(sc);
 	ieee80211_wake_queues(hw);
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index ec012b4..a1fed6c 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -565,11 +565,8 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 
 	rcu_read_unlock();
 
-	if (needreset) {
-		spin_unlock_bh(&sc->sc_pcu_lock);
+	if (needreset)
 		ath_reset(sc, false);
-		spin_lock_bh(&sc->sc_pcu_lock);
-	}
 }
 
 static u32 ath_lookup_rate(struct ath_softc *sc, struct ath_buf *bf,
@@ -2169,7 +2166,9 @@ static void ath_tx_complete_poll_work(struct work_struct *work)
 	if (needreset) {
 		ath_dbg(ath9k_hw_common(sc->sc_ah), ATH_DBG_RESET,
 			"tx hung, resetting the chip\n");
+		spin_lock_bh(&sc->sc_pcu_lock);
 		ath_reset(sc, true);
+		spin_unlock_bh(&sc->sc_pcu_lock);
 	}
 
 	ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work,
-- 
1.7.5.2

