Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38814 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751434AbdAQX2Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Jan 2017 18:28:16 -0500
From: Jes.Sorensen@gmail.com
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/5] rtl8xxxu: Add another 8192eu device to the USB list
Date: Tue, 17 Jan 2017 18:18:53 -0500
Message-Id: <20170117231856.5075-3-Jes.Sorensen@gmail.com> (sfid-20170118_002852_127129_CC63AFCF)
In-Reply-To: <20170117231856.5075-1-Jes.Sorensen@gmail.com>
References: <20170117231856.5075-1-Jes.Sorensen@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

TP-Link TL-WN822N v4 (2357:0108)

Reported-by: Gregory Auzanneau <linux@reolight.net>
Signed-off-by: Jes Sorensen <Jes.Sorensen@gmail.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 99cfd2b..016ea24 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -6197,6 +6197,9 @@ static struct usb_device_id dev_table[] = {
 	.driver_info = (unsigned long)&rtl8723au_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x818b, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192eu_fops},
+/* TP-Link TL-WN822N v4 */
+{USB_DEVICE_AND_INTERFACE_INFO(0x2357, 0x0108, 0xff, 0xff, 0xff),
+	.driver_info = (unsigned long)&rtl8192eu_fops},
 /* Tested by Myckel Habets */
 {USB_DEVICE_AND_INTERFACE_INFO(0x2357, 0x0109, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192eu_fops},
-- 
2.7.4
