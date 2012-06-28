Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41943 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462Ab2F1A0n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 20:26:43 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@qca.qualcomm.com
Subject: [PATCH 08/11] qca-swiss-army-knife: de-duplicate ar9485 initvals
Date: Thu, 28 Jun 2012 02:26:36 +0200
Message-Id: <1340843199-49821-8-git-send-email-nbd@openwrt.org> (sfid-20120628_022656_871398_33E2D071)
In-Reply-To: <1340843199-49821-7-git-send-email-nbd@openwrt.org>
References: <1340843199-49821-1-git-send-email-nbd@openwrt.org>
 <1340843199-49821-2-git-send-email-nbd@openwrt.org>
 <1340843199-49821-3-git-send-email-nbd@openwrt.org>
 <1340843199-49821-4-git-send-email-nbd@openwrt.org>
 <1340843199-49821-5-git-send-email-nbd@openwrt.org>
 <1340843199-49821-6-git-send-email-nbd@openwrt.org>
 <1340843199-49821-7-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 tools/initvals/initvals.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/tools/initvals/initvals.c b/tools/initvals/initvals.c
index 81669ff..9766c28 100644
--- a/tools/initvals/initvals.c
+++ b/tools/initvals/initvals.c
@@ -650,22 +650,28 @@ static void ar9340_hw_print_initvals(bool check)
 
 static void ar9485_hw_print_initvals(bool check)
 {
-	INI_PRINT(ar9485_1_1_mac_postamble);
+	INI_PRINT_DUP(ar9485_1_1_mac_postamble,
+		      ar9300_2p2_mac_postamble);
 	INI_PRINT(ar9485_1_1_pcie_phy_pll_on_clkreq_disable_L1);
 	INI_PRINT(ar9485Common_wo_xlna_rx_gain_1_1);
+
 	INI_PRINT(ar9485Modes_high_power_tx_gain_1_1);
+	INI_PRINT_DUP(ar9485Modes_high_ob_db_tx_gain_1_1,
+		      ar9485Modes_high_power_tx_gain_1_1);
+	INI_PRINT_DUP(ar9485Modes_low_ob_db_tx_gain_1_1,
+		      ar9485Modes_high_ob_db_tx_gain_1_1);
+	INI_PRINT_DUP(ar9485_modes_lowest_ob_db_tx_gain_1_1,
+		      ar9485Modes_low_ob_db_tx_gain_1_1);
+
 	INI_PRINT(ar9485_1_1);
 	INI_PRINT(ar9485_1_1_radio_core);
-	INI_PRINT(ar9485_modes_lowest_ob_db_tx_gain_1_1);
 	INI_PRINT(ar9485_1_1_baseband_core);
-	INI_PRINT(ar9485Modes_high_ob_db_tx_gain_1_1);
 	INI_PRINT(ar9485_common_rx_gain_1_1);
 	INI_PRINT(ar9485_1_1_pcie_phy_pll_on_clkreq_enable_L1);
 	INI_PRINT(ar9485_1_1_pcie_phy_clkreq_enable_L1);
 	INI_PRINT(ar9485_1_1_soc_preamble);
 	INI_PRINT(ar9485_fast_clock_1_1_baseband_postamble);
 	INI_PRINT(ar9485_1_1_baseband_postamble);
-	INI_PRINT(ar9485Modes_low_ob_db_tx_gain_1_1);
 	INI_PRINT(ar9485_1_1_pcie_phy_clkreq_disable_L1);
 	INI_PRINT(ar9485_1_1_radio_postamble);
 	INI_PRINT(ar9485_1_1_mac_core);
-- 
1.7.3.2

