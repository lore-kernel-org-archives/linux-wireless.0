Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:48225 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106AbXGaSeD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 14:34:03 -0400
Received: by ug-out-1314.google.com with SMTP id j3so121186ugf
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 11:34:02 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 05/24] rt2x00: rt2500usb needs to reset BBP 24, 25 and 61
Date: Tue, 31 Jul 2007 20:37:06 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707312037.06718.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 70e63489ce2fc33b4b4e80e9b71f9dcc05bf43cd Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Fri, 27 Jul 2007 19:03:55 +0200
Subject: [PATCH 05/24] rt2x00: rt2500usb needs to reset BBP 24, 25 and 61

When the link tuner is being reset the BBPTUNE
registers r24, r25 r61 need to be reset as well.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2500usb.c |   35 ++++++++++++++++++-----------------
 1 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/rt2500usb.c b/drivers/net/wireless/rt2500usb.c
index 7f9d9ad..1ec3592 100644
--- a/drivers/net/wireless/rt2500usb.c
+++ b/drivers/net/wireless/rt2500usb.c
@@ -648,7 +648,24 @@ static void rt2500usb_disable_led(struct rt2x00_dev *rt2x00dev)
  */
 static void rt2500usb_reset_tuner(struct rt2x00_dev *rt2x00dev)
 {
-	rt2500usb_bbp_write(rt2x00dev, 17, 0x48);
+	u16 eeprom;
+	u16 value;
+
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_BBPTUNE_R24, &eeprom);
+	value = rt2x00_get_field16(eeprom, EEPROM_BBPTUNE_R24_LOW);
+	rt2500usb_bbp_write(rt2x00dev, 24, value);
+
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_BBPTUNE_R25, &eeprom);
+	value = rt2x00_get_field16(eeprom, EEPROM_BBPTUNE_R25_LOW);
+	rt2500usb_bbp_write(rt2x00dev, 25, value);
+
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_BBPTUNE_R61, &eeprom);
+	value = rt2x00_get_field16(eeprom, EEPROM_BBPTUNE_R61_LOW);
+	rt2500usb_bbp_write(rt2x00dev, 61, value);
+
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_BBPTUNE_VGC, &eeprom);
+	value = rt2x00_get_field16(eeprom, EEPROM_BBPTUNE_VGCUPPER);
+	rt2500usb_bbp_write(rt2x00dev, 17, value);
 }
 
 static void rt2500usb_link_tuner(struct rt2x00_dev *rt2x00dev)
@@ -895,22 +912,6 @@ continue_csr_init:
 	}
 	DEBUG(rt2x00dev, "...End initialization from EEPROM.\n");
 
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_BBPTUNE_R24, &eeprom);
-	value = rt2x00_get_field16(eeprom, EEPROM_BBPTUNE_R24_LOW);
-	rt2500usb_bbp_write(rt2x00dev, 24, value);
-
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_BBPTUNE_R25, &eeprom);
-	value = rt2x00_get_field16(eeprom, EEPROM_BBPTUNE_R25_LOW);
-	rt2500usb_bbp_write(rt2x00dev, 25, value);
-
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_BBPTUNE_R61, &eeprom);
-	value = rt2x00_get_field16(eeprom, EEPROM_BBPTUNE_R61_LOW);
-	rt2500usb_bbp_write(rt2x00dev, 61, value);
-
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_BBPTUNE_VGC, &eeprom);
-	value = rt2x00_get_field16(eeprom, EEPROM_BBPTUNE_VGCUPPER);
-	rt2500usb_bbp_write(rt2x00dev, 17, value);
-
 	return 0;
 }
 
-- 
1.5.2.4

