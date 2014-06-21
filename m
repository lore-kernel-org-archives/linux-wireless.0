Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:45198 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245AbaFUKLX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jun 2014 06:11:23 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 1/8] brcmfmac: Add 43569 USB support.
Date: Sat, 21 Jun 2014 12:11:12 +0200
Message-ID: <1403345479-13467-2-git-send-email-arend@broadcom.com> (sfid-20140621_121129_396787_66EE5133)
In-Reply-To: <1403345479-13467-1-git-send-email-arend@broadcom.com>
References: <1403345479-13467-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Added usb device id for the new device 43569 to the list of
supported devices.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 6db51a6..aa23559 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -55,6 +55,7 @@
 #define BRCMF_USB_43143_FW_NAME	"brcm/brcmfmac43143.bin"
 #define BRCMF_USB_43236_FW_NAME	"brcm/brcmfmac43236b.bin"
 #define BRCMF_USB_43242_FW_NAME	"brcm/brcmfmac43242a.bin"
+#define BRCMF_USB_43569_FW_NAME	"brcm/brcmfmac43569.bin"
 
 struct brcmf_usb_image {
 	struct list_head list;
@@ -928,6 +929,8 @@ static bool brcmf_usb_chip_support(int chipid, int chiprev)
 		return (chiprev == 3);
 	case 43242:
 		return true;
+	case 43569:
+		return true;
 	default:
 		break;
 	}
@@ -1028,6 +1031,8 @@ static const char *brcmf_usb_get_fwname(struct brcmf_usbdev_info *devinfo)
 		return BRCMF_USB_43236_FW_NAME;
 	case 43242:
 		return BRCMF_USB_43242_FW_NAME;
+	case 43569:
+		return BRCMF_USB_43569_FW_NAME;
 	default:
 		return NULL;
 	}
@@ -1229,7 +1234,7 @@ brcmf_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	u8 endpoint_num;
 	struct brcmf_usbdev_info *devinfo;
 
-	brcmf_dbg(USB, "Enter\n");
+	brcmf_dbg(USB, "Enter 0x%04x:0x%04x\n", id->idVendor, id->idProduct);
 
 	devinfo = kzalloc(sizeof(*devinfo), GFP_ATOMIC);
 	if (devinfo == NULL)
@@ -1392,12 +1397,14 @@ static int brcmf_usb_reset_resume(struct usb_interface *intf)
 #define BRCMF_USB_DEVICE_ID_43143	0xbd1e
 #define BRCMF_USB_DEVICE_ID_43236	0xbd17
 #define BRCMF_USB_DEVICE_ID_43242	0xbd1f
+#define BRCMF_USB_DEVICE_ID_43569	0xbd27
 #define BRCMF_USB_DEVICE_ID_BCMFW	0x0bdc
 
 static struct usb_device_id brcmf_usb_devid_table[] = {
 	{ USB_DEVICE(BRCMF_USB_VENDOR_ID_BROADCOM, BRCMF_USB_DEVICE_ID_43143) },
 	{ USB_DEVICE(BRCMF_USB_VENDOR_ID_BROADCOM, BRCMF_USB_DEVICE_ID_43236) },
 	{ USB_DEVICE(BRCMF_USB_VENDOR_ID_BROADCOM, BRCMF_USB_DEVICE_ID_43242) },
+	{ USB_DEVICE(BRCMF_USB_VENDOR_ID_BROADCOM, BRCMF_USB_DEVICE_ID_43569) },
 	/* special entry for device with firmware loaded and running */
 	{ USB_DEVICE(BRCMF_USB_VENDOR_ID_BROADCOM, BRCMF_USB_DEVICE_ID_BCMFW) },
 	{ }
@@ -1407,6 +1414,7 @@ MODULE_DEVICE_TABLE(usb, brcmf_usb_devid_table);
 MODULE_FIRMWARE(BRCMF_USB_43143_FW_NAME);
 MODULE_FIRMWARE(BRCMF_USB_43236_FW_NAME);
 MODULE_FIRMWARE(BRCMF_USB_43242_FW_NAME);
+MODULE_FIRMWARE(BRCMF_USB_43569_FW_NAME);
 
 static struct usb_driver brcmf_usbdrvr = {
 	.name = KBUILD_MODNAME,
-- 
1.7.9.5

