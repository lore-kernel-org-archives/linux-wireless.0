Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:57290 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706Ab0I3XqP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 19:46:15 -0400
Message-ID: <4CA52145.6050200@openwrt.org>
Date: Fri, 01 Oct 2010 01:46:13 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] ath9k_hw: remove some useless calibration data
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The percal struct and bitmask for the initial DC calibration are not
used anywhere, so they can be removed.

Signed-off-by: Felix Fietkau <nbd@openwrt.org
---
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -45,11 +45,6 @@ static void ar9002_hw_setup_calibration(
 		ath_print(common, ATH_DBG_CALIBRATE,
 			  "starting ADC DC Calibration\n");
 		break;
-	case ADC_DC_INIT_CAL:
-		REG_WRITE(ah, AR_PHY_CALMODE, AR_PHY_CALMODE_ADC_DC_INIT);
-		ath_print(common, ATH_DBG_CALIBRATE,
-			  "starting Init ADC DC Calibration\n");
-		break;
 	case TEMP_COMP_CAL:
 		break; /* Not supported */
 	}
@@ -950,13 +945,6 @@ static const struct ath9k_percal_data ad
 	ar9002_hw_adc_dccal_collect,
 	ar9002_hw_adc_dccal_calibrate
 };
-static const struct ath9k_percal_data adc_init_dc_cal = {
-	ADC_DC_INIT_CAL,
-	MIN_CAL_SAMPLES,
-	INIT_LOG_COUNT,
-	ar9002_hw_adc_dccal_collect,
-	ar9002_hw_adc_dccal_calibrate
-};
 
 static void ar9002_hw_init_cal_settings(struct ath_hw *ah)
 {
@@ -973,16 +961,12 @@ static void ar9002_hw_init_cal_settings(
 				&adc_gain_cal_single_sample;
 			ah->adcdc_caldata.calData =
 				&adc_dc_cal_single_sample;
-			ah->adcdc_calinitdata.calData =
-				&adc_init_dc_cal;
 		} else {
 			ah->iq_caldata.calData = &iq_cal_multi_sample;
 			ah->adcgain_caldata.calData =
 				&adc_gain_cal_multi_sample;
 			ah->adcdc_caldata.calData =
 				&adc_dc_cal_multi_sample;
-			ah->adcdc_calinitdata.calData =
-				&adc_init_dc_cal;
 		}
 		ah->supp_cals = ADC_GAIN_CAL | ADC_DC_CAL | IQ_MISMATCH_CAL;
 	}
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -50,7 +50,6 @@ static void ar9003_hw_setup_calibration(
 		ath_print(common, ATH_DBG_CALIBRATE,
 			  "starting Temperature Compensation Calibration\n");
 		break;
-	case ADC_DC_INIT_CAL:
 	case ADC_GAIN_CAL:
 	case ADC_DC_CAL:
 		/* Not yet */
--- a/drivers/net/wireless/ath/ath9k/calib.h
+++ b/drivers/net/wireless/ath/ath9k/calib.h
@@ -59,7 +59,6 @@ struct ar5416IniArray {
 	} while (0)
 
 enum ath9k_cal_types {
-	ADC_DC_INIT_CAL = 0x1,
 	ADC_GAIN_CAL = 0x2,
 	ADC_DC_CAL = 0x4,
 	IQ_MISMATCH_CAL = 0x8,
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -692,7 +692,6 @@ struct ath_hw {
 	enum ath9k_cal_types supp_cals;
 	struct ath9k_cal_list iq_caldata;
 	struct ath9k_cal_list adcgain_caldata;
-	struct ath9k_cal_list adcdc_calinitdata;
 	struct ath9k_cal_list adcdc_caldata;
 	struct ath9k_cal_list tempCompCalData;
 	struct ath9k_cal_list *cal_list;
