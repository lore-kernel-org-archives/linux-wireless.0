Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36348 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932977AbdGKOiJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Jul 2017 10:38:09 -0400
Received: by mail-pg0-f67.google.com with SMTP id y129so157116pgy.3
        for <linux-wireless@vger.kernel.org>; Tue, 11 Jul 2017 07:38:04 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 3/3] rsi: fix static checker warning
Date: Tue, 11 Jul 2017 19:57:53 +0530
Message-Id: <1499783273-15428-3-git-send-email-amitkarwar@gmail.com> (sfid-20170711_163818_366009_F4E6ADB3)
In-Reply-To: <1499783273-15428-1-git-send-email-amitkarwar@gmail.com>
References: <1499783273-15428-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <amit.karwar@redpinesignals.com>

u32 pointer is changed to u16 and filled the value. Problem is
solved by using local temporary variable. Below static checker
warning was reported.

drivers/net/wireless/rsi/rsi_91x_usb.c:400 rsi_usb_master_reg_read()
        warn: passing casted pointer 'value' to 'rsi_usb_reg_read()'
32 vs 16.

Fixes: b97e9b94ad75c ("rsi: Add new host interface operations")
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 3d33ce9..9097f7e 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -404,8 +404,15 @@ static int rsi_usb_master_reg_read(struct rsi_hw *adapter, u32 reg,
 {
 	struct usb_device *usbdev =
 		((struct rsi_91x_usbdev *)adapter->rsi_dev)->usbdev;
+	u16 temp;
+	int ret;
 
-	return rsi_usb_reg_read(usbdev, reg, (u16 *)value, len);
+	ret = rsi_usb_reg_read(usbdev, reg, &temp, len);
+	if (ret < 0)
+		return ret;
+	*value = temp;
+
+	return 0;
 }
 
 static int rsi_usb_master_reg_write(struct rsi_hw *adapter,
-- 
2.7.4
