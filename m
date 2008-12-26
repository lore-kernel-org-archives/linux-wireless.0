Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:34333 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbYLZSJh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Dec 2008 13:09:37 -0500
From: Christian Lamparter <chunkeey@web.de>
To: wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] p54: prevent upload of wrong firmwares
Date: Fri, 26 Dec 2008 19:09:34 +0100
Cc: John W Linville <linville@tuxdriver.com>,
	Artur Skawina <art.08.09@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200812261909.34823.chunkeey@web.de> (sfid-20081226_190939_672460_79A34FE1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch will prevent anyone to upload a firmware which was not designed for his device.

There's still a catch:
There is no easy way to detect if a firmware is for PCI or for USB (1st Gen),
because they all share the same LM86 identifier.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
--- a/drivers/net/wireless/p54/p54pci.c	2008-12-26 13:33:37.000000000 +0100
+++ b/drivers/net/wireless/p54/p54pci.c	2008-12-26 17:43:25.000000000 +0100
@@ -79,6 +79,12 @@ static int p54p_upload_firmware(struct i
 	if (err)
 		return err;
 
+	if (priv->common.fw_interface != FW_LM86) {
+		dev_err(&priv->pdev->dev, "wrong firmware, "
+			"please get a LM86(PCI) firmware a try again.\n");
+		return -EINVAL;
+	}
+
 	data = (__le32 *) priv->firmware->data;
 	remains = priv->firmware->size;
 	device_addr = ISL38XX_DEV_FIRMWARE_ADDR;
diff -Nurp a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
--- a/drivers/net/wireless/p54/p54usb.c	2008-12-26 17:47:54.000000000 +0100
+++ b/drivers/net/wireless/p54/p54usb.c	2008-12-26 17:49:12.000000000 +0100
@@ -502,6 +502,13 @@ static int p54u_upload_firmware_3887(str
 	if (err)
 		goto err_upload_failed;
 
+	if (priv->common.fw_interface != FW_LM87) {
+		dev_err(&priv->udev->dev, "wrong firmware, "
+			"please get a LM87 firmware and try again.\n");
+		err = -EINVAL;
+		goto err_upload_failed;
+	}
+
 	left = block_size = min((size_t)P54U_FW_BLOCK, fw_entry->size);
 	strcpy(buf, p54u_firmware_upload_3887);
 	left -= strlen(p54u_firmware_upload_3887);
@@ -652,6 +659,14 @@ static int p54u_upload_firmware_net2280(
 		return err;
 	}
 
+	if (priv->common.fw_interface != FW_LM86) {
+		dev_err(&priv->udev->dev, "wrong firmware, "
+			"please get a LM86(USB) firmware and try again.\n");
+		kfree(buf);
+		release_firmware(fw_entry);
+		return -EINVAL;
+	}
+
 #define P54U_WRITE(type, addr, data) \
 	do {\
 		err = p54u_write(priv, buf, type,\
