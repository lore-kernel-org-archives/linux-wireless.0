Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:49933 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570Ab0G3WMH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jul 2010 18:12:07 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH v2 3/3] ath9k_hw: fix a noise floor calibration related race condition
Date: Sat, 31 Jul 2010 00:12:01 +0200
Message-Id: <1280527921-49946-3-git-send-email-nbd@openwrt.org>
In-Reply-To: <1280527921-49946-2-git-send-email-nbd@openwrt.org>
References: <1280527921-49946-1-git-send-email-nbd@openwrt.org>
 <1280527921-49946-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On AR5008-AR9002, other forms of calibration must not be started while
the noise floor calibration is running, as this can create invalid
readings which were sometimes not even recoverable by any further
calibration attempts.

This patch also ensures that the result of noise floor measurements
are processed faster and also allows the result of the initial
calibration on reset to make it into the NF history buffer

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9002_calib.c |   32 ++++++++++++++++--------
 drivers/net/wireless/ath/ath9k/calib.c        |   15 ++++++-----
 drivers/net/wireless/ath/ath9k/calib.h        |    3 +-
 drivers/net/wireless/ath/ath9k/hw.h           |    1 +
 4 files changed, 31 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
index d28a8d3..fe7418a 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -687,8 +687,13 @@ static bool ar9002_hw_calibrate(struct ath_hw *ah,
 {
 	bool iscaldone = true;
 	struct ath9k_cal_list *currCal = ah->cal_list_curr;
+	bool nfcal, nfcal_pending = false;
 
-	if (currCal &&
+	nfcal = !!(REG_READ(ah, AR_PHY_AGC_CONTROL) & AR_PHY_AGC_CONTROL_NF);
+	if (ah->caldata)
+		nfcal_pending = ah->caldata->nfcal_pending;
+
+	if (currCal && !nfcal &&
 	    (currCal->calState == CAL_RUNNING ||
 	     currCal->calState == CAL_WAITING)) {
 		iscaldone = ar9002_hw_per_calibration(ah, chan,
@@ -704,7 +709,7 @@ static bool ar9002_hw_calibrate(struct ath_hw *ah,
 	}
 
 	/* Do NF cal only at longer intervals */
-	if (longcal) {
+	if (longcal || nfcal_pending) {
 		/* Do periodic PAOffset Cal */
 		ar9002_hw_pa_cal(ah, false);
 		ar9002_hw_olc_temp_compensation(ah);
@@ -713,16 +718,18 @@ static bool ar9002_hw_calibrate(struct ath_hw *ah,
 		 * Get the value from the previous NF cal and update
 		 * history buffer.
 		 */
-		ath9k_hw_getnf(ah, chan);
-
-		/*
-		 * Load the NF from history buffer of the current channel.
-		 * NF is slow time-variant, so it is OK to use a historical
-		 * value.
-		 */
-		ath9k_hw_loadnf(ah, ah->curchan);
+		if (ath9k_hw_getnf(ah, chan)) {
+			/*
+			 * Load the NF from history buffer of the current
+			 * channel.
+			 * NF is slow time-variant, so it is OK to use a
+			 * historical value.
+			 */
+			ath9k_hw_loadnf(ah, ah->curchan);
+		}
 
-		ath9k_hw_start_nfcal(ah, false);
+		if (longcal)
+			ath9k_hw_start_nfcal(ah, false);
 	}
 
 	return iscaldone;
@@ -872,6 +879,9 @@ static bool ar9002_hw_init_cal(struct ath_hw *ah, struct ath9k_channel *chan)
 	/* Do NF Calibration after DC offset and other calibrations */
 	ath9k_hw_start_nfcal(ah, true);
 
+	if (ah->caldata)
+		ah->caldata->nfcal_pending = true;
+
 	ah->cal_list = ah->cal_list_last = ah->cal_list_curr = NULL;
 
 	/* Enable IQ, ADC Gain and ADC DC offset CALs */
diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 18b5c0d..4520869 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -156,6 +156,9 @@ EXPORT_SYMBOL(ath9k_hw_reset_calvalid);
 
 void ath9k_hw_start_nfcal(struct ath_hw *ah, bool update)
 {
+	if (ah->caldata)
+		ah->caldata->nfcal_pending = true;
+
 	REG_SET_BIT(ah, AR_PHY_AGC_CONTROL,
 		    AR_PHY_AGC_CONTROL_ENABLE_NF);
 
@@ -288,8 +291,7 @@ static void ath9k_hw_nf_sanitize(struct ath_hw *ah, s16 *nf)
 	}
 }
 
-int16_t ath9k_hw_getnf(struct ath_hw *ah,
-		       struct ath9k_channel *chan)
+bool ath9k_hw_getnf(struct ath_hw *ah, struct ath9k_channel *chan)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 	int16_t nf, nfThresh;
@@ -299,7 +301,7 @@ int16_t ath9k_hw_getnf(struct ath_hw *ah,
 	struct ath9k_hw_cal_data *caldata = ah->caldata;
 
 	if (!caldata)
-		return ath9k_hw_get_default_nf(ah, chan);
+		return false;
 
 	chan->channelFlags &= (~CHANNEL_CW_INT);
 	if (REG_READ(ah, AR_PHY_AGC_CONTROL) & AR_PHY_AGC_CONTROL_NF) {
@@ -307,7 +309,7 @@ int16_t ath9k_hw_getnf(struct ath_hw *ah,
 			  "NF did not complete in calibration window\n");
 		nf = 0;
 		caldata->rawNoiseFloor = nf;
-		return caldata->rawNoiseFloor;
+		return false;
 	} else {
 		ath9k_hw_do_getnf(ah, nfarray);
 		ath9k_hw_nf_sanitize(ah, nfarray);
@@ -323,11 +325,10 @@ int16_t ath9k_hw_getnf(struct ath_hw *ah,
 	}
 
 	h = caldata->nfCalHist;
-
+	caldata->nfcal_pending = false;
 	ath9k_hw_update_nfcal_hist_buffer(h, nfarray);
 	caldata->rawNoiseFloor = h[0].privNF;
-
-	return ah->caldata->rawNoiseFloor;
+	return true;
 }
 
 void ath9k_init_nfcal_hist_buffer(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/calib.h b/drivers/net/wireless/ath/ath9k/calib.h
index ca2e6b3..0a304b3 100644
--- a/drivers/net/wireless/ath/ath9k/calib.h
+++ b/drivers/net/wireless/ath/ath9k/calib.h
@@ -110,8 +110,7 @@ struct ath9k_pacal_info{
 bool ath9k_hw_reset_calvalid(struct ath_hw *ah);
 void ath9k_hw_start_nfcal(struct ath_hw *ah, bool update);
 void ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan);
-int16_t ath9k_hw_getnf(struct ath_hw *ah,
-		       struct ath9k_channel *chan);
+bool ath9k_hw_getnf(struct ath_hw *ah, struct ath9k_channel *chan);
 void ath9k_init_nfcal_hist_buffer(struct ath_hw *ah,
 				  struct ath9k_channel *chan);
 s16 ath9k_hw_getchan_noise(struct ath_hw *ah, struct ath9k_channel *chan);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index c1b7011..399f7c1 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -354,6 +354,7 @@ struct ath9k_hw_cal_data {
 	int8_t qCoff;
 	int16_t rawNoiseFloor;
 	bool paprd_done;
+	bool nfcal_pending;
 	u16 small_signal_gain[AR9300_MAX_CHAINS];
 	u32 pa_table[AR9300_MAX_CHAINS][PAPRD_TABLE_SZ];
 	struct ath9k_nfcal_hist nfCalHist[NUM_NF_READINGS];
-- 
1.6.4.2

