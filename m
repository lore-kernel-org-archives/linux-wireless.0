Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55430 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755910Ab2CNPkp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 11:40:45 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 11/14] ath9k_hw: clean up iniModesAdditional
Date: Wed, 14 Mar 2012 16:40:31 +0100
Message-Id: <1331739634-22318-11-git-send-email-nbd@openwrt.org> (sfid-20120314_164103_249545_C8AFAA8D)
In-Reply-To: <1331739634-22318-10-git-send-email-nbd@openwrt.org>
References: <1331739634-22318-1-git-send-email-nbd@openwrt.org>
 <1331739634-22318-2-git-send-email-nbd@openwrt.org>
 <1331739634-22318-3-git-send-email-nbd@openwrt.org>
 <1331739634-22318-4-git-send-email-nbd@openwrt.org>
 <1331739634-22318-5-git-send-email-nbd@openwrt.org>
 <1331739634-22318-6-git-send-email-nbd@openwrt.org>
 <1331739634-22318-7-git-send-email-nbd@openwrt.org>
 <1331739634-22318-8-git-send-email-nbd@openwrt.org>
 <1331739634-22318-9-git-send-email-nbd@openwrt.org>
 <1331739634-22318-10-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

use iniModesFastClock for 5 ghz fast clock specific settings, and
iniAdditional for clock/chip specific initval overrides

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c |    5 ++---
 drivers/net/wireless/ath/ath9k/ar9002_hw.c  |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c  |   25 +++++++++++++------------
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   16 ++++------------
 drivers/net/wireless/ath/ath9k/hw.h         |    4 ++--
 5 files changed, 22 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 86a891f..5d34e57 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -869,10 +869,9 @@ static int ar5008_hw_process_ini(struct ath_hw *ah,
 
 	REG_WRITE_ARRAY(&ah->iniBB_RfGain, freqIndex, regWrites);
 
-	if (IS_CHAN_A_FAST_CLOCK(ah, chan)) {
-		REG_WRITE_ARRAY(&ah->iniModesAdditional, modesIndex,
+	if (IS_CHAN_A_FAST_CLOCK(ah, chan))
+		REG_WRITE_ARRAY(&ah->iniModesFastClock, modesIndex,
 				regWrites);
-	}
 
 	ar5008_hw_override_ini(ah, chan);
 	ar5008_hw_set_channel_regs(ah, chan);
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index 1d06dab..7098cd8 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -73,7 +73,7 @@ static void ar9002_hw_init_mode_regs(struct ath_hw *ah)
 		INIT_INI_ARRAY(&ah->iniCommon, ar9280Common_9280_2,
 			       ARRAY_SIZE(ar9280Common_9280_2), 2);
 
-		INIT_INI_ARRAY(&ah->iniModesAdditional,
+		INIT_INI_ARRAY(&ah->iniModesFastClock,
 			       ar9280Modes_fast_clock_9280_2,
 			       ARRAY_SIZE(ar9280Modes_fast_clock_9280_2), 3);
 	} else if (AR_SREV_9160_10_OR_LATER(ah)) {
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 7b4aa00..0f56e32 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -87,11 +87,11 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 
 		/* additional clock settings */
 		if (ah->is_clk_25mhz)
-			INIT_INI_ARRAY(&ah->iniModesAdditional,
+			INIT_INI_ARRAY(&ah->iniAdditional,
 					ar9331_1p1_xtal_25M,
 					ARRAY_SIZE(ar9331_1p1_xtal_25M), 2);
 		else
-			INIT_INI_ARRAY(&ah->iniModesAdditional,
+			INIT_INI_ARRAY(&ah->iniAdditional,
 					ar9331_1p1_xtal_40M,
 					ARRAY_SIZE(ar9331_1p1_xtal_40M), 2);
 	} else if (AR_SREV_9330_12(ah)) {
@@ -140,11 +140,11 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 
 		/* additional clock settings */
 		if (ah->is_clk_25mhz)
-			INIT_INI_ARRAY(&ah->iniModesAdditional,
+			INIT_INI_ARRAY(&ah->iniAdditional,
 					ar9331_1p2_xtal_25M,
 					ARRAY_SIZE(ar9331_1p2_xtal_25M), 2);
 		else
-			INIT_INI_ARRAY(&ah->iniModesAdditional,
+			INIT_INI_ARRAY(&ah->iniAdditional,
 					ar9331_1p2_xtal_40M,
 					ARRAY_SIZE(ar9331_1p2_xtal_40M), 2);
 	} else if (AR_SREV_9340(ah)) {
@@ -194,15 +194,16 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 				ARRAY_SIZE(ar9340Modes_high_ob_db_tx_gain_table_1p0),
 				5);
 
-		INIT_INI_ARRAY(&ah->iniModesAdditional,
+		INIT_INI_ARRAY(&ah->iniModesFastClock,
 				ar9340Modes_fast_clock_1p0,
 				ARRAY_SIZE(ar9340Modes_fast_clock_1p0),
 				3);
 
-		INIT_INI_ARRAY(&ah->iniModesAdditional_40M,
-				ar9340_1p0_radio_core_40M,
-				ARRAY_SIZE(ar9340_1p0_radio_core_40M),
-				2);
+		if (!ah->is_clk_25mhz)
+			INIT_INI_ARRAY(&ah->iniAdditional,
+				       ar9340_1p0_radio_core_40M,
+				       ARRAY_SIZE(ar9340_1p0_radio_core_40M),
+				       2);
 	} else if (AR_SREV_9485_11(ah)) {
 		/* mac */
 		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_PRE], NULL, 0, 0);
@@ -321,7 +322,7 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 				2);
 
 		/* Fast clock modal settings */
-		INIT_INI_ARRAY(&ah->iniModesAdditional,
+		INIT_INI_ARRAY(&ah->iniModesFastClock,
 				ar9462_modes_fast_clock_2p0,
 				ARRAY_SIZE(ar9462_modes_fast_clock_2p0), 3);
 
@@ -378,7 +379,7 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 				ARRAY_SIZE(ar9580_1p0_low_ob_db_tx_gain_table),
 				5);
 
-		INIT_INI_ARRAY(&ah->iniModesAdditional,
+		INIT_INI_ARRAY(&ah->iniModesFastClock,
 				ar9580_1p0_modes_fast_clock,
 				ARRAY_SIZE(ar9580_1p0_modes_fast_clock),
 				3);
@@ -445,7 +446,7 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 				2);
 
 		/* Fast clock modal settings */
-		INIT_INI_ARRAY(&ah->iniModesAdditional,
+		INIT_INI_ARRAY(&ah->iniModesFastClock,
 				ar9300Modes_fast_clock_2p2,
 				ARRAY_SIZE(ar9300Modes_fast_clock_2p2),
 				3);
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 99b64f2..bc992b2 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -679,14 +679,10 @@ static int ar9003_hw_process_ini(struct ath_hw *ah,
 	 * different modal values.
 	 */
 	if (IS_CHAN_A_FAST_CLOCK(ah, chan))
-		REG_WRITE_ARRAY(&ah->iniModesAdditional,
+		REG_WRITE_ARRAY(&ah->iniModesFastClock,
 				modesIndex, regWrites);
 
-	if (AR_SREV_9330(ah))
-		REG_WRITE_ARRAY(&ah->iniModesAdditional, 1, regWrites);
-
-	if (AR_SREV_9340(ah) && !ah->is_clk_25mhz)
-		REG_WRITE_ARRAY(&ah->iniModesAdditional_40M, 1, regWrites);
+	REG_WRITE_ARRAY(&ah->iniAdditional, 1, regWrites);
 
 	if (AR_SREV_9462(ah))
 		ar9003_hw_prog_ini(ah, &ah->ini_BTCOEX_MAX_TXPWR, 1);
@@ -1323,13 +1319,9 @@ static int ar9003_hw_fast_chan_change(struct ath_hw *ah,
 	 * different modal values.
 	 */
 	if (IS_CHAN_A_FAST_CLOCK(ah, chan))
-		REG_WRITE_ARRAY(&ah->iniModesAdditional, modesIndex, regWrites);
-
-	if (AR_SREV_9330(ah))
-		REG_WRITE_ARRAY(&ah->iniModesAdditional, 1, regWrites);
+		REG_WRITE_ARRAY(&ah->iniModesFastClock, modesIndex, regWrites);
 
-	if (AR_SREV_9340(ah) && !ah->is_clk_25mhz)
-		REG_WRITE_ARRAY(&ah->iniModesAdditional_40M, 1, regWrites);
+	REG_WRITE_ARRAY(&ah->iniAdditional, 1, regWrites);
 
 	ah->modes_index = modesIndex;
 	*ini_reloaded = true;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 7efb06d..e6a358e 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -827,8 +827,8 @@ struct ath_hw {
 	struct ar5416IniArray iniAddac;
 	struct ar5416IniArray iniPcieSerdes;
 	struct ar5416IniArray iniPcieSerdesLowPower;
-	struct ar5416IniArray iniModesAdditional;
-	struct ar5416IniArray iniModesAdditional_40M;
+	struct ar5416IniArray iniModesFastClock;
+	struct ar5416IniArray iniAdditional;
 	struct ar5416IniArray iniModesRxGain;
 	struct ar5416IniArray iniModesTxGain;
 	struct ar5416IniArray iniModes_9271_1_0_only;
-- 
1.7.3.2

