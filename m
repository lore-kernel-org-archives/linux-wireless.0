Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:37205 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946510Ab2LFSRc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 13:17:32 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 03/13] qca-swiss-army-knife: print AR9565 initvals
Date: Thu,  6 Dec 2012 19:17:17 +0100
Message-Id: <1354817847-23440-4-git-send-email-juhosg@openwrt.org> (sfid-20121206_191752_348775_D281EB6A)
In-Reply-To: <1354817847-23440-1-git-send-email-juhosg@openwrt.org>
References: <1354817847-23440-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The initvals tool contain support for the
AR9565 chip, however the sha1sum values and
the actual initval arrays are not printend
when 'initvals' is called without a family
parameter.

Add the missing 'ar9565_1p0_hw_print_initvals()'
calls to fix this. Also refresh checksums.txt.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 tools/initvals/checksums.txt |   16 ++++++++++++++++
 tools/initvals/initvals.c    |    2 ++
 2 files changed, 18 insertions(+)

diff --git a/tools/initvals/checksums.txt b/tools/initvals/checksums.txt
index 9407ae4..5f18eb1 100644
--- a/tools/initvals/checksums.txt
+++ b/tools/initvals/checksums.txt
@@ -157,6 +157,22 @@ c8016c349304ed85842783f04f01f40a0cf4468f        ar9485_1_1_pcie_phy_clkreq_disab
 f5bb0f6a25e512b85039e8c49ebc6555ff27ac4d        ar9485_1_1_radio_postamble
 be2a6982ce450a3e03b1593199395599778297b0        ar9485_1_1_mac_core
 dfaefa89122b4b769bfcf93b4bd9569f2b0ee961        ar9485_1_1_baseband_core_txfir_coeff_japan_2484
+839b2486a70775db100fca6421860d4922fbf945        ar9565_1p0_mac_core
+c8dc777b012068116cd5282aade8eb460f397d20        ar9565_1p0_mac_postamble
+be2a958615907b5f7766336b124d79cb3dbb3c1f        ar9565_1p0_baseband_core
+7ae44b5234dc536c5fe3bd484ecbf4bd4f8f8ee1        ar9565_1p0_baseband_postamble
+98708e6c8cde013777cd5c5c9ded6dfe038b652f        ar9565_1p0_radio_core
+bc722e44e8c7039983b485fc099275c6629974cf        ar9565_1p0_radio_postamble
+524fae156c2942a28c62603dac8f9ee99ff0e25a        ar9565_1p0_soc_preamble
+b045882e6e5b3f54d9eed19022abe6a44bc04e73        ar9565_1p0_soc_postamble
+bc0a956de3b035894bf68722ca4c8a4365fe0f4b        ar9565_1p0_Common_rx_gain_table
+4bf703cdebf0bfb9ad867cb53b79d6c3957b6f91        ar9565_1p0_Modes_lowest_ob_db_tx_gain_table
+2fbe90336971cd66f0264c0cc57605c2de069d5f        ar9565_1p0_pciephy_clkreq_disable_L1
+6db24dff7f419466d4734d59063314b9e52d4640        ar9565_1p0_modes_fast_clock
+d297fe8586260e902a2b629323e4802fe207f2b7        ar9565_1p0_common_wo_xlna_rx_gain_table
+4bf703cdebf0bfb9ad867cb53b79d6c3957b6f91        ar9565_1p0_modes_low_ob_db_tx_gain_table
+7e7f55da5f2572348ddf79e41e9ab9647d94caff        ar9565_1p0_modes_high_ob_db_tx_gain_table
+a67925a1d3f3263537a4a0d6096f3f8994190f14        ar9565_1p0_modes_high_power_tx_gain_table
 87e0ecae5df96673e22bc448b17d813510964de8        ar9580_1p0_modes_fast_clock
 6b0fb5b3698c99f42a885c8e982ae436363f1865        ar9580_1p0_radio_postamble
 5b81bf27a30c826cfde3e8f6746473e949cb41ef        ar9580_1p0_baseband_core
diff --git a/tools/initvals/initvals.c b/tools/initvals/initvals.c
index 5dd54f3..c93a3d1 100644
--- a/tools/initvals/initvals.c
+++ b/tools/initvals/initvals.c
@@ -910,6 +910,7 @@ int main(int argc, char *argv[])
 			ar9330_1p2_hw_print_initvals(false);
 			ar9340_hw_print_initvals(false);
 			ar9485_hw_print_initvals(false);
+			ar9565_1p0_hw_print_initvals(false);
 			ar9580_1p0_hw_print_initvals(false);
 			ar9462_2p0_hw_print_initvals(false);
 
@@ -942,6 +943,7 @@ int main(int argc, char *argv[])
 	ar9330_1p2_hw_print_initvals(true);
 	ar9340_hw_print_initvals(true);
 	ar9485_hw_print_initvals(true);
+	ar9565_1p0_hw_print_initvals(true);
 	ar9580_1p0_hw_print_initvals(true);
 	ar9462_2p0_hw_print_initvals(true);
 
-- 
1.7.10

