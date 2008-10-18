Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:44731 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbYJRVAC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Oct 2008 17:00:02 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v2] p54: introduce new names for device firmwares
Date: Sat, 18 Oct 2008 23:04:15 +0200
Cc: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>
References: <200810161330.38726.chunkeey@web.de> <1224180417.735.88.camel@johannes.berg>
In-Reply-To: <1224180417.735.88.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200810182304.15385.chunkeey@web.de> (sfid-20081018_230009_476806_1F338D0D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes thought it would have been a good idea to change the firmware names.

Note: we still have fallbacks in case our users don't want to "break their running system",
but we won't advertise them with MODULE_FIRMWARE.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-10-18 21:02:04.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.c	2008-10-16 23:06:55.000000000 +0200
@@ -214,6 +214,11 @@ int p54_parse_firmware(struct ieee80211_
 		printk(KERN_INFO "p54: FW rev %s - Softmac protocol %x.%x\n",
 			fw_version, priv->fw_var >> 8, priv->fw_var & 0xff);
 
+	if (priv->fw_var < 0x500)
+		printk(KERN_INFO "p54: you are using an obsolete firmware. "
+		       "visit http://wireless.kernel.org/en/users/Drivers/p54 "
+		       "and grab one for \"kernel >= 2.6.28\"!\n");
+
 	if (priv->fw_var >= 0x300) {
 		/* Firmware supports QoS, use it! */
 		priv->tx_stats[4].limit = 3;
diff -Nurp a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
--- a/drivers/net/wireless/p54/p54usb.c	2008-10-14 22:07:39.000000000 +0200
+++ b/drivers/net/wireless/p54/p54usb.c	2008-10-18 19:22:07.000000000 +0200
@@ -28,6 +28,8 @@ MODULE_AUTHOR("Michael Wu <flamingice@so
 MODULE_DESCRIPTION("Prism54 USB wireless driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("prism54usb");
+MODULE_FIRMWARE("isl3886usb");
+MODULE_FIRMWARE("isl3887usb");
 
 static struct usb_device_id p54u_table[] __devinitdata = {
 	/* Version 1 devices (pci chip + net2280) */
@@ -415,10 +417,13 @@ static int p54u_upload_firmware_3887(str
 		goto err_reset;
 	}
 
-	err = request_firmware(&fw_entry, "isl3887usb_bare", &priv->udev->dev);
+	err = request_firmware(&fw_entry, "isl3887usb", &priv->udev->dev);
 	if (err) {
-		printk(KERN_ERR "p54usb: cannot find firmware (isl3887usb_bare)!\n");
-		goto err_req_fw_failed;
+		printk(KERN_ERR "p54usb: cannot find firmware (isl3887usb)\n");
+		err = request_firmware(&fw_entry, "isl3887usb_bare",
+			&priv->udev->dev);
+		if (err)
+			goto err_req_fw_failed;
 	}
 
 	err = p54_parse_firmware(dev, fw_entry);
@@ -553,11 +558,15 @@ static int p54u_upload_firmware_net2280(
 		return -ENOMEM;
 	}
 
-	err = request_firmware(&fw_entry, "isl3890usb", &priv->udev->dev);
+	err = request_firmware(&fw_entry, "isl3886usb", &priv->udev->dev);
 	if (err) {
-		printk(KERN_ERR "p54usb: cannot find firmware (isl3890usb)!\n");
-		kfree(buf);
-		return err;
+		printk(KERN_ERR "p54usb: cannot find firmware (isl3886usb)\n");
+		err = request_firmware(&fw_entry, "isl3890usb",
+			&priv->udev->dev);
+		if (err) {
+			kfree(buf);
+			return err;
+			}
 	}
 
 	err = p54_parse_firmware(dev, fw_entry);
diff -Nurp a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
--- a/drivers/net/wireless/p54/p54pci.c	2008-10-14 22:06:54.000000000 +0200
+++ b/drivers/net/wireless/p54/p54pci.c	2008-10-18 20:58:02.000000000 +0200
@@ -28,6 +28,7 @@ MODULE_AUTHOR("Michael Wu <flamingice@so
 MODULE_DESCRIPTION("Prism54 PCI wireless driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("prism54pci");
+MODULE_FIRMWARE("isl3886pci");
 
 static struct pci_device_id p54p_table[] __devinitdata = {
 	/* Intersil PRISM Duette/Prism GT Wireless LAN adapter */
@@ -72,11 +73,13 @@ static int p54p_upload_firmware(struct i
 	P54P_WRITE(ctrl_stat, reg);
 	wmb();
 
-	err = request_firmware(&fw_entry, "isl3886", &priv->pdev->dev);
+	err = request_firmware(&fw_entry, "isl3886pci", &priv->pdev->dev);
 	if (err) {
 		printk(KERN_ERR "%s (p54pci): cannot find firmware "
-		       "(isl3886)\n", pci_name(priv->pdev));
-		return err;
+		       "(isl3886pci)\n", pci_name(priv->pdev));
+		err = request_firmware(&fw_entry, "isl3886", &priv->pdev->dev);
+		if (err)
+			return err;
 	}
 
 	err = p54_parse_firmware(dev, fw_entry);
