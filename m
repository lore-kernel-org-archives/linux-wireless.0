Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:53313 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab3IKLKf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Sep 2013 07:10:35 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] ath9k: Use bitops for calibration flags
Date: Wed, 11 Sep 2013 16:36:31 +0530
Message-Id: <1378897592-19199-1-git-send-email-sujith@msujith.org> (sfid-20130911_131038_947805_61B80236)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_calib.c |  4 ++--
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 20 ++++++++++++--------
 drivers/net/wireless/ath/ath9k/ar9003_mci.c   |  6 +++---
 drivers/net/wireless/ath/ath9k/ar9003_rtt.c   |  6 +++---
 drivers/net/wireless/ath/ath9k/calib.c        | 14 +++++++-------
 drivers/net/wireless/ath/ath9k/hw.c           | 12 ++++++------
 drivers/net/wireless/ath/ath9k/hw.h           | 18 +++++++++++-------
 drivers/net/wireless/ath/ath9k/link.c         | 12 +++++++-----
 drivers/net/wireless/ath/ath9k/xmit.c         |  2 +-
 9 files changed, 52 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
index 9f58974..32376ad 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -671,7 +671,7 @@ static bool ar9002_hw_calibrate(struct ath_hw *ah,
 
 	nfcal = !!(REG_READ(ah, AR_PHY_AGC_CONTROL) & AR_PHY_AGC_CONTROL_NF);
 	if (ah->caldata)
-		nfcal_pending = ah->caldata->nfcal_pending;
+		nfcal_pending = test_bit(NFCAL_PENDING, &ah->caldata->cal_flags);
 
 	if (currCal && !nfcal &&
 	    (currCal->calState == CAL_RUNNING ||
@@ -861,7 +861,7 @@ static bool ar9002_hw_init_cal(struct ath_hw *ah, struct ath9k_channel *chan)
 	ar9002_hw_pa_cal(ah, true);
 
 	if (ah->caldata)
-		ah->caldata->nfcal_pending = true;
+		set_bit(NFCAL_PENDING, &ah->caldata->cal_flags);
 
 	ah->cal_list = ah->cal_list_last = ah->cal_list_curr = NULL;
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 6001bc0..687173c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -727,8 +727,12 @@ static void ar9003_hw_tx_iqcal_load_avg_2_passes(struct ath_hw *ah,
 	REG_RMW_FIELD(ah, AR_PHY_RX_IQCAL_CORR_B0,
 		      AR_PHY_RX_IQCAL_CORR_B0_LOOPBACK_IQCORR_EN, 0x1);
 
-	if (caldata)
-		caldata->done_txiqcal_once = is_reusable;
+	if (caldata) {
+		if (is_reusable)
+			set_bit(TXIQCAL_DONE, &caldata->cal_flags);
+		else
+			clear_bit(TXIQCAL_DONE, &caldata->cal_flags);
+	}
 
 	return;
 }
@@ -990,7 +994,7 @@ static void ar9003_hw_cl_cal_post_proc(struct ath_hw *ah, bool is_reusable)
 	txclcal_done = !!(REG_READ(ah, AR_PHY_AGC_CONTROL) &
 			  AR_PHY_AGC_CONTROL_CLC_SUCCESS);
 
-	if (caldata->done_txclcal_once) {
+	if (test_bit(TXCLCAL_DONE, &caldata->cal_flags)) {
 		for (i = 0; i < AR9300_MAX_CHAINS; i++) {
 			if (!(ah->txchainmask & (1 << i)))
 				continue;
@@ -1006,7 +1010,7 @@ static void ar9003_hw_cl_cal_post_proc(struct ath_hw *ah, bool is_reusable)
 				caldata->tx_clcal[i][j] =
 					REG_READ(ah, CL_TAB_ENTRY(cl_idx[i]));
 		}
-		caldata->done_txclcal_once = true;
+		set_bit(TXCLCAL_DONE, &caldata->cal_flags);
 	}
 }
 
@@ -1053,7 +1057,7 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 	}
 
 	if (ah->enabled_cals & TX_CL_CAL) {
-		if (caldata && caldata->done_txclcal_once)
+		if (caldata && test_bit(TXCLCAL_DONE, &caldata->cal_flags))
 			REG_CLR_BIT(ah, AR_PHY_CL_CAL_CTL,
 				    AR_PHY_CL_CAL_ENABLE);
 		else {
@@ -1077,14 +1081,14 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 	 * AGC calibration
 	 */
 	if (ah->enabled_cals & TX_IQ_ON_AGC_CAL) {
-		if (caldata && !caldata->done_txiqcal_once)
+		if (caldata && !test_bit(TXIQCAL_DONE, &caldata->cal_flags))
 			REG_SET_BIT(ah, AR_PHY_TX_IQCAL_CONTROL_0,
 				    AR_PHY_TX_IQCAL_CONTROL_0_ENABLE_TXIQ_CAL);
 		else
 			REG_CLR_BIT(ah, AR_PHY_TX_IQCAL_CONTROL_0,
 				    AR_PHY_TX_IQCAL_CONTROL_0_ENABLE_TXIQ_CAL);
 		txiqcal_done = run_agc_cal = true;
-	} else if (caldata && !caldata->done_txiqcal_once) {
+	} else if (caldata && !test_bit(TXIQCAL_DONE, &caldata->cal_flags)) {
 		run_agc_cal = true;
 		sep_iq_cal = true;
 	}
@@ -1148,7 +1152,7 @@ skip_tx_iqcal:
 
 	if (txiqcal_done)
 		ar9003_hw_tx_iq_cal_post_proc(ah, is_reusable);
-	else if (caldata && caldata->done_txiqcal_once)
+	else if (caldata && test_bit(TXIQCAL_DONE, &caldata->cal_flags))
 		ar9003_hw_tx_iq_cal_reload(ah);
 
 	ar9003_hw_cl_cal_post_proc(ah, is_reusable);
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index 8dd0692..7b94a6c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -753,9 +753,9 @@ int ar9003_mci_end_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		    1 << AR_PHY_TIMING_CONTROL4_DO_GAIN_DC_IQ_CAL_SHIFT);
 
 	if (caldata) {
-		caldata->done_txiqcal_once = false;
-		caldata->done_txclcal_once = false;
-		caldata->rtt_done = false;
+		clear_bit(TXIQCAL_DONE, &caldata->cal_flags);
+		clear_bit(TXCLCAL_DONE, &caldata->cal_flags);
+		clear_bit(RTT_DONE, &caldata->cal_flags);
 	}
 
 	if (!ath9k_hw_init_cal(ah, chan))
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_rtt.c b/drivers/net/wireless/ath/ath9k/ar9003_rtt.c
index 74de353..e398c18 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_rtt.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_rtt.c
@@ -161,7 +161,7 @@ void ar9003_hw_rtt_fill_hist(struct ath_hw *ah)
 		}
 	}
 
-	ah->caldata->rtt_done = true;
+	set_bit(RTT_DONE, &ah->caldata->cal_flags);
 }
 
 void ar9003_hw_rtt_clear_hist(struct ath_hw *ah)
@@ -176,7 +176,7 @@ void ar9003_hw_rtt_clear_hist(struct ath_hw *ah)
 	}
 
 	if (ah->caldata)
-		ah->caldata->rtt_done = false;
+		clear_bit(RTT_DONE, &ah->caldata->cal_flags);
 }
 
 bool ar9003_hw_rtt_restore(struct ath_hw *ah, struct ath9k_channel *chan)
@@ -186,7 +186,7 @@ bool ar9003_hw_rtt_restore(struct ath_hw *ah, struct ath9k_channel *chan)
 	if (!ah->caldata)
 		return false;
 
-	if (!ah->caldata->rtt_done)
+	if (!test_bit(RTT_DONE, &ah->caldata->cal_flags))
 		return false;
 
 	ar9003_hw_rtt_enable(ah);
diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 5e8219a..d438a03 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -119,7 +119,7 @@ static void ath9k_hw_update_nfcal_hist_buffer(struct ath_hw *ah,
 			ath_dbg(common, CALIBRATE,
 				"NFmid[%d] (%d) > MAX (%d), %s\n",
 				i, h[i].privNF, limit->max,
-				(cal->nfcal_interference ?
+				(test_bit(NFCAL_INTF, &cal->cal_flags) ?
 				 "not corrected (due to interference)" :
 				 "correcting to MAX"));
 
@@ -130,7 +130,7 @@ static void ath9k_hw_update_nfcal_hist_buffer(struct ath_hw *ah,
 			 * we bypass this limit here in order to better deal
 			 * with our environment.
 			 */
-			if (!cal->nfcal_interference)
+			if (!test_bit(NFCAL_INTF, &cal->cal_flags))
 				h[i].privNF = limit->max;
 		}
 	}
@@ -141,7 +141,7 @@ static void ath9k_hw_update_nfcal_hist_buffer(struct ath_hw *ah,
 	 * Re-enable the enforcement of the NF maximum again.
 	 */
 	if (!high_nf_mid)
-		cal->nfcal_interference = false;
+		clear_bit(NFCAL_INTF, &cal->cal_flags);
 }
 
 static bool ath9k_hw_get_nf_thresh(struct ath_hw *ah,
@@ -220,7 +220,7 @@ EXPORT_SYMBOL(ath9k_hw_reset_calvalid);
 void ath9k_hw_start_nfcal(struct ath_hw *ah, bool update)
 {
 	if (ah->caldata)
-		ah->caldata->nfcal_pending = true;
+		set_bit(NFCAL_PENDING, &ah->caldata->cal_flags);
 
 	REG_SET_BIT(ah, AR_PHY_AGC_CONTROL,
 		    AR_PHY_AGC_CONTROL_ENABLE_NF);
@@ -391,7 +391,7 @@ bool ath9k_hw_getnf(struct ath_hw *ah, struct ath9k_channel *chan)
 	}
 
 	h = caldata->nfCalHist;
-	caldata->nfcal_pending = false;
+	clear_bit(NFCAL_PENDING, &caldata->cal_flags);
 	ath9k_hw_update_nfcal_hist_buffer(ah, caldata, nfarray);
 	chan->noisefloor = h[0].privNF;
 	ah->noise = ath9k_hw_getchan_noise(ah, chan);
@@ -437,12 +437,12 @@ void ath9k_hw_bstuck_nfcal(struct ath_hw *ah)
 	 * the baseband update the internal NF value itself, similar to
 	 * what is being done after a full reset.
 	 */
-	if (!caldata->nfcal_pending)
+	if (!test_bit(NFCAL_PENDING, &caldata->cal_flags))
 		ath9k_hw_start_nfcal(ah, true);
 	else if (!(REG_READ(ah, AR_PHY_AGC_CONTROL) & AR_PHY_AGC_CONTROL_NF))
 		ath9k_hw_getnf(ah, ah->curchan);
 
-	caldata->nfcal_interference = true;
+	set_bit(NFCAL_INTF, &caldata->cal_flags);
 }
 EXPORT_SYMBOL(ath9k_hw_bstuck_nfcal);
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 7d6e35d..4e66c17 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1847,9 +1847,9 @@ static int ath9k_hw_do_fastcc(struct ath_hw *ah, struct ath9k_channel *chan)
 	 * re-using are present.
 	 */
 	if (AR_SREV_9462(ah) && (ah->caldata &&
-				 (!ah->caldata->done_txiqcal_once ||
-				  !ah->caldata->done_txclcal_once ||
-				  !ah->caldata->rtt_done)))
+				 (!test_bit(TXIQCAL_DONE, &ah->caldata->cal_flags) ||
+				  !test_bit(TXCLCAL_DONE, &ah->caldata->cal_flags) ||
+				  !test_bit(RTT_DONE, &ah->caldata->cal_flags))))
 		goto fail;
 
 	ath_dbg(common, RESET, "FastChannelChange for %d -> %d\n",
@@ -1905,7 +1905,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		memset(caldata, 0, sizeof(*caldata));
 		ath9k_init_nfcal_hist_buffer(ah, chan);
 	} else if (caldata) {
-		caldata->paprd_packet_sent = false;
+		clear_bit(PAPRD_PACKET_SENT, &caldata->cal_flags);
 	}
 	ah->noise = ath9k_hw_getchan_noise(ah, chan);
 
@@ -2042,8 +2042,8 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	ath9k_hw_init_bb(ah, chan);
 
 	if (caldata) {
-		caldata->done_txiqcal_once = false;
-		caldata->done_txclcal_once = false;
+		clear_bit(TXIQCAL_DONE, &caldata->cal_flags);
+		clear_bit(TXCLCAL_DONE, &caldata->cal_flags);
 	}
 	if (!ath9k_hw_init_cal(ah, chan))
 		return -EIO;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 8e1c675..2df1095 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -404,20 +404,24 @@ enum ath9k_int {
 #define MAX_CL_TAB_ENTRY	16
 #define CL_TAB_ENTRY(reg_base)	(reg_base + (4 * j))
 
+enum ath9k_cal_flags {
+	RTT_DONE,
+	PAPRD_PACKET_SENT,
+	PAPRD_DONE,
+	NFCAL_PENDING,
+	NFCAL_INTF,
+	TXIQCAL_DONE,
+	TXCLCAL_DONE,
+};
+
 struct ath9k_hw_cal_data {
 	u16 channel;
 	u32 channelFlags;
 	u32 chanmode;
+	unsigned long cal_flags;
 	int32_t CalValid;
 	int8_t iCoff;
 	int8_t qCoff;
-	bool rtt_done;
-	bool paprd_packet_sent;
-	bool paprd_done;
-	bool nfcal_pending;
-	bool nfcal_interference;
-	bool done_txiqcal_once;
-	bool done_txclcal_once;
 	u16 small_signal_gain[AR9300_MAX_CHAINS];
 	u32 pa_table[AR9300_MAX_CHAINS][PAPRD_TABLE_SZ];
 	u32 num_measures[AR9300_MAX_CHAINS];
diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index 2f831db..84a6064 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -184,7 +184,7 @@ static void ath_paprd_activate(struct ath_softc *sc)
 	struct ath9k_hw_cal_data *caldata = ah->caldata;
 	int chain;
 
-	if (!caldata || !caldata->paprd_done) {
+	if (!caldata || !test_bit(PAPRD_DONE, &caldata->cal_flags)) {
 		ath_dbg(common, CALIBRATE, "Failed to activate PAPRD\n");
 		return;
 	}
@@ -256,7 +256,9 @@ void ath_paprd_calibrate(struct work_struct *work)
 	int len = 1800;
 	int ret;
 
-	if (!caldata || !caldata->paprd_packet_sent || caldata->paprd_done) {
+	if (!caldata ||
+	    !test_bit(PAPRD_PACKET_SENT, &caldata->cal_flags) ||
+	    test_bit(PAPRD_DONE, &caldata->cal_flags)) {
 		ath_dbg(common, CALIBRATE, "Skipping PAPRD calibration\n");
 		return;
 	}
@@ -316,7 +318,7 @@ void ath_paprd_calibrate(struct work_struct *work)
 	kfree_skb(skb);
 
 	if (chain_ok) {
-		caldata->paprd_done = true;
+		set_bit(PAPRD_DONE, &caldata->cal_flags);
 		ath_paprd_activate(sc);
 	}
 
@@ -343,7 +345,7 @@ void ath_ani_calibrate(unsigned long data)
 	u32 cal_interval, short_cal_interval, long_cal_interval;
 	unsigned long flags;
 
-	if (ah->caldata && ah->caldata->nfcal_interference)
+	if (ah->caldata && test_bit(NFCAL_INTF, &ah->caldata->cal_flags))
 		long_cal_interval = ATH_LONG_CALINTERVAL_INT;
 	else
 		long_cal_interval = ATH_LONG_CALINTERVAL;
@@ -432,7 +434,7 @@ set_timer:
 	mod_timer(&common->ani.timer, jiffies + msecs_to_jiffies(cal_interval));
 
 	if (ar9003_is_paprd_enabled(ah) && ah->caldata) {
-		if (!ah->caldata->paprd_done) {
+		if (!test_bit(PAPRD_DONE, &ah->caldata->cal_flags)) {
 			ieee80211_queue_work(sc->hw, &sc->paprd_work);
 		} else if (!ah->paprd_table_write_done) {
 			ath9k_ps_wakeup(sc);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 35b515f..62c93a6 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2315,7 +2315,7 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 	ath_dbg(common, XMIT, "TX complete: skb: %p\n", skb);
 
 	if (sc->sc_ah->caldata)
-		sc->sc_ah->caldata->paprd_packet_sent = true;
+		set_bit(PAPRD_PACKET_SENT, &sc->sc_ah->caldata->cal_flags);
 
 	if (!(tx_flags & ATH_TX_ERROR))
 		/* Frame was ACKed */
-- 
1.8.4

