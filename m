Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48341 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060Ab3GHOI5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 10:08:57 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v3 12/20] rt2x00: rt2800lib: fix LNA_A[12] gain values for RT3593
Date: Mon,  8 Jul 2013 16:08:27 +0200
Message-Id: <1373292515-21332-13-git-send-email-juhosg@openwrt.org> (sfid-20130708_162039_340544_641C65EA)
In-Reply-To: <1373292515-21332-1-git-send-email-juhosg@openwrt.org>
References: <1373292515-21332-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The LNA_A[12] gain values are stored at a different
offset in the EEPROM on RT3593 based devices. However
the current code unconditionally reads those values
from the location used by other chipsets.

Fix the code to use the correct EEPROM offset.

Based on the DPO_RT5572_LinuxSTA_2.6.0.1_20120629
driver.

References:
  RT3593_EEPROM_RSSI2_OFFSET_ALNAGAIN1_24G_READ in include/chip/rt3593.h
  RT3593_EEPROM_RSSI2_OFFSET_ALNAGAIN2_5G_READ in include/chip/rt3593.h

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
Changes since v2:
  - replace 'rt2x00lib' with 'rt2800lib' in subject
---
 drivers/net/wireless/rt2x00/rt2800.h    |    4 +++
 drivers/net/wireless/rt2x00/rt2800lib.c |   55 ++++++++++++++++++++++++-------
 2 files changed, 47 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 69749ba5..7688e15 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -2672,6 +2672,10 @@ enum rt2800_eeprom_word {
 #define EEPROM_BBP_VALUE		FIELD16(0x00ff)
 #define EEPROM_BBP_REG_ID		FIELD16(0xff00)
 
+/* EEPROM_EXT_LNA2 */
+#define EEPROM_EXT_LNA2_A1		FIELD16(0x00ff)
+#define EEPROM_EXT_LNA2_A2		FIELD16(0xff00)
+
 /*
  * EEPROM IQ Calibration, unlike other entries those are byte addresses.
  */
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 65045e0..419ea05 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1826,11 +1826,25 @@ static void rt2800_config_lna_gain(struct rt2x00_dev *rt2x00dev,
 		rt2800_eeprom_read(rt2x00dev, EEPROM_LNA, &eeprom);
 		lna_gain = rt2x00_get_field16(eeprom, EEPROM_LNA_A0);
 	} else if (libconf->rf.channel <= 128) {
-		rt2800_eeprom_read(rt2x00dev, EEPROM_RSSI_BG2, &eeprom);
-		lna_gain = rt2x00_get_field16(eeprom, EEPROM_RSSI_BG2_LNA_A1);
+		if (rt2x00_rt(rt2x00dev, RT3593)) {
+			rt2800_eeprom_read(rt2x00dev, EEPROM_EXT_LNA2, &eeprom);
+			lna_gain = rt2x00_get_field16(eeprom,
+						      EEPROM_EXT_LNA2_A1);
+		} else {
+			rt2800_eeprom_read(rt2x00dev, EEPROM_RSSI_BG2, &eeprom);
+			lna_gain = rt2x00_get_field16(eeprom,
+						      EEPROM_RSSI_BG2_LNA_A1);
+		}
 	} else {
-		rt2800_eeprom_read(rt2x00dev, EEPROM_RSSI_A2, &eeprom);
-		lna_gain = rt2x00_get_field16(eeprom, EEPROM_RSSI_A2_LNA_A2);
+		if (rt2x00_rt(rt2x00dev, RT3593)) {
+			rt2800_eeprom_read(rt2x00dev, EEPROM_EXT_LNA2, &eeprom);
+			lna_gain = rt2x00_get_field16(eeprom,
+						      EEPROM_EXT_LNA2_A2);
+		} else {
+			rt2800_eeprom_read(rt2x00dev, EEPROM_RSSI_A2, &eeprom);
+			lna_gain = rt2x00_get_field16(eeprom,
+						      EEPROM_RSSI_A2_LNA_A2);
+		}
 	}
 
 	rt2x00dev->lna_gain = lna_gain;
@@ -6488,10 +6502,12 @@ static int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2800_eeprom_read(rt2x00dev, EEPROM_RSSI_BG2, &word);
 	if (abs(rt2x00_get_field16(word, EEPROM_RSSI_BG2_OFFSET2)) > 10)
 		rt2x00_set_field16(&word, EEPROM_RSSI_BG2_OFFSET2, 0);
-	if (rt2x00_get_field16(word, EEPROM_RSSI_BG2_LNA_A1) == 0x00 ||
-	    rt2x00_get_field16(word, EEPROM_RSSI_BG2_LNA_A1) == 0xff)
-		rt2x00_set_field16(&word, EEPROM_RSSI_BG2_LNA_A1,
-				   default_lna_gain);
+	if (!rt2x00_rt(rt2x00dev, RT3593)) {
+		if (rt2x00_get_field16(word, EEPROM_RSSI_BG2_LNA_A1) == 0x00 ||
+		    rt2x00_get_field16(word, EEPROM_RSSI_BG2_LNA_A1) == 0xff)
+			rt2x00_set_field16(&word, EEPROM_RSSI_BG2_LNA_A1,
+					   default_lna_gain);
+	}
 	rt2800_eeprom_write(rt2x00dev, EEPROM_RSSI_BG2, word);
 
 	drv_data->txmixer_gain_5g = rt2800_get_txmixer_gain_5g(rt2x00dev);
@@ -6506,12 +6522,27 @@ static int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2800_eeprom_read(rt2x00dev, EEPROM_RSSI_A2, &word);
 	if (abs(rt2x00_get_field16(word, EEPROM_RSSI_A2_OFFSET2)) > 10)
 		rt2x00_set_field16(&word, EEPROM_RSSI_A2_OFFSET2, 0);
-	if (rt2x00_get_field16(word, EEPROM_RSSI_A2_LNA_A2) == 0x00 ||
-	    rt2x00_get_field16(word, EEPROM_RSSI_A2_LNA_A2) == 0xff)
-		rt2x00_set_field16(&word, EEPROM_RSSI_A2_LNA_A2,
-				   default_lna_gain);
+	if (!rt2x00_rt(rt2x00dev, RT3593)) {
+		if (rt2x00_get_field16(word, EEPROM_RSSI_A2_LNA_A2) == 0x00 ||
+		    rt2x00_get_field16(word, EEPROM_RSSI_A2_LNA_A2) == 0xff)
+			rt2x00_set_field16(&word, EEPROM_RSSI_A2_LNA_A2,
+					   default_lna_gain);
+	}
 	rt2800_eeprom_write(rt2x00dev, EEPROM_RSSI_A2, word);
 
+	if (rt2x00_rt(rt2x00dev, RT3593)) {
+		rt2800_eeprom_read(rt2x00dev, EEPROM_EXT_LNA2, &word);
+		if (rt2x00_get_field16(word, EEPROM_EXT_LNA2_A1) == 0x00 ||
+		    rt2x00_get_field16(word, EEPROM_EXT_LNA2_A1) == 0xff)
+			rt2x00_set_field16(&word, EEPROM_EXT_LNA2_A1,
+					   default_lna_gain);
+		if (rt2x00_get_field16(word, EEPROM_EXT_LNA2_A2) == 0x00 ||
+		    rt2x00_get_field16(word, EEPROM_EXT_LNA2_A2) == 0xff)
+			rt2x00_set_field16(&word, EEPROM_EXT_LNA2_A1,
+					   default_lna_gain);
+		rt2800_eeprom_write(rt2x00dev, EEPROM_EXT_LNA2, word);
+	}
+
 	return 0;
 }
 
-- 
1.7.10

