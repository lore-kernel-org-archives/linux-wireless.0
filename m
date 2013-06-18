Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:49348 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab3FREqL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 00:46:11 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] initvals: Add 5g-XLNA table for AR9462
Date: Tue, 18 Jun 2013 10:13:09 +0530
Message-Id: <1371530590-15676-2-git-send-email-sujith@msujith.org> (sfid-20130618_064614_954150_A22E97FF)
In-Reply-To: <1371530590-15676-1-git-send-email-sujith@msujith.org>
References: <1371530590-15676-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 tools/initvals/ar9462_2p0_initvals.h | 5 +++++
 tools/initvals/checksums.txt         | 1 +
 tools/initvals/initvals.c            | 2 ++
 3 files changed, 8 insertions(+)

diff --git a/tools/initvals/ar9462_2p0_initvals.h b/tools/initvals/ar9462_2p0_initvals.h
index f00e945..d402c5d 100644
--- a/tools/initvals/ar9462_2p0_initvals.h
+++ b/tools/initvals/ar9462_2p0_initvals.h
@@ -1449,4 +1449,9 @@ static const u32 ar9462_common_mixed_rx_gain_table_2p0[][2] = {
 	{0x0000b1fc, 0x00000196},
 };
 
+static const u32 ar9462_2p0_baseband_postamble_5g_xlna[][5] = {
+	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
+	{0x00009e3c, 0xcf946220, 0xcf946220, 0xcfd5c782, 0xcfd5c282},
+};
+
 #endif /* INITVALS_9462_2P0_H */
diff --git a/tools/initvals/checksums.txt b/tools/initvals/checksums.txt
index e3632c8..5cb85c8 100644
--- a/tools/initvals/checksums.txt
+++ b/tools/initvals/checksums.txt
@@ -156,6 +156,7 @@ fd98d0361e085b102131c2dc07c601e0a7ccdd13        ar9462_2p0_radio_core
 2e6ddfe3c7e291ca6bebb5791d8a73c492db0399        ar9462_2p0_mac_core
 c8dc777b012068116cd5282aade8eb460f397d20        ar9462_2p0_mac_postamble
 72675fd0f308e6f31502e283119e12469d262f40        ar9462_common_mixed_rx_gain_table_2p0
+185f0537e40b74dcc4db33c7e111c1bfe79f3104        ar9462_2p0_baseband_postamble_5g_xlna
 c8dc777b012068116cd5282aade8eb460f397d20        ar9485_1_1_mac_postamble
 5d20e4848b97566ad55e0e95458463d622ee5480        ar9485_1_1_pcie_phy_pll_on_clkreq_disable_L1
 d9a90632a00a7b417154173b947dfffdeab23e51        ar9485Common_wo_xlna_rx_gain_1_1
diff --git a/tools/initvals/initvals.c b/tools/initvals/initvals.c
index 0f4c3f1..f8a104a 100644
--- a/tools/initvals/initvals.c
+++ b/tools/initvals/initvals.c
@@ -317,6 +317,7 @@ struct initval_family {
 #define ar9300_jupiter_2p0_mac_core				ar9462_2p0_mac_core
 #define ar9300_jupiter_2p0_mac_postamble			ar9462_2p0_mac_postamble
 #define ar9300Common_mixed_rx_gain_table_jupiter_2p0		ar9462_common_mixed_rx_gain_table_2p0
+#define ar9300_jupiter_2p0_baseband_postamble_5g_xlna		ar9462_2p0_baseband_postamble_5g_xlna
 
 #include "ar9300_jupiter20.ini"
 
@@ -902,6 +903,7 @@ static void ar9462_2p0_hw_print_initvals(bool check)
 	INI_PRINT(ar9462_2p0_mac_core);
 	INI_PRINT(ar9462_2p0_mac_postamble);
 	INI_PRINT(ar9462_common_mixed_rx_gain_table_2p0);
+	INI_PRINT(ar9462_2p0_baseband_postamble_5g_xlna);
 }
 
 static void ar9565_1p0_hw_print_initvals(bool check)
-- 
1.8.3.1

