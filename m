Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:37530 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbbCIIqb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 04:46:31 -0400
Received: from [117.207.78.0] (port=10150 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YUtKY-0033Ry-DS
	for linux-wireless@vger.kernel.org; Mon, 09 Mar 2015 04:46:30 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 4/5] ath9k: Check allowed PCIE powersave configuration
Date: Mon,  9 Mar 2015 14:20:09 +0530
Message-Id: <1425891010-21522-5-git-send-email-sujith@msujith.org> (sfid-20150309_094642_559520_F6526C60)
In-Reply-To: <1425891010-21522-1-git-send-email-sujith@msujith.org>
References: <1425891010-21522-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

When assigning the initvals for PCIE sleep/awake
registers, check the configuration that has been
assigned to pll_pwrsave during initialization. Also,
display a warning if we don't have valid arrays.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c | 73 +++++++++++++++++++++++-------
 1 file changed, 57 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index ea33f8d..df176e6 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -231,10 +231,20 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 			       ar9462_2p1_modes_fast_clock);
 		INIT_INI_ARRAY(&ah->iniCckfirJapan2484,
 			       ar9462_2p1_baseband_core_txfir_coeff_japan_2484);
-		INIT_INI_ARRAY(&ah->iniPcieSerdes,
-			       ar9462_2p1_pciephy_clkreq_disable_L1);
-		INIT_INI_ARRAY(&ah->iniPcieSerdesLowPower,
-			       ar9462_2p1_pciephy_clkreq_disable_L1);
+
+		/* Awake -> Sleep Setting */
+		if ((ah->config.pll_pwrsave & AR_PCIE_PLL_PWRSAVE_CONTROL) &&
+		    (ah->config.pll_pwrsave & AR_PCIE_PLL_PWRSAVE_ON_D3)) {
+			INIT_INI_ARRAY(&ah->iniPcieSerdes,
+				       ar9462_2p1_pciephy_clkreq_disable_L1);
+		}
+
+		/* Sleep -> Awake Setting */
+		if ((ah->config.pll_pwrsave & AR_PCIE_PLL_PWRSAVE_CONTROL) &&
+		    (ah->config.pll_pwrsave & AR_PCIE_PLL_PWRSAVE_ON_D0)) {
+			INIT_INI_ARRAY(&ah->iniPcieSerdesLowPower,
+				       ar9462_2p1_pciephy_clkreq_disable_L1);
+		}
 	} else if (AR_SREV_9462_20(ah)) {
 
 		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_CORE], ar9462_2p0_mac_core);
@@ -262,11 +272,18 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 				ar9462_2p0_common_rx_gain);
 
 		/* Awake -> Sleep Setting */
-		INIT_INI_ARRAY(&ah->iniPcieSerdes,
-			       ar9462_2p0_pciephy_clkreq_disable_L1);
+		if ((ah->config.pll_pwrsave & AR_PCIE_PLL_PWRSAVE_CONTROL) &&
+		    (ah->config.pll_pwrsave & AR_PCIE_PLL_PWRSAVE_ON_D3)) {
+			INIT_INI_ARRAY(&ah->iniPcieSerdes,
+				       ar9462_2p0_pciephy_clkreq_disable_L1);
+		}
+
 		/* Sleep -> Awake Setting */
-		INIT_INI_ARRAY(&ah->iniPcieSerdesLowPower,
-			       ar9462_2p0_pciephy_clkreq_disable_L1);
+		if ((ah->config.pll_pwrsave & AR_PCIE_PLL_PWRSAVE_CONTROL) &&
+		    (ah->config.pll_pwrsave & AR_PCIE_PLL_PWRSAVE_ON_D0)) {
+			INIT_INI_ARRAY(&ah->iniPcieSerdesLowPower,
+				       ar9462_2p0_pciephy_clkreq_disable_L1);
+		}
 
 		/* Fast clock modal settings */
 		INIT_INI_ARRAY(&ah->iniModesFastClock,
@@ -456,10 +473,19 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			       ar9565_1p1_Modes_lowest_ob_db_tx_gain_table);
 
-		INIT_INI_ARRAY(&ah->iniPcieSerdes,
-			       ar9565_1p1_pciephy_clkreq_disable_L1);
-		INIT_INI_ARRAY(&ah->iniPcieSerdesLowPower,
-			       ar9565_1p1_pciephy_clkreq_disable_L1);
+		/* Awake -> Sleep Setting */
+		if ((ah->config.pll_pwrsave & AR_PCIE_PLL_PWRSAVE_CONTROL) &&
+		    (ah->config.pll_pwrsave & AR_PCIE_PLL_PWRSAVE_ON_D3)) {
+			INIT_INI_ARRAY(&ah->iniPcieSerdes,
+				       ar9565_1p1_pciephy_clkreq_disable_L1);
+		}
+
+		/* Sleep -> Awake Setting */
+		if ((ah->config.pll_pwrsave & AR_PCIE_PLL_PWRSAVE_CONTROL) &&
+		    (ah->config.pll_pwrsave & AR_PCIE_PLL_PWRSAVE_ON_D0)) {
+			INIT_INI_ARRAY(&ah->iniPcieSerdesLowPower,
+				       ar9565_1p1_pciephy_clkreq_disable_L1);
+		}
 
 		INIT_INI_ARRAY(&ah->iniModesFastClock,
 				ar9565_1p1_modes_fast_clock);
@@ -491,10 +517,19 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			       ar9565_1p0_Modes_lowest_ob_db_tx_gain_table);
 
-		INIT_INI_ARRAY(&ah->iniPcieSerdes,
-			       ar9565_1p0_pciephy_clkreq_disable_L1);
-		INIT_INI_ARRAY(&ah->iniPcieSerdesLowPower,
-			       ar9565_1p0_pciephy_clkreq_disable_L1);
+		/* Awake -> Sleep Setting */
+		if ((ah->config.pll_pwrsave & AR_PCIE_PLL_PWRSAVE_CONTROL) &&
+		    (ah->config.pll_pwrsave & AR_PCIE_PLL_PWRSAVE_ON_D3)) {
+			INIT_INI_ARRAY(&ah->iniPcieSerdes,
+				       ar9565_1p0_pciephy_clkreq_disable_L1);
+		}
+
+		/* Sleep -> Awake Setting */
+		if ((ah->config.pll_pwrsave & AR_PCIE_PLL_PWRSAVE_CONTROL) &&
+		    (ah->config.pll_pwrsave & AR_PCIE_PLL_PWRSAVE_ON_D0)) {
+			INIT_INI_ARRAY(&ah->iniPcieSerdesLowPower,
+				       ar9565_1p0_pciephy_clkreq_disable_L1);
+		}
 
 		INIT_INI_ARRAY(&ah->iniModesFastClock,
 				ar9565_1p0_modes_fast_clock);
@@ -1130,6 +1165,12 @@ void ar9003_hw_attach_ops(struct ath_hw *ah)
 	struct ath_hw_ops *ops = ath9k_hw_ops(ah);
 
 	ar9003_hw_init_mode_regs(ah);
+
+	if (AR_SREV_9003_PCOEM(ah)) {
+		WARN_ON(!ah->iniPcieSerdes.ia_array);
+		WARN_ON(!ah->iniPcieSerdesLowPower.ia_array);
+	}
+
 	priv_ops->init_mode_gain_regs = ar9003_hw_init_mode_gain_regs;
 	priv_ops->init_hang_checks = ar9003_hw_init_hang_checks;
 	priv_ops->detect_mac_hang = ar9003_hw_detect_mac_hang;
-- 
2.3.1

