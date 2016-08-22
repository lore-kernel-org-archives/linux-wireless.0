Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iodev.co.uk ([82.211.30.53]:60326 "EHLO iodev.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754721AbcHVWk2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Aug 2016 18:40:28 -0400
From: Ismael Luceno <ismael@iodev.co.uk>
To: linux-wireless@vger.kernel.org
Cc: Ismael Luceno <ismael@iodev.co.uk>,
        brcm80211-dev-list@broadcom.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH v2] brcmfmac: Add USB ID for Cisco Linksys AE1200
Date: Mon, 22 Aug 2016 19:40:07 -0300
Message-Id: <20160822224007.300-1-ismael@iodev.co.uk> (sfid-20160823_004032_007231_23E78B11)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The AE1200 comes with different revisions of the BCM43235 chipset,
but all have the same USB ID. Only revision 3 can be supported.

Signed-off-by: Ismael Luceno <ismael@iodev.co.uk>
---
Changes since v1:
 - Keep the long device ID in a single line.
 - Added desc. about supported devices.

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c        | 4 ++++
 drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index 66c26a92b29c..5ec005e9f9d7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -1447,11 +1447,15 @@ static int brcmf_usb_reset_resume(struct usb_interface *intf)
 #define BRCMF_USB_DEVICE(dev_id)	\
 	{ USB_DEVICE(BRCM_USB_VENDOR_ID_BROADCOM, dev_id) }
 
+#define LINKSYS_USB_DEVICE(dev_id)	\
+	{ USB_DEVICE(BRCM_USB_VENDOR_ID_LINKSYS, dev_id) }
+
 static struct usb_device_id brcmf_usb_devid_table[] = {
 	BRCMF_USB_DEVICE(BRCM_USB_43143_DEVICE_ID),
 	BRCMF_USB_DEVICE(BRCM_USB_43236_DEVICE_ID),
 	BRCMF_USB_DEVICE(BRCM_USB_43242_DEVICE_ID),
 	BRCMF_USB_DEVICE(BRCM_USB_43569_DEVICE_ID),
+	LINKSYS_USB_DEVICE(BRCM_USB_43235_LINKSYS_DEVICE_ID),
 	{ USB_DEVICE(BRCM_USB_VENDOR_ID_LG, BRCM_USB_43242_LG_DEVICE_ID) },
 	/* special entry for device with firmware loaded and running */
 	BRCMF_USB_DEVICE(BRCM_USB_BCMFW_DEVICE_ID),
diff --git a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
index 699f2c2782ee..f207c2693877 100644
--- a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
+++ b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
@@ -22,6 +22,7 @@
 
 #define BRCM_USB_VENDOR_ID_BROADCOM	0x0a5c
 #define BRCM_USB_VENDOR_ID_LG		0x043e
+#define BRCM_USB_VENDOR_ID_LINKSYS	0x13b1
 #define BRCM_PCIE_VENDOR_ID_BROADCOM	PCI_VENDOR_ID_BROADCOM
 
 /* Chipcommon Core Chip IDs */
@@ -56,6 +57,7 @@
 
 /* USB Device IDs */
 #define BRCM_USB_43143_DEVICE_ID	0xbd1e
+#define BRCM_USB_43235_LINKSYS_DEVICE_ID	0x0039
 #define BRCM_USB_43236_DEVICE_ID	0xbd17
 #define BRCM_USB_43242_DEVICE_ID	0xbd1f
 #define BRCM_USB_43242_LG_DEVICE_ID	0x3101
-- 
2.9.2
