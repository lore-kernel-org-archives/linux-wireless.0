Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19521 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab2CQCUR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 22:20:17 -0400
Date: Fri, 16 Mar 2012 21:20:14 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, chunkeey@web.de
Subject: [RFC/RFT] p54usb: Load firmware asynchronously
Message-ID: <4f63f4de.b9MwfIoBwP8knH78%Larry.Finger@lwfinger.net> (sfid-20120317_032020_688174_7CE02ABC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers that load firmware from their probe routine have problems with the
latest versions of udev as they get timeouts while waiting for user
space to start. The problem is fixed by using request_firmware_nowait()
and delaying the start of mac80211 until the firmware is loaded.

To prevent the possibility of the driver being unloaded while the firmware
loading callback is still active, a completion queue entry is used.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

This version has not been tested to see if it works with the new udev while
suspending/resuming. My computer fails to suspend for other reasons.

Larry
---

 p54usb.c |  153 ++++++++++++++++++++++++++++++++++++++++++++++-----------------
 p54usb.h |    3 +
 2 files changed, 115 insertions(+), 41 deletions(-)
---

Index: wireless-testing-new/drivers/net/wireless/p54/p54usb.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/p54/p54usb.c
+++ wireless-testing-new/drivers/net/wireless/p54/p54usb.c
@@ -836,45 +836,133 @@ fail:
 	return err;
 }
 
-static int p54u_load_firmware(struct ieee80211_hw *dev)
+static int p54_find_type(struct p54u_priv *priv)
 {
-	struct p54u_priv *priv = dev->priv;
-	int err, i;
-
-	BUILD_BUG_ON(ARRAY_SIZE(p54u_fwlist) != __NUM_P54U_HWTYPES);
+	int i;
 
 	for (i = 0; i < __NUM_P54U_HWTYPES; i++)
 		if (p54u_fwlist[i].type == priv->hw_type)
 			break;
-
 	if (i == __NUM_P54U_HWTYPES)
 		return -EOPNOTSUPP;
 
-	err = request_firmware(&priv->fw, p54u_fwlist[i].fw, &priv->udev->dev);
-	if (err) {
-		dev_err(&priv->udev->dev, "(p54usb) cannot load firmware %s "
-					  "(%d)!\n", p54u_fwlist[i].fw, err);
+	return i;
+}
 
-		err = request_firmware(&priv->fw, p54u_fwlist[i].fw_legacy,
-				       &priv->udev->dev);
-		if (err)
-			return err;
-	}
+static int p54u_open(struct ieee80211_hw *dev);
+static void p54u_stop(struct ieee80211_hw *dev);
+
+static void p54_start_ops(struct usb_interface *intf)
+{
+	struct usb_device *udev = interface_to_usbdev(intf);
+	struct ieee80211_hw *dev = usb_get_intfdata(intf);
+	struct p54u_priv *priv = dev->priv;
+	int i, err;
 
 	err = p54_parse_firmware(dev, priv->fw);
 	if (err)
-		goto out;
+		goto err_free_dev;
 
+	i = p54_find_type(priv);
+	if (i < 0)
+		goto err_free_dev;
 	if (priv->common.fw_interface != p54u_fwlist[i].intf) {
 		dev_err(&priv->udev->dev, "wrong firmware, please get "
 			"a firmware for \"%s\" and try again.\n",
 			p54u_fwlist[i].hw);
-		err = -EINVAL;
+		goto err_free_dev;
+	}
+	err = priv->upload_fw(dev);
+	if (err)
+		goto err_free_dev;
+
+	p54u_open(dev);
+	err = p54_read_eeprom(dev);
+	p54u_stop(dev);
+	if (err)
+		goto err_free_dev;
+
+	err = p54_register_common(dev, &udev->dev);
+	if (err)
+		goto err_free_common;
+	return;
+
+err_free_common:
+	p54_free_common(dev);
+err_free_dev:
+	release_firmware(priv->fw);
+	usb_set_intfdata(intf, NULL);
+	usb_put_dev(udev);
+}
+
+static void p54u_load_firmware_cb2(const struct firmware *firmware,
+				   void *context)
+{
+	struct usb_interface *intf = context;
+	struct ieee80211_hw *dev = usb_get_intfdata(intf);
+	struct p54u_priv *priv = dev->priv;
+
+	complete(&priv->fw_loaded);
+	if (!firmware) {
+		dev_err(&priv->udev->dev, "Firmware not found\n");
+		return;
 	}
+	priv->fw = firmware;
+	p54_start_ops(intf);
+}
+
+static void p54u_load_firmware_cb(const struct firmware *firmware,
+				  void *context)
+{
+	struct usb_interface *intf = context;
+	struct ieee80211_hw *dev = usb_get_intfdata(intf);
+	struct p54u_priv *priv = dev->priv;
+	struct usb_device *udev = interface_to_usbdev(intf);
+	struct device *device = &udev->dev;
+	int i, err;
+
+	if (!firmware) {
+		i = p54_find_type(priv);
+		if (i < 0)
+			return;
+		/* Primary firmware not found - try for legacy variety */
+		dev_info(&priv->udev->dev, "Loading firmware file %s\n",
+			 p54u_fwlist[i].fw_legacy);
+		err = request_firmware_nowait(THIS_MODULE, 1,
+					      p54u_fwlist[i].fw_legacy,
+					      device, GFP_KERNEL, intf,
+					      p54u_load_firmware_cb2);
+		if (err)
+			return;
+	}
+	complete(&priv->fw_loaded);
+	priv->fw = firmware;
+	p54_start_ops(intf);
+}
 
-out:
+static int p54u_load_firmware(struct ieee80211_hw *dev,
+			      struct usb_interface *intf)
+{
+	struct usb_device *udev = interface_to_usbdev(intf);
+	struct p54u_priv *priv = dev->priv;
+	struct device *device = &udev->dev;
+	int err, i;
+
+	BUILD_BUG_ON(ARRAY_SIZE(p54u_fwlist) != __NUM_P54U_HWTYPES);
+
+	init_completion(&priv->fw_loaded);
+	i = p54_find_type(priv);
+	if (i < 0)
+		return i;
+
+	dev_info(&priv->udev->dev, "Loading firmware file %s\n",
+	       p54u_fwlist[i].fw);
+	err = request_firmware_nowait(THIS_MODULE, 1, p54u_fwlist[i].fw,
+				      device, GFP_KERNEL, intf,
+				      p54u_load_firmware_cb);
 	if (err)
-		release_firmware(priv->fw);
+		dev_err(&priv->udev->dev, "(p54usb) cannot load firmware %s "
+					  "(%d)!\n", p54u_fwlist[i].fw, err);
 
 	return err;
 }
@@ -969,33 +1057,7 @@ static int __devinit p54u_probe(struct u
 		priv->common.tx = p54u_tx_net2280;
 		priv->upload_fw = p54u_upload_firmware_net2280;
 	}
-	err = p54u_load_firmware(dev);
-	if (err)
-		goto err_free_dev;
-
-	err = priv->upload_fw(dev);
-	if (err)
-		goto err_free_fw;
-
-	p54u_open(dev);
-	err = p54_read_eeprom(dev);
-	p54u_stop(dev);
-	if (err)
-		goto err_free_fw;
-
-	err = p54_register_common(dev, &udev->dev);
-	if (err)
-		goto err_free_fw;
-
-	return 0;
-
-err_free_fw:
-	release_firmware(priv->fw);
-
-err_free_dev:
-	p54_free_common(dev);
-	usb_set_intfdata(intf, NULL);
-	usb_put_dev(udev);
+	err = p54u_load_firmware(dev, intf);
 	return err;
 }
 
@@ -1007,9 +1069,10 @@ static void __devexit p54u_disconnect(st
 	if (!dev)
 		return;
 
+	priv = dev->priv;
+	wait_for_completion(&priv->fw_loaded);
 	p54_unregister_common(dev);
 
-	priv = dev->priv;
 	usb_put_dev(interface_to_usbdev(intf));
 	release_firmware(priv->fw);
 	p54_free_common(dev);
Index: wireless-testing-new/drivers/net/wireless/p54/p54usb.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/p54/p54usb.h
+++ wireless-testing-new/drivers/net/wireless/p54/p54usb.h
@@ -143,6 +143,9 @@ struct p54u_priv {
 	struct sk_buff_head rx_queue;
 	struct usb_anchor submitted;
 	const struct firmware *fw;
+
+	/* asynchronous firmware callback */
+	struct completion fw_loaded;
 };
 
 #endif /* P54USB_H */
