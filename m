Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:38782 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756955AbZCYCJi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 22:09:38 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] p54: more SoftLED updates
Date: Wed, 25 Mar 2009 03:12:18 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200903250312.18264.chunkeey@web.de> (sfid-20090325_030944_693121_59AFCCD2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch hopefully finishes the SoftLED code:
- It adds two more LEDs (rx and radio). 
  (the FW claims it can support up to 16 LEDs,
   but I doubt that any vendor put more than 4 on a board)
- update the LEDs in a _delayed_ workqueue.
  No one reported any more crashes. 
  (see: "PATCH] p54: fix race condition in memory management")
  So we can stop burning the mm code.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
index 04d95a1..0954044 100644
--- a/drivers/net/wireless/p54/p54.h
+++ b/drivers/net/wireless/p54/p54.h
@@ -125,6 +125,7 @@ struct p54_led_dev {
 	struct led_classdev led_dev;
 	char name[P54_LED_MAX_NAME_LEN + 1];
 
+	unsigned int toggled;
 	unsigned int index;
 	unsigned int registered;
 };
@@ -187,8 +188,8 @@ struct p54_common {
 
 	/* LED management */
 #ifdef CONFIG_P54_LEDS
-	struct p54_led_dev assoc_led;
-	struct p54_led_dev tx_led;
+	struct p54_led_dev leds[4];
+	struct delayed_work led_work;
 #endif /* CONFIG_P54_LEDS */
 	u16 softled_state;		/* bit field of glowing LEDs */
 
diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
index 0c1b057..3766d33 100644
--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -2088,6 +2088,9 @@ static void p54_stop(struct ieee80211_hw *dev)
 	priv->softled_state = 0;
 	p54_set_leds(dev);
 
+#ifdef CONFIG_P54_LEDS
+	cancel_delayed_work_sync(&priv->led_work);
+#endif /* CONFIG_P54_LEDS */
 	cancel_delayed_work_sync(&priv->work);
 	if (priv->cached_beacon)
 		p54_tx_cancel(dev, priv->cached_beacon);
@@ -2421,6 +2424,43 @@ static int p54_set_key(struct ieee80211_hw *dev, enum set_key_cmd cmd,
 }
 
 #ifdef CONFIG_P54_LEDS
+static void p54_update_leds(struct work_struct *work)
+{
+	struct p54_common *priv = container_of(work, struct p54_common,
+					       led_work.work);
+	int err, i, tmp, blink_delay = 400;
+	bool rerun = false;
+
+	/* Don't toggle the LED, when the device is down. */
+	if (priv->mode == NL80211_IFTYPE_UNSPECIFIED)
+		return ;
+
+	for (i = 0; i < ARRAY_SIZE(priv->leds); i++)
+		if (priv->leds[i].toggled) {
+			priv->softled_state |= BIT(i);
+
+			tmp = 70 + 200 / (priv->leds[i].toggled);
+			if (tmp < blink_delay)
+				blink_delay = tmp;
+
+			if (priv->leds[i].led_dev.brightness == LED_OFF)
+				rerun = true;
+
+			priv->leds[i].toggled =
+				!!priv->leds[i].led_dev.brightness;
+		} else
+			priv->softled_state &= ~BIT(i);
+
+	err = p54_set_leds(priv->hw);
+	if (err && net_ratelimit())
+		printk(KERN_ERR "%s: failed to update LEDs.\n",
+			wiphy_name(priv->hw->wiphy));
+
+	if (rerun)
+		queue_delayed_work(priv->hw->workqueue, &priv->led_work,
+			msecs_to_jiffies(blink_delay));
+}
+
 static void p54_led_brightness_set(struct led_classdev *led_dev,
 				   enum led_brightness brightness)
 {
@@ -2428,28 +2468,23 @@ static void p54_led_brightness_set(struct led_classdev *led_dev,
 					       led_dev);
 	struct ieee80211_hw *dev = led->hw_dev;
 	struct p54_common *priv = dev->priv;
-	int err;
 
-	/* Don't toggle the LED, when the device is down. */
 	if (priv->mode == NL80211_IFTYPE_UNSPECIFIED)
 		return ;
 
-	if (brightness != LED_OFF)
-		priv->softled_state |= BIT(led->index);
-	else
-		priv->softled_state &= ~BIT(led->index);
-
-	err = p54_set_leds(dev);
-	if (err && net_ratelimit())
-		printk(KERN_ERR "%s: failed to update %s LED.\n",
-			wiphy_name(dev->wiphy), led_dev->name);
+	if (brightness) {
+		led->toggled++;
+		queue_delayed_work(priv->hw->workqueue, &priv->led_work,
+				   HZ/10);
+	}
 }
 
 static int p54_register_led(struct ieee80211_hw *dev,
-			    struct p54_led_dev *led,
 			    unsigned int led_index,
 			    char *name, char *trigger)
 {
+	struct p54_common *priv = dev->priv;
+	struct p54_led_dev *led = &priv->leds[led_index];
 	int err;
 
 	if (led->registered)
@@ -2482,19 +2517,30 @@ static int p54_init_leds(struct ieee80211_hw *dev)
 	 * TODO:
 	 * Figure out if the EEPROM contains some hints about the number
 	 * of available/programmable LEDs of the device.
-	 * But for now, we can assume that we have two programmable LEDs.
 	 */
 
-	err = p54_register_led(dev, &priv->assoc_led, 0, "assoc",
+	INIT_DELAYED_WORK(&priv->led_work, p54_update_leds);
+
+	err = p54_register_led(dev, 0, "assoc",
 			       ieee80211_get_assoc_led_name(dev));
 	if (err)
 		return err;
 
-	err = p54_register_led(dev, &priv->tx_led, 1, "tx",
+	err = p54_register_led(dev, 1, "tx",
 			       ieee80211_get_tx_led_name(dev));
 	if (err)
 		return err;
 
+	err = p54_register_led(dev, 2, "rx",
+			       ieee80211_get_rx_led_name(dev));
+	if (err)
+		return err;
+
+	err = p54_register_led(dev, 3, "radio",
+			       ieee80211_get_radio_led_name(dev));
+	if (err)
+		return err;
+
 	err = p54_set_leds(dev);
 	return err;
 }
@@ -2502,11 +2548,11 @@ static int p54_init_leds(struct ieee80211_hw *dev)
 static void p54_unregister_leds(struct ieee80211_hw *dev)
 {
 	struct p54_common *priv = dev->priv;
+	int i;
 
-	if (priv->tx_led.registered)
-		led_classdev_unregister(&priv->tx_led.led_dev);
-	if (priv->assoc_led.registered)
-		led_classdev_unregister(&priv->assoc_led.led_dev);
+	for (i = 0; i < ARRAY_SIZE(priv->leds); i++)
+		if (priv->leds[i].registered)
+			led_classdev_unregister(&priv->leds[i].led_dev);
 }
 #endif /* CONFIG_P54_LEDS */
 
