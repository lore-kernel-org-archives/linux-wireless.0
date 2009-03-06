Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:37046 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbZCFFzA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 00:55:00 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 05 Mar 2009 21:54:59 -0800
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>,
	<linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 3/4] ath9k: INI update for AR9285 and periodic PA offset caliberation
Date: Fri, 6 Mar 2009 11:24:10 +0530
Message-ID: <1236318851-7500-4-git-send-email-senthilkumar@atheros.com> (sfid-20090306_065506_088090_AE611D09)
In-Reply-To: <1236318851-7500-3-git-send-email-senthilkumar@atheros.com>
References: <1236318851-7500-1-git-send-email-senthilkumar@atheros.com>
 <1236318851-7500-2-git-send-email-senthilkumar@atheros.com>
 <1236318851-7500-3-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch updates the initvalues for AR9285 chipset and also adds
periodic PA offset caliberation.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath9k/calib.c    |  145 +++++++++++++++++++++-----------
 drivers/net/wireless/ath9k/eeprom.h   |    2 +-
 drivers/net/wireless/ath9k/hw.c       |   20 +++++-
 drivers/net/wireless/ath9k/initvals.h |  107 +++++++++++++++++-------
 drivers/net/wireless/ath9k/phy.h      |    4 +
 5 files changed, 195 insertions(+), 83 deletions(-)

diff --git a/drivers/net/wireless/ath9k/calib.c b/drivers/net/wireless/ath9k/calib.c
index 1c074c0..a652e9b 100644
--- a/drivers/net/wireless/ath9k/calib.c
+++ b/drivers/net/wireless/ath9k/calib.c
@@ -745,43 +745,6 @@ static void ath9k_olc_temp_compensation(struct ath_hw *ah)
 	}
 }
 
-bool ath9k_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
-			u8 rxchainmask, bool longcal,
-			bool *isCalDone)
-{
-	struct hal_cal_list *currCal = ah->cal_list_curr;
-
-	*isCalDone = true;
-
-	if (currCal &&
-	    (currCal->calState == CAL_RUNNING ||
-	     currCal->calState == CAL_WAITING)) {
-		ath9k_hw_per_calibration(ah, chan, rxchainmask, currCal,
-					 isCalDone);
-		if (*isCalDone) {
-			ah->cal_list_curr = currCal = currCal->calNext;
-
-			if (currCal->calState == CAL_WAITING) {
-				*isCalDone = false;
-				ath9k_hw_reset_calibration(ah, currCal);
-			}
-		}
-	}
-
-	if (longcal) {
-		if (OLC_FOR_AR9280_20_LATER)
-			ath9k_olc_temp_compensation(ah);
-		ath9k_hw_getnf(ah, chan);
-		ath9k_hw_loadnf(ah, ah->curchan);
-		ath9k_hw_start_nfcal(ah);
-
-		if (chan->channelFlags & CHANNEL_CW_INT)
-			chan->channelFlags &= ~CHANNEL_CW_INT;
-	}
-
-	return true;
-}
-
 static inline void ath9k_hw_9285_pa_cal(struct ath_hw *ah)
 {
 
@@ -877,22 +840,104 @@ static inline void ath9k_hw_9285_pa_cal(struct ath_hw *ah)
 
 }
 
+bool ath9k_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
+			u8 rxchainmask, bool longcal,
+			bool *isCalDone)
+{
+	struct hal_cal_list *currCal = ah->cal_list_curr;
+
+	*isCalDone = true;
+
+	if (currCal &&
+	    (currCal->calState == CAL_RUNNING ||
+	     currCal->calState == CAL_WAITING)) {
+		ath9k_hw_per_calibration(ah, chan, rxchainmask, currCal,
+					 isCalDone);
+		if (*isCalDone) {
+			ah->cal_list_curr = currCal = currCal->calNext;
+
+			if (currCal->calState == CAL_WAITING) {
+				*isCalDone = false;
+				ath9k_hw_reset_calibration(ah, currCal);
+			}
+		}
+	}
+
+	if (longcal) {
+		if (AR_SREV_9285(ah) && AR_SREV_9285_11_OR_LATER(ah))
+			ath9k_hw_9285_pa_cal(ah);
+
+		if (OLC_FOR_AR9280_20_LATER)
+			ath9k_olc_temp_compensation(ah);
+		ath9k_hw_getnf(ah, chan);
+		ath9k_hw_loadnf(ah, ah->curchan);
+		ath9k_hw_start_nfcal(ah);
+
+		if (chan->channelFlags & CHANNEL_CW_INT)
+			chan->channelFlags &= ~CHANNEL_CW_INT;
+	}
+
+	return true;
+}
+
+bool ar9285_clc(struct ath_hw *ah, struct ath9k_channel *chan)
+{
+	REG_SET_BIT(ah, AR_PHY_CL_CAL_CTL, AR_PHY_CL_CAL_ENABLE);
+	if (chan->channelFlags & CHANNEL_HT20) {
+		REG_SET_BIT(ah, AR_PHY_CL_CAL_CTL, AR_PHY_PARALLEL_CAL_ENABLE);
+		REG_SET_BIT(ah, AR_PHY_TURBO, AR_PHY_FC_DYN2040_EN);
+		REG_CLR_BIT(ah, AR_PHY_AGC_CONTROL,
+			    AR_PHY_AGC_CONTROL_FLTR_CAL);
+		REG_CLR_BIT(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_CAL_ENABLE);
+		REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_CAL);
+		if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL,
+				  AR_PHY_AGC_CONTROL_CAL, 0, AH_WAIT_TIMEOUT)) {
+			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE, "offset "
+				"calibration failed to complete in "
+				"1ms; noisy ??\n");
+			return false;
+		}
+		REG_CLR_BIT(ah, AR_PHY_TURBO, AR_PHY_FC_DYN2040_EN);
+		REG_CLR_BIT(ah, AR_PHY_CL_CAL_CTL, AR_PHY_PARALLEL_CAL_ENABLE);
+		REG_CLR_BIT(ah, AR_PHY_CL_CAL_CTL, AR_PHY_CL_CAL_ENABLE);
+	}
+	REG_CLR_BIT(ah, AR_PHY_ADC_CTL, AR_PHY_ADC_CTL_OFF_PWDADC);
+	REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_FLTR_CAL);
+	REG_SET_BIT(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_CAL_ENABLE);
+	REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_CAL);
+	if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_CAL,
+			  0, AH_WAIT_TIMEOUT)) {
+		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE, "offset calibration "
+				"failed to complete in 1ms; noisy ??\n");
+		return false;
+	}
+
+	REG_SET_BIT(ah, AR_PHY_ADC_CTL, AR_PHY_ADC_CTL_OFF_PWDADC);
+	REG_CLR_BIT(ah, AR_PHY_CL_CAL_CTL, AR_PHY_CL_CAL_ENABLE);
+	REG_CLR_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_FLTR_CAL);
+
+	return true;
+}
+
 bool ath9k_hw_init_cal(struct ath_hw *ah,
 		       struct ath9k_channel *chan)
 {
-	if (AR_SREV_9280_10_OR_LATER(ah)) {
+	if (AR_SREV_9285(ah) && AR_SREV_9285_12_OR_LATER(ah)) {
+		if (!ar9285_clc(ah, chan))
+			return false;
+	} else if (AR_SREV_9280_10_OR_LATER(ah)) {
 		REG_CLR_BIT(ah, AR_PHY_ADC_CTL, AR_PHY_ADC_CTL_OFF_PWDADC);
 		REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_FLTR_CAL);
 		REG_CLR_BIT(ah, AR_PHY_CL_CAL_CTL, AR_PHY_CL_CAL_ENABLE);
 
 		/* Kick off the cal */
 		REG_WRITE(ah, AR_PHY_AGC_CONTROL,
-			  REG_READ(ah, AR_PHY_AGC_CONTROL) |
-			  AR_PHY_AGC_CONTROL_CAL);
+				REG_READ(ah, AR_PHY_AGC_CONTROL) |
+				AR_PHY_AGC_CONTROL_CAL);
 
 		if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL,
-				   AR_PHY_AGC_CONTROL_CAL, 0,
-				   AH_WAIT_TIMEOUT)) {
+					AR_PHY_AGC_CONTROL_CAL, 0,
+					AH_WAIT_TIMEOUT)) {
 			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 				"offset calibration failed to complete in 1ms; "
 				"noisy environment?\n");
@@ -906,11 +951,11 @@ bool ath9k_hw_init_cal(struct ath_hw *ah,
 
 	/* Calibrate the AGC */
 	REG_WRITE(ah, AR_PHY_AGC_CONTROL,
-		  REG_READ(ah, AR_PHY_AGC_CONTROL) |
-		  AR_PHY_AGC_CONTROL_CAL);
+			REG_READ(ah, AR_PHY_AGC_CONTROL) |
+			AR_PHY_AGC_CONTROL_CAL);
 
 	if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_CAL,
-			   0, AH_WAIT_TIMEOUT)) {
+				0, AH_WAIT_TIMEOUT)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			"offset calibration failed to complete in 1ms; "
 			"noisy environment?\n");
@@ -928,8 +973,8 @@ bool ath9k_hw_init_cal(struct ath_hw *ah,
 
 	/* Do NF Calibration */
 	REG_WRITE(ah, AR_PHY_AGC_CONTROL,
-		  REG_READ(ah, AR_PHY_AGC_CONTROL) |
-		  AR_PHY_AGC_CONTROL_NF);
+			REG_READ(ah, AR_PHY_AGC_CONTROL) |
+			AR_PHY_AGC_CONTROL_NF);
 
 	ah->cal_list = ah->cal_list_last = ah->cal_list_curr = NULL;
 
@@ -938,19 +983,19 @@ bool ath9k_hw_init_cal(struct ath_hw *ah,
 			INIT_CAL(&ah->adcgain_caldata);
 			INSERT_CAL(ah, &ah->adcgain_caldata);
 			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
-				"enabling ADC Gain Calibration.\n");
+					"enabling ADC Gain Calibration.\n");
 		}
 		if (ath9k_hw_iscal_supported(ah, ADC_DC_CAL)) {
 			INIT_CAL(&ah->adcdc_caldata);
 			INSERT_CAL(ah, &ah->adcdc_caldata);
 			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
-				"enabling ADC DC Calibration.\n");
+					"enabling ADC DC Calibration.\n");
 		}
 		if (ath9k_hw_iscal_supported(ah, IQ_MISMATCH_CAL)) {
 			INIT_CAL(&ah->iq_caldata);
 			INSERT_CAL(ah, &ah->iq_caldata);
 			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
-				"enabling IQ Calibration.\n");
+					"enabling IQ Calibration.\n");
 		}
 
 		ah->cal_list_curr = ah->cal_list;
diff --git a/drivers/net/wireless/ath9k/eeprom.h b/drivers/net/wireless/ath9k/eeprom.h
index 6296e3e..d6f6108 100644
--- a/drivers/net/wireless/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath9k/eeprom.h
@@ -261,7 +261,7 @@ struct base_eep_header_4k {
 	u16 deviceCap;
 	u32 binBuildNumber;
 	u8 deviceType;
-	u8 futureBase[1];
+	u8 txGainType;
 } __packed;
 
 
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 5d72588..c10b33b 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -678,6 +678,7 @@ static struct ath_hw *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 		ah->hw_version.macVersion, ah->hw_version.macRev);
 
 	if (AR_SREV_9285_12_OR_LATER(ah)) {
+
 		INIT_INI_ARRAY(&ah->iniModes, ar9285Modes_9285_1_2,
 			       ARRAY_SIZE(ar9285Modes_9285_1_2), 6);
 		INIT_INI_ARRAY(&ah->iniCommon, ar9285Common_9285_1_2,
@@ -817,6 +818,22 @@ static struct ath_hw *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 	if (ecode != 0)
 		goto bad;
 
+	if (AR_SREV_9285_12_OR_LATER(ah)) {
+		u32 txgain_type = ah->eep_ops->get_eeprom(ah, EEP_TXGAIN_TYPE);
+
+		/* txgain table */
+		if (txgain_type == AR5416_EEP_TXGAIN_HIGH_POWER) {
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9285Modes_high_power_tx_gain_9285_1_2,
+			ARRAY_SIZE(ar9285Modes_high_power_tx_gain_9285_1_2), 6);
+		} else {
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9285Modes_original_tx_gain_9285_1_2,
+			ARRAY_SIZE(ar9285Modes_original_tx_gain_9285_1_2), 6);
+		}
+
+	}
+
 	/* rxgain table */
 	if (AR_SREV_9280_20(ah))
 		ath9k_hw_init_rxgain_ini(ah);
@@ -1293,7 +1310,8 @@ static int ath9k_hw_process_ini(struct ath_hw *ah,
 	if (AR_SREV_9280(ah))
 		REG_WRITE_ARRAY(&ah->iniModesRxGain, modesIndex, regWrites);
 
-	if (AR_SREV_9280(ah))
+	if (AR_SREV_9280(ah) || (AR_SREV_9285(ah) &&
+	    AR_SREV_9285_12_OR_LATER(ah)))
 		REG_WRITE_ARRAY(&ah->iniModesTxGain, modesIndex, regWrites);
 
 	for (i = 0; i < ah->iniCommon.ia_rows; i++) {
diff --git a/drivers/net/wireless/ath9k/initvals.h b/drivers/net/wireless/ath9k/initvals.h
index 4eb8b59..1d60c37 100644
--- a/drivers/net/wireless/ath9k/initvals.h
+++ b/drivers/net/wireless/ath9k/initvals.h
@@ -4121,6 +4121,7 @@ static const u_int32_t ar9285PciePhy_clkreq_off_L1_9285[][2] = {
     {0x00004044,  0x00000000 },
 };
 
+/* AR9285 v1_2 PCI Register Writes.  Created: 03/04/09 */
 static const u_int32_t ar9285Modes_9285_1_2[][6] = {
     { 0x00001030, 0x00000230, 0x00000460, 0x000002c0, 0x00000160, 0x000001e0 },
     { 0x00001070, 0x00000168, 0x000002d0, 0x00000318, 0x0000018c, 0x000001e0 },
@@ -4155,7 +4156,7 @@ static const u_int32_t ar9285Modes_9285_1_2[][6] = {
     { 0x000099bc, 0x00000600, 0x00000600, 0x00000c00, 0x00000c00, 0x00000c00 },
     { 0x000099c0, 0x05eea6d4, 0x05eea6d4, 0x05eea6d4, 0x05eea6d4, 0x05eea6d4 },
     { 0x000099c4, 0x06336f77, 0x06336f77, 0x06336f77, 0x06336f77, 0x06336f77 },
-    { 0x000099c8, 0x60f65329, 0x60f65329, 0x60f65329, 0x60f65329, 0x60f65329 },
+    { 0x000099c8, 0x6af65329, 0x6af65329, 0x6af65329, 0x6af65329, 0x6af65329 },
     { 0x000099cc, 0x08f186c8, 0x08f186c8, 0x08f186c8, 0x08f186c8, 0x08f186c8 },
     { 0x000099d0, 0x00046384, 0x00046384, 0x00046384, 0x00046384, 0x00046384 },
     { 0x000099d4, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 },
@@ -4421,25 +4422,6 @@ static const u_int32_t ar9285Modes_9285_1_2[][6] = {
     { 0x0000a21c, 0x1883800a, 0x1883800a, 0x1883800a, 0x1883800a, 0x1883800a },
     { 0x0000a230, 0x00000000, 0x00000000, 0x00000210, 0x00000108, 0x00000000 },
     { 0x0000a250, 0x0004f000, 0x0004f000, 0x0004a000, 0x0004a000, 0x0004a000 },
-    { 0x0000a274, 0x0a81c652, 0x0a81c652, 0x0a820652, 0x0a820652, 0x0a82a652 },
-    { 0x0000a300, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 },
-    { 0x0000a304, 0x00000000, 0x00000000, 0x00007201, 0x00007201, 0x00000000 },
-    { 0x0000a308, 0x00000000, 0x00000000, 0x00010408, 0x00010408, 0x00000000 },
-    { 0x0000a30c, 0x00000000, 0x00000000, 0x0001860a, 0x0001860a, 0x00000000 },
-    { 0x0000a310, 0x00000000, 0x00000000, 0x00020818, 0x00020818, 0x00000000 },
-    { 0x0000a314, 0x00000000, 0x00000000, 0x00024858, 0x00024858, 0x00000000 },
-    { 0x0000a318, 0x00000000, 0x00000000, 0x00026859, 0x00026859, 0x00000000 },
-    { 0x0000a31c, 0x00000000, 0x00000000, 0x0002985b, 0x0002985b, 0x00000000 },
-    { 0x0000a320, 0x00000000, 0x00000000, 0x0002b89a, 0x0002b89a, 0x00000000 },
-    { 0x0000a324, 0x00000000, 0x00000000, 0x0002d89b, 0x0002d89b, 0x00000000 },
-    { 0x0000a328, 0x00000000, 0x00000000, 0x0002f89c, 0x0002f89c, 0x00000000 },
-    { 0x0000a32c, 0x00000000, 0x00000000, 0x0003189d, 0x0003189d, 0x00000000 },
-    { 0x0000a330, 0x00000000, 0x00000000, 0x0003389e, 0x0003389e, 0x00000000 },
-    { 0x0000a334, 0x00000000, 0x00000000, 0x000368de, 0x000368de, 0x00000000 },
-    { 0x0000a338, 0x00000000, 0x00000000, 0x0003891e, 0x0003891e, 0x00000000 },
-    { 0x0000a33c, 0x00000000, 0x00000000, 0x0003a95e, 0x0003a95e, 0x00000000 },
-    { 0x0000a340, 0x00000000, 0x00000000, 0x0003e9df, 0x0003e9df, 0x00000000 },
-    { 0x0000a344, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
     { 0x0000a358, 0x7999aa02, 0x7999aa02, 0x7999aa0e, 0x7999aa0e, 0x7999aa0e },
 };
 
@@ -4569,7 +4551,7 @@ static const u_int32_t ar9285Common_9285_1_2[][2] = {
     { 0x00008110, 0x00000168 },
     { 0x00008118, 0x000100aa },
     { 0x0000811c, 0x00003210 },
-    { 0x00008120, 0x08f04800 },
+    { 0x00008120, 0x08f04810 },
     { 0x00008124, 0x00000000 },
     { 0x00008128, 0x00000000 },
     { 0x0000812c, 0x00000000 },
@@ -4585,7 +4567,7 @@ static const u_int32_t ar9285Common_9285_1_2[][2] = {
     { 0x00008178, 0x00000100 },
     { 0x0000817c, 0x00000000 },
     { 0x000081c0, 0x00000000 },
-    { 0x000081d0, 0x00003210 },
+    { 0x000081d0, 0x0000320a },
     { 0x000081ec, 0x00000000 },
     { 0x000081f0, 0x00000000 },
     { 0x000081f4, 0x00000000 },
@@ -4709,8 +4691,6 @@ static const u_int32_t ar9285Common_9285_1_2[][2] = {
     { 0x0000a268, 0x00000000 },
     { 0x0000a26c, 0x0ebae9e6 },
     { 0x0000d270, 0x0d820820 },
-    { 0x0000a278, 0x318c6318 },
-    { 0x0000a27c, 0x050c0318 },
     { 0x0000d35c, 0x07ffffef },
     { 0x0000d360, 0x0fffffe7 },
     { 0x0000d364, 0x17ffffe5 },
@@ -4725,8 +4705,6 @@ static const u_int32_t ar9285Common_9285_1_2[][2] = {
     { 0x0000a388, 0x0c000000 },
     { 0x0000a38c, 0x20202020 },
     { 0x0000a390, 0x20202020 },
-    { 0x0000a394, 0x318c6318 },
-    { 0x0000a398, 0x00000318 },
     { 0x0000a39c, 0x00000001 },
     { 0x0000a3a0, 0x00000000 },
     { 0x0000a3a4, 0x00000000 },
@@ -4741,8 +4719,6 @@ static const u_int32_t ar9285Common_9285_1_2[][2] = {
     { 0x0000a3cc, 0x20202020 },
     { 0x0000a3d0, 0x20202020 },
     { 0x0000a3d4, 0x20202020 },
-    { 0x0000a3dc, 0x318c6318 },
-    { 0x0000a3e0, 0x00000318 },
     { 0x0000a3e4, 0x00000000 },
     { 0x0000a3e8, 0x18c43433 },
     { 0x0000a3ec, 0x00f70081 },
@@ -4753,13 +4729,11 @@ static const u_int32_t ar9285Common_9285_1_2[][2] = {
     { 0x00007810, 0x71c0d388 },
     { 0x00007814, 0x924934a8 },
     { 0x0000781c, 0x00000000 },
-    { 0x00007820, 0x00000c04 },
     { 0x00007824, 0x00d86fff },
     { 0x00007828, 0x26d2491b },
     { 0x0000782c, 0x6e36d97b },
     { 0x00007830, 0xedb6d96e },
     { 0x00007834, 0x71400087 },
-    { 0x00007838, 0xfac68801 },
     { 0x0000783c, 0x0001fffe },
     { 0x00007840, 0xffeb1a20 },
     { 0x00007844, 0x000c0db6 },
@@ -4772,10 +4746,81 @@ static const u_int32_t ar9285Common_9285_1_2[][2] = {
     { 0x00007860, 0x21084210 },
     { 0x00007864, 0xf7d7ffde },
     { 0x00007868, 0xc2034080 },
-    { 0x0000786c, 0x48609eb4 },
     { 0x00007870, 0x10142c00 },
 };
 
+static const u_int32_t ar9285Modes_high_power_tx_gain_9285_1_2[][6] = {
+    /* Address      5G-HT20     5G-HT40     2G-HT40     2G-HT20     Turbo   */
+    { 0x0000a300, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 },
+    { 0x0000a304, 0x00000000, 0x00000000, 0x00005200, 0x00005200, 0x00000000 },
+    { 0x0000a308, 0x00000000, 0x00000000, 0x00007201, 0x00007201, 0x00000000 },
+    { 0x0000a30c, 0x00000000, 0x00000000, 0x0000b240, 0x0000b240, 0x00000000 },
+    { 0x0000a310, 0x00000000, 0x00000000, 0x0000d241, 0x0000d241, 0x00000000 },
+    { 0x0000a314, 0x00000000, 0x00000000, 0x0000f440, 0x0000f440, 0x00000000 },
+    { 0x0000a318, 0x00000000, 0x00000000, 0x00014640, 0x00014640, 0x00000000 },
+    { 0x0000a31c, 0x00000000, 0x00000000, 0x00018680, 0x00018680, 0x00000000 },
+    { 0x0000a320, 0x00000000, 0x00000000, 0x00019841, 0x00019841, 0x00000000 },
+    { 0x0000a324, 0x00000000, 0x00000000, 0x0001ca40, 0x0001ca40, 0x00000000 },
+    { 0x0000a328, 0x00000000, 0x00000000, 0x0001fa80, 0x0001fa80, 0x00000000 },
+    { 0x0000a32c, 0x00000000, 0x00000000, 0x00023ac0, 0x00023ac0, 0x00000000 },
+    { 0x0000a330, 0x00000000, 0x00000000, 0x0002ab40, 0x0002ab40, 0x00000000 },
+    { 0x0000a334, 0x00000000, 0x00000000, 0x00033d82, 0x00033d82, 0x00000000 },
+    { 0x0000a338, 0x0003891e, 0x0003891e, 0x0003891e, 0x0003891e, 0x00000000 },
+    { 0x0000a33c, 0x0003a95e, 0x0003a95e, 0x0003a95e, 0x0003a95e, 0x00000000 },
+    { 0x0000a340, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
+    { 0x0000a344, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
+    { 0x0000a348, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
+    { 0x0000a34c, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
+    { 0x0000a350, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
+    { 0x0000a354, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
+    { 0x00007838, 0xfac68803, 0xfac68803, 0xfac68803, 0xfac68803, 0xfac68803 },
+    { 0x0000786c, 0x08609ebe, 0x08609ebe, 0x08609ebe, 0x08609ebe, 0x08609ebe },
+    { 0x00007820, 0x00000c00, 0x00000c00, 0x00000c00, 0x00000c00, 0x00000c00 },
+    { 0x0000a274, 0x0a22a652, 0x0a22a652, 0x0a21a652, 0x0a21a652, 0x0a22a652 },
+    { 0x0000a278, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce },
+    { 0x0000a27c, 0x050701ce, 0x050701ce, 0x050701ce, 0x050701ce, 0x050701ce },
+    { 0x0000a394, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce },
+    { 0x0000a398, 0x000001ce, 0x000001ce, 0x000001ce, 0x000001ce, 0x000001ce },
+    { 0x0000a3dc, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce },
+    { 0x0000a3e0, 0x000001ce, 0x000001ce, 0x000001ce, 0x000001ce, 0x000001ce },
+};
+
+static const u_int32_t ar9285Modes_original_tx_gain_9285_1_2[][6] = {
+    /* Address      5G-HT20     5G-HT40     2G-HT40     2G-HT20     Turbo   */
+    { 0x0000a300, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 },
+    { 0x0000a304, 0x00000000, 0x00000000, 0x00009200, 0x00009200, 0x00000000 },
+    { 0x0000a308, 0x00000000, 0x00000000, 0x00010208, 0x00010208, 0x00000000 },
+    { 0x0000a30c, 0x00000000, 0x00000000, 0x00019608, 0x00019608, 0x00000000 },
+    { 0x0000a310, 0x00000000, 0x00000000, 0x00022618, 0x00022618, 0x00000000 },
+    { 0x0000a314, 0x00000000, 0x00000000, 0x0002a6c9, 0x0002a6c9, 0x00000000 },
+    { 0x0000a318, 0x00000000, 0x00000000, 0x00031710, 0x00031710, 0x00000000 },
+    { 0x0000a31c, 0x00000000, 0x00000000, 0x00035718, 0x00035718, 0x00000000 },
+    { 0x0000a320, 0x00000000, 0x00000000, 0x00038758, 0x00038758, 0x00000000 },
+    { 0x0000a324, 0x00000000, 0x00000000, 0x0003c75a, 0x0003c75a, 0x00000000 },
+    { 0x0000a328, 0x00000000, 0x00000000, 0x0004075c, 0x0004075c, 0x00000000 },
+    { 0x0000a32c, 0x00000000, 0x00000000, 0x0004475e, 0x0004475e, 0x00000000 },
+    { 0x0000a330, 0x00000000, 0x00000000, 0x0004679f, 0x0004679f, 0x00000000 },
+    { 0x0000a334, 0x00000000, 0x00000000, 0x000487df, 0x000487df, 0x00000000 },
+    { 0x0000a338, 0x0003891e, 0x0003891e, 0x0003891e, 0x0003891e, 0x00000000 },
+    { 0x0000a33c, 0x0003a95e, 0x0003a95e, 0x0003a95e, 0x0003a95e, 0x00000000 },
+    { 0x0000a340, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
+    { 0x0000a344, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
+    { 0x0000a348, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
+    { 0x0000a34c, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
+    { 0x0000a350, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
+    { 0x0000a354, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
+    { 0x00007838, 0xfac68801, 0xfac68801, 0xfac68801, 0xfac68801, 0xfac68801 },
+    { 0x0000786c, 0x48609eb4, 0x48609eb4, 0x48609eb4, 0x48609eb4, 0x48609eb4 },
+    { 0x00007820, 0x00000c04, 0x00000c04, 0x00000c04, 0x00000c04, 0x00000c04 },
+    { 0x0000a274, 0x0a21c652, 0x0a21c652, 0x0a21a652, 0x0a21a652, 0x0a22a652 },
+    { 0x0000a278, 0x39ce739c, 0x39ce739c, 0x39ce739c, 0x39ce739c, 0x39ce739c },
+    { 0x0000a27c, 0x050e039c, 0x050e039c, 0x050e039c, 0x050e039c, 0x050e039c },
+    { 0x0000a394, 0x39ce739c, 0x39ce739c, 0x39ce739c, 0x39ce739c, 0x39ce739c },
+    { 0x0000a398, 0x0000039c, 0x0000039c, 0x0000039c, 0x0000039c, 0x0000039c },
+    { 0x0000a3dc, 0x39ce739c, 0x39ce739c, 0x39ce739c, 0x39ce739c, 0x39ce739c },
+    { 0x0000a3e0, 0x0000039c, 0x0000039c, 0x0000039c, 0x0000039c, 0x0000039c },
+};
+
 static const u_int32_t ar9285PciePhy_clkreq_always_on_L1_9285_1_2[][2] = {
     {0x00004040,  0x9248fd00 },
     {0x00004040,  0x24924924 },
diff --git a/drivers/net/wireless/ath9k/phy.h b/drivers/net/wireless/ath9k/phy.h
index 6222e32..1eac8c7 100644
--- a/drivers/net/wireless/ath9k/phy.h
+++ b/drivers/net/wireless/ath9k/phy.h
@@ -446,6 +446,9 @@ bool ath9k_hw_init_rf(struct ath_hw *ah,
 #define AR_PHY_TPCRG1_PD_GAIN_3    0x00300000
 #define AR_PHY_TPCRG1_PD_GAIN_3_S  20
 
+#define AR_PHY_TPCRG1_PD_CAL_ENABLE   0x00400000
+#define AR_PHY_TPCRG1_PD_CAL_ENABLE_S 22
+
 #define AR_PHY_TX_PWRCTRL4       0xa264
 #define AR_PHY_TX_PWRCTRL_PD_AVG_VALID     0x00000001
 #define AR_PHY_TX_PWRCTRL_PD_AVG_VALID_S   0
@@ -513,6 +516,7 @@ bool ath9k_hw_init_rf(struct ath_hw *ah,
 /* Carrier leak calibration control, do it after AGC calibration */
 #define AR_PHY_CL_CAL_CTL       0xA358
 #define AR_PHY_CL_CAL_ENABLE    0x00000002
+#define AR_PHY_PARALLEL_CAL_ENABLE    0x00000001
 
 #define AR_PHY_POWER_TX_RATE5   0xA38C
 #define AR_PHY_POWER_TX_RATE6   0xA390
-- 
1.6.0.4

