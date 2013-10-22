Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:42821 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900Ab3JVTA2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Oct 2013 15:00:28 -0400
Received: by mail-we0-f180.google.com with SMTP id q59so8487988wes.25
        for <linux-wireless@vger.kernel.org>; Tue, 22 Oct 2013 12:00:26 -0700 (PDT)
Message-ID: <1382468422.6472.8.camel@canaries64-MCP7A> (sfid-20131022_210031_342998_1BE49995)
Subject: [PATCH] staging: vt6656: call usb_device_reset before netdev
 registration
From: Malcolm Priestley <tvboxspy@gmail.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 22 Oct 2013 20:00:22 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The USB reset occurs after netdev registration if network manager
calls device_open too fast causing USB fails in main_usb.c: device_init_registers.

Move the usb reset to before register_netdev.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 5e4a5d0..aae228c 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -723,14 +723,15 @@ vt6656_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	usb_set_intfdata(intf, pDevice);
 	SET_NETDEV_DEV(netdev, &intf->dev);
 	memcpy(pDevice->dev->dev_addr, fake_mac, ETH_ALEN);
+
+	usb_device_reset(pDevice);
+
 	rc = register_netdev(netdev);
 	if (rc) {
 		printk(KERN_ERR DEVICE_NAME " Failed to register netdev\n");
 		goto err_netdev;
 	}
 
-	usb_device_reset(pDevice);
-
 	return 0;
 
 err_netdev:
-- 
1.8.3.2

