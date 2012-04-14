Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:35311 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755966Ab2DNUY6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Apr 2012 16:24:58 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 2/3] ath9k: introduce ath9k_hw_get_scaled_power helper
Date: Sat, 14 Apr 2012 22:01:58 +0200
Message-Id: <1334433719-1144-2-git-send-email-juhosg@openwrt.org> (sfid-20120414_222502_010682_CFC37B2A)
In-Reply-To: <1334433719-1144-1-git-send-email-juhosg@openwrt.org>
References: <1334433719-1144-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The computation of the scaled power value in
various eeprom files uses identical code. Move
that code into a helper function and use that
instead of code duplication.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   28 +------------------
 drivers/net/wireless/ath/ath9k/eeprom.c        |   33 ++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/eeprom.h        |    5 +++
 drivers/net/wireless/ath/ath9k/eeprom_9287.c   |   30 +--------------------
 drivers/net/wireless/ath/ath9k/eeprom_def.c    |   23 +---------------
 5 files changed, 44 insertions(+), 75 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 25a4a02..d254571 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -30,8 +30,6 @@
 #define CTL_11A_EXT (CTL_11A | EXT_ADDITIVE)
 #define CTL_11G_EXT (CTL_11G | EXT_ADDITIVE)
 #define CTL_11B_EXT (CTL_11B | EXT_ADDITIVE)
-#define REDUCE_SCALED_POWER_BY_TWO_CHAIN     6  /* 10*log10(2)*2 */
-#define REDUCE_SCALED_POWER_BY_THREE_CHAIN   10 /* 10*log10(3)*2 */
 #define PWRINCR_3_TO_1_CHAIN      9             /* 10*log(3)*2 */
 #define PWRINCR_3_TO_2_CHAIN      3             /* floor(10*log(3/2)*2) */
 #define PWRINCR_2_TO_1_CHAIN      6             /* 10*log(2)*2 */
@@ -4789,30 +4787,8 @@ static void ar9003_hw_set_power_per_rate_table(struct ath_hw *ah,
 	bool is2ghz = IS_CHAN_2GHZ(chan);
 
 	ath9k_hw_get_channel_centers(ah, chan, &centers);
-	scaledPower = powerLimit - antenna_reduction;
-
-	/*
-	 * Reduce scaled Power by number of chains active to get
-	 * to per chain tx power level
-	 */
-	switch (ar5416_get_ntxchains(ah->txchainmask)) {
-	case 1:
-		break;
-	case 2:
-		if (scaledPower > REDUCE_SCALED_POWER_BY_TWO_CHAIN)
-			scaledPower -= REDUCE_SCALED_POWER_BY_TWO_CHAIN;
-		else
-			scaledPower = 0;
-		break;
-	case 3:
-		if (scaledPower > REDUCE_SCALED_POWER_BY_THREE_CHAIN)
-			scaledPower -= REDUCE_SCALED_POWER_BY_THREE_CHAIN;
-		else
-			scaledPower = 0;
-		break;
-	}
-
-	scaledPower = max((u16)0, scaledPower);
+	scaledPower = ath9k_hw_get_scaled_power(ah, powerLimit,
+						antenna_reduction);
 
 	/*
 	 * Get target powers from EEPROM - our baseline for TX Power
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index c435232..61bad99 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -290,6 +290,39 @@ u16 ath9k_hw_get_max_edge_power(u16 freq, struct cal_ctl_edges *pRdEdgesPower,
 	return twiceMaxEdgePower;
 }
 
+u16 ath9k_hw_get_scaled_power(struct ath_hw *ah, u16 power_limit,
+			      u8 antenna_reduction)
+{
+	u16 scaled_power;
+
+	scaled_power = power_limit - antenna_reduction;
+
+	/*
+	 * Reduce scaled Power by number of chains active
+	 * to get the per chain tx power level.
+	 */
+	switch (ar5416_get_ntxchains(ah->txchainmask)) {
+	case 1:
+		break;
+	case 2:
+		if (scaled_power > REDUCE_SCALED_POWER_BY_TWO_CHAIN)
+			scaled_power -= REDUCE_SCALED_POWER_BY_TWO_CHAIN;
+		else
+			scaled_power = 0;
+		break;
+	case 3:
+		if (scaled_power > REDUCE_SCALED_POWER_BY_THREE_CHAIN)
+			scaled_power -= REDUCE_SCALED_POWER_BY_THREE_CHAIN;
+		else
+			scaled_power = 0;
+		break;
+	}
+
+	scaled_power = max((u16)0, scaled_power);
+
+	return scaled_power;
+}
+
 void ath9k_hw_update_regulatory_maxpower(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 5ff7ab9..8d779b4 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -82,6 +82,9 @@
 #define INCREASE_MAXPOW_BY_TWO_CHAIN     6  /* 10*log10(2)*2 */
 #define INCREASE_MAXPOW_BY_THREE_CHAIN   10 /* 10*log10(3)*2 */
 
+#define REDUCE_SCALED_POWER_BY_TWO_CHAIN	6  /* 10*log10(2)*2 */
+#define REDUCE_SCALED_POWER_BY_THREE_CHAIN	10 /* 10*log10(3)*2 */
+
 /*
  * For AR9285 and later chipsets, the following bits are not being programmed
  * in EEPROM and so need to be enabled always.
@@ -686,6 +689,8 @@ void ath9k_hw_get_target_powers(struct ath_hw *ah,
 				u16 numRates, bool isHt40Target);
 u16 ath9k_hw_get_max_edge_power(u16 freq, struct cal_ctl_edges *pRdEdgesPower,
 				bool is2GHz, int num_band_edges);
+u16 ath9k_hw_get_scaled_power(struct ath_hw *ah, u16 power_limit,
+			      u8 antenna_reduction);
 void ath9k_hw_update_regulatory_maxpower(struct ath_hw *ah);
 int ath9k_hw_eeprom_init(struct ath_hw *ah);
 
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index 604eab8..5ab0e6e 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -564,9 +564,6 @@ static void ath9k_hw_set_ar9287_power_per_rate_table(struct ath_hw *ah,
 	(((cfgCtl & ~CTL_MODE_M) | (pCtlMode[ctlMode] & CTL_MODE_M)) == \
 	 ((pEepData->ctlIndex[i] & CTL_MODE_M) | SD_NO_CTL))
 
-#define REDUCE_SCALED_POWER_BY_TWO_CHAIN     6  /* 10*log10(2)*2 */
-#define REDUCE_SCALED_POWER_BY_THREE_CHAIN   10 /* 10*log10(3)*2 */
-
 	u16 twiceMaxEdgePower;
 	int i;
 	struct cal_ctl_data_ar9287 *rep;
@@ -591,29 +588,8 @@ static void ath9k_hw_set_ar9287_power_per_rate_table(struct ath_hw *ah,
 	tx_chainmask = ah->txchainmask;
 
 	ath9k_hw_get_channel_centers(ah, chan, &centers);
-	scaledPower = powerLimit - antenna_reduction;
-
-	/*
-	 * Reduce scaled Power by number of chains active
-	 * to get the per chain tx power level.
-	 */
-	switch (ar5416_get_ntxchains(tx_chainmask)) {
-	case 1:
-		break;
-	case 2:
-		if (scaledPower > REDUCE_SCALED_POWER_BY_TWO_CHAIN)
-			scaledPower -= REDUCE_SCALED_POWER_BY_TWO_CHAIN;
-		else
-			scaledPower = 0;
-		break;
-	case 3:
-		if (scaledPower > REDUCE_SCALED_POWER_BY_THREE_CHAIN)
-			scaledPower -= REDUCE_SCALED_POWER_BY_THREE_CHAIN;
-		else
-			scaledPower = 0;
-		break;
-	}
-	scaledPower = max((u16)0, scaledPower);
+	scaledPower = ath9k_hw_get_scaled_power(ah, powerLimit,
+						antenna_reduction);
 
 	/*
 	 * Get TX power from EEPROM.
@@ -786,8 +762,6 @@ static void ath9k_hw_set_ar9287_power_per_rate_table(struct ath_hw *ah,
 
 #undef CMP_CTL
 #undef CMP_NO_CTL
-#undef REDUCE_SCALED_POWER_BY_TWO_CHAIN
-#undef REDUCE_SCALED_POWER_BY_THREE_CHAIN
 }
 
 static void ath9k_hw_ar9287_set_txpower(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 0068627..3a9c9ed 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -991,9 +991,6 @@ static void ath9k_hw_set_def_power_per_rate_table(struct ath_hw *ah,
 						  u16 antenna_reduction,
 						  u16 powerLimit)
 {
-#define REDUCE_SCALED_POWER_BY_TWO_CHAIN     6  /* 10*log10(2)*2 */
-#define REDUCE_SCALED_POWER_BY_THREE_CHAIN   10 /* 10*log10(3)*2 */
-
 	struct ar5416_eeprom_def *pEepData = &ah->eeprom.def;
 	u16 twiceMaxEdgePower;
 	int i;
@@ -1027,24 +1024,8 @@ static void ath9k_hw_set_def_power_per_rate_table(struct ath_hw *ah,
 
 	ath9k_hw_get_channel_centers(ah, chan, &centers);
 
-	scaledPower = powerLimit - antenna_reduction;
-
-	switch (ar5416_get_ntxchains(tx_chainmask)) {
-	case 1:
-		break;
-	case 2:
-		if (scaledPower > REDUCE_SCALED_POWER_BY_TWO_CHAIN)
-			scaledPower -= REDUCE_SCALED_POWER_BY_TWO_CHAIN;
-		else
-			scaledPower = 0;
-		break;
-	case 3:
-		if (scaledPower > REDUCE_SCALED_POWER_BY_THREE_CHAIN)
-			scaledPower -= REDUCE_SCALED_POWER_BY_THREE_CHAIN;
-		else
-			scaledPower = 0;
-		break;
-	}
+	scaledPower = ath9k_hw_get_scaled_power(ah, powerLimit,
+						antenna_reduction);
 
 	if (IS_CHAN_2GHZ(chan)) {
 		numCtlModes = ARRAY_SIZE(ctlModesFor11g) -
-- 
1.7.2.1

