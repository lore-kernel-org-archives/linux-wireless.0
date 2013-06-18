Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:57370 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508Ab3FRKPm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 06:15:42 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] ath9k: Program initvals for CUS217
Date: Tue, 18 Jun 2013 15:42:38 +0530
Message-Id: <1371550358-5920-3-git-send-email-sujith@msujith.org> (sfid-20130618_121549_235417_77F7E8D8)
In-Reply-To: <1371550358-5920-1-git-send-email-sujith@msujith.org>
References: <1371550358-5920-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c  |  4 ++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 10 ++++++++++
 drivers/net/wireless/ath/ath9k/hw.h         |  2 ++
 3 files changed, 16 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index ce748af..671aaa7 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -630,6 +630,10 @@ static void ar9003_rx_gain_table_mode2(struct ath_hw *ah)
 	if (AR_SREV_9462_20(ah)) {
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
 			       ar9462_common_mixed_rx_gain_table_2p0);
+		INIT_INI_ARRAY(&ah->ini_modes_rxgain_bb_core,
+			       ar9462_2p0_baseband_core_mix_rxgain);
+		INIT_INI_ARRAY(&ah->ini_modes_rxgain_bb_postamble,
+			       ar9462_2p0_baseband_postamble_mix_rxgain);
 		INIT_INI_ARRAY(&ah->ini_modes_rxgain_5g_xlna,
 			       ar9462_2p0_baseband_postamble_5g_xlna);
 	}
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index df919e2..df84d20 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -756,6 +756,16 @@ static int ar9003_hw_process_ini(struct ath_hw *ah,
 
 	if (AR_SREV_9462_20(ah)) {
 		/*
+		 * CUS217 mix LNA mode.
+		 */
+		if (ar9003_hw_get_rx_gain_idx(ah) == 2) {
+			REG_WRITE_ARRAY(&ah->ini_modes_rxgain_bb_core,
+					1, regWrites);
+			REG_WRITE_ARRAY(&ah->ini_modes_rxgain_bb_postamble,
+					modesIndex, regWrites);
+		}
+
+		/*
 		 * 5G-XLNA
 		 */
 		if ((ar9003_hw_get_rx_gain_idx(ah) == 2) ||
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index e076639..cd74b3a 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -893,6 +893,8 @@ struct ath_hw {
 	struct ar5416IniArray iniModes_9271_ANI_reg;
 	struct ar5416IniArray ini_radio_post_sys2ant;
 	struct ar5416IniArray ini_modes_rxgain_5g_xlna;
+	struct ar5416IniArray ini_modes_rxgain_bb_core;
+	struct ar5416IniArray ini_modes_rxgain_bb_postamble;
 
 	struct ar5416IniArray iniMac[ATH_INI_NUM_SPLIT];
 	struct ar5416IniArray iniBB[ATH_INI_NUM_SPLIT];
-- 
1.8.3.1

