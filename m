Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plout10-02.prod.sin2.secureserver.net ([182.50.145.5]:55703
	"EHLO sg2plout10-02.prod.sin2.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752006Ab3ACGwa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 01:52:30 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] ath9k_hw: Remove TEMP_COMP_CAL
Date: Thu,  3 Jan 2013 12:21:23 +0530
Message-Id: <1357195883-8516-3-git-send-email-sujith@msujith.org> (sfid-20130103_075235_905857_713921DC)
In-Reply-To: <1357195883-8516-1-git-send-email-sujith@msujith.org>
References: <1357195883-8516-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This is not enabled for any chip and is unused.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 20 +++-----------------
 drivers/net/wireless/ath/ath9k/hw.h           |  1 -
 2 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 303e40d..fa67e84 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -32,7 +32,6 @@ struct coeff {
 
 enum ar9003_cal_types {
 	IQ_MISMATCH_CAL = BIT(0),
-	TEMP_COMP_CAL = BIT(1),
 };
 
 static void ar9003_hw_setup_calibration(struct ath_hw *ah,
@@ -49,7 +48,7 @@ static void ar9003_hw_setup_calibration(struct ath_hw *ah,
 		 */
 		REG_RMW_FIELD(ah, AR_PHY_TIMING4,
 			      AR_PHY_TIMING4_IQCAL_LOG_COUNT_MAX,
-		currCal->calData->calCountMax);
+			      currCal->calData->calCountMax);
 		REG_WRITE(ah, AR_PHY_CALMODE, AR_PHY_CALMODE_IQ);
 
 		ath_dbg(common, CALIBRATE,
@@ -58,14 +57,8 @@ static void ar9003_hw_setup_calibration(struct ath_hw *ah,
 		/* Kick-off cal */
 		REG_SET_BIT(ah, AR_PHY_TIMING4, AR_PHY_TIMING4_DO_CAL);
 		break;
-	case TEMP_COMP_CAL:
-		REG_RMW_FIELD(ah, AR_PHY_65NM_CH0_THERM,
-			      AR_PHY_65NM_CH0_THERM_LOCAL, 1);
-		REG_RMW_FIELD(ah, AR_PHY_65NM_CH0_THERM,
-			      AR_PHY_65NM_CH0_THERM_START, 1);
-
-		ath_dbg(common, CALIBRATE,
-			"starting Temperature Compensation Calibration\n");
+	default:
+		ath_err(common, "Invalid calibration type\n");
 		break;
 	}
 }
@@ -1144,13 +1137,6 @@ skip_tx_iqcal:
 	INSERT_CAL(ah, &ah->iq_caldata);
 	ath_dbg(common, CALIBRATE, "enabling IQ Calibration\n");
 
-	if (ah->supp_cals & TEMP_COMP_CAL) {
-		INIT_CAL(&ah->tempCompCalData);
-		INSERT_CAL(ah, &ah->tempCompCalData);
-		ath_dbg(common, CALIBRATE,
-			"enabling Temperature Compensation Calibration\n");
-	}
-
 	/* Initialize current pointer to first element in list */
 	ah->cal_list_curr = ah->cal_list;
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 7f1a8e9..809599c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -771,7 +771,6 @@ struct ath_hw {
 	struct ath9k_cal_list iq_caldata;
 	struct ath9k_cal_list adcgain_caldata;
 	struct ath9k_cal_list adcdc_caldata;
-	struct ath9k_cal_list tempCompCalData;
 	struct ath9k_cal_list *cal_list;
 	struct ath9k_cal_list *cal_list_last;
 	struct ath9k_cal_list *cal_list_curr;
-- 
1.8.1

