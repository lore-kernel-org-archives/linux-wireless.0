Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.225]:62205 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756151AbZHNF5e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 01:57:34 -0400
Received: by rv-out-0506.google.com with SMTP id f6so388799rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2009 22:57:35 -0700 (PDT)
Date: Fri, 14 Aug 2009 11:27:16 +0530
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/5] ath9k: Add open loop power control support for AR9287.
Message-ID: <20090814055716.GA3541@myhost.users.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/calib.c |   44 +++++++++++++++++++++----------
 drivers/net/wireless/ath/ath9k/hw.c    |   20 +++++++++++---
 drivers/net/wireless/ath/ath9k/phy.h   |    7 +++++
 3 files changed, 52 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 26d8752..20f74b5 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -729,26 +729,42 @@ s16 ath9k_hw_getchan_noise(struct ath_hw *ah, struct ath9k_channel *chan)
 static void ath9k_olc_temp_compensation(struct ath_hw *ah)
 {
 	u32 rddata, i;
-	int delta, currPDADC, regval;
+	int delta, currPDADC, regval, slope;
 
 	rddata = REG_READ(ah, AR_PHY_TX_PWRCTRL4);
-
 	currPDADC = MS(rddata, AR_PHY_TX_PWRCTRL_PD_AVG_OUT);
 
-	if (ah->eep_ops->get_eeprom(ah, EEP_DAC_HPWR_5G))
-		delta = (currPDADC - ah->initPDADC + 4) / 8;
-	else
-		delta = (currPDADC - ah->initPDADC + 5) / 10;
 
-	if (delta != ah->PDADCdelta) {
-		ah->PDADCdelta = delta;
-		for (i = 1; i < AR9280_TX_GAIN_TABLE_SIZE; i++) {
-			regval = ah->originalGain[i] - delta;
-			if (regval < 0)
-				regval = 0;
+	if (OLC_FOR_AR9287_10_LATER) {
+		if (ah->initPDADC == 0 || currPDADC == 0) {
+			return;
+		} else {
+			slope = ah->eep_ops->get_eeprom(ah, EEP_TEMPSENSE_SLOPE);
+			if (slope == 0)
+				delta = 0;
+			else
+				delta = ((currPDADC - ah->initPDADC)*4) / slope;
+			REG_RMW_FIELD(ah, AR_PHY_CH0_TX_PWRCTRL11,
+					AR_PHY_TX_PWRCTRL_OLPC_TEMP_COMP, delta);
+			REG_RMW_FIELD(ah, AR_PHY_CH1_TX_PWRCTRL11,
+					AR_PHY_TX_PWRCTRL_OLPC_TEMP_COMP, delta);
+		}
+	} else {
+		if (ah->eep_ops->get_eeprom(ah, EEP_DAC_HPWR_5G))
+			delta = (currPDADC - ah->initPDADC + 4) / 8;
+		else
+			delta = (currPDADC - ah->initPDADC + 5) / 10;
+
+		if (delta != ah->PDADCdelta) {
+			ah->PDADCdelta = delta;
+			for (i = 1; i < AR9280_TX_GAIN_TABLE_SIZE; i++) {
+				regval = ah->originalGain[i] - delta;
+				if (regval < 0)
+					regval = 0;
 
-			REG_RMW_FIELD(ah, AR_PHY_TX_GAIN_TBL1 + i * 4,
-					AR_PHY_TX_GAIN, regval);
+				REG_RMW_FIELD(ah, AR_PHY_TX_GAIN_TBL1 + i * 4,
+						AR_PHY_TX_GAIN, regval);
+			}
 		}
 	}
 }
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 6eef7b4..1d2cc25 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1332,11 +1332,21 @@ static void ath9k_olc_init(struct ath_hw *ah)
 {
 	u32 i;
 
-	for (i = 0; i < AR9280_TX_GAIN_TABLE_SIZE; i++)
-		ah->originalGain[i] =
-			MS(REG_READ(ah, AR_PHY_TX_GAIN_TBL1 + i * 4),
-					AR_PHY_TX_GAIN);
-	ah->PDADCdelta = 0;
+	if (OLC_FOR_AR9287_10_LATER) {
+		REG_SET_BIT(ah, AR_PHY_TX_PWRCTRL9,
+				AR_PHY_TX_PWRCTRL9_RES_DC_REMOVAL);
+		ath9k_hw_analog_shift_rmw(ah, AR9287_AN_TXPC0,
+				AR9287_AN_TXPC0_TXPCMODE,
+				AR9287_AN_TXPC0_TXPCMODE_S,
+				AR9287_AN_TXPC0_TXPCMODE_TEMPSENSE);
+		udelay(100);
+	} else {
+		for (i = 0; i < AR9280_TX_GAIN_TABLE_SIZE; i++)
+			ah->originalGain[i] =
+				MS(REG_READ(ah, AR_PHY_TX_GAIN_TBL1 + i * 4),
+						AR_PHY_TX_GAIN);
+		ah->PDADCdelta = 0;
+	}
 }
 
 static u32 ath9k_regd_get_ctl(struct ath_regulatory *reg,
diff --git a/drivers/net/wireless/ath/ath9k/phy.h b/drivers/net/wireless/ath/ath9k/phy.h
index e83cd4a..dfda6f4 100644
--- a/drivers/net/wireless/ath/ath9k/phy.h
+++ b/drivers/net/wireless/ath/ath9k/phy.h
@@ -490,11 +490,18 @@ bool ath9k_hw_init_rf(struct ath_hw *ah,
 #define AR_PHY_TX_PWRCTRL9       0xa27C
 #define AR_PHY_TX_DESIRED_SCALE_CCK        0x00007C00
 #define AR_PHY_TX_DESIRED_SCALE_CCK_S      10
+#define AR_PHY_TX_PWRCTRL9_RES_DC_REMOVAL  0x80000000
+#define AR_PHY_TX_PWRCTRL9_RES_DC_REMOVAL_S 31
 
 #define AR_PHY_TX_GAIN_TBL1      0xa300
 #define AR_PHY_TX_GAIN                     0x0007F000
 #define AR_PHY_TX_GAIN_S                   12
 
+#define AR_PHY_CH0_TX_PWRCTRL11  0xa398
+#define AR_PHY_CH1_TX_PWRCTRL11  0xb398
+#define AR_PHY_TX_PWRCTRL_OLPC_TEMP_COMP   0x0000FC00
+#define AR_PHY_TX_PWRCTRL_OLPC_TEMP_COMP_S 10
+
 #define AR_PHY_VIT_MASK2_M_46_61 0xa3a0
 #define AR_PHY_MASK2_M_31_45     0xa3a4
 #define AR_PHY_MASK2_M_16_30     0xa3a8
-- 
1.6.0.1

