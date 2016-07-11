Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56429 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932162AbcGKKCx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2016 06:02:53 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 4/4] ath9k_hw: implement temperature compensation support for AR9003+
Date: Mon, 11 Jul 2016 12:02:48 +0200
Message-Id: <20160711100248.68678-4-nbd@nbd.name> (sfid-20160711_120522_951012_EF6C8642)
In-Reply-To: <20160711100248.68678-1-nbd@nbd.name>
References: <20160711100248.68678-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 25 ++++++++++++++++++++++---
 drivers/net/wireless/ath/ath9k/hw.h           |  1 +
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 7e27a06..b6f064a 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -33,6 +33,7 @@ struct coeff {
 
 enum ar9003_cal_types {
 	IQ_MISMATCH_CAL = BIT(0),
+	TEMP_COMP_CAL = BIT(1),
 };
 
 static void ar9003_hw_setup_calibration(struct ath_hw *ah,
@@ -58,6 +59,12 @@ static void ar9003_hw_setup_calibration(struct ath_hw *ah,
 		/* Kick-off cal */
 		REG_SET_BIT(ah, AR_PHY_TIMING4, AR_PHY_TIMING4_DO_CAL);
 		break;
+	case TEMP_COMP_CAL:
+		ath_dbg(common, CALIBRATE,
+			"starting Temperature Compensation Calibration\n");
+		REG_SET_BIT(ah, AR_CH0_THERM, AR_CH0_THERM_LOCAL);
+		REG_SET_BIT(ah, AR_CH0_THERM, AR_CH0_THERM_START);
+		break;
 	default:
 		ath_err(common, "Invalid calibration type\n");
 		break;
@@ -86,7 +93,8 @@ static bool ar9003_hw_per_calibration(struct ath_hw *ah,
 		/*
 		* Accumulate cal measures for active chains
 		*/
-		cur_caldata->calCollect(ah);
+		if (cur_caldata->calCollect)
+			cur_caldata->calCollect(ah);
 		ah->cal_samples++;
 
 		if (ah->cal_samples >= cur_caldata->calNumSamples) {
@@ -99,7 +107,8 @@ static bool ar9003_hw_per_calibration(struct ath_hw *ah,
 			/*
 			* Process accumulated data
 			*/
-			cur_caldata->calPostProc(ah, numChains);
+			if (cur_caldata->calPostProc)
+				cur_caldata->calPostProc(ah, numChains);
 
 			/* Calibration has finished. */
 			caldata->CalValid |= cur_caldata->calType;
@@ -314,9 +323,16 @@ static const struct ath9k_percal_data iq_cal_single_sample = {
 	ar9003_hw_iqcalibrate
 };
 
+static const struct ath9k_percal_data temp_cal_single_sample = {
+	TEMP_COMP_CAL,
+	MIN_CAL_SAMPLES,
+	PER_MAX_LOG_COUNT,
+};
+
 static void ar9003_hw_init_cal_settings(struct ath_hw *ah)
 {
 	ah->iq_caldata.calData = &iq_cal_single_sample;
+	ah->temp_caldata.calData = &temp_cal_single_sample;
 
 	if (AR_SREV_9300_20_OR_LATER(ah)) {
 		ah->enabled_cals |= TX_IQ_CAL;
@@ -324,7 +340,7 @@ static void ar9003_hw_init_cal_settings(struct ath_hw *ah)
 			ah->enabled_cals |= TX_IQ_ON_AGC_CAL;
 	}
 
-	ah->supp_cals = IQ_MISMATCH_CAL;
+	ah->supp_cals = IQ_MISMATCH_CAL | TEMP_COMP_CAL;
 }
 
 #define OFF_UPPER_LT 24
@@ -1383,6 +1399,9 @@ static void ar9003_hw_init_cal_common(struct ath_hw *ah)
 	INIT_CAL(&ah->iq_caldata);
 	INSERT_CAL(ah, &ah->iq_caldata);
 
+	INIT_CAL(&ah->temp_caldata);
+	INSERT_CAL(ah, &ah->temp_caldata);
+
 	/* Initialize current pointer to first element in list */
 	ah->cal_list_curr = ah->cal_list;
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 9cbca12..2a5d3ad 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -830,6 +830,7 @@ struct ath_hw {
 	/* Calibration */
 	u32 supp_cals;
 	struct ath9k_cal_list iq_caldata;
+	struct ath9k_cal_list temp_caldata;
 	struct ath9k_cal_list adcgain_caldata;
 	struct ath9k_cal_list adcdc_caldata;
 	struct ath9k_cal_list *cal_list;
-- 
2.8.4

