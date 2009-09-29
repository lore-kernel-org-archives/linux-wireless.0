Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f211.google.com ([209.85.219.211]:51222 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbZI2Nhx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2009 09:37:53 -0400
Received: by ewy7 with SMTP id 7so5411880ewy.17
        for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2009 06:37:56 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	szalat <szalat@gmail.com>, users@rt2x00.serialmonkey.com
Subject: [PATCH] rt2x00: Thrustmaster FunAccess WIFI USB and rt73usb
Date: Tue, 29 Sep 2009 15:37:53 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200909291537.54334.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Szalata <szalat@gmail.com>

Thrustmaster FunAccess WIFI USB works with rt73usb with little
modification of rt73usb.c.
Tested with version 2.3.0 of driver.

Signed-off-by: Michal Szalata <szalat@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 1cbd9b4..b8f5ee3 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2381,6 +2381,7 @@ static struct usb_device_id rt73usb_device_table[] = {
 	/* Huawei-3Com */
 	{ USB_DEVICE(0x1472, 0x0009), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Hercules */
+	{ USB_DEVICE(0x06f8, 0xe002), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x06f8, 0xe010), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x06f8, 0xe020), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Linksys */
