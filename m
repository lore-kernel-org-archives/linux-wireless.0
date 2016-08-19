Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42462 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754598AbcHSVrY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Aug 2016 17:47:24 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 02/20] rtl8xxxu: Mark 0x2001:0x3308 as tested
Date: Fri, 19 Aug 2016 17:46:24 -0400
Message-Id: <1471643202-26250-3-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160819_234730_086246_989701D5)
In-Reply-To: <1471643202-26250-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1471643202-26250-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

D-Link DWA-121 is reported as working.

Reported-by: Stefano Bravi <stefanobravi69@libero.it>
Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 47d0868..ca4c40d 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5975,6 +5975,10 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
 		if (id->idProduct == 0x648b)
 			untested = 0;
 		break;
+	case 0x2001:
+		if (id->idProduct == 0x3308)
+			untested = 0;
+		break;
 	default:
 		break;
 	}
@@ -6147,6 +6151,9 @@ static struct usb_device_id dev_table[] = {
 /* Tested by Jocelyn Mayer */
 {USB_DEVICE_AND_INTERFACE_INFO(0x20f4, 0x648b, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192cu_fops},
+/* Tested by Stefano Bravi */
+{USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x3308, 0xff, 0xff, 0xff),
+	.driver_info = (unsigned long)&rtl8192cu_fops},
 /* Currently untested 8188 series devices */
 {USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x8191, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192cu_fops},
@@ -6194,8 +6201,6 @@ static struct usb_device_id dev_table[] = {
 	.driver_info = (unsigned long)&rtl8192cu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(0x13d3, 0x3357, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192cu_fops},
-{USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x3308, 0xff, 0xff, 0xff),
-	.driver_info = (unsigned long)&rtl8192cu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x330b, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192cu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(0x2019, 0x4902, 0xff, 0xff, 0xff),
-- 
2.7.4
