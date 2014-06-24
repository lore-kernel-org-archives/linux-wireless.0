Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:52159 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbaFXLhF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 07:37:05 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 2/5] ath9k_hw: Add QCA953x 2.0 initvals
Date: Tue, 24 Jun 2014 17:07:46 +0530
Message-ID: <1403609869-12901-2-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140624_133712_764258_B556F9B3)
In-Reply-To: <1403609869-12901-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1403609869-12901-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c       |  15 +-
 drivers/net/wireless/ath/ath9k/ar953x_initvals.h | 199 +++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/reg.h             |   4 +
 3 files changed, 214 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index ec1da0c..ddef9ee 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -314,10 +314,17 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 			       qca953x_1p0_mac_core);
 		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_POST],
 			       qca953x_1p0_mac_postamble);
-		INIT_INI_ARRAY(&ah->iniBB[ATH_INI_CORE],
-			       qca953x_1p0_baseband_core);
-		INIT_INI_ARRAY(&ah->iniBB[ATH_INI_POST],
-			       qca953x_1p0_baseband_postamble);
+		if (AR_SREV_9531_20(ah)) {
+			INIT_INI_ARRAY(&ah->iniBB[ATH_INI_CORE],
+				       qca953x_2p0_baseband_core);
+			INIT_INI_ARRAY(&ah->iniBB[ATH_INI_POST],
+				       qca953x_2p0_baseband_postamble);
+		} else {
+			INIT_INI_ARRAY(&ah->iniBB[ATH_INI_CORE],
+				       qca953x_1p0_baseband_core);
+			INIT_INI_ARRAY(&ah->iniBB[ATH_INI_POST],
+				       qca953x_1p0_baseband_postamble);
+		}
 		INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_CORE],
 			       qca953x_1p0_radio_core);
 		INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_POST],
diff --git a/drivers/net/wireless/ath/ath9k/ar953x_initvals.h b/drivers/net/wireless/ath/ath9k/ar953x_initvals.h
index 1907f86..812a9d7 100644
--- a/drivers/net/wireless/ath/ath9k/ar953x_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar953x_initvals.h
@@ -715,4 +715,203 @@ static const u32 qca953x_1p1_modes_no_xpa_tx_gain_table[][2] = {
 	{0x00016448, 0x6c927a70},
 };
 
+static const u32 qca953x_2p0_baseband_core[][2] = {
+	/* Addr      allmodes */
+	{0x00009800, 0xafe68e30},
+	{0x00009804, 0xfd14e000},
+	{0x00009808, 0x9c0a9f6b},
+	{0x0000980c, 0x04900000},
+	{0x00009814, 0x0280c00a},
+	{0x00009818, 0x00000000},
+	{0x0000981c, 0x00020028},
+	{0x00009834, 0x6400a190},
+	{0x00009838, 0x0108ecff},
+	{0x0000983c, 0x14000600},
+	{0x00009880, 0x201fff00},
+	{0x00009884, 0x00001042},
+	{0x000098a4, 0x00200400},
+	{0x000098b0, 0x32840bbe},
+	{0x000098bc, 0x00000002},
+	{0x000098d0, 0x004b6a8e},
+	{0x000098d4, 0x00000820},
+	{0x000098dc, 0x00000000},
+	{0x000098f0, 0x00000000},
+	{0x000098f4, 0x00000000},
+	{0x00009c04, 0xff55ff55},
+	{0x00009c08, 0x0320ff55},
+	{0x00009c0c, 0x00000000},
+	{0x00009c10, 0x00000000},
+	{0x00009c14, 0x00046384},
+	{0x00009c18, 0x05b6b440},
+	{0x00009c1c, 0x00b6b440},
+	{0x00009d00, 0xc080a333},
+	{0x00009d04, 0x40206c10},
+	{0x00009d08, 0x009c4060},
+	{0x00009d0c, 0x9883800a},
+	{0x00009d10, 0x018848c6},
+	{0x00009d14, 0x00c0040b},
+	{0x00009d18, 0x00000000},
+	{0x00009e08, 0x0038230c},
+	{0x00009e24, 0x990bb515},
+	{0x00009e28, 0x0c6f0000},
+	{0x00009e30, 0x06336f77},
+	{0x00009e34, 0x6af6532f},
+	{0x00009e38, 0x0cc80c00},
+	{0x00009e40, 0x0d261820},
+	{0x00009e4c, 0x00001004},
+	{0x00009e50, 0x00ff03f1},
+	{0x00009fc0, 0x813e4788},
+	{0x00009fc4, 0x0001efb5},
+	{0x00009fcc, 0x40000014},
+	{0x00009fd0, 0x02993b93},
+	{0x0000a20c, 0x00000000},
+	{0x0000a220, 0x00000000},
+	{0x0000a224, 0x00000000},
+	{0x0000a228, 0x10002310},
+	{0x0000a23c, 0x00000000},
+	{0x0000a244, 0x0c000000},
+	{0x0000a248, 0x00000140},
+	{0x0000a2a0, 0x00000007},
+	{0x0000a2c0, 0x00000007},
+	{0x0000a2c8, 0x00000000},
+	{0x0000a2d4, 0x00000000},
+	{0x0000a2ec, 0x00000000},
+	{0x0000a2f0, 0x00000000},
+	{0x0000a2f4, 0x00000000},
+	{0x0000a2f8, 0x00000000},
+	{0x0000a344, 0x00000000},
+	{0x0000a34c, 0x00000000},
+	{0x0000a350, 0x0000a000},
+	{0x0000a364, 0x00000000},
+	{0x0000a370, 0x00000000},
+	{0x0000a390, 0x00000001},
+	{0x0000a394, 0x00000444},
+	{0x0000a398, 0x001f0e0f},
+	{0x0000a39c, 0x0075393f},
+	{0x0000a3a0, 0xb79f6427},
+	{0x0000a3a4, 0x000400ff},
+	{0x0000a3a8, 0x6a6a6a6a},
+	{0x0000a3ac, 0x6a6a6a6a},
+	{0x0000a3b0, 0x00c8641a},
+	{0x0000a3b4, 0x0000001a},
+	{0x0000a3b8, 0x0088642a},
+	{0x0000a3bc, 0x000001fa},
+	{0x0000a3c0, 0x20202020},
+	{0x0000a3c4, 0x22222220},
+	{0x0000a3c8, 0x20200020},
+	{0x0000a3cc, 0x20202020},
+	{0x0000a3d0, 0x20202020},
+	{0x0000a3d4, 0x20202020},
+	{0x0000a3d8, 0x20202020},
+	{0x0000a3dc, 0x20202020},
+	{0x0000a3e0, 0x20202020},
+	{0x0000a3e4, 0x20202020},
+	{0x0000a3e8, 0x20202020},
+	{0x0000a3ec, 0x20202020},
+	{0x0000a3f0, 0x00000000},
+	{0x0000a3f4, 0x00000000},
+	{0x0000a3f8, 0x0c9bd380},
+	{0x0000a3fc, 0x000f0f01},
+	{0x0000a400, 0x8fa91f01},
+	{0x0000a404, 0x00000000},
+	{0x0000a408, 0x0e79e5c6},
+	{0x0000a40c, 0x00820820},
+	{0x0000a414, 0x1ce42108},
+	{0x0000a418, 0x2d001dce},
+	{0x0000a41c, 0x1ce73908},
+	{0x0000a420, 0x000001ce},
+	{0x0000a424, 0x1ce738e7},
+	{0x0000a428, 0x000001ce},
+	{0x0000a42c, 0x1ce739ce},
+	{0x0000a430, 0x1ce739ce},
+	{0x0000a434, 0x00000000},
+	{0x0000a438, 0x00001801},
+	{0x0000a43c, 0x00100000},
+	{0x0000a444, 0x00000000},
+	{0x0000a448, 0x05000080},
+	{0x0000a44c, 0x00000001},
+	{0x0000a450, 0x00010000},
+	{0x0000a458, 0x00000000},
+	{0x0000a644, 0xbfad9d74},
+	{0x0000a648, 0x0048060a},
+	{0x0000a64c, 0x00003c37},
+	{0x0000a670, 0x03020100},
+	{0x0000a674, 0x09080504},
+	{0x0000a678, 0x0d0c0b0a},
+	{0x0000a67c, 0x13121110},
+	{0x0000a680, 0x31301514},
+	{0x0000a684, 0x35343332},
+	{0x0000a688, 0x00000036},
+	{0x0000a690, 0x08000838},
+	{0x0000a7cc, 0x00000000},
+	{0x0000a7d0, 0x00000000},
+	{0x0000a7d4, 0x00000004},
+	{0x0000a7dc, 0x00000000},
+	{0x0000a8d0, 0x004b6a8e},
+	{0x0000a8d4, 0x00000820},
+	{0x0000a8dc, 0x00000000},
+	{0x0000a8f0, 0x00000000},
+	{0x0000a8f4, 0x00000000},
+	{0x0000b2d0, 0x00000080},
+	{0x0000b2d4, 0x00000000},
+	{0x0000b2ec, 0x00000000},
+	{0x0000b2f0, 0x00000000},
+	{0x0000b2f4, 0x00000000},
+	{0x0000b2f8, 0x00000000},
+	{0x0000b408, 0x0e79e5c0},
+	{0x0000b40c, 0x00820820},
+	{0x0000b420, 0x00000000},
+};
+
+static const u32 qca953x_2p0_baseband_postamble[][5] = {
+	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
+	{0x00009810, 0xd00a8005, 0xd00a8005, 0xd00a8011, 0xd00a8011},
+	{0x00009820, 0x206a022e, 0x206a022e, 0x206a012e, 0x206a012e},
+	{0x00009824, 0x5ac640d0, 0x5ac640d0, 0x5ac640d0, 0x5ac640d0},
+	{0x00009828, 0x06903081, 0x06903081, 0x06903881, 0x06903881},
+	{0x0000982c, 0x05eea6d4, 0x05eea6d4, 0x05eea6d4, 0x05eea6d4},
+	{0x00009830, 0x0000059c, 0x0000059c, 0x0000119c, 0x0000119c},
+	{0x00009c00, 0x000000c4, 0x000000c4, 0x000000c4, 0x000000c4},
+	{0x00009e00, 0x0372111a, 0x0372111a, 0x037216a0, 0x037216a0},
+	{0x00009e04, 0x001c2020, 0x001c2020, 0x001c2020, 0x001c2020},
+	{0x00009e0c, 0x6c4000e2, 0x6d4000e2, 0x6d4000e2, 0x6c4000e2},
+	{0x00009e10, 0x7ec88d2e, 0x7ec88d2e, 0x7ec84d2e, 0x7ec84d2e},
+	{0x00009e14, 0x37b95d5e, 0x37b9605e, 0x3379605e, 0x33795d5e},
+	{0x00009e18, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x00009e1c, 0x0001cf9c, 0x0001cf9c, 0x00021f9c, 0x00021f9c},
+	{0x00009e20, 0x000003b5, 0x000003b5, 0x000003ce, 0x000003ce},
+	{0x00009e2c, 0x0000001c, 0x0000001c, 0x00000021, 0x00000021},
+	{0x00009e3c, 0xcfa10820, 0xcfa10820, 0xcf946222, 0xcf946222},
+	{0x00009e44, 0xfe321e27, 0xfe321e27, 0xfe291e27, 0xfe291e27},
+	{0x00009e48, 0x5030201a, 0x5030201a, 0x50302012, 0x50302012},
+	{0x00009fc8, 0x0003f000, 0x0003f000, 0x0001a000, 0x0001a000},
+	{0x0000a204, 0x005c0ec0, 0x005c0ec4, 0x005c0ec4, 0x005c0ec0},
+	{0x0000a208, 0x00000104, 0x00000104, 0x00000004, 0x00000004},
+	{0x0000a22c, 0x07e26a2f, 0x07e26a2f, 0x01026a2f, 0x01026a2f},
+	{0x0000a230, 0x0000000a, 0x00000014, 0x00000016, 0x0000000b},
+	{0x0000a234, 0x00000fff, 0x10000fff, 0x10000fff, 0x00000fff},
+	{0x0000a238, 0xffb01018, 0xffb01018, 0xffb01018, 0xffb01018},
+	{0x0000a250, 0x00000000, 0x00000000, 0x00000210, 0x00000108},
+	{0x0000a254, 0x000007d0, 0x00000fa0, 0x00001130, 0x00000898},
+	{0x0000a258, 0x02020002, 0x02020002, 0x02020002, 0x02020002},
+	{0x0000a25c, 0x01000e0e, 0x01000e0e, 0x01010e0e, 0x01010e0e},
+	{0x0000a260, 0x0a021501, 0x0a021501, 0x3a021501, 0x3a021501},
+	{0x0000a264, 0x00000e0e, 0x00000e0e, 0x01000e0e, 0x01000e0e},
+	{0x0000a280, 0x00000007, 0x00000007, 0x0000000b, 0x0000000b},
+	{0x0000a284, 0x00000000, 0x00000000, 0x00000010, 0x00000010},
+	{0x0000a288, 0x00000110, 0x00000110, 0x00000110, 0x00000110},
+	{0x0000a28c, 0x00022222, 0x00022222, 0x00022222, 0x00022222},
+	{0x0000a2c4, 0x00158d18, 0x00158d18, 0x00158d18, 0x00158d18},
+	{0x0000a2cc, 0x18c50033, 0x18c43433, 0x18c41033, 0x18c44c33},
+	{0x0000a2d0, 0x00041982, 0x00041982, 0x00041982, 0x00041982},
+	{0x0000a2d8, 0x7999a83b, 0x7999a83b, 0x7999a83b, 0x7999a83b},
+	{0x0000a358, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000a830, 0x0000019c, 0x0000019c, 0x0000019c, 0x0000019c},
+	{0x0000ae04, 0x001c0000, 0x001c0000, 0x001c0000, 0x001c0000},
+	{0x0000ae18, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000ae1c, 0x0000019c, 0x0000019c, 0x0000019c, 0x0000019c},
+	{0x0000ae20, 0x000001b5, 0x000001b5, 0x000001ce, 0x000001ce},
+	{0x0000b284, 0x00000000, 0x00000000, 0x00000010, 0x00000010},
+};
+
 #endif /* INITVALS_953X_H */
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index f1bbce3..a149970 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -813,6 +813,7 @@
 #define AR_SREV_VERSION_9531            0x500
 #define AR_SREV_REVISION_9531_10        0
 #define AR_SREV_REVISION_9531_11        1
+#define AR_SREV_REVISION_9531_20        2
 
 #define AR_SREV_5416(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_5416_PCI) || \
@@ -958,6 +959,9 @@
 #define AR_SREV_9531_11(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9531) && \
 	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9531_11))
+#define AR_SREV_9531_20(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9531) && \
+	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9531_20))
 
 /* NOTE: When adding chips newer than Peacock, add chip check here */
 #define AR_SREV_9580_10_OR_LATER(_ah) \
-- 
2.0.0

