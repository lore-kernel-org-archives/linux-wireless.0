Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34092 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbcD1OqD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2016 10:46:03 -0400
Received: by mail-wm0-f65.google.com with SMTP id n129so14750222wmn.1
        for <linux-wireless@vger.kernel.org>; Thu, 28 Apr 2016 07:46:01 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, kvalo@qca.qualcomm.com,
	ath9k-devel@qca.qualcomm.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 1/3] ath9k: reuse ar9003_hw_tx_power_regwrite for tx99 setup
Date: Thu, 28 Apr 2016 16:45:04 +0200
Message-Id: <1461854706-10494-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20160428_164607_072138_E055E385)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The same functionality as ar9003_hw_tx_power_regwrite is hardcoded in
ar9003_hw_tx99_set_txpower. Just reuse the existing ar9003_hw_tx_power_regwrite
for TX99 setup too.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |  2 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h |  1 +
 drivers/net/wireless/ath/ath9k/ar9003_phy.c    | 60 ++------------------------
 3 files changed, 5 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index f680982..dec1a31 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -4402,7 +4402,7 @@ static void ar9003_hw_selfgen_tpc_txpower(struct ath_hw *ah,
 }
 
 /* Set tx power registers to array of values passed in */
-static int ar9003_hw_tx_power_regwrite(struct ath_hw *ah, u8 * pPwrArray)
+int ar9003_hw_tx_power_regwrite(struct ath_hw *ah, u8 * pPwrArray)
 {
 #define POW_SM(_r, _s)     (((_r) & 0x3f) << (_s))
 	/* make sure forced gain is not set */
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
index 694ca2e..107bcfb 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
@@ -355,5 +355,6 @@ unsigned int ar9003_get_paprd_scale_factor(struct ath_hw *ah,
 					   struct ath9k_channel *chan);
 
 void ar9003_hw_internal_regulator_apply(struct ath_hw *ah);
+int ar9003_hw_tx_power_regwrite(struct ath_hw *ah, u8 * pPwrArray);
 
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index be14a8e..2f15cbc 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -17,6 +17,7 @@
 #include <linux/export.h>
 #include "hw.h"
 #include "ar9003_phy.h"
+#include "ar9003_eeprom.h"
 
 #define AR9300_OFDM_RATES	8
 #define AR9300_HT_SS_RATES	8
@@ -1840,7 +1841,7 @@ static void ar9003_hw_tx99_stop(struct ath_hw *ah)
 
 static void ar9003_hw_tx99_set_txpower(struct ath_hw *ah, u8 txpower)
 {
-	static s16 p_pwr_array[ar9300RateSize] = { 0 };
+	static u8 p_pwr_array[ar9300RateSize] = { 0 };
 	unsigned int i;
 
 	if (txpower <= MAX_RATE_POWER) {
@@ -1851,62 +1852,7 @@ static void ar9003_hw_tx99_set_txpower(struct ath_hw *ah, u8 txpower)
 			p_pwr_array[i] = MAX_RATE_POWER;
 	}
 
-	REG_WRITE(ah, 0xa458, 0);
-
-	REG_WRITE(ah, 0xa3c0,
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_LEGACY_6_24], 24) |
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_LEGACY_6_24], 16) |
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_LEGACY_6_24],  8) |
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_LEGACY_6_24],  0));
-	REG_WRITE(ah, 0xa3c4,
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_LEGACY_54],  24) |
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_LEGACY_48],  16) |
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_LEGACY_36],   8) |
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_LEGACY_6_24], 0));
-	REG_WRITE(ah, 0xa3c8,
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_LEGACY_1L_5L], 24) |
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_LEGACY_1L_5L], 16) |
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_LEGACY_1L_5L],  0));
-	REG_WRITE(ah, 0xa3cc,
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_LEGACY_11S],   24) |
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_LEGACY_11L],   16) |
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_LEGACY_5S],     8) |
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_LEGACY_1L_5L],  0));
-	REG_WRITE(ah, 0xa3d0,
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT20_5],  24) |
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT20_4],  16) |
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT20_1_3_9_11_17_19], 8)|
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT20_0_8_16], 0));
-	REG_WRITE(ah, 0xa3d4,
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT20_13], 24) |
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT20_12], 16) |
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT20_7],   8) |
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT20_6],   0));
-	REG_WRITE(ah, 0xa3e4,
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT20_21], 24) |
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT20_20], 16) |
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT20_15],  8) |
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT20_14],  0));
-	REG_WRITE(ah, 0xa3e8,
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT40_23], 24) |
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT40_22], 16) |
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT20_23],  8) |
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT20_22],  0));
-	REG_WRITE(ah, 0xa3d8,
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT40_5], 24) |
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT40_4], 16) |
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT40_1_3_9_11_17_19], 8) |
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT40_0_8_16], 0));
-	REG_WRITE(ah, 0xa3dc,
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT40_13], 24) |
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT40_12], 16) |
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT40_7],   8) |
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT40_6],   0));
-	REG_WRITE(ah, 0xa3ec,
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT40_21], 24) |
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT40_20], 16) |
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT40_15],  8) |
-		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT40_14],  0));
+	ar9003_hw_tx_power_regwrite(ah, p_pwr_array);
 }
 
 static void ar9003_hw_init_txpower_cck(struct ath_hw *ah, u8 *rate_array)
-- 
2.8.1

