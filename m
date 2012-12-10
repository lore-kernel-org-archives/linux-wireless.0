Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plsmtpa01-01.prod.sin2.secureserver.net ([182.50.145.6]:38884
	"EHLO sg2plsmtpa01-01.prod.sin2.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361Ab2LJBxW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Dec 2012 20:53:22 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 8/8] ath9k_hw: Calculate the correct training power for PAPRD
Date: Mon, 10 Dec 2012 07:22:38 +0530
Message-Id: <1355104358-30062-8-git-send-email-sujith@msujith.org> (sfid-20121210_025337_898727_4BB69B7C)
In-Reply-To: <1355104358-30062-1-git-send-email-sujith@msujith.org>
References: <1355104358-30062-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Assign the training power for PAPRD based on the chip.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 41 ++++++++++++++++++--------
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c  | 22 +++++++++-----
 2 files changed, 43 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 6b8861c..11082b4 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -5072,6 +5072,33 @@ static inline u8 mcsidx_to_tgtpwridx(unsigned int mcs_idx, u8 base_pwridx)
 		return base_pwridx + 4 * (mcs_idx / 8) + mod_idx - 2;
 }
 
+static void ar9003_paprd_set_txpower(struct ath_hw *ah,
+				     struct ath9k_channel *chan,
+				     u8 *targetPowerValT2)
+{
+	int i;
+
+	if (!ar9003_is_paprd_enabled(ah))
+		return;
+
+	if (IS_CHAN_HT40(chan))
+		i = ALL_TARGET_HT40_7;
+	else
+		i = ALL_TARGET_HT20_7;
+
+	if (IS_CHAN_2GHZ(chan)) {
+		if (!AR_SREV_9330(ah) && !AR_SREV_9340(ah) &&
+		    !AR_SREV_9462(ah) && !AR_SREV_9565(ah)) {
+			if (IS_CHAN_HT40(chan))
+				i = ALL_TARGET_HT40_0_8_16;
+			else
+				i = ALL_TARGET_HT20_0_8_16;
+		}
+	}
+
+	ah->paprd_target_power = targetPowerValT2[i];
+}
+
 static void ath9k_hw_ar9300_set_txpower(struct ath_hw *ah,
 					struct ath9k_channel *chan, u16 cfgCtl,
 					u8 twiceAntennaReduction,
@@ -5166,19 +5193,7 @@ static void ath9k_hw_ar9300_set_txpower(struct ath_hw *ah,
 	/* Write target power array to registers */
 	ar9003_hw_tx_power_regwrite(ah, targetPowerValT2);
 	ar9003_hw_calibration_apply(ah, chan->channel);
-
-	if (IS_CHAN_2GHZ(chan)) {
-		if (IS_CHAN_HT40(chan))
-			i = ALL_TARGET_HT40_0_8_16;
-		else
-			i = ALL_TARGET_HT20_0_8_16;
-	} else {
-		if (IS_CHAN_HT40(chan))
-			i = ALL_TARGET_HT40_7;
-		else
-			i = ALL_TARGET_HT20_7;
-	}
-	ah->paprd_target_power = targetPowerValT2[i];
+	ar9003_paprd_set_txpower(ah, chan, targetPowerValT2);
 }
 
 static u16 ath9k_hw_ar9300_get_spur_channel(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
index aea1908..09c1f9d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
@@ -74,15 +74,23 @@ static int ar9003_get_training_power_2g(struct ath_hw *ah)
 	unsigned int power, scale, delta;
 
 	scale = ar9003_get_paprd_scale_factor(ah, chan);
-	power = REG_READ_FIELD(ah, AR_PHY_POWERTX_RATE5,
-			       AR_PHY_POWERTX_RATE5_POWERTXHT20_0);
 
-	delta = abs((int) ah->paprd_target_power - (int) power);
-	if (delta > scale)
-		return -1;
+	if (AR_SREV_9330(ah) || AR_SREV_9340(ah) ||
+	    AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
+		power = ah->paprd_target_power + 2;
+	} else if (AR_SREV_9485(ah)) {
+		power = 25;
+	} else {
+		power = REG_READ_FIELD(ah, AR_PHY_POWERTX_RATE5,
+				       AR_PHY_POWERTX_RATE5_POWERTXHT20_0);
+
+		delta = abs((int) ah->paprd_target_power - (int) power);
+		if (delta > scale)
+			return -1;
 
-	if (delta < 4)
-		power -= 4 - delta;
+		if (delta < 4)
+			power -= 4 - delta;
+	}
 
 	return power;
 }
-- 
1.8.0.1

