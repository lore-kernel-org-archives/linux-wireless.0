Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59800 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290Ab3BRTyb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 14:54:31 -0500
Received: by mail-wi0-f172.google.com with SMTP id ez12so3987898wid.11
        for <linux-wireless@vger.kernel.org>; Mon, 18 Feb 2013 11:54:29 -0800 (PST)
Message-ID: <1361217258.2698.4.camel@canaries64> (sfid-20130218_205436_014659_08D439CD)
Subject: [PATCH] staging: vt6656: Fix oops on resume from suspend.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Andres More <more.andres@gmail.com>, linux-wireless@vger.kernel.org
Date: Mon, 18 Feb 2013 19:54:18 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove usb_put_dev from vt6656_suspend and usb_get_dev
from vt6566_resume.

These are not normally in suspend/resume functions.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: stable@vger.kernel.org # 3.0+
---
 drivers/staging/vt6656/main_usb.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index d5f53e1..a5063a6 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -669,8 +669,6 @@ static int vt6656_suspend(struct usb_interface *intf, pm_message_t message)
 	if (device->flags & DEVICE_FLAGS_OPENED)
 		device_close(device->dev);
 
-	usb_put_dev(interface_to_usbdev(intf));
-
 	return 0;
 }
 
@@ -681,8 +679,6 @@ static int vt6656_resume(struct usb_interface *intf)
 	if (!device || !device->dev)
 		return -ENODEV;
 
-	usb_get_dev(interface_to_usbdev(intf));
-
 	if (!(device->flags & DEVICE_FLAGS_OPENED))
 		device_open(device->dev);
 
-- 
1.8.1.2



