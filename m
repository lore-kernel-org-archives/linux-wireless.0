Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ispras.ru ([83.149.199.45]:59294 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758955Ab3FMU0o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Jun 2013 16:26:44 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] orinoco_usb: fix memory leak in ezusb_access_ltv() when device disconnected
Date: Fri, 14 Jun 2013 00:26:11 +0400
Message-Id: <1371155171-15398-1-git-send-email-khoroshilov@ispras.ru> (sfid-20130613_222702_704948_2B3A3FEA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If "device is disconnected" check occurs to be true in ezusb_access_ltv(),
it just return -ENODEV. But that means request_context is leaked since
there are no any references to it anymore.
The patch adds a call to ezusb_request_context_put() before return.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/net/wireless/orinoco/orinoco_usb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/orinoco/orinoco_usb.c b/drivers/net/wireless/orinoco/orinoco_usb.c
index 1f9cb55..bdfe637 100644
--- a/drivers/net/wireless/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/orinoco/orinoco_usb.c
@@ -881,7 +881,8 @@ static int ezusb_access_ltv(struct ezusb_priv *upriv,
 
 	if (!upriv->udev) {
 		dbg("Device disconnected");
-		return -ENODEV;
+		retval = -ENODEV;
+		goto exit;
 	}
 
 	if (upriv->read_urb->status != -EINPROGRESS)
-- 
1.8.1.2

