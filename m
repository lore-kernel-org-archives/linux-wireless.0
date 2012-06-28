Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41932 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560Ab2F1A0m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 20:26:42 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@qca.qualcomm.com
Subject: [PATCH 06/11] qca-swiss-army-knife: de-duplicate ar933x initvals
Date: Thu, 28 Jun 2012 02:26:34 +0200
Message-Id: <1340843199-49821-6-git-send-email-nbd@openwrt.org> (sfid-20120628_022719_898199_4B780A79)
In-Reply-To: <1340843199-49821-5-git-send-email-nbd@openwrt.org>
References: <1340843199-49821-1-git-send-email-nbd@openwrt.org>
 <1340843199-49821-2-git-send-email-nbd@openwrt.org>
 <1340843199-49821-3-git-send-email-nbd@openwrt.org>
 <1340843199-49821-4-git-send-email-nbd@openwrt.org>
 <1340843199-49821-5-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 tools/initvals/initvals.c |   56 ++++++++++++++++++++++++++++++++-------------
 1 files changed, 40 insertions(+), 16 deletions(-)

diff --git a/tools/initvals/initvals.c b/tools/initvals/initvals.c
index b655a4c..cae4857 100644
--- a/tools/initvals/initvals.c
+++ b/tools/initvals/initvals.c
@@ -572,14 +572,16 @@ static void ar9330_1p1_hw_print_initvals(bool check)
 	INI_PRINT(ar9331_modes_lowest_ob_db_tx_gain_1p1);
 	INI_PRINT(ar9331_modes_high_ob_db_tx_gain_1p1);
 	INI_PRINT(ar9331_modes_low_ob_db_tx_gain_1p1);
-	INI_PRINT(ar9331_1p1_baseband_core_txfir_coeff_japan_2484);
+	INI_PRINT_DUP(ar9331_1p1_baseband_core_txfir_coeff_japan_2484,
+		      ar9462_2p0_baseband_core_txfir_coeff_japan_2484);
 	INI_PRINT(ar9331_1p1_xtal_25M);
 	INI_PRINT(ar9331_1p1_radio_core);
 	INI_PRINT(ar9331_1p1_soc_postamble);
 	INI_PRINT(ar9331_common_wo_xlna_rx_gain_1p1);
 	INI_PRINT(ar9331_1p1_baseband_core);
 	INI_PRINT(ar9331_modes_high_power_tx_gain_1p1);
-	INI_PRINT(ar9331_1p1_mac_postamble);
+	INI_PRINT_DUP(ar9331_1p1_mac_postamble,
+		      ar9300_2p2_mac_postamble);
 	INI_PRINT(ar9331_1p1_soc_preamble);
 	INI_PRINT(ar9331_1p1_xtal_40M);
 	INI_PRINT(ar9331_1p1_mac_core);
@@ -589,22 +591,44 @@ static void ar9330_1p1_hw_print_initvals(bool check)
 
 static void ar9330_1p2_hw_print_initvals(bool check)
 {
-	INI_PRINT(ar9331_modes_lowest_ob_db_tx_gain_1p2);
-	INI_PRINT(ar9331_1p2_baseband_postamble);
 	INI_PRINT(ar9331_modes_high_ob_db_tx_gain_1p2);
-	INI_PRINT(ar9331_modes_low_ob_db_tx_gain_1p2);
-	INI_PRINT(ar9331_1p2_baseband_core_txfir_coeff_japan_2484);
-	INI_PRINT(ar9331_1p2_xtal_25M);
+	INI_PRINT_DUP(ar9331_modes_high_power_tx_gain_1p2,
+		      ar9331_modes_high_ob_db_tx_gain_1p2);
+	INI_PRINT_DUP(ar9331_modes_low_ob_db_tx_gain_1p2,
+		      ar9331_modes_high_power_tx_gain_1p2);
+	INI_PRINT_DUP(ar9331_modes_lowest_ob_db_tx_gain_1p2,
+		      ar9331_modes_low_ob_db_tx_gain_1p2);
+
+	INI_PRINT_DUP(ar9331_1p2_baseband_postamble,
+		      ar9331_1p1_baseband_postamble);
+
 	INI_PRINT(ar9331_1p2_radio_core);
-	INI_PRINT(ar9331_1p2_soc_postamble);
-	INI_PRINT(ar9331_common_wo_xlna_rx_gain_1p2);
-	INI_PRINT(ar9331_1p2_baseband_core);
-	INI_PRINT(ar9331_modes_high_power_tx_gain_1p2);
-	INI_PRINT(ar9331_1p2_mac_postamble);
-	INI_PRINT(ar9331_1p2_soc_preamble);
-	INI_PRINT(ar9331_1p2_xtal_40M);
-	INI_PRINT(ar9331_1p2_mac_core);
-	INI_PRINT(ar9331_common_rx_gain_1p2);
+	INI_PRINT_DUP(ar9331_1p2_baseband_core_txfir_coeff_japan_2484,
+		      ar9331_1p1_baseband_core_txfir_coeff_japan_2484);
+
+	INI_PRINT_DUP(ar9331_1p2_xtal_25M, ar9331_1p1_xtal_25M);
+	INI_PRINT_DUP(ar9331_1p2_xtal_40M, ar9331_1p1_xtal_40M);
+
+	INI_PRINT_DUP(ar9331_1p2_baseband_core,
+		      ar9331_1p1_baseband_core);
+
+	INI_PRINT_DUP(ar9331_1p2_soc_postamble,
+		      ar9331_1p1_soc_postamble);
+
+	INI_PRINT_DUP(ar9331_1p2_mac_postamble,
+		      ar9331_1p1_mac_postamble);
+
+	INI_PRINT_DUP(ar9331_1p2_soc_preamble,
+		      ar9331_1p1_soc_preamble);
+
+	INI_PRINT_DUP(ar9331_1p2_mac_core,
+		      ar9331_1p1_mac_core);
+
+	INI_PRINT_DUP(ar9331_common_wo_xlna_rx_gain_1p2,
+		      ar9331_common_wo_xlna_rx_gain_1p1);
+
+	INI_PRINT_DUP(ar9331_common_rx_gain_1p2,
+		      ar9485Common_rx_gain_1_0);
 }
 
 static void ar9340_hw_print_initvals(bool check)
-- 
1.7.3.2

