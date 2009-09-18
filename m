Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:44848 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbZIRJdf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2009 05:33:35 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2009 02:33:40 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19123.21494.461882.467644@gargle.gargle.HOWL>
Date: Fri, 18 Sep 2009 15:03:42 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH/REVIEW 1/9] ath9k: Add Calibration checks
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vivek Natarajan <vnatarajan@atheros.com>

* Prevent divide-by-zero errors in IQ Calibration.
* Do not run temperature compensation if initPDADC or currPDADC is zero.
* Also, introduce a separate function for handling OLC for AR9287.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/calib.c |   78 ++++++++++++++++++++-----------
 1 files changed, 50 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 36c5f89..9c46b54 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -403,7 +403,8 @@ static void ath9k_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
 		iCoffDenom = (powerMeasI / 2 + powerMeasQ / 2) / 128;
 		qCoffDenom = powerMeasQ / 64;
 
-		if (powerMeasQ != 0) {
+		if ((powerMeasQ != 0) && (iCoffDenom != 0) &&
+		    (qCoffDenom != 0)) {
 			iCoff = iqCorrMeas / iCoffDenom;
 			qCoff = powerMeasI / qCoffDenom - 64;
 			ath_print(common, ATH_DBG_CALIBRATE,
@@ -746,44 +747,65 @@ s16 ath9k_hw_getchan_noise(struct ath_hw *ah, struct ath9k_channel *chan)
 	return nf;
 }
 
-static void ath9k_olc_temp_compensation(struct ath_hw *ah)
+static void ath9k_olc_temp_compensation_9287(struct ath_hw *ah)
 {
-	u32 rddata, i;
-	int delta, currPDADC, regval, slope;
+	u32 rddata;
+	int32_t delta, currPDADC, slope;
 
 	rddata = REG_READ(ah, AR_PHY_TX_PWRCTRL4);
 	currPDADC = MS(rddata, AR_PHY_TX_PWRCTRL_PD_AVG_OUT);
 
+	if (ah->initPDADC == 0 || currPDADC == 0) {
+		/*
+		 * Zero value indicates that no frames have been transmitted yet,
+		 * can't do temperature compensation until frames are transmitted.
+		 */
+		return;
+	} else {
+		slope = ah->eep_ops->get_eeprom(ah, EEP_TEMPSENSE_SLOPE);
+
+		if (slope == 0) { /* to avoid divide by zero case */
+			delta = 0;
+		} else {
+			delta = ((currPDADC - ah->initPDADC)*4) / slope;
+		}
+		REG_RMW_FIELD(ah, AR_PHY_CH0_TX_PWRCTRL11,
+			      AR_PHY_TX_PWRCTRL_OLPC_TEMP_COMP, delta);
+		REG_RMW_FIELD(ah, AR_PHY_CH1_TX_PWRCTRL11,
+			      AR_PHY_TX_PWRCTRL_OLPC_TEMP_COMP, delta);
+	}
+}
+
+static void ath9k_olc_temp_compensation(struct ath_hw *ah)
+{
+	u32 rddata, i;
+	int delta, currPDADC, regval;
 
 	if (OLC_FOR_AR9287_10_LATER) {
+		ath9k_olc_temp_compensation_9287(ah);
+	} else {
+		rddata = REG_READ(ah, AR_PHY_TX_PWRCTRL4);
+		currPDADC = MS(rddata, AR_PHY_TX_PWRCTRL_PD_AVG_OUT);
+
 		if (ah->initPDADC == 0 || currPDADC == 0) {
 			return;
 		} else {
-			slope = ah->eep_ops->get_eeprom(ah, EEP_TEMPSENSE_SLOPE);
-			if (slope == 0)
-				delta = 0;
+			if (ah->eep_ops->get_eeprom(ah, EEP_DAC_HPWR_5G))
+				delta = (currPDADC - ah->initPDADC + 4) / 8;
 			else
-				delta = ((currPDADC - ah->initPDADC)*4) / slope;
-			REG_RMW_FIELD(ah, AR_PHY_CH0_TX_PWRCTRL11,
-					AR_PHY_TX_PWRCTRL_OLPC_TEMP_COMP, delta);
-			REG_RMW_FIELD(ah, AR_PHY_CH1_TX_PWRCTRL11,
-					AR_PHY_TX_PWRCTRL_OLPC_TEMP_COMP, delta);
-		}
-	} else {
-		if (ah->eep_ops->get_eeprom(ah, EEP_DAC_HPWR_5G))
-			delta = (currPDADC - ah->initPDADC + 4) / 8;
-		else
-			delta = (currPDADC - ah->initPDADC + 5) / 10;
-
-		if (delta != ah->PDADCdelta) {
-			ah->PDADCdelta = delta;
-			for (i = 1; i < AR9280_TX_GAIN_TABLE_SIZE; i++) {
-				regval = ah->originalGain[i] - delta;
-				if (regval < 0)
-					regval = 0;
-
-				REG_RMW_FIELD(ah, AR_PHY_TX_GAIN_TBL1 + i * 4,
-						AR_PHY_TX_GAIN, regval);
+				delta = (currPDADC - ah->initPDADC + 5) / 10;
+
+			if (delta != ah->PDADCdelta) {
+				ah->PDADCdelta = delta;
+				for (i = 1; i < AR9280_TX_GAIN_TABLE_SIZE; i++) {
+					regval = ah->originalGain[i] - delta;
+					if (regval < 0)
+						regval = 0;
+
+					REG_RMW_FIELD(ah,
+						      AR_PHY_TX_GAIN_TBL1 + i * 4,
+						      AR_PHY_TX_GAIN, regval);
+				}
 			}
 		}
 	}
-- 
1.6.4.4

