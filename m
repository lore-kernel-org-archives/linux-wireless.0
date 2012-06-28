Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41940 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab2F1A0n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 20:26:43 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@qca.qualcomm.com
Subject: [PATCH 09/11] qca-swiss-army-knife: de-duplicate ar9580 initvals
Date: Thu, 28 Jun 2012 02:26:37 +0200
Message-Id: <1340843199-49821-9-git-send-email-nbd@openwrt.org> (sfid-20120628_022656_137598_B354B44E)
In-Reply-To: <1340843199-49821-8-git-send-email-nbd@openwrt.org>
References: <1340843199-49821-1-git-send-email-nbd@openwrt.org>
 <1340843199-49821-2-git-send-email-nbd@openwrt.org>
 <1340843199-49821-3-git-send-email-nbd@openwrt.org>
 <1340843199-49821-4-git-send-email-nbd@openwrt.org>
 <1340843199-49821-5-git-send-email-nbd@openwrt.org>
 <1340843199-49821-6-git-send-email-nbd@openwrt.org>
 <1340843199-49821-7-git-send-email-nbd@openwrt.org>
 <1340843199-49821-8-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 tools/initvals/initvals.c |   27 ++++++++++++++++++---------
 1 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/tools/initvals/initvals.c b/tools/initvals/initvals.c
index 9766c28..abf7b36 100644
--- a/tools/initvals/initvals.c
+++ b/tools/initvals/initvals.c
@@ -679,21 +679,30 @@ static void ar9485_hw_print_initvals(bool check)
 
 static void ar9580_1p0_hw_print_initvals(bool check)
 {
-	INI_PRINT(ar9580_1p0_modes_fast_clock);
+	INI_PRINT_DUP(ar9580_1p0_modes_fast_clock,
+		      ar9300Modes_fast_clock_2p2);
 	INI_PRINT(ar9580_1p0_radio_postamble);
 	INI_PRINT(ar9580_1p0_baseband_core);
-	INI_PRINT(ar9580_1p0_mac_postamble);
+	INI_PRINT_DUP(ar9580_1p0_mac_postamble,
+		      ar9300_2p2_mac_postamble);
 	INI_PRINT(ar9580_1p0_low_ob_db_tx_gain_table);
-	INI_PRINT(ar9580_1p0_high_power_tx_gain_table);
+	INI_PRINT_DUP(ar9580_1p0_high_power_tx_gain_table,
+		      ar9580_1p0_low_ob_db_tx_gain_table);
 	INI_PRINT(ar9580_1p0_lowest_ob_db_tx_gain_table);
-	INI_PRINT(ar9580_1p0_baseband_core_txfir_coeff_japan_2484);
+	INI_PRINT_DUP(ar9580_1p0_baseband_core_txfir_coeff_japan_2484,
+		      ar9462_2p0_baseband_core_txfir_coeff_japan_2484);
 	INI_PRINT(ar9580_1p0_mac_core);
 	INI_PRINT(ar9580_1p0_mixed_ob_db_tx_gain_table);
-	INI_PRINT(ar9580_1p0_wo_xlna_rx_gain_table);
-	INI_PRINT(ar9580_1p0_soc_postamble);
-	INI_PRINT(ar9580_1p0_high_ob_db_tx_gain_table);
-	INI_PRINT(ar9580_1p0_soc_preamble);
-	INI_PRINT(ar9580_1p0_rx_gain_table);
+	INI_PRINT_DUP(ar9580_1p0_wo_xlna_rx_gain_table,
+		      ar9300Common_wo_xlna_rx_gain_table_2p2);
+	INI_PRINT_DUP(ar9580_1p0_soc_postamble,
+		      ar9300_2p2_soc_postamble);
+	INI_PRINT_DUP(ar9580_1p0_high_ob_db_tx_gain_table,
+		      ar9300Modes_high_ob_db_tx_gain_table_2p2);
+	INI_PRINT_DUP(ar9580_1p0_soc_preamble,
+		      ar9300_2p2_soc_postamble);
+	INI_PRINT_DUP(ar9580_1p0_rx_gain_table,
+		      ar9462_common_rx_gain_table_2p0);
 	INI_PRINT(ar9580_1p0_radio_core);
 	INI_PRINT(ar9580_1p0_baseband_postamble);
 	INI_PRINT(ar9580_1p0_pcie_phy_clkreq_enable_L1);
-- 
1.7.3.2

