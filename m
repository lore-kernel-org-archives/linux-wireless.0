Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:14484 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbXJ0LYy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Oct 2007 07:24:54 -0400
Received: by fk-out-0910.google.com with SMTP id z23so1035387fkz
        for <linux-wireless@vger.kernel.org>; Sat, 27 Oct 2007 04:24:52 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/21] rt2x00: Use enum defines
Date: Sat, 27 Oct 2007 13:35:55 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200710271334.34192.IvDoorn@gmail.com>
In-Reply-To: <200710271334.34192.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710271335.55486.IvDoorn@gmail.com> (sfid-20071027_122503_071145_DA5E16F1)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When setting the default EEPROM values use
the values from the enums instead of "magic" values.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500pci.c |    9 ++++++---
 drivers/net/wireless/rt2x00/rt2500usb.c |    9 ++++++---
 drivers/net/wireless/rt2x00/rt61pci.c   |    6 ++++--
 drivers/net/wireless/rt2x00/rt73usb.c   |    6 ++++--
 4 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 1f65e71..5ecce34 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1421,9 +1421,12 @@ static int rt2500pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_ANTENNA, &word);
 	if (word == 0xffff) {
 		rt2x00_set_field16(&word, EEPROM_ANTENNA_NUM, 2);
-		rt2x00_set_field16(&word, EEPROM_ANTENNA_TX_DEFAULT, 0);
-		rt2x00_set_field16(&word, EEPROM_ANTENNA_RX_DEFAULT, 0);
-		rt2x00_set_field16(&word, EEPROM_ANTENNA_LED_MODE, 0);
+		rt2x00_set_field16(&word, EEPROM_ANTENNA_TX_DEFAULT,
+				   ANTENNA_SW_DIVERSITY);
+		rt2x00_set_field16(&word, EEPROM_ANTENNA_RX_DEFAULT,
+				   ANTENNA_SW_DIVERSITY);
+		rt2x00_set_field16(&word, EEPROM_ANTENNA_LED_MODE,
+				   LED_MODE_DEFAULT);
 		rt2x00_set_field16(&word, EEPROM_ANTENNA_DYN_TXAGC, 0);
 		rt2x00_set_field16(&word, EEPROM_ANTENNA_HARDWARE_RADIO, 0);
 		rt2x00_set_field16(&word, EEPROM_ANTENNA_RF_TYPE, RF2522);
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 8198531..487d89e 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1163,9 +1163,12 @@ static int rt2500usb_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_ANTENNA, &word);
 	if (word == 0xffff) {
 		rt2x00_set_field16(&word, EEPROM_ANTENNA_NUM, 2);
-		rt2x00_set_field16(&word, EEPROM_ANTENNA_TX_DEFAULT, 0);
-		rt2x00_set_field16(&word, EEPROM_ANTENNA_RX_DEFAULT, 0);
-		rt2x00_set_field16(&word, EEPROM_ANTENNA_LED_MODE, 0);
+		rt2x00_set_field16(&word, EEPROM_ANTENNA_TX_DEFAULT,
+				   ANTENNA_SW_DIVERSITY);
+		rt2x00_set_field16(&word, EEPROM_ANTENNA_RX_DEFAULT,
+				   ANTENNA_SW_DIVERSITY);
+		rt2x00_set_field16(&word, EEPROM_ANTENNA_LED_MODE,
+				   LED_MODE_DEFAULT);
 		rt2x00_set_field16(&word, EEPROM_ANTENNA_DYN_TXAGC, 0);
 		rt2x00_set_field16(&word, EEPROM_ANTENNA_HARDWARE_RADIO, 0);
 		rt2x00_set_field16(&word, EEPROM_ANTENNA_RF_TYPE, RF2522);
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index f6b8ae8..b8c3da7 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1908,8 +1908,10 @@ static int rt61pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_ANTENNA, &word);
 	if (word == 0xffff) {
 		rt2x00_set_field16(&word, EEPROM_ANTENNA_NUM, 2);
-		rt2x00_set_field16(&word, EEPROM_ANTENNA_TX_DEFAULT, 2);
-		rt2x00_set_field16(&word, EEPROM_ANTENNA_RX_DEFAULT, 2);
+		rt2x00_set_field16(&word, EEPROM_ANTENNA_TX_DEFAULT,
+				   ANTENNA_B);
+		rt2x00_set_field16(&word, EEPROM_ANTENNA_RX_DEFAULT,
+				   ANTENNA_B);
 		rt2x00_set_field16(&word, EEPROM_ANTENNA_FRAME_TYPE, 0);
 		rt2x00_set_field16(&word, EEPROM_ANTENNA_DYN_TXAGC, 0);
 		rt2x00_set_field16(&word, EEPROM_ANTENNA_HARDWARE_RADIO, 0);
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index d2b25ff..6297677 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1391,8 +1391,10 @@ static int rt73usb_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_ANTENNA, &word);
 	if (word == 0xffff) {
 		rt2x00_set_field16(&word, EEPROM_ANTENNA_NUM, 2);
-		rt2x00_set_field16(&word, EEPROM_ANTENNA_TX_DEFAULT, 2);
-		rt2x00_set_field16(&word, EEPROM_ANTENNA_RX_DEFAULT, 2);
+		rt2x00_set_field16(&word, EEPROM_ANTENNA_TX_DEFAULT,
+				   ANTENNA_B);
+		rt2x00_set_field16(&word, EEPROM_ANTENNA_RX_DEFAULT,
+				   ANTENNA_B);
 		rt2x00_set_field16(&word, EEPROM_ANTENNA_FRAME_TYPE, 0);
 		rt2x00_set_field16(&word, EEPROM_ANTENNA_DYN_TXAGC, 0);
 		rt2x00_set_field16(&word, EEPROM_ANTENNA_HARDWARE_RADIO, 0);
-- 
1.5.3.4

