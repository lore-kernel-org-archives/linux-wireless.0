Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:42610 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbZDQA44 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 20:56:56 -0400
Date: Thu, 16 Apr 2009 19:56:38 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] rtl8187: Implement TX/RX blink for LED
Message-ID: <49e7d3c6.lzheCvQxbBEom6sW%Larry.Finger@lwfinger.net> (sfid-20090417_025701_154053_3B93B18D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following patch implements some control over the LED on RTL8187B and
RTL8187L devices. Triggers are registered for TX and RX. Whenever the
trigger event occurs, the LED is turned off for 1/20 second, then turned
back on.

Note: For those RTL8187X devices that are built into the computer and have
a LED that is expected to be controlled with a radio switch, this patch will
not operate that LED. That will take a separate patch to be prepared later.


Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Tested-by: Hin-Tak Leung <htl10@users.sourceforge.net>
---

John,

This is 2.6.31 material.

Larry
---

Index: wireless-testing/drivers/net/wireless/Kconfig
===================================================================
--- wireless-testing.orig/drivers/net/wireless/Kconfig
+++ wireless-testing/drivers/net/wireless/Kconfig
@@ -433,6 +433,13 @@ config RTL8187
 
 	  Thanks to Realtek for their support!
 
+# If possible, automatically enable LEDs for RTL8187.
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
@@ -729,10 +732,10 @@ static const u8 rtl8187b_reg_table[][3]
 	{0x85, 0x24, 0}, {0x88, 0x54, 0}, {0x8B, 0xB8, 0}, {0x8C, 0x07, 0},
 	{0x8D, 0x00, 0}, {0x94, 0x1B, 0}, {0x95, 0x12, 0}, {0x96, 0x00, 0},
 	{0x97, 0x06, 0}, {0x9D, 0x1A, 0}, {0x9F, 0x10, 0}, {0xB4, 0x22, 0},
-	{0xBE, 0x80, 0}, {0xDB, 0x00, 0}, {0xEE, 0x00, 0}, {0x91, 0x03, 0},
+	{0xBE, 0x80, 0}, {0xDB, 0x00, 0}, {0xEE, 0x00, 0}, {0x4C, 0x00, 2},
 
-	{0x4C, 0x00, 2}, {0x9F, 0x00, 3}, {0x8C, 0x01, 0}, {0x8D, 0x10, 0},
-	{0x8E, 0x08, 0}, {0x8F, 0x00, 0}
+	{0x9F, 0x00, 3}, {0x8C, 0x01, 0}, {0x8D, 0x10, 0}, {0x8E, 0x08, 0},
+	{0x8F, 0x00, 0}
 };
 
 static int rtl8187b_init_hw(struct ieee80211_hw *dev)
@@ -1498,6 +1501,12 @@ static int __devinit rtl8187_probe(struc
 	       wiphy_name(dev->wiphy), dev->wiphy->perm_addr,
 	       chip_name, priv->asic_rev, priv->rf->name);
 
+#ifdef CONFIG_RTL8187_LEDS
+	eeprom_93cx6_read(&eeprom, 0x3F, &reg);
+	reg &= 0xFF;
+	rtl8187_leds_init(dev, reg);
+#endif
+
 	return 0;
 
  err_free_dev:
@@ -1515,6 +1524,9 @@ static void __devexit rtl8187_disconnect
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
@@ -0,0 +1,218 @@
+/*
+ * Linux LED driver for RTL8187
+ *
+ * Copyright 2009 Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ * Based on the LED handling in the r8187 driver, which is:
+ * Copyright (c) Realtek Semiconductor Corp. All rights reserved.
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
+	/* As this routine does read/write operations on the hardware, it must
+	 * be run from a work queue.
+	 */
+	u8 reg;
+	struct rtl8187_priv *priv = container_of(work, struct rtl8187_priv,
+				    led_on.work);
+	struct rtl8187_led *led = &priv->led_tx;
+
+	/* Don't change the LED, when the device is down. */
+	if (priv->mode == NL80211_IFTYPE_UNSPECIFIED)
+		return ;
+
+	/* Skip if the LED is not registered. */
+	if (!led->dev)
+		return;
+	mutex_lock(&priv->conf_mutex);
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
+	mutex_unlock(&priv->conf_mutex);
+}
+
+static void led_turn_off(struct work_struct *work)
+{
+	/* As this routine does read/write operations on the hardware, it must
+	 * be run from a work queue.
+	 */
+	u8 reg;
+	struct rtl8187_priv *priv = container_of(work, struct rtl8187_priv,
+				    led_off.work);
+	struct rtl8187_led *led = &priv->led_tx;
+
+	/* Don't change the LED, when the device is down. */
+	if (priv->mode == NL80211_IFTYPE_UNSPECIFIED)
+		return ;
+
+	/* Skip if the LED is not registered. */
+	if (!led->dev)
+		return;
+	mutex_lock(&priv->conf_mutex);
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
+	mutex_unlock(&priv->conf_mutex);
+}
+
+/* Callback from the LED subsystem. */
+static void rtl8187_led_brightness_set(struct led_classdev *led_dev,
+				   enum led_brightness brightness)
+{
+	struct rtl8187_led *led = container_of(led_dev, struct rtl8187_led,
+					       led_dev);
+	struct ieee80211_hw *hw = led->dev;
+	struct rtl8187_priv *priv = hw->priv;
+
+	if (brightness == LED_OFF) {
+		queue_delayed_work(hw->workqueue, &priv->led_off, 0);
+		/* The LED is off for 1/20 sec so that it just blinks. */
+		queue_delayed_work(hw->workqueue, &priv->led_on, HZ / 20);
+	} else
+		queue_delayed_work(hw->workqueue, &priv->led_on, 0);
+}
+
+static int rtl8187_register_led(struct ieee80211_hw *dev,
+				struct rtl8187_led *led, const char *name,
+				const char *default_trigger, u8 ledpin)
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
+	led_classdev_unregister(&led->led_dev);
+	led->dev = NULL;
+}
+
+void rtl8187_leds_init(struct ieee80211_hw *dev, u16 custid)
+{
+	struct rtl8187_priv *priv = dev->priv;
+	char name[RTL8187_LED_MAX_NAME_LEN + 1];
+	u8 ledpin;
+	int err;
+
+	/* According to the vendor driver, the LED operation depends on the
+	 * customer ID encoded in the EEPROM
+	 */
+	printk(KERN_INFO "rtl8187: Customer ID is 0x%02X\n", custid);
+	switch (custid) {
+	case EEPROM_CID_RSVD0:
+	case EEPROM_CID_RSVD1:
+	case EEPROM_CID_SERCOMM_PS:
+	case EEPROM_CID_QMI:
+	case EEPROM_CID_DELL:
+	case EEPROM_CID_TOSHIBA:
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
+	err = rtl8187_register_led(dev, &priv->led_tx, name,
+			 ieee80211_get_tx_led_name(dev), ledpin);
+	if (err)
+		goto error;
+	snprintf(name, sizeof(name),
+		 "rtl8187-%s::rx", wiphy_name(dev->wiphy));
+	err = rtl8187_register_led(dev, &priv->led_rx, name,
+			 ieee80211_get_rx_led_name(dev), ledpin);
+	if (!err) {
+		queue_delayed_work(dev->workqueue, &priv->led_on, 0);
+		return;
+	}
+	/* registration of RX LED failed - unregister TX */
+	rtl8187_unregister_led(&priv->led_tx);
+error:
+	/* If registration of either failed, cancel delayed work */
+	cancel_delayed_work_sync(&priv->led_off);
+	cancel_delayed_work_sync(&priv->led_on);
+}
+
+void rtl8187_leds_exit(struct ieee80211_hw *dev)
+{
+	struct rtl8187_priv *priv = dev->priv;
+
+	rtl8187_unregister_led(&priv->led_tx);
+	/* turn the LED off before exiting */
+	queue_delayed_work(dev->workqueue, &priv->led_off, 0);
+	cancel_delayed_work_sync(&priv->led_off);
+	rtl8187_unregister_led(&priv->led_rx);
+}
+#endif /* def CONFIG_RTL8187_LED */
+
Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_leds.h
===================================================================
--- /dev/null
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_leds.h
@@ -0,0 +1,57 @@
+/*
+ * Definitions for RTL8187 leds
+ *
+ * Copyright 2009 Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ * Based on the LED handling in the r8187 driver, which is:
+ * Copyright (c) Realtek Semiconductor Corp. All rights reserved.
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
+	EEPROM_CID_TOSHIBA = 0x04,
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
+void rtl8187_leds_init(struct ieee80211_hw *dev, u16 code);
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
