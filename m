Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:60285 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875Ab0IVKfI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 06:35:08 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 3/3] ath9k_hw: simplify revision checks for AR9287
Date: Wed, 22 Sep 2010 12:34:54 +0200
Message-Id: <1285151694-39227-3-git-send-email-nbd@openwrt.org>
In-Reply-To: <1285151694-39227-2-git-send-email-nbd@openwrt.org>
References: <1285151694-39227-1-git-send-email-nbd@openwrt.org>
 <1285151694-39227-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since AR9287 v1.0 was never sold (and the initvals removed), its revision
checks can be simplified similar to AR9280

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c   |    6 +++---
 drivers/net/wireless/ath/ath9k/ar9002_calib.c |    4 ++--
 drivers/net/wireless/ath/ath9k/eeprom.h       |    2 +-
 drivers/net/wireless/ath/ath9k/hw.c           |    4 ++--
 drivers/net/wireless/ath/ath9k/reg.h          |    9 +--------
 5 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 79dfe9d..525671f 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -669,7 +669,7 @@ static void ar5008_hw_override_ini(struct ath_hw *ah,
 		if (!AR_SREV_9271(ah))
 			val &= ~AR_PCU_MISC_MODE2_HWWAR1;
 
-		if (AR_SREV_9287_10_OR_LATER(ah))
+		if (AR_SREV_9287_11_OR_LATER(ah))
 			val = val & (~AR_PCU_MISC_MODE2_HWWAR2);
 
 		REG_WRITE(ah, AR_PCU_MISC_MODE2, val);
@@ -820,11 +820,11 @@ static int ar5008_hw_process_ini(struct ath_hw *ah,
 	REGWRITE_BUFFER_FLUSH(ah);
 	DISABLE_REGWRITE_BUFFER(ah);
 
-	if (AR_SREV_9280(ah) || AR_SREV_9287_10_OR_LATER(ah))
+	if (AR_SREV_9280(ah) || AR_SREV_9287_11_OR_LATER(ah))
 		REG_WRITE_ARRAY(&ah->iniModesRxGain, modesIndex, regWrites);
 
 	if (AR_SREV_9280(ah) || AR_SREV_9285_12_OR_LATER(ah) ||
-	    AR_SREV_9287_10_OR_LATER(ah))
+	    AR_SREV_9287_11_OR_LATER(ah))
 		REG_WRITE_ARRAY(&ah->iniModesTxGain, modesIndex, regWrites);
 
 	if (AR_SREV_9271_10(ah))
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
index 5d08151..d7d1d55 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -833,7 +833,7 @@ static bool ar9002_hw_init_cal(struct ath_hw *ah, struct ath9k_channel *chan)
 			return false;
 	} else {
 		if (AR_SREV_9280_20_OR_LATER(ah)) {
-			if (!AR_SREV_9287_10_OR_LATER(ah))
+			if (!AR_SREV_9287_11_OR_LATER(ah))
 				REG_CLR_BIT(ah, AR_PHY_ADC_CTL,
 					    AR_PHY_ADC_CTL_OFF_PWDADC);
 			REG_SET_BIT(ah, AR_PHY_AGC_CONTROL,
@@ -856,7 +856,7 @@ static bool ar9002_hw_init_cal(struct ath_hw *ah, struct ath9k_channel *chan)
 		}
 
 		if (AR_SREV_9280_20_OR_LATER(ah)) {
-			if (!AR_SREV_9287_10_OR_LATER(ah))
+			if (!AR_SREV_9287_11_OR_LATER(ah))
 				REG_SET_BIT(ah, AR_PHY_ADC_CTL,
 					    AR_PHY_ADC_CTL_OFF_PWDADC);
 			REG_CLR_BIT(ah, AR_PHY_AGC_CONTROL,
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index e583421..55f2147 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -101,7 +101,7 @@
 #define AR5416_VER_MASK (eep->baseEepHeader.version & AR5416_EEP_VER_MINOR_MASK)
 #define OLC_FOR_AR9280_20_LATER (AR_SREV_9280_20_OR_LATER(ah) && \
 				 ah->eep_ops->get_eeprom(ah, EEP_OL_PWRCTRL))
-#define OLC_FOR_AR9287_10_LATER (AR_SREV_9287_10_OR_LATER(ah) && \
+#define OLC_FOR_AR9287_10_LATER (AR_SREV_9287_11_OR_LATER(ah) && \
 				 ah->eep_ops->get_eeprom(ah, EEP_OL_PWRCTRL))
 
 #define AR_EEPROM_RFSILENT_GPIO_SEL     0x001c
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 1f41b45..25ed65a 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1989,7 +1989,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	if (AR_SREV_9300_20_OR_LATER(ah))
 		pCap->hw_caps |= ATH9K_HW_CAP_RAC_SUPPORTED;
 
-	if (AR_SREV_9287_10_OR_LATER(ah) || AR_SREV_9271(ah))
+	if (AR_SREV_9287_11_OR_LATER(ah) || AR_SREV_9271(ah))
 		pCap->hw_caps |= ATH9K_HW_CAP_SGI_20;
 
 	if (AR_SREV_9285(ah))
@@ -2073,7 +2073,7 @@ u32 ath9k_hw_gpio_get(struct ath_hw *ah, u32 gpio)
 		return MS_REG_READ(AR9300, gpio) != 0;
 	else if (AR_SREV_9271(ah))
 		return MS_REG_READ(AR9271, gpio) != 0;
-	else if (AR_SREV_9287_10_OR_LATER(ah))
+	else if (AR_SREV_9287_11_OR_LATER(ah))
 		return MS_REG_READ(AR9287, gpio) != 0;
 	else if (AR_SREV_9285_12_OR_LATER(ah))
 		return MS_REG_READ(AR9285, gpio) != 0;
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 7ff814d..6d01e50 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -831,18 +831,11 @@
 
 #define AR_SREV_9287(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9287))
-#define AR_SREV_9287_10_OR_LATER(_ah) \
+#define AR_SREV_9287_11_OR_LATER(_ah) \
 	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9287))
-#define AR_SREV_9287_10(_ah) \
-	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9287) && \
-	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9287_10))
 #define AR_SREV_9287_11(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9287) && \
 	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9287_11))
-#define AR_SREV_9287_11_OR_LATER(_ah) \
-	(((_ah)->hw_version.macVersion > AR_SREV_VERSION_9287) || \
-	 (((_ah)->hw_version.macVersion == AR_SREV_VERSION_9287) && \
-	  ((_ah)->hw_version.macRev >= AR_SREV_REVISION_9287_11)))
 #define AR_SREV_9287_12(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9287) && \
 	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9287_12))
-- 
1.7.2.2

