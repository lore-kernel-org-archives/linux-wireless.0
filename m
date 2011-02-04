Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39224 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757Ab1BDTJc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 14:09:32 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH v2] ath9k: add additional checks for the baseband hang detection
Date: Fri,  4 Feb 2011 20:09:25 +0100
Message-Id: <1296846565-90650-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since even with the latest changes the false positive issue of the baseband
hang check is not fully solved yet, additional checks are needed.
If the baseband hang occurs, the rx_clear signal will be stuck to high, so
we can use the cycle counters to confirm it.
With this patch, a hardware reset is only triggered if the baseband hang
check returned true three times in a row, with a beacon interval between
each check and if the busy time was also 99% or more during the check
intervals.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 +
 drivers/net/wireless/ath/ath9k/main.c  |   45 +++++++++++++++++++++++++------
 2 files changed, 38 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index bd85e31..7c8409e 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -602,6 +602,8 @@ struct ath_softc {
 	struct completion paprd_complete;
 	bool paprd_pending;
 
+	unsigned int hw_busy_count;
+
 	u32 intrstatus;
 	u32 sc_flags; /* SC_OP_* */
 	u16 ps_flags; /* PS_* */
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 1447b55..c6177bc 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -177,7 +177,12 @@ static void ath_update_survey_nf(struct ath_softc *sc, int channel)
 	}
 }
 
-static void ath_update_survey_stats(struct ath_softc *sc)
+/*
+ * Updates the survey statistics and returns the busy time since last
+ * update in %, if the measurement duration was long enough for the
+ * result to be useful, -1 otherwise.
+ */
+static int ath_update_survey_stats(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -185,9 +190,10 @@ static void ath_update_survey_stats(struct ath_softc *sc)
 	struct survey_info *survey = &sc->survey[pos];
 	struct ath_cycle_counters *cc = &common->cc_survey;
 	unsigned int div = common->clockrate * 1000;
+	int ret = 0;
 
 	if (!ah->curchan)
-		return;
+		return -1;
 
 	if (ah->power_mode == ATH9K_PM_AWAKE)
 		ath_hw_cycle_counters_update(common);
@@ -202,9 +208,18 @@ static void ath_update_survey_stats(struct ath_softc *sc)
 		survey->channel_time_rx += cc->rx_frame / div;
 		survey->channel_time_tx += cc->tx_frame / div;
 	}
+
+	if (cc->cycles < div)
+		return -1;
+
+	if (cc->cycles > 0)
+		ret = cc->rx_busy * 100 / cc->cycles;
+
 	memset(cc, 0, sizeof(*cc));
 
 	ath_update_survey_nf(sc, pos);
+
+	return ret;
 }
 
 /*
@@ -226,6 +241,8 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 	if (sc->sc_flags & SC_OP_INVALID)
 		return -EIO;
 
+	sc->hw_busy_count = 0;
+
 	del_timer_sync(&common->ani.timer);
 	cancel_work_sync(&sc->paprd_work);
 	cancel_work_sync(&sc->hw_check_work);
@@ -592,17 +609,25 @@ static void ath_node_detach(struct ath_softc *sc, struct ieee80211_sta *sta)
 void ath_hw_check(struct work_struct *work)
 {
 	struct ath_softc *sc = container_of(work, struct ath_softc, hw_check_work);
-	int i;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	unsigned long flags;
+	int busy;
 
 	ath9k_ps_wakeup(sc);
+	if (ath9k_hw_check_alive(sc->sc_ah))
+		goto out;
 
-	for (i = 0; i < 3; i++) {
-		if (ath9k_hw_check_alive(sc->sc_ah))
-			goto out;
+	spin_lock_irqsave(&common->cc_lock, flags);
+	busy = ath_update_survey_stats(sc);
+	spin_unlock_irqrestore(&common->cc_lock, flags);
 
-		msleep(1);
-	}
-	ath_reset(sc, true);
+	ath_dbg(common, ATH_DBG_RESET, "Possible baseband hang, "
+		"busy=%d (try %d)\n", busy, sc->hw_busy_count + 1);
+	if (busy >= 99) {
+		if (++sc->hw_busy_count >= 3)
+			ath_reset(sc, true);
+	} else if (busy >= 0)
+		sc->hw_busy_count = 0;
 
 out:
 	ath9k_ps_restore(sc);
@@ -952,6 +977,8 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 	struct ieee80211_hw *hw = sc->hw;
 	int r;
 
+	sc->hw_busy_count = 0;
+
 	/* Stop ANI */
 	del_timer_sync(&common->ani.timer);
 
-- 
1.7.3.2

