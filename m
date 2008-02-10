Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.187]:38996 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbYBJVxu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2008 16:53:50 -0500
Received: by fk-out-0910.google.com with SMTP id z23so4239380fkz.5
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2008 13:53:49 -0800 (PST)
To: linville@tuxdriver.com
Subject: [PATCH 09/14] rt2x00: Fix typo in debug statement
Date: Sun, 10 Feb 2008 22:50:58 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802102246.04515.IvDoorn@gmail.com>
In-Reply-To: <200802102246.04515.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802102250.59126.IvDoorn@gmail.com> (sfid-20080210_215353_152674_159772D0)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The second eeprom recovery message is about
the RSSI offset for ieee802.11 A.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt61pci.c |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 41ea0c4..43d5dd3 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1876,7 +1876,7 @@ static int rt61pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 		rt2x00_set_field16(&word, EEPROM_RSSI_OFFSET_A_1, 0);
 		rt2x00_set_field16(&word, EEPROM_RSSI_OFFSET_A_2, 0);
 		rt2x00_eeprom_write(rt2x00dev, EEPROM_RSSI_OFFSET_A, word);
-		EEPROM(rt2x00dev, "RSSI OFFSET BG: 0x%04x\n", word);
+		EEPROM(rt2x00dev, "RSSI OFFSET A: 0x%04x\n", word);
 	} else {
 		value = rt2x00_get_field16(word, EEPROM_RSSI_OFFSET_A_1);
 		if (value < -10 || value > 10)
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index ee2ee7b..1802898 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1496,7 +1496,7 @@ static int rt73usb_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 		rt2x00_set_field16(&word, EEPROM_RSSI_OFFSET_A_1, 0);
 		rt2x00_set_field16(&word, EEPROM_RSSI_OFFSET_A_2, 0);
 		rt2x00_eeprom_write(rt2x00dev, EEPROM_RSSI_OFFSET_A, word);
-		EEPROM(rt2x00dev, "RSSI OFFSET BG: 0x%04x\n", word);
+		EEPROM(rt2x00dev, "RSSI OFFSET A: 0x%04x\n", word);
 	} else {
 		value = rt2x00_get_field16(word, EEPROM_RSSI_OFFSET_A_1);
 		if (value < -10 || value > 10)
-- 
1.5.4

