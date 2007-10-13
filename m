Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:21986 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbXJMOKZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Oct 2007 10:10:25 -0400
Received: by nf-out-0910.google.com with SMTP id g13so956439nfb
        for <linux-wireless@vger.kernel.org>; Sat, 13 Oct 2007 07:10:24 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 02/11] rt2x00: Use enum defines
Date: Sat, 13 Oct 2007 16:26:18 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200710131621.05173.IvDoorn@gmail.com>
In-Reply-To: <200710131621.05173.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200710131626.19134.IvDoorn@gmail.com> (sfid-20071013_151032_109500_44B7A8D8)
Content-Type: text/plain;
  charset="utf-8"
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
index a59590c..c776155 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1418,9 +1418,12 @@ static int rt2500pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
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
index 625c409..5f02b91 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1161,9 +1161,12 @@ static int rt2500usb_validate_eeprom(struct rt2x00_dev *rt2x00dev)
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
index d3ef2fc..b9a37ae 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1906,8 +1906,10 @@ static int rt61pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
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
index f5af999..81ee3e5 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1389,8 +1389,10 @@ static int rt73usb_validate_eeprom(struct rt2x00_dev *rt2x00dev)
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

