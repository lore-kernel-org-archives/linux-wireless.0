Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41099 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130Ab0CQW2P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 18:28:15 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 06/20] ath9k_hw: move calibration settings to ar9002_calib_settings.c
Date: Wed, 17 Mar 2010 18:27:59 -0400
Message-Id: <1268864893-11428-7-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1268864893-11428-1-git-send-email-lrodriguez@atheros.com>
References: <1268864893-11428-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we now have all the calibration functions and structures
on ar9002_calib_settings.c we might as well move the function
that sets these up there as well.

While at it, simplify it a little and also move the AR9100
calibration settings there too since they were just dangling
on a random place on __ath9k_hw_init().

Doing this lets us remove the externs on the structures
saving ourselves about 272 bytes mostly on the text area
of ath9k_hw:

Before:
3746008 bytes ath9k_hw.ko
   text    data     bss     dec     hex filename
 221433    1088    1808  224329   36c49 ath9k_hw.ko

After:
3745736 bytes ath9k_hw.ko
   text    data     bss     dec     hex filename
 221417    1088    1808  224313   36c39 ath9k_hw.ko

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_calib.c      |    3 +
 .../net/wireless/ath/ath9k/ar9002_calib_settings.c |   52 +++++++++++++++++---
 drivers/net/wireless/ath/ath9k/ar9002_hw.c         |   25 ---------
 drivers/net/wireless/ath/ath9k/calib.h             |    8 ---
 drivers/net/wireless/ath/ath9k/hw.c                |    5 +--
 5 files changed, 49 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
index bec0467..0313121 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -22,6 +22,8 @@
  * the chipsets under the hardware families: AR5008, AR9001, and AR9002
  */
 
+extern void ar9002_hw_init_cal_settings(struct ath_hw *ah);
+
 static void ar9002_hw_do_getnf(struct ath_hw *ah,
 			      int16_t nfarray[NUM_NF_READINGS])
 {
@@ -820,4 +822,5 @@ void ar9002_hw_attach_calib_ops(struct ath_hw *ah)
 	priv_ops->loadnf = &ar9002_hw_loadnf;
 	priv_ops->start_nfcal = &ar9002_hw_start_nfcal;
 	priv_ops->pa_cal = &ar9002_hw_pa_cal;
+	priv_ops->init_cal_settings = &ar9002_hw_init_cal_settings;
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib_settings.c b/drivers/net/wireless/ath/ath9k/ar9002_calib_settings.c
index c22f6c3..b301b59 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib_settings.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib_settings.c
@@ -127,7 +127,7 @@ static void ar9002_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
 		    AR_PHY_TIMING_CTRL4_IQCORR_ENABLE);
 }
 
-const struct ath9k_percal_data iq_cal_multi_sample = {
+static const struct ath9k_percal_data iq_cal_multi_sample = {
 	IQ_MISMATCH_CAL,
 	MAX_CAL_SAMPLES,
 	PER_MIN_LOG_COUNT,
@@ -135,7 +135,7 @@ const struct ath9k_percal_data iq_cal_multi_sample = {
 	ar9002_hw_iqcalibrate
 };
 
-const struct ath9k_percal_data iq_cal_single_sample = {
+static const struct ath9k_percal_data iq_cal_single_sample = {
 	IQ_MISMATCH_CAL,
 	MIN_CAL_SAMPLES,
 	PER_MAX_LOG_COUNT,
@@ -226,7 +226,7 @@ static void ar9002_hw_adc_gaincal_calibrate(struct ath_hw *ah, u8 numChains)
 		  AR_PHY_NEW_ADC_GAIN_CORR_ENABLE);
 }
 
-const struct ath9k_percal_data adc_gain_cal_multi_sample = {
+static const struct ath9k_percal_data adc_gain_cal_multi_sample = {
 	ADC_GAIN_CAL,
 	MAX_CAL_SAMPLES,
 	PER_MIN_LOG_COUNT,
@@ -234,7 +234,7 @@ const struct ath9k_percal_data adc_gain_cal_multi_sample = {
 	ar9002_hw_adc_gaincal_calibrate
 };
 
-const struct ath9k_percal_data adc_gain_cal_single_sample = {
+static const struct ath9k_percal_data adc_gain_cal_single_sample = {
 	ADC_GAIN_CAL,
 	MIN_CAL_SAMPLES,
 	PER_MAX_LOG_COUNT,
@@ -325,7 +325,7 @@ static void ar9002_hw_adc_dccal_calibrate(struct ath_hw *ah, u8 numChains)
 		  AR_PHY_NEW_ADC_DC_OFFSET_CORR_ENABLE);
 }
 
-const struct ath9k_percal_data adc_dc_cal_multi_sample = {
+static const struct ath9k_percal_data adc_dc_cal_multi_sample = {
 	ADC_DC_CAL,
 	MAX_CAL_SAMPLES,
 	PER_MIN_LOG_COUNT,
@@ -333,7 +333,7 @@ const struct ath9k_percal_data adc_dc_cal_multi_sample = {
 	ar9002_hw_adc_dccal_calibrate
 };
 
-const struct ath9k_percal_data adc_dc_cal_single_sample = {
+static const struct ath9k_percal_data adc_dc_cal_single_sample = {
 	ADC_DC_CAL,
 	MIN_CAL_SAMPLES,
 	PER_MAX_LOG_COUNT,
@@ -341,10 +341,48 @@ const struct ath9k_percal_data adc_dc_cal_single_sample = {
 	ar9002_hw_adc_dccal_calibrate
 };
 
-const struct ath9k_percal_data adc_init_dc_cal = {
+static const struct ath9k_percal_data adc_init_dc_cal = {
 	ADC_DC_INIT_CAL,
 	MIN_CAL_SAMPLES,
 	INIT_LOG_COUNT,
 	ar9002_hw_adc_dccal_collect,
 	ar9002_hw_adc_dccal_calibrate
 };
+
+static void ar9002_hw_setup_calib_single(struct ath_hw *ah)
+{
+	ah->iq_caldata.calData = &iq_cal_single_sample;
+	ah->adcgain_caldata.calData =
+		&adc_gain_cal_single_sample;
+	ah->adcdc_caldata.calData =
+		&adc_dc_cal_single_sample;
+	ah->adcdc_calinitdata.calData =
+		&adc_init_dc_cal;
+}
+
+static void ar9002_hw_setup_calib_multi(struct ath_hw *ah)
+{
+	ah->iq_caldata.calData = &iq_cal_multi_sample;
+	ah->adcgain_caldata.calData =
+		&adc_gain_cal_multi_sample;
+	ah->adcdc_caldata.calData =
+		&adc_dc_cal_multi_sample;
+	ah->adcdc_calinitdata.calData =
+		&adc_init_dc_cal;
+}
+
+void ar9002_hw_init_cal_settings(struct ath_hw *ah)
+{
+	if (AR_SREV_9160_10_OR_LATER(ah)) {
+		if (AR_SREV_9280_10_OR_LATER(ah))
+			ar9002_hw_setup_calib_single(ah);
+		else
+			ar9002_hw_setup_calib_multi(ah);
+		ah->supp_cals = ADC_GAIN_CAL | ADC_DC_CAL | IQ_MISMATCH_CAL;
+	}
+
+	if (AR_SREV_9100(ah)) {
+		ah->iq_caldata.calData = &iq_cal_multi_sample;
+		ah->supp_cals = IQ_MISMATCH_CAL;
+        }
+}
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index 5a8da22..7c46c1e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -55,30 +55,6 @@ static bool ar9002_hw_macversion_supported(u32 macversion)
 	return false;
 }
 
-static void ar9002_hw_init_cal_settings(struct ath_hw *ah)
-{
-	if (AR_SREV_9160_10_OR_LATER(ah)) {
-		if (AR_SREV_9280_10_OR_LATER(ah)) {
-			ah->iq_caldata.calData = &iq_cal_single_sample;
-			ah->adcgain_caldata.calData =
-				&adc_gain_cal_single_sample;
-			ah->adcdc_caldata.calData =
-				&adc_dc_cal_single_sample;
-			ah->adcdc_calinitdata.calData =
-				&adc_init_dc_cal;
-		} else {
-			ah->iq_caldata.calData = &iq_cal_multi_sample;
-			ah->adcgain_caldata.calData =
-				&adc_gain_cal_multi_sample;
-			ah->adcdc_caldata.calData =
-				&adc_dc_cal_multi_sample;
-			ah->adcdc_calinitdata.calData =
-				&adc_init_dc_cal;
-		}
-		ah->supp_cals = ADC_GAIN_CAL | ADC_DC_CAL | IQ_MISMATCH_CAL;
-	}
-}
-
 static void ar9002_hw_init_mode_regs(struct ath_hw *ah)
 {
 	if (AR_SREV_9271(ah)) {
@@ -824,7 +800,6 @@ void ar9002_hw_attach_ops(struct ath_hw *ah)
 	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
 	struct ath_hw_ops *ops = ath9k_hw_ops(ah);
 
-	priv_ops->init_cal_settings = &ar9002_hw_init_cal_settings;
 	priv_ops->init_mode_regs = &ar9002_hw_init_mode_regs;
 	priv_ops->macversion_supported = &ar9002_hw_macversion_supported;
 	priv_ops->set_reset_reg = &ar9002_hw_set_reset_reg;
diff --git a/drivers/net/wireless/ath/ath9k/calib.h b/drivers/net/wireless/ath/ath9k/calib.h
index 039c247..9d647db 100644
--- a/drivers/net/wireless/ath/ath9k/calib.h
+++ b/drivers/net/wireless/ath/ath9k/calib.h
@@ -19,14 +19,6 @@
 
 #include "hw.h"
 
-extern const struct ath9k_percal_data iq_cal_multi_sample;
-extern const struct ath9k_percal_data iq_cal_single_sample;
-extern const struct ath9k_percal_data adc_gain_cal_multi_sample;
-extern const struct ath9k_percal_data adc_gain_cal_single_sample;
-extern const struct ath9k_percal_data adc_dc_cal_multi_sample;
-extern const struct ath9k_percal_data adc_dc_cal_single_sample;
-extern const struct ath9k_percal_data adc_init_dc_cal;
-
 #define AR_PHY_CCA_MAX_AR5416_GOOD_VALUE	-85
 #define AR_PHY_CCA_MAX_AR9280_GOOD_VALUE	-112
 #define AR_PHY_CCA_MAX_AR9285_GOOD_VALUE	-118
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 2a63b42..8d376ce 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -535,11 +535,8 @@ int __ath9k_hw_init(struct ath_hw *ah)
 		return -EOPNOTSUPP;
 	}
 
-	if (AR_SREV_9100(ah)) {
-		ah->iq_caldata.calData = &iq_cal_multi_sample;
-		ah->supp_cals = IQ_MISMATCH_CAL;
+	if (AR_SREV_9100(ah))
 		ah->is_pciexpress = false;
-	}
 
 	if (AR_SREV_9271(ah))
 		ah->is_pciexpress = false;
-- 
1.6.3.3

