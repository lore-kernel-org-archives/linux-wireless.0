Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:32408 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738AbZHGEPO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 00:15:14 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2009 21:15:15 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19067.43611.455467.918248@gargle.gargle.HOWL>
Date: Fri, 7 Aug 2009 09:45:23 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 08/12] ath9k: Clean antenna configuration for 4K EEPROM chips
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch revamps the antenna configuration mechanism
for 4K chips.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/eeprom.h    |   33 +++++++--
 drivers/net/wireless/ath/ath9k/eeprom_4k.c |  103 +++++++++++++++-------------
 drivers/net/wireless/ath/ath9k/phy.h       |    1 +
 3 files changed, 84 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 7d825b6..4fe33f7 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -404,8 +404,13 @@ struct modal_eep_4k_header {
 	u8 iqCalICh[AR5416_EEP4K_MAX_CHAINS];
 	u8 iqCalQCh[AR5416_EEP4K_MAX_CHAINS];
 	u8 pdGainOverlap;
-	u8 ob_01;
-	u8 db1_01;
+#ifdef __BIG_ENDIAN_BITFIELD
+	u8 ob_1:4, ob_0:4;
+	u8 db1_1:4, db1_0:4;
+#else
+	u8 ob_0:4, ob_1:4;
+	u8 db1_0:4, db1_1:4;
+#endif
 	u8 xpaBiasLvl;
 	u8 txFrameToDataStart;
 	u8 txFrameToPaOn;
@@ -415,11 +420,27 @@ struct modal_eep_4k_header {
 	u8 swSettleHt40;
 	u8 xatten2Db[AR5416_EEP4K_MAX_CHAINS];
 	u8 xatten2Margin[AR5416_EEP4K_MAX_CHAINS];
-	u8 db2_01;
+#ifdef __BIG_ENDIAN_BITFIELD
+	u8 db2_1:4, db2_0:4;
+#else
+	u8 db2_0:4, db2_1:4;
+#endif
 	u8 version;
-	u16 ob_234;
-	u16 db1_234;
-	u16 db2_234;
+#ifdef __BIG_ENDIAN_BITFIELD
+	u8 ob_3:4, ob_2:4;
+	u8 antdiv_ctl1:4, ob_4:4;
+	u8 db1_3:4, db1_2:4;
+	u8 antdiv_ctl2:4, db1_4:4;
+	u8 db2_2:4, db2_3:4;
+	u8 reserved:4, db2_4:4;
+#else
+	u8 ob_2:4, ob_3:4;
+	u8 ob_4:4, antdiv_ctl1:4;
+	u8 db1_2:4, db1_3:4;
+	u8 db1_4:4, antdiv_ctl2:4;
+	u8 db2_2:4, db2_3:4;
+	u8 db2_4:4, reserved:4;
+#endif
 	u8 futureModal[4];
 	struct spur_chan spurChans[AR5416_EEPROM_MODAL_SPURS];
 } __packed;
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index aafc6d3..c963615 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -197,9 +197,9 @@ static u32 ath9k_hw_4k_get_eeprom(struct ath_hw *ah,
 	case EEP_RF_SILENT:
 		return pBase->rfSilent;
 	case EEP_OB_2:
-		return pModal->ob_01;
+		return pModal->ob_0;
 	case EEP_DB_2:
-		return pModal->db1_01;
+		return pModal->db1_1;
 	case EEP_MINOR_REV:
 		return pBase->version & AR5416_EEP_VER_MINOR_MASK;
 	case EEP_TX_MASK:
@@ -923,58 +923,67 @@ static void ath9k_hw_4k_set_board_values(struct ath_hw *ah,
 
 	/* Initialize Ant Diversity settings from EEPROM */
 	if (pModal->version >= 3) {
-		ant_div_control1 = ((pModal->ob_234 >> 12) & 0xf);
-		ant_div_control2 = ((pModal->db1_234 >> 12) & 0xf);
-		regVal = REG_READ(ah, 0x99ac);
-		regVal &= (~(0x7f000000));
-		regVal |= ((ant_div_control1 & 0x1) << 24);
-		regVal |= (((ant_div_control1 >> 1) & 0x1) << 29);
-		regVal |= (((ant_div_control1 >> 2) & 0x1) << 30);
-		regVal |= ((ant_div_control2 & 0x3) << 25);
-		regVal |= (((ant_div_control2 >> 2) & 0x3) << 27);
-		REG_WRITE(ah, 0x99ac, regVal);
-		regVal = REG_READ(ah, 0x99ac);
-		regVal = REG_READ(ah, 0xa208);
-		regVal &= (~(0x1 << 13));
-		regVal |= (((ant_div_control1 >> 3) & 0x1) << 13);
-		REG_WRITE(ah, 0xa208, regVal);
-		regVal = REG_READ(ah, 0xa208);
+		ant_div_control1 = pModal->antdiv_ctl1;
+		ant_div_control2 = pModal->antdiv_ctl2;
+
+		regVal = REG_READ(ah, AR_PHY_MULTICHAIN_GAIN_CTL);
+		regVal &= (~(AR_PHY_9285_ANT_DIV_CTL_ALL));
+
+		regVal |= SM(ant_div_control1,
+			     AR_PHY_9285_ANT_DIV_CTL);
+		regVal |= SM(ant_div_control2,
+			     AR_PHY_9285_ANT_DIV_ALT_LNACONF);
+		regVal |= SM((ant_div_control2 >> 2),
+			     AR_PHY_9285_ANT_DIV_MAIN_LNACONF);
+		regVal |= SM((ant_div_control1 >> 1),
+			     AR_PHY_9285_ANT_DIV_ALT_GAINTB);
+		regVal |= SM((ant_div_control1 >> 2),
+			     AR_PHY_9285_ANT_DIV_MAIN_GAINTB);
+
+
+		REG_WRITE(ah, AR_PHY_MULTICHAIN_GAIN_CTL, regVal);
+		regVal = REG_READ(ah, AR_PHY_MULTICHAIN_GAIN_CTL);
+		regVal = REG_READ(ah, AR_PHY_CCK_DETECT);
+		regVal &= (~AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV);
+		regVal |= SM((ant_div_control1 >> 3),
+			     AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV);
+
+		REG_WRITE(ah, AR_PHY_CCK_DETECT, regVal);
+		regVal = REG_READ(ah, AR_PHY_CCK_DETECT);
 	}
 
 	if (pModal->version >= 2) {
-		ob[0] = (pModal->ob_01 & 0xf);
-		ob[1] = (pModal->ob_01 >> 4) & 0xf;
-		ob[2] = (pModal->ob_234 & 0xf);
-		ob[3] = ((pModal->ob_234 >> 4) & 0xf);
-		ob[4] = ((pModal->ob_234 >> 8) & 0xf);
-
-		db1[0] = (pModal->db1_01 & 0xf);
-		db1[1] = ((pModal->db1_01 >> 4) & 0xf);
-		db1[2] = (pModal->db1_234 & 0xf);
-		db1[3] = ((pModal->db1_234 >> 4) & 0xf);
-		db1[4] = ((pModal->db1_234 >> 8) & 0xf);
-
-		db2[0] = (pModal->db2_01 & 0xf);
-		db2[1] = ((pModal->db2_01 >> 4) & 0xf);
-		db2[2] = (pModal->db2_234 & 0xf);
-		db2[3] = ((pModal->db2_234 >> 4) & 0xf);
-		db2[4] = ((pModal->db2_234 >> 8) & 0xf);
-
+		ob[0] = pModal->ob_0;
+		ob[1] = pModal->ob_1;
+		ob[2] = pModal->ob_2;
+		ob[3] = pModal->ob_3;
+		ob[4] = pModal->ob_4;
+
+		db1[0] = pModal->db1_0;
+		db1[1] = pModal->db1_1;
+		db1[2] = pModal->db1_2;
+		db1[3] = pModal->db1_3;
+		db1[4] = pModal->db1_4;
+
+		db2[0] = pModal->db2_0;
+		db2[1] = pModal->db2_1;
+		db2[2] = pModal->db2_2;
+		db2[3] = pModal->db2_3;
+		db2[4] = pModal->db2_4;
 	} else if (pModal->version == 1) {
-		ob[0] = (pModal->ob_01 & 0xf);
-		ob[1] = ob[2] = ob[3] = ob[4] = (pModal->ob_01 >> 4) & 0xf;
-		db1[0] = (pModal->db1_01 & 0xf);
-		db1[1] = db1[2] = db1[3] =
-			db1[4] = ((pModal->db1_01 >> 4) & 0xf);
-		db2[0] = (pModal->db2_01 & 0xf);
-		db2[1] = db2[2] = db2[3] =
-			db2[4] = ((pModal->db2_01 >> 4) & 0xf);
+		ob[0] = pModal->ob_0;
+		ob[1] = ob[2] = ob[3] = ob[4] = pModal->ob_1;
+		db1[0] = pModal->db1_0;
+		db1[1] = db1[2] = db1[3] = db1[4] = pModal->db1_1;
+		db2[0] = pModal->db2_0;
+		db2[1] = db2[2] = db2[3] = db2[4] = pModal->db2_1;
 	} else {
 		int i;
+
 		for (i = 0; i < 5; i++) {
-			ob[i] = pModal->ob_01;
-			db1[i] = pModal->db1_01;
-			db2[i] = pModal->db1_01;
+			ob[i] = pModal->ob_0;
+			db1[i] = pModal->db1_0;
+			db2[i] = pModal->db1_0;
 		}
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/phy.h b/drivers/net/wireless/ath/ath9k/phy.h
index 5317e05..e83cd4a 100644
--- a/drivers/net/wireless/ath/ath9k/phy.h
+++ b/drivers/net/wireless/ath/ath9k/phy.h
@@ -419,6 +419,7 @@ bool ath9k_hw_init_rf(struct ath_hw *ah,
 #define AR_PHY_CCK_DETECT_ANT_SWITCH_TIME           0x00001FC0
 #define AR_PHY_CCK_DETECT_ANT_SWITCH_TIME_S         6
 #define AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV    0x2000
+#define AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV_S  13
 
 #define AR_PHY_GAIN_2GHZ                0xA20C
 #define AR_PHY_GAIN_2GHZ_RXTX_MARGIN    0x00FC0000
-- 
1.6.4

