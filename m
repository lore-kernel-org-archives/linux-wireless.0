Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plout10-02.prod.sin2.secureserver.net ([182.50.145.5]:39034
	"EHLO sg2plout10-02.prod.sin2.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756613Ab3AHP2w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2013 10:28:52 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] ath9k_hw: Add TempCompensation feature for AR9550
Date: Tue,  8 Jan 2013 20:57:52 +0530
Message-Id: <1357658873-14896-2-git-send-email-sujith@msujith.org> (sfid-20130108_162857_328361_536DBD19)
In-Reply-To: <1357658873-14896-1-git-send-email-sujith@msujith.org>
References: <1357658873-14896-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 128 +++++++++++++++++++------
 drivers/net/wireless/ath/ath9k/ar9003_phy.h    |   2 +-
 2 files changed, 100 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 562186c..881e989 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -4586,14 +4586,14 @@ static int ar9003_hw_cal_pier_get(struct ath_hw *ah,
 	return 0;
 }
 
-static int ar9003_hw_power_control_override(struct ath_hw *ah,
-					    int frequency,
-					    int *correction,
-					    int *voltage, int *temperature)
+static void ar9003_hw_power_control_override(struct ath_hw *ah,
+					     int frequency,
+					     int *correction,
+					     int *voltage, int *temperature)
 {
-	int tempSlope = 0;
+	int temp_slope = 0, temp_slope1 = 0, temp_slope2 = 0;
 	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
-	int f[8], t[8], i;
+	int f[8], t[8], t1[3], t2[3], i;
 
 	REG_RMW(ah, AR_PHY_TPC_11_B0,
 		(correction[0] << AR_PHY_TPC_OLPC_GAIN_DELTA_S),
@@ -4624,38 +4624,108 @@ static int ar9003_hw_power_control_override(struct ath_hw *ah,
 	 * enable temperature compensation
 	 * Need to use register names
 	 */
-	if (frequency < 4000)
-		tempSlope = eep->modalHeader2G.tempSlope;
-	else if ((eep->baseEepHeader.miscConfiguration & 0x20) != 0) {
-		for (i = 0; i < 8; i++) {
-			t[i] = eep->base_ext1.tempslopextension[i];
-			f[i] = FBIN2FREQ(eep->calFreqPier5G[i], 0);
+	if (frequency < 4000) {
+		temp_slope = eep->modalHeader2G.tempSlope;
+	} else {
+		if (AR_SREV_9550(ah)) {
+			t[0] = eep->base_ext1.tempslopextension[2];
+			t1[0] = eep->base_ext1.tempslopextension[3];
+			t2[0] = eep->base_ext1.tempslopextension[4];
+			f[0] = 5180;
+
+			t[1] = eep->modalHeader5G.tempSlope;
+			t1[1] = eep->base_ext1.tempslopextension[0];
+			t2[1] = eep->base_ext1.tempslopextension[1];
+			f[1] = 5500;
+
+			t[2] = eep->base_ext1.tempslopextension[5];
+			t1[2] = eep->base_ext1.tempslopextension[6];
+			t2[2] = eep->base_ext1.tempslopextension[7];
+			f[2] = 5785;
+
+			temp_slope = ar9003_hw_power_interpolate(frequency,
+								 f, t, 3);
+			temp_slope1 = ar9003_hw_power_interpolate(frequency,
+								   f, t1, 3);
+			temp_slope2 = ar9003_hw_power_interpolate(frequency,
+								   f, t2, 3);
+
+			goto tempslope;
 		}
-		tempSlope = ar9003_hw_power_interpolate((s32) frequency,
-							f, t, 8);
-	} else if (eep->base_ext2.tempSlopeLow != 0) {
-		t[0] = eep->base_ext2.tempSlopeLow;
-		f[0] = 5180;
-		t[1] = eep->modalHeader5G.tempSlope;
-		f[1] = 5500;
-		t[2] = eep->base_ext2.tempSlopeHigh;
-		f[2] = 5785;
-		tempSlope = ar9003_hw_power_interpolate((s32) frequency,
-							f, t, 3);
-	} else
-		tempSlope = eep->modalHeader5G.tempSlope;
 
-	REG_RMW_FIELD(ah, AR_PHY_TPC_19, AR_PHY_TPC_19_ALPHA_THERM, tempSlope);
+		if ((eep->baseEepHeader.miscConfiguration & 0x20) != 0) {
+			for (i = 0; i < 8; i++) {
+				t[i] = eep->base_ext1.tempslopextension[i];
+				f[i] = FBIN2FREQ(eep->calFreqPier5G[i], 0);
+			}
+			temp_slope = ar9003_hw_power_interpolate((s32) frequency,
+								 f, t, 8);
+		} else if (eep->base_ext2.tempSlopeLow != 0) {
+			t[0] = eep->base_ext2.tempSlopeLow;
+			f[0] = 5180;
+			t[1] = eep->modalHeader5G.tempSlope;
+			f[1] = 5500;
+			t[2] = eep->base_ext2.tempSlopeHigh;
+			f[2] = 5785;
+			temp_slope = ar9003_hw_power_interpolate((s32) frequency,
+								 f, t, 3);
+		} else {
+			temp_slope = eep->modalHeader5G.tempSlope;
+		}
+	}
+
+tempslope:
+	if (AR_SREV_9550(ah)) {
+		/*
+		 * AR955x has tempSlope register for each chain.
+		 * Check whether temp_compensation feature is enabled or not.
+		 */
+		if (eep->baseEepHeader.featureEnable & 0x1) {
+			if (frequency < 4000) {
+				REG_RMW_FIELD(ah, AR_PHY_TPC_19,
+					      AR_PHY_TPC_19_ALPHA_THERM,
+					      eep->base_ext2.tempSlopeLow);
+				REG_RMW_FIELD(ah, AR_PHY_TPC_19_B1,
+					      AR_PHY_TPC_19_ALPHA_THERM,
+					      temp_slope);
+				REG_RMW_FIELD(ah, AR_PHY_TPC_19_B2,
+					      AR_PHY_TPC_19_ALPHA_THERM,
+					      eep->base_ext2.tempSlopeHigh);
+			} else {
+				REG_RMW_FIELD(ah, AR_PHY_TPC_19,
+					      AR_PHY_TPC_19_ALPHA_THERM,
+					      temp_slope);
+				REG_RMW_FIELD(ah, AR_PHY_TPC_19_B1,
+					      AR_PHY_TPC_19_ALPHA_THERM,
+					      temp_slope1);
+				REG_RMW_FIELD(ah, AR_PHY_TPC_19_B2,
+					      AR_PHY_TPC_19_ALPHA_THERM,
+					      temp_slope2);
+			}
+		} else {
+			/*
+			 * If temp compensation is not enabled,
+			 * set all registers to 0.
+			 */
+			REG_RMW_FIELD(ah, AR_PHY_TPC_19,
+				      AR_PHY_TPC_19_ALPHA_THERM, 0);
+			REG_RMW_FIELD(ah, AR_PHY_TPC_19_B1,
+				      AR_PHY_TPC_19_ALPHA_THERM, 0);
+			REG_RMW_FIELD(ah, AR_PHY_TPC_19_B2,
+				      AR_PHY_TPC_19_ALPHA_THERM, 0);
+		}
+	} else {
+		REG_RMW_FIELD(ah, AR_PHY_TPC_19,
+			      AR_PHY_TPC_19_ALPHA_THERM, temp_slope);
+	}
 
 	if (AR_SREV_9462_20(ah))
 		REG_RMW_FIELD(ah, AR_PHY_TPC_19_B1,
-			      AR_PHY_TPC_19_B1_ALPHA_THERM, tempSlope);
+			      AR_PHY_TPC_19_B1_ALPHA_THERM, temp_slope);
 
 
 	REG_RMW_FIELD(ah, AR_PHY_TPC_18, AR_PHY_TPC_18_THERM_CAL_VALUE,
 		      temperature[0]);
-
-	return 0;
 }
 
 /* Apply the recorded correction values. */
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 1079562..e717741 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -1028,7 +1028,7 @@
 #define AR_PHY_TPC_5_B2          (AR_SM2_BASE + 0x208)
 #define AR_PHY_TPC_6_B2          (AR_SM2_BASE + 0x20c)
 #define AR_PHY_TPC_11_B2         (AR_SM2_BASE + 0x220)
-#define AR_PHY_PDADC_TAB_2       (AR_SM2_BASE + 0x240)
+#define AR_PHY_TPC_19_B2         (AR_SM2_BASE + 0x240)
 #define AR_PHY_TX_IQCAL_STATUS_B2   (AR_SM2_BASE + 0x48c)
 #define AR_PHY_TX_IQCAL_CORR_COEFF_B2(_i)    (AR_SM2_BASE + 0x450 + ((_i) << 2))
 
-- 
1.8.1

