Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47198 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756814Ab2IGGpW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 02:45:22 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 1/2] ath9k_hw: Read and apply thermometer settings from EEPROM
Date: Fri, 7 Sep 2012 12:15:15 +0530
Message-ID: <1347000316-4466-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120907_084529_968938_97BA322A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 39 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.h    |  2 ++
 2 files changed, 41 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index a03e905..0e46330 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3982,6 +3982,44 @@ static void ar9003_hw_xlna_bias_strength_apply(struct ath_hw *ah, bool is2ghz)
 		      bias & 0x3);
 }
 
+static int ar9003_hw_get_thermometer(struct ath_hw *ah)
+{
+	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
+	struct ar9300_base_eep_hdr *pBase = &eep->baseEepHeader;
+	int thermometer =  (pBase->miscConfiguration >> 1) & 0x3;
+
+	return --thermometer;
+}
+
+static void ar9003_hw_thermometer_apply(struct ath_hw *ah)
+{
+	int thermometer = ar9003_hw_get_thermometer(ah);
+	u8 therm_on = (thermometer < 0) ? 0 : 1;
+
+	REG_RMW_FIELD(ah, AR_PHY_65NM_CH0_RXTX4,
+		      AR_PHY_65NM_CH0_RXTX4_THERM_ON_OVR, therm_on);
+	if (ah->caps.tx_chainmask & BIT(1))
+		REG_RMW_FIELD(ah, AR_PHY_65NM_CH1_RXTX4,
+			      AR_PHY_65NM_CH0_RXTX4_THERM_ON_OVR, therm_on);
+	if (ah->caps.tx_chainmask & BIT(2))
+		REG_RMW_FIELD(ah, AR_PHY_65NM_CH2_RXTX4,
+			      AR_PHY_65NM_CH0_RXTX4_THERM_ON_OVR, therm_on);
+
+	therm_on = (thermometer < 0) ? 0 : (thermometer == 0);
+	REG_RMW_FIELD(ah, AR_PHY_65NM_CH0_RXTX4,
+		      AR_PHY_65NM_CH0_RXTX4_THERM_ON, therm_on);
+	if (ah->caps.tx_chainmask & BIT(1)) {
+		therm_on = (thermometer < 0) ? 0 : (thermometer == 1);
+		REG_RMW_FIELD(ah, AR_PHY_65NM_CH1_RXTX4,
+			      AR_PHY_65NM_CH0_RXTX4_THERM_ON, therm_on);
+	}
+	if (ah->caps.tx_chainmask & BIT(2)) {
+		therm_on = (thermometer < 0) ? 0 : (thermometer == 2);
+		REG_RMW_FIELD(ah, AR_PHY_65NM_CH2_RXTX4,
+			      AR_PHY_65NM_CH0_RXTX4_THERM_ON, therm_on);
+	}
+}
+
 static void ath9k_hw_ar9300_set_board_values(struct ath_hw *ah,
 					     struct ath9k_channel *chan)
 {
@@ -3997,6 +4035,7 @@ static void ath9k_hw_ar9300_set_board_values(struct ath_hw *ah,
 		ar9003_hw_internal_regulator_apply(ah);
 	ar9003_hw_apply_tuning_caps(ah);
 	ar9003_hw_txend_to_xpa_off_apply(ah, is2ghz);
+	ar9003_hw_thermometer_apply(ah);
 }
 
 static void ath9k_hw_ar9300_set_addac(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 84d3d49..25d8181 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -881,6 +881,8 @@
 
 #define AR_PHY_65NM_CH0_RXTX4_THERM_ON          0x10000000
 #define AR_PHY_65NM_CH0_RXTX4_THERM_ON_S        28
+#define AR_PHY_65NM_CH0_RXTX4_THERM_ON_OVR      0x20000000
+#define AR_PHY_65NM_CH0_RXTX4_THERM_ON_OVR_S    29
 
 #define AR_PHY_65NM_RXTX4_XLNA_BIAS		0xC0000000
 #define AR_PHY_65NM_RXTX4_XLNA_BIAS_S		30
-- 
1.7.12

