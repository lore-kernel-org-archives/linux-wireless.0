Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33480 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab1KYSlC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Nov 2011 13:41:02 -0500
Received: by mail-ey0-f174.google.com with SMTP id k14so988570eaa.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 Nov 2011 10:41:01 -0800 (PST)
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	nbd@openwrt.org, jirislaby@gmail.com,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH v2 04/12] ath5k: Calibration re-work
Date: Fri, 25 Nov 2011 20:40:23 +0200
Message-Id: <1322246431-10825-5-git-send-email-mickflemm@gmail.com> (sfid-20111125_194112_146243_CED72F73)
In-Reply-To: <1322246431-10825-1-git-send-email-mickflemm@gmail.com>
References: <1322246431-10825-1-git-send-email-mickflemm@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Noise floor calibration does not interfere with traffic and should run more
often as part of our "short calibration". The full calibration is not the
noise floor calibration but the AGC + Gain_F (on RF5111 and RF5112) calibration
and should run less often because it does interfere with traffic.

So

Short calibration -> I/Q & NF Calibration
Long calibration -> Short + AGC + Gain_F

This patch was for some time on my pub/ dir on www.kernel.org and has been tested
by a few people and me. I think it's O.K. to go in.

I also changed ah_calibration to ah_iq_cal_needed to make more sense.

v2 Use a workqueue instead of a tasklet for calibration

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |   15 ++--
 drivers/net/wireless/ath/ath5k/base.c  |  112 ++++++++++++++++++++++----------
 drivers/net/wireless/ath/ath5k/phy.c   |   82 ++++++++++++++++++------
 3 files changed, 147 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index b8abdbc..3e75d02 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -187,10 +187,9 @@
 #define AR5K_TUNE_MAX_TXPOWER			63
 #define AR5K_TUNE_DEFAULT_TXPOWER		25
 #define AR5K_TUNE_TPC_TXPOWER			false
-#define ATH5K_TUNE_CALIBRATION_INTERVAL_FULL    10000   /* 10 sec */
+#define ATH5K_TUNE_CALIBRATION_INTERVAL_FULL    60000   /* 60 sec */
+#define	ATH5K_TUNE_CALIBRATION_INTERVAL_SHORT	10000	/* 10 sec */
 #define ATH5K_TUNE_CALIBRATION_INTERVAL_ANI	1000	/* 1 sec */
-#define ATH5K_TUNE_CALIBRATION_INTERVAL_NF	60000	/* 60 sec */
-
 #define ATH5K_TX_COMPLETE_POLL_INT		3000	/* 3 sec */
 
 #define AR5K_INIT_CARR_SENSE_EN			1
@@ -896,7 +895,8 @@ enum ath5k_int {
 enum ath5k_calibration_mask {
 	AR5K_CALIBRATION_FULL = 0x01,
 	AR5K_CALIBRATION_SHORT = 0x02,
-	AR5K_CALIBRATION_ANI = 0x04,
+	AR5K_CALIBRATION_NF = 0x04,
+	AR5K_CALIBRATION_ANI = 0x08,
 };
 
 /*
@@ -1098,6 +1098,7 @@ struct ath5k_hw {
 				led_on;		/* pin setting for LED on */
 
 	struct work_struct	reset_work;	/* deferred chip reset */
+	struct work_struct	calib_work;	/* deferred phy calibration */
 
 	struct list_head	rxbuf;		/* receive buffer */
 	spinlock_t		rxbuflock;
@@ -1114,8 +1115,6 @@ struct ath5k_hw {
 
 	struct ath5k_rfkill	rf_kill;
 
-	struct tasklet_struct	calib;		/* calibration tasklet */
-
 	spinlock_t		block;		/* protects beacon */
 	struct tasklet_struct	beacontq;	/* beacon intr tasklet */
 	struct list_head	bcbuf;		/* beacon buffer */
@@ -1145,7 +1144,7 @@ struct ath5k_hw {
 	enum ath5k_int		ah_imr;
 
 	struct ieee80211_channel *ah_current_channel;
-	bool			ah_calibration;
+	bool			ah_iq_cal_needed;
 	bool			ah_single_chip;
 
 	enum ath5k_version	ah_version;
@@ -1235,8 +1234,8 @@ struct ath5k_hw {
 
 	/* Calibration timestamp */
 	unsigned long		ah_cal_next_full;
+	unsigned long		ah_cal_next_short;
 	unsigned long		ah_cal_next_ani;
-	unsigned long		ah_cal_next_nf;
 
 	/* Calibration mask */
 	u8			ah_cal_mask;
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 47194a4..a8cb1c7 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2112,16 +2112,29 @@ static void
 ath5k_intr_calibration_poll(struct ath5k_hw *ah)
 {
 	if (time_is_before_eq_jiffies(ah->ah_cal_next_ani) &&
-	    !(ah->ah_cal_mask & AR5K_CALIBRATION_FULL)) {
-		/* run ANI only when full calibration is not active */
+	   !(ah->ah_cal_mask & AR5K_CALIBRATION_FULL) &&
+	   !(ah->ah_cal_mask & AR5K_CALIBRATION_SHORT)) {
+
+		/* Run ANI only when calibration is not active */
+
 		ah->ah_cal_next_ani = jiffies +
 			msecs_to_jiffies(ATH5K_TUNE_CALIBRATION_INTERVAL_ANI);
 		tasklet_schedule(&ah->ani_tasklet);
 
-	} else if (time_is_before_eq_jiffies(ah->ah_cal_next_full)) {
-		ah->ah_cal_next_full = jiffies +
-			msecs_to_jiffies(ATH5K_TUNE_CALIBRATION_INTERVAL_FULL);
-		tasklet_schedule(&ah->calib);
+	} else if (time_is_before_eq_jiffies(ah->ah_cal_next_short) &&
+		!(ah->ah_cal_mask & AR5K_CALIBRATION_FULL) &&
+		!(ah->ah_cal_mask & AR5K_CALIBRATION_SHORT)) {
+
+		/* Run calibration only when another calibration
+		 * is not running.
+		 *
+		 * Note: This is for both full/short calibration,
+		 * if it's time for a full one, ath5k_calibrate_work will deal
+		 * with it. */
+
+		ah->ah_cal_next_short = jiffies +
+			msecs_to_jiffies(ATH5K_TUNE_CALIBRATION_INTERVAL_SHORT);
+		ieee80211_queue_work(ah->hw, &ah->calib_work);
 	}
 	/* we could use SWI to generate enough interrupts to meet our
 	 * calibration interval requirements, if necessary:
@@ -2286,41 +2299,58 @@ ath5k_intr(int irq, void *dev_id)
  * for temperature/environment changes.
  */
 static void
-ath5k_tasklet_calibrate(unsigned long data)
+ath5k_calibrate_work(struct work_struct *work)
 {
-	struct ath5k_hw *ah = (void *)data;
+	struct ath5k_hw *ah = container_of(work, struct ath5k_hw,
+		calib_work);
+
+	/* Should we run a full calibration ? */
+	if (time_is_before_eq_jiffies(ah->ah_cal_next_full)) {
+
+		ah->ah_cal_next_full = jiffies +
+			msecs_to_jiffies(ATH5K_TUNE_CALIBRATION_INTERVAL_FULL);
+		ah->ah_cal_mask |= AR5K_CALIBRATION_FULL;
+
+		ATH5K_DBG(ah, ATH5K_DEBUG_CALIBRATE,
+				"running full calibration\n");
+
+		if (ath5k_hw_gainf_calibrate(ah) == AR5K_RFGAIN_NEED_CHANGE) {
+			/*
+			 * Rfgain is out of bounds, reset the chip
+			 * to load new gain values.
+			 */
+			ATH5K_DBG(ah, ATH5K_DEBUG_RESET,
+					"got new rfgain, resetting\n");
+			ieee80211_queue_work(ah->hw, &ah->reset_work);
+		}
+
+		/* TODO: On full calibration we should stop TX here,
+		 * so that it doesn't interfere (mostly due to gain_f
+		 * calibration that messes with tx packets -see phy.c).
+		 *
+		 * NOTE: Stopping the queues from above is not enough
+		 * to stop TX but saves us from disconecting (at least
+		 * we don't lose packets). */
+		ieee80211_stop_queues(ah->hw);
+	} else
+		ah->ah_cal_mask |= AR5K_CALIBRATION_SHORT;
 
-	/* Only full calibration for now */
-	ah->ah_cal_mask |= AR5K_CALIBRATION_FULL;
 
 	ATH5K_DBG(ah, ATH5K_DEBUG_CALIBRATE, "channel %u/%x\n",
 		ieee80211_frequency_to_channel(ah->curchan->center_freq),
 		ah->curchan->hw_value);
 
-	if (ath5k_hw_gainf_calibrate(ah) == AR5K_RFGAIN_NEED_CHANGE) {
-		/*
-		 * Rfgain is out of bounds, reset the chip
-		 * to load new gain values.
-		 */
-		ATH5K_DBG(ah, ATH5K_DEBUG_RESET, "calibration, resetting\n");
-		ieee80211_queue_work(ah->hw, &ah->reset_work);
-	}
 	if (ath5k_hw_phy_calibrate(ah, ah->curchan))
 		ATH5K_ERR(ah, "calibration of channel %u failed\n",
 			ieee80211_frequency_to_channel(
 				ah->curchan->center_freq));
 
-	/* Noise floor calibration interrupts rx/tx path while I/Q calibration
-	 * doesn't.
-	 * TODO: We should stop TX here, so that it doesn't interfere.
-	 * Note that stopping the queues is not enough to stop TX! */
-	if (time_is_before_eq_jiffies(ah->ah_cal_next_nf)) {
-		ah->ah_cal_next_nf = jiffies +
-			msecs_to_jiffies(ATH5K_TUNE_CALIBRATION_INTERVAL_NF);
-		ath5k_hw_update_noise_floor(ah);
-	}
-
-	ah->ah_cal_mask &= ~AR5K_CALIBRATION_FULL;
+	/* Clear calibration flags */
+	if (ah->ah_cal_mask & AR5K_CALIBRATION_FULL) {
+		ieee80211_wake_queues(ah->hw);
+		ah->ah_cal_mask &= ~AR5K_CALIBRATION_FULL;
+	} else if (ah->ah_cal_mask & AR5K_CALIBRATION_SHORT)
+		ah->ah_cal_mask &= ~AR5K_CALIBRATION_SHORT;
 }
 
 
@@ -2639,7 +2669,6 @@ static void ath5k_stop_tasklets(struct ath5k_hw *ah)
 	ah->tx_pending = false;
 	tasklet_kill(&ah->rxtq);
 	tasklet_kill(&ah->txtq);
-	tasklet_kill(&ah->calib);
 	tasklet_kill(&ah->beacontq);
 	tasklet_kill(&ah->ani_tasklet);
 }
@@ -2743,9 +2772,24 @@ ath5k_reset(struct ath5k_hw *ah, struct ieee80211_channel *chan,
 
 	ath5k_ani_init(ah, ani_mode);
 
-	ah->ah_cal_next_full = jiffies + msecs_to_jiffies(100);
-	ah->ah_cal_next_ani = jiffies;
-	ah->ah_cal_next_nf = jiffies;
+	/*
+	 * Set calibration intervals
+	 *
+	 * Note: We don't need to run calibration imediately
+	 * since some initial calibration is done on reset
+	 * even for fast channel switching. Also on scanning
+	 * this will get set again and again and it won't get
+	 * executed unless we connect somewhere and spend some
+	 * time on the channel (that's what calibration needs
+	 * anyway to be accurate).
+	 */
+	ah->ah_cal_next_full = jiffies +
+		msecs_to_jiffies(ATH5K_TUNE_CALIBRATION_INTERVAL_FULL);
+	ah->ah_cal_next_ani = jiffies +
+		msecs_to_jiffies(ATH5K_TUNE_CALIBRATION_INTERVAL_ANI);
+	ah->ah_cal_next_short = jiffies +
+		msecs_to_jiffies(ATH5K_TUNE_CALIBRATION_INTERVAL_SHORT);
+
 	ewma_init(&ah->ah_beacon_rssi_avg, 1024, 8);
 
 	/* clear survey data and cycle counters */
@@ -2895,11 +2939,11 @@ ath5k_init(struct ieee80211_hw *hw)
 
 	tasklet_init(&ah->rxtq, ath5k_tasklet_rx, (unsigned long)ah);
 	tasklet_init(&ah->txtq, ath5k_tasklet_tx, (unsigned long)ah);
-	tasklet_init(&ah->calib, ath5k_tasklet_calibrate, (unsigned long)ah);
 	tasklet_init(&ah->beacontq, ath5k_tasklet_beacon, (unsigned long)ah);
 	tasklet_init(&ah->ani_tasklet, ath5k_tasklet_ani, (unsigned long)ah);
 
 	INIT_WORK(&ah->reset_work, ath5k_reset_work);
+	INIT_WORK(&ah->calib_work, ath5k_calibrate_work);
 	INIT_DELAYED_WORK(&ah->tx_complete_work, ath5k_tx_complete_poll_work);
 
 	ret = ath5k_hw_common(ah)->bus_ops->eeprom_read_mac(ah, mac);
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 01cb72d..ca4241d 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -338,9 +338,6 @@ static void ath5k_hw_wait_for_synth(struct ath5k_hw *ah,
  * And this is the MadWiFi bug entry related to the above
  * http://madwifi-project.org/ticket/1659
  * with various measurements and diagrams
- *
- * TODO: Deal with power drops due to probes by setting an appropriate
- * tx power on the probe packets ! Make this part of the calibration process.
  */
 
 /* Initialize ah_gain during attach */
@@ -372,10 +369,9 @@ int ath5k_hw_rfgain_opt_init(struct ath5k_hw *ah)
  * tx power and a Peak to Average Power Detector (PAPD) will try
  * to measure the gain.
  *
- * XXX:  How about forcing a tx packet (bypassing PCU arbitrator etc)
+ * TODO: Force a tx packet (bypassing PCU arbitrator etc)
  * just after we enable the probe so that we don't mess with
- * standard traffic ? Maybe it's time to use sw interrupts and
- * a probe tasklet !!!
+ * standard traffic.
  */
 static void ath5k_hw_request_rfgain_probe(struct ath5k_hw *ah)
 {
@@ -575,9 +571,7 @@ done:
 /* Main callback for thermal RF gain calibration engine
  * Check for a new gain reading and schedule an adjustment
  * if needed.
- *
- * TODO: Use sw interrupt to schedule reset if gain_F needs
- * adjustment */
+ */
 enum ath5k_rfgain ath5k_hw_gainf_calibrate(struct ath5k_hw *ah)
 {
 	u32 data, type;
@@ -1390,6 +1384,8 @@ void ath5k_hw_update_noise_floor(struct ath5k_hw *ah)
 		return;
 	}
 
+	ah->ah_cal_mask |= AR5K_CALIBRATION_NF;
+
 	ee_mode = ath5k_eeprom_mode_from_channel(ah->ah_current_channel);
 
 	/* completed NF calibration, test threshold */
@@ -1434,6 +1430,8 @@ void ath5k_hw_update_noise_floor(struct ath5k_hw *ah)
 
 	ah->ah_noise_floor = nf;
 
+	ah->ah_cal_mask &= ~AR5K_CALIBRATION_NF;
+
 	ATH5K_DBG(ah, ATH5K_DEBUG_CALIBRATE,
 		"noise floor calibrated: %d\n", nf);
 }
@@ -1547,12 +1545,19 @@ ath5k_hw_rf511x_iq_calibrate(struct ath5k_hw *ah)
 	s32 iq_corr, i_coff, i_coffd, q_coff, q_coffd;
 	int i;
 
-	if (!ah->ah_calibration ||
-		ath5k_hw_reg_read(ah, AR5K_PHY_IQ) & AR5K_PHY_IQ_RUN)
-		return 0;
+	/* Skip if I/Q calibration is not needed or if it's still running */
+	if (!ah->ah_iq_cal_needed)
+		return -EINVAL;
+	else if (ath5k_hw_reg_read(ah, AR5K_PHY_IQ) & AR5K_PHY_IQ_RUN) {
+		ATH5K_DBG_UNLIMIT(ah, ATH5K_DEBUG_CALIBRATE,
+				"I/Q calibration still running");
+		return -EBUSY;
+	}
 
 	/* Calibration has finished, get the results and re-run */
-	/* work around empty results which can apparently happen on 5212 */
+
+	/* Work around for empty results which can apparently happen on 5212:
+	 * Read registers up to 10 times until we get both i_pr and q_pwr */
 	for (i = 0; i <= 10; i++) {
 		iq_corr = ath5k_hw_reg_read(ah, AR5K_PHY_IQRES_CAL_CORR);
 		i_pwr = ath5k_hw_reg_read(ah, AR5K_PHY_IQRES_CAL_PWR_I);
@@ -1570,9 +1575,13 @@ ath5k_hw_rf511x_iq_calibrate(struct ath5k_hw *ah)
 	else
 		q_coffd = q_pwr >> 7;
 
-	/* protect against divide by 0 and loss of sign bits */
+	/* In case i_coffd became zero, cancel calibration
+	 * not only it's too small, it'll also result a divide
+	 * by zero later on. */
 	if (i_coffd == 0 || q_coffd < 2)
-		return 0;
+		return -ECANCELED;
+
+	/* Protect against loss of sign bits */
 
 	i_coff = (-iq_corr) / i_coffd;
 	i_coff = clamp(i_coff, -32, 31); /* signed 6 bit */
@@ -1613,10 +1622,43 @@ int ath5k_hw_phy_calibrate(struct ath5k_hw *ah,
 		return ath5k_hw_rf5110_calibrate(ah, channel);
 
 	ret = ath5k_hw_rf511x_iq_calibrate(ah);
+	if (ret) {
+		ATH5K_DBG_UNLIMIT(ah, ATH5K_DEBUG_CALIBRATE,
+			"No I/Q correction performed (%uMHz)\n",
+			channel->center_freq);
+
+		/* Happens all the time if there is not much
+		 * traffic, consider it normal behaviour. */
+		ret = 0;
+	}
+
+	/* On full calibration do an AGC calibration and
+	 * request a PAPD probe for gainf calibration if
+	 * needed */
+	if (ah->ah_cal_mask & AR5K_CALIBRATION_FULL) {
+
+		AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_AGCCTL,
+					AR5K_PHY_AGCCTL_CAL);
+
+		ret = ath5k_hw_register_timeout(ah, AR5K_PHY_AGCCTL,
+			AR5K_PHY_AGCCTL_CAL | AR5K_PHY_AGCCTL_NF,
+			0, false);
+		if (ret) {
+			ATH5K_ERR(ah,
+				"gain calibration timeout (%uMHz)\n",
+				channel->center_freq);
+		}
+
+		if ((ah->ah_radio == AR5K_RF5111 ||
+			ah->ah_radio == AR5K_RF5112)
+			&& (channel->hw_value != AR5K_MODE_11B))
+			ath5k_hw_request_rfgain_probe(ah);
+	}
 
-	if ((ah->ah_radio == AR5K_RF5111 || ah->ah_radio == AR5K_RF5112) &&
-	    (channel->hw_value != AR5K_MODE_11B))
-		ath5k_hw_request_rfgain_probe(ah);
+	/* Update noise floor
+	 * XXX: Only do this after AGC calibration */
+	if (!(ah->ah_cal_mask & AR5K_CALIBRATION_NF))
+		ath5k_hw_update_noise_floor(ah);
 
 	return ret;
 }
@@ -3433,9 +3475,9 @@ int ath5k_hw_phy_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 
 	/* At the same time start I/Q calibration for QAM constellation
 	 * -no need for CCK- */
-	ah->ah_calibration = false;
+	ah->ah_iq_cal_needed = false;
 	if (!(mode == AR5K_MODE_11B)) {
-		ah->ah_calibration = true;
+		ah->ah_iq_cal_needed = true;
 		AR5K_REG_WRITE_BITS(ah, AR5K_PHY_IQ,
 				AR5K_PHY_IQ_CAL_NUM_LOG_MAX, 15);
 		AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_IQ,
-- 
1.7.8.rc3

