Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45612 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab2GIJRG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 05:17:06 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20474.41283.134369.452325@gargle.gargle.HOWL> (sfid-20120709_111711_515893_7C247AE0)
Date: Mon, 9 Jul 2012 14:45:47 +0530
To: <linux-wireless@vger.kernel.org>
CC: <ath9k-devel@lists.ath9k.org>
Subject: [RFC/WIP 11/11] ath9k: Fix race in reset-work usage
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

Using work_pending() to defer certain operations when
a HW-reset work has been queued is racy since the check
would return false when the work item is actually in
execution. Use SC_OP_HW_RESET instead to fix this race.
Also, unify the reset debug statistics maintenance.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |  1 +
 drivers/net/wireless/ath/ath9k/beacon.c |  5 +++--
 drivers/net/wireless/ath/ath9k/debug.h  | 24 +++++++++++++-----------
 drivers/net/wireless/ath/ath9k/link.c   | 13 ++++++-------
 drivers/net/wireless/ath/ath9k/main.c   | 17 +++++++++++------
 drivers/net/wireless/ath/ath9k/mci.c    |  2 +-
 drivers/net/wireless/ath/ath9k/xmit.c   | 13 ++++++-------
 7 files changed, 41 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 7323c3f..ede5a02 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -449,6 +449,7 @@ void ath_stop_ani(struct ath_softc *sc);
 void ath_check_ani(struct ath_softc *sc);
 int ath_update_survey_stats(struct ath_softc *sc);
 void ath_update_survey_nf(struct ath_softc *sc, int channel);
+void ath9k_queue_reset(struct ath_softc *sc, enum ath_reset_type type);
 
 /**********/
 /* BTCOEX */
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 812efe5..aa09636 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -317,11 +317,12 @@ void ath9k_beacon_tasklet(unsigned long data)
 	bool edma = !!(ah->caps.hw_caps & ATH9K_HW_CAP_EDMA);
 	int slot;
 
-	if (work_pending(&sc->hw_reset_work)) {
+	if (test_bit(SC_OP_HW_RESET, &sc->sc_flags)) {
 		ath_dbg(common, RESET,
 			"reset work is pending, skip beaconing now\n");
 		return;
 	}
+
 	/*
 	 * Check if the previous beacon has gone out.  If
 	 * not don't try to post another, skip this period
@@ -345,7 +346,7 @@ void ath9k_beacon_tasklet(unsigned long data)
 		} else if (sc->beacon.bmisscnt >= BSTUCK_THRESH) {
 			ath_dbg(common, BSTUCK, "beacon is officially stuck\n");
 			sc->beacon.bmisscnt = 0;
-			ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
+			ath9k_queue_reset(sc, RESET_TYPE_BEACON_STUCK);
 		}
 
 		return;
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index d0f851c..8b9d080d 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -32,6 +32,19 @@ struct ath_buf;
 #define RESET_STAT_INC(sc, type) do { } while (0)
 #endif
 
+enum ath_reset_type {
+	RESET_TYPE_BB_HANG,
+	RESET_TYPE_BB_WATCHDOG,
+	RESET_TYPE_FATAL_INT,
+	RESET_TYPE_TX_ERROR,
+	RESET_TYPE_TX_HANG,
+	RESET_TYPE_PLL_HANG,
+	RESET_TYPE_MAC_HANG,
+	RESET_TYPE_BEACON_STUCK,
+	RESET_TYPE_MCI,
+	__RESET_TYPE_MAX
+};
+
 #ifdef CONFIG_ATH9K_DEBUGFS
 
 /**
@@ -209,17 +222,6 @@ struct ath_rx_stats {
 	u32 rx_frags;
 };
 
-enum ath_reset_type {
-	RESET_TYPE_BB_HANG,
-	RESET_TYPE_BB_WATCHDOG,
-	RESET_TYPE_FATAL_INT,
-	RESET_TYPE_TX_ERROR,
-	RESET_TYPE_TX_HANG,
-	RESET_TYPE_PLL_HANG,
-	RESET_TYPE_MAC_HANG,
-	__RESET_TYPE_MAX
-};
-
 struct ath_stats {
 	struct ath_interrupt_stats istats;
 	struct ath_tx_stats txstats[ATH9K_NUM_TX_QUEUES];
diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index 7af32b1..23ab7b0 100644
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
index 512d719..e7b3ded 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -360,6 +360,7 @@ void ath9k_tasklet(unsigned long data)
 	struct ath_softc *sc = (struct ath_softc *)data;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
+	enum ath_reset_type type;
 	unsigned long flags;
 	u32 status = sc->intrstatus;
 	u32 rxmask;
@@ -369,18 +370,13 @@ void ath9k_tasklet(unsigned long data)
 
 	if ((status & ATH9K_INT_FATAL) ||
 	    (status & ATH9K_INT_BB_WATCHDOG)) {
-#ifdef CONFIG_ATH9K_DEBUGFS
-		enum ath_reset_type type;
 
 		if (status & ATH9K_INT_FATAL)
 			type = RESET_TYPE_FATAL_INT;
 		else
 			type = RESET_TYPE_BB_WATCHDOG;
 
-		RESET_STAT_INC(sc, type);
-#endif
-		set_bit(SC_OP_HW_RESET, &sc->sc_flags);
-		ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
+		ath9k_queue_reset(sc, type);
 		goto out;
 	}
 
@@ -570,6 +566,15 @@ static int ath_reset(struct ath_softc *sc, bool retry_tx)
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

