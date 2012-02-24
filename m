Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40289 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab2BXGXG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 01:23:06 -0500
Received: by eaah12 with SMTP id h12so921094eaa.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2012 22:23:05 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH] brcm80211: fmac: use correct firmware filename
Date: Fri, 24 Feb 2012 07:22:51 +0100
Message-Id: <1330064571-4455-1-git-send-email-zajec5@gmail.com> (sfid-20120224_072310_453023_645B9B4C)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also don't use so generic BRCMF_USB_FW_NAME as we may need different
firmwares in the future.

Cc: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 934ed78..9c14435 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -65,7 +65,7 @@
 #define BRCMF_USB_CBCTL_READ	1
 #define BRCMF_USB_MAX_PKT_SIZE	1600
 
-#define BRCMF_USB_FW_NAME	"brcm/brcmfmac-usb.bin"
+#define BRCMF_USB_43236_FW_NAME	"brcm/brcmfmac43236b.bin"
 
 enum usbdev_suspend_state {
 	USBOS_SUSPEND_STATE_DEVICE_ACTIVE = 0, /* Device is busy, won't allow
@@ -1229,7 +1229,7 @@ static int brcmf_usb_get_fw(struct brcmf_usbdev_info *devinfo)
 	if (devinfo->image)
 		return 0;
 
-	fwname = BRCMF_USB_FW_NAME;
+	fwname = BRCMF_USB_43236_FW_NAME;
 
 	err = request_firmware(&fw, fwname, devinfo->dev);
 	if (!fw) {
@@ -1596,7 +1596,7 @@ static struct usb_device_id brcmf_usb_devid_table[] = {
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, brcmf_usb_devid_table);
-MODULE_FIRMWARE(BRCMF_USB_FW_NAME);
+MODULE_FIRMWARE(BRCMF_USB_43236_FW_NAME);
 
 /* TODO: suspend and resume entries */
 static struct usb_driver brcmf_usbdrvr = {
-- 
1.7.7

