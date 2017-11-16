Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:53324 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751390AbdKPRjY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Nov 2017 12:39:24 -0500
From: Colin King <colin.king@canonical.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rsi: fix memory leak on buf and usb_reg_buf
Date: Thu, 16 Nov 2017 17:39:18 +0000
Message-Id: <20171116173918.3030-1-colin.king@canonical.com> (sfid-20171116_183930_175515_26D0E152)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

In the cases where len is too long, the error return path fails to
kfree allocated buffers buf and usb_reg_buf.  The simplest fix is to
perform the sanity check on len before the allocations to avoid having
to do the kfree'ing in the first place.

Detected by CoverityScan, CID#1452258,1452259 ("Resource Leak")

Fixes: 59f73e2ae185 ("rsi: check length before USB read/write register")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 08730227cd18..8f8443833348 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -162,13 +162,13 @@ static int rsi_usb_reg_read(struct usb_device *usbdev,
 	u8 *buf;
 	int status = -ENOMEM;
 
+	if (len > RSI_USB_CTRL_BUF_SIZE)
+		return -EINVAL;
+
 	buf  = kmalloc(RSI_USB_CTRL_BUF_SIZE, GFP_KERNEL);
 	if (!buf)
 		return status;
 
-	if (len > RSI_USB_CTRL_BUF_SIZE)
-		return -EINVAL;
-
 	status = usb_control_msg(usbdev,
 				 usb_rcvctrlpipe(usbdev, 0),
 				 USB_VENDOR_REGISTER_READ,
@@ -207,13 +207,13 @@ static int rsi_usb_reg_write(struct usb_device *usbdev,
 	u8 *usb_reg_buf;
 	int status = -ENOMEM;
 
+	if (len > RSI_USB_CTRL_BUF_SIZE)
+		return -EINVAL;
+
 	usb_reg_buf  = kmalloc(RSI_USB_CTRL_BUF_SIZE, GFP_KERNEL);
 	if (!usb_reg_buf)
 		return status;
 
-	if (len > RSI_USB_CTRL_BUF_SIZE)
-		return -EINVAL;
-
 	usb_reg_buf[0] = (value & 0x00ff);
 	usb_reg_buf[1] = (value & 0xff00) >> 8;
 	usb_reg_buf[2] = 0x0;
-- 
2.14.1
