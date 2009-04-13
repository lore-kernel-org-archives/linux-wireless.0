Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54222 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833AbZDMQbZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 12:31:25 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2009 09:31:25 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18915.26579.173650.253119@gargle.gargle.HOWL> (sfid-20090413_183128_438691_0791BCE8)
Date: Mon, 13 Apr 2009 21:56:59 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 10/11] ath9k: Fix bug in calibration initialization
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a bug in ath9k_hw_init_cal() where the wrong
calibration was being done for non-AR9285 chipsets.
Also add a few helpful comments.

Cc: stable@kernel.org
Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/calib.c |   61 +++++++++++--------------------
 1 files changed, 22 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 67375ad..08f6902 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -918,83 +918,66 @@ static bool ar9285_clc(struct ath_hw *ah, struct ath9k_channel *chan)
 	return true;
 }
 
-bool ath9k_hw_init_cal(struct ath_hw *ah,
-		       struct ath9k_channel *chan)
+bool ath9k_hw_init_cal(struct ath_hw *ah, struct ath9k_channel *chan)
 {
 	if (AR_SREV_9285(ah) && AR_SREV_9285_12_OR_LATER(ah)) {
 		if (!ar9285_clc(ah, chan))
 			return false;
-	} else if (AR_SREV_9280_10_OR_LATER(ah)) {
-		REG_CLR_BIT(ah, AR_PHY_ADC_CTL, AR_PHY_ADC_CTL_OFF_PWDADC);
-		REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_FLTR_CAL);
-		REG_CLR_BIT(ah, AR_PHY_CL_CAL_CTL, AR_PHY_CL_CAL_ENABLE);
+	} else {
+		if (AR_SREV_9280_10_OR_LATER(ah)) {
+			REG_CLR_BIT(ah, AR_PHY_ADC_CTL, AR_PHY_ADC_CTL_OFF_PWDADC);
+			REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_FLTR_CAL);
+		}
 
-		/* Kick off the cal */
+		/* Calibrate the AGC */
 		REG_WRITE(ah, AR_PHY_AGC_CONTROL,
-				REG_READ(ah, AR_PHY_AGC_CONTROL) |
-				AR_PHY_AGC_CONTROL_CAL);
+			  REG_READ(ah, AR_PHY_AGC_CONTROL) |
+			  AR_PHY_AGC_CONTROL_CAL);
 
-		if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL,
-					AR_PHY_AGC_CONTROL_CAL, 0,
-					AH_WAIT_TIMEOUT)) {
+		/* Poll for offset calibration complete */
+		if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_CAL,
+				   0, AH_WAIT_TIMEOUT)) {
 			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 				"offset calibration failed to complete in 1ms; "
 				"noisy environment?\n");
 			return false;
 		}
 
-		REG_CLR_BIT(ah, AR_PHY_ADC_CTL, AR_PHY_ADC_CTL_OFF_PWDADC);
-		REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_FLTR_CAL);
-		REG_SET_BIT(ah, AR_PHY_CL_CAL_CTL, AR_PHY_CL_CAL_ENABLE);
-	}
-
-	/* Calibrate the AGC */
-	REG_WRITE(ah, AR_PHY_AGC_CONTROL,
-			REG_READ(ah, AR_PHY_AGC_CONTROL) |
-			AR_PHY_AGC_CONTROL_CAL);
-
-	if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_CAL,
-				0, AH_WAIT_TIMEOUT)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
-			"offset calibration failed to complete in 1ms; "
-			"noisy environment?\n");
-		return false;
-	}
-
-	if (AR_SREV_9280_10_OR_LATER(ah)) {
-		REG_SET_BIT(ah, AR_PHY_ADC_CTL, AR_PHY_ADC_CTL_OFF_PWDADC);
-		REG_CLR_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_FLTR_CAL);
+		if (AR_SREV_9280_10_OR_LATER(ah)) {
+			REG_SET_BIT(ah, AR_PHY_ADC_CTL, AR_PHY_ADC_CTL_OFF_PWDADC);
+			REG_CLR_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_FLTR_CAL);
+		}
 	}
 
 	/* Do PA Calibration */
 	if (AR_SREV_9285(ah) && AR_SREV_9285_11_OR_LATER(ah))
 		ath9k_hw_9285_pa_cal(ah);
 
-	/* Do NF Calibration */
+	/* Do NF Calibration after DC offset and other calibrations */
 	REG_WRITE(ah, AR_PHY_AGC_CONTROL,
-			REG_READ(ah, AR_PHY_AGC_CONTROL) |
-			AR_PHY_AGC_CONTROL_NF);
+		  REG_READ(ah, AR_PHY_AGC_CONTROL) | AR_PHY_AGC_CONTROL_NF);
 
 	ah->cal_list = ah->cal_list_last = ah->cal_list_curr = NULL;
 
+	/* Enable IQ, ADC Gain and ADC DC offset CALs */
 	if (AR_SREV_9100(ah) || AR_SREV_9160_10_OR_LATER(ah)) {
 		if (ath9k_hw_iscal_supported(ah, ADC_GAIN_CAL)) {
 			INIT_CAL(&ah->adcgain_caldata);
 			INSERT_CAL(ah, &ah->adcgain_caldata);
 			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
-					"enabling ADC Gain Calibration.\n");
+				"enabling ADC Gain Calibration.\n");
 		}
 		if (ath9k_hw_iscal_supported(ah, ADC_DC_CAL)) {
 			INIT_CAL(&ah->adcdc_caldata);
 			INSERT_CAL(ah, &ah->adcdc_caldata);
 			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
-					"enabling ADC DC Calibration.\n");
+				"enabling ADC DC Calibration.\n");
 		}
 		if (ath9k_hw_iscal_supported(ah, IQ_MISMATCH_CAL)) {
 			INIT_CAL(&ah->iq_caldata);
 			INSERT_CAL(ah, &ah->iq_caldata);
 			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
-					"enabling IQ Calibration.\n");
+				"enabling IQ Calibration.\n");
 		}
 
 		ah->cal_list_curr = ah->cal_list;
-- 
1.6.2.2

