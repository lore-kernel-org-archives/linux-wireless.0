Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:13830 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833Ab0LAHdY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 02:33:24 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 23:33:10 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 04/26] ath9k_hw: Initialize mode registers for AR9485
Date: Tue, 30 Nov 2010 23:32:33 -0800
Message-ID: <1291188775-13707-5-git-send-email-vasanth@atheros.com>
In-Reply-To: <1291188775-13707-1-git-send-email-vasanth@atheros.com>
References: <1291188775-13707-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c |  195 ++++++++++++++++++----------
 1 files changed, 129 insertions(+), 66 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 0e3e259..f01c289 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -17,6 +17,7 @@
 #include "hw.h"
 #include "ar9003_mac.h"
 #include "ar9003_2p2_initvals.h"
+#include "ar9485_initvals.h"
 
 /* General hardware code for the AR9003 hadware family */
 
@@ -39,72 +40,134 @@ static bool ar9003_hw_macversion_supported(u32 macversion)
  */
 static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 {
-	/* mac */
-	INIT_INI_ARRAY(&ah->iniMac[ATH_INI_PRE], NULL, 0, 0);
-	INIT_INI_ARRAY(&ah->iniMac[ATH_INI_CORE],
-		       ar9300_2p2_mac_core,
-		       ARRAY_SIZE(ar9300_2p2_mac_core), 2);
-	INIT_INI_ARRAY(&ah->iniMac[ATH_INI_POST],
-		       ar9300_2p2_mac_postamble,
-		       ARRAY_SIZE(ar9300_2p2_mac_postamble), 5);
-
-	/* bb */
-	INIT_INI_ARRAY(&ah->iniBB[ATH_INI_PRE], NULL, 0, 0);
-	INIT_INI_ARRAY(&ah->iniBB[ATH_INI_CORE],
-		       ar9300_2p2_baseband_core,
-		       ARRAY_SIZE(ar9300_2p2_baseband_core), 2);
-	INIT_INI_ARRAY(&ah->iniBB[ATH_INI_POST],
-		       ar9300_2p2_baseband_postamble,
-		       ARRAY_SIZE(ar9300_2p2_baseband_postamble), 5);
-
-	/* radio */
-	INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_PRE], NULL, 0, 0);
-	INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_CORE],
-		       ar9300_2p2_radio_core,
-		       ARRAY_SIZE(ar9300_2p2_radio_core), 2);
-	INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_POST],
-		       ar9300_2p2_radio_postamble,
-		       ARRAY_SIZE(ar9300_2p2_radio_postamble), 5);
-
-	/* soc */
-	INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_PRE],
-		       ar9300_2p2_soc_preamble,
-		       ARRAY_SIZE(ar9300_2p2_soc_preamble), 2);
-	INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_CORE], NULL, 0, 0);
-	INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_POST],
-		       ar9300_2p2_soc_postamble,
-		       ARRAY_SIZE(ar9300_2p2_soc_postamble), 5);
-
-	/* rx/tx gain */
-	INIT_INI_ARRAY(&ah->iniModesRxGain,
-		       ar9300Common_rx_gain_table_2p2,
-		       ARRAY_SIZE(ar9300Common_rx_gain_table_2p2), 2);
-	INIT_INI_ARRAY(&ah->iniModesTxGain,
-		       ar9300Modes_lowest_ob_db_tx_gain_table_2p2,
-		       ARRAY_SIZE(ar9300Modes_lowest_ob_db_tx_gain_table_2p2),
-		       5);
-
-	/* Load PCIE SERDES settings from INI */
-
-	/* Awake Setting */
-
-	INIT_INI_ARRAY(&ah->iniPcieSerdes,
-		       ar9300PciePhy_pll_on_clkreq_disable_L1_2p2,
-		       ARRAY_SIZE(ar9300PciePhy_pll_on_clkreq_disable_L1_2p2),
-		       2);
-
-	/* Sleep Setting */
-
-	INIT_INI_ARRAY(&ah->iniPcieSerdesLowPower,
-		       ar9300PciePhy_clkreq_enable_L1_2p2,
-		       ARRAY_SIZE(ar9300PciePhy_clkreq_enable_L1_2p2),
-		       2);
-
-	/* Fast clock modal settings */
-	INIT_INI_ARRAY(&ah->iniModesAdditional,
-		       ar9300Modes_fast_clock_2p2,
-		       ARRAY_SIZE(ar9300Modes_fast_clock_2p2),
-		       3);
+	if (AR_SREV_9485(ah)) {
+		/* mac */
+		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_PRE], NULL, 0, 0);
+		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_CORE],
+				ar9485_1_0_mac_core,
+				ARRAY_SIZE(ar9485_1_0_mac_core), 2);
+		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_POST],
+				ar9485_1_0_mac_postamble,
+				ARRAY_SIZE(ar9485_1_0_mac_postamble), 5);
+
+		/* bb */
+		INIT_INI_ARRAY(&ah->iniBB[ATH_INI_PRE], ar9485_1_0,
+				ARRAY_SIZE(ar9485_1_0), 2);
+		INIT_INI_ARRAY(&ah->iniBB[ATH_INI_CORE],
+				ar9485_1_0_baseband_core,
+				ARRAY_SIZE(ar9485_1_0_baseband_core), 2);
+		INIT_INI_ARRAY(&ah->iniBB[ATH_INI_POST],
+				ar9485_1_0_baseband_postamble,
+				ARRAY_SIZE(ar9485_1_0_baseband_postamble), 5);
+
+		/* radio */
+		INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_PRE], NULL, 0, 0);
+		INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_CORE],
+				ar9485_1_0_radio_core,
+				ARRAY_SIZE(ar9485_1_0_radio_core), 2);
+		INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_POST],
+				ar9485_1_0_radio_postamble,
+				ARRAY_SIZE(ar9485_1_0_radio_postamble), 2);
+
+		/* soc */
+		INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_PRE],
+				ar9485_1_0_soc_preamble,
+				ARRAY_SIZE(ar9485_1_0_soc_preamble), 2);
+		INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_CORE], NULL, 0, 0);
+		INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_POST], NULL, 0, 0);
+
+		/* rx/tx gain */
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+				ar9485Common_rx_gain_1_0,
+				ARRAY_SIZE(ar9485Common_rx_gain_1_0), 2);
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+				ar9485Modes_lowest_ob_db_tx_gain_1_0,
+				ARRAY_SIZE(ar9485Modes_lowest_ob_db_tx_gain_1_0),
+				5);
+
+		/* Load PCIE SERDES settings from INI */
+
+		/* Awake Setting */
+
+		INIT_INI_ARRAY(&ah->iniPcieSerdes,
+				ar9485_1_0_pcie_phy_pll_on_clkreq_disable_L1,
+				ARRAY_SIZE(ar9485_1_0_pcie_phy_pll_on_clkreq_disable_L1),
+				2);
+
+		/* Sleep Setting */
+
+		INIT_INI_ARRAY(&ah->iniPcieSerdesLowPower,
+				ar9485_1_0_pcie_phy_pll_on_clkreq_enable_L1,
+				ARRAY_SIZE(ar9485_1_0_pcie_phy_pll_on_clkreq_enable_L1),
+				2);
+	} else {
+		/* mac */
+		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_PRE], NULL, 0, 0);
+		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_CORE],
+				ar9300_2p2_mac_core,
+				ARRAY_SIZE(ar9300_2p2_mac_core), 2);
+		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_POST],
+				ar9300_2p2_mac_postamble,
+				ARRAY_SIZE(ar9300_2p2_mac_postamble), 5);
+
+		/* bb */
+		INIT_INI_ARRAY(&ah->iniBB[ATH_INI_PRE], NULL, 0, 0);
+		INIT_INI_ARRAY(&ah->iniBB[ATH_INI_CORE],
+				ar9300_2p2_baseband_core,
+				ARRAY_SIZE(ar9300_2p2_baseband_core), 2);
+		INIT_INI_ARRAY(&ah->iniBB[ATH_INI_POST],
+				ar9300_2p2_baseband_postamble,
+				ARRAY_SIZE(ar9300_2p2_baseband_postamble), 5);
+
+		/* radio */
+		INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_PRE], NULL, 0, 0);
+		INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_CORE],
+				ar9300_2p2_radio_core,
+				ARRAY_SIZE(ar9300_2p2_radio_core), 2);
+		INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_POST],
+				ar9300_2p2_radio_postamble,
+				ARRAY_SIZE(ar9300_2p2_radio_postamble), 5);
+
+		/* soc */
+		INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_PRE],
+				ar9300_2p2_soc_preamble,
+				ARRAY_SIZE(ar9300_2p2_soc_preamble), 2);
+		INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_CORE], NULL, 0, 0);
+		INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_POST],
+				ar9300_2p2_soc_postamble,
+				ARRAY_SIZE(ar9300_2p2_soc_postamble), 5);
+
+		/* rx/tx gain */
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+				ar9300Common_rx_gain_table_2p2,
+				ARRAY_SIZE(ar9300Common_rx_gain_table_2p2), 2);
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+				ar9300Modes_lowest_ob_db_tx_gain_table_2p2,
+				ARRAY_SIZE(ar9300Modes_lowest_ob_db_tx_gain_table_2p2),
+				5);
+
+		/* Load PCIE SERDES settings from INI */
+
+		/* Awake Setting */
+
+		INIT_INI_ARRAY(&ah->iniPcieSerdes,
+				ar9300PciePhy_pll_on_clkreq_disable_L1_2p2,
+				ARRAY_SIZE(ar9300PciePhy_pll_on_clkreq_disable_L1_2p2),
+				2);
+
+		/* Sleep Setting */
+
+		INIT_INI_ARRAY(&ah->iniPcieSerdesLowPower,
+				ar9300PciePhy_clkreq_enable_L1_2p2,
+				ARRAY_SIZE(ar9300PciePhy_clkreq_enable_L1_2p2),
+				2);
+
+		/* Fast clock modal settings */
+		INIT_INI_ARRAY(&ah->iniModesAdditional,
+				ar9300Modes_fast_clock_2p2,
+				ARRAY_SIZE(ar9300Modes_fast_clock_2p2),
+				3);
+	}
 }
 
 static void ar9003_tx_gain_table_apply(struct ath_hw *ah)
-- 
1.7.0.4

