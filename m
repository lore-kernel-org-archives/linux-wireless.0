Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:36369 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847AbZCFACI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2009 19:02:08 -0500
To: linux-wireless@vger.kernel.org
Subject: [PATCH 7/7 v2] p54: initial SoftLED support
Cc: "John W. Linville" <linville@tuxdriver.com>
From: Christian Lamparter <chunkeey@web.de>
Date: Fri, 6 Mar 2009 01:02:04 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200903060102.04668.chunkeey@web.de> (sfid-20090306_010213_638552_F3E6017A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds SoftLED support for all p54 devices.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
changes:
	- removed stray mutex_destroy
	- ratelimit "failed to LED" messages
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2009-03-05 15:50:10.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2009-03-06 00:56:48.000000000 +0100
@@ -21,6 +21,9 @@
 #include <linux/etherdevice.h>
 
 #include <net/mac80211.h>
+#ifdef CONFIG_MAC80211_LEDS
+#include <linux/leds.h>
+#endif /* CONFIG_MAC80211_LEDS */
 
 #include "p54.h"
 #include "p54common.h"
@@ -1865,7 +1868,7 @@ static int p54_scan(struct ieee80211_hw 
 	return -EINVAL;
 }
 
-static int p54_set_leds(struct ieee80211_hw *dev, int mode, int link, int act)
+static int p54_set_leds(struct ieee80211_hw *dev)
 {
 	struct p54_common *priv = dev->priv;
 	struct sk_buff *skb;
@@ -1876,11 +1879,11 @@ static int p54_set_leds(struct ieee80211
 	if (!skb)
 		return -ENOMEM;
 
-	led = (struct p54_led *)skb_put(skb, sizeof(*led));
-	led->mode = cpu_to_le16(mode);
-	led->led_permanent = cpu_to_le16(link);
-	led->led_temporary = cpu_to_le16(act);
-	led->duration = cpu_to_le16(1000);
+	led = (struct p54_led *) skb_put(skb, sizeof(*led));
+	led->flags = cpu_to_le16(0x0003);
+	led->mask[0] = led->mask[1] = cpu_to_le16(priv->softled_state);
+	led->delay[0] = cpu_to_le16(1);
+	led->delay[1] = cpu_to_le16(0);
 	priv->tx(dev, skb);
 	return 0;
 }
@@ -2060,6 +2063,9 @@ static int p54_start(struct ieee80211_hw
 
 	queue_delayed_work(dev->workqueue, &priv->work, 0);
 
+	priv->softled_state = 0;
+	err = p54_set_leds(dev);
+
 out:
 	mutex_unlock(&priv->conf_mutex);
 	return err;
@@ -2072,6 +2078,9 @@ static void p54_stop(struct ieee80211_hw
 	mutex_lock(&priv->conf_mutex);
 	priv->mode = NL80211_IFTYPE_UNSPECIFIED;
 	p54_setup_mac(dev);
+	priv->softled_state = 0;
+	p54_set_leds(dev);
+
 	cancel_delayed_work_sync(&priv->work);
 
 	/*
@@ -2113,7 +2122,6 @@ static int p54_add_interface(struct ieee
 
 	memcpy(priv->mac_addr, conf->mac_addr, ETH_ALEN);
 	p54_setup_mac(dev);
-	p54_set_leds(dev, 1, 0, 0);
 	mutex_unlock(&priv->conf_mutex);
 	return 0;
 }
@@ -2193,8 +2201,6 @@ static int p54_config_interface(struct i
 			goto out;
 	}
 
-	ret = p54_set_leds(dev, 1, !is_multicast_ether_addr(priv->bssid), 0);
-
 out:
 	mutex_unlock(&priv->conf_mutex);
 	return ret;
@@ -2411,6 +2417,96 @@ static int p54_set_key(struct ieee80211_
 	return 0;
 }
 
+#ifdef CONFIG_MAC80211_LEDS
+static void p54_led_brightness_set(struct led_classdev *led_dev,
+				   enum led_brightness brightness)
+{
+	struct p54_led_dev *led = container_of(led_dev, struct p54_led_dev,
+					       led_dev);
+	struct ieee80211_hw *dev = led->hw_dev;
+	struct p54_common *priv = dev->priv;
+	int err;
+
+	/* Don't toggle the LED, when the device is down. */
+	if (priv->mode == NL80211_IFTYPE_UNSPECIFIED)
+		return ;
+
+	if (brightness != LED_OFF)
+		priv->softled_state |= BIT(led->index);
+	else
+		priv->softled_state &= ~BIT(led->index);
+
+	err = p54_set_leds(dev);
+	if (err && net_ratelimit())
+		printk(KERN_ERR "%s: failed to update %s LED.\n",
+			wiphy_name(dev->wiphy), led_dev->name);
+}
+
+static int p54_register_led(struct ieee80211_hw *dev,
+			    struct p54_led_dev *led,
+			    unsigned int led_index,
+			    char *name, char *trigger)
+{
+	int err;
+
+	if (led->registered)
+		return -EEXIST;
+
+	snprintf(led->name, sizeof(led->name), "p54-%s::%s",
+		 wiphy_name(dev->wiphy), name);
+	led->hw_dev = dev;
+	led->index = led_index;
+	led->led_dev.name = led->name;
+	led->led_dev.default_trigger = trigger;
+	led->led_dev.brightness_set = p54_led_brightness_set;
+
+	err = led_classdev_register(wiphy_dev(dev->wiphy), &led->led_dev);
+	if (err)
+		printk(KERN_ERR "%s: Failed to register %s LED.\n",
+			wiphy_name(dev->wiphy), name);
+	else
+		led->registered = 1;
+
+	return err;
+}
+
+static int p54_init_leds(struct ieee80211_hw *dev)
+{
+	struct p54_common *priv = dev->priv;
+	int err;
+
+	/*
+	 * TODO:
+	 * Figure out if the EEPROM contains some hints about the number
+	 * of available/programmable LEDs of the device.
+	 * But for now, we can assume that we have two programmable LEDs.
+	 */
+
+	err = p54_register_led(dev, &priv->assoc_led, 0, "assoc",
+			       ieee80211_get_assoc_led_name(dev));
+	if (err)
+		return err;
+
+	err = p54_register_led(dev, &priv->tx_led, 1, "tx",
+			       ieee80211_get_tx_led_name(dev));
+	if (err)
+		return err;
+
+	err = p54_set_leds(dev);
+	return err;
+}
+
+static void p54_unregister_leds(struct ieee80211_hw *dev)
+{
+	struct p54_common *priv = dev->priv;
+
+	if (priv->tx_led.registered)
+		led_classdev_unregister(&priv->tx_led.led_dev);
+	if (priv->assoc_led.registered)
+		led_classdev_unregister(&priv->assoc_led.led_dev);
+}
+#endif /* CONFIG_MAC80211_LEDS */
+
 static const struct ieee80211_ops p54_ops = {
 	.tx			= p54_tx,
 	.start			= p54_start,
@@ -2491,6 +2587,12 @@ int p54_register_common(struct ieee80211
 		return err;
 	}
 
+	#ifdef CONFIG_MAC80211_LEDS
+	err = p54_init_leds(dev);
+	if (err)
+		return err;
+	#endif /* CONFIG_MAC80211_LEDS */
+
 	dev_info(pdev, "is registered as '%s'\n", wiphy_name(dev->wiphy));
 	return 0;
 }
@@ -2502,6 +2604,10 @@ void p54_free_common(struct ieee80211_hw
 	kfree(priv->iq_autocal);
 	kfree(priv->output_limit);
 	kfree(priv->curve_data);
+
+	#ifdef CONFIG_MAC80211_LEDS
+	p54_unregister_leds(dev);
+	#endif /* CONFIG_MAC80211_LEDS */
 }
 EXPORT_SYMBOL_GPL(p54_free_common);
 
diff -Nurp a/drivers/net/wireless/p54/p54common.h b/drivers/net/wireless/p54/p54common.h
--- a/drivers/net/wireless/p54/p54common.h	2009-03-05 15:26:38.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.h	2009-03-06 00:25:14.000000000 +0100
@@ -515,10 +515,9 @@ struct p54_scan_tail_rate {
 } __attribute__ ((packed));
 
 struct p54_led {
-	__le16 mode;
-	__le16 led_temporary;
-	__le16 led_permanent;
-	__le16 duration;
+	__le16 flags;
+	__le16 mask[2];
+	__le16 delay[2];
 } __attribute__ ((packed));
 
 struct p54_edcf {
diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
--- a/drivers/net/wireless/p54/p54.h	2009-03-05 15:26:38.000000000 +0100
+++ b/drivers/net/wireless/p54/p54.h	2009-03-06 00:25:14.000000000 +0100
@@ -14,6 +14,10 @@
  * published by the Free Software Foundation.
  */
 
+#ifdef CONFIG_MAC80211_LEDS
+#include <linux/leds.h>
+#endif /* CONFIG_MAC80211_LEDS */
+
 enum p54_control_frame_types {
 	P54_CONTROL_TYPE_SETUP = 0,
 	P54_CONTROL_TYPE_SCAN,
@@ -112,6 +116,21 @@ enum fw_state {
 	FW_STATE_RESETTING,
 };
 
+#ifdef CONFIG_MAC80211_LEDS
+
+#define P54_LED_MAX_NAME_LEN 31
+
+struct p54_led_dev {
+	struct ieee80211_hw *hw_dev;
+	struct led_classdev led_dev;
+	char name[P54_LED_MAX_NAME_LEN + 1];
+
+	unsigned int index;
+	unsigned int registered;
+};
+
+#endif /* CONFIG_MAC80211_LEDS */
+
 struct p54_common {
 	struct ieee80211_hw *hw;
 	u32 rx_start;
@@ -157,6 +176,12 @@ struct p54_common {
 	struct completion eeprom_comp;
 	u8 privacy_caps;
 	u8 rx_keycache_size;
+	/* LED management */
+	#ifdef CONFIG_MAC80211_LEDS
+	struct p54_led_dev assoc_led;
+	struct p54_led_dev tx_led;
+	#endif /* CONFIG_MAC80211_LEDS */
+	u16 softled_state;		/* bit field of glowing LEDs */
 };
 
 int p54_rx(struct ieee80211_hw *dev, struct sk_buff *skb);
