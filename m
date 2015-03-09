Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:45422 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbbCIIq2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 04:46:28 -0400
Received: from [117.207.78.0] (port=10150 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YUtKV-0033Ry-U1
	for linux-wireless@vger.kernel.org; Mon, 09 Mar 2015 04:46:28 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/5] ath9k: Fix PLL powersave for AR9485
Date: Mon,  9 Mar 2015 14:20:07 +0530
Message-Id: <1425891010-21522-3-git-send-email-sujith@msujith.org> (sfid-20150309_094638_784155_5ED603BF)
In-Reply-To: <1425891010-21522-1-git-send-email-sujith@msujith.org>
References: <1425891010-21522-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Use the value in ah->config.pll_pwrsave to determine
which array needs to be loaded. Also, initialize
pll_pwrsave to 1 by default.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c | 10 +++++-----
 drivers/net/wireless/ath/ath9k/hw.h        |  2 +-
 drivers/net/wireless/ath/ath9k/init.c      |  8 +++++++-
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 4335ccb..ea33f8d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -195,16 +195,16 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 		INIT_INI_ARRAY(&ah->iniCckfirJapan2484,
 			       ar9485_1_1_baseband_core_txfir_coeff_japan_2484);
 
-		if (ah->config.no_pll_pwrsave) {
+		if (ah->config.pll_pwrsave & AR_PCIE_PLL_PWRSAVE_CONTROL) {
 			INIT_INI_ARRAY(&ah->iniPcieSerdes,
-				       ar9485_1_1_pcie_phy_clkreq_disable_L1);
+				       ar9485_1_1_pll_on_cdr_on_clkreq_disable_L1);
 			INIT_INI_ARRAY(&ah->iniPcieSerdesLowPower,
-				       ar9485_1_1_pcie_phy_clkreq_disable_L1);
+				       ar9485_1_1_pll_on_cdr_on_clkreq_disable_L1);
 		} else {
 			INIT_INI_ARRAY(&ah->iniPcieSerdes,
-				       ar9485_1_1_pll_on_cdr_on_clkreq_disable_L1);
+				       ar9485_1_1_pcie_phy_clkreq_disable_L1);
 			INIT_INI_ARRAY(&ah->iniPcieSerdesLowPower,
-				       ar9485_1_1_pll_on_cdr_on_clkreq_disable_L1);
+				       ar9485_1_1_pcie_phy_clkreq_disable_L1);
 		}
 	} else if (AR_SREV_9462_21(ah)) {
 		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_CORE],
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 2bb3b33..e124ee2 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -341,7 +341,7 @@ struct ath9k_ops_config {
 	u32 ant_ctrl_comm2g_switch_enable;
 	bool xatten_margin_cfg;
 	bool alt_mingainidx;
-	bool no_pll_pwrsave;
+	bool pll_pwrsave;
 	bool tx_gain_buffalo;
 	bool led_active_high;
 };
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 6c6e884..ca66fab 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -437,8 +437,14 @@ static void ath9k_init_pcoem_platform(struct ath_softc *sc)
 		ath_info(common, "Enable WAR for ASPM D3/L1\n");
 	}
 
+	/*
+	 * The default value of pll_pwrsave is 1.
+	 * For certain AR9485 cards, it is set to 0.
+	 */
+	ah->config.pll_pwrsave = 1;
+
 	if (sc->driver_data & ATH9K_PCI_NO_PLL_PWRSAVE) {
-		ah->config.no_pll_pwrsave = true;
+		ah->config.pll_pwrsave = 0;
 		ath_info(common, "Disable PLL PowerSave\n");
 	}
 
-- 
2.3.1

