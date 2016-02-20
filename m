Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ispras.ru ([83.149.199.45]:58301 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947588AbcBTWbE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Feb 2016 17:31:04 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Andrea Merello <andrea.merello@gmail.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	ldv-project@linuxtesting.org
Subject: [PATCH] at76c50x-usb: avoid double usb_put_dev() after downloading internal firmware in at76_probe()
Date: Sun, 21 Feb 2016 01:30:29 +0300
Message-Id: <1456007429-4713-2-git-send-email-khoroshilov@ispras.ru> (sfid-20160220_233144_102338_F745A8F1)
In-Reply-To: <1456007429-4713-1-git-send-email-khoroshilov@ispras.ru>
References: <1456007429-4713-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no need in usb_put_dev() if at76_load_internal_fw() succeed.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/net/wireless/atmel/at76c50x-usb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/atmel/at76c50x-usb.c b/drivers/net/wireless/atmel/at76c50x-usb.c
index dab25136214a..1efb1d66e0b7 100644
--- a/drivers/net/wireless/atmel/at76c50x-usb.c
+++ b/drivers/net/wireless/atmel/at76c50x-usb.c
@@ -2481,9 +2481,7 @@ static int at76_probe(struct usb_interface *interface,
 			dev_err(&interface->dev,
 				"error %d downloading internal firmware\n",
 				ret);
-			goto exit;
 		}
-		usb_put_dev(udev);
 		goto exit;
 	}
 
-- 
1.9.1

