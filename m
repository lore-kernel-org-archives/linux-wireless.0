Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:45851 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab3FYHCY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jun 2013 03:02:24 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Add mix tx gain table for AR9462 2.0
Date: Tue, 25 Jun 2013 12:29:23 +0530
Message-Id: <1372143563-5906-1-git-send-email-sujith@msujith.org> (sfid-20130625_090227_764164_6E9367C6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |  3 ++
 .../net/wireless/ath/ath9k/ar9462_2p0_initvals.h   | 63 ++++++++++++++++++++++
 2 files changed, 66 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 3101c39..d402cb3 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -542,6 +542,9 @@ static void ar9003_tx_gain_table_mode4(struct ath_hw *ah)
 	else if (AR_SREV_9462_21(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 		       ar9462_2p1_modes_mix_ob_db_tx_gain);
+	else if (AR_SREV_9462_20(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+		       ar9462_modes_mix_ob_db_tx_gain_table_2p0);
 	else
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar9300Modes_mixed_ob_db_tx_gain_table_2p2);
diff --git a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
index 1d6b705..092b9d4 100644
--- a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
@@ -879,6 +879,69 @@ static const u32 ar9462_2p0_radio_postamble[][5] = {
 	{0x0001650c, 0x48000000, 0x40000000, 0x40000000, 0x40000000},
 };
 
+static const u32 ar9462_modes_mix_ob_db_tx_gain_table_2p0[][5] = {
+	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
+	{0x000098bc, 0x00000002, 0x00000002, 0x00000002, 0x00000002},
+	{0x0000a2dc, 0x01feee00, 0x01feee00, 0x03aaa352, 0x03aaa352},
+	{0x0000a2e0, 0x0000f000, 0x0000f000, 0x03ccc584, 0x03ccc584},
+	{0x0000a2e4, 0x01ff0000, 0x01ff0000, 0x03f0f800, 0x03f0f800},
+	{0x0000a2e8, 0x00000000, 0x00000000, 0x03ff0000, 0x03ff0000},
+	{0x0000a410, 0x0000d0da, 0x0000d0da, 0x0000d0de, 0x0000d0de},
+	{0x0000a458, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000a500, 0x00002220, 0x00002220, 0x00000000, 0x00000000},
+	{0x0000a504, 0x06002223, 0x06002223, 0x04000002, 0x04000002},
+	{0x0000a508, 0x0a022220, 0x0a022220, 0x08000004, 0x08000004},
+	{0x0000a50c, 0x0f022223, 0x0f022223, 0x0b000200, 0x0b000200},
+	{0x0000a510, 0x14022620, 0x14022620, 0x0f000202, 0x0f000202},
+	{0x0000a514, 0x18022622, 0x18022622, 0x12000400, 0x12000400},
+	{0x0000a518, 0x1b022822, 0x1b022822, 0x16000402, 0x16000402},
+	{0x0000a51c, 0x20022842, 0x20022842, 0x19000404, 0x19000404},
+	{0x0000a520, 0x22022c41, 0x22022c41, 0x1c000603, 0x1c000603},
+	{0x0000a524, 0x28023042, 0x28023042, 0x21000a02, 0x21000a02},
+	{0x0000a528, 0x2c023044, 0x2c023044, 0x25000a04, 0x25000a04},
+	{0x0000a52c, 0x2f023644, 0x2f023644, 0x28000a20, 0x28000a20},
+	{0x0000a530, 0x34025643, 0x34025643, 0x2c000e20, 0x2c000e20},
+	{0x0000a534, 0x38025a44, 0x38025a44, 0x30000e22, 0x30000e22},
+	{0x0000a538, 0x3b025e45, 0x3b025e45, 0x34000e24, 0x34000e24},
+	{0x0000a53c, 0x41025e4a, 0x41025e4a, 0x38001640, 0x38001640},
+	{0x0000a540, 0x48025e6c, 0x48025e6c, 0x3c001660, 0x3c001660},
+	{0x0000a544, 0x4e025e8e, 0x4e025e8e, 0x3f001861, 0x3f001861},
+	{0x0000a548, 0x55025eb3, 0x55025eb3, 0x43001a81, 0x43001a81},
+	{0x0000a54c, 0x58025ef3, 0x58025ef3, 0x47001a83, 0x47001a83},
+	{0x0000a550, 0x5d025ef6, 0x5d025ef6, 0x4a001c84, 0x4a001c84},
+	{0x0000a554, 0x62025f56, 0x62025f56, 0x4e001ce3, 0x4e001ce3},
+	{0x0000a558, 0x66027f56, 0x66027f56, 0x52001ce5, 0x52001ce5},
+	{0x0000a55c, 0x6a029f56, 0x6a029f56, 0x56001ce9, 0x56001ce9},
+	{0x0000a560, 0x70049f56, 0x70049f56, 0x5a001ceb, 0x5a001ceb},
+	{0x0000a564, 0x751ffff6, 0x751ffff6, 0x5c001eec, 0x5c001eec},
+	{0x0000a568, 0x751ffff6, 0x751ffff6, 0x5e001ef0, 0x5e001ef0},
+	{0x0000a56c, 0x751ffff6, 0x751ffff6, 0x60001ef4, 0x60001ef4},
+	{0x0000a570, 0x751ffff6, 0x751ffff6, 0x62001ff6, 0x62001ff6},
+	{0x0000a574, 0x751ffff6, 0x751ffff6, 0x62001ff6, 0x62001ff6},
+	{0x0000a578, 0x751ffff6, 0x751ffff6, 0x62001ff6, 0x62001ff6},
+	{0x0000a57c, 0x751ffff6, 0x751ffff6, 0x62001ff6, 0x62001ff6},
+	{0x0000a600, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000a604, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000a608, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000a60c, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000a610, 0x00804000, 0x00804000, 0x00000000, 0x00000000},
+	{0x0000a614, 0x00804201, 0x00804201, 0x01404000, 0x01404000},
+	{0x0000a618, 0x0280c802, 0x0280c802, 0x01404501, 0x01404501},
+	{0x0000a61c, 0x0280ca03, 0x0280ca03, 0x02008501, 0x02008501},
+	{0x0000a620, 0x04c15104, 0x04c15104, 0x0280ca03, 0x0280ca03},
+	{0x0000a624, 0x04c15305, 0x04c15305, 0x03010c04, 0x03010c04},
+	{0x0000a628, 0x04c15305, 0x04c15305, 0x04014c04, 0x04014c04},
+	{0x0000a62c, 0x04c15305, 0x04c15305, 0x04015005, 0x04015005},
+	{0x0000a630, 0x04c15305, 0x04c15305, 0x04015005, 0x04015005},
+	{0x0000a634, 0x04c15305, 0x04c15305, 0x04015005, 0x04015005},
+	{0x0000a638, 0x04c15305, 0x04c15305, 0x04015005, 0x04015005},
+	{0x0000a63c, 0x04c15305, 0x04c15305, 0x04015005, 0x04015005},
+	{0x0000b2dc, 0x01feee00, 0x01feee00, 0x03aaa352, 0x03aaa352},
+	{0x0000b2e0, 0x0000f000, 0x0000f000, 0x03ccc584, 0x03ccc584},
+	{0x0000b2e4, 0x01ff0000, 0x01ff0000, 0x03f0f800, 0x03f0f800},
+	{0x0000b2e8, 0x00000000, 0x00000000, 0x03ff0000, 0x03ff0000},
+};
+
 static const u32 ar9462_modes_high_ob_db_tx_gain_table_2p0[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x000098bc, 0x00000002, 0x00000002, 0x00000002, 0x00000002},
-- 
1.8.3.1

