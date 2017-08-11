Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36848 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750815AbdHKFYU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Aug 2017 01:24:20 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@codeaurora.org,
        chi-hsien.lin@cypress.com, wsa-dev@sang-engineering.com
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 06/20] brcm80211: constify usb_device_id
Date: Fri, 11 Aug 2017 10:53:50 +0530
Message-Id: <ff83342cc9413d79ba18e05b2cb0b53bff338b2f.1502428689.git.arvind.yadav.cs@gmail.com> (sfid-20170811_072441_216244_CC3A8EB3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

usb_device_id are not supposed to change at runtime. All functions
working with usb_device_id provided by <linux/usb.h> work with
const usb_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
changes in v2:
              Re-submitting wireless separately.
changes in v3:
              Resolve Merge conflic.

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index 8f20a4b..11ffaa0 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -1468,7 +1468,7 @@ static int brcmf_usb_reset_resume(struct usb_interface *intf)
 #define CYPRESS_USB_DEVICE(dev_id)	\
 	{ USB_DEVICE(CY_USB_VENDOR_ID_CYPRESS, dev_id) }
 
-static struct usb_device_id brcmf_usb_devid_table[] = {
+static const struct usb_device_id brcmf_usb_devid_table[] = {
 	BRCMF_USB_DEVICE(BRCM_USB_43143_DEVICE_ID),
 	BRCMF_USB_DEVICE(BRCM_USB_43236_DEVICE_ID),
 	BRCMF_USB_DEVICE(BRCM_USB_43242_DEVICE_ID),
-- 
1.9.1
