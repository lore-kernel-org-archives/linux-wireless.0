Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36600 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753541AbcJYUc2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Oct 2016 16:32:28 -0400
Received: by mail-pf0-f195.google.com with SMTP id n85so1423755pfi.3
        for <linux-wireless@vger.kernel.org>; Tue, 25 Oct 2016 13:32:28 -0700 (PDT)
Date: Wed, 26 Oct 2016 06:29:37 +1000
From: Barry Day <briselec@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH] rtl8xxxu: Add D-Link DWA-131 rev E1
Message-ID: <20161025202928.GA10934@box64.home.org> (sfid-20161025_223232_317445_EBDD23CD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a rtl8192eu dongle and has been tested

Signed-off-by: Barry Day <briselec@gmail.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 04141e5..d426836 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -6009,7 +6009,7 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
 			untested = 0;
 		break;
 	case 0x2001:
-		if (id->idProduct == 0x3308)
+		if (id->idProduct == 0x3308 || id->idProduct == 0x3319)
 			untested = 0;
 		break;
 	case 0x2357:
@@ -6188,6 +6188,8 @@ static struct usb_device_id dev_table[] = {
 	.driver_info = (unsigned long)&rtl8723au_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x818b, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192eu_fops},
+{USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x3319, 0xff, 0xff, 0xff),
+	.driver_info = (unsigned long)&rtl8192eu_fops},
 /* Tested by Myckel Habets */
 {USB_DEVICE_AND_INTERFACE_INFO(0x2357, 0x0109, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192eu_fops},
-- 
2.9.2
