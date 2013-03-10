Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:35181 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab3CJNKb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Mar 2013 09:10:31 -0400
From: Andrei Epure <epure.andrei@gmail.com>
To: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
	linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Andrei Epure <epure.andrei@gmail.com>
Subject: [PATCH] wireless:rtlwifi: replaced kmalloc+memcpy with kmemdup
Date: Sun, 10 Mar 2013 15:09:47 +0200
Message-Id: <1362920987-6679-1-git-send-email-epure.andrei@gmail.com> (sfid-20130310_141051_023699_00E2366D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Andrei Epure <epure.andrei@gmail.com>
---
 drivers/net/wireless/rtlwifi/usb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index 156b527..b5c80b5 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -224,10 +224,9 @@ static void _usb_writeN_sync(struct rtl_priv *rtlpriv, u32 addr, void *data,
 	u8 *buffer;
 
 	wvalue = (u16)(addr & 0x0000ffff);
-	buffer = kmalloc(len, GFP_ATOMIC);
+	buffer = kmemdup(data, len, GFP_ATOMIC);
 	if (!buffer)
 		return;
-	memcpy(buffer, data, len);
 	usb_control_msg(udev, pipe, request, reqtype, wvalue,
 			index, buffer, len, 50);
 
-- 
1.7.10.4

