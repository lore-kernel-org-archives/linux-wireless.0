Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:39177 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759361Ab3ICFC2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 01:02:28 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/4] initvals: Add channel 14 initvals for AR9565
Date: Tue,  3 Sep 2013 10:28:35 +0530
Message-Id: <1378184318-1169-1-git-send-email-sujith@msujith.org> (sfid-20130903_070231_124190_CB2D40A5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 tools/initvals/ar9565_1p0_initvals.h | 7 +++++++
 tools/initvals/checksums.txt         | 1 +
 tools/initvals/initvals.c            | 1 +
 3 files changed, 9 insertions(+)

diff --git a/tools/initvals/ar9565_1p0_initvals.h b/tools/initvals/ar9565_1p0_initvals.h
index 03ecc07..a8c757b 100644
--- a/tools/initvals/ar9565_1p0_initvals.h
+++ b/tools/initvals/ar9565_1p0_initvals.h
@@ -1231,4 +1231,11 @@ static const u32 ar9565_1p0_modes_high_power_tx_gain_table[][5] = {
 	{0x00016054, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 };
 
+static const u32 ar9565_1p0_baseband_core_txfir_coeff_japan_2484[][2] = {
+	/* Addr      allmodes  */
+	{0x0000a398, 0x00000000},
+	{0x0000a39c, 0x6f7f0301},
+	{0x0000a3a0, 0xca9228ee},
+};
+
 #endif /* INITVALS_9565_1P0_H */
diff --git a/tools/initvals/checksums.txt b/tools/initvals/checksums.txt
index e39c382..9fd46a4 100644
--- a/tools/initvals/checksums.txt
+++ b/tools/initvals/checksums.txt
@@ -234,6 +234,7 @@ a3173672141a2ac797e660228d41a609f9ab2c4c        ar9565_1p0_pciephy_clkreq_disabl
 4bf703cdebf0bfb9ad867cb53b79d6c3957b6f91        ar9565_1p0_modes_low_ob_db_tx_gain_table
 e1be4dc91b540109b236b6b4002a9108ad3a01de        ar9565_1p0_modes_high_ob_db_tx_gain_table
 19ed468cdcc0c0be512a64d55f40c609e6d75720        ar9565_1p0_modes_high_power_tx_gain_table
+dfaefa89122b4b769bfcf93b4bd9569f2b0ee961        ar9565_1p0_baseband_core_txfir_coeff_japan_2484
 87e0ecae5df96673e22bc448b17d813510964de8        ar9580_1p0_modes_fast_clock
 6b0fb5b3698c99f42a885c8e982ae436363f1865        ar9580_1p0_radio_postamble
 5b81bf27a30c826cfde3e8f6746473e949cb41ef        ar9580_1p0_baseband_core
diff --git a/tools/initvals/initvals.c b/tools/initvals/initvals.c
index a1647e3..41e8051 100644
--- a/tools/initvals/initvals.c
+++ b/tools/initvals/initvals.c
@@ -982,6 +982,7 @@ static void ar9565_1p0_hw_print_initvals(bool check)
 	INI_PRINT(ar9565_1p0_modes_low_ob_db_tx_gain_table);
 	INI_PRINT(ar9565_1p0_modes_high_ob_db_tx_gain_table);
 	INI_PRINT(ar9565_1p0_modes_high_power_tx_gain_table);
+	INI_PRINT(ar9565_1p0_baseband_core_txfir_coeff_japan_2484);
 }
 
 #define FAM(_name, _def, _ver, _print) {	\
-- 
1.8.4

