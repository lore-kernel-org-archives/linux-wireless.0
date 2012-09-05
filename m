Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15422 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab2IEFa7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 01:30:59 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 3/3] ath9k_hw: add 8 points for 5G temp slop
Date: Wed, 5 Sep 2012 11:02:15 +0530
Message-ID: <1346823135-2992-3-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120905_073104_883295_ADB1EEC4)
In-Reply-To: <1346823135-2992-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1346823135-2992-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 26 +++++++++++++++++++-------
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h |  3 ++-
 drivers/net/wireless/ath/ath9k/eeprom.h        |  1 +
 3 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index c37fe96..a03e905 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -138,7 +138,8 @@ static const struct ar9300_eeprom ar9300_default = {
 	 },
 	.base_ext1 = {
 		.ant_div_control = 0,
-		.future = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
+		.future = {0, 0, 0},
+		.tempslopextension = {0, 0, 0, 0, 0, 0, 0, 0}
 	},
 	.calFreqPier2G = {
 		FREQ2FBIN(2412, 1),
@@ -713,7 +714,8 @@ static const struct ar9300_eeprom ar9300_x113 = {
 	 },
 	 .base_ext1 = {
 		.ant_div_control = 0,
-		.future = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
+		.future = {0, 0, 0},
+		.tempslopextension = {0, 0, 0, 0, 0, 0, 0, 0}
 	 },
 	.calFreqPier2G = {
 		FREQ2FBIN(2412, 1),
@@ -1289,7 +1291,8 @@ static const struct ar9300_eeprom ar9300_h112 = {
 	},
 	.base_ext1 = {
 		.ant_div_control = 0,
-		.future = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
+		.future = {0, 0, 0},
+		.tempslopextension = {0, 0, 0, 0, 0, 0, 0, 0}
 	},
 	.calFreqPier2G = {
 		FREQ2FBIN(2412, 1),
@@ -1865,7 +1868,8 @@ static const struct ar9300_eeprom ar9300_x112 = {
 	},
 	.base_ext1 = {
 		.ant_div_control = 0,
-		.future = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
+		.future = {0, 0, 0},
+		.tempslopextension = {0, 0, 0, 0, 0, 0, 0, 0}
 	},
 	.calFreqPier2G = {
 		FREQ2FBIN(2412, 1),
@@ -2440,7 +2444,8 @@ static const struct ar9300_eeprom ar9300_h116 = {
 	 },
 	 .base_ext1 = {
 		.ant_div_control = 0,
-		.future = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
+		.future = {0, 0, 0},
+		.tempslopextension = {0, 0, 0, 0, 0, 0, 0, 0}
 	 },
 	.calFreqPier2G = {
 		FREQ2FBIN(2412, 1),
@@ -4528,7 +4533,7 @@ static int ar9003_hw_power_control_override(struct ath_hw *ah,
 {
 	int tempSlope = 0;
 	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
-	int f[3], t[3];
+	int f[8], t[8], i;
 
 	REG_RMW(ah, AR_PHY_TPC_11_B0,
 		(correction[0] << AR_PHY_TPC_OLPC_GAIN_DELTA_S),
@@ -4561,7 +4566,14 @@ static int ar9003_hw_power_control_override(struct ath_hw *ah,
 	 */
 	if (frequency < 4000)
 		tempSlope = eep->modalHeader2G.tempSlope;
-	else if (eep->base_ext2.tempSlopeLow != 0) {
+	else if ((eep->baseEepHeader.miscConfiguration & 0x20) != 0) {
+		for (i = 0; i < 8; i++) {
+			t[i] = eep->base_ext1.tempslopextension[i];
+			f[i] = FBIN2FREQ(eep->calFreqPier5G[i], 0);
+		}
+		tempSlope = ar9003_hw_power_interpolate((s32) frequency,
+							f, t, 8);
+	} else if (eep->base_ext2.tempSlopeLow != 0) {
 		t[0] = eep->base_ext2.tempSlopeLow;
 		f[0] = 5180;
 		t[1] = eep->modalHeader5G.tempSlope;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
index 3a1ff55..41b1a75 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
@@ -267,7 +267,8 @@ struct cal_ctl_data_5g {
 
 struct ar9300_BaseExtension_1 {
 	u8 ant_div_control;
-	u8 future[11];
+	u8 future[3];
+	u8 tempslopextension[8];
 	int8_t quick_drop_low;
 	int8_t quick_drop_high;
 } __packed;
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 484b313..4249096 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -96,6 +96,7 @@
 
 #define ATH9K_POW_SM(_r, _s)	(((_r) & 0x3f) << (_s))
 #define FREQ2FBIN(x, y)		((y) ? ((x) - 2300) : (((x) - 4800) / 5))
+#define FBIN2FREQ(x, y)		((y) ? (2300 + x) : (4800 + 5 * x))
 #define ath9k_hw_use_flash(_ah)	(!(_ah->ah_flags & AH_USE_EEPROM))
 
 #define AR5416_VER_MASK (eep->baseEepHeader.version & AR5416_EEP_VER_MINOR_MASK)
-- 
1.7.12

