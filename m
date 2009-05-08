Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:61500 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbZEHQap (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 12:30:45 -0400
Received: by ewy24 with SMTP id 24so1937714ewy.37
        for <linux-wireless@vger.kernel.org>; Fri, 08 May 2009 09:30:45 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: rt2x00: Fix chipset detection for rt73usb
Date: Fri, 8 May 2009 18:30:43 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200905081830.43618.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The lower 4 bytes of the chipset revision must contain
a non-zero value. This bug was introduced by

	commit: fbebe7c588a341d7a39ce0b0ea5bd5c58f906b07
	rt2x00: Simplify rt2x00_check_rev

	rt2x00_check_rev() was too specific for rt2500usb and rt73usb,
	by adding the mask argument (instead of hardcoding it into
	the function itself) we can use the function in rt2800usb as
	well.

	v2: Fix revision mask for rt2800usb

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt73usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 4f94a61..dc2ad94 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1847,7 +1847,7 @@ static int rt73usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_chip(rt2x00dev, RT2571, value, reg);
 
 	if (!rt2x00_check_rev(&rt2x00dev->chip, 0x000ffff0, 0x25730) ||
-	    !rt2x00_check_rev(&rt2x00dev->chip, 0x0000000f, 0)) {
+	    rt2x00_check_rev(&rt2x00dev->chip, 0x0000000f, 0)) {
 		ERROR(rt2x00dev, "Invalid RT chipset detected.\n");
 		return -ENODEV;
 	}
-- 
1.6.2.3

