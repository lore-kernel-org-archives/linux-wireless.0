Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:11020 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbbLJMnp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2015 07:43:45 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH V2 10/13] brcmfmac: add 43242 device id for LG dongle
Date: Thu, 10 Dec 2015 13:43:09 +0100
Message-ID: <1449751392-32569-11-git-send-email-arend@broadcom.com> (sfid-20151210_140058_181057_29C9B394)
In-Reply-To: <1449751392-32569-1-git-send-email-arend@broadcom.com>
References: <1449751392-32569-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Got a hint on IRC that a 43242 dongle for LG smart TV's works with
brcmfmac:

> Hello - I recently got a LG AN-WF500 wireless dongle for LG's SmartTVs.
> From the information I gathered it uses a Broadcom chipset BCM43242.
> The device should have been supported by brcmfmac kernel driver if it used
> USB IDs 0a5c:bd1f.
> My device however identifies itself as "ID 043e:3101 LG Electronics USA, Inc.".
> I then tried adding the USB ID to the driver with
> "echo "043e 3101" > /sys/bus/usb/drivers/brcmfmac/new_id" and it just works.
> The kernel provides the following information.
> [15958.851291] usb 3-1.1.3: new high-speed USB device number 53 using ehci-pci
> [15958.946723] usb 3-1.1.3: New USB device found, idVendor=043e, idProduct=3101
> [15958.946728] usb 3-1.1.3: New USB device strings: Mfr=1, Product=4, SerialNumber=3
> [15958.946731] usb 3-1.1.3: Product: Composite Wireless Adapter
> [15958.946733] usb 3-1.1.3: Manufacturer: Broadcom
> [15958.946735] usb 3-1.1.3: SerialNumber: 28458

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c        | 1 +
 drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index 23eaf0f..66c26a9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -1452,6 +1452,7 @@ static struct usb_device_id brcmf_usb_devid_table[] = {
 	BRCMF_USB_DEVICE(BRCM_USB_43236_DEVICE_ID),
 	BRCMF_USB_DEVICE(BRCM_USB_43242_DEVICE_ID),
 	BRCMF_USB_DEVICE(BRCM_USB_43569_DEVICE_ID),
+	{ USB_DEVICE(BRCM_USB_VENDOR_ID_LG, BRCM_USB_43242_LG_DEVICE_ID) },
 	/* special entry for device with firmware loaded and running */
 	BRCMF_USB_DEVICE(BRCM_USB_BCMFW_DEVICE_ID),
 	{ /* end: all zeroes */ }
diff --git a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
index 4092d27..699f2c2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
+++ b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
@@ -21,6 +21,7 @@
 #include <linux/mmc/sdio_ids.h>
 
 #define BRCM_USB_VENDOR_ID_BROADCOM	0x0a5c
+#define BRCM_USB_VENDOR_ID_LG		0x043e
 #define BRCM_PCIE_VENDOR_ID_BROADCOM	PCI_VENDOR_ID_BROADCOM
 
 /* Chipcommon Core Chip IDs */
@@ -57,6 +58,7 @@
 #define BRCM_USB_43143_DEVICE_ID	0xbd1e
 #define BRCM_USB_43236_DEVICE_ID	0xbd17
 #define BRCM_USB_43242_DEVICE_ID	0xbd1f
+#define BRCM_USB_43242_LG_DEVICE_ID	0x3101
 #define BRCM_USB_43569_DEVICE_ID	0xbd27
 #define BRCM_USB_BCMFW_DEVICE_ID	0x0bdc
 
-- 
1.9.1

