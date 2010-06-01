Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:42261 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259Ab0FAKNr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jun 2010 06:13:47 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 01 Jun 2010 03:13:47 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19460.56736.744071.882417@gargle.gargle.HOWL>
Date: Tue, 1 Jun 2010 15:44:56 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 02/13] ath9k_hw: Optimize ath9k_hw_ar9287_set_board_values
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rather than doing a series of RMWs, calculate the
value to be written to the register in question and
do a single REGWRITE. This improves bringup time.

This depends on the analog_shiftreg configuration option,
which is currently buggy. For AP mode, a delay of 100us
has to be the default. For station mode, this knob has to
be enabled on a per-case basis, though it is a little
unclear on when to enable a delay. This can be fixed later though.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/eeprom.c      |    8 +++
 drivers/net/wireless/ath/ath9k/eeprom.h      |    1 +
 drivers/net/wireless/ath/ath9k/eeprom_9287.c |   69 ++++++++++++--------------
 3 files changed, 41 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index ca8704a..a29b2d9 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -24,6 +24,14 @@ static inline u16 ath9k_hw_fbin2freq(u8 fbin, bool is2GHz)
 	return (u16) ((is2GHz) ? (2300 + fbin) : (4800 + 5 * fbin));
 }
 
+void ath9k_hw_analog_shift_regwrite(struct ath_hw *ah, u32 reg, u32 val)
+{
+        REG_WRITE(ah, reg, val);
+
+        if (ah->config.analog_shiftreg)
+		udelay(100);
+}
+
 void ath9k_hw_analog_shift_rmw(struct ath_hw *ah, u32 reg, u32 mask,
 			       u32 shift, u32 val)
 {
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 21354c1..14186f2 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -679,6 +679,7 @@ struct eeprom_ops {
 	u16 (*get_spur_channel)(struct ath_hw *ah, u16 i, bool is2GHz);
 };
 
+void ath9k_hw_analog_shift_regwrite(struct ath_hw *ah, u32 reg, u32 val);
 void ath9k_hw_analog_shift_rmw(struct ath_hw *ah, u32 reg, u32 mask,
 			       u32 shift, u32 val);
 int16_t ath9k_hw_interpolate(u16 target, u16 srcLeft, u16 srcRight,
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index 5010cd1..27abfba 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -988,7 +988,7 @@ static void ath9k_hw_ar9287_set_board_values(struct ath_hw *ah,
 	struct ar9287_eeprom *eep = &ah->eeprom.map9287;
 	struct modal_eep_ar9287_header *pModal = &eep->modalHeader;
 	u16 antWrites[AR9287_ANT_16S];
-	u32 regChainOffset;
+	u32 regChainOffset, regval;
 	u8 txRxAttenLocal;
 	int i, j, offset_num;
 
@@ -1075,42 +1075,37 @@ static void ath9k_hw_ar9287_set_board_values(struct ath_hw *ah,
 	REG_RMW_FIELD(ah, AR_PHY_EXT_CCA0,
 		      AR_PHY_EXT_CCA0_THRESH62, pModal->thresh62);
 
-	ath9k_hw_analog_shift_rmw(ah, AR9287_AN_RF2G3_CH0, AR9287_AN_RF2G3_DB1,
-				  AR9287_AN_RF2G3_DB1_S, pModal->db1);
-	ath9k_hw_analog_shift_rmw(ah, AR9287_AN_RF2G3_CH0, AR9287_AN_RF2G3_DB2,
-				  AR9287_AN_RF2G3_DB2_S, pModal->db2);
-	ath9k_hw_analog_shift_rmw(ah, AR9287_AN_RF2G3_CH0,
-				  AR9287_AN_RF2G3_OB_CCK,
-				  AR9287_AN_RF2G3_OB_CCK_S, pModal->ob_cck);
-	ath9k_hw_analog_shift_rmw(ah, AR9287_AN_RF2G3_CH0,
-				  AR9287_AN_RF2G3_OB_PSK,
-				  AR9287_AN_RF2G3_OB_PSK_S, pModal->ob_psk);
-	ath9k_hw_analog_shift_rmw(ah, AR9287_AN_RF2G3_CH0,
-				  AR9287_AN_RF2G3_OB_QAM,
-				  AR9287_AN_RF2G3_OB_QAM_S, pModal->ob_qam);
-	ath9k_hw_analog_shift_rmw(ah, AR9287_AN_RF2G3_CH0,
-				  AR9287_AN_RF2G3_OB_PAL_OFF,
-				  AR9287_AN_RF2G3_OB_PAL_OFF_S,
-				  pModal->ob_pal_off);
-
-	ath9k_hw_analog_shift_rmw(ah, AR9287_AN_RF2G3_CH1,
-				  AR9287_AN_RF2G3_DB1, AR9287_AN_RF2G3_DB1_S,
-				  pModal->db1);
-	ath9k_hw_analog_shift_rmw(ah, AR9287_AN_RF2G3_CH1, AR9287_AN_RF2G3_DB2,
-				  AR9287_AN_RF2G3_DB2_S, pModal->db2);
-	ath9k_hw_analog_shift_rmw(ah, AR9287_AN_RF2G3_CH1,
-				  AR9287_AN_RF2G3_OB_CCK,
-				  AR9287_AN_RF2G3_OB_CCK_S, pModal->ob_cck);
-	ath9k_hw_analog_shift_rmw(ah, AR9287_AN_RF2G3_CH1,
-				  AR9287_AN_RF2G3_OB_PSK,
-				  AR9287_AN_RF2G3_OB_PSK_S, pModal->ob_psk);
-	ath9k_hw_analog_shift_rmw(ah, AR9287_AN_RF2G3_CH1,
-				  AR9287_AN_RF2G3_OB_QAM,
-				  AR9287_AN_RF2G3_OB_QAM_S, pModal->ob_qam);
-	ath9k_hw_analog_shift_rmw(ah, AR9287_AN_RF2G3_CH1,
-				  AR9287_AN_RF2G3_OB_PAL_OFF,
-				  AR9287_AN_RF2G3_OB_PAL_OFF_S,
-				  pModal->ob_pal_off);
+	regval = REG_READ(ah, AR9287_AN_RF2G3_CH0);
+	regval &= ~(AR9287_AN_RF2G3_DB1 |
+		    AR9287_AN_RF2G3_DB2 |
+		    AR9287_AN_RF2G3_OB_CCK |
+		    AR9287_AN_RF2G3_OB_PSK |
+		    AR9287_AN_RF2G3_OB_QAM |
+		    AR9287_AN_RF2G3_OB_PAL_OFF);
+	regval |= (SM(pModal->db1, AR9287_AN_RF2G3_DB1) |
+		   SM(pModal->db2, AR9287_AN_RF2G3_DB2) |
+		   SM(pModal->ob_cck, AR9287_AN_RF2G3_OB_CCK) |
+		   SM(pModal->ob_psk, AR9287_AN_RF2G3_OB_PSK) |
+		   SM(pModal->ob_qam, AR9287_AN_RF2G3_OB_QAM) |
+		   SM(pModal->ob_pal_off, AR9287_AN_RF2G3_OB_PAL_OFF));
+
+	ath9k_hw_analog_shift_regwrite(ah, AR9287_AN_RF2G3_CH0, regval);
+
+	regval = REG_READ(ah, AR9287_AN_RF2G3_CH1);
+	regval &= ~(AR9287_AN_RF2G3_DB1 |
+		    AR9287_AN_RF2G3_DB2 |
+		    AR9287_AN_RF2G3_OB_CCK |
+		    AR9287_AN_RF2G3_OB_PSK |
+		    AR9287_AN_RF2G3_OB_QAM |
+		    AR9287_AN_RF2G3_OB_PAL_OFF);
+	regval |= (SM(pModal->db1, AR9287_AN_RF2G3_DB1) |
+		   SM(pModal->db2, AR9287_AN_RF2G3_DB2) |
+		   SM(pModal->ob_cck, AR9287_AN_RF2G3_OB_CCK) |
+		   SM(pModal->ob_psk, AR9287_AN_RF2G3_OB_PSK) |
+		   SM(pModal->ob_qam, AR9287_AN_RF2G3_OB_QAM) |
+		   SM(pModal->ob_pal_off, AR9287_AN_RF2G3_OB_PAL_OFF));
+
+	ath9k_hw_analog_shift_regwrite(ah, AR9287_AN_RF2G3_CH1, regval);
 
 	REG_RMW_FIELD(ah, AR_PHY_RF_CTL2,
 		      AR_PHY_TX_END_DATA_START, pModal->txFrameToDataStart);
-- 
1.7.1

