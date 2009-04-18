Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:36601 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbZDRPMU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Apr 2009 11:12:20 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH] ar9170usb: fix hang on resume
Date: Sat, 18 Apr 2009 17:12:18 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200904181712.18628.chunkeey@web.de> (sfid-20090418_171224_315277_6E1753B2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a hang on resume when the filesystem is not
available and request_firmware blocks.

However, the device does not accept the firmware on resume.
and it will exit with:

> firmware part 1 upload failed (-71).
> device is in a bad state. please reconnect it!

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/ath/ar9170/usb.c b/drivers/net/wireless/ath/ar9170/usb.c
index c9e422e..fddda47 100644
--- a/drivers/net/wireless/ath/ar9170/usb.c
+++ b/drivers/net/wireless/ath/ar9170/usb.c
@@ -623,6 +623,39 @@ static int ar9170_usb_open(struct ar9170 *ar)
 	return 0;
 }
 
+static int ar9170_usb_init_device(struct ar9170_usb *aru)
+{
+	int err;
+
+	err = ar9170_usb_alloc_rx_irq_urb(aru);
+	if (err)
+		goto err_out;
+
+	err = ar9170_usb_alloc_rx_bulk_urbs(aru);
+	if (err)
+		goto err_unrx;
+
+	err = ar9170_usb_upload_firmware(aru);
+	if (err) {
+		err = ar9170_echo_test(&aru->common, 0x60d43110);
+		if (err) {
+			/* force user invention, by disabling the device */
+			err = usb_driver_set_configuration(aru->udev, -1);
+			dev_err(&aru->udev->dev, "device is in a bad state. "
+						 "please reconnect it!\n");
+			goto err_unrx;
+		}
+	}
+
+	return 0;
+
+err_unrx:
+	ar9170_usb_cancel_urbs(aru);
+
+err_out:
+	return err;
+}
+
 static int ar9170_usb_probe(struct usb_interface *intf,
 			const struct usb_device_id *id)
 {
@@ -658,32 +691,16 @@ static int ar9170_usb_probe(struct usb_interface *intf,
 
 	err = ar9170_usb_reset(aru);
 	if (err)
-		goto err_unlock;
+		goto err_freehw;
 
 	err = ar9170_usb_request_firmware(aru);
 	if (err)
-		goto err_unlock;
+		goto err_freehw;
 
-	err = ar9170_usb_alloc_rx_irq_urb(aru);
+	err = ar9170_usb_init_device(aru);
 	if (err)
 		goto err_freefw;
 
-	err = ar9170_usb_alloc_rx_bulk_urbs(aru);
-	if (err)
-		goto err_unrx;
-
-	err = ar9170_usb_upload_firmware(aru);
-	if (err) {
-		err = ar9170_echo_test(&aru->common, 0x60d43110);
-		if (err) {
-			/* force user invention, by disabling the device */
-			err = usb_driver_set_configuration(aru->udev, -1);
-			dev_err(&aru->udev->dev, "device is in a bad state. "
-						 "please reconnect it!\n");
-			goto err_unrx;
-		}
-	}
-
 	err = ar9170_usb_open(ar);
 	if (err)
 		goto err_unrx;
@@ -703,7 +720,7 @@ err_freefw:
 	release_firmware(aru->init_values);
 	release_firmware(aru->firmware);
 
-err_unlock:
+err_freehw:
 	usb_set_intfdata(intf, NULL);
 	usb_put_dev(udev);
 	ieee80211_free_hw(ar->hw);
@@ -730,12 +747,65 @@ static void ar9170_usb_disconnect(struct usb_interface *intf)
 	ieee80211_free_hw(aru->common.hw);
 }
 
+#ifdef CONFIG_PM
+static int ar9170_suspend(struct usb_interface *intf,
+			  pm_message_t  message)
+{
+	struct ar9170_usb *aru = usb_get_intfdata(intf);
+
+	if (!aru)
+		return -ENODEV;
+
+	aru->common.state = AR9170_IDLE;
+	ar9170_usb_cancel_urbs(aru);
+
+	return 0;
+}
+
+static int ar9170_resume(struct usb_interface *intf)
+{
+	struct ar9170_usb *aru = usb_get_intfdata(intf);
+	int err;
+
+	if (!aru)
+		return -ENODEV;
+
+	usb_unpoison_anchored_urbs(&aru->rx_submitted);
+	usb_unpoison_anchored_urbs(&aru->tx_submitted);
+
+	/*
+	 * FIXME: firmware upload will fail on resume.
+	 * but this is better than a hang!
+	 */
+
+	err = ar9170_usb_init_device(aru);
+	if (err)
+		goto err_unrx;
+
+	err = ar9170_usb_open(&aru->common);
+	if (err)
+		goto err_unrx;
+
+	return 0;
+
+err_unrx:
+	aru->common.state = AR9170_IDLE;
+	ar9170_usb_cancel_urbs(aru);
+
+	return err;
+}
+#endif /* CONFIG_PM */
+
 static struct usb_driver ar9170_driver = {
 	.name = "ar9170usb",
 	.probe = ar9170_usb_probe,
 	.disconnect = ar9170_usb_disconnect,
 	.id_table = ar9170_usb_ids,
 	.soft_unbind = 1,
+#ifdef CONFIG_PM
+	.suspend = ar9170_suspend,
+	.resume = ar9170_resume,
+#endif /* CONFIG_PM */
 };
 
 static int __init ar9170_init(void)
