Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37200 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab2GIGco (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 02:32:44 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH] ath9k: fix reset work check properly
Date: Mon, 9 Jul 2012 12:04:00 +0530
Message-ID: <1341815640-6299-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120709_083248_231932_76032EBE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Once the hw reset work is queued up and to bail out current
execution properly, use HW_RESET bit ops instead of work_pending.
As work_pending might return false when the queued work is in
execution. So it is not correct to use the work utility for
baining out.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |  1 +
 drivers/net/wireless/ath/ath9k/beacon.c |  4 ++--
 drivers/net/wireless/ath/ath9k/debug.h  |  2 ++
 drivers/net/wireless/ath/ath9k/link.c   | 13 ++++++-------
 drivers/net/wireless/ath/ath9k/main.c   | 14 ++++++++++----
 drivers/net/wireless/ath/ath9k/mci.c    |  2 +-
 drivers/net/wireless/ath/ath9k/xmit.c   | 13 ++++++-------
 7 files changed, 28 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 79840d6..f65fd3a 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -445,6 +445,7 @@ void ath_ani_calibrate(unsigned long data);
 void ath_start_ani(struct ath_common *common);
 int ath_update_survey_stats(struct ath_softc *sc);
 void ath_update_survey_nf(struct ath_softc *sc, int channel);
+void ath9k_queue_reset(struct ath_softc *sc, enum ath_reset_type type);
 
 /**********/
 /* BTCOEX */
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 40775da..567a655 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -362,7 +362,7 @@ void ath_beacon_tasklet(unsigned long data)
 	int slot;
 	u32 bfaddr, bc = 0;
 
-	if (work_pending(&sc->hw_reset_work)) {
+	if (test_bit(SC_OP_HW_RESET, &sc->sc_flags)) {
 		ath_dbg(common, RESET,
 			"reset work is pending, skip beaconing now\n");
 		return;
@@ -391,7 +391,7 @@ void ath_beacon_tasklet(unsigned long data)
 			ath_dbg(common, BSTUCK, "beacon is officially stuck\n");
 			sc->beacon.bmisscnt = 0;
 			set_bit(SC_OP_TSF_RESET, &sc->sc_flags);
-			ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
+			ath9k_queue_reset(sc, RESET_TYPE_BEACON_STUCK);
 		}
 
 		return;
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index d0f851c..2078ecc 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -217,6 +217,8 @@ enum ath_reset_type {
 	RESET_TYPE_TX_HANG,
 	RESET_TYPE_PLL_HANG,
 	RESET_TYPE_MAC_HANG,
+	RESET_TYPE_BEACON_STUCK,
+	RESET_TYPE_MCI,
 	__RESET_TYPE_MAX
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index 91650fe..7463069 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -50,8 +50,7 @@ void ath_tx_complete_poll_work(struct work_struct *work)
 	if (needreset) {
 		ath_dbg(ath9k_hw_common(sc->sc_ah), RESET,
 			"tx hung, resetting the chip\n");
-		RESET_STAT_INC(sc, RESET_TYPE_TX_HANG);
-		ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
+		ath9k_queue_reset(sc, RESET_TYPE_TX_HANG);
 		return;
 	}
 
@@ -69,6 +68,7 @@ void ath_hw_check(struct work_struct *work)
 	unsigned long flags;
 	int busy;
 	u8 is_alive, nbeacon = 1;
+	enum ath_reset_type type;
 
 	ath9k_ps_wakeup(sc);
 	is_alive = ath9k_hw_check_alive(sc->sc_ah);
@@ -78,7 +78,7 @@ void ath_hw_check(struct work_struct *work)
 	else if (!is_alive && AR_SREV_9300(sc->sc_ah)) {
 		ath_dbg(common, RESET,
 			"DCU stuck is detected. Schedule chip reset\n");
-		RESET_STAT_INC(sc, RESET_TYPE_MAC_HANG);
+		type = RESET_TYPE_MAC_HANG;
 		goto sched_reset;
 	}
 
@@ -90,7 +90,7 @@ void ath_hw_check(struct work_struct *work)
 		busy, sc->hw_busy_count + 1);
 	if (busy >= 99) {
 		if (++sc->hw_busy_count >= 3) {
-			RESET_STAT_INC(sc, RESET_TYPE_BB_HANG);
+			type = RESET_TYPE_BB_HANG;
 			goto sched_reset;
 		}
 	} else if (busy >= 0) {
@@ -102,7 +102,7 @@ void ath_hw_check(struct work_struct *work)
 	goto out;
 
 sched_reset:
-	ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
+	ath9k_queue_reset(sc, type);
 out:
 	ath9k_ps_restore(sc);
 }
@@ -119,8 +119,7 @@ static bool ath_hw_pll_rx_hang_check(struct ath_softc *sc, u32 pll_sqsum)
 		count++;
 		if (count == 3) {
 			ath_dbg(common, RESET, "PLL WAR, resetting the chip\n");
-			RESET_STAT_INC(sc, RESET_TYPE_PLL_HANG);
-			ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
+			ath9k_queue_reset(sc, RESET_TYPE_PLL_HANG);
 			count = 0;
 			return true;
 		}
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 248e5b2..e31be58 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -381,11 +381,8 @@ void ath9k_tasklet(unsigned long data)
 			type = RESET_TYPE_FATAL_INT;
 		else
 			type = RESET_TYPE_BB_WATCHDOG;
-
-		RESET_STAT_INC(sc, type);
 #endif
-		set_bit(SC_OP_HW_RESET, &sc->sc_flags);
-		ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
+		ath9k_queue_reset(sc, type);
 		goto out;
 	}
 
@@ -575,6 +572,15 @@ static int ath_reset(struct ath_softc *sc, bool retry_tx)
 	return r;
 }
 
+void ath9k_queue_reset(struct ath_softc *sc, enum ath_reset_type type)
+{
+#ifdef CONFIG_ATH9K_DEBUGFS
+	RESET_STAT_INC(sc, type);
+#endif
+	set_bit(SC_OP_HW_RESET, &sc->sc_flags);
+	ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
+}
+
 void ath_reset_work(struct work_struct *work)
 {
 	struct ath_softc *sc = container_of(work, struct ath_softc, hw_reset_work);
diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index 87acff7..fb536e7 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -202,7 +202,7 @@ static void ath_mci_cal_msg(struct ath_softc *sc, u8 opcode, u8 *rx_payload)
 	case MCI_GPM_BT_CAL_REQ:
 		if (mci_hw->bt_state == MCI_BT_AWAKE) {
 			ar9003_mci_state(ah, MCI_STATE_SET_BT_CAL_START);
-			ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
+			ath9k_queue_reset(sc, RESET_TYPE_MCI);
 		}
 		ath_dbg(common, MCI, "MCI State : %d\n", mci_hw->bt_state);
 		break;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index cafb4a0..20929e9 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -614,10 +614,8 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 
 	rcu_read_unlock();
 
-	if (needreset) {
-		RESET_STAT_INC(sc, RESET_TYPE_TX_ERROR);
-		ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
-	}
+	if (needreset)
+		ath9k_queue_reset(sc, RESET_TYPE_TX_ERROR);
 }
 
 static bool ath_lookup_legacy(struct ath_buf *bf)
@@ -1586,7 +1584,8 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 	struct ath_atx_ac *ac, *ac_tmp, *last_ac;
 	struct ath_atx_tid *tid, *last_tid;
 
-	if (work_pending(&sc->hw_reset_work) || list_empty(&txq->axq_acq) ||
+	if (test_bit(SC_OP_HW_RESET, &sc->sc_flags) ||
+	    list_empty(&txq->axq_acq) ||
 	    txq->axq_ampdu_depth >= ATH_AGGR_MIN_QDEPTH)
 		return;
 
@@ -2191,7 +2190,7 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 
 	ath_txq_lock(sc, txq);
 	for (;;) {
-		if (work_pending(&sc->hw_reset_work))
+		if (test_bit(SC_OP_HW_RESET, &sc->sc_flags))
 			break;
 
 		if (list_empty(&txq->axq_q)) {
@@ -2274,7 +2273,7 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
 	int status;
 
 	for (;;) {
-		if (work_pending(&sc->hw_reset_work))
+		if (test_bit(SC_OP_HW_RESET, &sc->sc_flags))
 			break;
 
 		status = ath9k_hw_txprocdesc(ah, NULL, (void *)&ts);
-- 
1.7.11.1

