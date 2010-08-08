Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699Ab0HHCM2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Aug 2010 22:12:28 -0400
Subject: [PATCH 1/5] libertas: [usb] use new firmware locations
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>,
	Holger Schurig <hs4233@mail.mn-solutions.de>
In-Reply-To: <1281233470.6235.12.camel@dcbw.foobar.com>
References: <1281233470.6235.12.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Aug 2010 21:13:57 -0500
Message-ID: <1281233637.6235.14.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Look for firmware where the linux-firmware tree actually puts it, but
fall back to original firmware name & location when the new location
doesn't exist.

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/if_usb.c |   60 ++++++++++++++++++++++++++++----
 drivers/net/wireless/libertas/if_usb.h |    1 +
 2 files changed, 54 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 07ece9d..238de10 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -26,15 +26,25 @@
 
 #define MESSAGE_HEADER_LEN	4
 
-static char *lbs_fw_name = "usb8388.bin";
+static char *lbs_fw_name = NULL;
 module_param_named(fw_name, lbs_fw_name, charp, 0644);
 
+MODULE_FIRMWARE("libertas/usb8388_v9.bin");
+MODULE_FIRMWARE("libertas/usb8388_v5.bin");
+MODULE_FIRMWARE("libertas/usb8388.bin");
+MODULE_FIRMWARE("libertas/usb8682.bin");
 MODULE_FIRMWARE("usb8388.bin");
 
+enum {
+	MODEL_UNKNOWN = 0x0,
+	MODEL_8388 = 0x1,
+	MODEL_8682 = 0x2
+};
+
 static struct usb_device_id if_usb_table[] = {
 	/* Enter the device signature inside */
-	{ USB_DEVICE(0x1286, 0x2001) },
-	{ USB_DEVICE(0x05a3, 0x8388) },
+	{ USB_DEVICE(0x1286, 0x2001), .driver_info = MODEL_8388 },
+	{ USB_DEVICE(0x05a3, 0x8388), .driver_info = MODEL_8388 },
 	{}	/* Terminating entry */
 };
 
@@ -66,6 +76,8 @@ static ssize_t if_usb_firmware_set(struct device *dev,
 	struct if_usb_card *cardp = priv->card;
 	int ret;
 
+	BUG_ON(buf == NULL);
+
 	ret = if_usb_prog_firmware(cardp, buf, BOOT_CMD_UPDATE_FW);
 	if (ret == 0)
 		return count;
@@ -91,6 +103,8 @@ static ssize_t if_usb_boot2_set(struct device *dev,
 	struct if_usb_card *cardp = priv->card;
 	int ret;
 
+	BUG_ON(buf == NULL);
+
 	ret = if_usb_prog_firmware(cardp, buf, BOOT_CMD_UPDATE_BOOT2);
 	if (ret == 0)
 		return count;
@@ -244,6 +258,7 @@ static int if_usb_probe(struct usb_interface *intf,
 	init_waitqueue_head(&cardp->fw_wq);
 
 	cardp->udev = udev;
+	cardp->model = (uint32_t) id->driver_info;
 	iface_desc = intf->cur_altsetting;
 
 	lbs_deb_usbd(&udev->dev, "bcdUSB = 0x%X bDeviceClass = 0x%X"
@@ -921,6 +936,38 @@ static int if_usb_prog_firmware(struct if_usb_card *cardp,
 	return ret;
 }
 
+/* table of firmware file names */
+static const struct {
+	u32 model;
+	const char *fwname;
+} fw_table[] = {
+	{ MODEL_8388, "libertas/usb8388_v9.bin" },
+	{ MODEL_8388, "libertas/usb8388_v5.bin" },
+	{ MODEL_8388, "libertas/usb8388.bin" },
+	{ MODEL_8388, "usb8388.bin" },
+	{ MODEL_8682, "libertas/usb8682.bin" }
+};
+
+static int get_fw(struct if_usb_card *cardp, const char *fwname)
+{
+	int i;
+
+	/* Try user-specified firmware first */
+	if (fwname)
+		return request_firmware(&cardp->fw, fwname, &cardp->udev->dev);
+
+	/* Otherwise search for firmware to use */
+	for (i = 0; i < ARRAY_SIZE(fw_table); i++) {
+		if (fw_table[i].model != cardp->model)
+			continue;
+		if (request_firmware(&cardp->fw, fw_table[i].fwname,
+					&cardp->udev->dev) == 0)
+			return 0;
+	}
+
+	return -ENOENT;
+}
+
 static int __if_usb_prog_firmware(struct if_usb_card *cardp,
 					const char *fwname, int cmd)
 {
@@ -930,10 +977,9 @@ static int __if_usb_prog_firmware(struct if_usb_card *cardp,
 
 	lbs_deb_enter(LBS_DEB_USB);
 
-	ret = request_firmware(&cardp->fw, fwname, &cardp->udev->dev);
-	if (ret < 0) {
-		lbs_pr_err("request_firmware() failed with %#x\n", ret);
-		lbs_pr_err("firmware %s not found\n", fwname);
+	ret = get_fw(cardp, fwname);
+	if (ret) {
+		lbs_pr_err("failed to find firmware (%d)\n", ret);
 		goto done;
 	}
 
diff --git a/drivers/net/wireless/libertas/if_usb.h b/drivers/net/wireless/libertas/if_usb.h
index 5ba0aee..d819e7e 100644
--- a/drivers/net/wireless/libertas/if_usb.h
+++ b/drivers/net/wireless/libertas/if_usb.h
@@ -43,6 +43,7 @@ struct bootcmdresp
 /** USB card description structure*/
 struct if_usb_card {
 	struct usb_device *udev;
+	uint32_t model;  /* MODEL_* */
 	struct urb *rx_urb, *tx_urb;
 	struct lbs_private *priv;
 
-- 
1.7.2.1


