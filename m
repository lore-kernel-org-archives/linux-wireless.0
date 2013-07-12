Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:44671 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab3GLEDg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jul 2013 00:03:36 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/6] initvals: Add rxgain tables for AR9462
Date: Fri, 12 Jul 2013 09:30:11 +0530
Message-Id: <1373601613-31616-5-git-send-email-sujith@msujith.org> (sfid-20130712_060354_979485_6EA5A02B)
In-Reply-To: <1373601613-31616-1-git-send-email-sujith@msujith.org>
References: <1373601613-31616-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 tools/initvals/ar9462_2p0_initvals.h | 15 +++++++++++++++
 tools/initvals/checksums.txt         |  2 ++
 tools/initvals/initvals.c            |  4 ++++
 3 files changed, 21 insertions(+)

diff --git a/tools/initvals/ar9462_2p0_initvals.h b/tools/initvals/ar9462_2p0_initvals.h
index bcd0cae..1d6b705 100644
--- a/tools/initvals/ar9462_2p0_initvals.h
+++ b/tools/initvals/ar9462_2p0_initvals.h
@@ -1714,4 +1714,19 @@ static const u32 ar9462_2p0_5g_xlna_only_rxgain[][2] = {
 	{0x0000b1fc, 0x00000196},
 };
 
+static const u32 ar9462_2p0_baseband_core_mix_rxgain[][2] = {
+	/* Addr      allmodes  */
+	{0x00009fd0, 0x0a2d6b93},
+};
+
+static const u32 ar9462_2p0_baseband_postamble_mix_rxgain[][5] = {
+	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
+	{0x00009820, 0x206a022e, 0x206a022e, 0x206a01ae, 0x206a01ae},
+	{0x00009824, 0x63c640de, 0x5ac640d0, 0x63c640da, 0x63c640da},
+	{0x00009828, 0x0796be89, 0x0696b081, 0x0916be81, 0x0916be81},
+	{0x00009e0c, 0x6c4000e2, 0x6d4000e2, 0x6d4000d8, 0x6c4000d8},
+	{0x00009e10, 0x92c88d2e, 0x7ec88d2e, 0x7ec86d2e, 0x7ec86d2e},
+	{0x00009e14, 0x37b95d5e, 0x37b9605e, 0x3236605e, 0x32395c5e},
+};
+
 #endif /* INITVALS_9462_2P0_H */
diff --git a/tools/initvals/checksums.txt b/tools/initvals/checksums.txt
index 758ff85..c224297 100644
--- a/tools/initvals/checksums.txt
+++ b/tools/initvals/checksums.txt
@@ -158,6 +158,8 @@ c8dc777b012068116cd5282aade8eb460f397d20        ar9462_2p0_mac_postamble
 72675fd0f308e6f31502e283119e12469d262f40        ar9462_common_mixed_rx_gain_table_2p0
 185f0537e40b74dcc4db33c7e111c1bfe79f3104        ar9462_2p0_baseband_postamble_5g_xlna
 72675fd0f308e6f31502e283119e12469d262f40        ar9462_2p0_5g_xlna_only_rxgain
+8f24703571c460bced3d0fea95b5cfeac34a724d        ar9462_2p0_baseband_core_mix_rxgain
+cb83a8c304aae0b6fc937e61d145253a8f470d24        ar9462_2p0_baseband_postamble_mix_rxgain
 c8dc777b012068116cd5282aade8eb460f397d20        ar9485_1_1_mac_postamble
 5d20e4848b97566ad55e0e95458463d622ee5480        ar9485_1_1_pcie_phy_pll_on_clkreq_disable_L1
 d9a90632a00a7b417154173b947dfffdeab23e51        ar9485Common_wo_xlna_rx_gain_1_1
diff --git a/tools/initvals/initvals.c b/tools/initvals/initvals.c
index 2d1edba..6b72f29 100644
--- a/tools/initvals/initvals.c
+++ b/tools/initvals/initvals.c
@@ -319,6 +319,8 @@ struct initval_family {
 #define ar9300Common_mixed_rx_gain_table_jupiter_2p0		ar9462_common_mixed_rx_gain_table_2p0
 #define ar9300_jupiter_2p0_baseband_postamble_5g_xlna		ar9462_2p0_baseband_postamble_5g_xlna
 #define ar9300Common_5g_xlna_only_rx_gain_table_jupiter_2p0	ar9462_2p0_5g_xlna_only_rxgain
+#define ar9300_jupiter_2p0_baseband_core_mix_rxgain		ar9462_2p0_baseband_core_mix_rxgain
+#define ar9300_jupiter_2p0_baseband_postamble_mix_rxgain	ar9462_2p0_baseband_postamble_mix_rxgain
 
 #include "ar9300_jupiter20.ini"
 
@@ -906,6 +908,8 @@ static void ar9462_2p0_hw_print_initvals(bool check)
 	INI_PRINT(ar9462_common_mixed_rx_gain_table_2p0);
 	INI_PRINT(ar9462_2p0_baseband_postamble_5g_xlna);
 	INI_PRINT(ar9462_2p0_5g_xlna_only_rxgain);
+	INI_PRINT(ar9462_2p0_baseband_core_mix_rxgain);
+	INI_PRINT(ar9462_2p0_baseband_postamble_mix_rxgain);
 }
 
 static void ar9565_1p0_hw_print_initvals(bool check)
-- 
1.8.3.2

