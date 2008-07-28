Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:62751 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbYG1IB0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 04:01:26 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1437807nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2008 01:01:24 -0700 (PDT)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 1/2] rt2x00: Fix VGC lower bound initialization
Date: Mon, 28 Jul 2008 10:20:12 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807281020.13080.IvDoorn@gmail.com> (sfid-20080728_100129_782061_825ADFBE)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the EEPROM_BBPTUNE_VGC word is valid, we should
override EEPROM_BBPTUNE_VGCLOWER field with the BBP
value.

And we should _not_ do that when EEPROM_BBPTUNE_R17 is valid.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
John. Please queue for 2.6.27, it restores rt2500usb back to the same
state as 2.6.25 which means it can associate, but cannot transfer data
afterwards.

 drivers/net/wireless/rt2x00/rt2500usb.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 3078417..c6f6eb6 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1376,6 +1376,9 @@ static int rt2500usb_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 		rt2x00_set_field16(&word, EEPROM_BBPTUNE_VGCLOWER, bbp);
 		rt2x00_eeprom_write(rt2x00dev, EEPROM_BBPTUNE_VGC, word);
 		EEPROM(rt2x00dev, "BBPtune vgc: 0x%04x\n", word);
+	} else {
+		rt2x00_set_field16(&word, EEPROM_BBPTUNE_VGCLOWER, bbp);
+		rt2x00_eeprom_write(rt2x00dev, EEPROM_BBPTUNE_VGC, word);
 	}
 
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_BBPTUNE_R17, &word);
@@ -1384,9 +1387,6 @@ static int rt2500usb_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 		rt2x00_set_field16(&word, EEPROM_BBPTUNE_R17_HIGH, 0x41);
 		rt2x00_eeprom_write(rt2x00dev, EEPROM_BBPTUNE_R17, word);
 		EEPROM(rt2x00dev, "BBPtune r17: 0x%04x\n", word);
-	} else {
-		rt2x00_set_field16(&word, EEPROM_BBPTUNE_VGCLOWER, bbp);
-		rt2x00_eeprom_write(rt2x00dev, EEPROM_BBPTUNE_VGC, word);
 	}
 
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_BBPTUNE_R24, &word);
-- 
1.5.6.1

