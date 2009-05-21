Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:33080 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbZEURQu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 13:16:50 -0400
Received: by ewy24 with SMTP id 24so1347402ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 21 May 2009 10:16:50 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: linville@tuxdriver.com
Subject: [PATCH 1/2] rt2x00: Add new rt2800usb USB ID's for Sweex
Date: Thu, 21 May 2009 19:16:14 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200905211916.14245.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The USB ID with unknown manufacturer is apparently sweex,
copy it to the correct location of the list and add 2
additional USB ID's also belonging to Sweex.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index f11e597..aae7aa7 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -2881,8 +2881,6 @@ static const struct rt2x00_ops rt2800usb_ops = {
  * rt2800usb module information.
  */
 static struct usb_device_id rt2800usb_device_table[] = {
-	/* ??? */
-	{ USB_DEVICE(0x177f, 0x0302), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Abocom */
 	{ USB_DEVICE(0x07b8, 0x2870), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x07b8, 0x2770), USB_DEVICE_DATA(&rt2800usb_ops) },
@@ -3027,6 +3025,10 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x083a, 0xc522), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Sparklan */
 	{ USB_DEVICE(0x15a9, 0x0006), USB_DEVICE_DATA(&rt2800usb_ops) },
+	/* Sweex */
+	{ USB_DEVICE(0x177f, 0x0153), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x177f, 0x0302), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x177f, 0x0313), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* U-Media*/
 	{ USB_DEVICE(0x157e, 0x300e), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* ZCOM */
-- 
1.6.3

