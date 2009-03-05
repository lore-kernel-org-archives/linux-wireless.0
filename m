Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:38032 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756800AbZCEU3y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2009 15:29:54 -0500
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/7] p54usb: stop USB core interference in exit path
Date: Thu, 5 Mar 2009 21:29:51 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200903052129.51790.chunkeey@web.de> (sfid-20090305_213000_768578_AD6A2045)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch fixes a problem when the (Soft)LED stayed on after the module was unloaded.
It turned out that the USB core disables all endpoints before calling the disconnect method.
So it was impossible to switch off the radio & LEDs.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
--- a/drivers/net/wireless/p54/p54usb.c	2009-03-04 22:17:37.000000000 +0100
+++ b/drivers/net/wireless/p54/p54usb.c	2009-03-05 14:49:43.000000000 +0100
@@ -1024,6 +1024,7 @@ static struct usb_driver p54u_driver = {
 	.disconnect = p54u_disconnect,
 	.pre_reset = p54u_pre_reset,
 	.post_reset = p54u_post_reset,
+	.soft_unbind = 1,
 };
 
 static int __init p54u_init(void)
