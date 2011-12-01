Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4812 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab1LAFpD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Dec 2011 00:45:03 -0500
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Wilson Tsao <wtsao@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath9k_hw: sync to latest AR9462 INI
Date: Thu, 1 Dec 2011 11:14:19 +0530
Message-ID: <1322718259-5551-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111201_064509_318419_9BA05E33)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

based on systems change to improve rx dynamic range,
and enables heavy clip for 5G HT40 MCS0 to improve
spectral mask power. also remove an unused function
declaration

Cc: Wilson Tsao <wtsao@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 .../net/wireless/ath/ath9k/ar9462_2p0_initvals.h   |   42 ++++++++++----------
 drivers/net/wireless/ath/ath9k/hw.h                |    1 -
 2 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
index 259a6f3..dc2054f 100644
--- a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
@@ -41,24 +41,24 @@ static const u32 ar9462_pciephy_clkreq_enable_L1_2p0[][2] = {
 
 static const u32 ar9462_2p0_baseband_postamble[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
-	{0x00009810, 0xd00a8005, 0xd00a8005, 0xd00a8011, 0xd00a8011},
-	{0x00009820, 0x206a022e, 0x206a022e, 0x206a012e, 0x206a012e},
-	{0x00009824, 0x5ac640de, 0x5ac640d0, 0x5ac640d0, 0x5ac640de},
-	{0x00009828, 0x0796be89, 0x0696b081, 0x0696b881, 0x0796be89},
+	{0x00009810, 0xd00a8005, 0xd00a8005, 0xd00a8011, 0xd00a800d},
+	{0x00009820, 0x206a022e, 0x206a022e, 0x206a012e, 0x206a01ae},
+	{0x00009824, 0x5ac640de, 0x5ac640d0, 0x5ac640d0, 0x63c640da},
+	{0x00009828, 0x0796be89, 0x0696b081, 0x0696b881, 0x09143e81},
 	{0x0000982c, 0x05eea6d4, 0x05eea6d4, 0x05eea6d4, 0x05eea6d4},
 	{0x00009830, 0x0000059c, 0x0000059c, 0x0000119c, 0x0000119c},
 	{0x00009c00, 0x000000c4, 0x000000c4, 0x000000c4, 0x000000c4},
 	{0x00009e00, 0x0372111a, 0x0372111a, 0x037216a0, 0x037216a0},
 	{0x00009e04, 0x001c2020, 0x001c2020, 0x001c2020, 0x001c2020},
-	{0x00009e0c, 0x6c4000e2, 0x6d4000e2, 0x6d4000e2, 0x6c4000e2},
-	{0x00009e10, 0x92c88d2e, 0x7ec88d2e, 0x7ec84d2e, 0x92c84d2e},
-	{0x00009e14, 0x37b95d5e, 0x37b9605e, 0x3379605e, 0x33795d5e},
+	{0x00009e0c, 0x6c4000e2, 0x6d4000e2, 0x6d4000e2, 0x6c4000d8},
+	{0x00009e10, 0x92c88d2e, 0x7ec88d2e, 0x7ec84d2e, 0x7ec86d2e},
+	{0x00009e14, 0x37b95d5e, 0x37b9605e, 0x3376605e, 0x33795d5e},
 	{0x00009e18, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x00009e1c, 0x0001cf9c, 0x0001cf9c, 0x00021f9c, 0x00021f9c},
 	{0x00009e20, 0x000003b5, 0x000003b5, 0x000003ce, 0x000003ce},
 	{0x00009e2c, 0x0000001c, 0x0000001c, 0x00000021, 0x00000021},
-	{0x00009e3c, 0xcf946220, 0xcf946220, 0xcfd5c782, 0xcfd5c782},
-	{0x00009e44, 0xfe321e27, 0xfe321e27, 0xfe291e27, 0xfe291e27},
+	{0x00009e3c, 0xcf946220, 0xcf946220, 0xcfd5c782, 0xcfd5c282},
+	{0x00009e44, 0x62321e27, 0x62321e27, 0xfe291e27, 0xfe291e27},
 	{0x00009e48, 0x5030201a, 0x5030201a, 0x50302012, 0x50302012},
 	{0x00009fc8, 0x0003f000, 0x0003f000, 0x0001a000, 0x0001a000},
 	{0x0000a204, 0x013187c0, 0x013187c4, 0x013187c4, 0x013187c0},
@@ -81,6 +81,15 @@ static const u32 ar9462_2p0_baseband_postamble[][5] = {
 	{0x0000a2d0, 0x00041981, 0x00041981, 0x00041981, 0x00041982},
 	{0x0000a2d8, 0x7999a83b, 0x7999a83b, 0x7999a83b, 0x7999a83b},
 	{0x0000a358, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000a3a4, 0x00000010, 0x00000010, 0x00000000, 0x00000000},
+	{0x0000a3a8, 0xaaaaaaaa, 0xaaaaaaaa, 0xaaaaaaaa, 0xaaaaaaaa},
+	{0x0000a3ac, 0xaaaaaa00, 0xaaaaaa30, 0xaaaaaa00, 0xaaaaaa00},
+	{0x0000a41c, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce},
+	{0x0000a420, 0x000001ce, 0x000001ce, 0x000001ce, 0x000001ce},
+	{0x0000a424, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce},
+	{0x0000a428, 0x000001ce, 0x000001ce, 0x000001ce, 0x000001ce},
+	{0x0000a42c, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce},
+	{0x0000a430, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce},
 	{0x0000a830, 0x0000019c, 0x0000019c, 0x0000019c, 0x0000019c},
 	{0x0000ae04, 0x001c0000, 0x001c0000, 0x001c0000, 0x00100000},
 	{0x0000ae18, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
@@ -1107,11 +1116,11 @@ static const u32 ar9462_2p0_baseband_core[][2] = {
 	{0x00009e30, 0x06336f77},
 	{0x00009e34, 0x6af6532f},
 	{0x00009e38, 0x0cc80c00},
-	{0x00009e40, 0x0d261820},
+	{0x00009e40, 0x15262820},
 	{0x00009e4c, 0x00001004},
 	{0x00009e50, 0x00ff03f1},
-	{0x00009e54, 0xe4c355c7},
-	{0x00009e58, 0xfd897735},
+	{0x00009e54, 0xe4c555c2},
+	{0x00009e58, 0xfd857722},
 	{0x00009e5c, 0xe9198724},
 	{0x00009fc0, 0x803e4788},
 	{0x00009fc4, 0x0001efb5},
@@ -1142,9 +1151,6 @@ static const u32 ar9462_2p0_baseband_core[][2] = {
 	{0x0000a398, 0x001f0e0f},
 	{0x0000a39c, 0x0075393f},
 	{0x0000a3a0, 0xb79f6427},
-	{0x0000a3a4, 0x00000000},
-	{0x0000a3a8, 0xaaaaaaaa},
-	{0x0000a3ac, 0x3c466478},
 	{0x0000a3c0, 0x20202020},
 	{0x0000a3c4, 0x22222220},
 	{0x0000a3c8, 0x20200020},
@@ -1167,12 +1173,6 @@ static const u32 ar9462_2p0_baseband_core[][2] = {
 	{0x0000a40c, 0x00820820},
 	{0x0000a414, 0x1ce739ce},
 	{0x0000a418, 0x2d001dce},
-	{0x0000a41c, 0x1ce739ce},
-	{0x0000a420, 0x000001ce},
-	{0x0000a424, 0x1ce739ce},
-	{0x0000a428, 0x000001ce},
-	{0x0000a42c, 0x1ce739ce},
-	{0x0000a430, 0x1ce739ce},
 	{0x0000a434, 0x00000000},
 	{0x0000a438, 0x00001801},
 	{0x0000a43c, 0x00100000},
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index c9c3b18..36968c0 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -1110,7 +1110,6 @@ bool ath9k_hw_disable(struct ath_hw *ah);
 void ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32 limit, bool test);
 void ath9k_hw_setopmode(struct ath_hw *ah);
 void ath9k_hw_setmcastfilter(struct ath_hw *ah, u32 filter0, u32 filter1);
-void ath9k_hw_setbssidmask(struct ath_hw *ah);
 void ath9k_hw_write_associd(struct ath_hw *ah);
 u32 ath9k_hw_gettsf32(struct ath_hw *ah);
 u64 ath9k_hw_gettsf64(struct ath_hw *ah);
-- 
1.7.0.4

