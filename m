Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:34247 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab3LDEeN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 23:34:13 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] ath9k: Initialize baseband for DFS channels
Date: Wed,  4 Dec 2013 09:59:25 +0530
Message-Id: <1386131365-28780-2-git-send-email-sujith@msujith.org> (sfid-20131204_053434_807966_8B44D957)
In-Reply-To: <1386131365-28780-1-git-send-email-sujith@msujith.org>
References: <1386131365-28780-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Certain baseband registers require different values
to be programmed when operating in a DFS channel to
ensure that radar detection works correctly. This
is required for AR9300, AR9340 and AR9580.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c  | 6 ++++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 6 ++++++
 drivers/net/wireless/ath/ath9k/hw.h         | 1 +
 3 files changed, 13 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index d8c1eee..4e8ae4a 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -152,6 +152,8 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 			       ar9340Modes_fast_clock_1p0);
 		INIT_INI_ARRAY(&ah->iniCckfirJapan2484,
 			       ar9340_1p0_baseband_core_txfir_coeff_japan_2484);
+		INIT_INI_ARRAY(&ah->ini_dfs,
+			       ar9340_1p0_baseband_postamble_dfs_channel);
 
 		if (!ah->is_clk_25mhz)
 			INIT_INI_ARRAY(&ah->iniAdditional,
@@ -340,6 +342,8 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 			       ar9580_1p0_modes_fast_clock);
 		INIT_INI_ARRAY(&ah->iniCckfirJapan2484,
 			       ar9580_1p0_baseband_core_txfir_coeff_japan_2484);
+		INIT_INI_ARRAY(&ah->ini_dfs,
+			       ar9580_1p0_baseband_postamble_dfs_channel);
 	} else if (AR_SREV_9565_11_OR_LATER(ah)) {
 		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_CORE],
 			       ar9565_1p1_mac_core);
@@ -458,6 +462,8 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 			       ar9300Modes_fast_clock_2p2);
 		INIT_INI_ARRAY(&ah->iniCckfirJapan2484,
 			       ar9300_2p2_baseband_core_txfir_coeff_japan_2484);
+		INIT_INI_ARRAY(&ah->ini_dfs,
+			       ar9300_2p2_baseband_postamble_dfs_channel);
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 39b71b3..9f051a0 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1332,6 +1332,7 @@ static void ar9003_hw_ani_cache_ini_regs(struct ath_hw *ah)
 static void ar9003_hw_set_radar_params(struct ath_hw *ah,
 				       struct ath_hw_radar_conf *conf)
 {
+	unsigned int regWrites = 0;
 	u32 radar_0 = 0, radar_1 = 0;
 
 	if (!conf) {
@@ -1358,6 +1359,11 @@ static void ar9003_hw_set_radar_params(struct ath_hw *ah,
 		REG_SET_BIT(ah, AR_PHY_RADAR_EXT, AR_PHY_RADAR_EXT_ENA);
 	else
 		REG_CLR_BIT(ah, AR_PHY_RADAR_EXT, AR_PHY_RADAR_EXT_ENA);
+
+	if (AR_SREV_9300(ah) || AR_SREV_9340(ah) || AR_SREV_9580(ah)) {
+		REG_WRITE_ARRAY(&ah->ini_dfs,
+				IS_CHAN_HT40(ah->curchan) ? 2 : 1, regWrites);
+	}
 }
 
 static void ar9003_hw_set_radar_conf(struct ath_hw *ah)
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index e508436..7490047 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -864,6 +864,7 @@ struct ath_hw {
 	u32 gpio_mask;
 	u32 gpio_val;
 
+	struct ar5416IniArray ini_dfs;
 	struct ar5416IniArray iniModes;
 	struct ar5416IniArray iniCommon;
 	struct ar5416IniArray iniBB_RfGain;
-- 
1.8.4.2

