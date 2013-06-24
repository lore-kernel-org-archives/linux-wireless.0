Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:48238 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab3FXMvz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 08:51:55 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 4/4] ath9k: Add support for AR9462 2.1
Date: Mon, 24 Jun 2013 18:18:46 +0530
Message-Id: <1372078126-13602-4-git-send-email-sujith@msujith.org> (sfid-20130624_145159_443502_CACCDE22)
In-Reply-To: <1372078126-13602-1-git-send-email-sujith@msujith.org>
References: <1372078126-13602-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Various parts of the HW code are applicable for
both v2.0 and v2.1.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 7 ++++---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c    | 6 +++---
 drivers/net/wireless/ath/ath9k/ar9003_phy.h    | 4 ++--
 drivers/net/wireless/ath/ath9k/hw.c            | 2 +-
 4 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 1e86977..d105e43 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3606,7 +3606,7 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
 	 *   7:4 R/W  SWITCH_TABLE_COM_SPDT_WLAN_IDLE
 	 * SWITCH_TABLE_COM_SPDT_WLAN_IDLE
 	 */
-	if (AR_SREV_9462_20(ah) || AR_SREV_9565(ah)) {
+	if (AR_SREV_9462_20_OR_LATER(ah) || AR_SREV_9565(ah)) {
 		value = ar9003_switch_com_spdt_get(ah, is2ghz);
 		REG_RMW_FIELD(ah, AR_PHY_GLB_CONTROL,
 				AR_SWITCH_TABLE_COM_SPDT_ALL, value);
@@ -4059,8 +4059,9 @@ static void ar9003_hw_thermo_cal_apply(struct ath_hw *ah)
 {
 	u32 data, ko, kg;
 
-	if (!AR_SREV_9462_20(ah))
+	if (!AR_SREV_9462_20_OR_LATER(ah))
 		return;
+
 	ar9300_otp_read_word(ah, 1, &data);
 	ko = data & 0xff;
 	kg = (data >> 8) & 0xff;
@@ -4752,7 +4753,7 @@ tempslope:
 			      AR_PHY_TPC_19_ALPHA_THERM, temp_slope);
 	}
 
-	if (AR_SREV_9462_20(ah))
+	if (AR_SREV_9462_20_OR_LATER(ah))
 		REG_RMW_FIELD(ah, AR_PHY_TPC_19_B1,
 			      AR_PHY_TPC_19_B1_ALPHA_THERM, temp_slope);
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index df84d20..1f694ab 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -743,7 +743,7 @@ static int ar9003_hw_process_ini(struct ath_hw *ah,
 		ar9003_hw_prog_ini(ah, &ah->iniMac[i], modesIndex);
 		ar9003_hw_prog_ini(ah, &ah->iniBB[i], modesIndex);
 		ar9003_hw_prog_ini(ah, &ah->iniRadio[i], modesIndex);
-		if (i == ATH_INI_POST && AR_SREV_9462_20(ah))
+		if (i == ATH_INI_POST && AR_SREV_9462_20_OR_LATER(ah))
 			ar9003_hw_prog_ini(ah,
 					   &ah->ini_radio_post_sys2ant,
 					   modesIndex);
@@ -754,7 +754,7 @@ static int ar9003_hw_process_ini(struct ath_hw *ah,
 	 */
 	REG_WRITE_ARRAY(&ah->iniModesRxGain, 1, regWrites);
 
-	if (AR_SREV_9462_20(ah)) {
+	if (AR_SREV_9462_20_OR_LATER(ah)) {
 		/*
 		 * CUS217 mix LNA mode.
 		 */
@@ -1512,7 +1512,7 @@ static int ar9003_hw_fast_chan_change(struct ath_hw *ah,
 	ar9003_hw_prog_ini(ah, &ah->iniBB[ATH_INI_POST], modesIndex);
 	ar9003_hw_prog_ini(ah, &ah->iniRadio[ATH_INI_POST], modesIndex);
 
-	if (AR_SREV_9462_20(ah))
+	if (AR_SREV_9462_20_OR_LATER(ah))
 		ar9003_hw_prog_ini(ah, &ah->ini_radio_post_sys2ant,
 				   modesIndex);
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 5013c73..d4d39f3 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -954,7 +954,7 @@
 #define AR_PHY_TPC_5_B1         (AR_SM1_BASE + 0x208)
 #define AR_PHY_TPC_6_B1         (AR_SM1_BASE + 0x20c)
 #define AR_PHY_TPC_11_B1        (AR_SM1_BASE + 0x220)
-#define AR_PHY_PDADC_TAB_1	(AR_SM1_BASE + (AR_SREV_AR9462(ah) ? \
+#define AR_PHY_PDADC_TAB_1	(AR_SM1_BASE + (AR_SREV_9462_20_OR_LATER(ah) ? \
 					0x280 : 0x240))
 #define AR_PHY_TPC_19_B1	(AR_SM1_BASE + 0x240)
 #define AR_PHY_TPC_19_B1_ALPHA_THERM		0xff
@@ -1048,7 +1048,7 @@
 #define AR_GLB_GPIO_CONTROL	(AR_GLB_BASE)
 #define AR_PHY_GLB_CONTROL	(AR_GLB_BASE + 0x44)
 #define AR_GLB_SCRATCH(_ah)	(AR_GLB_BASE + \
-					(AR_SREV_9462_20(_ah) ? 0x4c : 0x50))
+					(AR_SREV_9462_20_OR_LATER(_ah) ? 0x4c : 0x50))
 #define AR_GLB_STATUS		(AR_GLB_BASE + 0x48)
 
 /*
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 5324c33..4ca0cb0 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2599,7 +2599,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		if (!(ah->ent_mode & AR_ENT_OTP_49GHZ_DISABLE))
 			pCap->hw_caps |= ATH9K_HW_CAP_MCI;
 
-		if (AR_SREV_9462_20(ah))
+		if (AR_SREV_9462_20_OR_LATER(ah))
 			pCap->hw_caps |= ATH9K_HW_CAP_RTT;
 	}
 
-- 
1.8.3.1

