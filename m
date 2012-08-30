Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3854 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275Ab2H3Rn0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2012 13:43:26 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 4/5] brcmfmac: Add 43143 USB support.
Date: Thu, 30 Aug 2012 19:43:01 +0200
Message-ID: <1346348582-20095-5-git-send-email-arend@broadcom.com> (sfid-20120830_194332_423106_FED30104)
In-Reply-To: <1346348582-20095-1-git-send-email-arend@broadcom.com>
References: <1346348582-20095-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Added usb device id to list of supported devices. 43143 is a new
802.11n single stream device.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index ecf3f77..78fb17e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -66,6 +66,7 @@
 #define BRCMF_USB_CBCTL_READ	1
 #define BRCMF_USB_MAX_PKT_SIZE	1600
 
+#define BRCMF_USB_43143_FW_NAME	"brcm/brcmfmac43143.bin"
 #define BRCMF_USB_43236_FW_NAME	"brcm/brcmfmac43236b.bin"
 #define BRCMF_USB_43242_FW_NAME	"brcm/brcmfmac43242a.bin"
 
@@ -1113,6 +1114,8 @@ static int brcmf_usb_dlrun(struct brcmf_usbdev_info *devinfo)
 static bool brcmf_usb_chip_support(int chipid, int chiprev)
 {
 	switch(chipid) {
+	case 43143:
+		return true;
 	case 43235:
 	case 43236:
 	case 43238:
@@ -1232,6 +1235,9 @@ static int brcmf_usb_get_fw(struct brcmf_usbdev_info *devinfo)
 		return 0;
 
 	switch (devinfo->bus_pub.devid) {
+	case 43143:
+		fwname = BRCMF_USB_43143_FW_NAME;
+		break;
 	case 43235:
 	case 43236:
 	case 43238:
@@ -1592,11 +1598,13 @@ static int brcmf_usb_resume(struct usb_interface *intf)
 }
 
 #define BRCMF_USB_VENDOR_ID_BROADCOM	0x0a5c
+#define BRCMF_USB_DEVICE_ID_43143	0xbd1e
 #define BRCMF_USB_DEVICE_ID_43236	0xbd17
 #define BRCMF_USB_DEVICE_ID_43242	0xbd1f
 #define BRCMF_USB_DEVICE_ID_BCMFW	0x0bdc
 
 static struct usb_device_id brcmf_usb_devid_table[] = {
+	{ USB_DEVICE(BRCMF_USB_VENDOR_ID_BROADCOM, BRCMF_USB_DEVICE_ID_43143) },
 	{ USB_DEVICE(BRCMF_USB_VENDOR_ID_BROADCOM, BRCMF_USB_DEVICE_ID_43236) },
 	{ USB_DEVICE(BRCMF_USB_VENDOR_ID_BROADCOM, BRCMF_USB_DEVICE_ID_43242) },
 	/* special entry for device with firmware loaded and running */
@@ -1604,6 +1612,7 @@ static struct usb_device_id brcmf_usb_devid_table[] = {
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, brcmf_usb_devid_table);
+MODULE_FIRMWARE(BRCMF_USB_43143_FW_NAME);
 MODULE_FIRMWARE(BRCMF_USB_43236_FW_NAME);
 MODULE_FIRMWARE(BRCMF_USB_43242_FW_NAME);
 
-- 
1.7.9.5


