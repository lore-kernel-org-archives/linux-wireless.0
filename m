Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64160 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503AbZDIEYQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Apr 2009 00:24:16 -0400
Date: Wed, 08 Apr 2009 23:23:59 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: [RFT/RFC] rtl8187: Implement TX/RX blink for LED
Message-ID: <49dd785f.mp1oc4nY+m3n0uHL%Larry.Finger@lwfinger.net> (sfid-20090409_062420_693088_CF1A52A3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following patch implements some control over the LED on RTL8187B and
RTL8187L devices. Triggers are registered for TX and RX. Whenever the
trigger event occurs, the LED is turned off for 1/20 second, then turned
back on.

Please test and comment.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/Kconfig
===================================================================
--- wireless-testing.orig/drivers/net/wireless/Kconfig
+++ wireless-testing/drivers/net/wireless/Kconfig
@@ -433,6 +433,13 @@ config RTL8187
 
 	  Thanks to Realtek for their support!
 
+# If possible, automatically enable LED's for RTL8187.
+
+config RTL8187_LEDS
+	bool
+	depends on RTL8187 && MAC80211_LEDS && (LEDS_CLASS = y || LEDS_CLASS = RTL8187)
+	default y
+
 config ADM8211
 	tristate "ADMtek ADM8211 support"
 	depends on MAC80211 && PCI && WLAN_80211 && EXPERIMENTAL
Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -29,6 +29,9 @@
 
 #include "rtl8187.h"
 #include "rtl8187_rtl8225.h"
+#ifdef CONFIG_RTL8187_LEDS
+#include "rtl8187_leds.h"
+#endif
 
 MODULE_AUTHOR("Michael Wu <flamingice@sourmilk.net>");
 MODULE_AUTHOR("Andrea Merello <andreamrl@tiscali.it>");
@@ -1506,6 +1509,10 @@ static int __devinit rtl8187_probe(struc
 	       wiphy_name(dev->wiphy), dev->wiphy->perm_addr,
 	       chip_name, priv->asic_rev, priv->rf->name);
 
+#ifdef CONFIG_RTL8187_LEDS
+	rtl8187_leds_init(dev, eeprom);
+#endif
+
 	return 0;
 
  err_free_dev:
@@ -1523,6 +1530,9 @@ static void __devexit rtl8187_disconnect
 	if (!dev)
 		return;
 
+#ifdef CONFIG_RTL8187_LEDS
+	rtl8187_leds_exit(dev);
+#endif
 	ieee80211_unregister_hw(dev);
 
 	priv = dev->priv;
Index: wireless-testing/drivers/net/wireless/rtl818x/Makefile
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/Makefile
+++ wireless-testing/drivers/net/wireless/rtl818x/Makefile
@@ -1,5 +1,5 @@
 rtl8180-objs		:= rtl8180_dev.o rtl8180_rtl8225.o rtl8180_sa2400.o rtl8180_max2820.o rtl8180_grf5101.o
-rtl8187-objs		:= rtl8187_dev.o rtl8187_rtl8225.o
+rtl8187-objs		:= rtl8187_dev.o rtl8187_rtl8225.o rtl8187_leds.o
 
 obj-$(CONFIG_RTL8180)	+= rtl8180.o
 obj-$(CONFIG_RTL8187)	+= rtl8187.o
Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_leds.c
===================================================================
--- /dev/null
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_leds.c
@@ -0,0 +1,180 @@
+/*
+ * Linux LED driver for RTL8187
+ *
+ * Copyright 2009 Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ * Based on the r8187 driver, which is:
+ * Copyright 2005 Andrea Merello <andreamrl@tiscali.it>, et al.
+ *
+ * Thanks to Realtek for their support!
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifdef CONFIG_RTL8187_LEDS
+
+#include <net/mac80211.h>
+#include <linux/usb.h>
+#include <linux/eeprom_93cx6.h>
+
+#include "rtl8187.h"
+#include "rtl8187_leds.h"
+
+static void led_turn_on(struct work_struct *work)
+{
+	u8 reg;
+	struct rtl8187_priv *priv = container_of(work, struct rtl8187_priv,
+				    led_on.work);
+	struct rtl8187_led *led = &priv->led_tx;
+
+	switch (led->ledpin) {
+	case LED_PIN_GPIO0:
+		rtl818x_iowrite8(priv, &priv->map->GPIO, 0x01);
+		rtl818x_iowrite8(priv, &priv->map->GP_ENABLE, 0x00);
+		break;
+	case LED_PIN_LED0:
+		reg = rtl818x_ioread8(priv, &priv->map->PGSELECT) & ~(1 << 4);
+		rtl818x_iowrite8(priv, &priv->map->PGSELECT, reg);
+		break;
+	case LED_PIN_LED1:
+		reg = rtl818x_ioread8(priv, &priv->map->PGSELECT) & ~(1 << 5);
+		rtl818x_iowrite8(priv, &priv->map->PGSELECT, reg);
+		break;
+	case LED_PIN_HW:
+	default:
+		break;
+	}
+}
+
+static void led_turn_off(struct work_struct *work)
+{
+	u8 reg;
+	struct rtl8187_priv *priv = container_of(work, struct rtl8187_priv,
+				    led_off.work);
+	struct rtl8187_led *led = &priv->led_tx;
+
+	switch (led->ledpin) {
+	case LED_PIN_GPIO0:
+		rtl818x_iowrite8(priv, &priv->map->GPIO, 0x01);
+		rtl818x_iowrite8(priv, &priv->map->GP_ENABLE, 0x01);
+		break;
+	case LED_PIN_LED0:
+		reg = rtl818x_ioread8(priv, &priv->map->PGSELECT) | (1 << 4);
+		rtl818x_iowrite8(priv, &priv->map->PGSELECT, reg);
+		break;
+	case LED_PIN_LED1:
+		reg = rtl818x_ioread8(priv, &priv->map->PGSELECT) | (1 << 5);
+		rtl818x_iowrite8(priv, &priv->map->PGSELECT, reg);
+		break;
+	case LED_PIN_HW:
+	default:
+		break;
+	}
+	queue_delayed_work(priv->dev->workqueue, &priv->led_on, HZ / 20);
+}
+
+/* Callback from the LED subsystem. */
+static void rtl8187_led_brightness_set(struct led_classdev *led_dev,
+				   enum led_brightness brightness)
+{
+	struct rtl8187_led *led = container_of(led_dev, struct rtl8187_led, led_dev);
+	struct ieee80211_hw *hw = led->dev;
+	struct rtl8187_priv *priv = hw->priv;
+
+	if (brightness == LED_OFF)
+		queue_delayed_work(hw->workqueue, &priv->led_off, 0);
+	else
+		queue_delayed_work(hw->workqueue, &priv->led_on, 0);
+}
+
+static int rtl8187_register_led(struct ieee80211_hw *dev, struct rtl8187_led *led,
+			    const char *name, const char *default_trigger, u8 ledpin)
+{
+	int err;
+	struct rtl8187_priv *priv = dev->priv;
+
+	if (led->dev)
+		return -EEXIST;
+	if (!default_trigger)
+		return -EINVAL;
+	led->dev = dev;
+	led->ledpin = ledpin;
+	strncpy(led->name, name, sizeof(led->name));
+
+	led->led_dev.name = led->name;
+	led->led_dev.default_trigger = default_trigger;
+	led->led_dev.brightness_set = rtl8187_led_brightness_set;
+
+	err = led_classdev_register(&priv->udev->dev, &led->led_dev);
+	if (err) {
+		printk(KERN_INFO "LEDs: Failed to register %s\n", name);
+		led->dev = NULL;
+		return err;
+	}
+	return 0;
+}
+
+static void rtl8187_unregister_led(struct rtl8187_led *led)
+{
+	if (!led->dev)
+		return;
+	led_classdev_unregister(&led->led_dev);
+	led->dev = NULL;
+}
+
+void rtl8187_leds_init(struct ieee80211_hw *dev, struct eeprom_93cx6 eeprom)
+{
+	struct rtl8187_priv *priv = dev->priv;
+	char name[RTL8187_LED_MAX_NAME_LEN + 1];
+	u16 reg;
+	u8 ledpin;
+
+	eeprom_93cx6_read(&eeprom, 0x3F, &reg);
+	printk(KERN_INFO "rtl8187: Customer ID 0x%X\n", reg & 0xFF);
+	/* According to the vendor driver, the LED operation depends on the
+	 * customer ID encoded in the EEPROM
+	 */
+	switch (reg) {
+	case EEPROM_CID_RSVD0:
+	case EEPROM_CID_RSVD1:
+	case EEPROM_CID_SERCOMM_PS:
+	case EEPROM_CID_QMI:
+	case EEPROM_CID_DELL:
+		ledpin = LED_PIN_GPIO0;
+		break;
+	case EEPROM_CID_ALPHA0:
+		ledpin = LED_PIN_LED0;
+		break;
+	case EEPROM_CID_HW:
+		ledpin = LED_PIN_HW;
+		break;
+	default:
+		ledpin = LED_PIN_GPIO0;
+	}
+
+	INIT_DELAYED_WORK(&priv->led_on, led_turn_on);
+	INIT_DELAYED_WORK(&priv->led_off, led_turn_off);
+
+	snprintf(name, sizeof(name),
+		 "rtl8187-%s::tx", wiphy_name(dev->wiphy));
+	rtl8187_register_led(dev, &priv->led_tx, name,
+			 ieee80211_get_tx_led_name(dev), ledpin);
+	snprintf(name, sizeof(name),
+		 "rtl8187-%s::rx", wiphy_name(dev->wiphy));
+	rtl8187_register_led(dev, &priv->led_rx, name,
+			 ieee80211_get_rx_led_name(dev), ledpin);
+}
+
+void rtl8187_leds_exit(struct ieee80211_hw *dev)
+{
+	struct rtl8187_priv *priv = dev->priv;
+
+	cancel_delayed_work(&priv->led_on);
+	cancel_delayed_work(&priv->led_off);
+	rtl8187_unregister_led(&priv->led_tx);
+	rtl8187_unregister_led(&priv->led_rx);
+}
+#endif /* def CONFIG_RTL8187_LED */
+
Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_leds.h
===================================================================
--- /dev/null
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_leds.h
@@ -0,0 +1,56 @@
+/*
+ * Definitions for RTL8187 leds
+ *
+ * Copyright 2009 Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ * Based on the r8187 driver, which is:
+ * Copyright 2005 Andrea Merello <andreamrl@tiscali.it>, et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef RTL8187_LED_H
+#define RTL8187_LED_H
+
+#ifdef CONFIG_RTL8187_LEDS
+
+#define RTL8187_LED_MAX_NAME_LEN	21
+
+#include <linux/leds.h>
+#include <linux/types.h>
+
+enum {
+	LED_PIN_LED0,
+	LED_PIN_LED1,
+	LED_PIN_GPIO0,
+	LED_PIN_HW
+};
+
+enum {
+	EEPROM_CID_RSVD0 = 0x00,
+	EEPROM_CID_RSVD1 = 0xFF,
+	EEPROM_CID_ALPHA0 = 0x01,
+	EEPROM_CID_SERCOMM_PS = 0x02,
+	EEPROM_CID_HW = 0x03,
+	EEPROM_CID_QMI = 0x07,
+	EEPROM_CID_DELL = 0x08
+};
+
+struct rtl8187_led {
+	struct ieee80211_hw *dev;
+	/* The LED class device */
+	struct led_classdev led_dev;
+	/* The pin/method used to control the led */
+	u8 ledpin;
+	/* The unique name string for this LED device. */
+	char name[RTL8187_LED_MAX_NAME_LEN + 1];
+};
+
+void rtl8187_leds_init(struct ieee80211_hw *dev, struct eeprom_93cx6 eeprom);
+void rtl8187_leds_exit(struct ieee80211_hw *dev);
+
+#endif /* def CONFIG_RTL8187_LED */
+
+#endif /* RTL8187_LED_H */
Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187.h
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187.h
@@ -16,6 +16,7 @@
 #define RTL8187_H
 
 #include "rtl818x.h"
+#include "rtl8187_leds.h"
 
 #define RTL8187_EEPROM_TXPWR_BASE	0x05
 #define RTL8187_EEPROM_MAC_ADDR		0x07
@@ -102,6 +103,12 @@ struct rtl8187_priv {
 	struct usb_anchor anchored;
 	struct delayed_work work;
 	struct ieee80211_hw *dev;
+#ifdef CONFIG_RTL8187_LEDS
+	struct rtl8187_led led_tx;
+	struct rtl8187_led led_rx;
+	struct delayed_work led_on;
+	struct delayed_work led_off;
+#endif
 	u16 txpwr_base;
 	u8 asic_rev;
 	u8 is_rtl8187b;
Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_rtl8225.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_rtl8225.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_rtl8225.c
@@ -18,6 +18,7 @@
 
 #include <linux/init.h>
 #include <linux/usb.h>
+#include <linux/eeprom_93cx6.h>
 #include <net/mac80211.h>
 
 #include "rtl8187.h"
