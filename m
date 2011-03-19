Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52443 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465Ab1CSMzt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Mar 2011 08:55:49 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 4/7] ath9k: add support for overriding LED pin and GPIO settings from platform data
Date: Sat, 19 Mar 2011 13:55:40 +0100
Message-Id: <1300539343-75509-4-git-send-email-nbd@openwrt.org>
In-Reply-To: <1300539343-75509-3-git-send-email-nbd@openwrt.org>
References: <1300539343-75509-1-git-send-email-nbd@openwrt.org>
 <1300539343-75509-2-git-send-email-nbd@openwrt.org>
 <1300539343-75509-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/gpio.c |   14 ++++++++------
 drivers/net/wireless/ath/ath9k/hw.h   |    2 +-
 drivers/net/wireless/ath/ath9k/init.c |    8 +++++++-
 include/linux/ath9k_platform.h        |    4 ++++
 4 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 0fb8f8a..44a0a88 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -41,12 +41,14 @@ void ath_init_leds(struct ath_softc *sc)
 {
 	int ret;
 
-	if (AR_SREV_9287(sc->sc_ah))
-		sc->sc_ah->led_pin = ATH_LED_PIN_9287;
-	else if (AR_SREV_9485(sc->sc_ah))
-		sc->sc_ah->led_pin = ATH_LED_PIN_9485;
-	else
-		sc->sc_ah->led_pin = ATH_LED_PIN_DEF;
+	if (sc->sc_ah->led_pin < 0) {
+		if (AR_SREV_9287(sc->sc_ah))
+			sc->sc_ah->led_pin = ATH_LED_PIN_9287;
+		else if (AR_SREV_9485(sc->sc_ah))
+			sc->sc_ah->led_pin = ATH_LED_PIN_9485;
+		else
+			sc->sc_ah->led_pin = ATH_LED_PIN_DEF;
+	}
 
 	/* Configure gpio 1 for output */
 	ath9k_hw_cfg_output(sc->sc_ah, sc->sc_ah->led_pin,
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 91010e3..cd314d6 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -794,7 +794,7 @@ struct ath_hw {
 	u32 originalGain[22];
 	int initPDADC;
 	int PDADCdelta;
-	u8 led_pin;
+	int led_pin;
 	u32 gpio_mask;
 	u32 gpio_val;
 
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index e22e821..cdb0f1c 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -553,8 +553,14 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 	ah->hw_version.subsysid = subsysid;
 	sc->sc_ah = ah;
 
-	if (!pdata)
+	if (!pdata) {
 		ah->ah_flags |= AH_USE_EEPROM;
+		sc->sc_ah->led_pin = -1;
+	} else {
+		sc->sc_ah->gpio_mask = pdata->gpio_mask;
+		sc->sc_ah->gpio_val = pdata->gpio_val;
+		sc->sc_ah->led_pin = pdata->led_pin;
+	}
 
 	common = ath9k_hw_common(ah);
 	common->ops = &ath9k_common_ops;
diff --git a/include/linux/ath9k_platform.h b/include/linux/ath9k_platform.h
index b5f0658..020387a 100644
--- a/include/linux/ath9k_platform.h
+++ b/include/linux/ath9k_platform.h
@@ -24,6 +24,10 @@
 struct ath9k_platform_data {
 	u16 eeprom_data[ATH9K_PLAT_EEP_MAX_WORDS];
 	u8 *macaddr;
+
+	int led_pin;
+	u32 gpio_mask;
+	u32 gpio_val;
 };
 
 #endif /* _LINUX_ATH9K_PLATFORM_H */
-- 
1.7.3.2

