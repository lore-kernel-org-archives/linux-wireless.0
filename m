Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41577 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab0L1IMt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 03:12:49 -0500
Received: by iwn9 with SMTP id 9so9147869iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Dec 2010 00:12:49 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19737.39918.866435.325463@gargle.gargle.HOWL>
Date: Tue, 28 Dec 2010 13:42:30 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH 5/5] ath9k_htc: Move LED/RFKILL code to htc_drv_gpio.c
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

And add the copyright/license header.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |    5 +
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c |  327 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |  313 +-----------------------
 3 files changed, 333 insertions(+), 312 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 34456a8..a099b3e 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -459,8 +459,13 @@ void ath9k_htc_ps_restore(struct ath9k_htc_priv *priv);
 void ath9k_ps_work(struct work_struct *work);
 bool ath9k_htc_setpower(struct ath9k_htc_priv *priv,
 			enum ath9k_power_mode mode);
+void ath_update_txpow(struct ath9k_htc_priv *priv);
 
 void ath9k_start_rfkill_poll(struct ath9k_htc_priv *priv);
+void ath9k_htc_rfkill_poll_state(struct ieee80211_hw *hw);
+void ath9k_htc_radio_enable(struct ieee80211_hw *hw);
+void ath9k_htc_radio_disable(struct ieee80211_hw *hw);
+void ath9k_led_stop_brightness(struct ath9k_htc_priv *priv);
 void ath9k_init_leds(struct ath9k_htc_priv *priv);
 void ath9k_deinit_leds(struct ath9k_htc_priv *priv);
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
index 283ff97..fe70f67 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
@@ -1,3 +1,19 @@
+/*
+ * Copyright (c) 2010 Atheros Communications Inc.
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
 #include "htc.h"
 
 /******************/
@@ -131,3 +147,314 @@ void ath_htc_cancel_btcoex_work(struct ath9k_htc_priv *priv)
 	cancel_delayed_work_sync(&priv->coex_period_work);
 	cancel_delayed_work_sync(&priv->duty_cycle_work);
 }
+
+/*******/
+/* LED */
+/*******/
+
+static void ath9k_led_blink_work(struct work_struct *work)
+{
+	struct ath9k_htc_priv *priv = container_of(work, struct ath9k_htc_priv,
+						   ath9k_led_blink_work.work);
+
+	if (!(priv->op_flags & OP_LED_ASSOCIATED))
+		return;
+
+	if ((priv->led_on_duration == ATH_LED_ON_DURATION_IDLE) ||
+	    (priv->led_off_duration == ATH_LED_OFF_DURATION_IDLE))
+		ath9k_hw_set_gpio(priv->ah, priv->ah->led_pin, 0);
+	else
+		ath9k_hw_set_gpio(priv->ah, priv->ah->led_pin,
+				  (priv->op_flags & OP_LED_ON) ? 1 : 0);
+
+	ieee80211_queue_delayed_work(priv->hw,
+				     &priv->ath9k_led_blink_work,
+				     (priv->op_flags & OP_LED_ON) ?
+				     msecs_to_jiffies(priv->led_off_duration) :
+				     msecs_to_jiffies(priv->led_on_duration));
+
+	priv->led_on_duration = priv->led_on_cnt ?
+		max((ATH_LED_ON_DURATION_IDLE - priv->led_on_cnt), 25) :
+		ATH_LED_ON_DURATION_IDLE;
+	priv->led_off_duration = priv->led_off_cnt ?
+		max((ATH_LED_OFF_DURATION_IDLE - priv->led_off_cnt), 10) :
+		ATH_LED_OFF_DURATION_IDLE;
+	priv->led_on_cnt = priv->led_off_cnt = 0;
+
+	if (priv->op_flags & OP_LED_ON)
+		priv->op_flags &= ~OP_LED_ON;
+	else
+		priv->op_flags |= OP_LED_ON;
+}
+
+static void ath9k_led_brightness_work(struct work_struct *work)
+{
+	struct ath_led *led = container_of(work, struct ath_led,
+					   brightness_work.work);
+	struct ath9k_htc_priv *priv = led->priv;
+
+	switch (led->brightness) {
+	case LED_OFF:
+		if (led->led_type == ATH_LED_ASSOC ||
+		    led->led_type == ATH_LED_RADIO) {
+			ath9k_hw_set_gpio(priv->ah, priv->ah->led_pin,
+					  (led->led_type == ATH_LED_RADIO));
+			priv->op_flags &= ~OP_LED_ASSOCIATED;
+			if (led->led_type == ATH_LED_RADIO)
+				priv->op_flags &= ~OP_LED_ON;
+		} else {
+			priv->led_off_cnt++;
+		}
+		break;
+	case LED_FULL:
+		if (led->led_type == ATH_LED_ASSOC) {
+			priv->op_flags |= OP_LED_ASSOCIATED;
+			ieee80211_queue_delayed_work(priv->hw,
+					     &priv->ath9k_led_blink_work, 0);
+		} else if (led->led_type == ATH_LED_RADIO) {
+			ath9k_hw_set_gpio(priv->ah, priv->ah->led_pin, 0);
+			priv->op_flags |= OP_LED_ON;
+		} else {
+			priv->led_on_cnt++;
+		}
+		break;
+	default:
+		break;
+	}
+}
+
+static void ath9k_led_brightness(struct led_classdev *led_cdev,
+				 enum led_brightness brightness)
+{
+	struct ath_led *led = container_of(led_cdev, struct ath_led, led_cdev);
+	struct ath9k_htc_priv *priv = led->priv;
+
+	led->brightness = brightness;
+	if (!(priv->op_flags & OP_LED_DEINIT))
+		ieee80211_queue_delayed_work(priv->hw,
+					     &led->brightness_work, 0);
+}
+
+void ath9k_led_stop_brightness(struct ath9k_htc_priv *priv)
+{
+	cancel_delayed_work_sync(&priv->radio_led.brightness_work);
+	cancel_delayed_work_sync(&priv->assoc_led.brightness_work);
+	cancel_delayed_work_sync(&priv->tx_led.brightness_work);
+	cancel_delayed_work_sync(&priv->rx_led.brightness_work);
+}
+
+static int ath9k_register_led(struct ath9k_htc_priv *priv, struct ath_led *led,
+			      char *trigger)
+{
+	int ret;
+
+	led->priv = priv;
+	led->led_cdev.name = led->name;
+	led->led_cdev.default_trigger = trigger;
+	led->led_cdev.brightness_set = ath9k_led_brightness;
+
+	ret = led_classdev_register(wiphy_dev(priv->hw->wiphy), &led->led_cdev);
+	if (ret)
+		ath_err(ath9k_hw_common(priv->ah),
+			"Failed to register led:%s", led->name);
+	else
+		led->registered = 1;
+
+	INIT_DELAYED_WORK(&led->brightness_work, ath9k_led_brightness_work);
+
+	return ret;
+}
+
+static void ath9k_unregister_led(struct ath_led *led)
+{
+	if (led->registered) {
+		led_classdev_unregister(&led->led_cdev);
+		led->registered = 0;
+	}
+}
+
+void ath9k_deinit_leds(struct ath9k_htc_priv *priv)
+{
+	priv->op_flags |= OP_LED_DEINIT;
+	ath9k_unregister_led(&priv->assoc_led);
+	priv->op_flags &= ~OP_LED_ASSOCIATED;
+	ath9k_unregister_led(&priv->tx_led);
+	ath9k_unregister_led(&priv->rx_led);
+	ath9k_unregister_led(&priv->radio_led);
+}
+
+void ath9k_init_leds(struct ath9k_htc_priv *priv)
+{
+	char *trigger;
+	int ret;
+
+	if (AR_SREV_9287(priv->ah))
+		priv->ah->led_pin = ATH_LED_PIN_9287;
+	else if (AR_SREV_9271(priv->ah))
+		priv->ah->led_pin = ATH_LED_PIN_9271;
+	else if (AR_DEVID_7010(priv->ah))
+		priv->ah->led_pin = ATH_LED_PIN_7010;
+	else
+		priv->ah->led_pin = ATH_LED_PIN_DEF;
+
+	/* Configure gpio 1 for output */
+	ath9k_hw_cfg_output(priv->ah, priv->ah->led_pin,
+			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
+	/* LED off, active low */
+	ath9k_hw_set_gpio(priv->ah, priv->ah->led_pin, 1);
+
+	INIT_DELAYED_WORK(&priv->ath9k_led_blink_work, ath9k_led_blink_work);
+
+	trigger = ieee80211_get_radio_led_name(priv->hw);
+	snprintf(priv->radio_led.name, sizeof(priv->radio_led.name),
+		"ath9k-%s::radio", wiphy_name(priv->hw->wiphy));
+	ret = ath9k_register_led(priv, &priv->radio_led, trigger);
+	priv->radio_led.led_type = ATH_LED_RADIO;
+	if (ret)
+		goto fail;
+
+	trigger = ieee80211_get_assoc_led_name(priv->hw);
+	snprintf(priv->assoc_led.name, sizeof(priv->assoc_led.name),
+		"ath9k-%s::assoc", wiphy_name(priv->hw->wiphy));
+	ret = ath9k_register_led(priv, &priv->assoc_led, trigger);
+	priv->assoc_led.led_type = ATH_LED_ASSOC;
+	if (ret)
+		goto fail;
+
+	trigger = ieee80211_get_tx_led_name(priv->hw);
+	snprintf(priv->tx_led.name, sizeof(priv->tx_led.name),
+		"ath9k-%s::tx", wiphy_name(priv->hw->wiphy));
+	ret = ath9k_register_led(priv, &priv->tx_led, trigger);
+	priv->tx_led.led_type = ATH_LED_TX;
+	if (ret)
+		goto fail;
+
+	trigger = ieee80211_get_rx_led_name(priv->hw);
+	snprintf(priv->rx_led.name, sizeof(priv->rx_led.name),
+		"ath9k-%s::rx", wiphy_name(priv->hw->wiphy));
+	ret = ath9k_register_led(priv, &priv->rx_led, trigger);
+	priv->rx_led.led_type = ATH_LED_RX;
+	if (ret)
+		goto fail;
+
+	priv->op_flags &= ~OP_LED_DEINIT;
+
+	return;
+
+fail:
+	cancel_delayed_work_sync(&priv->ath9k_led_blink_work);
+	ath9k_deinit_leds(priv);
+}
+
+/*******************/
+/*	Rfkill	   */
+/*******************/
+
+static bool ath_is_rfkill_set(struct ath9k_htc_priv *priv)
+{
+	return ath9k_hw_gpio_get(priv->ah, priv->ah->rfkill_gpio) ==
+		priv->ah->rfkill_polarity;
+}
+
+void ath9k_htc_rfkill_poll_state(struct ieee80211_hw *hw)
+{
+	struct ath9k_htc_priv *priv = hw->priv;
+	bool blocked = !!ath_is_rfkill_set(priv);
+
+	wiphy_rfkill_set_hw_state(hw->wiphy, blocked);
+}
+
+void ath9k_start_rfkill_poll(struct ath9k_htc_priv *priv)
+{
+	if (priv->ah->caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
+		wiphy_rfkill_start_polling(priv->hw->wiphy);
+}
+
+void ath9k_htc_radio_enable(struct ieee80211_hw *hw)
+{
+	struct ath9k_htc_priv *priv = hw->priv;
+	struct ath_hw *ah = priv->ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	int ret;
+	u8 cmd_rsp;
+
+	if (!ah->curchan)
+		ah->curchan = ath9k_cmn_get_curchannel(hw, ah);
+
+	/* Reset the HW */
+	ret = ath9k_hw_reset(ah, ah->curchan, ah->caldata, false);
+	if (ret) {
+		ath_err(common,
+			"Unable to reset hardware; reset status %d (freq %u MHz)\n",
+			ret, ah->curchan->channel);
+	}
+
+	ath_update_txpow(priv);
+
+	/* Start RX */
+	WMI_CMD(WMI_START_RECV_CMDID);
+	ath9k_host_rx_init(priv);
+
+	/* Start TX */
+	htc_start(priv->htc);
+	spin_lock_bh(&priv->tx_lock);
+	priv->tx_queues_stop = false;
+	spin_unlock_bh(&priv->tx_lock);
+	ieee80211_wake_queues(hw);
+
+	WMI_CMD(WMI_ENABLE_INTR_CMDID);
+
+	/* Enable LED */
+	ath9k_hw_cfg_output(ah, ah->led_pin,
+			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
+	ath9k_hw_set_gpio(ah, ah->led_pin, 0);
+}
+
+void ath9k_htc_radio_disable(struct ieee80211_hw *hw)
+{
+	struct ath9k_htc_priv *priv = hw->priv;
+	struct ath_hw *ah = priv->ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	int ret;
+	u8 cmd_rsp;
+
+	ath9k_htc_ps_wakeup(priv);
+
+	/* Disable LED */
+	ath9k_hw_set_gpio(ah, ah->led_pin, 1);
+	ath9k_hw_cfg_gpio_input(ah, ah->led_pin);
+
+	WMI_CMD(WMI_DISABLE_INTR_CMDID);
+
+	/* Stop TX */
+	ieee80211_stop_queues(hw);
+	htc_stop(priv->htc);
+	WMI_CMD(WMI_DRAIN_TXQ_ALL_CMDID);
+	skb_queue_purge(&priv->tx_queue);
+
+	/* Stop RX */
+	WMI_CMD(WMI_STOP_RECV_CMDID);
+
+	/*
+	 * The MIB counters have to be disabled here,
+	 * since the target doesn't do it.
+	 */
+	ath9k_hw_disable_mib_counters(ah);
+
+	if (!ah->curchan)
+		ah->curchan = ath9k_cmn_get_curchannel(hw, ah);
+
+	/* Reset the HW */
+	ret = ath9k_hw_reset(ah, ah->curchan, ah->caldata, false);
+	if (ret) {
+		ath_err(common,
+			"Unable to reset hardware; reset status %d (freq %u MHz)\n",
+			ret, ah->curchan->channel);
+	}
+
+	/* Disable the PHY */
+	ath9k_hw_phy_disable(ah);
+
+	ath9k_htc_ps_restore(priv);
+	ath9k_htc_setpower(priv, ATH9K_PM_FULL_SLEEP);
+}
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index d54adeb..f4edd72 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -24,7 +24,7 @@ static struct dentry *ath9k_debugfs_root;
 /* Utilities */
 /*************/
 
-static void ath_update_txpow(struct ath9k_htc_priv *priv)
+void ath_update_txpow(struct ath9k_htc_priv *priv)
 {
 	struct ath_hw *ah = priv->ah;
 
@@ -840,317 +840,6 @@ set_timer:
 				     msecs_to_jiffies(cal_interval));
 }
 
-/*******/
-/* LED */
-/*******/
-
-static void ath9k_led_blink_work(struct work_struct *work)
-{
-	struct ath9k_htc_priv *priv = container_of(work, struct ath9k_htc_priv,
-						   ath9k_led_blink_work.work);
-
-	if (!(priv->op_flags & OP_LED_ASSOCIATED))
-		return;
-
-	if ((priv->led_on_duration == ATH_LED_ON_DURATION_IDLE) ||
-	    (priv->led_off_duration == ATH_LED_OFF_DURATION_IDLE))
-		ath9k_hw_set_gpio(priv->ah, priv->ah->led_pin, 0);
-	else
-		ath9k_hw_set_gpio(priv->ah, priv->ah->led_pin,
-				  (priv->op_flags & OP_LED_ON) ? 1 : 0);
-
-	ieee80211_queue_delayed_work(priv->hw,
-				     &priv->ath9k_led_blink_work,
-				     (priv->op_flags & OP_LED_ON) ?
-				     msecs_to_jiffies(priv->led_off_duration) :
-				     msecs_to_jiffies(priv->led_on_duration));
-
-	priv->led_on_duration = priv->led_on_cnt ?
-		max((ATH_LED_ON_DURATION_IDLE - priv->led_on_cnt), 25) :
-		ATH_LED_ON_DURATION_IDLE;
-	priv->led_off_duration = priv->led_off_cnt ?
-		max((ATH_LED_OFF_DURATION_IDLE - priv->led_off_cnt), 10) :
-		ATH_LED_OFF_DURATION_IDLE;
-	priv->led_on_cnt = priv->led_off_cnt = 0;
-
-	if (priv->op_flags & OP_LED_ON)
-		priv->op_flags &= ~OP_LED_ON;
-	else
-		priv->op_flags |= OP_LED_ON;
-}
-
-static void ath9k_led_brightness_work(struct work_struct *work)
-{
-	struct ath_led *led = container_of(work, struct ath_led,
-					   brightness_work.work);
-	struct ath9k_htc_priv *priv = led->priv;
-
-	switch (led->brightness) {
-	case LED_OFF:
-		if (led->led_type == ATH_LED_ASSOC ||
-		    led->led_type == ATH_LED_RADIO) {
-			ath9k_hw_set_gpio(priv->ah, priv->ah->led_pin,
-					  (led->led_type == ATH_LED_RADIO));
-			priv->op_flags &= ~OP_LED_ASSOCIATED;
-			if (led->led_type == ATH_LED_RADIO)
-				priv->op_flags &= ~OP_LED_ON;
-		} else {
-			priv->led_off_cnt++;
-		}
-		break;
-	case LED_FULL:
-		if (led->led_type == ATH_LED_ASSOC) {
-			priv->op_flags |= OP_LED_ASSOCIATED;
-			ieee80211_queue_delayed_work(priv->hw,
-					     &priv->ath9k_led_blink_work, 0);
-		} else if (led->led_type == ATH_LED_RADIO) {
-			ath9k_hw_set_gpio(priv->ah, priv->ah->led_pin, 0);
-			priv->op_flags |= OP_LED_ON;
-		} else {
-			priv->led_on_cnt++;
-		}
-		break;
-	default:
-		break;
-	}
-}
-
-static void ath9k_led_brightness(struct led_classdev *led_cdev,
-				 enum led_brightness brightness)
-{
-	struct ath_led *led = container_of(led_cdev, struct ath_led, led_cdev);
-	struct ath9k_htc_priv *priv = led->priv;
-
-	led->brightness = brightness;
-	if (!(priv->op_flags & OP_LED_DEINIT))
-		ieee80211_queue_delayed_work(priv->hw,
-					     &led->brightness_work, 0);
-}
-
-static void ath9k_led_stop_brightness(struct ath9k_htc_priv *priv)
-{
-	cancel_delayed_work_sync(&priv->radio_led.brightness_work);
-	cancel_delayed_work_sync(&priv->assoc_led.brightness_work);
-	cancel_delayed_work_sync(&priv->tx_led.brightness_work);
-	cancel_delayed_work_sync(&priv->rx_led.brightness_work);
-}
-
-static int ath9k_register_led(struct ath9k_htc_priv *priv, struct ath_led *led,
-			      char *trigger)
-{
-	int ret;
-
-	led->priv = priv;
-	led->led_cdev.name = led->name;
-	led->led_cdev.default_trigger = trigger;
-	led->led_cdev.brightness_set = ath9k_led_brightness;
-
-	ret = led_classdev_register(wiphy_dev(priv->hw->wiphy), &led->led_cdev);
-	if (ret)
-		ath_err(ath9k_hw_common(priv->ah),
-			"Failed to register led:%s", led->name);
-	else
-		led->registered = 1;
-
-	INIT_DELAYED_WORK(&led->brightness_work, ath9k_led_brightness_work);
-
-	return ret;
-}
-
-static void ath9k_unregister_led(struct ath_led *led)
-{
-	if (led->registered) {
-		led_classdev_unregister(&led->led_cdev);
-		led->registered = 0;
-	}
-}
-
-void ath9k_deinit_leds(struct ath9k_htc_priv *priv)
-{
-	priv->op_flags |= OP_LED_DEINIT;
-	ath9k_unregister_led(&priv->assoc_led);
-	priv->op_flags &= ~OP_LED_ASSOCIATED;
-	ath9k_unregister_led(&priv->tx_led);
-	ath9k_unregister_led(&priv->rx_led);
-	ath9k_unregister_led(&priv->radio_led);
-}
-
-void ath9k_init_leds(struct ath9k_htc_priv *priv)
-{
-	char *trigger;
-	int ret;
-
-	if (AR_SREV_9287(priv->ah))
-		priv->ah->led_pin = ATH_LED_PIN_9287;
-	else if (AR_SREV_9271(priv->ah))
-		priv->ah->led_pin = ATH_LED_PIN_9271;
-	else if (AR_DEVID_7010(priv->ah))
-		priv->ah->led_pin = ATH_LED_PIN_7010;
-	else
-		priv->ah->led_pin = ATH_LED_PIN_DEF;
-
-	/* Configure gpio 1 for output */
-	ath9k_hw_cfg_output(priv->ah, priv->ah->led_pin,
-			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
-	/* LED off, active low */
-	ath9k_hw_set_gpio(priv->ah, priv->ah->led_pin, 1);
-
-	INIT_DELAYED_WORK(&priv->ath9k_led_blink_work, ath9k_led_blink_work);
-
-	trigger = ieee80211_get_radio_led_name(priv->hw);
-	snprintf(priv->radio_led.name, sizeof(priv->radio_led.name),
-		"ath9k-%s::radio", wiphy_name(priv->hw->wiphy));
-	ret = ath9k_register_led(priv, &priv->radio_led, trigger);
-	priv->radio_led.led_type = ATH_LED_RADIO;
-	if (ret)
-		goto fail;
-
-	trigger = ieee80211_get_assoc_led_name(priv->hw);
-	snprintf(priv->assoc_led.name, sizeof(priv->assoc_led.name),
-		"ath9k-%s::assoc", wiphy_name(priv->hw->wiphy));
-	ret = ath9k_register_led(priv, &priv->assoc_led, trigger);
-	priv->assoc_led.led_type = ATH_LED_ASSOC;
-	if (ret)
-		goto fail;
-
-	trigger = ieee80211_get_tx_led_name(priv->hw);
-	snprintf(priv->tx_led.name, sizeof(priv->tx_led.name),
-		"ath9k-%s::tx", wiphy_name(priv->hw->wiphy));
-	ret = ath9k_register_led(priv, &priv->tx_led, trigger);
-	priv->tx_led.led_type = ATH_LED_TX;
-	if (ret)
-		goto fail;
-
-	trigger = ieee80211_get_rx_led_name(priv->hw);
-	snprintf(priv->rx_led.name, sizeof(priv->rx_led.name),
-		"ath9k-%s::rx", wiphy_name(priv->hw->wiphy));
-	ret = ath9k_register_led(priv, &priv->rx_led, trigger);
-	priv->rx_led.led_type = ATH_LED_RX;
-	if (ret)
-		goto fail;
-
-	priv->op_flags &= ~OP_LED_DEINIT;
-
-	return;
-
-fail:
-	cancel_delayed_work_sync(&priv->ath9k_led_blink_work);
-	ath9k_deinit_leds(priv);
-}
-
-/*******************/
-/*	Rfkill	   */
-/*******************/
-
-static bool ath_is_rfkill_set(struct ath9k_htc_priv *priv)
-{
-	return ath9k_hw_gpio_get(priv->ah, priv->ah->rfkill_gpio) ==
-		priv->ah->rfkill_polarity;
-}
-
-static void ath9k_htc_rfkill_poll_state(struct ieee80211_hw *hw)
-{
-	struct ath9k_htc_priv *priv = hw->priv;
-	bool blocked = !!ath_is_rfkill_set(priv);
-
-	wiphy_rfkill_set_hw_state(hw->wiphy, blocked);
-}
-
-void ath9k_start_rfkill_poll(struct ath9k_htc_priv *priv)
-{
-	if (priv->ah->caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
-		wiphy_rfkill_start_polling(priv->hw->wiphy);
-}
-
-static void ath9k_htc_radio_enable(struct ieee80211_hw *hw)
-{
-	struct ath9k_htc_priv *priv = hw->priv;
-	struct ath_hw *ah = priv->ah;
-	struct ath_common *common = ath9k_hw_common(ah);
-	int ret;
-	u8 cmd_rsp;
-
-	if (!ah->curchan)
-		ah->curchan = ath9k_cmn_get_curchannel(hw, ah);
-
-	/* Reset the HW */
-	ret = ath9k_hw_reset(ah, ah->curchan, ah->caldata, false);
-	if (ret) {
-		ath_err(common,
-			"Unable to reset hardware; reset status %d (freq %u MHz)\n",
-			ret, ah->curchan->channel);
-	}
-
-	ath_update_txpow(priv);
-
-	/* Start RX */
-	WMI_CMD(WMI_START_RECV_CMDID);
-	ath9k_host_rx_init(priv);
-
-	/* Start TX */
-	htc_start(priv->htc);
-	spin_lock_bh(&priv->tx_lock);
-	priv->tx_queues_stop = false;
-	spin_unlock_bh(&priv->tx_lock);
-	ieee80211_wake_queues(hw);
-
-	WMI_CMD(WMI_ENABLE_INTR_CMDID);
-
-	/* Enable LED */
-	ath9k_hw_cfg_output(ah, ah->led_pin,
-			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
-	ath9k_hw_set_gpio(ah, ah->led_pin, 0);
-}
-
-static void ath9k_htc_radio_disable(struct ieee80211_hw *hw)
-{
-	struct ath9k_htc_priv *priv = hw->priv;
-	struct ath_hw *ah = priv->ah;
-	struct ath_common *common = ath9k_hw_common(ah);
-	int ret;
-	u8 cmd_rsp;
-
-	ath9k_htc_ps_wakeup(priv);
-
-	/* Disable LED */
-	ath9k_hw_set_gpio(ah, ah->led_pin, 1);
-	ath9k_hw_cfg_gpio_input(ah, ah->led_pin);
-
-	WMI_CMD(WMI_DISABLE_INTR_CMDID);
-
-	/* Stop TX */
-	ieee80211_stop_queues(hw);
-	htc_stop(priv->htc);
-	WMI_CMD(WMI_DRAIN_TXQ_ALL_CMDID);
-	skb_queue_purge(&priv->tx_queue);
-
-	/* Stop RX */
-	WMI_CMD(WMI_STOP_RECV_CMDID);
-
-	/*
-	 * The MIB counters have to be disabled here,
-	 * since the target doesn't do it.
-	 */
-	ath9k_hw_disable_mib_counters(ah);
-
-	if (!ah->curchan)
-		ah->curchan = ath9k_cmn_get_curchannel(hw, ah);
-
-	/* Reset the HW */
-	ret = ath9k_hw_reset(ah, ah->curchan, ah->caldata, false);
-	if (ret) {
-		ath_err(common,
-			"Unable to reset hardware; reset status %d (freq %u MHz)\n",
-			ret, ah->curchan->channel);
-	}
-
-	/* Disable the PHY */
-	ath9k_hw_phy_disable(ah);
-
-	ath9k_htc_ps_restore(priv);
-	ath9k_htc_setpower(priv, ATH9K_PM_FULL_SLEEP);
-}
-
 /**********************/
 /* mac80211 Callbacks */
 /**********************/
-- 
1.7.3.4

