Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41944 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505AbZLWMWF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 07:22:05 -0500
Message-Id: <20091223121614.849207840@sipsolutions.net>
Date: Wed, 23 Dec 2009 13:15:30 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH next 01/18] ar9170: load firmware asynchronously
References: <20091223121529.289129599@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This converts ar9170 to load firmware asynchronously
out of ->probe() and only register with mac80211 when
all firmware has been loaded successfully. If, on the
other hand, any firmware fails to load, it will now
unbind from the device.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
This ought to make it possible to build the driver
into the kernel and as long as your system boots
within 60 seconds it'll all just work.

This is how we need to load firmware for drivers that
require the firmware image to detect which features
to register to mac80211/cfg80211, but it's also useful
when no features depend on the firmware.

I've done ar9170 because I'm somewhat familiar with its
implementation. b43 should probably be converted to this
scheme since it actually has features that depend on the
firmware, and libertas_tf has the MAC addresss depending
on the firmware (well it needs the firmware to read it).

The only complication with this is that now the user is
mostly unaware they have a wireless device, they can only
find it via lsusb/lspci etc. if firmware loading fails,
or from kernel messages. And also manual binding in sysfs,
device re-plugging or module re-loading is required to
get the module to find the device after putting firmware
in place...

Still I think this is better than what we have now with
many drivers -- if firmware is missing you get network
interfaces etc. but cannot ever use them, and it's not
always entirely clear that is due to missing firmware.

 drivers/net/wireless/ath/ar9170/ar9170.h |    1 
 drivers/net/wireless/ath/ar9170/main.c   |   10 +
 drivers/net/wireless/ath/ar9170/usb.c    |  170 ++++++++++++++++++-------------
 3 files changed, 111 insertions(+), 70 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/ath/ar9170/usb.c	2009-12-23 10:10:22.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/ar9170/usb.c	2009-12-23 10:26:55.000000000 +0100
@@ -582,43 +582,6 @@ static int ar9170_usb_upload(struct ar91
 	return 0;
 }
 
-static int ar9170_usb_request_firmware(struct ar9170_usb *aru)
-{
-	int err = 0;
-
-	err = request_firmware(&aru->firmware, "ar9170.fw",
-			       &aru->udev->dev);
-	if (!err) {
-		aru->init_values = NULL;
-		return 0;
-	}
-
-	if (aru->req_one_stage_fw) {
-		dev_err(&aru->udev->dev, "ar9170.fw firmware file "
-			"not found and is required for this device\n");
-		return -EINVAL;
-	}
-
-	dev_err(&aru->udev->dev, "ar9170.fw firmware file "
-		"not found, trying old firmware...\n");
-
-	err = request_firmware(&aru->init_values, "ar9170-1.fw",
-			       &aru->udev->dev);
-	if (err) {
-		dev_err(&aru->udev->dev, "file with init values not found.\n");
-		return err;
-	}
-
-	err = request_firmware(&aru->firmware, "ar9170-2.fw", &aru->udev->dev);
-	if (err) {
-		release_firmware(aru->init_values);
-		dev_err(&aru->udev->dev, "firmware file not found.\n");
-		return err;
-	}
-
-	return err;
-}
-
 static int ar9170_usb_reset(struct ar9170_usb *aru)
 {
 	int ret, lock = (aru->intf->condition != USB_INTERFACE_BINDING);
@@ -757,6 +720,103 @@ err_out:
 	return err;
 }
 
+static void ar9170_usb_firmware_failed(struct ar9170_usb *aru)
+{
+	struct device *parent = aru->udev->dev.parent;
+
+	/* unbind anything failed */
+	if (parent)
+		down(&parent->sem);
+	device_release_driver(&aru->udev->dev);
+	if (parent)
+		up(&parent->sem);
+}
+
+static void ar9170_usb_firmware_finish(const struct firmware *fw, void *context)
+{
+	struct ar9170_usb *aru = context;
+	int err;
+
+	aru->firmware = fw;
+
+	if (!fw) {
+		dev_err(&aru->udev->dev, "firmware file not found.\n");
+		goto err_freefw;
+	}
+
+	err = ar9170_usb_init_device(aru);
+	if (err)
+		goto err_freefw;
+
+	err = ar9170_usb_open(&aru->common);
+	if (err)
+		goto err_unrx;
+
+	err = ar9170_register(&aru->common, &aru->udev->dev);
+
+	ar9170_usb_stop(&aru->common);
+	if (err)
+		goto err_unrx;
+
+	return;
+
+ err_unrx:
+	ar9170_usb_cancel_urbs(aru);
+
+ err_freefw:
+	ar9170_usb_firmware_failed(aru);
+}
+
+static void ar9170_usb_firmware_inits(const struct firmware *fw,
+				      void *context)
+{
+	struct ar9170_usb *aru = context;
+	int err;
+
+	if (!fw) {
+		dev_err(&aru->udev->dev, "file with init values not found.\n");
+		ar9170_usb_firmware_failed(aru);
+		return;
+	}
+
+	aru->init_values = fw;
+
+	/* ok so we have the init values -- get code for two-stage */
+
+	err = request_firmware_nowait(THIS_MODULE, 1, "ar9170-2.fw",
+				      &aru->udev->dev, GFP_KERNEL, aru,
+				      ar9170_usb_firmware_finish);
+	if (err)
+		ar9170_usb_firmware_failed(aru);
+}
+
+static void ar9170_usb_firmware_step2(const struct firmware *fw, void *context)
+{
+	struct ar9170_usb *aru = context;
+	int err;
+
+	if (fw) {
+		ar9170_usb_firmware_finish(fw, context);
+		return;
+	}
+
+	if (aru->req_one_stage_fw) {
+		dev_err(&aru->udev->dev, "ar9170.fw firmware file "
+			"not found and is required for this device\n");
+		ar9170_usb_firmware_failed(aru);
+		return;
+	}
+
+	dev_err(&aru->udev->dev, "ar9170.fw firmware file "
+		"not found, trying old firmware...\n");
+
+	err = request_firmware_nowait(THIS_MODULE, 1, "ar9170-1.fw",
+				      &aru->udev->dev, GFP_KERNEL, aru,
+				      ar9170_usb_firmware_inits);
+	if (err)
+		ar9170_usb_firmware_failed(aru);
+}
+
 static bool ar9170_requires_one_stage(const struct usb_device_id *id)
 {
 	if (!id->driver_info)
@@ -814,33 +874,9 @@ static int ar9170_usb_probe(struct usb_i
 	if (err)
 		goto err_freehw;
 
-	err = ar9170_usb_request_firmware(aru);
-	if (err)
-		goto err_freehw;
-
-	err = ar9170_usb_init_device(aru);
-	if (err)
-		goto err_freefw;
-
-	err = ar9170_usb_open(ar);
-	if (err)
-		goto err_unrx;
-
-	err = ar9170_register(ar, &udev->dev);
-
-	ar9170_usb_stop(ar);
-	if (err)
-		goto err_unrx;
-
-	return 0;
-
-err_unrx:
-	ar9170_usb_cancel_urbs(aru);
-
-err_freefw:
-	release_firmware(aru->init_values);
-	release_firmware(aru->firmware);
-
+	return request_firmware_nowait(THIS_MODULE, 1, "ar9170.fw",
+				       &aru->udev->dev, GFP_KERNEL, aru,
+				       ar9170_usb_firmware_step2);
 err_freehw:
 	usb_set_intfdata(intf, NULL);
 	usb_put_dev(udev);
@@ -860,12 +896,12 @@ static void ar9170_usb_disconnect(struct
 	ar9170_unregister(&aru->common);
 	ar9170_usb_cancel_urbs(aru);
 
-	release_firmware(aru->init_values);
-	release_firmware(aru->firmware);
-
 	usb_put_dev(aru->udev);
 	usb_set_intfdata(intf, NULL);
 	ieee80211_free_hw(aru->common.hw);
+
+	release_firmware(aru->init_values);
+	release_firmware(aru->firmware);
 }
 
 #ifdef CONFIG_PM
--- wireless-testing.orig/drivers/net/wireless/ath/ar9170/ar9170.h	2009-12-23 10:10:22.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/ar9170/ar9170.h	2009-12-23 10:26:55.000000000 +0100
@@ -160,6 +160,7 @@ struct ar9170 {
 	struct ath_common common;
 	struct mutex mutex;
 	enum ar9170_device_state state;
+	bool registered;
 	unsigned long bad_hw_nagger;
 
 	int (*open)(struct ar9170 *);
--- wireless-testing.orig/drivers/net/wireless/ath/ar9170/main.c	2009-12-23 10:10:22.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/ar9170/main.c	2009-12-23 10:26:56.000000000 +0100
@@ -2712,7 +2712,8 @@ int ar9170_register(struct ar9170 *ar, s
 	dev_info(pdev, "Atheros AR9170 is registered as '%s'\n",
 		 wiphy_name(ar->hw->wiphy));
 
-	return err;
+	ar->registered = true;
+	return 0;
 
 err_unreg:
 	ieee80211_unregister_hw(ar->hw);
@@ -2723,11 +2724,14 @@ err_out:
 
 void ar9170_unregister(struct ar9170 *ar)
 {
+	if (ar->registered) {
 #ifdef CONFIG_AR9170_LEDS
-	ar9170_unregister_leds(ar);
+		ar9170_unregister_leds(ar);
 #endif /* CONFIG_AR9170_LEDS */
 
-	kfree_skb(ar->rx_failover);
 	ieee80211_unregister_hw(ar->hw);
+	}
+
+	kfree_skb(ar->rx_failover);
 	mutex_destroy(&ar->mutex);
 }


