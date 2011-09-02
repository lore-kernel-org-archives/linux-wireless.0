Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53593 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735Ab1IBXkj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Sep 2011 19:40:39 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	rmanohar@qca.qualcomm.com, shafi.wireless@gmail.com,
	vthiagar@qca.qualcomm.com
Subject: [PATCH v13 3/5] ath9k: always call ath_reset from workqueue context
Date: Sat,  3 Sep 2011 01:40:25 +0200
Message-Id: <1315006827-81443-3-git-send-email-nbd@openwrt.org> (sfid-20110903_014042_652746_0E69E4DF)
In-Reply-To: <1315006827-81443-2-git-send-email-nbd@openwrt.org>
References: <1315006827-81443-1-git-send-email-nbd@openwrt.org>
 <1315006827-81443-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes it much easier to add further rework to avoid race conditions
between reset and other work items.
Move other functions to make ath_reset static.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |    3 ++-
 drivers/net/wireless/ath/ath9k/beacon.c |    4 +---
 drivers/net/wireless/ath/ath9k/init.c   |    1 +
 drivers/net/wireless/ath/ath9k/main.c   |   17 +++++++++++++----
 drivers/net/wireless/ath/ath9k/xmit.c   |   14 +++++++++-----
 5 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 5d9a9aa..b2992d4 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -425,6 +425,7 @@ void ath9k_set_beaconing_status(struct ath_softc *sc, bool status);
 
 #define ATH_PAPRD_TIMEOUT	100 /* msecs */
 
+void ath_reset_work(struct work_struct *work);
 void ath_hw_check(struct work_struct *work);
 void ath_hw_pll_work(struct work_struct *work);
 void ath_paprd_calibrate(struct work_struct *work);
@@ -604,6 +605,7 @@ struct ath_softc {
 	struct mutex mutex;
 	struct work_struct paprd_work;
 	struct work_struct hw_check_work;
+	struct work_struct hw_reset_work;
 	struct completion paprd_complete;
 
 	unsigned int hw_busy_count;
@@ -650,7 +652,6 @@ struct ath_softc {
 };
 
 void ath9k_tasklet(unsigned long data);
-int ath_reset(struct ath_softc *sc, bool retry_tx);
 int ath_cabq_update(struct ath_softc *);
 
 static inline void ath_read_cachesize(struct ath_common *common, int *csz)
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 0c757c9..22e8e25 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -386,9 +386,7 @@ void ath_beacon_tasklet(unsigned long data)
 			ath_dbg(common, ATH_DBG_BSTUCK,
 				"beacon is officially stuck\n");
 			sc->sc_flags |= SC_OP_TSF_RESET;
-			spin_lock(&sc->sc_pcu_lock);
-			ath_reset(sc, true);
-			spin_unlock(&sc->sc_pcu_lock);
+			ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
 		}
 
 		return;
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 50da642..be302fb 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -777,6 +777,7 @@ int ath9k_init_device(u16 devid, struct ath_softc *sc,
 			goto error_world;
 	}
 
+	INIT_WORK(&sc->hw_reset_work, ath_reset_work);
 	INIT_WORK(&sc->hw_check_work, ath_hw_check);
 	INIT_WORK(&sc->paprd_work, ath_paprd_calibrate);
 	INIT_DELAYED_WORK(&sc->hw_pll_work, ath_hw_pll_work);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 9bb222c..9afcc66 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -236,6 +236,7 @@ static int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 	del_timer_sync(&common->ani.timer);
 	cancel_work_sync(&sc->paprd_work);
 	cancel_work_sync(&sc->hw_check_work);
+	cancel_work_sync(&sc->hw_reset_work);
 	cancel_delayed_work_sync(&sc->tx_complete_work);
 	cancel_delayed_work_sync(&sc->hw_pll_work);
 
@@ -608,9 +609,7 @@ void ath9k_tasklet(unsigned long data)
 
 	if ((status & ATH9K_INT_FATAL) ||
 	    (status & ATH9K_INT_BB_WATCHDOG)) {
-		spin_lock(&sc->sc_pcu_lock);
-		ath_reset(sc, true);
-		spin_unlock(&sc->sc_pcu_lock);
+		ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
 		return;
 	}
 
@@ -901,7 +900,7 @@ void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	ath9k_ps_restore(sc);
 }
 
-int ath_reset(struct ath_softc *sc, bool retry_tx)
+static int ath_reset(struct ath_softc *sc, bool retry_tx)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -969,6 +968,15 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 	return r;
 }
 
+void ath_reset_work(struct work_struct *work)
+{
+	struct ath_softc *sc = container_of(work, struct ath_softc, hw_reset_work);
+
+	spin_lock_bh(&sc->sc_pcu_lock);
+	ath_reset(sc, true);
+	spin_unlock_bh(&sc->sc_pcu_lock);
+}
+
 void ath_hw_check(struct work_struct *work)
 {
 	struct ath_softc *sc = container_of(work, struct ath_softc, hw_check_work);
@@ -1230,6 +1238,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	cancel_delayed_work_sync(&sc->hw_pll_work);
 	cancel_work_sync(&sc->paprd_work);
 	cancel_work_sync(&sc->hw_check_work);
+	cancel_work_sync(&sc->hw_reset_work);
 
 	if (sc->sc_flags & SC_OP_INVALID) {
 		ath_dbg(common, ATH_DBG_ANY, "Device not present\n");
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 49b93c2..782b0c9 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -582,7 +582,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	rcu_read_unlock();
 
 	if (needreset)
-		ath_reset(sc, false);
+		ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
 }
 
 static bool ath_lookup_legacy(struct ath_buf *bf)
@@ -1332,7 +1332,7 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 	struct ath_atx_ac *ac, *ac_tmp, *last_ac;
 	struct ath_atx_tid *tid, *last_tid;
 
-	if (list_empty(&txq->axq_acq) ||
+	if (work_pending(&sc->hw_reset_work) || list_empty(&txq->axq_acq) ||
 	    txq->axq_ampdu_depth >= ATH_AGGR_MIN_QDEPTH)
 		return;
 
@@ -2147,6 +2147,9 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 
 	spin_lock_bh(&txq->axq_lock);
 	for (;;) {
+		if (work_pending(&sc->hw_reset_work))
+			break;
+
 		if (list_empty(&txq->axq_q)) {
 			txq->axq_link = NULL;
 			if (sc->sc_flags & SC_OP_TXAGGR)
@@ -2234,9 +2237,7 @@ static void ath_tx_complete_poll_work(struct work_struct *work)
 	if (needreset) {
 		ath_dbg(ath9k_hw_common(sc->sc_ah), ATH_DBG_RESET,
 			"tx hung, resetting the chip\n");
-		spin_lock_bh(&sc->sc_pcu_lock);
-		ath_reset(sc, true);
-		spin_unlock_bh(&sc->sc_pcu_lock);
+		ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
 	}
 
 	ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work,
@@ -2269,6 +2270,9 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
 	int status;
 
 	for (;;) {
+		if (work_pending(&sc->hw_reset_work))
+			break;
+
 		status = ath9k_hw_txprocdesc(ah, NULL, (void *)&ts);
 		if (status == -EINPROGRESS)
 			break;
-- 
1.7.3.2

