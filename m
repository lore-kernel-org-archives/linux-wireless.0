Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:26475 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754283Ab0KJND2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 08:03:28 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 05:03:16 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 02/11] ath9k_hw: Add new member into the eeprom structure.
Date: Wed, 10 Nov 2010 05:03:07 -0800
Message-ID: <1289394196-3465-2-git-send-email-vasanth@atheros.com>
In-Reply-To: <1289394196-3465-1-git-send-email-vasanth@atheros.com>
References: <1289394196-3465-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Senthil Balasubramanian <senthilkumar@atheros.com>

Add eeprom base extension structures which are needed for
AR938x caliberation changes and gain calculation.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   21 +++++++++++++++------
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h |   18 +++++++++++++++++-
 2 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index a88fe0d..bc3f49c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -147,10 +147,13 @@ static const struct ar9300_eeprom ar9300_default = {
 		.papdRateMaskHt20 = LE32(0x80c080),
 		.papdRateMaskHt40 = LE32(0x80c080),
 		.futureModal = {
-			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
-			0, 0, 0, 0, 0, 0, 0, 0
+			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 		},
 	 },
+	.base_ext1 = {
+		.ant_div_control = 0,
+		.future = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
+	},
 	.calFreqPier2G = {
 		FREQ2FBIN(2412, 1),
 		FREQ2FBIN(2437, 1),
@@ -285,8 +288,7 @@ static const struct ar9300_eeprom ar9300_default = {
 			/* Data[11].ctlEdges[0].bChannel */ FREQ2FBIN(2422, 1),
 			/* Data[11].ctlEdges[1].bChannel */ FREQ2FBIN(2427, 1),
 			/* Data[11].ctlEdges[2].bChannel */ FREQ2FBIN(2447, 1),
-			/* Data[11].ctlEdges[3].bChannel */
-			FREQ2FBIN(2462, 1),
+			/* Data[11].ctlEdges[3].bChannel */ FREQ2FBIN(2462, 1),
 		}
 	 },
 	.ctlPowerData_2G = {
@@ -346,10 +348,17 @@ static const struct ar9300_eeprom ar9300_default = {
 		.papdRateMaskHt20 = LE32(0xf0e0e0),
 		.papdRateMaskHt40 = LE32(0xf0e0e0),
 		.futureModal = {
-			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
-			0, 0, 0, 0, 0, 0, 0, 0
+			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 		},
 	 },
+	.base_ext2 = {
+		.tempSlopeLow = 0,
+		.tempSlopeHigh = 0,
+		.xatten1DBLow = {0, 0, 0},
+		.xatten1MarginLow = {0, 0, 0},
+		.xatten1DBHigh = {0, 0, 0},
+		.xatten1MarginHigh = {0, 0, 0}
+	},
 	.calFreqPier5G = {
 		FREQ2FBIN(5180, 0),
 		FREQ2FBIN(5220, 0),
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
index 3c533bb..5301df3 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
@@ -236,7 +236,7 @@ struct ar9300_modal_eep_header {
 	u8 thresh62;
 	__le32 papdRateMaskHt20;
 	__le32 papdRateMaskHt40;
-	u8 futureModal[24];
+	u8 futureModal[10];
 } __packed;
 
 struct ar9300_cal_data_per_freq_op_loop {
@@ -274,6 +274,20 @@ struct cal_ctl_data_5g {
 	struct cal_ctl_edge_pwr ctlEdges[AR9300_NUM_BAND_EDGES_5G];
 } __packed;
 
+struct ar9300_BaseExtension_1 {
+	u8 ant_div_control;
+	u8 future[13];
+} __packed;
+
+struct ar9300_BaseExtension_2 {
+	int8_t    tempSlopeLow;
+	int8_t    tempSlopeHigh;
+	u8   xatten1DBLow[AR9300_MAX_CHAINS];
+	u8   xatten1MarginLow[AR9300_MAX_CHAINS];
+	u8   xatten1DBHigh[AR9300_MAX_CHAINS];
+	u8   xatten1MarginHigh[AR9300_MAX_CHAINS];
+} __packed;
+
 struct ar9300_eeprom {
 	u8 eepromVersion;
 	u8 templateVersion;
@@ -283,6 +297,7 @@ struct ar9300_eeprom {
 	struct ar9300_base_eep_hdr baseEepHeader;
 
 	struct ar9300_modal_eep_header modalHeader2G;
+	struct ar9300_BaseExtension_1 base_ext1;
 	u8 calFreqPier2G[AR9300_NUM_2G_CAL_PIERS];
 	struct ar9300_cal_data_per_freq_op_loop
 	 calPierData2G[AR9300_MAX_CHAINS][AR9300_NUM_2G_CAL_PIERS];
@@ -302,6 +317,7 @@ struct ar9300_eeprom {
 	u8 ctl_freqbin_2G[AR9300_NUM_CTLS_2G][AR9300_NUM_BAND_EDGES_2G];
 	struct cal_ctl_data_2g ctlPowerData_2G[AR9300_NUM_CTLS_2G];
 	struct ar9300_modal_eep_header modalHeader5G;
+	struct ar9300_BaseExtension_2 base_ext2;
 	u8 calFreqPier5G[AR9300_NUM_5G_CAL_PIERS];
 	struct ar9300_cal_data_per_freq_op_loop
 	 calPierData5G[AR9300_MAX_CHAINS][AR9300_NUM_5G_CAL_PIERS];
-- 
1.7.0.4

