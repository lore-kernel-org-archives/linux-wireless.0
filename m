Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48235 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962Ab3GHOIq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 10:08:46 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v3 10/20] rt2x00: rt2800lib: introduce rt2800_get_txmixer_gain_{24,5}g helpers
Date: Mon,  8 Jul 2013 16:08:25 +0200
Message-Id: <1373292515-21332-11-git-send-email-juhosg@openwrt.org> (sfid-20130708_162043_644063_79B61ED8)
In-Reply-To: <1373292515-21332-1-git-send-email-juhosg@openwrt.org>
References: <1373292515-21332-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move the TX mixer gain reading code into separate
helper functions in preparation for RT3593 support.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
Changes since v2: ---
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   38 +++++++++++++++++++------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index b11f0b0..1f32732 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -6361,6 +6361,28 @@ int rt2800_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev)
 }
 EXPORT_SYMBOL_GPL(rt2800_read_eeprom_efuse);
 
+static u8 rt2800_get_txmixer_gain_24g(struct rt2x00_dev *rt2x00dev)
+{
+	u16 word;
+
+	rt2800_eeprom_read(rt2x00dev, EEPROM_TXMIXER_GAIN_BG, &word);
+	if ((word & 0x00ff) != 0x00ff)
+		return rt2x00_get_field16(word, EEPROM_TXMIXER_GAIN_BG_VAL);
+
+	return 0;
+}
+
+static u8 rt2800_get_txmixer_gain_5g(struct rt2x00_dev *rt2x00dev)
+{
+	u16 word;
+
+	rt2800_eeprom_read(rt2x00dev, EEPROM_TXMIXER_GAIN_A, &word);
+	if ((word & 0x00ff) != 0x00ff)
+		return rt2x00_get_field16(word, EEPROM_TXMIXER_GAIN_A_VAL);
+
+	return 0;
+}
+
 static int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 {
 	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
@@ -6455,13 +6477,7 @@ static int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 		rt2x00_set_field16(&word, EEPROM_RSSI_BG_OFFSET1, 0);
 	rt2800_eeprom_write(rt2x00dev, EEPROM_RSSI_BG, word);
 
-	rt2800_eeprom_read(rt2x00dev, EEPROM_TXMIXER_GAIN_BG, &word);
-	if ((word & 0x00ff) != 0x00ff) {
-		drv_data->txmixer_gain_24g =
-			rt2x00_get_field16(word, EEPROM_TXMIXER_GAIN_BG_VAL);
-	} else {
-		drv_data->txmixer_gain_24g = 0;
-	}
+	drv_data->txmixer_gain_24g = rt2800_get_txmixer_gain_24g(rt2x00dev);
 
 	rt2800_eeprom_read(rt2x00dev, EEPROM_RSSI_BG2, &word);
 	if (abs(rt2x00_get_field16(word, EEPROM_RSSI_BG2_OFFSET2)) > 10)
@@ -6472,13 +6488,7 @@ static int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 				   default_lna_gain);
 	rt2800_eeprom_write(rt2x00dev, EEPROM_RSSI_BG2, word);
 
-	rt2800_eeprom_read(rt2x00dev, EEPROM_TXMIXER_GAIN_A, &word);
-	if ((word & 0x00ff) != 0x00ff) {
-		drv_data->txmixer_gain_5g =
-			rt2x00_get_field16(word, EEPROM_TXMIXER_GAIN_A_VAL);
-	} else {
-		drv_data->txmixer_gain_5g = 0;
-	}
+	drv_data->txmixer_gain_5g = rt2800_get_txmixer_gain_5g(rt2x00dev);
 
 	rt2800_eeprom_read(rt2x00dev, EEPROM_RSSI_A, &word);
 	if (abs(rt2x00_get_field16(word, EEPROM_RSSI_A_OFFSET0)) > 10)
-- 
1.7.10

