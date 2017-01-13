Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:44139 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750908AbdAMVc5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 16:32:57 -0500
Date: Fri, 13 Jan 2017 22:32:49 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 36/40] rt2x00: support for for RT3352 with external PA
Message-ID: <20170113213244.GA3650@makrotopia.org> (sfid-20170113_223300_618493_D5948755)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is needed for WiFi to work e.g. on DIR-615 rev.H1 which got
external RF power amplifiers connected to the WiSoC.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800.h    | 24 ++++++++
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 77 +++++++++++++++++++++-----
 drivers/net/wireless/ralink/rt2x00/rt2x00.h    |  2 +
 3 files changed, 90 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800.h b/drivers/net/wireless/ralink/rt2x00/rt2800.h
index 33a3b33c9a0b..14c94034a707 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800.h
@@ -2333,6 +2333,12 @@ struct mac_iveiv_entry {
 #define RFCSR36_RF_BS			FIELD8(0x80)
 
 /*
+ * RFCSR 34:
+ */
+#define RFCSR34_TX0_EXT_PA		FIELD8(0x04)
+#define RFCSR34_TX1_EXT_PA		FIELD8(0x08)
+
+/*
  * RFCSR 38:
  */
 #define RFCSR38_RX_LO1_EN		FIELD8(0x20)
@@ -2344,6 +2350,18 @@ struct mac_iveiv_entry {
 #define RFCSR39_RX_LO2_EN		FIELD8(0x80)
 
 /*
+ * RFCSR 41:
+ */
+#define RFCSR41_BIT1			FIELD8(0x01)
+#define RFCSR41_BIT4			FIELD8(0x08)
+
+/*
+ * RFCSR 42:
+ */
+#define RFCSR42_BIT1			FIELD8(0x01)
+#define RFCSR42_BIT4			FIELD8(0x08)
+
+/*
  * RFCSR 49:
  */
 #define RFCSR49_TX			FIELD8(0x3f)
@@ -2356,6 +2374,8 @@ struct mac_iveiv_entry {
  * RFCSR 50:
  */
 #define RFCSR50_TX			FIELD8(0x3f)
+#define RFCSR50_TX0_EXT_PA		FIELD8(0x02)
+#define RFCSR50_TX1_EXT_PA		FIELD8(0x10)
 #define RFCSR50_EP			FIELD8(0xc0)
 /* bits for RT3593 */
 #define RFCSR50_TX_LO1_EN		FIELD8(0x20)
@@ -2503,6 +2523,8 @@ enum rt2800_eeprom_word {
  * INTERNAL_TX_ALC: 0: disable, 1: enable
  * BT_COEXIST: 0: disable, 1: enable
  * DAC_TEST: 0: disable, 1: enable
+ * EXTERNAL_TX0_PA: 0: disable, 1: enable (only on RT3352)
+ * EXTERNAL_TX1_PA: 0: disable, 1: enable (only on RT3352)
  */
 #define EEPROM_NIC_CONF1_HW_RADIO		FIELD16(0x0001)
 #define EEPROM_NIC_CONF1_EXTERNAL_TX_ALC	FIELD16(0x0002)
@@ -2519,6 +2541,8 @@ enum rt2800_eeprom_word {
 #define EEPROM_NIC_CONF1_INTERNAL_TX_ALC	FIELD16(0x2000)
 #define EEPROM_NIC_CONF1_BT_COEXIST		FIELD16(0x4000)
 #define EEPROM_NIC_CONF1_DAC_TEST		FIELD16(0x8000)
+#define EEPROM_NIC_CONF1_EXTERNAL_TX0_PA_3352	FIELD16(0x4000)
+#define EEPROM_NIC_CONF1_EXTERNAL_TX1_PA_3352	FIELD16(0x8000)
 
 /*
  * EEPROM frequency
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 51c9d5e8b888..320fdb90be84 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -3564,11 +3564,18 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Change BBP settings
 	 */
+
 	if (rt2x00_rt(rt2x00dev, RT3352)) {
+		rt2800_bbp_write(rt2x00dev, 62, 0x37 - rt2x00dev->lna_gain);
+		rt2800_bbp_write(rt2x00dev, 63, 0x37 - rt2x00dev->lna_gain);
+		rt2800_bbp_write(rt2x00dev, 64, 0x37 - rt2x00dev->lna_gain);
+
 		rt2800_bbp_write(rt2x00dev, 27, 0x0);
 		rt2800_bbp_write(rt2x00dev, 66, 0x26 + rt2x00dev->lna_gain);
 		rt2800_bbp_write(rt2x00dev, 27, 0x20);
 		rt2800_bbp_write(rt2x00dev, 66, 0x26 + rt2x00dev->lna_gain);
+		rt2800_bbp_write(rt2x00dev, 86, 0x38);
+		rt2800_bbp_write(rt2x00dev, 83, 0x6a);
 	} else if (rt2x00_rt(rt2x00dev, RT3593)) {
 		if (rf->channel > 14) {
 			/* Disable CCK Packet detection on 5GHz */
@@ -6640,6 +6647,12 @@ static void rt2800_init_rfcsr_3290(struct rt2x00_dev *rt2x00dev)
 
 static void rt2800_init_rfcsr_3352(struct rt2x00_dev *rt2x00dev)
 {
+	int tx0_int_pa = test_bit(CAPABILITY_INTERNAL_PA_TX0,
+				  &rt2x00dev->cap_flags);
+	int tx1_int_pa = test_bit(CAPABILITY_INTERNAL_PA_TX1,
+				  &rt2x00dev->cap_flags);
+	u8 rfcsr;
+
 	rt2800_rf_init_calibration(rt2x00dev, 30);
 
 	rt2800_rfcsr_write(rt2x00dev, 0, 0xf0);
@@ -6675,15 +6688,30 @@ static void rt2800_init_rfcsr_3352(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_write(rt2x00dev, 31, 0x80);
 	rt2800_rfcsr_write(rt2x00dev, 32, 0x80);
 	rt2800_rfcsr_write(rt2x00dev, 33, 0x00);
-	rt2800_rfcsr_write(rt2x00dev, 34, 0x01);
+	rfcsr = 0x01;
+	if (!tx0_int_pa)
+		rt2x00_set_field8(&rfcsr, RFCSR34_TX0_EXT_PA, 1);
+	if (!tx1_int_pa)
+		rt2x00_set_field8(&rfcsr, RFCSR34_TX1_EXT_PA, 1);
+	rt2800_rfcsr_write(rt2x00dev, 34, rfcsr);
 	rt2800_rfcsr_write(rt2x00dev, 35, 0x03);
 	rt2800_rfcsr_write(rt2x00dev, 36, 0xbd);
 	rt2800_rfcsr_write(rt2x00dev, 37, 0x3c);
 	rt2800_rfcsr_write(rt2x00dev, 38, 0x5f);
 	rt2800_rfcsr_write(rt2x00dev, 39, 0xc5);
 	rt2800_rfcsr_write(rt2x00dev, 40, 0x33);
-	rt2800_rfcsr_write(rt2x00dev, 41, 0x5b);
-	rt2800_rfcsr_write(rt2x00dev, 42, 0x5b);
+	rfcsr = 0x52;
+	if (tx0_int_pa) {
+		rt2x00_set_field8(&rfcsr, RFCSR41_BIT1, 1);
+		rt2x00_set_field8(&rfcsr, RFCSR41_BIT4, 1);
+	}
+	rt2800_rfcsr_write(rt2x00dev, 41, rfcsr);
+	rfcsr = 0x52;
+	if (tx1_int_pa) {
+		rt2x00_set_field8(&rfcsr, RFCSR42_BIT1, 1);
+		rt2x00_set_field8(&rfcsr, RFCSR42_BIT4, 1);
+	}
+	rt2800_rfcsr_write(rt2x00dev, 42, rfcsr);
 	rt2800_rfcsr_write(rt2x00dev, 43, 0xdb);
 	rt2800_rfcsr_write(rt2x00dev, 44, 0xdb);
 	rt2800_rfcsr_write(rt2x00dev, 45, 0xdb);
@@ -6691,15 +6719,20 @@ static void rt2800_init_rfcsr_3352(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_write(rt2x00dev, 47, 0x0d);
 	rt2800_rfcsr_write(rt2x00dev, 48, 0x14);
 	rt2800_rfcsr_write(rt2x00dev, 49, 0x00);
-	rt2800_rfcsr_write(rt2x00dev, 50, 0x2d);
-	rt2800_rfcsr_write(rt2x00dev, 51, 0x7f);
-	rt2800_rfcsr_write(rt2x00dev, 52, 0x00);
-	rt2800_rfcsr_write(rt2x00dev, 53, 0x52);
-	rt2800_rfcsr_write(rt2x00dev, 54, 0x1b);
-	rt2800_rfcsr_write(rt2x00dev, 55, 0x7f);
-	rt2800_rfcsr_write(rt2x00dev, 56, 0x00);
-	rt2800_rfcsr_write(rt2x00dev, 57, 0x52);
-	rt2800_rfcsr_write(rt2x00dev, 58, 0x1b);
+	rfcsr = 0x2d;
+	if (!tx0_int_pa)
+		rt2x00_set_field8(&rfcsr, RFCSR50_TX0_EXT_PA, 1);
+	if (!tx1_int_pa)
+		rt2x00_set_field8(&rfcsr, RFCSR50_TX1_EXT_PA, 1);
+	rt2800_rfcsr_write(rt2x00dev, 50, rfcsr);
+	rt2800_rfcsr_write(rt2x00dev, 51, (tx0_int_pa ? 0x7f : 0x52));
+	rt2800_rfcsr_write(rt2x00dev, 52, (tx0_int_pa ? 0x00 : 0xc0));
+	rt2800_rfcsr_write(rt2x00dev, 53, (tx0_int_pa ? 0x52 : 0xd2));
+	rt2800_rfcsr_write(rt2x00dev, 54, (tx0_int_pa ? 0x1b : 0xc0));
+	rt2800_rfcsr_write(rt2x00dev, 55, (tx1_int_pa ? 0x7f : 0x52));
+	rt2800_rfcsr_write(rt2x00dev, 56, (tx1_int_pa ? 0x00 : 0xc0));
+	rt2800_rfcsr_write(rt2x00dev, 57, (tx0_int_pa ? 0x52 : 0x49));
+	rt2800_rfcsr_write(rt2x00dev, 58, (tx1_int_pa ? 0x1b : 0xc0));
 	rt2800_rfcsr_write(rt2x00dev, 59, 0x00);
 	rt2800_rfcsr_write(rt2x00dev, 60, 0x00);
 	rt2800_rfcsr_write(rt2x00dev, 61, 0x00);
@@ -7716,6 +7749,7 @@ static int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	 * RT53xx: defined in "EEPROM_CHIP_ID" field
 	 */
 	if (rt2x00_rt(rt2x00dev, RT3290) ||
+	    rt2x00_rt(rt2x00dev, RT3352) ||
 	    rt2x00_rt(rt2x00dev, RT5390) ||
 	    rt2x00_rt(rt2x00dev, RT5392))
 		rt2800_eeprom_read(rt2x00dev, EEPROM_CHIP_ID, &rf);
@@ -7811,7 +7845,8 @@ static int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Detect if this device has Bluetooth co-existence.
 	 */
-	if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF1_BT_COEXIST))
+	if (!rt2x00_rt(rt2x00dev, RT3352) &&
+	    rt2x00_get_field16(eeprom, EEPROM_NIC_CONF1_BT_COEXIST))
 		__set_bit(CAPABILITY_BT_COEXIST, &rt2x00dev->cap_flags);
 
 	/*
@@ -7840,6 +7875,22 @@ static int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 					EIRP_MAX_TX_POWER_LIMIT)
 		__set_bit(CAPABILITY_POWER_LIMIT, &rt2x00dev->cap_flags);
 
+	/*
+	 * Detect if device uses internal or external PA
+	 */
+	rt2800_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
+
+	if (rt2x00_rt(rt2x00dev, RT3352)) {
+		if (!rt2x00_get_field16(eeprom,
+		    EEPROM_NIC_CONF1_EXTERNAL_TX0_PA_3352))
+		    __set_bit(CAPABILITY_INTERNAL_PA_TX0,
+			      &rt2x00dev->cap_flags);
+		if (!rt2x00_get_field16(eeprom,
+		    EEPROM_NIC_CONF1_EXTERNAL_TX1_PA_3352))
+		    __set_bit(CAPABILITY_INTERNAL_PA_TX1,
+			      &rt2x00dev->cap_flags);
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
index c27408b494ef..cfbf414c2627 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
@@ -716,6 +716,8 @@ enum rt2x00_capability_flags {
 	CAPABILITY_DOUBLE_ANTENNA,
 	CAPABILITY_BT_COEXIST,
 	CAPABILITY_VCO_RECALIBRATION,
+	CAPABILITY_INTERNAL_PA_TX0,
+	CAPABILITY_INTERNAL_PA_TX1,
 };
 
 /*
-- 
2.11.0
