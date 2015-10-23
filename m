Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35597 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbbJWR2M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 13:28:12 -0400
Received: from potku.com (a88-115-185-251.elisa-laajakaista.fi [88.115.185.251])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: kvalo@smtp.codeaurora.org)
	by smtp.codeaurora.org (Postfix) with ESMTPSA id 2ECA6140AF5
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2015 17:28:10 +0000 (UTC)
From: Kalle Valo <kvalo@codeaurora.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] rtl8xxxu: move devices supported by rtlwifi under UNTESTED config
Date: Fri, 23 Oct 2015 20:27:58 +0300
Message-Id: <1445621278-9276-1-git-send-email-kvalo@codeaurora.org> (sfid-20151023_192815_173424_6B20DEB6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are still four devices which are currently supported both by the new
rtl8xxxu driver and rtlwifi. To not break existing setups enable the support
for these four devices only when CONFIG_RTL8XXXU_UNTESTED is turned on.

Once rtl8xxxu support is found to be good enough the devices can be removed
from rtlwifi and enabled by default in rtl8xxxu.

Reported-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 47e52ad56144..86d864af3a32 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -5797,6 +5797,8 @@ static struct usb_device_id dev_table[] = {
 	.driver_info = (unsigned long)&rtl8723au_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x0724, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8723au_fops},
+#ifdef CONFIG_RTL8XXXU_UNTESTED
+/* Still supported by rtlwifi */
 {USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x8176, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192cu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x8178, 0xff, 0xff, 0xff),
@@ -5806,7 +5808,6 @@ static struct usb_device_id dev_table[] = {
 /* Tested by Larry Finger */
 {USB_DEVICE_AND_INTERFACE_INFO(0x7392, 0x7811, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192cu_fops},
-#ifdef CONFIG_RTL8XXXU_UNTESTED
 /* Currently untested 8188 series devices */
 {USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x8191, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192cu_fops},
-- 
1.7.9.5

