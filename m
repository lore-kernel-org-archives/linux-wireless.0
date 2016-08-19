Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47584 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754947AbcHSVrY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Aug 2016 17:47:24 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 01/20] rtl8xxxu: Mark 0x20f4:0x648b as tested
Date: Fri, 19 Aug 2016 17:46:23 -0400
Message-Id: <1471643202-26250-2-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160819_234730_721016_85EFBFDD)
In-Reply-To: <1471643202-26250-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1471643202-26250-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Successfully tested by Jocelyn Mayer

Reported-by: J. Mayer <l_indien@magic.fr>
Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 77048db..47d0868 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5971,6 +5971,10 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
 		if (id->idProduct == 0x1004)
 			untested = 0;
 		break;
+	case 0x20f4:
+		if (id->idProduct == 0x648b)
+			untested = 0;
+		break;
 	default:
 		break;
 	}
@@ -6140,6 +6144,9 @@ static struct usb_device_id dev_table[] = {
 /* Tested by Andrea Merello */
 {USB_DEVICE_AND_INTERFACE_INFO(0x050d, 0x1004, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192cu_fops},
+/* Tested by Jocelyn Mayer */
+{USB_DEVICE_AND_INTERFACE_INFO(0x20f4, 0x648b, 0xff, 0xff, 0xff),
+	.driver_info = (unsigned long)&rtl8192cu_fops},
 /* Currently untested 8188 series devices */
 {USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x8191, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192cu_fops},
@@ -6199,8 +6206,6 @@ static struct usb_device_id dev_table[] = {
 	.driver_info = (unsigned long)&rtl8192cu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(0x2019, 0xed17, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192cu_fops},
-{USB_DEVICE_AND_INTERFACE_INFO(0x20f4, 0x648b, 0xff, 0xff, 0xff),
-	.driver_info = (unsigned long)&rtl8192cu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(0x4855, 0x0090, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192cu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(0x4856, 0x0091, 0xff, 0xff, 0xff),
-- 
2.7.4
