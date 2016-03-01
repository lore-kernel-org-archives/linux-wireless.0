Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48750 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbcCAC7P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 21:59:15 -0500
From: miaoqing@codeaurora.org
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	kvalo@qca.qualcomm.com, Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH 4/8] ath9k: cleanup led_pin initial
Date: Tue,  1 Mar 2016 10:58:31 +0800
Message-Id: <1456801115-16636-5-git-send-email-miaoqing@codeaurora.org> (sfid-20160301_035918_738655_86541F0E)
In-Reply-To: <1456801115-16636-1-git-send-email-miaoqing@codeaurora.org>
References: <1456801115-16636-1-git-send-email-miaoqing@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@codeaurora.org>

Make ath_init_leds() and ath_deinit_leds() pairs as the only
API to set leds, also removed direction configuration from
ath9k_start() and ath9k_stop(). So the initial is more clear
now.

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  4 ---
 drivers/net/wireless/ath/ath9k/gpio.c  | 62 ++++++++++++++++------------------
 drivers/net/wireless/ath/ath9k/init.c  |  1 -
 drivers/net/wireless/ath/ath9k/main.c  |  9 ++---
 drivers/net/wireless/ath/ath9k/reg.h   |  2 --
 5 files changed, 31 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 5294595..93b3793 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -813,7 +813,6 @@ static inline int ath9k_dump_btcoex(struct ath_softc *sc, u8 *buf, u32 size)
 #ifdef CONFIG_MAC80211_LEDS
 void ath_init_leds(struct ath_softc *sc);
 void ath_deinit_leds(struct ath_softc *sc);
-void ath_fill_led_pin(struct ath_softc *sc);
 #else
 static inline void ath_init_leds(struct ath_softc *sc)
 {
@@ -822,9 +821,6 @@ static inline void ath_init_leds(struct ath_softc *sc)
 static inline void ath_deinit_leds(struct ath_softc *sc)
 {
 }
-static inline void ath_fill_led_pin(struct ath_softc *sc)
-{
-}
 #endif
 
 /************************/
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 4964bb3..490f74d 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -21,6 +21,33 @@
 /********************************/
 
 #ifdef CONFIG_MAC80211_LEDS
+
+void ath_fill_led_pin(struct ath_softc *sc)
+{
+	struct ath_hw *ah = sc->sc_ah;
+
+	/* Set default led pin if invalid */
+	if (ah->led_pin < 0) {
+		if (AR_SREV_9287(ah))
+			ah->led_pin = ATH_LED_PIN_9287;
+		else if (AR_SREV_9485(ah))
+			ah->led_pin = ATH_LED_PIN_9485;
+		else if (AR_SREV_9300(ah))
+			ah->led_pin = ATH_LED_PIN_9300;
+		else if (AR_SREV_9462(ah) || AR_SREV_9565(ah))
+			ah->led_pin = ATH_LED_PIN_9462;
+		else
+			ah->led_pin = ATH_LED_PIN_DEF;
+	}
+
+	/* Configure gpio for output */
+	ath9k_hw_gpio_request_out(ah, ah->led_pin, "ath9k-led",
+				  AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
+
+	/* LED off, active low */
+	ath9k_hw_set_gpio(ah, ah->led_pin, ah->config.led_active_high ? 0 : 1);
+}
+
 static void ath_led_brightness(struct led_classdev *led_cdev,
 			       enum led_brightness brightness)
 {
@@ -51,6 +78,8 @@ void ath_init_leds(struct ath_softc *sc)
 	if (AR_SREV_9100(sc->sc_ah))
 		return;
 
+	ath_fill_led_pin(sc);
+
 	if (!ath9k_led_blink)
 		sc->led_cdev.default_trigger =
 			ieee80211_get_radio_led_name(sc->hw);
@@ -66,39 +95,6 @@ void ath_init_leds(struct ath_softc *sc)
 
 	sc->led_registered = true;
 }
-
-void ath_fill_led_pin(struct ath_softc *sc)
-{
-	struct ath_hw *ah = sc->sc_ah;
-
-	if (AR_SREV_9100(ah))
-		return;
-
-	if (ah->led_pin >= 0) {
-		if (!((1 << ah->led_pin) & AR_GPIO_OE_OUT_MASK))
-			ath9k_hw_gpio_request_out(ah, ah->led_pin, "ath9k-led",
-						  AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
-		return;
-	}
-
-	if (AR_SREV_9287(ah))
-		ah->led_pin = ATH_LED_PIN_9287;
-	else if (AR_SREV_9485(sc->sc_ah))
-		ah->led_pin = ATH_LED_PIN_9485;
-	else if (AR_SREV_9300(sc->sc_ah))
-		ah->led_pin = ATH_LED_PIN_9300;
-	else if (AR_SREV_9462(sc->sc_ah) || AR_SREV_9565(sc->sc_ah))
-		ah->led_pin = ATH_LED_PIN_9462;
-	else
-		ah->led_pin = ATH_LED_PIN_DEF;
-
-	/* Configure gpio 1 for output */
-	ath9k_hw_gpio_request_out(ah, ah->led_pin, "ath9k-led",
-				  AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
-
-	/* LED off, active low */
-	ath9k_hw_set_gpio(ah, ah->led_pin, (ah->config.led_active_high) ? 0 : 1);
-}
 #endif
 
 /*******************/
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 2e2b92b..95c12fd 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -660,7 +660,6 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 
 	ath9k_cmn_init_crypto(sc->sc_ah);
 	ath9k_init_misc(sc);
-	ath_fill_led_pin(sc);
 	ath_chanctx_init(sc);
 	ath9k_offchannel_init(sc);
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 95d0a53..f469a7c 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -718,12 +718,9 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	if (!ath_complete_reset(sc, false))
 		ah->reset_power_on = false;
 
-	if (ah->led_pin >= 0) {
+	if (ah->led_pin >= 0)
 		ath9k_hw_set_gpio(ah, ah->led_pin,
 				  (ah->config.led_active_high) ? 1 : 0);
-		ath9k_hw_gpio_request_out(ah, ah->led_pin, NULL,
-					  AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
-	}
 
 	/*
 	 * Reset key cache to sane defaults (all entries cleared) instead of
@@ -867,11 +864,9 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
 	spin_lock_bh(&sc->sc_pcu_lock);
 
-	if (ah->led_pin >= 0) {
+	if (ah->led_pin >= 0)
 		ath9k_hw_set_gpio(ah, ah->led_pin,
 				  (ah->config.led_active_high) ? 0 : 1);
-		ath9k_hw_gpio_request_in(ah, ah->led_pin, NULL);
-	}
 
 	ath_prepare_reset(sc);
 
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 8903f70..f82a4ad 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1166,8 +1166,6 @@ enum {
 
 #define AR_GPIO_OE_OUT                           (AR_SREV_9340(ah) ? 0x4030 : \
 						  (AR_SREV_9300_20_OR_LATER(ah) ? 0x4050 : 0x404c))
-#define AR_GPIO_OE_OUT_MASK			 (AR_SREV_9550_OR_LATER(ah) ? \
-						  0x0000000F : 0xFFFFFFFF)
 #define AR_GPIO_OE_OUT_DRV                       0x3
 #define AR_GPIO_OE_OUT_DRV_NO                    0x0
 #define AR_GPIO_OE_OUT_DRV_LOW                   0x1
-- 
1.9.1

