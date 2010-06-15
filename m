Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:41935 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882Ab0FOFUX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jun 2010 01:20:23 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Jun 2010 22:20:23 -0700
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: Modify LED blinking pattern during wifi activity.
Date: Tue, 15 Jun 2010 10:50:17 +0530
Message-ID: <1276579217-6837-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some vendors require the LED to be ON always irrespective of any
radio activity. Introducing a module parameter to enable this,
so that one can choose between always on or led blink during
activity.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/gpio.c  |    9 ++++++---
 drivers/net/wireless/ath/ath9k/init.c  |    4 ++++
 drivers/net/wireless/ath/ath9k/main.c  |    4 +++-
 4 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 8d163ae..3a14630 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -628,6 +628,7 @@ static inline void ath_read_cachesize(struct ath_common *common, int *csz)
 
 extern struct ieee80211_ops ath9k_ops;
 extern int modparam_nohwcrypt;
+extern int led_blink;
 
 irqreturn_t ath_isr(int irq, void *dev);
 int ath9k_init_device(u16 devid, struct ath_softc *sc, u16 subsysid,
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 0ee75e7..3a8ee99 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -76,7 +76,8 @@ static void ath_led_brightness(struct led_classdev *led_cdev,
 	case LED_FULL:
 		if (led->led_type == ATH_LED_ASSOC) {
 			sc->sc_flags |= SC_OP_LED_ASSOCIATED;
-			ieee80211_queue_delayed_work(sc->hw,
+			if (led_blink)
+				ieee80211_queue_delayed_work(sc->hw,
 						     &sc->ath_led_blink_work, 0);
 		} else if (led->led_type == ATH_LED_RADIO) {
 			ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, 0);
@@ -143,7 +144,8 @@ void ath_init_leds(struct ath_softc *sc)
 	/* LED off, active low */
 	ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, 1);
 
-	INIT_DELAYED_WORK(&sc->ath_led_blink_work, ath_led_blink_work);
+	if (led_blink)
+		INIT_DELAYED_WORK(&sc->ath_led_blink_work, ath_led_blink_work);
 
 	trigger = ieee80211_get_radio_led_name(sc->hw);
 	snprintf(sc->radio_led.name, sizeof(sc->radio_led.name),
@@ -180,7 +182,8 @@ void ath_init_leds(struct ath_softc *sc)
 	return;
 
 fail:
-	cancel_delayed_work_sync(&sc->ath_led_blink_work);
+	if (led_blink)
+		cancel_delayed_work_sync(&sc->ath_led_blink_work);
 	ath_deinit_leds(sc);
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 514a401..b2bf0e8 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -33,6 +33,10 @@ int modparam_nohwcrypt;
 module_param_named(nohwcrypt, modparam_nohwcrypt, int, 0444);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption");
 
+int led_blink;
+module_param_named(blink, led_blink, int, 0444);
+MODULE_PARM_DESC(blink, "Enable LED blink on activity");
+
 /* We use the hw_value as an index into our private channel structure */
 
 #define CHAN2G(_freq, _idx)  { \
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index c8de50f..5af2596 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1241,7 +1241,9 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
 	aphy->state = ATH_WIPHY_INACTIVE;
 
-	cancel_delayed_work_sync(&sc->ath_led_blink_work);
+	if (led_blink)
+		cancel_delayed_work_sync(&sc->ath_led_blink_work);
+
 	cancel_delayed_work_sync(&sc->tx_complete_work);
 	cancel_work_sync(&sc->paprd_work);
 
-- 
1.7.1

