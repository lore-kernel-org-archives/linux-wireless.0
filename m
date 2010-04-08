Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46925 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933271Ab0DHT1q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:46 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 065/102] ath9k_hw: fill in the callbacks for calibration for AR9003
Date: Thu,  8 Apr 2010 15:27:01 -0400
Message-Id: <1270754858-26266-66-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_calib.c |    2 +
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |   36 ++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/calib.h        |    3 +-
 3 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
index a4abe9c..4237269 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -50,6 +50,8 @@ static void ar9002_hw_setup_calibration(struct ath_hw *ah,
 		ath_print(common, ATH_DBG_CALIBRATE,
 			  "starting Init ADC DC Calibration\n");
 		break;
+	case TEMP_COMP_CAL:
+		break; /* Not supported */
 	}
 
 	REG_SET_BIT(ah, AR_PHY_TIMING_CTRL4(0),
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index b46834f..ea151ee 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -21,7 +21,41 @@
 static void ar9003_hw_setup_calibration(struct ath_hw *ah,
 					struct ath9k_cal_list *currCal)
 {
-	/* TODO */
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	/* Select calibration to run */
+	switch(currCal->calData->calType) {
+	case IQ_MISMATCH_CAL:
+		/*
+		 * Start calibration with
+		 * 2^(INIT_IQCAL_LOG_COUNT_MAX+1) samples
+		 */
+		REG_RMW_FIELD(ah, AR_PHY_TIMING4,
+			      AR_PHY_TIMING4_IQCAL_LOG_COUNT_MAX,
+		currCal->calData->calCountMax);
+		REG_WRITE(ah, AR_PHY_CALMODE, AR_PHY_CALMODE_IQ);
+
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "starting IQ Mismatch Calibration\n");
+
+		/* Kick-off cal */
+		REG_SET_BIT(ah, AR_PHY_TIMING4, AR_PHY_TIMING4_DO_CAL);
+		break;
+	case TEMP_COMP_CAL:
+		REG_RMW_FIELD(ah, AR_PHY_65NM_CH0_THERM,
+			      AR_PHY_65NM_CH0_THERM_LOCAL, 1);
+		REG_RMW_FIELD(ah, AR_PHY_65NM_CH0_THERM,
+			      AR_PHY_65NM_CH0_THERM_START, 1);
+
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "starting Temperature Compensation Calibration\n");
+		break;
+	case ADC_DC_INIT_CAL:
+	case ADC_GAIN_CAL:
+	case ADC_DC_CAL:
+		/* Not yet */
+		break;
+	}
 }
 
 static bool ar9003_hw_calibrate(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/calib.h b/drivers/net/wireless/ath/ath9k/calib.h
index 25828e8..24538bd 100644
--- a/drivers/net/wireless/ath/ath9k/calib.h
+++ b/drivers/net/wireless/ath/ath9k/calib.h
@@ -68,7 +68,8 @@ enum ath9k_cal_types {
 	ADC_DC_INIT_CAL = 0x1,
 	ADC_GAIN_CAL = 0x2,
 	ADC_DC_CAL = 0x4,
-	IQ_MISMATCH_CAL = 0x8
+	IQ_MISMATCH_CAL = 0x8,
+	TEMP_COMP_CAL = 0x10,
 };
 
 enum ath9k_cal_state {
-- 
1.6.3.3

