Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:59253 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757455Ab0LBLOe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 06:14:34 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 03:14:20 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V2 19/27] ath9k_hw: Read and configure turnning caps to regulate freq accuracy
Date: Thu, 2 Dec 2010 03:07:03 -0800
Message-ID: <1291288031-3409-20-git-send-email-vasanth@atheros.com>
In-Reply-To: <1291288031-3409-1-git-send-email-vasanth@atheros.com>
References: <1291288031-3409-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Right now it is done for only AR9485, will be done for ar9003 also
after proper testing.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   16 ++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.h    |    6 ++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index e7ba662..82c628a 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3736,6 +3736,20 @@ static void ar9003_hw_internal_regulator_apply(struct ath_hw *ah)
 
 }
 
+static void ar9003_hw_apply_tuning_caps(struct ath_hw *ah)
+{
+	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
+	u8 tuning_caps_param = eep->baseEepHeader.params_for_tuning_caps[0];
+
+	if (eep->baseEepHeader.featureEnable & 0x40) {
+		tuning_caps_param &= 0x7f;
+		REG_RMW_FIELD(ah, AR_CH0_XTAL, AR_CH0_XTAL_CAPINDAC,
+			      tuning_caps_param);
+		REG_RMW_FIELD(ah, AR_CH0_XTAL, AR_CH0_XTAL_CAPOUTDAC,
+			      tuning_caps_param);
+	}
+}
+
 static void ath9k_hw_ar9300_set_board_values(struct ath_hw *ah,
 					     struct ath9k_channel *chan)
 {
@@ -3744,6 +3758,8 @@ static void ath9k_hw_ar9300_set_board_values(struct ath_hw *ah,
 	ar9003_hw_drive_strength_apply(ah);
 	ar9003_hw_atten_apply(ah, chan);
 	ar9003_hw_internal_regulator_apply(ah);
+	if (AR_SREV_9485(ah))
+		ar9003_hw_apply_tuning_caps(ah);
 }
 
 static void ath9k_hw_ar9300_set_addac(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 8de3ffd..4c64eb1 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -598,6 +598,12 @@
 #define AR_CH0_TOP2_XPABIASLVL		0xf000
 #define AR_CH0_TOP2_XPABIASLVL_S	12
 
+#define AR_CH0_XTAL		(AR_SREV_9485(ah) ? 0x16290 : 0x16294)
+#define AR_CH0_XTAL_CAPINDAC	0x7f000000
+#define AR_CH0_XTAL_CAPINDAC_S	24
+#define AR_CH0_XTAL_CAPOUTDAC	0x00fe0000
+#define AR_CH0_XTAL_CAPOUTDAC_S	17
+
 #define AR_PHY_PMU1		0x16c40
 #define AR_PHY_PMU1_PWD		0x1
 #define AR_PHY_PMU1_PWD_S	0
-- 
1.7.0.4

