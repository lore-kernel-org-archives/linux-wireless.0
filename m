Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1548 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217Ab3CCLqO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Mar 2013 06:46:14 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 04/13] brcmfmac: cleanup module information macros
Date: Sun, 3 Mar 2013 12:45:23 +0100
Message-ID: <1362311132-29561-5-git-send-email-arend@broadcom.com> (sfid-20130303_131304_306396_BDB0ED58)
In-Reply-To: <1362311132-29561-1-git-send-email-arend@broadcom.com>
References: <1362311132-29561-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The output of modinfo shows a bit of strangeness because module
information macros are used in multiple source files:

license:        Dual BSD/GPL
description:    Broadcom 802.11 wireless LAN fullmac driver.
author:         Broadcom Corporation
firmware:       brcm/brcmfmac-sdio.txt
firmware:       brcm/brcmfmac-sdio.bin
firmware:       brcm/brcmfmac43236b.bin
license:        Dual BSD/GPL
description:    Broadcom 802.11n wireless LAN fullmac usb driver.
author:         Broadcom Corporation

This patch cleans it up.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    1 -
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |    6 +-----
 2 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index a4d01f3..5b92341 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -33,7 +33,6 @@
 
 MODULE_AUTHOR("Broadcom Corporation");
 MODULE_DESCRIPTION("Broadcom 802.11 wireless LAN fullmac driver.");
-MODULE_SUPPORTED_DEVICE("Broadcom 802.11 WLAN fullmac cards");
 MODULE_LICENSE("Dual BSD/GPL");
 
 #define MAX_WAIT_FOR_8021X_TX		50	/* msecs */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index a55994d..2e8f938 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -112,11 +112,6 @@ struct brcmf_usbdev_info {
 static void brcmf_usb_rx_refill(struct brcmf_usbdev_info *devinfo,
 				struct brcmf_usbreq  *req);
 
-MODULE_AUTHOR("Broadcom Corporation");
-MODULE_DESCRIPTION("Broadcom 802.11n wireless LAN fullmac usb driver.");
-MODULE_SUPPORTED_DEVICE("Broadcom 802.11n WLAN fullmac usb cards");
-MODULE_LICENSE("Dual BSD/GPL");
-
 static struct brcmf_usbdev *brcmf_usb_get_buspub(struct device *dev)
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
@@ -1486,6 +1481,7 @@ static struct usb_device_id brcmf_usb_devid_table[] = {
 	{ USB_DEVICE(BRCMF_USB_VENDOR_ID_BROADCOM, BRCMF_USB_DEVICE_ID_BCMFW) },
 	{ }
 };
+
 MODULE_DEVICE_TABLE(usb, brcmf_usb_devid_table);
 MODULE_FIRMWARE(BRCMF_USB_43143_FW_NAME);
 MODULE_FIRMWARE(BRCMF_USB_43236_FW_NAME);
-- 
1.7.6


