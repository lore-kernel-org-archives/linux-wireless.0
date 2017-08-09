Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:38216 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751944AbdHISDU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Aug 2017 14:03:20 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: sameo@linux.intel.com, stephen@networkplumber.org
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] NFC: nfcmrvl: constify usb_device_id
Date: Wed,  9 Aug 2017 23:33:11 +0530
Message-Id: <339b58be7bd3cd1b3ca3310e4a8500d6c8bc1fdf.1502301580.git.arvind.yadav.cs@gmail.com> (sfid-20170809_200333_603526_1F692303)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

usb_device_id are not supposed to change at runtime. All functions
working with usb_device_id provided by <linux/usb.h> work with
const usb_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/nfc/nfcmrvl/usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/nfcmrvl/usb.c b/drivers/nfc/nfcmrvl/usb.c
index bd35eab..46e11fc 100644
--- a/drivers/nfc/nfcmrvl/usb.c
+++ b/drivers/nfc/nfcmrvl/usb.c
@@ -23,7 +23,7 @@
 #include <net/nfc/nci_core.h>
 #include "nfcmrvl.h"
 
-static struct usb_device_id nfcmrvl_table[] = {
+static const struct usb_device_id nfcmrvl_table[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x1286, 0x2046,
 					USB_CLASS_VENDOR_SPEC, 4, 1) },
 	{ }	/* Terminating entry */
-- 
2.7.4
