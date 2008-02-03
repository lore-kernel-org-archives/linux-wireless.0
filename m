Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:28399 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbYBCO4v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2008 09:56:51 -0500
Received: by py-out-1112.google.com with SMTP id u52so2708585pyb.10
        for <linux-wireless@vger.kernel.org>; Sun, 03 Feb 2008 06:56:50 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 15/19] rt2x00: Enable LED class support for rt2500usb/rt73usb
Date: Sun, 3 Feb 2008 15:54:11 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802031541.52167.IvDoorn@gmail.com>
In-Reply-To: <200802031541.52167.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802031554.11610.IvDoorn@gmail.com> (sfid-20080203_145658_047384_FB079D2C)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add kerneldoc for vendor request functions in rt2x00usb.
Add asynchroneous vendor request function in rt2x00usb.

With the availability of the asynchroneuous vendor request
we can now enable LED class support for rt2500usb and rt73usb.
Since LED handling is not important, it doesn't really matter
if a register call fails (This solution is better then no
LED class support at all).

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/Kconfig      |   14 ++
 drivers/net/wireless/rt2x00/rt2500usb.c  |   20 ++-
 drivers/net/wireless/rt2x00/rt2x00leds.c |  217 ++++++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00leds.h |   63 +++++++++
 drivers/net/wireless/rt2x00/rt2x00usb.c  |   52 +++++++
 drivers/net/wireless/rt2x00/rt2x00usb.h  |  129 +++++++++++++-----
 drivers/net/wireless/rt2x00/rt73usb.c    |   21 ++--
 7 files changed, 463 insertions(+), 53 deletions(-)
 create mode 100644 drivers/net/wireless/rt2x00/rt2x00leds.c
 create mode 100644 drivers/net/wireless/rt2x00/rt2x00leds.h

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index 88a6ef6..51adb2f 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -133,6 +133,13 @@ config RT2500USB
 
 	  When compiled as a module, this driver will be called "rt2500usb.ko".
 
+config RT2500USB_LEDS
+	bool "RT2500 leds support"
+	depends on RT2500USB
+	select RT2X00_LIB_LEDS
+	---help---
+	  This adds support for led triggers provided my mac80211.
+
 config RT73USB
 	tristate "Ralink rt73 usb support"
 	depends on RT2X00 && USB
@@ -143,6 +150,13 @@ config RT73USB
 
 	  When compiled as a module, this driver will be called "rt73usb.ko".
 
+config RT73USB_LEDS
+	bool "RT73 leds support"
+	depends on RT73USB
+	select RT2X00_LIB_LEDS
+	---help---
+	  This adds support for led triggers provided my mac80211.
+
 config RT2X00_LIB_DEBUGFS
 	bool "Ralink debugfs support"
 	depends on RT2X00_LIB && MAC80211_DEBUGFS
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index f10b574..7c48c10 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -291,17 +291,16 @@ static void rt2500usb_led_brightness(struct led_classdev *led_cdev,
 	unsigned int enabled = brightness != LED_OFF;
 	unsigned int activity =
 	    led->rt2x00dev->led_flags & LED_SUPPORT_ACTIVITY;
-	u16 reg;
-
-	rt2500usb_register_read(led->rt2x00dev, MAC_CSR20, &reg);
 
 	if (led->type == LED_TYPE_RADIO || led->type == LED_TYPE_ASSOC) {
-		rt2x00_set_field16(&reg, MAC_CSR20_LINK, enabled);
-		rt2x00_set_field16(&reg, MAC_CSR20_ACTIVITY,
-				   enabled && activity);
+		rt2x00_set_field16(&led->rt2x00dev->led_mcu_reg,
+				   MAC_CSR20_LINK, enabled);
+		rt2x00_set_field16(&led->rt2x00dev->led_mcu_reg,
+				   MAC_CSR20_ACTIVITY, enabled && activity);
 	}
 
-	rt2500usb_register_write(led->rt2x00dev, MAC_CSR20, reg);
+	rt2x00usb_vendor_request_async(led->rt2x00dev, USB_SINGLE_WRITE,
+				       MAC_CSR20, led->rt2x00dev->led_mcu_reg);
 }
 #else
 #define rt2500usb_led_brightness	NULL
@@ -1373,6 +1372,13 @@ static int rt2500usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 		rt2x00dev->led_flags = LED_SUPPORT_RADIO;
 		break;
 	}
+
+	/*
+	 * Store the current led register value, we need it later
+	 * in set_brightness but that is called in irq context which
+	 * means we can't use rt2500usb_register_read() at that time.
+	 */
+	rt2500usb_register_read(rt2x00dev, MAC_CSR20, &rt2x00dev->led_mcu_reg);
 #endif /* CONFIG_RT2500USB_LEDS */
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00leds.c b/drivers/net/wireless/rt2x00/rt2x00leds.c
new file mode 100644
index 0000000..9c29d17
--- /dev/null
+++ b/drivers/net/wireless/rt2x00/rt2x00leds.c
@@ -0,0 +1,217 @@
+/*
+	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
+	<http://rt2x00.serialmonkey.com>
+
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+	GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public License
+	along with this program; if not, write to the
+	Free Software Foundation, Inc.,
+	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+/*
+	Module: rt2x00lib
+	Abstract: rt2x00 led specific routines.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include "rt2x00.h"
+#include "rt2x00lib.h"
+
+void rt2x00leds_led_quality(struct rt2x00_dev *rt2x00dev, int rssi)
+{
+	if (!rt2x00dev->trigger_qual.registered)
+		return;
+
+	/*
+	 * Led handling requires a positive value for the rssi,
+	 * to do that correctly we need to add the correction.
+	 */
+	rssi += rt2x00dev->rssi_offset;
+
+	/*
+	 * Get the rssi level, this is used to convert the rssi
+	 * to a LED value inside the range LED_OFF - LED_FULL.
+	 */
+	if (rssi <= 30)
+		rssi = 0;
+	else if (rssi <= 39)
+		rssi = 1;
+	else if (rssi <= 49)
+		rssi = 2;
+	else if (rssi <= 53)
+		rssi = 3;
+	else if (rssi <= 63)
+		rssi = 4;
+	else
+		rssi = 5;
+
+	/*
+	 * Note that we must _not_ send LED_OFF since the driver
+	 * is going to calculate the value and might use it in a
+	 * division.
+	 */
+	led_trigger_event(&rt2x00dev->trigger_qual.trigger,
+			  ((LED_FULL / 6) * rssi) + 1);
+}
+
+static int rt2x00leds_register_trigger(struct rt2x00_dev *rt2x00dev,
+				       struct rt2x00_trigger *trigger,
+				       const char *name)
+{
+	int retval;
+
+	trigger->trigger.name = name;
+	retval = led_trigger_register(&trigger->trigger);
+	if (retval) {
+		ERROR(rt2x00dev, "Failed to register led trigger.\n");
+		return retval;
+	}
+
+	trigger->registered = 1;
+
+	return 0;
+}
+
+static int rt2x00leds_register_led(struct rt2x00_dev *rt2x00dev,
+				   struct rt2x00_led *led,
+				   enum led_type type,
+				   const char *name, char *trigger)
+{
+	struct device *device = wiphy_dev(rt2x00dev->hw->wiphy);
+	int retval;
+
+	led->led_dev.name = name;
+	led->led_dev.brightness_set = rt2x00dev->ops->lib->led_brightness;
+	led->led_dev.default_trigger = trigger;
+
+	retval = led_classdev_register(device, &led->led_dev);
+	if (retval) {
+		ERROR(rt2x00dev, "Failed to register led handler.\n");
+		return retval;
+	}
+
+	led->rt2x00dev = rt2x00dev;
+	led->type = type;
+	led->registered = 1;
+
+	return 0;
+}
+
+int rt2x00leds_register(struct rt2x00_dev *rt2x00dev)
+{
+	char *trigger;
+	char dev_name[16];
+	char name[32];
+	int retval;
+
+	if (!rt2x00dev->ops->lib->led_brightness)
+		return 0;
+
+	snprintf(dev_name, sizeof(dev_name), "%s-%s",
+		 rt2x00dev->ops->name, wiphy_name(rt2x00dev->hw->wiphy));
+
+	if (rt2x00dev->led_flags & LED_SUPPORT_RADIO) {
+		trigger = ieee80211_get_radio_led_name(rt2x00dev->hw);
+		snprintf(name, sizeof(name), "%s:radio", dev_name);
+
+		retval = rt2x00leds_register_led(rt2x00dev,
+						 &rt2x00dev->led_radio,
+						 LED_TYPE_RADIO,
+						 name, trigger);
+		if (retval)
+			goto exit_fail;
+	}
+
+	if (rt2x00dev->led_flags & LED_SUPPORT_ASSOC) {
+		trigger = ieee80211_get_assoc_led_name(rt2x00dev->hw);
+		snprintf(name, sizeof(name), "%s:assoc", dev_name);
+
+		retval = rt2x00leds_register_led(rt2x00dev,
+						 &rt2x00dev->led_assoc,
+						 LED_TYPE_ASSOC,
+						 name, trigger);
+		if (retval)
+			goto exit_fail;
+	}
+
+	if (rt2x00dev->led_flags & LED_SUPPORT_QUALITY) {
+		snprintf(name, sizeof(name), "%s:quality", dev_name);
+
+		retval = rt2x00leds_register_trigger(rt2x00dev,
+						     &rt2x00dev->trigger_qual,
+						     name);
+
+		retval = rt2x00leds_register_led(rt2x00dev,
+						 &rt2x00dev->led_qual,
+						 LED_TYPE_QUALITY,
+						 name, name);
+		if (retval)
+			goto exit_fail;
+	}
+
+	return 0;
+
+exit_fail:
+	rt2x00leds_unregister(rt2x00dev);
+	return retval;
+}
+
+static void rt2x00leds_unregister_trigger(struct rt2x00_trigger *trigger)
+{
+	if (!trigger->registered)
+		return;
+
+	led_trigger_unregister(&trigger->trigger);
+	trigger->registered = 0;
+}
+
+static void rt2x00leds_unregister_led(struct rt2x00_led *led)
+{
+	if (!led->registered)
+		return;
+
+	led_classdev_unregister(&led->led_dev);
+
+	led->led_dev.brightness_set(&led->led_dev, LED_OFF);
+	led->registered = 0;
+}
+
+void rt2x00leds_unregister(struct rt2x00_dev *rt2x00dev)
+{
+	rt2x00leds_unregister_trigger(&rt2x00dev->trigger_qual);
+	rt2x00leds_unregister_led(&rt2x00dev->led_qual);
+	rt2x00leds_unregister_led(&rt2x00dev->led_assoc);
+	rt2x00leds_unregister_led(&rt2x00dev->led_radio);
+}
+
+void rt2x00leds_suspend(struct rt2x00_dev *rt2x00dev)
+{
+	if (rt2x00dev->led_qual.registered)
+		led_classdev_suspend(&rt2x00dev->led_qual.led_dev);
+	if (rt2x00dev->led_assoc.registered)
+		led_classdev_suspend(&rt2x00dev->led_assoc.led_dev);
+	if (rt2x00dev->led_radio.registered)
+		led_classdev_suspend(&rt2x00dev->led_radio.led_dev);
+}
+
+void rt2x00leds_resume(struct rt2x00_dev *rt2x00dev)
+{
+	if (rt2x00dev->led_radio.registered)
+		led_classdev_resume(&rt2x00dev->led_radio.led_dev);
+	if (rt2x00dev->led_assoc.registered)
+		led_classdev_resume(&rt2x00dev->led_assoc.led_dev);
+	if (rt2x00dev->led_qual.registered)
+		led_classdev_resume(&rt2x00dev->led_qual.led_dev);
+}
diff --git a/drivers/net/wireless/rt2x00/rt2x00leds.h b/drivers/net/wireless/rt2x00/rt2x00leds.h
new file mode 100644
index 0000000..11e71e9
--- /dev/null
+++ b/drivers/net/wireless/rt2x00/rt2x00leds.h
@@ -0,0 +1,63 @@
+/*
+	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
+	<http://rt2x00.serialmonkey.com>
+
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+	GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public License
+	along with this program; if not, write to the
+	Free Software Foundation, Inc.,
+	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+/*
+	Module: rt2x00lib
+	Abstract: rt2x00 led datastructures and routines
+ */
+
+#ifndef RT2X00LEDS_H
+#define RT2X00LEDS_H
+
+/*
+* Flags used by driver to indicate which
+ * which led types are supported.
+ */
+#define LED_SUPPORT_RADIO	0x000001
+#define LED_SUPPORT_ASSOC	0x000002
+#define LED_SUPPORT_ACTIVITY	0x000004
+#define LED_SUPPORT_QUALITY	0x000008
+
+enum led_type {
+	LED_TYPE_RADIO,
+	LED_TYPE_ASSOC,
+	LED_TYPE_QUALITY,
+};
+
+#ifdef CONFIG_RT2X00_LIB_LEDS
+
+struct rt2x00_led {
+	struct rt2x00_dev *rt2x00dev;
+	struct led_classdev led_dev;
+
+	enum led_type type;
+	unsigned int registered;
+};
+
+struct rt2x00_trigger {
+	struct led_trigger trigger;
+
+	enum led_type type;
+	unsigned int registered;
+};
+
+#endif /* CONFIG_RT2X00_LIB_LEDS */
+
+#endif /* RT2X00LEDS_H */
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index fc60644..44ab216 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -122,6 +122,58 @@ int rt2x00usb_vendor_request_buff(struct rt2x00_dev *rt2x00dev,
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_vendor_request_buff);
 
+static void rt2x00usb_vendor_request_async_complete(struct urb *urb)
+{
+	/*
+	 * We're done with it, descrease usage count and let the
+	 * usb layer delete it as soon as it is done with it.
+	 */
+	usb_put_urb(urb);
+}
+
+int rt2x00usb_vendor_request_async(struct rt2x00_dev *rt2x00dev,
+				   const u8 request, const u16 offset,
+				   const u16 value)
+{
+	struct usb_device *usb_dev = rt2x00dev_usb_dev(rt2x00dev);
+	struct usb_ctrlrequest *ctrl;
+	struct urb *urb;
+	int status;
+
+	urb = usb_alloc_urb(0, GFP_NOIO);
+	if (!urb)
+		return -ENOMEM;
+
+	ctrl = kmalloc(sizeof(struct usb_ctrlrequest), GFP_NOIO);
+	if (!ctrl) {
+		status = -ENOMEM;
+		goto exit;
+	}
+
+	ctrl->bRequestType= USB_VENDOR_REQUEST_OUT;
+	ctrl->bRequest = request;
+	ctrl->wValue = cpu_to_le16p(&value);
+	ctrl->wIndex = cpu_to_le16p(&offset);
+	ctrl->wLength = 0;
+
+	usb_fill_control_urb(urb, usb_dev, usb_sndctrlpipe(usb_dev, 0),
+			     (unsigned char *)ctrl, NULL, 0,
+			     rt2x00usb_vendor_request_async_complete, NULL);
+
+	status = usb_submit_urb(urb, GFP_ATOMIC);
+	if (!status)
+		goto exit;
+
+	return 0;
+
+exit:
+	usb_put_urb(urb);
+	kfree(ctrl);
+
+	return status;
+}
+EXPORT_SYMBOL_GPL(rt2x00usb_vendor_request_async);
+
 /*
  * TX data handlers.
  */
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index af60663..275b089 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -60,34 +60,47 @@
 #define USB_VENDOR_REQUEST_IN	( USB_DIR_IN | USB_VENDOR_REQUEST )
 #define USB_VENDOR_REQUEST_OUT	( USB_DIR_OUT | USB_VENDOR_REQUEST )
 
-/*
- * USB vendor commands.
- */
-#define USB_DEVICE_MODE		0x01
-#define USB_SINGLE_WRITE	0x02
-#define USB_SINGLE_READ		0x03
-#define USB_MULTI_WRITE		0x06
-#define USB_MULTI_READ		0x07
-#define USB_EEPROM_WRITE	0x08
-#define USB_EEPROM_READ		0x09
-#define USB_LED_CONTROL		0x0a	/* RT73USB */
-#define USB_RX_CONTROL		0x0c
+/**
+ * enum rt2x00usb_vendor_request: USB vendor commands.
+ */
+enum rt2x00usb_vendor_request {
+	USB_DEVICE_MODE = 1,
+	USB_SINGLE_WRITE = 2,
+	USB_SINGLE_READ = 3,
+	USB_MULTI_WRITE = 6,
+	USB_MULTI_READ = 7,
+	USB_EEPROM_WRITE = 8,
+	USB_EEPROM_READ = 9,
+	USB_LED_CONTROL = 10, /* RT73USB */
+	USB_RX_CONTROL = 12,
+};
 
-/*
- * Device modes offset
+/**
+ * enum rt2x00usb_mode_offset: Device modes offset.
  */
-#define USB_MODE_RESET		0x01
-#define USB_MODE_UNPLUG		0x02
-#define USB_MODE_FUNCTION	0x03
-#define USB_MODE_TEST		0x04
-#define USB_MODE_SLEEP		0x07	/* RT73USB */
-#define USB_MODE_FIRMWARE	0x08	/* RT73USB */
-#define USB_MODE_WAKEUP		0x09	/* RT73USB */
+enum rt2x00usb_mode_offset {
+	USB_MODE_RESET = 1,
+	USB_MODE_UNPLUG = 2,
+	USB_MODE_FUNCTION = 3,
+	USB_MODE_TEST = 4,
+	USB_MODE_SLEEP = 7,	/* RT73USB */
+	USB_MODE_FIRMWARE = 8,	/* RT73USB */
+	USB_MODE_WAKEUP = 9,	/* RT73USB */
+};
 
-/*
- * Used to read/write from/to the device.
+/**
+ * rt2x00usb_vendor_request - Send register command to device
+ * @rt2x00dev: Pointer to &struct rt2x00_dev
+ * @request: USB vendor command (See &enum rt2x00usb_vendor_request)
+ * @requesttype: Request type &USB_VENDOR_REQUEST_*
+ * @offset: Register offset to perform action on
+ * @value: Value to write to device
+ * @buffer: Buffer where information will be read/written to by device
+ * @buffer_length: Size of &buffer
+ * @timeout: Operation timeout
+ *
  * This is the main function to communicate with the device,
- * the buffer argument _must_ either be NULL or point to
+ * the &buffer argument _must_ either be NULL or point to
  * a buffer allocated by kmalloc. Failure to do so can lead
  * to unexpected behavior depending on the architecture.
  */
@@ -97,13 +110,21 @@ int rt2x00usb_vendor_request(struct rt2x00_dev *rt2x00dev,
 			     void *buffer, const u16 buffer_length,
 			     const int timeout);
 
-/*
- * Used to read/write from/to the device.
+/**
+ * rt2x00usb_vendor_request_buff - Send register command to device (buffered)
+ * @rt2x00dev: Pointer to &struct rt2x00_dev
+ * @request: USB vendor command (See &enum rt2x00usb_vendor_request)
+ * @requesttype: Request type &USB_VENDOR_REQUEST_*
+ * @offset: Register offset to perform action on
+ * @buffer: Buffer where information will be read/written to by device
+ * @buffer_length: Size of &buffer
+ * @timeout: Operation timeout
+ *
  * This function will use a previously with kmalloc allocated cache
  * to communicate with the device. The contents of the buffer pointer
  * will be copied to this cache when writing, or read from the cache
  * when reading.
- * Buffers send to rt2x00usb_vendor_request _must_ be allocated with
+ * Buffers send to &rt2x00usb_vendor_request _must_ be allocated with
  * kmalloc. Hence the reason for using a previously allocated cache
  * which has been allocated properly.
  */
@@ -112,15 +133,32 @@ int rt2x00usb_vendor_request_buff(struct rt2x00_dev *rt2x00dev,
 				  const u16 offset, void *buffer,
 				  const u16 buffer_length, const int timeout);
 
-/*
- * A version of rt2x00usb_vendor_request_buff which must be called
- * if the usb_cache_mutex is already held. */
+/**
+ * rt2x00usb_vendor_request_buff - Send register command to device (buffered)
+ * @rt2x00dev: Pointer to &struct rt2x00_dev
+ * @request: USB vendor command (See &enum rt2x00usb_vendor_request)
+ * @requesttype: Request type &USB_VENDOR_REQUEST_*
+ * @offset: Register offset to perform action on
+ * @buffer: Buffer where information will be read/written to by device
+ * @buffer_length: Size of &buffer
+ * @timeout: Operation timeout
+ *
+ * A version of &rt2x00usb_vendor_request_buff which must be called
+ * if the usb_cache_mutex is already held.
+ */
 int rt2x00usb_vendor_req_buff_lock(struct rt2x00_dev *rt2x00dev,
 				   const u8 request, const u8 requesttype,
 				   const u16 offset, void *buffer,
 				   const u16 buffer_length, const int timeout);
 
-/*
+/**
+ * rt2x00usb_vendor_request_sw - Send single register command to device
+ * @rt2x00dev: Pointer to &struct rt2x00_dev
+ * @request: USB vendor command (See &enum rt2x00usb_vendor_request)
+ * @offset: Register offset to perform action on
+ * @value: Value to write to device
+ * @timeout: Operation timeout
+ *
  * Simple wrapper around rt2x00usb_vendor_request to write a single
  * command to the device. Since we don't use the buffer argument we
  * don't have to worry about kmalloc here.
@@ -136,7 +174,12 @@ static inline int rt2x00usb_vendor_request_sw(struct rt2x00_dev *rt2x00dev,
 					value, NULL, 0, timeout);
 }
 
-/*
+/**
+ * rt2x00usb_eeprom_read - Read eeprom from device
+ * @rt2x00dev: Pointer to &struct rt2x00_dev
+ * @eeprom: Pointer to eeprom array to store the information in
+ * @length: Number of bytes to read from the eeprom
+ *
  * Simple wrapper around rt2x00usb_vendor_request to read the eeprom
  * from the device. Note that the eeprom argument _must_ be allocated using
  * kmalloc for correct handling inside the kernel USB layer.
@@ -147,10 +190,28 @@ static inline int rt2x00usb_eeprom_read(struct rt2x00_dev *rt2x00dev,
 	int timeout = REGISTER_TIMEOUT * (lenght / sizeof(u16));
 
 	return rt2x00usb_vendor_request(rt2x00dev, USB_EEPROM_READ,
-					USB_VENDOR_REQUEST_IN, 0x0000,
-					0x0000, eeprom, lenght, timeout);
+					USB_VENDOR_REQUEST_IN, 0, 0,
+					eeprom, lenght, timeout);
 }
 
+/**
+ * rt2x00usb_vendor_request_async - Send register command to device (async)
+ * @rt2x00dev: Pointer to &struct rt2x00_dev
+ * @request: USB vendor command (See &enum rt2x00usb_vendor_request)
+ * @offset: Register offset to perform action on
+ * @value: Value to write to device
+ *
+ * Asynchroneous version of &rt2x00usb_vendor_request this is required
+ * for some routines where the driver cannot sleep because it is in
+ * irq context. Note that with this function the driver will not be
+ * notified on failure or timeout of the command. It will only be notified
+ * if the start of the command succeeded or not. This means it should not be
+ * used when the command must succeed.
+ */
+int rt2x00usb_vendor_request_async(struct rt2x00_dev *rt2x00dev,
+				   const u8 request, const u16 offset,
+				   const u16 value);
+
 /*
  * Radio handlers
  */
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 43d21aa..e970e32 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -294,28 +294,25 @@ static void rt73usb_led_brightness(struct led_classdev *led_cdev,
 		rt2x00_set_field16(&led->rt2x00dev->led_mcu_reg,
 				   MCU_LEDCS_RADIO_STATUS, enabled);
 
-		rt2x00usb_vendor_request_sw(led->rt2x00dev, USB_LED_CONTROL, 0,
-					    led->rt2x00dev->led_mcu_reg,
-					    REGISTER_TIMEOUT);
+		rt2x00usb_vendor_request_async(led->rt2x00dev, USB_LED_CONTROL,
+					       0, led->rt2x00dev->led_mcu_reg);
 	} else if (led->type == LED_TYPE_ASSOC) {
 		rt2x00_set_field16(&led->rt2x00dev->led_mcu_reg,
 				   MCU_LEDCS_LINK_BG_STATUS, bg_mode);
 		rt2x00_set_field16(&led->rt2x00dev->led_mcu_reg,
 				   MCU_LEDCS_LINK_A_STATUS, a_mode);
 
-		rt2x00usb_vendor_request_sw(led->rt2x00dev, USB_LED_CONTROL, 0,
-					    led->rt2x00dev->led_mcu_reg,
-					    REGISTER_TIMEOUT);
+		rt2x00usb_vendor_request_async(led->rt2x00dev, USB_LED_CONTROL,
+					       0, led->rt2x00dev->led_mcu_reg);
 	} else if (led->type == LED_TYPE_QUALITY) {
 		/*
 		 * The brightness is divided into 6 levels (0 - 5),
 		 * this means we need to convert the brightness
 		 * argument into the matching level within that range.
 		 */
-		rt2x00usb_vendor_request_sw(led->rt2x00dev, USB_LED_CONTROL,
-					    brightness / (LED_FULL / 6),
-					    led->rt2x00dev->led_mcu_reg,
-					    REGISTER_TIMEOUT);
+		rt2x00usb_vendor_request_async(led->rt2x00dev, USB_LED_CONTROL,
+					       brightness / (LED_FULL / 6),
+					       led->rt2x00dev->led_mcu_reg);
 	}
 }
 #else
@@ -871,7 +868,7 @@ static int rt73usb_load_firmware(struct rt2x00_dev *rt2x00dev, void *data,
 
 		rt2x00usb_vendor_request(rt2x00dev, USB_MULTI_WRITE,
 					 USB_VENDOR_REQUEST_OUT,
-					 FIRMWARE_IMAGE_BASE + i, 0x0000,
+					 FIRMWARE_IMAGE_BASE + i, 0,
 					 cache, buflen, timeout);
 
 		ptr += buflen;
@@ -884,7 +881,7 @@ static int rt73usb_load_firmware(struct rt2x00_dev *rt2x00dev, void *data,
 	 * we need to specify a long timeout time.
 	 */
 	status = rt2x00usb_vendor_request_sw(rt2x00dev, USB_DEVICE_MODE,
-					     0x0000, USB_MODE_FIRMWARE,
+					     0, USB_MODE_FIRMWARE,
 					     REGISTER_TIMEOUT_FIRMWARE);
 	if (status < 0) {
 		ERROR(rt2x00dev, "Failed to write Firmware to device.\n");
-- 
1.5.3.8

