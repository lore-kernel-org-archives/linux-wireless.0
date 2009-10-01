Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:39311 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbZJAOyV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2009 10:54:21 -0400
Received: by fxm27 with SMTP id 27so134407fxm.17
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2009 07:54:24 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Malte Gell <malte.gell@gmx.de>
Subject: Re: [PATCH] ar9170usb: LEDs are confused
Date: Thu, 1 Oct 2009 16:54:10 +0200
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, linville@tuxdriver.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910011654.10963.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2009-10-01 06:32 AM, Malte Gell wrote:
>I first noticed the LEDs are confused,
no, the LED colors is not _confused_ at all.
This is simply different on.... well, you know: on a per-device base!

For example: The Netgear uses a single bi-color LED for their WNDA3100 stick.
It glows blue or/and orange depending on the selected band and current
operation mode and state...

No idea why they didn't stick to the usual red/green mix.
Maybe because someone told the hw-devs about the existence of
red/green colorblind people??!

The original vendor driver (located: drivers/staging/otus/80211core/ledmgr.c)
goes to great lengths to describe what's behind the variety of
blinking signals. Which is nice, if you like expensive light shows...

>when I ran my AVM Fritz USBN N under Windows,
>where the LEDs had the right order. I made a little patch that put 
>the assoc and the tx LEDs in the right order.
FYI: you can assign the LEDs under "/sys/class/leds/" with a different tigger
without messing with the kernel source... An up-to-date README can be found in
the kernel's documentation directory: Documentation/leds-class.txt ,
or you can look it up online as well:
http://www.mjmwired.net/kernel/Documentation/leds-class.txt (from 2.6.31)

but back to the patch and the problem with the wide diversity of
over-customized solutions for a direct feedback mechanism to the
mindful human operator...

what about the (inline) _attached_ approach?
Sure, this idea needs some more code... but, it covers all/most 
possible scenarios from beloved "no, no, no" vendors.
---
From: Christian Lamparter <chunkeey@googlemail.com>
Subject: [PATCH] ar9170usb: flexible LED mapping

This patch adds two more quirk flags which are useful to:

 - reduce the number of virtual/ghost LEDs
   ( for low-budget devices: Netgear WN111 v2 )
 - select an alternative LED mapping.
   ( for AVM FRITZ!WLAN USB Stick N )

Reported-by: Malte Gell <malte.gell@gmx.de>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/ath/ar9170/ar9170.h b/drivers/net/wireless/ath/ar9170/ar9170.h
index ec034af..a451bb1 100644
--- a/drivers/net/wireless/ath/ar9170/ar9170.h
+++ b/drivers/net/wireless/ath/ar9170/ar9170.h
@@ -155,6 +155,12 @@ struct ar9170_sta_tid {
 #define AR9170_NUM_TX_STATUS		128
 #define AR9170_NUM_TX_AGG_MAX		30
 
+enum ar9170_quirks {
+	AR9170_REQ_FW1_ONLY = BIT(0),
+	AR9170_ONLY_ONE_LED = BIT(1),
+	AR9170_SWAPPED_LEDS = BIT(2),
+};
+
 struct ar9170 {
 	struct ieee80211_hw *hw;
 	struct ath_common common;
@@ -241,6 +247,9 @@ struct ar9170 {
 	/* (cached) HW A-MPDU settings */
 	u8 global_ampdu_density;
 	u8 global_ampdu_factor;
+
+	/* device quirks */
+	unsigned long quirks;
 };
 
 struct ar9170_sta_info {
diff --git a/drivers/net/wireless/ath/ar9170/led.c b/drivers/net/wireless/ath/ar9170/led.c
index 86c4e79..36ab738 100644
--- a/drivers/net/wireless/ath/ar9170/led.c
+++ b/drivers/net/wireless/ath/ar9170/led.c
@@ -155,18 +155,30 @@ void ar9170_unregister_leds(struct ar9170 *ar)
 	cancel_delayed_work_sync(&ar->led_work);
 }
 
+const static int std_led_map[AR9170_NUM_LEDS] = { 0, 1 };
+const static int avm_led_map[AR9170_NUM_LEDS] = { 1, 0 };
+
 int ar9170_register_leds(struct ar9170 *ar)
 {
+	const int *led_map;
 	int err;
 
+	if (ar->quirks & AR9170_SWAPPED_LEDS)
+		led_map = avm_led_map;
+	else
+		led_map = std_led_map;
+
 	INIT_DELAYED_WORK(&ar->led_work, ar9170_update_leds);
 
-	err = ar9170_register_led(ar, 0, "tx",
+	err = ar9170_register_led(ar, led_map[0], "tx",
 				  ieee80211_get_tx_led_name(ar->hw));
 	if (err)
 		goto fail;
 
-	err = ar9170_register_led(ar, 1, "assoc",
+	if (ar->quirks & AR9170_ONLY_ONE_LED)
+		return 0;
+
+	err = ar9170_register_led(ar, led_map[1], "assoc",
 				 ieee80211_get_assoc_led_name(ar->hw));
 	if (err)
 		goto fail;
diff --git a/drivers/net/wireless/ath/ar9170/usb.c b/drivers/net/wireless/ath/ar9170/usb.c
index e974e58..3be19e4 100644
--- a/drivers/net/wireless/ath/ar9170/usb.c
+++ b/drivers/net/wireless/ath/ar9170/usb.c
@@ -55,10 +55,6 @@ MODULE_FIRMWARE("ar9170.fw");
 MODULE_FIRMWARE("ar9170-1.fw");
 MODULE_FIRMWARE("ar9170-2.fw");
 
-enum ar9170_requirements {
-	AR9170_REQ_FW1_ONLY = 1,
-};
-
 static struct usb_device_id ar9170_usb_ids[] = {
 	/* Atheros 9170 */
 	{ USB_DEVICE(0x0cf3, 0x9170) },
@@ -73,7 +69,7 @@ static struct usb_device_id ar9170_usb_ids[] = {
 	/* Netgear WNDA3100 */
 	{ USB_DEVICE(0x0846, 0x9010) },
 	/* Netgear WN111 v2 */
-	{ USB_DEVICE(0x0846, 0x9001) },
+	{ USB_DEVICE(0x0846, 0x9001), .driver_info = AR9170_ONLY_ONE_LED },
 	/* Zydas ZD1221 */
 	{ USB_DEVICE(0x0ace, 0x1221) },
 	/* ZyXEL NWD271N */
@@ -89,7 +85,7 @@ static struct usb_device_id ar9170_usb_ids[] = {
 	/* IO-Data WNGDNUS2 */
 	{ USB_DEVICE(0x04bb, 0x093f) },
 	/* AVM FRITZ!WLAN USB Stick N */
-	{ USB_DEVICE(0x057C, 0x8401) },
+	{ USB_DEVICE(0x057C, 0x8401), .driver_info = AR9170_SWAPPED_LEDS },
 	/* AVM FRITZ!WLAN USB Stick N 2.4 */
 	{ USB_DEVICE(0x057C, 0x8402), .driver_info = AR9170_REQ_FW1_ONLY },
 
@@ -589,7 +585,7 @@ static int ar9170_usb_request_firmware(struct ar9170_usb *aru)
 		return 0;
 	}
 
-	if (aru->req_one_stage_fw) {
+	if (aru->common.quirks & AR9170_REQ_FW1_ONLY) {
 		dev_err(&aru->udev->dev, "ar9170.fw firmware file "
 			"not found and is required for this device\n");
 		return -EINVAL;
@@ -753,15 +749,6 @@ err_out:
 	return err;
 }
 
-static bool ar9170_requires_one_stage(const struct usb_device_id *id)
-{
-	if (!id->driver_info)
-		return false;
-	if (id->driver_info == AR9170_REQ_FW1_ONLY)
-		return true;
-	return false;
-}
-
 static int ar9170_usb_probe(struct usb_interface *intf,
 			const struct usb_device_id *id)
 {
@@ -781,8 +768,7 @@ static int ar9170_usb_probe(struct usb_interface *intf,
 	aru->udev = udev;
 	aru->intf = intf;
 	ar = &aru->common;
-
-	aru->req_one_stage_fw = ar9170_requires_one_stage(id);
+	ar->quirks = id->driver_info;
 
 	usb_set_intfdata(intf, aru);
 	SET_IEEE80211_DEV(ar->hw, &intf->dev);
diff --git a/drivers/net/wireless/ath/ar9170/usb.h b/drivers/net/wireless/ath/ar9170/usb.h
index d098f4d..714436d 100644
--- a/drivers/net/wireless/ath/ar9170/usb.h
+++ b/drivers/net/wireless/ath/ar9170/usb.h
@@ -64,8 +64,6 @@ struct ar9170_usb {
 	struct usb_anchor tx_pending;
 	struct usb_anchor tx_submitted;
 
-	bool req_one_stage_fw;
-
 	spinlock_t tx_urb_lock;
 	unsigned int tx_submitted_urbs;
 	unsigned int tx_pending_urbs;
