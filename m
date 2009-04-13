Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54221 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401AbZDMQbY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 12:31:24 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2009 09:31:24 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18915.26576.820796.287571@gargle.gargle.HOWL> (sfid-20090413_183127_716375_1A6FE176)
Date: Mon, 13 Apr 2009 21:56:56 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 09/11] ath9k: Use a consistent naming convention
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces old 'hal_' prefixes with 'ath9k_'.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/calib.c |   28 ++++++++++++++--------------
 drivers/net/wireless/ath/ath9k/calib.h |   30 +++++++++++++++---------------
 drivers/net/wireless/ath/ath9k/hw.h    |   16 ++++++++--------
 3 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index a0661bb..67375ad 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -186,7 +186,7 @@ static bool getNoiseFloorThresh(struct ath_hw *ah,
 }
 
 static void ath9k_hw_setup_calibration(struct ath_hw *ah,
-				       struct hal_cal_list *currCal)
+				       struct ath9k_cal_list *currCal)
 {
 	REG_RMW_FIELD(ah, AR_PHY_TIMING_CTRL4(0),
 		      AR_PHY_TIMING_CTRL4_IQCAL_LOG_COUNT_MAX,
@@ -220,7 +220,7 @@ static void ath9k_hw_setup_calibration(struct ath_hw *ah,
 }
 
 static void ath9k_hw_reset_calibration(struct ath_hw *ah,
-				       struct hal_cal_list *currCal)
+				       struct ath9k_cal_list *currCal)
 {
 	int i;
 
@@ -241,7 +241,7 @@ static void ath9k_hw_reset_calibration(struct ath_hw *ah,
 static bool ath9k_hw_per_calibration(struct ath_hw *ah,
 				     struct ath9k_channel *ichan,
 				     u8 rxchainmask,
-				     struct hal_cal_list *currCal)
+				     struct ath9k_cal_list *currCal)
 {
 	bool iscaldone = false;
 
@@ -276,7 +276,7 @@ static bool ath9k_hw_per_calibration(struct ath_hw *ah,
 
 /* Assumes you are talking about the currently configured channel */
 static bool ath9k_hw_iscal_supported(struct ath_hw *ah,
-				     enum hal_cal_types calType)
+				     enum ath9k_cal_types calType)
 {
 	struct ieee80211_conf *conf = &ah->ah_sc->hw->conf;
 
@@ -499,7 +499,7 @@ static void ath9k_hw_adc_dccal_calibrate(struct ath_hw *ah, u8 numChains)
 {
 	u32 iOddMeasOffset, iEvenMeasOffset, val, i;
 	int32_t qOddMeasOffset, qEvenMeasOffset, qDcMismatch, iDcMismatch;
-	const struct hal_percal_data *calData =
+	const struct ath9k_percal_data *calData =
 		ah->cal_list_curr->calData;
 	u32 numSamples =
 		(1 << (calData->calCountMax + 5)) * calData->calNumSamples;
@@ -556,7 +556,7 @@ static void ath9k_hw_adc_dccal_calibrate(struct ath_hw *ah, u8 numChains)
 bool ath9k_hw_reset_calvalid(struct ath_hw *ah)
 {
 	struct ieee80211_conf *conf = &ah->ah_sc->hw->conf;
-	struct hal_cal_list *currCal = ah->cal_list_curr;
+	struct ath9k_cal_list *currCal = ah->cal_list_curr;
 
 	if (!ah->curchan)
 		return true;
@@ -845,7 +845,7 @@ bool ath9k_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
 			u8 rxchainmask, bool longcal)
 {
 	bool iscaldone = true;
-	struct hal_cal_list *currCal = ah->cal_list_curr;
+	struct ath9k_cal_list *currCal = ah->cal_list_curr;
 
 	if (currCal &&
 	    (currCal->calState == CAL_RUNNING ||
@@ -1008,49 +1008,49 @@ bool ath9k_hw_init_cal(struct ath_hw *ah,
 	return true;
 }
 
-const struct hal_percal_data iq_cal_multi_sample = {
+const struct ath9k_percal_data iq_cal_multi_sample = {
 	IQ_MISMATCH_CAL,
 	MAX_CAL_SAMPLES,
 	PER_MIN_LOG_COUNT,
 	ath9k_hw_iqcal_collect,
 	ath9k_hw_iqcalibrate
 };
-const struct hal_percal_data iq_cal_single_sample = {
+const struct ath9k_percal_data iq_cal_single_sample = {
 	IQ_MISMATCH_CAL,
 	MIN_CAL_SAMPLES,
 	PER_MAX_LOG_COUNT,
 	ath9k_hw_iqcal_collect,
 	ath9k_hw_iqcalibrate
 };
-const struct hal_percal_data adc_gain_cal_multi_sample = {
+const struct ath9k_percal_data adc_gain_cal_multi_sample = {
 	ADC_GAIN_CAL,
 	MAX_CAL_SAMPLES,
 	PER_MIN_LOG_COUNT,
 	ath9k_hw_adc_gaincal_collect,
 	ath9k_hw_adc_gaincal_calibrate
 };
-const struct hal_percal_data adc_gain_cal_single_sample = {
+const struct ath9k_percal_data adc_gain_cal_single_sample = {
 	ADC_GAIN_CAL,
 	MIN_CAL_SAMPLES,
 	PER_MAX_LOG_COUNT,
 	ath9k_hw_adc_gaincal_collect,
 	ath9k_hw_adc_gaincal_calibrate
 };
-const struct hal_percal_data adc_dc_cal_multi_sample = {
+const struct ath9k_percal_data adc_dc_cal_multi_sample = {
 	ADC_DC_CAL,
 	MAX_CAL_SAMPLES,
 	PER_MIN_LOG_COUNT,
 	ath9k_hw_adc_dccal_collect,
 	ath9k_hw_adc_dccal_calibrate
 };
-const struct hal_percal_data adc_dc_cal_single_sample = {
+const struct ath9k_percal_data adc_dc_cal_single_sample = {
 	ADC_DC_CAL,
 	MIN_CAL_SAMPLES,
 	PER_MAX_LOG_COUNT,
 	ath9k_hw_adc_dccal_collect,
 	ath9k_hw_adc_dccal_calibrate
 };
-const struct hal_percal_data adc_init_dc_cal = {
+const struct ath9k_percal_data adc_init_dc_cal = {
 	ADC_DC_INIT_CAL,
 	MIN_CAL_SAMPLES,
 	INIT_LOG_COUNT,
diff --git a/drivers/net/wireless/ath/ath9k/calib.h b/drivers/net/wireless/ath/ath9k/calib.h
index ac71ed9..fe5367f 100644
--- a/drivers/net/wireless/ath/ath9k/calib.h
+++ b/drivers/net/wireless/ath/ath9k/calib.h
@@ -17,13 +17,13 @@
 #ifndef CALIB_H
 #define CALIB_H
 
-extern const struct hal_percal_data iq_cal_multi_sample;
-extern const struct hal_percal_data iq_cal_single_sample;
-extern const struct hal_percal_data adc_gain_cal_multi_sample;
-extern const struct hal_percal_data adc_gain_cal_single_sample;
-extern const struct hal_percal_data adc_dc_cal_multi_sample;
-extern const struct hal_percal_data adc_dc_cal_single_sample;
-extern const struct hal_percal_data adc_init_dc_cal;
+extern const struct ath9k_percal_data iq_cal_multi_sample;
+extern const struct ath9k_percal_data iq_cal_single_sample;
+extern const struct ath9k_percal_data adc_gain_cal_multi_sample;
+extern const struct ath9k_percal_data adc_gain_cal_single_sample;
+extern const struct ath9k_percal_data adc_dc_cal_multi_sample;
+extern const struct ath9k_percal_data adc_dc_cal_single_sample;
+extern const struct ath9k_percal_data adc_init_dc_cal;
 
 #define AR_PHY_CCA_MAX_GOOD_VALUE      		-85
 #define AR_PHY_CCA_MAX_HIGH_VALUE      		-62
@@ -67,14 +67,14 @@ struct ar5416IniArray {
 		}							\
 	} while (0)
 
-enum hal_cal_types {
+enum ath9k_cal_types {
 	ADC_DC_INIT_CAL = 0x1,
 	ADC_GAIN_CAL = 0x2,
 	ADC_DC_CAL = 0x4,
 	IQ_MISMATCH_CAL = 0x8
 };
 
-enum hal_cal_state {
+enum ath9k_cal_state {
 	CAL_INACTIVE,
 	CAL_WAITING,
 	CAL_RUNNING,
@@ -87,18 +87,18 @@ enum hal_cal_state {
 #define PER_MIN_LOG_COUNT   2
 #define PER_MAX_LOG_COUNT  10
 
-struct hal_percal_data {
-	enum hal_cal_types calType;
+struct ath9k_percal_data {
+	enum ath9k_cal_types calType;
 	u32 calNumSamples;
 	u32 calCountMax;
 	void (*calCollect) (struct ath_hw *);
 	void (*calPostProc) (struct ath_hw *, u8);
 };
 
-struct hal_cal_list {
-	const struct hal_percal_data *calData;
-	enum hal_cal_state calState;
-	struct hal_cal_list *calNext;
+struct ath9k_cal_list {
+	const struct ath9k_percal_data *calData;
+	enum ath9k_cal_state calState;
+	struct ath9k_cal_list *calNext;
 };
 
 struct ath9k_nfcal_hist {
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 7e37570..ab34126 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -436,14 +436,14 @@ struct ath_hw {
 	enum ath9k_ant_setting diversity_control;
 
 	/* Calibration */
-	enum hal_cal_types supp_cals;
-	struct hal_cal_list iq_caldata;
-	struct hal_cal_list adcgain_caldata;
-	struct hal_cal_list adcdc_calinitdata;
-	struct hal_cal_list adcdc_caldata;
-	struct hal_cal_list *cal_list;
-	struct hal_cal_list *cal_list_last;
-	struct hal_cal_list *cal_list_curr;
+	enum ath9k_cal_types supp_cals;
+	struct ath9k_cal_list iq_caldata;
+	struct ath9k_cal_list adcgain_caldata;
+	struct ath9k_cal_list adcdc_calinitdata;
+	struct ath9k_cal_list adcdc_caldata;
+	struct ath9k_cal_list *cal_list;
+	struct ath9k_cal_list *cal_list_last;
+	struct ath9k_cal_list *cal_list_curr;
 #define totalPowerMeasI meas0.unsign
 #define totalPowerMeasQ meas1.unsign
 #define totalIqCorrMeas meas2.sign
-- 
1.6.2.2

