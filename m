Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:49919 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438Ab3F1TNR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jun 2013 15:13:17 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 11/19] rt2x00: rt2x00lib: fix LNA_A[12] gain values for RT3593
Date: Fri, 28 Jun 2013 21:12:25 +0200
Message-Id: <1372446753-11408-12-git-send-email-juhosg@openwrt.org> (sfid-20130628_211349_559692_D183E08D)
In-Reply-To: <1372446753-11408-1-git-send-email-juhosg@openwrt.org>
References: <1372446753-11408-1-git-send-email-juhosg@openwrt.org>
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
index ea9b98d..f079d70 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1827,11 +1827,25 @@ static void rt2800_config_lna_gain(struct rt2x00_dev *rt2x00dev,
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
@@ -6489,10 +6503,12 @@ static int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
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
@@ -6507,12 +6523,27 @@ static int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
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

