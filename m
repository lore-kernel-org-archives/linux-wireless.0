Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:50026 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab3LDEeN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 23:34:13 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] ath9k: Add initval arrays for DFS channels
Date: Wed,  4 Dec 2013 09:59:24 +0530
Message-Id: <1386131365-28780-1-git-send-email-sujith@msujith.org> (sfid-20131204_053435_481288_3AB00648)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h |  7 +++++++
 drivers/net/wireless/ath/ath9k/ar9340_initvals.h     |  2 ++
 drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h | 13 +++++++++++--
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
index e7cdf11..97b4bd1 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
@@ -1745,4 +1745,11 @@ static const u32 ar9300_2p2_baseband_core_txfir_coeff_japan_2484[][2] = {
 	{0x0000a3a0, 0xca9228ee},
 };
 
+static const u32 ar9300_2p2_baseband_postamble_dfs_channel[][3] = {
+	/* Addr      5G          2G        */
+	{0x00009824, 0x5ac668d0, 0x5ac668d0},
+	{0x00009e0c, 0x6d4000e2, 0x6d4000e2},
+	{0x00009e14, 0x37b9625e, 0x37b9625e},
+};
+
 #endif /* INITVALS_9003_2P2_H */
diff --git a/drivers/net/wireless/ath/ath9k/ar9340_initvals.h b/drivers/net/wireless/ath/ath9k/ar9340_initvals.h
index 7f22cb2..a01f0ed 100644
--- a/drivers/net/wireless/ath/ath9k/ar9340_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9340_initvals.h
@@ -30,6 +30,8 @@
 
 #define ar9340_1p0_baseband_core_txfir_coeff_japan_2484 ar9300_2p2_baseband_core_txfir_coeff_japan_2484
 
+#define ar9340_1p0_baseband_postamble_dfs_channel ar9300_2p2_baseband_postamble_dfs_channel
+
 static const u32 ar9340_1p0_radio_postamble[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x000160ac, 0xa4646800, 0xa4646800, 0xa4646800, 0xa4646800},
diff --git a/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h
index 75bef11..e6aec2c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h
@@ -57,8 +57,6 @@ static const u32 ar9580_1p0_baseband_core[][2] = {
 	{0x00009804, 0xfd14e000},
 	{0x00009808, 0x9c0a9f6b},
 	{0x0000980c, 0x04900000},
-	{0x00009814, 0x3280c00a},
-	{0x00009818, 0x00000000},
 	{0x0000981c, 0x00020028},
 	{0x00009834, 0x6400a190},
 	{0x00009838, 0x0108ecff},
@@ -1133,6 +1131,8 @@ static const u32 ar9580_1p0_rx_gain_table[][2] = {
 static const u32 ar9580_1p0_baseband_postamble[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x00009810, 0xd00a8005, 0xd00a8005, 0xd00a8011, 0xd00a8011},
+	{0x00009814, 0x3280c00a, 0x3280c00a, 0x3280c00a, 0x3280c00a},
+	{0x00009818, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x00009820, 0x206a022e, 0x206a022e, 0x206a012e, 0x206a012e},
 	{0x00009824, 0x5ac640d0, 0x5ac640d0, 0x5ac640d0, 0x5ac640d0},
 	{0x00009828, 0x06903081, 0x06903081, 0x06903881, 0x06903881},
@@ -1207,4 +1207,13 @@ static const u32 ar9580_1p0_pcie_phy_pll_on_clkreq[][2] = {
 	{0x00004044, 0x00000000},
 };
 
+static const u32 ar9580_1p0_baseband_postamble_dfs_channel[][3] = {
+	/* Addr      5G          2G        */
+	{0x00009814, 0x3400c00f, 0x3400c00f},
+	{0x00009824, 0x5ac668d0, 0x5ac668d0},
+	{0x00009828, 0x06903080, 0x06903080},
+	{0x00009e0c, 0x6d4000e2, 0x6d4000e2},
+	{0x00009e14, 0x37b9625e, 0x37b9625e},
+};
+
 #endif /* INITVALS_9580_1P0_H */
-- 
1.8.4.2

