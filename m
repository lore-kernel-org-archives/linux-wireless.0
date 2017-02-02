Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53183 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750858AbdBBJOy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Feb 2017 04:14:54 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH v2 1/3] ath9k: rename tx_complete_work to hw_check_work
Date: Thu,  2 Feb 2017 10:14:50 +0100
Message-Id: <20170202091452.11939-1-nbd@nbd.name> (sfid-20170202_101502_786761_4F51CF6A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also include common MAC alive check. This should make the hang checks
more reliable for modes where beacons are not sent and is used as a
starting point for further hang check improvements

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  6 ++---
 drivers/net/wireless/ath/ath9k/init.c  |  1 +
 drivers/net/wireless/ath/ath9k/link.c  | 46 ++++++++++++++++++----------------
 drivers/net/wireless/ath/ath9k/main.c  | 10 +++++---
 drivers/net/wireless/ath/ath9k/xmit.c  |  2 --
 5 files changed, 35 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 331947b6a667..b2fa44adc60e 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -108,7 +108,7 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 #define ATH_AGGR_MIN_QDEPTH        2
 /* minimum h/w qdepth for non-aggregated traffic */
 #define ATH_NON_AGGR_MIN_QDEPTH    8
-#define ATH_TX_COMPLETE_POLL_INT   1000
+#define ATH_HW_CHECK_POLL_INT      1000
 #define ATH_TXFIFO_DEPTH           8
 #define ATH_TX_ERROR               0x01
 
@@ -745,7 +745,7 @@ void ath9k_csa_update(struct ath_softc *sc);
 #define ATH_PAPRD_TIMEOUT         100 /* msecs */
 #define ATH_PLL_WORK_INTERVAL     100
 
-void ath_tx_complete_poll_work(struct work_struct *work);
+void ath_hw_check_work(struct work_struct *work);
 void ath_reset_work(struct work_struct *work);
 bool ath_hw_check(struct ath_softc *sc);
 void ath_hw_pll_work(struct work_struct *work);
@@ -1053,7 +1053,7 @@ struct ath_softc {
 #ifdef CONFIG_ATH9K_DEBUGFS
 	struct ath9k_debug debug;
 #endif
-	struct delayed_work tx_complete_work;
+	struct delayed_work hw_check_work;
 	struct delayed_work hw_pll_work;
 	struct timer_list sleep_timer;
 
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 084ad1bd495f..a2f7f48bbb92 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -681,6 +681,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	INIT_WORK(&sc->hw_reset_work, ath_reset_work);
 	INIT_WORK(&sc->paprd_work, ath_paprd_calibrate);
 	INIT_DELAYED_WORK(&sc->hw_pll_work, ath_hw_pll_work);
+	INIT_DELAYED_WORK(&sc->hw_check_work, ath_hw_check_work);
 
 	ath9k_init_channel_context(sc);
 
diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index 5ad0feeebc86..27c50562dc47 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -20,20 +20,13 @@
  * TX polling - checks if the TX engine is stuck somewhere
  * and issues a chip reset if so.
  */
-void ath_tx_complete_poll_work(struct work_struct *work)
+static bool ath_tx_complete_check(struct ath_softc *sc)
 {
-	struct ath_softc *sc = container_of(work, struct ath_softc,
-					    tx_complete_work.work);
 	struct ath_txq *txq;
 	int i;
-	bool needreset = false;
-
 
-	if (sc->tx99_state) {
-		ath_dbg(ath9k_hw_common(sc->sc_ah), RESET,
-			"skip tx hung detection on tx99\n");
-		return;
-	}
+	if (sc->tx99_state)
+		return true;
 
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
 		txq = sc->tx.txq_map[i];
@@ -41,25 +34,36 @@ void ath_tx_complete_poll_work(struct work_struct *work)
 		ath_txq_lock(sc, txq);
 		if (txq->axq_depth) {
 			if (txq->axq_tx_inprogress) {
-				needreset = true;
 				ath_txq_unlock(sc, txq);
-				break;
-			} else {
-				txq->axq_tx_inprogress = true;
+				goto reset;
 			}
+
+			txq->axq_tx_inprogress = true;
 		}
 		ath_txq_unlock(sc, txq);
 	}
 
-	if (needreset) {
-		ath_dbg(ath9k_hw_common(sc->sc_ah), RESET,
-			"tx hung, resetting the chip\n");
-		ath9k_queue_reset(sc, RESET_TYPE_TX_HANG);
+	return true;
+
+reset:
+	ath_dbg(ath9k_hw_common(sc->sc_ah), RESET,
+		"tx hung, resetting the chip\n");
+	ath9k_queue_reset(sc, RESET_TYPE_TX_HANG);
+	return false;
+
+}
+
+void ath_hw_check_work(struct work_struct *work)
+{
+	struct ath_softc *sc = container_of(work, struct ath_softc,
+					    hw_check_work.work);
+
+	if (!ath_hw_check(sc) ||
+	    !ath_tx_complete_check(sc))
 		return;
-	}
 
-	ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work,
-				     msecs_to_jiffies(ATH_TX_COMPLETE_POLL_INT));
+	ieee80211_queue_delayed_work(sc->hw, &sc->hw_check_work,
+				     msecs_to_jiffies(ATH_HW_CHECK_POLL_INT));
 }
 
 /*
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 58f06ce9a4cf..0345d6ec564f 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -181,7 +181,7 @@ void ath9k_ps_restore(struct ath_softc *sc)
 static void __ath_cancel_work(struct ath_softc *sc)
 {
 	cancel_work_sync(&sc->paprd_work);
-	cancel_delayed_work_sync(&sc->tx_complete_work);
+	cancel_delayed_work_sync(&sc->hw_check_work);
 	cancel_delayed_work_sync(&sc->hw_pll_work);
 
 #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
@@ -198,7 +198,8 @@ void ath_cancel_work(struct ath_softc *sc)
 
 void ath_restart_work(struct ath_softc *sc)
 {
-	ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work, 0);
+	ieee80211_queue_delayed_work(sc->hw, &sc->hw_check_work,
+				     ATH_HW_CHECK_POLL_INT);
 
 	if (AR_SREV_9340(sc->sc_ah) || AR_SREV_9330(sc->sc_ah))
 		ieee80211_queue_delayed_work(sc->hw, &sc->hw_pll_work,
@@ -2091,7 +2092,7 @@ void __ath9k_flush(struct ieee80211_hw *hw, u32 queues, bool drop,
 	int timeout;
 	bool drain_txq;
 
-	cancel_delayed_work_sync(&sc->tx_complete_work);
+	cancel_delayed_work_sync(&sc->hw_check_work);
 
 	if (ah->ah_flags & AH_UNPLUGGED) {
 		ath_dbg(common, ANY, "Device has been unplugged!\n");
@@ -2129,7 +2130,8 @@ void __ath9k_flush(struct ieee80211_hw *hw, u32 queues, bool drop,
 		ath9k_ps_restore(sc);
 	}
 
-	ieee80211_queue_delayed_work(hw, &sc->tx_complete_work, 0);
+	ieee80211_queue_delayed_work(hw, &sc->hw_check_work,
+				     ATH_HW_CHECK_POLL_INT);
 }
 
 static bool ath9k_tx_frames_pending(struct ieee80211_hw *hw)
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index c35a192861ab..11073cf87909 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2872,8 +2872,6 @@ int ath_tx_init(struct ath_softc *sc, int nbufs)
 		return error;
 	}
 
-	INIT_DELAYED_WORK(&sc->tx_complete_work, ath_tx_complete_poll_work);
-
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
 		error = ath_tx_edma_init(sc);
 
-- 
2.11.0
