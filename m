Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:50408 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072Ab2DRIVD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 04:21:03 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [RFC] ath9k: fix TX power reporting on AR9003 chips
Date: Wed, 18 Apr 2012 11:16:29 +0200
Message-Id: <1334740589-7853-1-git-send-email-juhosg@openwrt.org> (sfid-20120418_102108_853951_2E7C0A9A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current code unconditionally reads the target
power values for all modes from the EEPROM. However
In 'ar9003_hw_set_power_per_rate_table' the regulatory
caps are applied only on a mode specific subset of the
power values.

The reported TX power level is calculated from the
maximum of the power values. Because some of these
values are uncapped in certain cases, the reported
TX power will be wrong.

On the older chipset, we don't have such problems
because only the mode specific subset of the power
levels are retrieved from the EEPROM on those. Do
the same for the AR9003 chips to fix the issue.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
Test results on the built-in wireless MAC of the AR9344 SoC:

Freq  mode     power      reported power
               limit    w/ patch  w/o patch
2412  legacy   3 dBm      3 dBm    22 dBm
2412  legacy   4 dBm      4 dBm    19 dBm
2412  legacy   5 dBm      5 dBm    19 dBm
2412  legacy   6 dBm      6 dBm    19 dBm
2412  legacy   7 dBm      7 dBm    19 dBm
2412  legacy   8 dBm      8 dBm    19 dBm
2412  legacy   9 dBm      9 dBm    19 dBm
2412  legacy  10 dBm     10 dBm    19 dBm
2412  legacy  11 dBm     11 dBm    19 dBm
2412  legacy  12 dBm     12 dBm    19 dBm
2412  legacy  13 dBm     13 dBm    19 dBm
2412  legacy  14 dBm     14 dBm    19 dBm
2412  legacy  15 dBm     15 dBm    19 dBm
2412  legacy  16 dBm     16 dBm    19 dBm
2412  legacy  17 dBm     17 dBm    19 dBm

2412  HT20     3 dBm      3 dBm    19 dBm
2412  HT20     4 dBm      4 dBm    19 dBm
2412  HT20     5 dBm      5 dBm    19 dBm
2412  HT20     6 dBm      6 dBm    19 dBm
2412  HT20     7 dBm      7 dBm    19 dBm
2412  HT20     8 dBm      8 dBm    19 dBm
2412  HT20     9 dBm      9 dBm    19 dBm
2412  HT20    10 dBm     10 dBm    19 dBm
2412  HT20    11 dBm     11 dBm    19 dBm
2412  HT20    12 dBm     12 dBm    19 dBm
2412  HT20    13 dBm     13 dBm    19 dBm
2412  HT20    14 dBm     14 dBm    19 dBm
2412  HT20    15 dBm     15 dBm    19 dBm
2412  HT20    16 dBm     16 dBm    19 dBm
2412  HT20    17 dBm     17 dBm    19 dBm

2412  HT40+    3 dBm      3 dBm    19 dBm
2412  HT40+    4 dBm      4 dBm     4 dBm
2412  HT40+    5 dBm      5 dBm     5 dBm
2412  HT40+    6 dBm      6 dBm     6 dBm
2412  HT40+    7 dBm      7 dBm     7 dBm
2412  HT40+    8 dBm      8 dBm     8 dBm
2412  HT40+    9 dBm      9 dBm     9 dBm
2412  HT40+   10 dBm     10 dBm    10 dBm
2412  HT40+   11 dBm     11 dBm    11 dBm
2412  HT40+   12 dBm     12 dBm    12 dBm
2412  HT40+   13 dBm     13 dBm    13 dBm
2412  HT40+   14 dBm     14 dBm    14 dBm
2412  HT40+   15 dBm     15 dBm    15 dBm
2412  HT40+   16 dBm     16 dBm    16 dBm
2412  HT40+   17 dBm     17 dBm    17 dBm

5180  legacy   3 dBm      3 dBm     3 dBm
5180  legacy   4 dBm      4 dBm    22 dBm
5180  legacy   5 dBm      5 dBm    22 dBm
5180  legacy   6 dBm      6 dBm    22 dBm
5180  legacy   7 dBm      7 dBm    22 dBm
5180  legacy   8 dBm      8 dBm    22 dBm
5180  legacy   9 dBm      9 dBm    22 dBm
5180  legacy  10 dBm     10 dBm    22 dBm
5180  legacy  11 dBm     11 dBm    22 dBm
5180  legacy  12 dBm     12 dBm    22 dBm
5180  legacy  13 dBm     13 dBm    22 dBm
5180  legacy  14 dBm     14 dBm    22 dBm
5180  legacy  15 dBm     15 dBm    22 dBm
5180  legacy  16 dBm     16 dBm    22 dBm
5180  legacy  17 dBm     17 dBm    22 dBm

5180  HT20     3 dBm      3 dBm    22 dBm
5180  HT20     4 dBm      4 dBm    22 dBm
5180  HT20     5 dBm      5 dBm    22 dBm
5180  HT20     6 dBm      6 dBm    22 dBm
5180  HT20     7 dBm      7 dBm    22 dBm
5180  HT20     8 dBm      8 dBm    22 dBm
5180  HT20     9 dBm      9 dBm    22 dBm
5180  HT20    10 dBm     10 dBm    22 dBm
5180  HT20    11 dBm     11 dBm    22 dBm
5180  HT20    12 dBm     12 dBm    22 dBm
5180  HT20    13 dBm     13 dBm    22 dBm
5180  HT20    14 dBm     14 dBm    22 dBm
5180  HT20    15 dBm     15 dBm    22 dBm
5180  HT20    16 dBm     16 dBm    22 dBm
5180  HT20    17 dBm     17 dBm    22 dBm

5180  HT40+    3 dBm      3 dBm    22 dBm
5180  HT40+    4 dBm      4 dBm    20 dBm
5180  HT40+    5 dBm      5 dBm    20 dBm
5180  HT40+    6 dBm      6 dBm    20 dBm
5180  HT40+    7 dBm      7 dBm    20 dBm
5180  HT40+    8 dBm      8 dBm    20 dBm
5180  HT40+    9 dBm      9 dBm    20 dBm
5180  HT40+   10 dBm     10 dBm    20 dBm
5180  HT40+   11 dBm     11 dBm    20 dBm
5180  HT40+   12 dBm     12 dBm    20 dBm
5180  HT40+   13 dBm     13 dBm    20 dBm
5180  HT40+   14 dBm     14 dBm    20 dBm
5180  HT40+   15 dBm     15 dBm    20 dBm
5180  HT40+   16 dBm     16 dBm    20 dBm
5180  HT40+   17 dBm     17 dBm    20 dBm
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   58 +++++++++++++++++++-----
 1 files changed, 46 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 1188db2..80c89c9 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -4281,18 +4281,10 @@ static int ar9003_hw_tx_power_regwrite(struct ath_hw *ah, u8 * pPwrArray)
 #undef POW_SM
 }
 
-static void ar9003_hw_set_target_power_eeprom(struct ath_hw *ah, u16 freq,
-					      u8 *targetPowerValT2)
+static void ar9003_hw_get_legacy_target_powers(struct ath_hw *ah, u16 freq,
+					       u8 *targetPowerValT2,
+					       bool is2GHz)
 {
-	/* XXX: hard code for now, need to get from eeprom struct */
-	u8 ht40PowerIncForPdadc = 0;
-	bool is2GHz = false;
-	unsigned int i = 0;
-	struct ath_common *common = ath9k_hw_common(ah);
-
-	if (freq < 4000)
-		is2GHz = true;
-
 	targetPowerValT2[ALL_TARGET_LEGACY_6_24] =
 	    ar9003_hw_eeprom_get_tgt_pwr(ah, LEGACY_TARGET_RATE_6_24, freq,
 					 is2GHz);
@@ -4305,6 +4297,11 @@ static void ar9003_hw_set_target_power_eeprom(struct ath_hw *ah, u16 freq,
 	targetPowerValT2[ALL_TARGET_LEGACY_54] =
 	    ar9003_hw_eeprom_get_tgt_pwr(ah, LEGACY_TARGET_RATE_54, freq,
 					 is2GHz);
+}
+
+static void ar9003_hw_get_cck_target_powers(struct ath_hw *ah, u16 freq,
+					    u8 *targetPowerValT2)
+{
 	targetPowerValT2[ALL_TARGET_LEGACY_1L_5L] =
 	    ar9003_hw_eeprom_get_cck_tgt_pwr(ah, LEGACY_TARGET_RATE_1L_5L,
 					     freq);
@@ -4314,6 +4311,11 @@ static void ar9003_hw_set_target_power_eeprom(struct ath_hw *ah, u16 freq,
 	    ar9003_hw_eeprom_get_cck_tgt_pwr(ah, LEGACY_TARGET_RATE_11L, freq);
 	targetPowerValT2[ALL_TARGET_LEGACY_11S] =
 	    ar9003_hw_eeprom_get_cck_tgt_pwr(ah, LEGACY_TARGET_RATE_11S, freq);
+}
+
+static void ar9003_hw_get_ht20_target_powers(struct ath_hw *ah, u16 freq,
+					     u8 *targetPowerValT2, bool is2GHz)
+{
 	targetPowerValT2[ALL_TARGET_HT20_0_8_16] =
 	    ar9003_hw_eeprom_get_ht20_tgt_pwr(ah, HT_TARGET_RATE_0_8_16, freq,
 					      is2GHz);
@@ -4356,6 +4358,16 @@ static void ar9003_hw_set_target_power_eeprom(struct ath_hw *ah, u16 freq,
 	targetPowerValT2[ALL_TARGET_HT20_23] =
 	    ar9003_hw_eeprom_get_ht20_tgt_pwr(ah, HT_TARGET_RATE_23, freq,
 					      is2GHz);
+}
+
+static void ar9003_hw_get_ht40_target_powers(struct ath_hw *ah,
+						   u16 freq,
+						   u8 *targetPowerValT2,
+						   bool is2GHz)
+{
+	/* XXX: hard code for now, need to get from eeprom struct */
+	u8 ht40PowerIncForPdadc = 0;
+
 	targetPowerValT2[ALL_TARGET_HT40_0_8_16] =
 	    ar9003_hw_eeprom_get_ht40_tgt_pwr(ah, HT_TARGET_RATE_0_8_16, freq,
 					      is2GHz) + ht40PowerIncForPdadc;
@@ -4399,6 +4411,26 @@ static void ar9003_hw_set_target_power_eeprom(struct ath_hw *ah, u16 freq,
 	targetPowerValT2[ALL_TARGET_HT40_23] =
 	    ar9003_hw_eeprom_get_ht40_tgt_pwr(ah, HT_TARGET_RATE_23, freq,
 					      is2GHz) + ht40PowerIncForPdadc;
+}
+
+static void ar9003_hw_get_target_power_eeprom(struct ath_hw *ah,
+					      struct ath9k_channel *chan,
+					      u8 *targetPowerValT2)
+{
+	bool is2GHz = IS_CHAN_2GHZ(chan);
+	unsigned int i = 0;
+	struct ath_common *common = ath9k_hw_common(ah);
+	u16 freq = chan->channel;
+
+	if (is2GHz)
+		ar9003_hw_get_cck_target_powers(ah, freq, targetPowerValT2);
+
+	ar9003_hw_get_legacy_target_powers(ah, freq, targetPowerValT2, is2GHz);
+	ar9003_hw_get_ht20_target_powers(ah, freq, targetPowerValT2, is2GHz);
+
+	if (IS_CHAN_HT40(chan))
+		ar9003_hw_get_ht40_target_powers(ah, freq, targetPowerValT2,
+						 is2GHz);
 
 	for (i = 0; i < ar9300RateSize; i++) {
 		ath_dbg(common, EEPROM, "TPC[%02d] 0x%08x\n",
@@ -4952,7 +4984,9 @@ static void ath9k_hw_ar9300_set_txpower(struct ath_hw *ah,
 	unsigned int i = 0, paprd_scale_factor = 0;
 	u8 pwr_idx, min_pwridx = 0;
 
-	ar9003_hw_set_target_power_eeprom(ah, chan->channel, targetPowerValT2);
+	memset(targetPowerValT2, 0 , sizeof(targetPowerValT2));
+
+	ar9003_hw_get_target_power_eeprom(ah, chan, targetPowerValT2);
 
 	if (ah->eep_ops->get_eeprom(ah, EEP_PAPRD)) {
 		if (IS_CHAN_2GHZ(chan))
-- 
1.7.2.1

