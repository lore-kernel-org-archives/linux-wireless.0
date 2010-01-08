Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:57904 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab0AHEtF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2010 23:49:05 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 07 Jan 2010 20:49:05 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19270.48440.162296.382915@gargle.gargle.HOWL>
Date: Fri, 8 Jan 2010 10:36:00 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/7] ath9k: Add a new file for GPIO
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move all LED/RFKILL/BTCOEX related code
to gpio.c

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/Makefile |    1 +
 drivers/net/wireless/ath/ath9k/ath9k.h  |   15 +
 drivers/net/wireless/ath/ath9k/gpio.c   |  428 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/main.c   |  406 -----------------------------
 4 files changed, 444 insertions(+), 406 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/gpio.c

diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index 4985b2b..332d6f2 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -1,4 +1,5 @@
 ath9k-y +=	beacon.o \
+		gpio.o \
 		main.o \
 		recv.o \
 		xmit.o \
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 9efebac..bbdca5e 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -341,6 +341,10 @@ int ath_beaconq_config(struct ath_softc *sc);
 #define ATH_LONG_CALINTERVAL      30000   /* 30 seconds */
 #define ATH_RESTART_CALINTERVAL   1200000 /* 20 minutes */
 
+/**********/
+/* BTCOEX */
+/**********/
+
 /* Defines the BT AR_BT_COEX_WGHT used */
 enum ath_stomp_type {
 	ATH_BTCOEX_NO_STOMP,
@@ -361,6 +365,10 @@ struct ath_btcoex {
 	struct ath_gen_timer *no_stomp_timer; /* Timer for no BT stomping */
 };
 
+int ath_init_btcoex_timer(struct ath_softc *sc);
+void ath9k_btcoex_timer_resume(struct ath_softc *sc);
+void ath9k_btcoex_timer_pause(struct ath_softc *sc);
+
 /********************/
 /*   LED Control    */
 /********************/
@@ -385,6 +393,9 @@ struct ath_led {
 	bool registered;
 };
 
+void ath_init_leds(struct ath_softc *sc);
+void ath_deinit_leds(struct ath_softc *sc);
+
 /********************/
 /* Main driver core */
 /********************/
@@ -582,4 +593,8 @@ void ath_mac80211_stop_queue(struct ath_softc *sc, u16 skb_queue);
 void ath_mac80211_start_queue(struct ath_softc *sc, u16 skb_queue);
 
 int ath_tx_get_qnum(struct ath_softc *sc, int qtype, int haltype);
+
+void ath_start_rfkill_poll(struct ath_softc *sc);
+extern void ath9k_rfkill_poll_state(struct ieee80211_hw *hw);
+
 #endif /* ATH9K_H */
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
new file mode 100644
index 0000000..e204bd2
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -0,0 +1,428 @@
+/*
+ * Copyright (c) 2008-2009 Atheros Communications Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "ath9k.h"
+
+/********************************/
+/*	 LED functions		*/
+/********************************/
+
+static void ath_led_blink_work(struct work_struct *work)
+{
+	struct ath_softc *sc = container_of(work, struct ath_softc,
+					    ath_led_blink_work.work);
+
+	if (!(sc->sc_flags & SC_OP_LED_ASSOCIATED))
+		return;
+
+	if ((sc->led_on_duration == ATH_LED_ON_DURATION_IDLE) ||
+	    (sc->led_off_duration == ATH_LED_OFF_DURATION_IDLE))
+		ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, 0);
+	else
+		ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin,
+				  (sc->sc_flags & SC_OP_LED_ON) ? 1 : 0);
+
+	ieee80211_queue_delayed_work(sc->hw,
+				     &sc->ath_led_blink_work,
+				     (sc->sc_flags & SC_OP_LED_ON) ?
+					msecs_to_jiffies(sc->led_off_duration) :
+					msecs_to_jiffies(sc->led_on_duration));
+
+	sc->led_on_duration = sc->led_on_cnt ?
+			max((ATH_LED_ON_DURATION_IDLE - sc->led_on_cnt), 25) :
+			ATH_LED_ON_DURATION_IDLE;
+	sc->led_off_duration = sc->led_off_cnt ?
+			max((ATH_LED_OFF_DURATION_IDLE - sc->led_off_cnt), 10) :
+			ATH_LED_OFF_DURATION_IDLE;
+	sc->led_on_cnt = sc->led_off_cnt = 0;
+	if (sc->sc_flags & SC_OP_LED_ON)
+		sc->sc_flags &= ~SC_OP_LED_ON;
+	else
+		sc->sc_flags |= SC_OP_LED_ON;
+}
+
+static void ath_led_brightness(struct led_classdev *led_cdev,
+			       enum led_brightness brightness)
+{
+	struct ath_led *led = container_of(led_cdev, struct ath_led, led_cdev);
+	struct ath_softc *sc = led->sc;
+
+	switch (brightness) {
+	case LED_OFF:
+		if (led->led_type == ATH_LED_ASSOC ||
+		    led->led_type == ATH_LED_RADIO) {
+			ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin,
+				(led->led_type == ATH_LED_RADIO));
+			sc->sc_flags &= ~SC_OP_LED_ASSOCIATED;
+			if (led->led_type == ATH_LED_RADIO)
+				sc->sc_flags &= ~SC_OP_LED_ON;
+		} else {
+			sc->led_off_cnt++;
+		}
+		break;
+	case LED_FULL:
+		if (led->led_type == ATH_LED_ASSOC) {
+			sc->sc_flags |= SC_OP_LED_ASSOCIATED;
+			ieee80211_queue_delayed_work(sc->hw,
+						     &sc->ath_led_blink_work, 0);
+		} else if (led->led_type == ATH_LED_RADIO) {
+			ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, 0);
+			sc->sc_flags |= SC_OP_LED_ON;
+		} else {
+			sc->led_on_cnt++;
+		}
+		break;
+	default:
+		break;
+	}
+}
+
+static int ath_register_led(struct ath_softc *sc, struct ath_led *led,
+			    char *trigger)
+{
+	int ret;
+
+	led->sc = sc;
+	led->led_cdev.name = led->name;
+	led->led_cdev.default_trigger = trigger;
+	led->led_cdev.brightness_set = ath_led_brightness;
+
+	ret = led_classdev_register(wiphy_dev(sc->hw->wiphy), &led->led_cdev);
+	if (ret)
+		ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_FATAL,
+			  "Failed to register led:%s", led->name);
+	else
+		led->registered = 1;
+	return ret;
+}
+
+static void ath_unregister_led(struct ath_led *led)
+{
+	if (led->registered) {
+		led_classdev_unregister(&led->led_cdev);
+		led->registered = 0;
+	}
+}
+
+void ath_deinit_leds(struct ath_softc *sc)
+{
+	ath_unregister_led(&sc->assoc_led);
+	sc->sc_flags &= ~SC_OP_LED_ASSOCIATED;
+	ath_unregister_led(&sc->tx_led);
+	ath_unregister_led(&sc->rx_led);
+	ath_unregister_led(&sc->radio_led);
+	ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, 1);
+}
+
+void ath_init_leds(struct ath_softc *sc)
+{
+	char *trigger;
+	int ret;
+
+	if (AR_SREV_9287(sc->sc_ah))
+		sc->sc_ah->led_pin = ATH_LED_PIN_9287;
+	else
+		sc->sc_ah->led_pin = ATH_LED_PIN_DEF;
+
+	/* Configure gpio 1 for output */
+	ath9k_hw_cfg_output(sc->sc_ah, sc->sc_ah->led_pin,
+			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
+	/* LED off, active low */
+	ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, 1);
+
+	INIT_DELAYED_WORK(&sc->ath_led_blink_work, ath_led_blink_work);
+
+	trigger = ieee80211_get_radio_led_name(sc->hw);
+	snprintf(sc->radio_led.name, sizeof(sc->radio_led.name),
+		"ath9k-%s::radio", wiphy_name(sc->hw->wiphy));
+	ret = ath_register_led(sc, &sc->radio_led, trigger);
+	sc->radio_led.led_type = ATH_LED_RADIO;
+	if (ret)
+		goto fail;
+
+	trigger = ieee80211_get_assoc_led_name(sc->hw);
+	snprintf(sc->assoc_led.name, sizeof(sc->assoc_led.name),
+		"ath9k-%s::assoc", wiphy_name(sc->hw->wiphy));
+	ret = ath_register_led(sc, &sc->assoc_led, trigger);
+	sc->assoc_led.led_type = ATH_LED_ASSOC;
+	if (ret)
+		goto fail;
+
+	trigger = ieee80211_get_tx_led_name(sc->hw);
+	snprintf(sc->tx_led.name, sizeof(sc->tx_led.name),
+		"ath9k-%s::tx", wiphy_name(sc->hw->wiphy));
+	ret = ath_register_led(sc, &sc->tx_led, trigger);
+	sc->tx_led.led_type = ATH_LED_TX;
+	if (ret)
+		goto fail;
+
+	trigger = ieee80211_get_rx_led_name(sc->hw);
+	snprintf(sc->rx_led.name, sizeof(sc->rx_led.name),
+		"ath9k-%s::rx", wiphy_name(sc->hw->wiphy));
+	ret = ath_register_led(sc, &sc->rx_led, trigger);
+	sc->rx_led.led_type = ATH_LED_RX;
+	if (ret)
+		goto fail;
+
+	return;
+
+fail:
+	cancel_delayed_work_sync(&sc->ath_led_blink_work);
+	ath_deinit_leds(sc);
+}
+
+/*******************/
+/*	Rfkill	   */
+/*******************/
+
+static bool ath_is_rfkill_set(struct ath_softc *sc)
+{
+	struct ath_hw *ah = sc->sc_ah;
+
+	return ath9k_hw_gpio_get(ah, ah->rfkill_gpio) ==
+				  ah->rfkill_polarity;
+}
+
+void ath9k_rfkill_poll_state(struct ieee80211_hw *hw)
+{
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
+	bool blocked = !!ath_is_rfkill_set(sc);
+
+	wiphy_rfkill_set_hw_state(hw->wiphy, blocked);
+}
+
+void ath_start_rfkill_poll(struct ath_softc *sc)
+{
+	struct ath_hw *ah = sc->sc_ah;
+
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
+		wiphy_rfkill_start_polling(sc->hw->wiphy);
+}
+
+/******************/
+/*     BTCOEX     */
+/******************/
+
+/*
+ * Detects if there is any priority bt traffic
+ */
+static void ath_detect_bt_priority(struct ath_softc *sc)
+{
+	struct ath_btcoex *btcoex = &sc->btcoex;
+	struct ath_hw *ah = sc->sc_ah;
+
+	if (ath9k_hw_gpio_get(sc->sc_ah, ah->btcoex_hw.btpriority_gpio))
+		btcoex->bt_priority_cnt++;
+
+	if (time_after(jiffies, btcoex->bt_priority_time +
+			msecs_to_jiffies(ATH_BT_PRIORITY_TIME_THRESHOLD))) {
+		if (btcoex->bt_priority_cnt >= ATH_BT_CNT_THRESHOLD) {
+			ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_BTCOEX,
+				  "BT priority traffic detected");
+			sc->sc_flags |= SC_OP_BT_PRIORITY_DETECTED;
+		} else {
+			sc->sc_flags &= ~SC_OP_BT_PRIORITY_DETECTED;
+		}
+
+		btcoex->bt_priority_cnt = 0;
+		btcoex->bt_priority_time = jiffies;
+	}
+}
+
+/*
+ * Configures appropriate weight based on stomp type.
+ */
+static void ath9k_btcoex_bt_stomp(struct ath_softc *sc,
+				  enum ath_stomp_type stomp_type)
+{
+	struct ath_hw *ah = sc->sc_ah;
+
+	switch (stomp_type) {
+	case ATH_BTCOEX_STOMP_ALL:
+		ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT,
+					   AR_STOMP_ALL_WLAN_WGHT);
+		break;
+	case ATH_BTCOEX_STOMP_LOW:
+		ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT,
+					   AR_STOMP_LOW_WLAN_WGHT);
+		break;
+	case ATH_BTCOEX_STOMP_NONE:
+		ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT,
+					   AR_STOMP_NONE_WLAN_WGHT);
+		break;
+	default:
+		ath_print(ath9k_hw_common(ah), ATH_DBG_BTCOEX,
+			  "Invalid Stomptype\n");
+		break;
+	}
+
+	ath9k_hw_btcoex_enable(ah);
+}
+
+static void ath9k_gen_timer_start(struct ath_hw *ah,
+				  struct ath_gen_timer *timer,
+				  u32 timer_next,
+				  u32 timer_period)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath_softc *sc = (struct ath_softc *) common->priv;
+
+	ath9k_hw_gen_timer_start(ah, timer, timer_next, timer_period);
+
+	if ((sc->imask & ATH9K_INT_GENTIMER) == 0) {
+		ath9k_hw_set_interrupts(ah, 0);
+		sc->imask |= ATH9K_INT_GENTIMER;
+		ath9k_hw_set_interrupts(ah, sc->imask);
+	}
+}
+
+static void ath9k_gen_timer_stop(struct ath_hw *ah, struct ath_gen_timer *timer)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath_softc *sc = (struct ath_softc *) common->priv;
+	struct ath_gen_timer_table *timer_table = &ah->hw_gen_timers;
+
+	ath9k_hw_gen_timer_stop(ah, timer);
+
+	/* if no timer is enabled, turn off interrupt mask */
+	if (timer_table->timer_mask.val == 0) {
+		ath9k_hw_set_interrupts(ah, 0);
+		sc->imask &= ~ATH9K_INT_GENTIMER;
+		ath9k_hw_set_interrupts(ah, sc->imask);
+	}
+}
+
+/*
+ * This is the master bt coex timer which runs for every
+ * 45ms, bt traffic will be given priority during 55% of this
+ * period while wlan gets remaining 45%
+ */
+static void ath_btcoex_period_timer(unsigned long data)
+{
+	struct ath_softc *sc = (struct ath_softc *) data;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_btcoex *btcoex = &sc->btcoex;
+
+	ath_detect_bt_priority(sc);
+
+	spin_lock_bh(&btcoex->btcoex_lock);
+
+	ath9k_btcoex_bt_stomp(sc, btcoex->bt_stomp_type);
+
+	spin_unlock_bh(&btcoex->btcoex_lock);
+
+	if (btcoex->btcoex_period != btcoex->btcoex_no_stomp) {
+		if (btcoex->hw_timer_enabled)
+			ath9k_gen_timer_stop(ah, btcoex->no_stomp_timer);
+
+		ath9k_gen_timer_start(ah,
+				      btcoex->no_stomp_timer,
+				      (ath9k_hw_gettsf32(ah) +
+				       btcoex->btcoex_no_stomp),
+				       btcoex->btcoex_no_stomp * 10);
+		btcoex->hw_timer_enabled = true;
+	}
+
+	mod_timer(&btcoex->period_timer, jiffies +
+				  msecs_to_jiffies(ATH_BTCOEX_DEF_BT_PERIOD));
+}
+
+/*
+ * Generic tsf based hw timer which configures weight
+ * registers to time slice between wlan and bt traffic
+ */
+static void ath_btcoex_no_stomp_timer(void *arg)
+{
+	struct ath_softc *sc = (struct ath_softc *)arg;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_btcoex *btcoex = &sc->btcoex;
+
+	ath_print(ath9k_hw_common(ah), ATH_DBG_BTCOEX,
+		  "no stomp timer running \n");
+
+	spin_lock_bh(&btcoex->btcoex_lock);
+
+	if (btcoex->bt_stomp_type == ATH_BTCOEX_STOMP_LOW)
+		ath9k_btcoex_bt_stomp(sc, ATH_BTCOEX_STOMP_NONE);
+	 else if (btcoex->bt_stomp_type == ATH_BTCOEX_STOMP_ALL)
+		ath9k_btcoex_bt_stomp(sc, ATH_BTCOEX_STOMP_LOW);
+
+	spin_unlock_bh(&btcoex->btcoex_lock);
+}
+
+int ath_init_btcoex_timer(struct ath_softc *sc)
+{
+	struct ath_btcoex *btcoex = &sc->btcoex;
+
+	btcoex->btcoex_period = ATH_BTCOEX_DEF_BT_PERIOD * 1000;
+	btcoex->btcoex_no_stomp = (100 - ATH_BTCOEX_DEF_DUTY_CYCLE) *
+		btcoex->btcoex_period / 100;
+
+	setup_timer(&btcoex->period_timer, ath_btcoex_period_timer,
+			(unsigned long) sc);
+
+	spin_lock_init(&btcoex->btcoex_lock);
+
+	btcoex->no_stomp_timer = ath_gen_timer_alloc(sc->sc_ah,
+			ath_btcoex_no_stomp_timer,
+			ath_btcoex_no_stomp_timer,
+			(void *) sc, AR_FIRST_NDP_TIMER);
+
+	if (!btcoex->no_stomp_timer)
+		return -ENOMEM;
+
+	return 0;
+}
+
+/*
+ * (Re)start btcoex timers
+ */
+void ath9k_btcoex_timer_resume(struct ath_softc *sc)
+{
+	struct ath_btcoex *btcoex = &sc->btcoex;
+	struct ath_hw *ah = sc->sc_ah;
+
+	ath_print(ath9k_hw_common(ah), ATH_DBG_BTCOEX,
+		  "Starting btcoex timers");
+
+	/* make sure duty cycle timer is also stopped when resuming */
+	if (btcoex->hw_timer_enabled)
+		ath9k_gen_timer_stop(sc->sc_ah, btcoex->no_stomp_timer);
+
+	btcoex->bt_priority_cnt = 0;
+	btcoex->bt_priority_time = jiffies;
+	sc->sc_flags &= ~SC_OP_BT_PRIORITY_DETECTED;
+
+	mod_timer(&btcoex->period_timer, jiffies);
+}
+
+
+/*
+ * Pause btcoex timer and bt duty cycle timer
+ */
+void ath9k_btcoex_timer_pause(struct ath_softc *sc)
+{
+	struct ath_btcoex *btcoex = &sc->btcoex;
+	struct ath_hw *ah = sc->sc_ah;
+
+	del_timer_sync(&btcoex->period_timer);
+
+	if (btcoex->hw_timer_enabled)
+		ath9k_gen_timer_stop(ah, btcoex->no_stomp_timer);
+
+	btcoex->hw_timer_enabled = false;
+}
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 79fbbda..31fcfc6 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1000,174 +1000,6 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 	}
 }
 
-/********************************/
-/*	 LED functions		*/
-/********************************/
-
-static void ath_led_blink_work(struct work_struct *work)
-{
-	struct ath_softc *sc = container_of(work, struct ath_softc,
-					    ath_led_blink_work.work);
-
-	if (!(sc->sc_flags & SC_OP_LED_ASSOCIATED))
-		return;
-
-	if ((sc->led_on_duration == ATH_LED_ON_DURATION_IDLE) ||
-	    (sc->led_off_duration == ATH_LED_OFF_DURATION_IDLE))
-		ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, 0);
-	else
-		ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin,
-				  (sc->sc_flags & SC_OP_LED_ON) ? 1 : 0);
-
-	ieee80211_queue_delayed_work(sc->hw,
-				     &sc->ath_led_blink_work,
-				     (sc->sc_flags & SC_OP_LED_ON) ?
-					msecs_to_jiffies(sc->led_off_duration) :
-					msecs_to_jiffies(sc->led_on_duration));
-
-	sc->led_on_duration = sc->led_on_cnt ?
-			max((ATH_LED_ON_DURATION_IDLE - sc->led_on_cnt), 25) :
-			ATH_LED_ON_DURATION_IDLE;
-	sc->led_off_duration = sc->led_off_cnt ?
-			max((ATH_LED_OFF_DURATION_IDLE - sc->led_off_cnt), 10) :
-			ATH_LED_OFF_DURATION_IDLE;
-	sc->led_on_cnt = sc->led_off_cnt = 0;
-	if (sc->sc_flags & SC_OP_LED_ON)
-		sc->sc_flags &= ~SC_OP_LED_ON;
-	else
-		sc->sc_flags |= SC_OP_LED_ON;
-}
-
-static void ath_led_brightness(struct led_classdev *led_cdev,
-			       enum led_brightness brightness)
-{
-	struct ath_led *led = container_of(led_cdev, struct ath_led, led_cdev);
-	struct ath_softc *sc = led->sc;
-
-	switch (brightness) {
-	case LED_OFF:
-		if (led->led_type == ATH_LED_ASSOC ||
-		    led->led_type == ATH_LED_RADIO) {
-			ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin,
-				(led->led_type == ATH_LED_RADIO));
-			sc->sc_flags &= ~SC_OP_LED_ASSOCIATED;
-			if (led->led_type == ATH_LED_RADIO)
-				sc->sc_flags &= ~SC_OP_LED_ON;
-		} else {
-			sc->led_off_cnt++;
-		}
-		break;
-	case LED_FULL:
-		if (led->led_type == ATH_LED_ASSOC) {
-			sc->sc_flags |= SC_OP_LED_ASSOCIATED;
-			ieee80211_queue_delayed_work(sc->hw,
-						     &sc->ath_led_blink_work, 0);
-		} else if (led->led_type == ATH_LED_RADIO) {
-			ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, 0);
-			sc->sc_flags |= SC_OP_LED_ON;
-		} else {
-			sc->led_on_cnt++;
-		}
-		break;
-	default:
-		break;
-	}
-}
-
-static int ath_register_led(struct ath_softc *sc, struct ath_led *led,
-			    char *trigger)
-{
-	int ret;
-
-	led->sc = sc;
-	led->led_cdev.name = led->name;
-	led->led_cdev.default_trigger = trigger;
-	led->led_cdev.brightness_set = ath_led_brightness;
-
-	ret = led_classdev_register(wiphy_dev(sc->hw->wiphy), &led->led_cdev);
-	if (ret)
-		ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_FATAL,
-			  "Failed to register led:%s", led->name);
-	else
-		led->registered = 1;
-	return ret;
-}
-
-static void ath_unregister_led(struct ath_led *led)
-{
-	if (led->registered) {
-		led_classdev_unregister(&led->led_cdev);
-		led->registered = 0;
-	}
-}
-
-static void ath_deinit_leds(struct ath_softc *sc)
-{
-	ath_unregister_led(&sc->assoc_led);
-	sc->sc_flags &= ~SC_OP_LED_ASSOCIATED;
-	ath_unregister_led(&sc->tx_led);
-	ath_unregister_led(&sc->rx_led);
-	ath_unregister_led(&sc->radio_led);
-	ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, 1);
-}
-
-static void ath_init_leds(struct ath_softc *sc)
-{
-	char *trigger;
-	int ret;
-
-	if (AR_SREV_9287(sc->sc_ah))
-		sc->sc_ah->led_pin = ATH_LED_PIN_9287;
-	else
-		sc->sc_ah->led_pin = ATH_LED_PIN_DEF;
-
-	/* Configure gpio 1 for output */
-	ath9k_hw_cfg_output(sc->sc_ah, sc->sc_ah->led_pin,
-			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
-	/* LED off, active low */
-	ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, 1);
-
-	INIT_DELAYED_WORK(&sc->ath_led_blink_work, ath_led_blink_work);
-
-	trigger = ieee80211_get_radio_led_name(sc->hw);
-	snprintf(sc->radio_led.name, sizeof(sc->radio_led.name),
-		"ath9k-%s::radio", wiphy_name(sc->hw->wiphy));
-	ret = ath_register_led(sc, &sc->radio_led, trigger);
-	sc->radio_led.led_type = ATH_LED_RADIO;
-	if (ret)
-		goto fail;
-
-	trigger = ieee80211_get_assoc_led_name(sc->hw);
-	snprintf(sc->assoc_led.name, sizeof(sc->assoc_led.name),
-		"ath9k-%s::assoc", wiphy_name(sc->hw->wiphy));
-	ret = ath_register_led(sc, &sc->assoc_led, trigger);
-	sc->assoc_led.led_type = ATH_LED_ASSOC;
-	if (ret)
-		goto fail;
-
-	trigger = ieee80211_get_tx_led_name(sc->hw);
-	snprintf(sc->tx_led.name, sizeof(sc->tx_led.name),
-		"ath9k-%s::tx", wiphy_name(sc->hw->wiphy));
-	ret = ath_register_led(sc, &sc->tx_led, trigger);
-	sc->tx_led.led_type = ATH_LED_TX;
-	if (ret)
-		goto fail;
-
-	trigger = ieee80211_get_rx_led_name(sc->hw);
-	snprintf(sc->rx_led.name, sizeof(sc->rx_led.name),
-		"ath9k-%s::rx", wiphy_name(sc->hw->wiphy));
-	ret = ath_register_led(sc, &sc->rx_led, trigger);
-	sc->rx_led.led_type = ATH_LED_RX;
-	if (ret)
-		goto fail;
-
-	return;
-
-fail:
-	cancel_delayed_work_sync(&sc->ath_led_blink_work);
-	ath_deinit_leds(sc);
-}
-
 void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
 {
 	struct ath_hw *ah = sc->sc_ah;
@@ -1252,35 +1084,6 @@ void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	ath9k_setpower(sc, ATH9K_PM_FULL_SLEEP);
 }
 
-/*******************/
-/*	Rfkill	   */
-/*******************/
-
-static bool ath_is_rfkill_set(struct ath_softc *sc)
-{
-	struct ath_hw *ah = sc->sc_ah;
-
-	return ath9k_hw_gpio_get(ah, ah->rfkill_gpio) ==
-				  ah->rfkill_polarity;
-}
-
-static void ath9k_rfkill_poll_state(struct ieee80211_hw *hw)
-{
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
-	bool blocked = !!ath_is_rfkill_set(sc);
-
-	wiphy_rfkill_set_hw_state(hw->wiphy, blocked);
-}
-
-static void ath_start_rfkill_poll(struct ath_softc *sc)
-{
-	struct ath_hw *ah = sc->sc_ah;
-
-	if (ah->caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
-		wiphy_rfkill_start_polling(sc->hw->wiphy);
-}
-
 static void ath9k_uninit_hw(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
@@ -1365,177 +1168,6 @@ static int ath9k_reg_notifier(struct wiphy *wiphy,
 }
 
 /*
- * Detects if there is any priority bt traffic
- */
-static void ath_detect_bt_priority(struct ath_softc *sc)
-{
-	struct ath_btcoex *btcoex = &sc->btcoex;
-	struct ath_hw *ah = sc->sc_ah;
-
-	if (ath9k_hw_gpio_get(sc->sc_ah, ah->btcoex_hw.btpriority_gpio))
-		btcoex->bt_priority_cnt++;
-
-	if (time_after(jiffies, btcoex->bt_priority_time +
-			msecs_to_jiffies(ATH_BT_PRIORITY_TIME_THRESHOLD))) {
-		if (btcoex->bt_priority_cnt >= ATH_BT_CNT_THRESHOLD) {
-			ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_BTCOEX,
-				  "BT priority traffic detected");
-			sc->sc_flags |= SC_OP_BT_PRIORITY_DETECTED;
-		} else {
-			sc->sc_flags &= ~SC_OP_BT_PRIORITY_DETECTED;
-		}
-
-		btcoex->bt_priority_cnt = 0;
-		btcoex->bt_priority_time = jiffies;
-	}
-}
-
-/*
- * Configures appropriate weight based on stomp type.
- */
-static void ath9k_btcoex_bt_stomp(struct ath_softc *sc,
-				  enum ath_stomp_type stomp_type)
-{
-	struct ath_hw *ah = sc->sc_ah;
-
-	switch (stomp_type) {
-	case ATH_BTCOEX_STOMP_ALL:
-		ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT,
-					   AR_STOMP_ALL_WLAN_WGHT);
-		break;
-	case ATH_BTCOEX_STOMP_LOW:
-		ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT,
-					   AR_STOMP_LOW_WLAN_WGHT);
-		break;
-	case ATH_BTCOEX_STOMP_NONE:
-		ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT,
-					   AR_STOMP_NONE_WLAN_WGHT);
-		break;
-	default:
-		ath_print(ath9k_hw_common(ah), ATH_DBG_BTCOEX,
-			  "Invalid Stomptype\n");
-		break;
-	}
-
-	ath9k_hw_btcoex_enable(ah);
-}
-
-static void ath9k_gen_timer_start(struct ath_hw *ah,
-				  struct ath_gen_timer *timer,
-				  u32 timer_next,
-				  u32 timer_period)
-{
-	struct ath_common *common = ath9k_hw_common(ah);
-	struct ath_softc *sc = (struct ath_softc *) common->priv;
-
-	ath9k_hw_gen_timer_start(ah, timer, timer_next, timer_period);
-
-	if ((sc->imask & ATH9K_INT_GENTIMER) == 0) {
-		ath9k_hw_set_interrupts(ah, 0);
-		sc->imask |= ATH9K_INT_GENTIMER;
-		ath9k_hw_set_interrupts(ah, sc->imask);
-	}
-}
-
-static void ath9k_gen_timer_stop(struct ath_hw *ah, struct ath_gen_timer *timer)
-{
-	struct ath_common *common = ath9k_hw_common(ah);
-	struct ath_softc *sc = (struct ath_softc *) common->priv;
-	struct ath_gen_timer_table *timer_table = &ah->hw_gen_timers;
-
-	ath9k_hw_gen_timer_stop(ah, timer);
-
-	/* if no timer is enabled, turn off interrupt mask */
-	if (timer_table->timer_mask.val == 0) {
-		ath9k_hw_set_interrupts(ah, 0);
-		sc->imask &= ~ATH9K_INT_GENTIMER;
-		ath9k_hw_set_interrupts(ah, sc->imask);
-	}
-}
-
-/*
- * This is the master bt coex timer which runs for every
- * 45ms, bt traffic will be given priority during 55% of this
- * period while wlan gets remaining 45%
- */
-static void ath_btcoex_period_timer(unsigned long data)
-{
-	struct ath_softc *sc = (struct ath_softc *) data;
-	struct ath_hw *ah = sc->sc_ah;
-	struct ath_btcoex *btcoex = &sc->btcoex;
-
-	ath_detect_bt_priority(sc);
-
-	spin_lock_bh(&btcoex->btcoex_lock);
-
-	ath9k_btcoex_bt_stomp(sc, btcoex->bt_stomp_type);
-
-	spin_unlock_bh(&btcoex->btcoex_lock);
-
-	if (btcoex->btcoex_period != btcoex->btcoex_no_stomp) {
-		if (btcoex->hw_timer_enabled)
-			ath9k_gen_timer_stop(ah, btcoex->no_stomp_timer);
-
-		ath9k_gen_timer_start(ah,
-				      btcoex->no_stomp_timer,
-				      (ath9k_hw_gettsf32(ah) +
-				       btcoex->btcoex_no_stomp),
-				       btcoex->btcoex_no_stomp * 10);
-		btcoex->hw_timer_enabled = true;
-	}
-
-	mod_timer(&btcoex->period_timer, jiffies +
-				  msecs_to_jiffies(ATH_BTCOEX_DEF_BT_PERIOD));
-}
-
-/*
- * Generic tsf based hw timer which configures weight
- * registers to time slice between wlan and bt traffic
- */
-static void ath_btcoex_no_stomp_timer(void *arg)
-{
-	struct ath_softc *sc = (struct ath_softc *)arg;
-	struct ath_hw *ah = sc->sc_ah;
-	struct ath_btcoex *btcoex = &sc->btcoex;
-
-	ath_print(ath9k_hw_common(ah), ATH_DBG_BTCOEX,
-		  "no stomp timer running \n");
-
-	spin_lock_bh(&btcoex->btcoex_lock);
-
-	if (btcoex->bt_stomp_type == ATH_BTCOEX_STOMP_LOW)
-		ath9k_btcoex_bt_stomp(sc, ATH_BTCOEX_STOMP_NONE);
-	 else if (btcoex->bt_stomp_type == ATH_BTCOEX_STOMP_ALL)
-		ath9k_btcoex_bt_stomp(sc, ATH_BTCOEX_STOMP_LOW);
-
-	spin_unlock_bh(&btcoex->btcoex_lock);
-}
-
-static int ath_init_btcoex_timer(struct ath_softc *sc)
-{
-	struct ath_btcoex *btcoex = &sc->btcoex;
-
-	btcoex->btcoex_period = ATH_BTCOEX_DEF_BT_PERIOD * 1000;
-	btcoex->btcoex_no_stomp = (100 - ATH_BTCOEX_DEF_DUTY_CYCLE) *
-		btcoex->btcoex_period / 100;
-
-	setup_timer(&btcoex->period_timer, ath_btcoex_period_timer,
-			(unsigned long) sc);
-
-	spin_lock_init(&btcoex->btcoex_lock);
-
-	btcoex->no_stomp_timer = ath_gen_timer_alloc(sc->sc_ah,
-			ath_btcoex_no_stomp_timer,
-			ath_btcoex_no_stomp_timer,
-			(void *) sc, AR_FIRST_NDP_TIMER);
-
-	if (!btcoex->no_stomp_timer)
-		return -ENOMEM;
-
-	return 0;
-}
-
-/*
  * Read and write, they both share the same lock. We do this to serialize
  * reads and writes on Atheros 802.11n PCI devices only. This is required
  * as the FIFO on these devices can only accept sanely 2 requests. After
@@ -2210,28 +1842,6 @@ void ath9k_update_ichannel(struct ath_softc *sc, struct ieee80211_hw *hw,
 /* mac80211 callbacks */
 /**********************/
 
-/*
- * (Re)start btcoex timers
- */
-static void ath9k_btcoex_timer_resume(struct ath_softc *sc)
-{
-	struct ath_btcoex *btcoex = &sc->btcoex;
-	struct ath_hw *ah = sc->sc_ah;
-
-	ath_print(ath9k_hw_common(ah), ATH_DBG_BTCOEX,
-		  "Starting btcoex timers");
-
-	/* make sure duty cycle timer is also stopped when resuming */
-	if (btcoex->hw_timer_enabled)
-		ath9k_gen_timer_stop(sc->sc_ah, btcoex->no_stomp_timer);
-
-	btcoex->bt_priority_cnt = 0;
-	btcoex->bt_priority_time = jiffies;
-	sc->sc_flags &= ~SC_OP_BT_PRIORITY_DETECTED;
-
-	mod_timer(&btcoex->period_timer, jiffies);
-}
-
 static int ath9k_start(struct ieee80211_hw *hw)
 {
 	struct ath_wiphy *aphy = hw->priv;
@@ -2458,22 +2068,6 @@ exit:
 	return 0;
 }
 
-/*
- * Pause btcoex timer and bt duty cycle timer
- */
-static void ath9k_btcoex_timer_pause(struct ath_softc *sc)
-{
-	struct ath_btcoex *btcoex = &sc->btcoex;
-	struct ath_hw *ah = sc->sc_ah;
-
-	del_timer_sync(&btcoex->period_timer);
-
-	if (btcoex->hw_timer_enabled)
-		ath9k_gen_timer_stop(ah, btcoex->no_stomp_timer);
-
-	btcoex->hw_timer_enabled = false;
-}
-
 static void ath9k_stop(struct ieee80211_hw *hw)
 {
 	struct ath_wiphy *aphy = hw->priv;
-- 
1.6.6

