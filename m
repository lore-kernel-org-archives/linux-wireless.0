Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44590 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758670Ab1D1Klr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 06:41:47 -0400
Received: by pzk9 with SMTP id 9so1591811pzk.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Apr 2011 03:41:47 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19897.17653.621421.380417@gargle.gargle.HOWL> (sfid-20110428_124200_962973_E9254C23)
Date: Thu, 28 Apr 2011 16:14:05 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH] ath9k_htc: Revamp LED management
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Remove all the convoluted hacks in the driver and simplify things
by making use of mac80211's LED triggers.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |   65 ++++-----
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c |  188 ++++---------------------
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |   22 +++
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    6 +-
 4 files changed, 85 insertions(+), 196 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 6bb71e3..dfc7a98 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -385,25 +385,6 @@ static inline void ath9k_htc_err_stat_rx(struct ath9k_htc_priv *priv,
 #define ATH_LED_PIN_9287            10
 #define ATH_LED_PIN_9271            15
 #define ATH_LED_PIN_7010            12
-#define ATH_LED_ON_DURATION_IDLE    350	/* in msecs */
-#define ATH_LED_OFF_DURATION_IDLE   250	/* in msecs */
-
-enum ath_led_type {
-	ATH_LED_RADIO,
-	ATH_LED_ASSOC,
-	ATH_LED_TX,
-	ATH_LED_RX
-};
-
-struct ath_led {
-	struct ath9k_htc_priv *priv;
-	struct led_classdev led_cdev;
-	enum ath_led_type led_type;
-	struct delayed_work brightness_work;
-	char name[32];
-	bool registered;
-	int brightness;
-};
 
 #define BSTUCK_THRESHOLD 10
 
@@ -437,14 +418,11 @@ void ath_htc_cancel_btcoex_work(struct ath9k_htc_priv *priv);
 
 #define OP_INVALID		   BIT(0)
 #define OP_SCANNING		   BIT(1)
-#define OP_LED_ASSOCIATED	   BIT(2)
-#define OP_LED_ON		   BIT(3)
-#define OP_ENABLE_BEACON	   BIT(4)
-#define OP_LED_DEINIT		   BIT(5)
-#define OP_BT_PRIORITY_DETECTED    BIT(6)
-#define OP_BT_SCAN                 BIT(7)
-#define OP_ANI_RUNNING             BIT(8)
-#define OP_TSF_RESET               BIT(9)
+#define OP_ENABLE_BEACON           BIT(2)
+#define OP_BT_PRIORITY_DETECTED    BIT(3)
+#define OP_BT_SCAN                 BIT(4)
+#define OP_ANI_RUNNING             BIT(5)
+#define OP_TSF_RESET               BIT(6)
 
 struct ath9k_htc_priv {
 	struct device *dev;
@@ -504,15 +482,13 @@ struct ath9k_htc_priv {
 	bool ps_enabled;
 	bool ps_idle;
 
-	struct ath_led radio_led;
-	struct ath_led assoc_led;
-	struct ath_led tx_led;
-	struct ath_led rx_led;
-	struct delayed_work ath9k_led_blink_work;
-	int led_on_duration;
-	int led_off_duration;
-	int led_on_cnt;
-	int led_off_cnt;
+#ifdef CONFIG_MAC80211_LEDS
+	enum led_brightness brightness;
+	bool led_registered;
+	char led_name[32];
+	struct led_classdev led_cdev;
+	struct work_struct led_work;
+#endif
 
 	int beaconq;
 	int cabq;
@@ -597,9 +573,24 @@ void ath9k_start_rfkill_poll(struct ath9k_htc_priv *priv);
 void ath9k_htc_rfkill_poll_state(struct ieee80211_hw *hw);
 void ath9k_htc_radio_enable(struct ieee80211_hw *hw);
 void ath9k_htc_radio_disable(struct ieee80211_hw *hw);
-void ath9k_led_stop_brightness(struct ath9k_htc_priv *priv);
+
+#ifdef CONFIG_MAC80211_LEDS
 void ath9k_init_leds(struct ath9k_htc_priv *priv);
 void ath9k_deinit_leds(struct ath9k_htc_priv *priv);
+void ath9k_led_work(struct work_struct *work);
+#else
+static inline void ath9k_init_leds(struct ath9k_htc_priv *priv)
+{
+}
+
+static inline void ath9k_deinit_leds(struct ath9k_htc_priv *priv)
+{
+}
+
+static inline void ath9k_led_work(struct work_struct *work)
+{
+}
+#endif
 
 int ath9k_htc_probe_device(struct htc_target *htc_handle, struct device *dev,
 			   u16 devid, char *product, u32 drv_info);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
index d051a42..2ea60da 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
@@ -154,140 +154,41 @@ void ath_htc_cancel_btcoex_work(struct ath9k_htc_priv *priv)
 /* LED */
 /*******/
 
-static void ath9k_led_blink_work(struct work_struct *work)
+#ifdef CONFIG_MAC80211_LEDS
+void ath9k_led_work(struct work_struct *work)
 {
-	struct ath9k_htc_priv *priv = container_of(work, struct ath9k_htc_priv,
-						   ath9k_led_blink_work.work);
-
-	if (!(priv->op_flags & OP_LED_ASSOCIATED))
-		return;
+	struct ath9k_htc_priv *priv = container_of(work,
+						   struct ath9k_htc_priv,
+						   led_work);
 
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
+	ath9k_hw_set_gpio(priv->ah, priv->ah->led_pin,
+			  (priv->brightness == LED_OFF));
 }
 
 static void ath9k_led_brightness(struct led_classdev *led_cdev,
 				 enum led_brightness brightness)
 {
-	struct ath_led *led = container_of(led_cdev, struct ath_led, led_cdev);
-	struct ath9k_htc_priv *priv = led->priv;
-
-	led->brightness = brightness;
-	if (!(priv->op_flags & OP_LED_DEINIT))
-		ieee80211_queue_delayed_work(priv->hw,
-					     &led->brightness_work, 0);
-}
+	struct ath9k_htc_priv *priv = container_of(led_cdev,
+						   struct ath9k_htc_priv,
+						   led_cdev);
 
-void ath9k_led_stop_brightness(struct ath9k_htc_priv *priv)
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
+	/* Not locked, but it's just a tiny green light..*/
+	priv->brightness = brightness;
+	ieee80211_queue_work(priv->hw, &priv->led_work);
 }
 
 void ath9k_deinit_leds(struct ath9k_htc_priv *priv)
 {
-	priv->op_flags |= OP_LED_DEINIT;
-	ath9k_unregister_led(&priv->assoc_led);
-	priv->op_flags &= ~OP_LED_ASSOCIATED;
-	ath9k_unregister_led(&priv->tx_led);
-	ath9k_unregister_led(&priv->rx_led);
-	ath9k_unregister_led(&priv->radio_led);
+	if (!priv->led_registered)
+		return;
+
+	ath9k_led_brightness(&priv->led_cdev, LED_OFF);
+	led_classdev_unregister(&priv->led_cdev);
+	cancel_work_sync(&priv->led_work);
 }
 
 void ath9k_init_leds(struct ath9k_htc_priv *priv)
 {
-	char *trigger;
 	int ret;
 
 	if (AR_SREV_9287(priv->ah))
@@ -305,48 +206,21 @@ void ath9k_init_leds(struct ath9k_htc_priv *priv)
 	/* LED off, active low */
 	ath9k_hw_set_gpio(priv->ah, priv->ah->led_pin, 1);
 
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
+	snprintf(priv->led_name, sizeof(priv->led_name),
+		"ath9k_htc-%s", wiphy_name(priv->hw->wiphy));
+	priv->led_cdev.name = priv->led_name;
+	priv->led_cdev.brightness_set = ath9k_led_brightness;
 
-	return;
+	ret = led_classdev_register(wiphy_dev(priv->hw->wiphy), &priv->led_cdev);
+	if (ret < 0)
+		return;
 
-fail:
-	cancel_delayed_work_sync(&priv->ath9k_led_blink_work);
-	ath9k_deinit_leds(priv);
+	INIT_WORK(&priv->led_work, ath9k_led_work);
+	priv->led_registered = true;
+
+	return;
 }
+#endif
 
 /*******************/
 /*	Rfkill	   */
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index d2dd5a6..bfdc8a8 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -117,6 +117,21 @@ static struct ieee80211_rate ath9k_legacy_rates[] = {
 	RATE(540, 0x0c, 0),
 };
 
+#ifdef CONFIG_MAC80211_LEDS
+static const struct ieee80211_tpt_blink ath9k_htc_tpt_blink[] = {
+	{ .throughput = 0 * 1024, .blink_time = 334 },
+	{ .throughput = 1 * 1024, .blink_time = 260 },
+	{ .throughput = 5 * 1024, .blink_time = 220 },
+	{ .throughput = 10 * 1024, .blink_time = 190 },
+	{ .throughput = 20 * 1024, .blink_time = 170 },
+	{ .throughput = 50 * 1024, .blink_time = 150 },
+	{ .throughput = 70 * 1024, .blink_time = 130 },
+	{ .throughput = 100 * 1024, .blink_time = 110 },
+	{ .throughput = 200 * 1024, .blink_time = 80 },
+	{ .throughput = 300 * 1024, .blink_time = 50 },
+};
+#endif
+
 static int ath9k_htc_wait_for_target(struct ath9k_htc_priv *priv)
 {
 	int time_left;
@@ -863,6 +878,13 @@ static int ath9k_init_device(struct ath9k_htc_priv *priv,
 	if (error != 0)
 		goto err_rx;
 
+#ifdef CONFIG_MAC80211_LEDS
+	/* must be initialized before ieee80211_register_hw */
+	priv->led_cdev.default_trigger = ieee80211_create_tpt_led_trigger(priv->hw,
+		IEEE80211_TPT_LEDTRIG_FL_RADIO, ath9k_htc_tpt_blink,
+		ARRAY_SIZE(ath9k_htc_tpt_blink));
+#endif
+
 	/* Register with mac80211 */
 	error = ieee80211_register_hw(hw);
 	if (error)
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index e9746e8..5aa104f 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1003,9 +1003,11 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
 	/* Cancel all the running timers/work .. */
 	cancel_work_sync(&priv->fatal_work);
 	cancel_work_sync(&priv->ps_work);
-	cancel_delayed_work_sync(&priv->ath9k_led_blink_work);
+
+#ifdef CONFIG_MAC80211_LEDS
+	cancel_work_sync(&priv->led_work);
+#endif
 	ath9k_htc_stop_ani(priv);
-	ath9k_led_stop_brightness(priv);
 
 	mutex_lock(&priv->mutex);
 
-- 
1.7.4.4

