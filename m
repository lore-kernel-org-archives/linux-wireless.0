Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:33613 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab3LQJWs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 04:22:48 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/4] ath9k: Update BaseExtension_1 eeprom structure
Date: Tue, 17 Dec 2013 14:47:48 +0530
Message-Id: <1387271869-12780-3-git-send-email-sujith@msujith.org> (sfid-20131217_102317_947709_3C02761A)
In-Reply-To: <1387271869-12780-1-git-send-email-sujith@msujith.org>
References: <1387271869-12780-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

* Add a new field "misc_enable"
* Use int_8 for tempslopextension.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 10 +++++-----
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h | 14 ++++++++++++--
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 86baa20..d9e09bf 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -139,7 +139,7 @@ static const struct ar9300_eeprom ar9300_default = {
 	 },
 	.base_ext1 = {
 		.ant_div_control = 0,
-		.future = {0, 0, 0},
+		.future = {0, 0},
 		.tempslopextension = {0, 0, 0, 0, 0, 0, 0, 0}
 	},
 	.calFreqPier2G = {
@@ -717,7 +717,7 @@ static const struct ar9300_eeprom ar9300_x113 = {
 	 },
 	 .base_ext1 = {
 		.ant_div_control = 0,
-		.future = {0, 0, 0},
+		.future = {0, 0},
 		.tempslopextension = {0, 0, 0, 0, 0, 0, 0, 0}
 	 },
 	.calFreqPier2G = {
@@ -1296,7 +1296,7 @@ static const struct ar9300_eeprom ar9300_h112 = {
 	},
 	.base_ext1 = {
 		.ant_div_control = 0,
-		.future = {0, 0, 0},
+		.future = {0, 0},
 		.tempslopextension = {0, 0, 0, 0, 0, 0, 0, 0}
 	},
 	.calFreqPier2G = {
@@ -1875,7 +1875,7 @@ static const struct ar9300_eeprom ar9300_x112 = {
 	},
 	.base_ext1 = {
 		.ant_div_control = 0,
-		.future = {0, 0, 0},
+		.future = {0, 0},
 		.tempslopextension = {0, 0, 0, 0, 0, 0, 0, 0}
 	},
 	.calFreqPier2G = {
@@ -2453,7 +2453,7 @@ static const struct ar9300_eeprom ar9300_h116 = {
 	 },
 	 .base_ext1 = {
 		.ant_div_control = 0,
-		.future = {0, 0, 0},
+		.future = {0, 0},
 		.tempslopextension = {0, 0, 0, 0, 0, 0, 0, 0}
 	 },
 	.calFreqPier2G = {
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
index 0e5daa5..694ca2e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
@@ -270,10 +270,20 @@ struct cal_ctl_data_5g {
 	u8 ctlEdges[AR9300_NUM_BAND_EDGES_5G];
 } __packed;
 
+#define MAX_BASE_EXTENSION_FUTURE 2
+
 struct ar9300_BaseExtension_1 {
 	u8 ant_div_control;
-	u8 future[3];
-	u8 tempslopextension[8];
+	u8 future[MAX_BASE_EXTENSION_FUTURE];
+	/*
+	 * misc_enable:
+	 *
+	 * BIT 0   - TX Gain Cap enable.
+	 * BIT 1   - Uncompressed Checksum enable.
+	 * BIT 2/3 - MinCCApwr enable 2g/5g.
+	 */
+	u8 misc_enable;
+	int8_t tempslopextension[8];
 	int8_t quick_drop_low;
 	int8_t quick_drop_high;
 } __packed;
-- 
1.8.5.1

