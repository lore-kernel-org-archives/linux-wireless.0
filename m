Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.184]:28903 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334AbYBQQgG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Feb 2008 11:36:06 -0500
Received: by mu-out-0910.google.com with SMTP id i10so1209783mue.5
        for <linux-wireless@vger.kernel.org>; Sun, 17 Feb 2008 08:36:06 -0800 (PST)
To: linville@tuxdriver.com
Subject: [PATCH 08/11] rt2x00: Remove async vendor request calls from rt2x00usb
Date: Sun, 17 Feb 2008 17:35:28 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802171730.44353.IvDoorn@gmail.com>
In-Reply-To: <200802171730.44353.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802171735.28898.IvDoorn@gmail.com> (sfid-20080217_163620_603022_C6080DA1)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The async vendor requests are a ugly hack which is not working correctly.
The proper fix for the scheduling while atomic issue is finding out why
we can't use led classes for USB drivers and fix that.

Just replace all async calls with the regular ones and print an
error for the disallowed LED configuration attempts. That will
help in determining which led class is causing the problem.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |   10 +++++-
 drivers/net/wireless/rt2x00/rt2x00usb.c |   52 -------------------------------
 drivers/net/wireless/rt2x00/rt2x00usb.h |   18 -----------
 drivers/net/wireless/rt2x00/rt73usb.c   |   23 +++++++++----
 4 files changed, 24 insertions(+), 79 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 0a5900b..d9643c5 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -292,6 +292,12 @@ static void rt2500usb_led_brightness(struct led_classdev *led_cdev,
 	unsigned int activity =
 	    led->rt2x00dev->led_flags & LED_SUPPORT_ACTIVITY;
 
+	if (in_atomic()) {
+		NOTICE(led->rt2x00dev,
+		       "Ignoring LED brightness command for led %d", led->type);
+		return;
+	}
+
 	if (led->type == LED_TYPE_RADIO || led->type == LED_TYPE_ASSOC) {
 		rt2x00_set_field16(&led->rt2x00dev->led_mcu_reg,
 				   MAC_CSR20_LINK, enabled);
@@ -299,8 +305,8 @@ static void rt2500usb_led_brightness(struct led_classdev *led_cdev,
 				   MAC_CSR20_ACTIVITY, enabled && activity);
 	}
 
-	rt2x00usb_vendor_request_async(led->rt2x00dev, USB_SINGLE_WRITE,
-				       MAC_CSR20, led->rt2x00dev->led_mcu_reg);
+	rt2500usb_register_write(led->rt2x00dev, MAC_CSR20,
+				 led->rt2x00dev->led_mcu_reg);
 }
 #else
 #define rt2500usb_led_brightness	NULL
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 89471b2..063b167 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -122,58 +122,6 @@ int rt2x00usb_vendor_request_buff(struct rt2x00_dev *rt2x00dev,
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_vendor_request_buff);
 
-static void rt2x00usb_vendor_request_async_complete(struct urb *urb)
-{
-	/*
-	 * We're done with it, descrease usage count and let the
-	 * usb layer delete it as soon as it is done with it.
-	 */
-	usb_put_urb(urb);
-}
-
-int rt2x00usb_vendor_request_async(struct rt2x00_dev *rt2x00dev,
-				   const u8 request, const u16 offset,
-				   const u16 value)
-{
-	struct usb_device *usb_dev = rt2x00dev_usb_dev(rt2x00dev);
-	struct usb_ctrlrequest *ctrl;
-	struct urb *urb;
-	int status;
-
-	urb = usb_alloc_urb(0, GFP_NOIO);
-	if (!urb)
-		return -ENOMEM;
-
-	ctrl = kmalloc(sizeof(struct usb_ctrlrequest), GFP_NOIO);
-	if (!ctrl) {
-		status = -ENOMEM;
-		goto exit;
-	}
-
-	ctrl->bRequestType= USB_VENDOR_REQUEST_OUT;
-	ctrl->bRequest = request;
-	ctrl->wValue = cpu_to_le16p(&value);
-	ctrl->wIndex = cpu_to_le16p(&offset);
-	ctrl->wLength = 0;
-
-	usb_fill_control_urb(urb, usb_dev, usb_sndctrlpipe(usb_dev, 0),
-			     (unsigned char *)ctrl, NULL, 0,
-			     rt2x00usb_vendor_request_async_complete, NULL);
-
-	status = usb_submit_urb(urb, GFP_ATOMIC);
-	if (!status)
-		goto exit;
-
-	return 0;
-
-exit:
-	usb_put_urb(urb);
-	kfree(ctrl);
-
-	return status;
-}
-EXPORT_SYMBOL_GPL(rt2x00usb_vendor_request_async);
-
 /*
  * TX data handlers.
  */
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index 275b089..11e5518 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -194,24 +194,6 @@ static inline int rt2x00usb_eeprom_read(struct rt2x00_dev *rt2x00dev,
 					eeprom, lenght, timeout);
 }
 
-/**
- * rt2x00usb_vendor_request_async - Send register command to device (async)
- * @rt2x00dev: Pointer to &struct rt2x00_dev
- * @request: USB vendor command (See &enum rt2x00usb_vendor_request)
- * @offset: Register offset to perform action on
- * @value: Value to write to device
- *
- * Asynchroneous version of &rt2x00usb_vendor_request this is required
- * for some routines where the driver cannot sleep because it is in
- * irq context. Note that with this function the driver will not be
- * notified on failure or timeout of the command. It will only be notified
- * if the start of the command succeeded or not. This means it should not be
- * used when the command must succeed.
- */
-int rt2x00usb_vendor_request_async(struct rt2x00_dev *rt2x00dev,
-				   const u8 request, const u16 offset,
-				   const u16 value);
-
 /*
  * Radio handlers
  */
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index cae4b02..7d6ee97 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -290,29 +290,38 @@ static void rt73usb_led_brightness(struct led_classdev *led_cdev,
 	unsigned int bg_mode =
 	    (enabled && led->rt2x00dev->curr_band == IEEE80211_BAND_2GHZ);
 
+	if (in_atomic()) {
+		NOTICE(led->rt2x00dev,
+		       "Ignoring LED brightness command for led %d", led->type);
+		return;
+	}
+
 	if (led->type == LED_TYPE_RADIO) {
 		rt2x00_set_field16(&led->rt2x00dev->led_mcu_reg,
 				   MCU_LEDCS_RADIO_STATUS, enabled);
 
-		rt2x00usb_vendor_request_async(led->rt2x00dev, USB_LED_CONTROL,
-					       0, led->rt2x00dev->led_mcu_reg);
+		rt2x00usb_vendor_request_sw(led->rt2x00dev, USB_LED_CONTROL,
+					    0, led->rt2x00dev->led_mcu_reg,
+					    REGISTER_TIMEOUT);
 	} else if (led->type == LED_TYPE_ASSOC) {
 		rt2x00_set_field16(&led->rt2x00dev->led_mcu_reg,
 				   MCU_LEDCS_LINK_BG_STATUS, bg_mode);
 		rt2x00_set_field16(&led->rt2x00dev->led_mcu_reg,
 				   MCU_LEDCS_LINK_A_STATUS, a_mode);
 
-		rt2x00usb_vendor_request_async(led->rt2x00dev, USB_LED_CONTROL,
-					       0, led->rt2x00dev->led_mcu_reg);
+		rt2x00usb_vendor_request_sw(led->rt2x00dev, USB_LED_CONTROL,
+					    0, led->rt2x00dev->led_mcu_reg,
+					    REGISTER_TIMEOUT);
 	} else if (led->type == LED_TYPE_QUALITY) {
 		/*
 		 * The brightness is divided into 6 levels (0 - 5),
 		 * this means we need to convert the brightness
 		 * argument into the matching level within that range.
 		 */
-		rt2x00usb_vendor_request_async(led->rt2x00dev, USB_LED_CONTROL,
-					       brightness / (LED_FULL / 6),
-					       led->rt2x00dev->led_mcu_reg);
+		rt2x00usb_vendor_request_sw(led->rt2x00dev, USB_LED_CONTROL,
+					    brightness / (LED_FULL / 6),
+					    led->rt2x00dev->led_mcu_reg,
+					    REGISTER_TIMEOUT);
 	}
 }
 #else
-- 
1.5.4

