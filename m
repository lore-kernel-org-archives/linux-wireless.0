Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33521 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752768AbdHHQCD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 12:02:03 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: kvalo@codeaurora.org, elena.reshetova@intel.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH 22/35] wireless: intersil: orinoco: constify usb_device_id
Date: Tue,  8 Aug 2017 21:31:53 +0530
Message-Id: <1502208113-11966-1-git-send-email-arvind.yadav.cs@gmail.com> (sfid-20170808_180901_512405_879F8573)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

usb_device_id are not supposed to change at runtime. All functions
working with usb_device_id provided by <linux/usb.h> work with
const usb_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/net/wireless/intersil/orinoco/orinoco_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
index c84fd84..56f6e3b 100644
--- a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
@@ -210,7 +210,7 @@ struct ezusb_packet {
 } __packed;
 
 /* Table of devices that work or may work with this driver */
-static struct usb_device_id ezusb_table[] = {
+static const struct usb_device_id ezusb_table[] = {
 	{USB_DEVICE(USB_COMPAQ_VENDOR_ID, USB_COMPAQ_WL215_ID)},
 	{USB_DEVICE(USB_COMPAQ_VENDOR_ID, USB_HP_WL215_ID)},
 	{USB_DEVICE(USB_COMPAQ_VENDOR_ID, USB_COMPAQ_W200_ID)},
-- 
2.7.4
