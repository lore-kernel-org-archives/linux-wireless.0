Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54399 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137Ab1AURqn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 12:46:43 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH] ath9k_hw: replace magic values in register writes with proper defines
Date: Fri, 21 Jan 2011 18:46:35 +0100
Message-Id: <1295631995-27637-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   24 ++++++++++++------------
 drivers/net/wireless/ath/ath9k/ar9003_phy.h    |    2 ++
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 4819747..a256556 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3959,19 +3959,19 @@ static int ar9003_hw_tx_power_regwrite(struct ath_hw *ah, u8 * pPwrArray)
 {
 #define POW_SM(_r, _s)     (((_r) & 0x3f) << (_s))
 	/* make sure forced gain is not set */
-	REG_WRITE(ah, 0xa458, 0);
+	REG_WRITE(ah, AR_PHY_TX_FORCED_GAIN, 0);
 
 	/* Write the OFDM power per rate set */
 
 	/* 6 (LSB), 9, 12, 18 (MSB) */
-	REG_WRITE(ah, 0xa3c0,
+	REG_WRITE(ah, AR_PHY_POWER_TX_RATE(0),
 		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_6_24], 24) |
 		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_6_24], 16) |
 		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_6_24], 8) |
 		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_6_24], 0));
 
 	/* 24 (LSB), 36, 48, 54 (MSB) */
-	REG_WRITE(ah, 0xa3c4,
+	REG_WRITE(ah, AR_PHY_POWER_TX_RATE(1),
 		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_54], 24) |
 		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_48], 16) |
 		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_36], 8) |
@@ -3980,14 +3980,14 @@ static int ar9003_hw_tx_power_regwrite(struct ath_hw *ah, u8 * pPwrArray)
 	/* Write the CCK power per rate set */
 
 	/* 1L (LSB), reserved, 2L, 2S (MSB) */
-	REG_WRITE(ah, 0xa3c8,
+	REG_WRITE(ah, AR_PHY_POWER_TX_RATE(2),
 		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_1L_5L], 24) |
 		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_1L_5L], 16) |
 		  /* POW_SM(txPowerTimes2,  8) | this is reserved for AR9003 */
 		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_1L_5L], 0));
 
 	/* 5.5L (LSB), 5.5S, 11L, 11S (MSB) */
-	REG_WRITE(ah, 0xa3cc,
+	REG_WRITE(ah, AR_PHY_POWER_TX_RATE(3),
 		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_11S], 24) |
 		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_11L], 16) |
 		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_5S], 8) |
@@ -3997,7 +3997,7 @@ static int ar9003_hw_tx_power_regwrite(struct ath_hw *ah, u8 * pPwrArray)
 	/* Write the HT20 power per rate set */
 
 	/* 0/8/16 (LSB), 1-3/9-11/17-19, 4, 5 (MSB) */
-	REG_WRITE(ah, 0xa3d0,
+	REG_WRITE(ah, AR_PHY_POWER_TX_RATE(4),
 		  POW_SM(pPwrArray[ALL_TARGET_HT20_5], 24) |
 		  POW_SM(pPwrArray[ALL_TARGET_HT20_4], 16) |
 		  POW_SM(pPwrArray[ALL_TARGET_HT20_1_3_9_11_17_19], 8) |
@@ -4005,7 +4005,7 @@ static int ar9003_hw_tx_power_regwrite(struct ath_hw *ah, u8 * pPwrArray)
 	    );
 
 	/* 6 (LSB), 7, 12, 13 (MSB) */
-	REG_WRITE(ah, 0xa3d4,
+	REG_WRITE(ah, AR_PHY_POWER_TX_RATE(5),
 		  POW_SM(pPwrArray[ALL_TARGET_HT20_13], 24) |
 		  POW_SM(pPwrArray[ALL_TARGET_HT20_12], 16) |
 		  POW_SM(pPwrArray[ALL_TARGET_HT20_7], 8) |
@@ -4013,7 +4013,7 @@ static int ar9003_hw_tx_power_regwrite(struct ath_hw *ah, u8 * pPwrArray)
 	    );
 
 	/* 14 (LSB), 15, 20, 21 */
-	REG_WRITE(ah, 0xa3e4,
+	REG_WRITE(ah, AR_PHY_POWER_TX_RATE(9),
 		  POW_SM(pPwrArray[ALL_TARGET_HT20_21], 24) |
 		  POW_SM(pPwrArray[ALL_TARGET_HT20_20], 16) |
 		  POW_SM(pPwrArray[ALL_TARGET_HT20_15], 8) |
@@ -4023,7 +4023,7 @@ static int ar9003_hw_tx_power_regwrite(struct ath_hw *ah, u8 * pPwrArray)
 	/* Mixed HT20 and HT40 rates */
 
 	/* HT20 22 (LSB), HT20 23, HT40 22, HT40 23 (MSB) */
-	REG_WRITE(ah, 0xa3e8,
+	REG_WRITE(ah, AR_PHY_POWER_TX_RATE(10),
 		  POW_SM(pPwrArray[ALL_TARGET_HT40_23], 24) |
 		  POW_SM(pPwrArray[ALL_TARGET_HT40_22], 16) |
 		  POW_SM(pPwrArray[ALL_TARGET_HT20_23], 8) |
@@ -4035,7 +4035,7 @@ static int ar9003_hw_tx_power_regwrite(struct ath_hw *ah, u8 * pPwrArray)
 	 * correct PAR difference between HT40 and HT20/LEGACY
 	 * 0/8/16 (LSB), 1-3/9-11/17-19, 4, 5 (MSB)
 	 */
-	REG_WRITE(ah, 0xa3d8,
+	REG_WRITE(ah, AR_PHY_POWER_TX_RATE(6),
 		  POW_SM(pPwrArray[ALL_TARGET_HT40_5], 24) |
 		  POW_SM(pPwrArray[ALL_TARGET_HT40_4], 16) |
 		  POW_SM(pPwrArray[ALL_TARGET_HT40_1_3_9_11_17_19], 8) |
@@ -4043,7 +4043,7 @@ static int ar9003_hw_tx_power_regwrite(struct ath_hw *ah, u8 * pPwrArray)
 	    );
 
 	/* 6 (LSB), 7, 12, 13 (MSB) */
-	REG_WRITE(ah, 0xa3dc,
+	REG_WRITE(ah, AR_PHY_POWER_TX_RATE(7),
 		  POW_SM(pPwrArray[ALL_TARGET_HT40_13], 24) |
 		  POW_SM(pPwrArray[ALL_TARGET_HT40_12], 16) |
 		  POW_SM(pPwrArray[ALL_TARGET_HT40_7], 8) |
@@ -4051,7 +4051,7 @@ static int ar9003_hw_tx_power_regwrite(struct ath_hw *ah, u8 * pPwrArray)
 	    );
 
 	/* 14 (LSB), 15, 20, 21 */
-	REG_WRITE(ah, 0xa3ec,
+	REG_WRITE(ah, AR_PHY_POWER_TX_RATE(11),
 		  POW_SM(pPwrArray[ALL_TARGET_HT40_21], 24) |
 		  POW_SM(pPwrArray[ALL_TARGET_HT40_20], 16) |
 		  POW_SM(pPwrArray[ALL_TARGET_HT40_15], 8) |
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 59bab6b..8bdda2c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -486,6 +486,8 @@
 #define AR_PHY_HEAVYCLIP_40      (AR_SM_BASE + 0x1ac)
 #define AR_PHY_ILLEGAL_TXRATE    (AR_SM_BASE + 0x1b0)
 
+#define AR_PHY_POWER_TX_RATE(_d) (AR_SM_BASE + 0x1c0 + ((_d) << 2))
+
 #define AR_PHY_PWRTX_MAX         (AR_SM_BASE + 0x1f0)
 #define AR_PHY_POWER_TX_SUB      (AR_SM_BASE + 0x1f4)
 
-- 
1.7.3.2

