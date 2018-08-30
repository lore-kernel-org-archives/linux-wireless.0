Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:42079 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728962AbeH3SIi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Aug 2018 14:08:38 -0400
From: Aleksei Mamlin <mamlinav@gmail.com>
To: Jes Sorensen <Jes.Sorensen@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aleksei Mamlin <mamlinav@gmail.com>
Subject: [PATCH] rtl8xxxu: Add rtl8188ctv support
Date: Thu, 30 Aug 2018 17:05:41 +0300
Message-Id: <20180830140541.31964-1-mamlinav@gmail.com> (sfid-20180830_160638_509451_54F6C7CF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The Realtek rtl8188ctv (0x0bda:0x018a) is a highly integrated single-chip
WLAN USB2.0 network interface controller.

Currently rtl8188ctv is supported by rtlwifi driver.
It is similar to the rtl8188cus(0x0bda:0x818a) and uses the same config.

Signed-off-by: Aleksei Mamlin <mamlinav@gmail.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 505ab1b055ff..73f6fc0d4a01 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -6231,6 +6231,8 @@ static const struct usb_device_id dev_table[] = {
 {USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x3308, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192cu_fops},
 /* Currently untested 8188 series devices */
+{USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x018a, 0xff, 0xff, 0xff),
+	.driver_info = (unsigned long)&rtl8192cu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x8191, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192cu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x8170, 0xff, 0xff, 0xff),
-- 
2.16.4
