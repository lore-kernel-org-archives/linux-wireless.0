Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:1356 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbaE0K4j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 06:56:39 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 16/16] brcmfmac: remove firmware list from USB driver
Date: Tue, 27 May 2014 12:56:28 +0200
Message-ID: <1401188188-16492-17-git-send-email-arend@broadcom.com> (sfid-20140527_125715_428504_39C504B0)
In-Reply-To: <1401188188-16492-1-git-send-email-arend@broadcom.com>
References: <1401188188-16492-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The USB driver was using a list for firmware info that was
used in suspend/resume scenario. Now that brcmfmac is using
the asynchronous firmware request this is no longer needed.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c |   76 -------------------------
 1 file changed, 76 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index fa440ba..6db51a6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -62,7 +62,6 @@ struct brcmf_usb_image {
 	u8 *image;
 	int image_len;
 };
-static struct list_head fw_image_list;
 
 struct brcmf_usbdev_info {
 	struct brcmf_usbdev bus_pub; /* MUST BE FIRST */
@@ -1033,69 +1032,6 @@ static const char *brcmf_usb_get_fwname(struct brcmf_usbdev_info *devinfo)
 		return NULL;
 	}
 }
-static __used int brcmf_usb_get_fw(struct brcmf_usbdev_info *devinfo)
-{
-	s8 *fwname;
-	const struct firmware *fw;
-	struct brcmf_usb_image *fw_image;
-	int err;
-
-	brcmf_dbg(USB, "Enter\n");
-	switch (devinfo->bus_pub.devid) {
-	case 43143:
-		fwname = BRCMF_USB_43143_FW_NAME;
-		break;
-	case 43235:
-	case 43236:
-	case 43238:
-		fwname = BRCMF_USB_43236_FW_NAME;
-		break;
-	case 43242:
-		fwname = BRCMF_USB_43242_FW_NAME;
-		break;
-	default:
-		return -EINVAL;
-		break;
-	}
-	brcmf_dbg(USB, "Loading FW %s\n", fwname);
-	list_for_each_entry(fw_image, &fw_image_list, list) {
-		if (fw_image->fwname == fwname) {
-			devinfo->image = fw_image->image;
-			devinfo->image_len = fw_image->image_len;
-			return 0;
-		}
-	}
-	/* fw image not yet loaded. Load it now and add to list */
-	err = request_firmware(&fw, fwname, devinfo->dev);
-	if (!fw) {
-		brcmf_err("fail to request firmware %s\n", fwname);
-		return err;
-	}
-	if (check_file(fw->data) < 0) {
-		brcmf_err("invalid firmware %s\n", fwname);
-		return -EINVAL;
-	}
-
-	fw_image = kzalloc(sizeof(*fw_image), GFP_ATOMIC);
-	if (!fw_image)
-		return -ENOMEM;
-	INIT_LIST_HEAD(&fw_image->list);
-	list_add_tail(&fw_image->list, &fw_image_list);
-	fw_image->fwname = fwname;
-	fw_image->image = vmalloc(fw->size);
-	if (!fw_image->image)
-		return -ENOMEM;
-
-	memcpy(fw_image->image, fw->data, fw->size);
-	fw_image->image_len = fw->size;
-
-	release_firmware(fw);
-
-	devinfo->image = fw_image->image;
-	devinfo->image_len = fw_image->image_len;
-
-	return 0;
-}
 
 
 static
@@ -1484,16 +1420,6 @@ static struct usb_driver brcmf_usbdrvr = {
 	.disable_hub_initiated_lpm = 1,
 };
 
-static void brcmf_release_fw(struct list_head *q)
-{
-	struct brcmf_usb_image *fw_image, *next;
-
-	list_for_each_entry_safe(fw_image, next, q, list) {
-		vfree(fw_image->image);
-		list_del_init(&fw_image->list);
-	}
-}
-
 static int brcmf_usb_reset_device(struct device *dev, void *notused)
 {
 	/* device past is the usb interface so we
@@ -1512,12 +1438,10 @@ void brcmf_usb_exit(void)
 	ret = driver_for_each_device(drv, NULL, NULL,
 				     brcmf_usb_reset_device);
 	usb_deregister(&brcmf_usbdrvr);
-	brcmf_release_fw(&fw_image_list);
 }
 
 void brcmf_usb_register(void)
 {
 	brcmf_dbg(USB, "Enter\n");
-	INIT_LIST_HEAD(&fw_image_list);
 	usb_register(&brcmf_usbdrvr);
 }
-- 
1.7.9.5

