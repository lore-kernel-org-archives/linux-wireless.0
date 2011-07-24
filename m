Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40565 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab1GXKei (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jul 2011 06:34:38 -0400
Received: by ewy4 with SMTP id 4so2133933ewy.19
        for <linux-wireless@vger.kernel.org>; Sun, 24 Jul 2011 03:34:37 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] Add new device ID for Belkin
Date: Sun, 24 Jul 2011 12:34:32 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201107241234.33980.IvDoorn@gmail.com> (sfid-20110724_123442_412291_D483527A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eduardo Bacchi Kienetz <eduardo@kienetz.com>

Belkin's Connect N150 Wireless USB Adapter, model F7D1101 version 2, uses ID 0x945b.
Chipset info: rt: 3390, rf: 000b, rev: 3213.
I have just bought one, which started to work perfectly after the ID was added through this patch.

Signed-off-by: Eduardo Bacchi Kienetz <eduardo@kienetz.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 59e7779..5075593 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1054,6 +1054,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x0586, 0x341e) },
 	{ USB_DEVICE(0x0586, 0x343e) },
 #ifdef CONFIG_RT2800USB_RT33XX
+	/* Belkin */
+	{ USB_DEVICE(0x050d, 0x945b) },
 	/* Ralink */
 	{ USB_DEVICE(0x148f, 0x3370) },
 	{ USB_DEVICE(0x148f, 0x8070) },
-- 
1.7.2.3

