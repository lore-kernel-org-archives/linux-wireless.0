Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:50094 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbZDROqa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Apr 2009 10:46:30 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: ar9710 resume hangs
Date: Sat, 18 Apr 2009 16:46:28 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
References: <1240041582.4456.0.camel@johannes.local> <1240060783.4755.18.camel@johannes.local> <200904181621.27807.chunkeey@web.de>
In-Reply-To: <200904181621.27807.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <200904181646.28359.chunkeey@web.de> (sfid-20090418_164634_015595_556275B6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 18 April 2009 16:21:27 Christian Lamparter wrote:
> On Saturday 18 April 2009 15:19:43 Johannes Berg wrote:
> > On Sat, 2009-04-18 at 15:04 +0200, Christian Lamparter wrote:
> > > On Saturday 18 April 2009 09:59:42 Johannes Berg wrote:
> > > > because it tries to load firmware before userspace is up :/
> > > 
> > > heh, I have 4 different machines and not a single one does 
> > > atleast one suspend & resume cycle properly.
> > 
> > 
> > Heh.
> > 
> > > here's a patch that compiles, but may not work at all.
> > 
> > Huh, wouldn't it be simpler to just cache the firmware? Everything else
> > seems ok as-is.
> > 
> 
> > it's better, in that it doesn't hang at resume
> > [ 6694.110048] usb 1-1: unable to lock device for reset (-16).
> > [ 6694.119657] ar9170usb 1-1:1.0: resume error -16
> > [ 6695.140043] usb 1-1: unable to lock device for reset (-16).
> > [ 6695.149649] ar9170usb 1-1:1.0: resume error -16
> 
> please retry with the attached version...
> [ 8153.991223] ar9170usb 1-1:1.0: resume error -1
> [ 8154.001191] ar9170usb 1-1:1.0: resume error -1

should be fixed... let's see if the third attempt is the lucky one.
---
diff --git a/drivers/net/wireless/ath/ar9170/usb.c b/drivers/net/wireless/ath/ar9170/usb.c
index c9e422e..8b23386 100644
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
@@ -730,12 +747,60 @@ static void ar9170_usb_disconnect(struct usb_interface *intf)
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
