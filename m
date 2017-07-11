Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35307 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932729AbdGKObI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Jul 2017 10:31:08 -0400
Received: by mail-pf0-f193.google.com with SMTP id q85so153464pfq.2
        for <linux-wireless@vger.kernel.org>; Tue, 11 Jul 2017 07:31:07 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 2/3] rsi: check length before USB read/write register
Date: Tue, 11 Jul 2017 19:57:52 +0530
Message-Id: <1499783273-15428-2-git-send-email-amitkarwar@gmail.com> (sfid-20170711_163115_749632_7A14FFB5)
In-Reply-To: <1499783273-15428-1-git-send-email-amitkarwar@gmail.com>
References: <1499783273-15428-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <amit.karwar@redpinesignals.com>

These checks are required. Otherwise we may end up getting
memory corruption if invalid length is passed.

Fixes: b97e9b94ad75c ("rsi: Add new host interface operations")
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 99a520a..3d33ce9 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -166,6 +166,9 @@ static int rsi_usb_reg_read(struct usb_device *usbdev,
 	if (!buf)
 		return status;
 
+	if (len > RSI_USB_CTRL_BUF_SIZE)
+		return -EINVAL;
+
 	status = usb_control_msg(usbdev,
 				 usb_rcvctrlpipe(usbdev, 0),
 				 USB_VENDOR_REGISTER_READ,
@@ -208,6 +211,9 @@ static int rsi_usb_reg_write(struct usb_device *usbdev,
 	if (!usb_reg_buf)
 		return status;
 
+	if (len > RSI_USB_CTRL_BUF_SIZE)
+		return -EINVAL;
+
 	usb_reg_buf[0] = (value & 0x00ff);
 	usb_reg_buf[1] = (value & 0xff00) >> 8;
 	usb_reg_buf[2] = 0x0;
-- 
2.7.4
