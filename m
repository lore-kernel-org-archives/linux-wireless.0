Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:36143 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab2KNG2s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 01:28:48 -0500
To: <rodrigue@qca.qualcomm.com>
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 2/2] qca-swiss-army-knife: refresh 9565 initvals
Date: Wed, 14 Nov 2012 11:58:44 +0530
Message-ID: <1352874524-1180-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20121114_072850_720249_83DD6DEC)
In-Reply-To: <1352874524-1180-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1352874524-1180-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable hw PLL power save to reduce power consumption in sleep state

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 tools/initvals/ar9565_1p0_initvals.h | 4 ++--
 tools/initvals/initvals.c            | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/initvals/ar9565_1p0_initvals.h b/tools/initvals/ar9565_1p0_initvals.h
index 843e79f..0c2ac0c 100644
--- a/tools/initvals/ar9565_1p0_initvals.h
+++ b/tools/initvals/ar9565_1p0_initvals.h
@@ -768,9 +768,9 @@ static const u32 ar9565_1p0_Modes_lowest_ob_db_tx_gain_table[][5] = {
 	{0x00016054, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 };
 
-static const u32 ar9565_1p0_pciephy_pll_on_clkreq_disable_L1[][2] = {
+static const u32 ar9565_1p0_pciephy_clkreq_disable_L1[][2] = {
 	/* Addr      allmodes  */
-	{0x00018c00, 0x18212ede},
+	{0x00018c00, 0x18213ede},
 	{0x00018c04, 0x000801d8},
 	{0x00018c08, 0x0003780c},
 };
diff --git a/tools/initvals/initvals.c b/tools/initvals/initvals.c
index 525d6cc..9b2fa27 100644
--- a/tools/initvals/initvals.c
+++ b/tools/initvals/initvals.c
@@ -315,7 +315,7 @@ typedef long long unsigned int u64;
 #define ar9565_1p0_mac_postamble				ar956X_aphrodite_1p0_mac_postamble
 #define ar9565_1p0_radio_postamble				ar956X_aphrodite_1p0_radio_postamble
 #define ar9565_1p0_Common_rx_gain_table				ar956XCommon_rx_gain_table_aphrodite_1p0
-#define ar9565_1p0_pciephy_pll_on_clkreq_disable_L1		ar956X_PciePhy_pll_on_clkreq_disable_L1_aphrodite_1p0
+#define ar9565_1p0_pciephy_clkreq_disable_L1			ar956X_PciePhy_pll_on_clkreq_disable_L1_aphrodite_1p0
 #define ar9565_1p0_baseband_postamble_emulation			ar956X_aphrodite_1p0_baseband_postamble_emulation
 #define ar9565_1p0_radio_core					ar956X_aphrodite_1p0_radio_core
 #define ar9565_1p0_baseband_postamble				ar956X_aphrodite_1p0_baseband_postamble
@@ -780,7 +780,7 @@ static void ar9565_1p0_hw_print_initvals(bool check)
 	INI_PRINT(ar9565_1p0_soc_postamble);
 	INI_PRINT(ar9565_1p0_Common_rx_gain_table);
 	INI_PRINT(ar9565_1p0_Modes_lowest_ob_db_tx_gain_table);
-	INI_PRINT(ar9565_1p0_pciephy_pll_on_clkreq_disable_L1);
+	INI_PRINT(ar9565_1p0_pciephy_clkreq_disable_L1);
 	INI_PRINT(ar9565_1p0_modes_fast_clock);
 	INI_PRINT(ar9565_1p0_common_wo_xlna_rx_gain_table);
 	INI_PRINT(ar9565_1p0_modes_low_ob_db_tx_gain_table);
-- 
1.8.0

