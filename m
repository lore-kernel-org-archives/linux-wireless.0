Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:43317 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbYLTKCE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 05:02:04 -0500
Received: by mail-ew0-f17.google.com with SMTP id 10so1457082ewy.13
        for <linux-wireless@vger.kernel.org>; Sat, 20 Dec 2008 02:02:03 -0800 (PST)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 9/15] rt2x00: Split EEPROM_NIC_TX_RX_FIXED
Date: Sat, 20 Dec 2008 10:57:47 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200812201052.00655.IvDoorn@gmail.com> <200812201056.36218.IvDoorn@gmail.com> <200812201057.02583.IvDoorn@gmail.com>
In-Reply-To: <200812201057.02583.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812201057.47712.IvDoorn@gmail.com> (sfid-20081220_110215_762633_4FE23D9F)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 2 bits in EEPROM_NIC_TX_RX_FIXED each influence
a different antenna. We might as well split the
definition and directly read the correct bit.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt61pci.c |   25 ++++++-------------------
 drivers/net/wireless/rt2x00/rt61pci.h |    3 ++-
 2 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 2b72010..875acb3 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2232,7 +2232,8 @@ static int rt61pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 	if (word == 0xffff) {
 		rt2x00_set_field16(&word, EEPROM_NIC_ENABLE_DIVERSITY, 0);
 		rt2x00_set_field16(&word, EEPROM_NIC_TX_DIVERSITY, 0);
-		rt2x00_set_field16(&word, EEPROM_NIC_TX_RX_FIXED, 0);
+		rt2x00_set_field16(&word, EEPROM_NIC_RX_FIXED, 0);
+		rt2x00_set_field16(&word, EEPROM_NIC_TX_FIXED, 0);
 		rt2x00_set_field16(&word, EEPROM_NIC_EXTERNAL_LNA_BG, 0);
 		rt2x00_set_field16(&word, EEPROM_NIC_CARDBUS_ACCEL, 0);
 		rt2x00_set_field16(&word, EEPROM_NIC_EXTERNAL_LNA_A, 0);
@@ -2376,24 +2377,10 @@ static int rt61pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	 */
 	if (rt2x00_rf(&rt2x00dev->chip, RF2529) &&
 	    !test_bit(CONFIG_DOUBLE_ANTENNA, &rt2x00dev->flags)) {
-		switch (rt2x00_get_field16(eeprom, EEPROM_NIC_TX_RX_FIXED)) {
-		case 0:
-			rt2x00dev->default_ant.tx = ANTENNA_B;
-			rt2x00dev->default_ant.rx = ANTENNA_A;
-			break;
-		case 1:
-			rt2x00dev->default_ant.tx = ANTENNA_B;
-			rt2x00dev->default_ant.rx = ANTENNA_B;
-			break;
-		case 2:
-			rt2x00dev->default_ant.tx = ANTENNA_A;
-			rt2x00dev->default_ant.rx = ANTENNA_A;
-			break;
-		case 3:
-			rt2x00dev->default_ant.tx = ANTENNA_A;
-			rt2x00dev->default_ant.rx = ANTENNA_B;
-			break;
-		}
+		rt2x00dev->default_ant.rx =
+		    ANTENNA_A + rt2x00_get_field16(eeprom, EEPROM_NIC_RX_FIXED);
+		rt2x00dev->default_ant.tx =
+		    ANTENNA_B - rt2x00_get_field16(eeprom, EEPROM_NIC_TX_FIXED);
 
 		if (rt2x00_get_field16(eeprom, EEPROM_NIC_TX_DIVERSITY))
 			rt2x00dev->default_ant.tx = ANTENNA_SW_DIVERSITY;
diff --git a/drivers/net/wireless/rt2x00/rt61pci.h b/drivers/net/wireless/rt2x00/rt61pci.h
index 86590c6..cd86def 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/rt2x00/rt61pci.h
@@ -1190,7 +1190,8 @@ struct hw_pairwise_ta_entry {
 #define EEPROM_NIC			0x0011
 #define EEPROM_NIC_ENABLE_DIVERSITY	FIELD16(0x0001)
 #define EEPROM_NIC_TX_DIVERSITY		FIELD16(0x0002)
-#define EEPROM_NIC_TX_RX_FIXED		FIELD16(0x000c)
+#define EEPROM_NIC_RX_FIXED		FIELD16(0x0004)
+#define EEPROM_NIC_TX_FIXED		FIELD16(0x0008)
 #define EEPROM_NIC_EXTERNAL_LNA_BG	FIELD16(0x0010)
 #define EEPROM_NIC_CARDBUS_ACCEL	FIELD16(0x0020)
 #define EEPROM_NIC_EXTERNAL_LNA_A	FIELD16(0x0040)
-- 
1.5.6.1

