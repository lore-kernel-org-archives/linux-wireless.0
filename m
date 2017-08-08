Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36114 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752122AbdHHQBi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 12:01:38 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: kvalo@codeaurora.org, petkan@nucleusys.com,
        arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        wright.feng@cypress.com, hante.meuleman@broadcom.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Subject: [PATCH 21/35] wireless: broadcom: brcm80211: constify usb_device_id
Date: Tue,  8 Aug 2017 21:31:26 +0530
Message-Id: <1502208086-11916-1-git-send-email-arvind.yadav.cs@gmail.com> (sfid-20170808_180206_826214_9E8DF5A1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

usb_device_id are not supposed to change at runtime. All functions
working with usb_device_id provided by <linux/usb.h> work with
const usb_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index 0eea48e..51562b0 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -1463,7 +1463,7 @@ static int brcmf_usb_reset_resume(struct usb_interface *intf)
 #define LINKSYS_USB_DEVICE(dev_id)	\
 	{ USB_DEVICE(BRCM_USB_VENDOR_ID_LINKSYS, dev_id) }
 
-static struct usb_device_id brcmf_usb_devid_table[] = {
+static const struct usb_device_id brcmf_usb_devid_table[] = {
 	BRCMF_USB_DEVICE(BRCM_USB_43143_DEVICE_ID),
 	BRCMF_USB_DEVICE(BRCM_USB_43236_DEVICE_ID),
 	BRCMF_USB_DEVICE(BRCM_USB_43242_DEVICE_ID),
-- 
2.7.4
