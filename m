Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3671 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342Ab2H3Rn3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2012 13:43:29 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 3/5] brcmfmac: Add 43242 USB support.
Date: Thu, 30 Aug 2012 19:43:00 +0200
Message-ID: <1346348582-20095-4-git-send-email-arend@broadcom.com> (sfid-20120830_194336_880018_F98F1A77)
In-Reply-To: <1346348582-20095-1-git-send-email-arend@broadcom.com>
References: <1346348582-20095-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Added usb device id to list of supported devices. 43242 is the new
802.11n 2x2 MIMO device.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index ac1ed1f..ecf3f77 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -67,6 +67,7 @@
 #define BRCMF_USB_MAX_PKT_SIZE	1600
 
 #define BRCMF_USB_43236_FW_NAME	"brcm/brcmfmac43236b.bin"
+#define BRCMF_USB_43242_FW_NAME	"brcm/brcmfmac43242a.bin"
 
 enum usbdev_suspend_state {
 	USBOS_SUSPEND_STATE_DEVICE_ACTIVE = 0, /* Device is busy, won't allow
@@ -1116,6 +1117,8 @@ static bool brcmf_usb_chip_support(int chipid, int chiprev)
 	case 43236:
 	case 43238:
 		return (chiprev == 3);
+	case 43242:
+		return true;
 	default:
 		break;
 	}
@@ -1228,7 +1231,19 @@ static int brcmf_usb_get_fw(struct brcmf_usbdev_info *devinfo)
 	if (devinfo->image)
 		return 0;
 
-	fwname = BRCMF_USB_43236_FW_NAME;
+	switch (devinfo->bus_pub.devid) {
+	case 43235:
+	case 43236:
+	case 43238:
+		fwname = BRCMF_USB_43236_FW_NAME;
+		break;
+	case 43242:
+		fwname = BRCMF_USB_43242_FW_NAME;
+		break;
+	default:
+		return -EINVAL;
+		break;
+	}
 
 	err = request_firmware(&fw, fwname, devinfo->dev);
 	if (!fw) {
@@ -1578,16 +1593,19 @@ static int brcmf_usb_resume(struct usb_interface *intf)
 
 #define BRCMF_USB_VENDOR_ID_BROADCOM	0x0a5c
 #define BRCMF_USB_DEVICE_ID_43236	0xbd17
+#define BRCMF_USB_DEVICE_ID_43242	0xbd1f
 #define BRCMF_USB_DEVICE_ID_BCMFW	0x0bdc
 
 static struct usb_device_id brcmf_usb_devid_table[] = {
 	{ USB_DEVICE(BRCMF_USB_VENDOR_ID_BROADCOM, BRCMF_USB_DEVICE_ID_43236) },
+	{ USB_DEVICE(BRCMF_USB_VENDOR_ID_BROADCOM, BRCMF_USB_DEVICE_ID_43242) },
 	/* special entry for device with firmware loaded and running */
 	{ USB_DEVICE(BRCMF_USB_VENDOR_ID_BROADCOM, BRCMF_USB_DEVICE_ID_BCMFW) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, brcmf_usb_devid_table);
 MODULE_FIRMWARE(BRCMF_USB_43236_FW_NAME);
+MODULE_FIRMWARE(BRCMF_USB_43242_FW_NAME);
 
 /* TODO: suspend and resume entries */
 static struct usb_driver brcmf_usbdrvr = {
-- 
1.7.9.5


