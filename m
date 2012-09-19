Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3070 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668Ab2ISUVi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2012 16:21:38 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 05/13] brcmfmac: store usb fw images in local linked
 list.
Date: Wed, 19 Sep 2012 22:21:10 +0200
Message-ID: <1348086078-19183-6-git-send-email-arend@broadcom.com> (sfid-20120919_222552_789677_04A1FFE1)
In-Reply-To: <1348086078-19183-1-git-send-email-arend@broadcom.com>
References: <1348086078-19183-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

For suspend/resume it is necessary to store firmware in memory.
In order to support multiple usb dongles at the same time a linked
list of firmwares was created.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c |   64 ++++++++++++++++---------
 1 file changed, 41 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 03f59cd..edb4311 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -81,10 +81,12 @@ enum usbdev_suspend_state {
 };
 
 struct brcmf_usb_image {
-	void *data;
-	u32 len;
+	struct list_head list;
+	s8 *fwname;
+	u8 *image;
+	int image_len;
 };
-static struct brcmf_usb_image g_image = { NULL, 0 };
+static struct list_head fw_image_list;
 
 struct intr_transfer_buf {
 	u32 notification;
@@ -1152,10 +1154,6 @@ static void brcmf_usb_detach(struct brcmf_usbdev_info *devinfo)
 {
 	brcmf_dbg(TRACE, "devinfo %p\n", devinfo);
 
-	/* store the image globally */
-	g_image.data = devinfo->image;
-	g_image.len = devinfo->image_len;
-
 	/* free the URBS */
 	brcmf_usb_free_q(&devinfo->rx_freeq, false);
 	brcmf_usb_free_q(&devinfo->tx_freeq, false);
@@ -1207,17 +1205,9 @@ static int brcmf_usb_get_fw(struct brcmf_usbdev_info *devinfo)
 {
 	s8 *fwname;
 	const struct firmware *fw;
+	struct brcmf_usb_image *fw_image;
 	int err;
 
-	devinfo->image = g_image.data;
-	devinfo->image_len = g_image.len;
-
-	/*
-	 * if we have an image we can leave here.
-	 */
-	if (devinfo->image)
-		return 0;
-
 	switch (devinfo->bus_pub.devid) {
 	case 43143:
 		fwname = BRCMF_USB_43143_FW_NAME;
@@ -1235,6 +1225,14 @@ static int brcmf_usb_get_fw(struct brcmf_usbdev_info *devinfo)
 		break;
 	}
 
+	list_for_each_entry(fw_image, &fw_image_list, list) {
+		if (fw_image->fwname == fwname) {
+			devinfo->image = fw_image->image;
+			devinfo->image_len = fw_image->image_len;
+			return 0;
+		}
+	}
+	/* fw image not yet loaded. Load it now and add to list */
 	err = request_firmware(&fw, fwname, devinfo->dev);
 	if (!fw) {
 		brcmf_dbg(ERROR, "fail to request firmware %s\n", fwname);
@@ -1245,14 +1243,24 @@ static int brcmf_usb_get_fw(struct brcmf_usbdev_info *devinfo)
 		return -EINVAL;
 	}
 
-	devinfo->image = vmalloc(fw->size); /* plus nvram */
-	if (!devinfo->image)
+	fw_image = kzalloc(sizeof(*fw_image), GFP_ATOMIC);
+	if (!fw_image)
+		return -ENOMEM;
+	INIT_LIST_HEAD(&fw_image->list);
+	list_add_tail(&fw_image->list, &fw_image_list);
+	fw_image->fwname = fwname;
+	fw_image->image = vmalloc(fw->size);
+	if (!fw_image->image)
 		return -ENOMEM;
 
-	memcpy(devinfo->image, fw->data, fw->size);
-	devinfo->image_len = fw->size;
+	memcpy(fw_image->image, fw->data, fw->size);
+	fw_image->image_len = fw->size;
 
 	release_firmware(fw);
+
+	devinfo->image = fw_image->image;
+	devinfo->image_len = fw_image->image_len;
+
 	return 0;
 }
 
@@ -1594,15 +1602,25 @@ static struct usb_driver brcmf_usbdrvr = {
 	.disable_hub_initiated_lpm = 1,
 };
 
+static void brcmf_release_fw(struct list_head *q)
+{
+	struct brcmf_usb_image *fw_image, *next;
+
+	list_for_each_entry_safe(fw_image, next, q, list) {
+		vfree(fw_image->image);
+		list_del_init(&fw_image->list);
+	}
+}
+
+
 void brcmf_usb_exit(void)
 {
 	usb_deregister(&brcmf_usbdrvr);
-	vfree(g_image.data);
-	g_image.data = NULL;
-	g_image.len = 0;
+	brcmf_release_fw(&fw_image_list);
 }
 
 void brcmf_usb_init(void)
 {
+	INIT_LIST_HEAD(&fw_image_list);
 	usb_register(&brcmf_usbdrvr);
 }
-- 
1.7.9.5


