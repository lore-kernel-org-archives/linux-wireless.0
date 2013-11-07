Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:53172 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab3KGAQw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 19:16:52 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 11/13] ath9k: Use correct PCIE initvals for AR9485
Date: Thu,  7 Nov 2013 05:41:58 +0530
Message-Id: <1383783120-22435-12-git-send-email-sujith@msujith.org> (sfid-20131107_013807_255722_6065FE4F)
In-Reply-To: <1383783120-22435-1-git-send-email-sujith@msujith.org>
References: <1383783120-22435-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Currently, the PLL is turned off for AR9485 when
switching to a low power state, but AR9485 has an issue
where the card will become unresponsive if left idle
for a long time without any traffic. To fix this,
force the PLL to always be on using a different initval
array, ar9485_1_1_pll_on_cdr_on_clkreq_disable_L1.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c       | 11 ++------
 drivers/net/wireless/ath/ath9k/ar9485_initvals.h | 35 +++++-------------------
 2 files changed, 9 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 42daea5..b054dee 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -187,17 +187,10 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 		INIT_INI_ARRAY(&ah->iniCckfirJapan2484,
 			       ar9485_1_1_baseband_core_txfir_coeff_japan_2484);
 
-		/* Load PCIE SERDES settings from INI */
-
-		/* Awake Setting */
-
 		INIT_INI_ARRAY(&ah->iniPcieSerdes,
-				ar9485_1_1_pcie_phy_clkreq_disable_L1);
-
-		/* Sleep Setting */
-
+			       ar9485_1_1_pll_on_cdr_on_clkreq_disable_L1);
 		INIT_INI_ARRAY(&ah->iniPcieSerdesLowPower,
-				ar9485_1_1_pcie_phy_clkreq_disable_L1);
+			       ar9485_1_1_pll_on_cdr_on_clkreq_disable_L1);
 	} else if (AR_SREV_9462_21(ah)) {
 		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_CORE],
 			       ar9462_2p1_mac_core);
diff --git a/drivers/net/wireless/ath/ath9k/ar9485_initvals.h b/drivers/net/wireless/ath/ath9k/ar9485_initvals.h
index 6f899c6..93b18ce 100644
--- a/drivers/net/wireless/ath/ath9k/ar9485_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9485_initvals.h
@@ -32,13 +32,6 @@ static const u32 ar9485_1_1_mac_postamble[][5] = {
 	{0x00008318, 0x00003e80, 0x00007d00, 0x00006880, 0x00003440},
 };
 
-static const u32 ar9485_1_1_pcie_phy_pll_on_clkreq_disable_L1[][2] = {
-	/* Addr      allmodes  */
-	{0x00018c00, 0x18012e5e},
-	{0x00018c04, 0x000801d8},
-	{0x00018c08, 0x0000080c},
-};
-
 static const u32 ar9485Common_wo_xlna_rx_gain_1_1[][2] = {
 	/* Addr      allmodes  */
 	{0x00009e00, 0x037216a0},
@@ -1101,20 +1094,6 @@ static const u32 ar9485_common_rx_gain_1_1[][2] = {
 	{0x0000a1fc, 0x00000296},
 };
 
-static const u32 ar9485_1_1_pcie_phy_pll_on_clkreq_enable_L1[][2] = {
-	/* Addr      allmodes  */
-	{0x00018c00, 0x18052e5e},
-	{0x00018c04, 0x000801d8},
-	{0x00018c08, 0x0000080c},
-};
-
-static const u32 ar9485_1_1_pcie_phy_clkreq_enable_L1[][2] = {
-	/* Addr      allmodes  */
-	{0x00018c00, 0x18053e5e},
-	{0x00018c04, 0x000801d8},
-	{0x00018c08, 0x0000080c},
-};
-
 static const u32 ar9485_1_1_soc_preamble[][2] = {
 	/* Addr      allmodes  */
 	{0x00004014, 0xba280400},
@@ -1173,13 +1152,6 @@ static const u32 ar9485_1_1_baseband_postamble[][5] = {
 	{0x0000be18, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 };
 
-static const u32 ar9485_1_1_pcie_phy_clkreq_disable_L1[][2] = {
-	/* Addr      allmodes  */
-	{0x00018c00, 0x18013e5e},
-	{0x00018c04, 0x000801d8},
-	{0x00018c08, 0x0000080c},
-};
-
 static const u32 ar9485_1_1_radio_postamble[][2] = {
 	/* Addr      allmodes  */
 	{0x0001609c, 0x0b283f31},
@@ -1358,4 +1330,11 @@ static const u32 ar9485_1_1_baseband_core_txfir_coeff_japan_2484[][2] = {
 	{0x0000a3a0, 0xca9228ee},
 };
 
+static const u32 ar9485_1_1_pll_on_cdr_on_clkreq_disable_L1[][2] = {
+	/* Addr      allmodes  */
+	{0x00018c00, 0x1801265e},
+	{0x00018c04, 0x000801d8},
+	{0x00018c08, 0x0000080c},
+};
+
 #endif /* INITVALS_9485_H */
-- 
1.8.4.2

