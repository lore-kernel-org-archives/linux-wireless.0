Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43153 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab1GJPFX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jul 2011 11:05:23 -0400
Received: by eyx24 with SMTP id 24so1110003eyx.19
        for <linux-wireless@vger.kernel.org>; Sun, 10 Jul 2011 08:05:21 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/1] Add new device ID for Belkin
Date: Sun, 10 Jul 2011 17:05:14 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201107101705.15918.IvDoorn@gmail.com> (sfid-20110710_170532_453031_F108E51A)
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

