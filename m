Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:46678 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964780Ab2GCQyi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 12:54:38 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 07/10] qca-swiss-army-knife: add initval support for AR955X
Date: Tue,  3 Jul 2012 18:42:52 +0200
Message-Id: <1341333775-14091-8-git-send-email-juhosg@openwrt.org> (sfid-20120703_185444_805553_0631E7A2)
In-Reply-To: <1341333775-14091-1-git-send-email-juhosg@openwrt.org>
References: <1341333775-14091-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 tools/initvals/Makefile   |    1 +
 tools/initvals/initvals.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/tools/initvals/Makefile b/tools/initvals/Makefile
index a7f7c0c..a4e375e 100644
--- a/tools/initvals/Makefile
+++ b/tools/initvals/Makefile
@@ -20,6 +20,7 @@ ATHEROS_DEPS += \
 	ar9330_12.ini		\
 	ar9340.ini		\
 	ar9485.ini		\
+	ar955x.ini		\
 	ar9580.ini		\
 	ar9300_jupiter20.ini
 endif
diff --git a/tools/initvals/initvals.c b/tools/initvals/initvals.c
index d7df352..4327f0d 100644
--- a/tools/initvals/initvals.c
+++ b/tools/initvals/initvals.c
@@ -233,6 +233,25 @@ struct initval_family {
 
 #include "ar9485_1_1.ini"
 
+#define ar955x_scorpion_1p0_radio_postamble			ar955x_1p0_radio_postamble
+#define ar955x_scorpion_1p0_baseband_core_txfir_coeff_japan_2484 ar955x_1p0_baseband_core_txfir_coeff_japan_2484
+#define ar955x_scorpion_1p0_baseband_postamble			ar955x_1p0_baseband_postamble
+#define ar955x_scorpion_1p0_radio_core				ar955x_1p0_radio_core
+#define ar955xModes_xpa_tx_gain_table_scorpion_1p0		ar955x_1p0_modes_xpa_tx_gain_table
+#define ar955x_scorpion_1p0_mac_core				ar955x_1p0_mac_core
+#define ar955xCommon_rx_gain_table_scorpion_1p0			ar955x_1p0_common_rx_gain_table
+#define ar955x_scorpion_1p0_baseband_core			ar955x_1p0_baseband_core
+#define ar955xCommon_wo_xlna_rx_gain_table_scorpion_1p0		ar955x_1p0_common_wo_xlna_rx_gain_table
+#define ar955x_scorpion_1p0_soc_preamble			ar955x_1p0_soc_preamble
+#define ar955xCommon_wo_xlna_rx_gain_bounds_scorpion_1p0	ar955x_1p0_common_wo_xlna_rx_gain_bounds
+#define ar955x_scorpion_1p0_mac_postamble			ar955x_1p0_mac_postamble
+#define ar955xCommon_rx_gain_bounds_scorpion_1p0		ar955x_1p0_common_rx_gain_bounds
+#define ar955xModes_no_xpa_tx_gain_table_scorpion_1p0		ar955x_1p0_modes_no_xpa_tx_gain_table
+#define ar955x_scorpion_1p0_soc_postamble			ar955x_1p0_soc_postamble
+#define ar955xModes_fast_clock_scorpion_1p0			ar955x_1p0_modes_fast_clock
+
+#include "ar955x.ini"
+
 #define ar9300Modes_fast_clock_ar9580_1p0			ar9580_1p0_modes_fast_clock
 #define ar9300_ar9580_1p0_radio_postamble			ar9580_1p0_radio_postamble
 #define ar9300_ar9580_1p0_baseband_core				ar9580_1p0_baseband_core
@@ -418,6 +437,9 @@ static void ath9k_hw_print_initval(const char *name, const u32 *array, u32 rows,
 		printf("static const u32 %s[][%d] = {\n", name, p_columns);
 
 	switch (p_columns) {
+	case 9:
+		printf("\t/* Addr      5G_HT20_L   5G_HT40_L   5G_HT20_M   5G_HT40_M   5G_HT20_H   5G_HT40_H   2G_HT40     2G_HT20  */\n");
+		break;
 	case 5:
 		printf("\t/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */\n");
 		break;
@@ -716,6 +738,26 @@ static void ar9485_hw_print_initvals(bool check)
 	INI_PRINT(ar9485_1_1_mac_core);
 }
 
+static void ar955x_1p0_hw_print_initvals(bool check)
+{
+	INI_PRINT(ar955x_1p0_radio_postamble);
+	INI_PRINT(ar955x_1p0_baseband_core_txfir_coeff_japan_2484);
+	INI_PRINT(ar955x_1p0_baseband_postamble);
+	INI_PRINT(ar955x_1p0_radio_core);
+	INI_PRINTW(ar955x_1p0_modes_xpa_tx_gain_table);
+	INI_PRINT(ar955x_1p0_mac_core);
+	INI_PRINT(ar955x_1p0_common_rx_gain_table);
+	INI_PRINT(ar955x_1p0_baseband_core);
+	INI_PRINT(ar955x_1p0_common_wo_xlna_rx_gain_table);
+	INI_PRINT(ar955x_1p0_soc_preamble);
+	INI_PRINT(ar955x_1p0_common_wo_xlna_rx_gain_bounds);
+	INI_PRINT(ar955x_1p0_mac_postamble);
+	INI_PRINT(ar955x_1p0_common_rx_gain_bounds);
+	INI_PRINTW(ar955x_1p0_modes_no_xpa_tx_gain_table);
+	INI_PRINT(ar955x_1p0_soc_postamble);
+	INI_PRINT(ar955x_1p0_modes_fast_clock);
+}
+
 static void ar9580_1p0_hw_print_initvals(bool check)
 {
 	INI_PRINT_DUP(ar9580_1p0_modes_fast_clock,
@@ -788,6 +830,7 @@ struct initval_family families[] = {
 	FAM("ar9330-1p2", "9330_1P2", NULL        , ar9330_1p2_hw_print_initvals),
 	FAM("ar9340"    , "9340"    , NULL        , ar9340_hw_print_initvals),
 	FAM("ar9485"    , "9485"    , "AR9485 1.0", ar9485_hw_print_initvals),
+	FAM("ar955x-1p0", "955X_1P0", "AR955X 1.0", ar955x_1p0_hw_print_initvals),
 	FAM("ar9580"    , "9580_1P0", "AR9580 1.0", ar9580_1p0_hw_print_initvals),
 	FAM("ar9462-2p0", "9462_2P0", "AR9462 2.0", ar9462_2p0_hw_print_initvals),
 };
-- 
1.7.2.1

