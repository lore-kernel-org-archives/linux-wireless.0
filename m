Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iodev.co.uk ([82.211.30.53]:56826 "EHLO iodev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547AbcFUBNt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2016 21:13:49 -0400
From: Ismael Luceno <ismael@iodev.co.uk>
To: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list@broadcom.com, Ismael Luceno <ismael@iodev.co.uk>
Subject: [PATCH] brcmfmac: Add USB ID for Cisco Linksys AE1200
Date: Mon, 20 Jun 2016 21:18:41 -0300
Message-Id: <20160621001841.5383-1-ismael@iodev.co.uk> (sfid-20160621_031354_040437_757E0658)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ismael Luceno <ismael@iodev.co.uk>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c        | 4 ++++
 drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index 98b15a9..455fc69 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -1462,11 +1462,15 @@ static int brcmf_usb_reset_resume(struct usb_interface *intf)
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
index 699f2c2..6666513 100644
--- a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
+++ b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
@@ -22,6 +22,7 @@
 
 #define BRCM_USB_VENDOR_ID_BROADCOM	0x0a5c
 #define BRCM_USB_VENDOR_ID_LG		0x043e
+#define BRCM_USB_VENDOR_ID_LINKSYS	0x13b1
 #define BRCM_PCIE_VENDOR_ID_BROADCOM	PCI_VENDOR_ID_BROADCOM
 
 /* Chipcommon Core Chip IDs */
@@ -56,6 +57,8 @@
 
 /* USB Device IDs */
 #define BRCM_USB_43143_DEVICE_ID	0xbd1e
+#define BRCM_USB_43235_LINKSYS_DEVICE_ID \
+					0x0039
 #define BRCM_USB_43236_DEVICE_ID	0xbd17
 #define BRCM_USB_43242_DEVICE_ID	0xbd1f
 #define BRCM_USB_43242_LG_DEVICE_ID	0x3101
-- 
2.9.0

