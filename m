Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58237 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbbI2FYr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2015 01:24:47 -0400
From: miaoqing@codeaurora.org
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	kvalo@qca.qualcomm.com, Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH 1/2] ath9k: rename ini_modes_rxgain_5g_xlna to ini_modes_rxgain_xlna
Date: Tue, 29 Sep 2015 13:24:36 +0800
Message-Id: <1443504277-3482-1-git-send-email-miaoqing@codeaurora.org> (sfid-20150929_072450_867030_EFF5F365)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@codeaurora.org>

rename the variable as preparation for using the array with 2.4 GHz
band, etc.

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c  | 10 +++++-----
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |  4 ++--
 drivers/net/wireless/ath/ath9k/hw.h         |  2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 79fd3b2..8b238c1 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -857,7 +857,7 @@ static void ar9003_rx_gain_table_mode0(struct ath_hw *ah)
 			       qca956x_1p0_common_rx_gain_table);
 		INIT_INI_ARRAY(&ah->ini_modes_rx_gain_bounds,
 			       qca956x_1p0_common_rx_gain_bounds);
-		INIT_INI_ARRAY(&ah->ini_modes_rxgain_5g_xlna,
+		INIT_INI_ARRAY(&ah->ini_modes_rxgain_xlna,
 			       qca956x_1p0_xlna_only);
 	} else if (AR_SREV_9580(ah))
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
@@ -942,7 +942,7 @@ static void ar9003_rx_gain_table_mode2(struct ath_hw *ah)
 			       ar9462_2p1_baseband_core_mix_rxgain);
 		INIT_INI_ARRAY(&ah->ini_modes_rxgain_bb_postamble,
 			       ar9462_2p1_baseband_postamble_mix_rxgain);
-		INIT_INI_ARRAY(&ah->ini_modes_rxgain_5g_xlna,
+		INIT_INI_ARRAY(&ah->ini_modes_rxgain_xlna,
 			       ar9462_2p1_baseband_postamble_5g_xlna);
 	} else if (AR_SREV_9462_20(ah)) {
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
@@ -951,7 +951,7 @@ static void ar9003_rx_gain_table_mode2(struct ath_hw *ah)
 			       ar9462_2p0_baseband_core_mix_rxgain);
 		INIT_INI_ARRAY(&ah->ini_modes_rxgain_bb_postamble,
 			       ar9462_2p0_baseband_postamble_mix_rxgain);
-		INIT_INI_ARRAY(&ah->ini_modes_rxgain_5g_xlna,
+		INIT_INI_ARRAY(&ah->ini_modes_rxgain_xlna,
 			       ar9462_2p0_baseband_postamble_5g_xlna);
 	}
 }
@@ -961,12 +961,12 @@ static void ar9003_rx_gain_table_mode3(struct ath_hw *ah)
 	if (AR_SREV_9462_21(ah)) {
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
 			       ar9462_2p1_common_5g_xlna_only_rxgain);
-		INIT_INI_ARRAY(&ah->ini_modes_rxgain_5g_xlna,
+		INIT_INI_ARRAY(&ah->ini_modes_rxgain_xlna,
 			       ar9462_2p1_baseband_postamble_5g_xlna);
 	} else if (AR_SREV_9462_20(ah)) {
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
 			       ar9462_2p0_common_5g_xlna_only_rxgain);
-		INIT_INI_ARRAY(&ah->ini_modes_rxgain_5g_xlna,
+		INIT_INI_ARRAY(&ah->ini_modes_rxgain_xlna,
 			       ar9462_2p0_baseband_postamble_5g_xlna);
 	}
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 1ad66b7..296a69e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -926,12 +926,12 @@ static int ar9003_hw_process_ini(struct ath_hw *ah,
 		 */
 		if ((ar9003_hw_get_rx_gain_idx(ah) == 2) ||
 		    (ar9003_hw_get_rx_gain_idx(ah) == 3)) {
-			REG_WRITE_ARRAY(&ah->ini_modes_rxgain_5g_xlna,
+			REG_WRITE_ARRAY(&ah->ini_modes_rxgain_xlna,
 					modesIndex, regWrites);
 		}
 
 		if (AR_SREV_9561(ah) && (ar9003_hw_get_rx_gain_idx(ah) == 0))
-			REG_WRITE_ARRAY(&ah->ini_modes_rxgain_5g_xlna,
+			REG_WRITE_ARRAY(&ah->ini_modes_rxgain_xlna,
 					modesIndex, regWrites);
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index e8454db..4f0a3f6 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -919,7 +919,7 @@ struct ath_hw {
 	struct ar5416IniArray iniCckfirJapan2484;
 	struct ar5416IniArray iniModes_9271_ANI_reg;
 	struct ar5416IniArray ini_radio_post_sys2ant;
-	struct ar5416IniArray ini_modes_rxgain_5g_xlna;
+	struct ar5416IniArray ini_modes_rxgain_xlna;
 	struct ar5416IniArray ini_modes_rxgain_bb_core;
 	struct ar5416IniArray ini_modes_rxgain_bb_postamble;
 
-- 
1.9.1

