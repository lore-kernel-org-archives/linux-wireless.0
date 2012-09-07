Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21836 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab2IGGpQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 02:45:16 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 2/2] ath9k_hw: Read and configure thermocal for AR9462
Date: Fri, 7 Sep 2012 12:15:16 +0530
Message-ID: <1347000316-4466-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120907_084525_578930_AE834F60)
In-Reply-To: <1347000316-4466-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1347000316-4466-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Read and configure thermometer calibration results read from
OTP card.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 19 +++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.h    |  6 ++++++
 2 files changed, 25 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 0e46330..d44ed24 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -4020,6 +4020,24 @@ static void ar9003_hw_thermometer_apply(struct ath_hw *ah)
 	}
 }
 
+static void ar9003_hw_thermo_cal_apply(struct ath_hw *ah)
+{
+	u32 data, ko, kg;
+
+	if (!AR_SREV_9462_20(ah))
+		return;
+	ar9300_otp_read_word(ah, 1, &data);
+	ko = data & 0xff;
+	kg = (data >> 8) & 0xff;
+	if (ko || kg) {
+		REG_RMW_FIELD(ah, AR_PHY_BB_THERM_ADC_3,
+			      AR_PHY_BB_THERM_ADC_3_THERM_ADC_OFFSET, ko);
+		REG_RMW_FIELD(ah, AR_PHY_BB_THERM_ADC_3,
+			      AR_PHY_BB_THERM_ADC_3_THERM_ADC_SCALE_GAIN,
+			      kg + 256);
+	}
+}
+
 static void ath9k_hw_ar9300_set_board_values(struct ath_hw *ah,
 					     struct ath9k_channel *chan)
 {
@@ -4036,6 +4054,7 @@ static void ath9k_hw_ar9300_set_board_values(struct ath_hw *ah,
 	ar9003_hw_apply_tuning_caps(ah);
 	ar9003_hw_txend_to_xpa_off_apply(ah, is2ghz);
 	ar9003_hw_thermometer_apply(ah);
+	ar9003_hw_thermo_cal_apply(ah);
 }
 
 static void ath9k_hw_ar9300_set_addac(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 25d8181..e8bfb41 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -609,6 +609,12 @@
 #define AR_PHY_BB_THERM_ADC_1_INIT_THERM		0x000000ff
 #define AR_PHY_BB_THERM_ADC_1_INIT_THERM_S		0
 
+#define AR_PHY_BB_THERM_ADC_3				(AR_SM_BASE + 0x250)
+#define AR_PHY_BB_THERM_ADC_3_THERM_ADC_SCALE_GAIN	0x0001ff00
+#define AR_PHY_BB_THERM_ADC_3_THERM_ADC_SCALE_GAIN_S	8
+#define AR_PHY_BB_THERM_ADC_3_THERM_ADC_OFFSET		0x000000ff
+#define AR_PHY_BB_THERM_ADC_3_THERM_ADC_OFFSET_S	0
+
 #define AR_PHY_BB_THERM_ADC_4				(AR_SM_BASE + 0x254)
 #define AR_PHY_BB_THERM_ADC_4_LATEST_THERM_VALUE	0x000000ff
 #define AR_PHY_BB_THERM_ADC_4_LATEST_THERM_VALUE_S	0
-- 
1.7.12

