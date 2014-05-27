Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:34772 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbaE0K4g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 06:56:36 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 11/16] brcmfmac: use asynchronous firmware request in USB
Date: Tue, 27 May 2014 12:56:23 +0200
Message-ID: <1401188188-16492-12-git-send-email-arend@broadcom.com> (sfid-20140527_125642_640771_9DC495C6)
In-Reply-To: <1401188188-16492-1-git-send-email-arend@broadcom.com>
References: <1401188188-16492-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds use of asynchronous firmware request to
the driver USB layer.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c |   98 +++++++++++++++++--------
 1 file changed, 68 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 8d67940..21335e2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -25,6 +25,7 @@
 #include <dhd_bus.h>
 #include <dhd_dbg.h>
 
+#include "firmware.h"
 #include "usb_rdl.h"
 #include "usb.h"
 
@@ -87,7 +88,7 @@ struct brcmf_usbdev_info {
 	struct brcmf_usbreq *tx_reqs;
 	struct brcmf_usbreq *rx_reqs;
 
-	u8 *image;	/* buffer for combine fw and nvram */
+	const u8 *image;	/* buffer for combine fw and nvram */
 	int image_len;
 
 	struct usb_device *usbdev;
@@ -1021,7 +1022,7 @@ brcmf_usb_fw_download(struct brcmf_usbdev_info *devinfo)
 	}
 
 	err = brcmf_usb_dlstart(devinfo,
-		devinfo->image, devinfo->image_len);
+		(u8 *)devinfo->image, devinfo->image_len);
 	if (err == 0)
 		err = brcmf_usb_dlrun(devinfo);
 	return err;
@@ -1080,7 +1081,22 @@ static int check_file(const u8 *headers)
 	return -1;
 }
 
-static int brcmf_usb_get_fw(struct brcmf_usbdev_info *devinfo)
+static const char *brcmf_usb_get_fwname(struct brcmf_usbdev_info *devinfo)
+{
+	switch (devinfo->bus_pub.devid) {
+	case 43143:
+		return BRCMF_USB_43143_FW_NAME;
+	case 43235:
+	case 43236:
+	case 43238:
+		return BRCMF_USB_43236_FW_NAME;
+	case 43242:
+		return BRCMF_USB_43242_FW_NAME;
+	default:
+		return NULL;
+	}
+}
+static __used int brcmf_usb_get_fw(struct brcmf_usbdev_info *devinfo)
 {
 	s8 *fwname;
 	const struct firmware *fw;
@@ -1202,16 +1218,6 @@ struct brcmf_usbdev *brcmf_usb_attach(struct brcmf_usbdev_info *devinfo,
 		goto error;
 	}
 
-	if (!brcmf_usb_dlneeded(devinfo))
-		return &devinfo->bus_pub;
-
-	brcmf_dbg(USB, "Start fw downloading\n");
-	if (brcmf_usb_get_fw(devinfo))
-		goto error;
-
-	if (brcmf_usb_fw_download(devinfo))
-		goto error;
-
 	return &devinfo->bus_pub;
 
 error:
@@ -1252,12 +1258,47 @@ fail:
 	return ret;
 }
 
+static void brcmf_usb_probe_phase2(struct device *dev,
+				   const struct firmware *fw,
+				   void *nvram, u32 nvlen)
+{
+	struct brcmf_bus *bus = dev_get_drvdata(dev);
+	struct brcmf_usbdev_info *devinfo;
+	int ret;
+
+	brcmf_dbg(USB, "Start fw downloading\n");
+	ret = check_file(fw->data);
+	if (ret < 0) {
+		brcmf_err("invalid firmware\n");
+		release_firmware(fw);
+		goto error;
+	}
+
+	devinfo = bus->bus_priv.usb->devinfo;
+	devinfo->image = fw->data;
+	devinfo->image_len = fw->size;
+
+	ret = brcmf_usb_fw_download(devinfo);
+	release_firmware(fw);
+	if (ret)
+		goto error;
+
+	ret = brcmf_usb_bus_setup(devinfo);
+	if (ret)
+		goto error;
+
+	return;
+error:
+	brcmf_dbg(TRACE, "failed: dev=%s, err=%d\n", dev_name(dev), ret);
+	device_release_driver(dev);
+}
+
 static int brcmf_usb_probe_cb(struct brcmf_usbdev_info *devinfo)
 {
 	struct brcmf_bus *bus = NULL;
 	struct brcmf_usbdev *bus_pub = NULL;
-	int ret;
 	struct device *dev = devinfo->dev;
+	int ret;
 
 	brcmf_dbg(USB, "Enter\n");
 	bus_pub = brcmf_usb_attach(devinfo, BRCMF_USB_NRXQ, BRCMF_USB_NTXQ);
@@ -1280,13 +1321,16 @@ static int brcmf_usb_probe_cb(struct brcmf_usbdev_info *devinfo)
 	bus->proto_type = BRCMF_PROTO_BCDC;
 	bus->always_use_fws_queue = true;
 
-	ret = brcmf_usb_bus_setup(devinfo);
-	if (ret) {
-		brcmf_err("dongle is not responding\n");
-		goto fail;
+	if (!brcmf_usb_dlneeded(devinfo)) {
+		ret = brcmf_usb_bus_setup(devinfo);
+		if (ret)
+			goto fail;
 	}
-
+	/* request firmware here */
+	brcmf_fw_get_firmwares(dev, 0, brcmf_usb_get_fwname(devinfo), NULL,
+			       brcmf_usb_probe_phase2);
 	return 0;
+
 fail:
 	/* Release resources in reverse order */
 	kfree(bus);
@@ -1409,12 +1453,8 @@ brcmf_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	}
 
 	/* Allocate interrupt URB and data buffer */
-	/* RNDIS says 8-byte intr, our old drivers used 4-byte */
-	if (IFEPDESC(usb, CONTROL_IF, 0).wMaxPacketSize == cpu_to_le16(16))
-		devinfo->intr_size = 8;
-	else
-		devinfo->intr_size = 4;
-
+	devinfo->intr_size =
+		le16_to_cpu(IFEPDESC(usb, CONTROL_IF, 0).wMaxPacketSize);
 	devinfo->interval = IFEPDESC(usb, CONTROL_IF, 0).bInterval;
 
 	if (usb->speed == USB_SPEED_SUPER)
@@ -1481,13 +1521,11 @@ static int brcmf_usb_reset_resume(struct usb_interface *intf)
 {
 	struct usb_device *usb = interface_to_usbdev(intf);
 	struct brcmf_usbdev_info *devinfo = brcmf_usb_get_businfo(&usb->dev);
-
 	brcmf_dbg(USB, "Enter\n");
 
-	if (!brcmf_usb_fw_download(devinfo))
-		return brcmf_usb_bus_setup(devinfo);
-
-	return -EIO;
+	return brcmf_fw_get_firmwares(&usb->dev, 0,
+				      brcmf_usb_get_fwname(devinfo), NULL,
+				      brcmf_usb_probe_phase2);
 }
 
 #define BRCMF_USB_VENDOR_ID_BROADCOM	0x0a5c
-- 
1.7.9.5

