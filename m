Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:31690 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297Ab2HIG5u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 02:57:50 -0400
Date: Thu, 9 Aug 2012 09:57:30 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] wireless: at76c50x: signedness bug in at76_dfu_get_state()
Message-ID: <20120809065730.GA7925@elgon.mountain> (sfid-20120809_085755_743305_EAB40B14)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This return holds the number of bytes transfered (1 byte) or a negative
error code.  The type should be int instead of u8.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index efc162e..88b8d64 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -342,7 +342,7 @@ static int at76_dfu_get_status(struct usb_device *udev,
 	return ret;
 }
 
-static u8 at76_dfu_get_state(struct usb_device *udev, u8 *state)
+static int at76_dfu_get_state(struct usb_device *udev, u8 *state)
 {
 	int ret;
 
