Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:35787 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbYLZSIe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Dec 2008 13:08:34 -0500
From: Christian Lamparter <chunkeey@web.de>
To: wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/3] p54usb: utilize usb_reset_device for 3887
Date: Fri, 26 Dec 2008 19:08:31 +0100
Cc: John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200812261908.31998.chunkeey@web.de> (sfid-20081226_190839_827142_CC9E6D38)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes on unload or reboot the 3887 USB devices become stuck.
<usual log entry> 
kernel: usbcore: registered new interface driver p54usb
kernel: usb 2-10: (p54usb) reset failed! (-110)
kernel: p54usb: probe of 2-10:1.0 failed with error -110
[...]

and a physical unplug and replug was necessary.
However we should be able to do this in software as well,
without any user interaction.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
--- a/drivers/net/wireless/p54/p54usb.c	2008-12-26 13:23:36.000000000 +0100
+++ b/drivers/net/wireless/p54/p54usb.c	2008-12-26 17:47:54.000000000 +0100
@@ -428,9 +428,44 @@ static int p54u_bulk_msg(struct p54u_pri
 			    data, len, &alen, 2000);
 }
 
+static const char p54u_romboot_3887[] = "~~~~";
+static const char p54u_firmware_upload_3887[] = "<\r";
+
+static int p54u_device_reset_3887(struct ieee80211_hw *dev)
+{
+	struct p54u_priv *priv = dev->priv;
+	int ret, lock;
+	u8 buf[4];
+
+	ret = lock = usb_lock_device_for_reset(priv->udev, priv->intf);
+	if (ret < 0) {
+		dev_err(&priv->udev->dev, "(p54usb) unable to lock device for "
+			"reset: %d\n", ret);
+		return ret;
+	}
+
+	ret = usb_reset_device(priv->udev);
+	if (lock)
+		usb_unlock_device(priv->udev);
+
+	if (ret) {
+		dev_err(&priv->udev->dev, "(p54usb) unable to reset "
+			"device: %d\n", ret);
+		return ret;
+	}
+
+	memcpy(&buf, p54u_romboot_3887, sizeof(buf));
+	ret = p54u_bulk_msg(priv, P54U_PIPE_DATA,
+			    buf, sizeof(buf));
+	if (ret)
+		dev_err(&priv->udev->dev, "(p54usb) unable to jump to "
+			"boot ROM: %d\n", ret);
+
+	return ret;
+}
+
 static int p54u_upload_firmware_3887(struct ieee80211_hw *dev)
 {
-	static char start_string[] = "~~~~<\r";
 	struct p54u_priv *priv = dev->priv;
 	const struct firmware *fw_entry = NULL;
 	int err, alen;
@@ -449,12 +484,9 @@ static int p54u_upload_firmware_3887(str
 		goto err_bufalloc;
 	}
 
-	memcpy(buf, start_string, 4);
-	err = p54u_bulk_msg(priv, P54U_PIPE_DATA, buf, 4);
-	if (err) {
-		dev_err(&priv->udev->dev, "(p54usb) reset failed! (%d)\n", err);
+	err = p54u_device_reset_3887(dev);
+	if (err)
 		goto err_reset;
-	}
 
 	err = request_firmware(&fw_entry, "isl3887usb", &priv->udev->dev);
 	if (err) {
@@ -471,14 +503,14 @@ static int p54u_upload_firmware_3887(str
 		goto err_upload_failed;
 
 	left = block_size = min((size_t)P54U_FW_BLOCK, fw_entry->size);
-	strcpy(buf, start_string);
-	left -= strlen(start_string);
-	tmp += strlen(start_string);
+	strcpy(buf, p54u_firmware_upload_3887);
+	left -= strlen(p54u_firmware_upload_3887);
+	tmp += strlen(p54u_firmware_upload_3887);
 
 	data = fw_entry->data;
 	remains = fw_entry->size;
 
-	hdr = (struct x2_header *)(buf + strlen(start_string));
+	hdr = (struct x2_header *)(buf + strlen(p54u_firmware_upload_3887));
 	memcpy(hdr->signature, X2_SIGNATURE, X2_SIGNATURE_SIZE);
 	hdr->fw_load_addr = cpu_to_le32(ISL38XX_DEV_FIRMWARE_ADDR);
 	hdr->fw_length = cpu_to_le32(fw_entry->size);
@@ -881,6 +913,9 @@ static int __devinit p54u_probe(struct u
 	SET_IEEE80211_DEV(dev, &intf->dev);
 	usb_set_intfdata(intf, dev);
 	priv->udev = udev;
+	priv->intf = intf;
+	skb_queue_head_init(&priv->rx_queue);
+	init_usb_anchor(&priv->submitted);
 
 	usb_get_dev(udev);
 
@@ -923,9 +958,6 @@ static int __devinit p54u_probe(struct u
 	if (err)
 		goto err_free_dev;
 
-	skb_queue_head_init(&priv->rx_queue);
-	init_usb_anchor(&priv->submitted);
-
 	p54u_open(dev);
 	err = p54_read_eeprom(dev);
 	p54u_stop(dev);
@@ -963,11 +995,23 @@ static void __devexit p54u_disconnect(st
 	ieee80211_free_hw(dev);
 }
 
+static int p54u_pre_reset(struct usb_interface *intf)
+{
+	return 0;
+}
+
+static int p54u_post_reset(struct usb_interface *intf)
+{
+	return 0;
+}
+
 static struct usb_driver p54u_driver = {
 	.name	= "p54usb",
 	.id_table = p54u_table,
 	.probe = p54u_probe,
 	.disconnect = p54u_disconnect,
+	.pre_reset = p54u_pre_reset,
+	.post_reset = p54u_post_reset,
 };
 
 static int __init p54u_init(void)
diff -Nurp a/drivers/net/wireless/p54/p54usb.h b/drivers/net/wireless/p54/p54usb.h
--- a/drivers/net/wireless/p54/p54usb.h	2008-12-26 13:23:36.000000000 +0100
+++ b/drivers/net/wireless/p54/p54usb.h	2008-12-26 15:16:24.000000000 +0100
@@ -126,6 +126,7 @@ struct p54u_rx_info {
 struct p54u_priv {
 	struct p54_common common;
 	struct usb_device *udev;
+	struct usb_interface *intf;
 	enum {
 		P54U_NET2280 = 0,
 		P54U_3887
