Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39814 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754611AbcHSVrY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Aug 2016 17:47:24 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 04/20] rtl8xxxu: Add TP-Link TL-WN823N v2 to list of supported devices
Date: Fri, 19 Aug 2016 17:46:26 -0400
Message-Id: <1471643202-26250-5-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160819_234731_761261_64D06EC9)
In-Reply-To: <1471643202-26250-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1471643202-26250-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This is an rtl8192eu based dongle (the v1 is an rtl8192cu). Reported
and tested by Myckel Habets.

Reported-by: Myckel Habets <myckel@sdf.lonestar.org>
Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 9c6305b..948f153 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5979,6 +5979,10 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
 		if (id->idProduct == 0x3308)
 			untested = 0;
 		break;
+	case 0x2357:
+		if (id->idProduct == 0x0109)
+			untested = 0;
+		break;
 	default:
 		break;
 	}
@@ -6146,6 +6150,9 @@ static struct usb_device_id dev_table[] = {
 	.driver_info = (unsigned long)&rtl8723au_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x818b, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192eu_fops},
+/* Tested by Myckel Habets */
+{USB_DEVICE_AND_INTERFACE_INFO(0x2357, 0x0109, 0xff, 0xff, 0xff),
+	.driver_info = (unsigned long)&rtl8192eu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0xb720, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8723bu_fops},
 #ifdef CONFIG_RTL8XXXU_UNTESTED
-- 
2.7.4
