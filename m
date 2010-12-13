Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f45.google.com ([209.85.215.45]:47560 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab0LMLkD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 06:40:03 -0500
Received: by ewy10 with SMTP id 10so3803451ewy.4
        for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 03:40:01 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 01/17] rt2x00: Add rt2800 EEPROM definition
Date: Mon, 13 Dec 2010 12:31:27 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201012131231.28313.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: RA-Jay Hung <Jay_Hung@ralinktech.com>

Add and modify NIC Configuration and LED definition of EEPROM

Signed-off-by: RA-Jay Hung <jay_hung@ralinktech.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h    |   94 +++++++++++++++++---------
 drivers/net/wireless/rt2x00/rt2800lib.c |  111 ++++++++++++++++---------------
 2 files changed, 119 insertions(+), 86 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index a81c437..9dcbf87 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -1841,32 +1841,51 @@ struct mac_iveiv_entry {
 #define EEPROM_MAC_ADDR_BYTE5		FIELD16(0xff00)
 
 /*
- * EEPROM ANTENNA config
+ * EEPROM NIC Configuration 0
  * RXPATH: 1: 1R, 2: 2R, 3: 3R
- * TXPATH: 1: 1T, 2: 2T
- */
-#define	EEPROM_ANTENNA			0x001a
-#define EEPROM_ANTENNA_RXPATH		FIELD16(0x000f)
-#define EEPROM_ANTENNA_TXPATH		FIELD16(0x00f0)
-#define EEPROM_ANTENNA_RF_TYPE		FIELD16(0x0f00)
-
-/*
- * EEPROM NIC config
- * CARDBUS_ACCEL: 0 - enable, 1 - disable
- */
-#define	EEPROM_NIC			0x001b
-#define EEPROM_NIC_HW_RADIO		FIELD16(0x0001)
-#define EEPROM_NIC_DYNAMIC_TX_AGC	FIELD16(0x0002)
-#define EEPROM_NIC_EXTERNAL_LNA_BG	FIELD16(0x0004)
-#define EEPROM_NIC_EXTERNAL_LNA_A	FIELD16(0x0008)
-#define EEPROM_NIC_CARDBUS_ACCEL	FIELD16(0x0010)
-#define EEPROM_NIC_BW40M_SB_BG		FIELD16(0x0020)
-#define EEPROM_NIC_BW40M_SB_A		FIELD16(0x0040)
-#define EEPROM_NIC_WPS_PBC		FIELD16(0x0080)
-#define EEPROM_NIC_BW40M_BG		FIELD16(0x0100)
-#define EEPROM_NIC_BW40M_A		FIELD16(0x0200)
-#define EEPROM_NIC_ANT_DIVERSITY	FIELD16(0x0800)
-#define EEPROM_NIC_DAC_TEST		FIELD16(0x8000)
+ * TXPATH: 1: 1T, 2: 2T, 3: 3T
+ * RF_TYPE: RFIC type
+ */
+#define	EEPROM_NIC_CONF0		0x001a
+#define EEPROM_NIC_CONF0_RXPATH		FIELD16(0x000f)
+#define EEPROM_NIC_CONF0_TXPATH		FIELD16(0x00f0)
+#define EEPROM_NIC_CONF0_RF_TYPE		FIELD16(0x0f00)
+
+/*
+ * EEPROM NIC Configuration 1
+ * HW_RADIO: 0: disable, 1: enable
+ * EXTERNAL_TX_ALC: 0: disable, 1: enable
+ * EXTERNAL_LNA_2G: 0: disable, 1: enable
+ * EXTERNAL_LNA_5G: 0: disable, 1: enable
+ * CARDBUS_ACCEL: 0: enable, 1: disable
+ * BW40M_SB_2G: 0: disable, 1: enable
+ * BW40M_SB_5G: 0: disable, 1: enable
+ * WPS_PBC: 0: disable, 1: enable
+ * BW40M_2G: 0: enable, 1: disable
+ * BW40M_5G: 0: enable, 1: disable
+ * BROADBAND_EXT_LNA: 0: disable, 1: enable
+ * ANT_DIVERSITY: 00: Disable, 01: Diversity,
+ * 				  10: Main antenna, 11: Aux antenna
+ * INTERNAL_TX_ALC: 0: disable, 1: enable
+ * BT_COEXIST: 0: disable, 1: enable
+ * DAC_TEST: 0: disable, 1: enable
+ */
+#define	EEPROM_NIC_CONF1		0x001b
+#define EEPROM_NIC_CONF1_HW_RADIO		FIELD16(0x0001)
+#define EEPROM_NIC_CONF1_EXTERNAL_TX_ALC		FIELD16(0x0002)
+#define EEPROM_NIC_CONF1_EXTERNAL_LNA_2G		FIELD16(0x0004)
+#define EEPROM_NIC_CONF1_EXTERNAL_LNA_5G		FIELD16(0x0008)
+#define EEPROM_NIC_CONF1_CARDBUS_ACCEL		FIELD16(0x0010)
+#define EEPROM_NIC_CONF1_BW40M_SB_2G		FIELD16(0x0020)
+#define EEPROM_NIC_CONF1_BW40M_SB_5G		FIELD16(0x0040)
+#define EEPROM_NIC_CONF1_WPS_PBC		FIELD16(0x0080)
+#define EEPROM_NIC_CONF1_BW40M_2G		FIELD16(0x0100)
+#define EEPROM_NIC_CONF1_BW40M_5G		FIELD16(0x0200)
+#define EEPROM_NIC_CONF1_BROADBAND_EXT_LNA		FIELD16(0x400)
+#define EEPROM_NIC_CONF1_ANT_DIVERSITY		FIELD16(0x1800)
+#define EEPROM_NIC_CONF1_INTERNAL_TX_ALC		FIELD16(0x2000)
+#define EEPROM_NIC_CONF1_BT_COEXIST		FIELD16(0x4000)
+#define EEPROM_NIC_CONF1_DAC_TEST		FIELD16(0x8000)
 
 /*
  * EEPROM frequency
@@ -1888,9 +1907,9 @@ struct mac_iveiv_entry {
  * POLARITY_GPIO_4: Polarity GPIO4 setting.
  * LED_MODE: Led mode.
  */
-#define EEPROM_LED1			0x001e
-#define EEPROM_LED2			0x001f
-#define EEPROM_LED3			0x0020
+#define EEPROM_LED_AG_CONF		0x001e
+#define EEPROM_LED_ACT_CONF		0x001f
+#define EEPROM_LED_POLARITY		0x0020
 #define EEPROM_LED_POLARITY_RDY_BG	FIELD16(0x0001)
 #define EEPROM_LED_POLARITY_RDY_A	FIELD16(0x0002)
 #define EEPROM_LED_POLARITY_ACT		FIELD16(0x0004)
@@ -1902,6 +1921,17 @@ struct mac_iveiv_entry {
 #define EEPROM_LED_LED_MODE		FIELD16(0x1f00)
 
 /*
+ * EEPROM NIC Configuration 2
+ * RX_STREAM: 0: Reserved, 1: 1 Stream, 2: 2 Stream
+ * TX_STREAM: 0: Reserved, 1: 1 Stream, 2: 2 Stream
+ * CRYSTAL: 00: Reserved, 01: One crystal, 10: Two crystal, 11: Reserved
+ */
+#define EEPROM_NIC_CONF2		0x0021
+#define EEPROM_NIC_CONF2_RX_STREAM		FIELD16(0x000f)
+#define EEPROM_NIC_CONF2_TX_STREAM		FIELD16(0x00f0)
+#define EEPROM_NIC_CONF2_CRYSTAL		FIELD16(0x0600)
+
+/*
  * EEPROM LNA
  */
 #define EEPROM_LNA			0x0022
@@ -1951,7 +1981,7 @@ struct mac_iveiv_entry {
 
 /*
  * EEPROM TXpower delta: 20MHZ AND 40 MHZ use different power.
- *	This is delta in 40MHZ.
+ * This is delta in 40MHZ.
  * VALUE: Tx Power dalta value (MAX=4)
  * TYPE: 1: Plus the delta value, 0: minus the delta value
  * TXPOWER: Enable:
@@ -2007,9 +2037,9 @@ struct mac_iveiv_entry {
 #define MCU_CURRENT			0x36
 #define MCU_LED				0x50
 #define MCU_LED_STRENGTH		0x51
-#define MCU_LED_1			0x52
-#define MCU_LED_2			0x53
-#define MCU_LED_3			0x54
+#define MCU_LED_AG_CONF		0x52
+#define MCU_LED_ACT_CONF		0x53
+#define MCU_LED_LED_POLARITY		0x54
 #define MCU_RADAR			0x60
 #define MCU_BOOT_SIGNAL			0x72
 #define MCU_BBP_SIGNAL			0x80
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 7563161..9b592d9 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1930,8 +1930,8 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 		if (rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
 		    rt2x00_rt_rev_lt(rt2x00dev, RT3090, REV_RT3090E) ||
 		    rt2x00_rt_rev_lt(rt2x00dev, RT3390, REV_RT3390E)) {
-			rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC, &eeprom);
-			if (rt2x00_get_field16(eeprom, EEPROM_NIC_DAC_TEST))
+			rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
+			if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF1_DAC_TEST))
 				rt2800_register_write(rt2x00dev, TX_SW_CFG2,
 						      0x0000002c);
 			else
@@ -2376,10 +2376,10 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	    rt2x00_rt(rt2x00dev, RT3390)) {
 		rt2800_bbp_read(rt2x00dev, 138, &value);
 
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_ANTENNA, &eeprom);
-		if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_TXPATH) == 1)
+		rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0, &eeprom);
+		if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_TXPATH) == 1)
 			value |= 0x20;
-		if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RXPATH) == 1)
+		if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RXPATH) == 1)
 			value &= ~0x02;
 
 		rt2800_bbp_write(rt2x00dev, 138, value);
@@ -2591,8 +2591,8 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 		rt2x00_set_field32(&reg, LDO_CFG0_BGSEL, 1);
 		if (rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
 		    rt2x00_rt_rev_lt(rt2x00dev, RT3090, REV_RT3090E)) {
-			rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC, &eeprom);
-			if (rt2x00_get_field16(eeprom, EEPROM_NIC_DAC_TEST))
+			rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
+			if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF1_DAC_TEST))
 				rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 3);
 			else
 				rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 0);
@@ -2665,10 +2665,10 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	if (rt2x00_rt(rt2x00dev, RT3090)) {
 		rt2800_bbp_read(rt2x00dev, 138, &bbp);
 
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_ANTENNA, &eeprom);
-		if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RXPATH) == 1)
+		rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0, &eeprom);
+		if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RXPATH) == 1)
 			rt2x00_set_field8(&bbp, BBP138_RX_ADC1, 0);
-		if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_TXPATH) == 1)
+		if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_TXPATH) == 1)
 			rt2x00_set_field8(&bbp, BBP138_TX_DAC1, 1);
 
 		rt2800_bbp_write(rt2x00dev, 138, bbp);
@@ -2767,16 +2767,16 @@ int rt2800_enable_radio(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize LED control
 	 */
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_LED1, &word);
-	rt2800_mcu_request(rt2x00dev, MCU_LED_1, 0xff,
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_LED_AG_CONF, &word);
+	rt2800_mcu_request(rt2x00dev, MCU_LED_AG_CONF, 0xff,
 			   word & 0xff, (word >> 8) & 0xff);
 
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_LED2, &word);
-	rt2800_mcu_request(rt2x00dev, MCU_LED_2, 0xff,
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_LED_ACT_CONF, &word);
+	rt2800_mcu_request(rt2x00dev, MCU_LED_ACT_CONF, 0xff,
 			   word & 0xff, (word >> 8) & 0xff);
 
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_LED3, &word);
-	rt2800_mcu_request(rt2x00dev, MCU_LED_3, 0xff,
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_LED_POLARITY, &word);
+	rt2800_mcu_request(rt2x00dev, MCU_LED_LED_POLARITY, 0xff,
 			   word & 0xff, (word >> 8) & 0xff);
 
 	return 0;
@@ -2870,38 +2870,41 @@ int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 		EEPROM(rt2x00dev, "MAC: %pM\n", mac);
 	}
 
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_ANTENNA, &word);
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0, &word);
 	if (word == 0xffff) {
-		rt2x00_set_field16(&word, EEPROM_ANTENNA_RXPATH, 2);
-		rt2x00_set_field16(&word, EEPROM_ANTENNA_TXPATH, 1);
-		rt2x00_set_field16(&word, EEPROM_ANTENNA_RF_TYPE, RF2820);
-		rt2x00_eeprom_write(rt2x00dev, EEPROM_ANTENNA, word);
+		rt2x00_set_field16(&word, EEPROM_NIC_CONF0_RXPATH, 2);
+		rt2x00_set_field16(&word, EEPROM_NIC_CONF0_TXPATH, 1);
+		rt2x00_set_field16(&word, EEPROM_NIC_CONF0_RF_TYPE, RF2820);
+		rt2x00_eeprom_write(rt2x00dev, EEPROM_NIC_CONF0, word);
 		EEPROM(rt2x00dev, "Antenna: 0x%04x\n", word);
 	} else if (rt2x00_rt(rt2x00dev, RT2860) ||
 		   rt2x00_rt(rt2x00dev, RT2872)) {
 		/*
 		 * There is a max of 2 RX streams for RT28x0 series
 		 */
-		if (rt2x00_get_field16(word, EEPROM_ANTENNA_RXPATH) > 2)
-			rt2x00_set_field16(&word, EEPROM_ANTENNA_RXPATH, 2);
-		rt2x00_eeprom_write(rt2x00dev, EEPROM_ANTENNA, word);
+		if (rt2x00_get_field16(word, EEPROM_NIC_CONF0_RXPATH) > 2)
+			rt2x00_set_field16(&word, EEPROM_NIC_CONF0_RXPATH, 2);
+		rt2x00_eeprom_write(rt2x00dev, EEPROM_NIC_CONF0, word);
 	}
 
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC, &word);
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &word);
 	if (word == 0xffff) {
-		rt2x00_set_field16(&word, EEPROM_NIC_HW_RADIO, 0);
-		rt2x00_set_field16(&word, EEPROM_NIC_DYNAMIC_TX_AGC, 0);
-		rt2x00_set_field16(&word, EEPROM_NIC_EXTERNAL_LNA_BG, 0);
-		rt2x00_set_field16(&word, EEPROM_NIC_EXTERNAL_LNA_A, 0);
-		rt2x00_set_field16(&word, EEPROM_NIC_CARDBUS_ACCEL, 0);
-		rt2x00_set_field16(&word, EEPROM_NIC_BW40M_SB_BG, 0);
-		rt2x00_set_field16(&word, EEPROM_NIC_BW40M_SB_A, 0);
-		rt2x00_set_field16(&word, EEPROM_NIC_WPS_PBC, 0);
-		rt2x00_set_field16(&word, EEPROM_NIC_BW40M_BG, 0);
-		rt2x00_set_field16(&word, EEPROM_NIC_BW40M_A, 0);
-		rt2x00_set_field16(&word, EEPROM_NIC_ANT_DIVERSITY, 0);
-		rt2x00_set_field16(&word, EEPROM_NIC_DAC_TEST, 0);
-		rt2x00_eeprom_write(rt2x00dev, EEPROM_NIC, word);
+		rt2x00_set_field16(&word, EEPROM_NIC_CONF1_HW_RADIO, 0);
+		rt2x00_set_field16(&word, EEPROM_NIC_CONF1_EXTERNAL_TX_ALC, 0);
+		rt2x00_set_field16(&word, EEPROM_NIC_CONF1_EXTERNAL_LNA_2G, 0);
+		rt2x00_set_field16(&word, EEPROM_NIC_CONF1_EXTERNAL_LNA_5G, 0);
+		rt2x00_set_field16(&word, EEPROM_NIC_CONF1_CARDBUS_ACCEL, 0);
+		rt2x00_set_field16(&word, EEPROM_NIC_CONF1_BW40M_SB_2G, 0);
+		rt2x00_set_field16(&word, EEPROM_NIC_CONF1_BW40M_SB_5G, 0);
+		rt2x00_set_field16(&word, EEPROM_NIC_CONF1_WPS_PBC, 0);
+		rt2x00_set_field16(&word, EEPROM_NIC_CONF1_BW40M_2G, 0);
+		rt2x00_set_field16(&word, EEPROM_NIC_CONF1_BW40M_5G, 0);
+		rt2x00_set_field16(&word, EEPROM_NIC_CONF1_BROADBAND_EXT_LNA, 0);
+		rt2x00_set_field16(&word, EEPROM_NIC_CONF1_ANT_DIVERSITY, 0);
+		rt2x00_set_field16(&word, EEPROM_NIC_CONF1_INTERNAL_TX_ALC, 0);
+		rt2x00_set_field16(&word, EEPROM_NIC_CONF1_BT_COEXIST, 0);
+		rt2x00_set_field16(&word, EEPROM_NIC_CONF1_DAC_TEST, 0);
+		rt2x00_eeprom_write(rt2x00dev, EEPROM_NIC_CONF1, word);
 		EEPROM(rt2x00dev, "NIC: 0x%04x\n", word);
 	}
 
@@ -2916,9 +2919,9 @@ int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 				   LED_MODE_TXRX_ACTIVITY);
 		rt2x00_set_field16(&word, EEPROM_FREQ_LED_POLARITY, 0);
 		rt2x00_eeprom_write(rt2x00dev, EEPROM_FREQ, word);
-		rt2x00_eeprom_write(rt2x00dev, EEPROM_LED1, 0x5555);
-		rt2x00_eeprom_write(rt2x00dev, EEPROM_LED2, 0x2221);
-		rt2x00_eeprom_write(rt2x00dev, EEPROM_LED3, 0xa9f8);
+		rt2x00_eeprom_write(rt2x00dev, EEPROM_LED_AG_CONF, 0x5555);
+		rt2x00_eeprom_write(rt2x00dev, EEPROM_LED_ACT_CONF, 0x2221);
+		rt2x00_eeprom_write(rt2x00dev, EEPROM_LED_POLARITY, 0xa9f8);
 		EEPROM(rt2x00dev, "Led Mode: 0x%04x\n", word);
 	}
 
@@ -2982,12 +2985,12 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Read EEPROM word for configuration.
 	 */
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_ANTENNA, &eeprom);
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0, &eeprom);
 
 	/*
 	 * Identify RF chipset.
 	 */
-	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RF_TYPE);
+	value = rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RF_TYPE);
 	rt2800_register_read(rt2x00dev, MAC_CSR0, &reg);
 
 	rt2x00_set_chip(rt2x00dev, rt2x00_get_field32(reg, MAC_CSR0_CHIPSET),
@@ -3023,9 +3026,9 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	 * Identify default antenna configuration.
 	 */
 	rt2x00dev->default_ant.tx =
-	    rt2x00_get_field16(eeprom, EEPROM_ANTENNA_TXPATH);
+	    rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_TXPATH);
 	rt2x00dev->default_ant.rx =
-	    rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RXPATH);
+	    rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RXPATH);
 
 	/*
 	 * Read frequency offset and RF programming sequence.
@@ -3036,17 +3039,17 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Read external LNA informations.
 	 */
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC, &eeprom);
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
 
-	if (rt2x00_get_field16(eeprom, EEPROM_NIC_EXTERNAL_LNA_A))
+	if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF1_EXTERNAL_LNA_5G))
 		__set_bit(CONFIG_EXTERNAL_LNA_A, &rt2x00dev->flags);
-	if (rt2x00_get_field16(eeprom, EEPROM_NIC_EXTERNAL_LNA_BG))
+	if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF1_EXTERNAL_LNA_2G))
 		__set_bit(CONFIG_EXTERNAL_LNA_BG, &rt2x00dev->flags);
 
 	/*
 	 * Detect if this device has an hardware controlled radio.
 	 */
-	if (rt2x00_get_field16(eeprom, EEPROM_NIC_HW_RADIO))
+	if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF1_HW_RADIO))
 		__set_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags);
 
 	/*
@@ -3258,7 +3261,7 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->hw->max_report_rates = 7;
 	rt2x00dev->hw->max_rate_tries = 1;
 
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_ANTENNA, &eeprom);
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0, &eeprom);
 
 	/*
 	 * Initialize hw_mode information.
@@ -3302,11 +3305,11 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	    IEEE80211_HT_CAP_SGI_20 |
 	    IEEE80211_HT_CAP_SGI_40;
 
-	if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_TXPATH) >= 2)
+	if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_TXPATH) >= 2)
 		spec->ht.cap |= IEEE80211_HT_CAP_TX_STBC;
 
 	spec->ht.cap |=
-	    rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RXPATH) <<
+	    rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RXPATH) <<
 		IEEE80211_HT_CAP_RX_STBC_SHIFT;
 
 	spec->ht.ampdu_factor = 3;
@@ -3314,10 +3317,10 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	spec->ht.mcs.tx_params =
 	    IEEE80211_HT_MCS_TX_DEFINED |
 	    IEEE80211_HT_MCS_TX_RX_DIFF |
-	    ((rt2x00_get_field16(eeprom, EEPROM_ANTENNA_TXPATH) - 1) <<
+	    ((rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_TXPATH) - 1) <<
 		IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT);
 
-	switch (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RXPATH)) {
+	switch (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RXPATH)) {
 	case 3:
 		spec->ht.mcs.rx_mask[2] = 0xff;
 	case 2:
-- 
1.7.2.3

