Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:41767 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbZDRNER (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Apr 2009 09:04:17 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: ar9710 resume hangs
Date: Sat, 18 Apr 2009 15:04:14 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
References: <1240041582.4456.0.camel@johannes.local>
In-Reply-To: <1240041582.4456.0.camel@johannes.local>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_O/c6JbdSD2Bgp4v"
Message-Id: <200904181504.14870.chunkeey@web.de> (sfid-20090418_150421_634886_53621519)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_O/c6JbdSD2Bgp4v
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Saturday 18 April 2009 09:59:42 Johannes Berg wrote:
> because it tries to load firmware before userspace is up :/

heh, I have 4 different machines and not a single one does 
atleast one suspend & resume cycle properly.

here's a patch that compiles, but may not work at all.

regards,
	chr

--Boundary-00=_O/c6JbdSD2Bgp4v
Content-Type: text/x-patch;
  charset="UTF-8";
  name="ar9170usb-resume.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="ar9170usb-resume.diff"

diff --git a/drivers/net/wireless/ath/ar9170/usb.c b/drivers/net/wireless/ath/ar9170/usb.c
index c9e422e..361cb89 100644
--- a/drivers/net/wireless/ath/ar9170/usb.c
+++ b/drivers/net/wireless/ath/ar9170/usb.c
@@ -623,6 +623,43 @@ static int ar9170_usb_open(struct ar9170 *ar)
 	return 0;
 }
 
+static int ar9170_usb_init_device(struct ar9170_usb *aru)
+{
+	int err;
+
+	err = ar9170_usb_reset(aru);
+	if (err)
+		goto err_out;
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
@@ -656,34 +693,14 @@ static int ar9170_usb_probe(struct usb_interface *intf,
 	aru->common.exec_cmd = ar9170_usb_exec_cmd;
 	aru->common.callback_cmd = ar9170_usb_callback_cmd;
 
-	err = ar9170_usb_reset(aru);
-	if (err)
-		goto err_unlock;
-
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
@@ -730,12 +747,57 @@ static void ar9170_usb_disconnect(struct usb_interface *intf)
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

--Boundary-00=_O/c6JbdSD2Bgp4v--
