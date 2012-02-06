Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:3292 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756430Ab2BFW7F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 17:59:05 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 8/8] rt2x00: Correctly set txmixer_gain in RT3572 channel switching.
Date: Mon,  6 Feb 2012 23:45:13 +0100
Message-Id: <1328568313-26267-9-git-send-email-gwingerde@gmail.com> (sfid-20120206_235928_459302_E97B6A21)
In-Reply-To: <1328568313-26267-8-git-send-email-gwingerde@gmail.com>
References: <1328568313-26267-1-git-send-email-gwingerde@gmail.com>
 <1328568313-26267-2-git-send-email-gwingerde@gmail.com>
 <1328568313-26267-3-git-send-email-gwingerde@gmail.com>
 <1328568313-26267-4-git-send-email-gwingerde@gmail.com>
 <1328568313-26267-5-git-send-email-gwingerde@gmail.com>
 <1328568313-26267-6-git-send-email-gwingerde@gmail.com>
 <1328568313-26267-7-git-send-email-gwingerde@gmail.com>
 <1328568313-26267-8-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Align with the v2.5.0.0 Ralink RT3572 driver.

Save the EEPROM txmixer_gain values inside the rt2800 driver data structure
and use it throughout the code.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index c6648b0..06acabd 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -1849,6 +1849,11 @@ struct mac_iveiv_entry {
 #define RFCSR15_TX_LO2_EN		FIELD8(0x08)
 
 /*
+ * RFCSR 16:
+ */
+#define RFCSR16_TXMIXER_GAIN		FIELD8(0x07)
+
+/*
  * RFCSR 17:
  */
 #define RFCSR17_TXMIXER_GAIN		FIELD8(0x07)
@@ -2111,6 +2116,12 @@ struct mac_iveiv_entry {
 #define EEPROM_RSSI_A2_LNA_A2		FIELD16(0xff00)
 
 /*
+ * EEPROM TXMIXER GAIN A offset (note overlaps with EEPROM RSSI A2).
+ */
+#define EEPROM_TXMIXER_GAIN_A		0x0026
+#define EEPROM_TXMIXER_GAIN_A_VAL	FIELD16(0x0007)
+
+/*
  * EEPROM EIRP Maximum TX power values(unit: dbm)
  */
 #define EEPROM_EIRP_MAX_TX_POWER	0x0027
@@ -2448,6 +2459,8 @@ struct rt2800_drv_data {
 	u8 calibration_bw40;
 	u8 bbp25;
 	u8 bbp26;
+	u8 txmixer_gain_24g;
+	u8 txmixer_gain_5g;
 };
 
 #endif /* RT2800_H */
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 28dc6ba..772d4ae 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1856,7 +1856,10 @@ static void rt2800_config_channel_rf3052(struct rt2x00_dev *rt2x00dev,
 		rt2800_rfcsr_write(rt2x00dev, 10, 0xf1);
 		rt2800_rfcsr_write(rt2x00dev, 11, 0xb9);
 		rt2800_rfcsr_write(rt2x00dev, 15, 0x53);
-		rt2800_rfcsr_write(rt2x00dev, 16, 0x4c);
+		rfcsr = 0x4c;
+		rt2x00_set_field8(&rfcsr, RFCSR16_TXMIXER_GAIN,
+				  drv_data->txmixer_gain_24g);
+		rt2800_rfcsr_write(rt2x00dev, 16, rfcsr);
 		rt2800_rfcsr_write(rt2x00dev, 17, 0x23);
 		rt2800_rfcsr_write(rt2x00dev, 19, 0x93);
 		rt2800_rfcsr_write(rt2x00dev, 20, 0xb3);
@@ -1875,7 +1878,10 @@ static void rt2800_config_channel_rf3052(struct rt2x00_dev *rt2x00dev,
 		rt2800_rfcsr_write(rt2x00dev, 10, 0xf1);
 		rt2800_rfcsr_write(rt2x00dev, 11, 0x00);
 		rt2800_rfcsr_write(rt2x00dev, 15, 0x43);
-		rt2800_rfcsr_write(rt2x00dev, 16, 0x7a);
+		rfcsr = 0x7a;
+		rt2x00_set_field8(&rfcsr, RFCSR16_TXMIXER_GAIN,
+				  drv_data->txmixer_gain_5g);
+		rt2800_rfcsr_write(rt2x00dev, 16, rfcsr);
 		rt2800_rfcsr_write(rt2x00dev, 17, 0x23);
 		if (rf->channel <= 64) {
 			rt2800_rfcsr_write(rt2x00dev, 19, 0xb7);
@@ -3672,11 +3678,8 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 				      &rt2x00dev->cap_flags))
 				rt2x00_set_field8(&rfcsr, RFCSR17_R, 1);
 		}
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_TXMIXER_GAIN_BG, &eeprom);
-		if (rt2x00_get_field16(eeprom, EEPROM_TXMIXER_GAIN_BG_VAL) >= 1)
-			rt2x00_set_field8(&rfcsr, RFCSR17_TXMIXER_GAIN,
-					rt2x00_get_field16(eeprom,
-						EEPROM_TXMIXER_GAIN_BG_VAL));
+		rt2x00_set_field8(&rfcsr, RFCSR17_TXMIXER_GAIN,
+				  drv_data->txmixer_gain_24g);
 		rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
 	}
 
@@ -3884,6 +3887,7 @@ EXPORT_SYMBOL_GPL(rt2800_read_eeprom_efuse);
 
 int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 {
+	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
 	u16 word;
 	u8 *mac;
 	u8 default_lna_gain;
@@ -3967,6 +3971,14 @@ int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 		rt2x00_set_field16(&word, EEPROM_RSSI_BG_OFFSET1, 0);
 	rt2x00_eeprom_write(rt2x00dev, EEPROM_RSSI_BG, word);
 
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_TXMIXER_GAIN_BG, &word);
+	if ((word & 0x00ff) != 0x00ff) {
+		drv_data->txmixer_gain_24g =
+			rt2x00_get_field16(word, EEPROM_TXMIXER_GAIN_BG_VAL);
+	} else {
+		drv_data->txmixer_gain_24g = 0;
+	}
+
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_BG2, &word);
 	if (abs(rt2x00_get_field16(word, EEPROM_RSSI_BG2_OFFSET2)) > 10)
 		rt2x00_set_field16(&word, EEPROM_RSSI_BG2_OFFSET2, 0);
@@ -3976,6 +3988,14 @@ int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 				   default_lna_gain);
 	rt2x00_eeprom_write(rt2x00dev, EEPROM_RSSI_BG2, word);
 
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_TXMIXER_GAIN_A, &word);
+	if ((word & 0x00ff) != 0x00ff) {
+		drv_data->txmixer_gain_5g =
+			rt2x00_get_field16(word, EEPROM_TXMIXER_GAIN_A_VAL);
+	} else {
+		drv_data->txmixer_gain_5g = 0;
+	}
+
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_A, &word);
 	if (abs(rt2x00_get_field16(word, EEPROM_RSSI_A_OFFSET0)) > 10)
 		rt2x00_set_field16(&word, EEPROM_RSSI_A_OFFSET0, 0);
-- 
1.7.9

