Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60805 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab1BTM6M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Feb 2011 07:58:12 -0500
Received: by eye27 with SMTP id 27so2477416eye.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Feb 2011 04:58:02 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/8] rt2x00: Add antenna setting for RT3070/RT3090/RT3390 with RX antenna diversity support
Date: Sun, 20 Feb 2011 13:54:52 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201102201354.53379.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: RA-Jay Hung <Jay_Hung@ralinktech.com>

For RT3070/RT3090/RT3390 with RX antenna diversity support, we must select
default antenna using gpio control way even if we do not turn on
antenna diversity feature.

Seperate the meaning of TX/RX chain and antenna. Some chips use
2x2 TX/RX chain but may have 3 RX antennas or 1x1 TX/RX chain
but may have 2 RX antennas to do antenna diversity.

Signed-off-by: RA-Jay Hung <jay_hung@ralinktech.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h    |    3 +
 drivers/net/wireless/rt2x00/rt2800lib.c |   74 +++++++++++++++++++++++++++----
 drivers/net/wireless/rt2x00/rt2x00.h    |    2 +
 3 files changed, 70 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index ec8159c..ef8f605 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -270,6 +270,7 @@
 
 /*
  * GPIO_CTRL_CFG:
+ * GPIOD: GPIO direction, 0: Output, 1: Input
  */
 #define GPIO_CTRL_CFG			0x0228
 #define GPIO_CTRL_CFG_BIT0		FIELD32(0x00000001)
@@ -281,6 +282,7 @@
 #define GPIO_CTRL_CFG_BIT6		FIELD32(0x00000040)
 #define GPIO_CTRL_CFG_BIT7		FIELD32(0x00000080)
 #define GPIO_CTRL_CFG_BIT8		FIELD32(0x00000100)
+#define GPIO_CTRL_CFG_GPIOD		FIELD32(0x00000800)
 
 /*
  * MCU_CMD_CFG
@@ -2068,6 +2070,7 @@ struct mac_iveiv_entry {
 #define MCU_LED_LED_POLARITY		0x54
 #define MCU_RADAR			0x60
 #define MCU_BOOT_SIGNAL			0x72
+#define MCU_ANT_SELECT			0X73
 #define MCU_BBP_SIGNAL			0x80
 #define MCU_POWER_SAVE			0x83
 
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index c9bf074..7f44b97 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1368,10 +1368,32 @@ void rt2800_config_erp(struct rt2x00_dev *rt2x00dev, struct rt2x00lib_erp *erp,
 }
 EXPORT_SYMBOL_GPL(rt2800_config_erp);
 
+static void rt2800_set_ant_diversity(struct rt2x00_dev *rt2x00dev,
+				     enum antenna ant)
+{
+	u32 reg;
+	u8 eesk_pin = (ant == ANTENNA_A) ? 1 : 0;
+	u8 gpio_bit3 = (ant == ANTENNA_A) ? 0 : 1;
+
+	if (rt2x00_is_pci(rt2x00dev)) {
+		rt2800_register_read(rt2x00dev, E2PROM_CSR, &reg);
+		rt2x00_set_field32(&reg, E2PROM_CSR_DATA_CLOCK, eesk_pin);
+		rt2800_register_write(rt2x00dev, E2PROM_CSR, reg);
+	} else if (rt2x00_is_usb(rt2x00dev))
+		rt2800_mcu_request(rt2x00dev, MCU_ANT_SELECT, 0xff,
+				   eesk_pin, 0);
+
+	rt2800_register_read(rt2x00dev, GPIO_CTRL_CFG, &reg);
+	rt2x00_set_field32(&reg, GPIO_CTRL_CFG_GPIOD, 0);
+	rt2x00_set_field32(&reg, GPIO_CTRL_CFG_BIT3, gpio_bit3);
+	rt2800_register_write(rt2x00dev, GPIO_CTRL_CFG, reg);
+}
+
 void rt2800_config_ant(struct rt2x00_dev *rt2x00dev, struct antenna_setup *ant)
 {
 	u8 r1;
 	u8 r3;
+	u16 eeprom;
 
 	rt2800_bbp_read(rt2x00dev, 1, &r1);
 	rt2800_bbp_read(rt2x00dev, 3, &r3);
@@ -1379,7 +1401,7 @@ void rt2800_config_ant(struct rt2x00_dev *rt2x00dev, struct antenna_setup *ant)
 	/*
 	 * Configure the TX antenna.
 	 */
-	switch ((int)ant->tx) {
+	switch (ant->tx_chain_num) {
 	case 1:
 		rt2x00_set_field8(&r1, BBP1_TX_ANTENNA, 0);
 		break;
@@ -1394,8 +1416,18 @@ void rt2800_config_ant(struct rt2x00_dev *rt2x00dev, struct antenna_setup *ant)
 	/*
 	 * Configure the RX antenna.
 	 */
-	switch ((int)ant->rx) {
+	switch (ant->rx_chain_num) {
 	case 1:
+		if (rt2x00_rt(rt2x00dev, RT3070) ||
+		    rt2x00_rt(rt2x00dev, RT3090) ||
+		    rt2x00_rt(rt2x00dev, RT3390)) {
+			rt2x00_eeprom_read(rt2x00dev,
+					   EEPROM_NIC_CONF1, &eeprom);
+			if (rt2x00_get_field16(eeprom,
+						EEPROM_NIC_CONF1_ANT_DIVERSITY))
+				rt2800_set_ant_diversity(rt2x00dev,
+						rt2x00dev->default_ant.rx);
+		}
 		rt2x00_set_field8(&r3, BBP3_RX_ANTENNA, 0);
 		break;
 	case 2:
@@ -1441,13 +1473,13 @@ static void rt2800_config_channel_rf2xxx(struct rt2x00_dev *rt2x00dev,
 {
 	rt2x00_set_field32(&rf->rf4, RF4_FREQ_OFFSET, rt2x00dev->freq_offset);
 
-	if (rt2x00dev->default_ant.tx == 1)
+	if (rt2x00dev->default_ant.tx_chain_num == 1)
 		rt2x00_set_field32(&rf->rf2, RF2_ANTENNA_TX1, 1);
 
-	if (rt2x00dev->default_ant.rx == 1) {
+	if (rt2x00dev->default_ant.rx_chain_num == 1) {
 		rt2x00_set_field32(&rf->rf2, RF2_ANTENNA_RX1, 1);
 		rt2x00_set_field32(&rf->rf2, RF2_ANTENNA_RX2, 1);
-	} else if (rt2x00dev->default_ant.rx == 2)
+	} else if (rt2x00dev->default_ant.rx_chain_num == 2)
 		rt2x00_set_field32(&rf->rf2, RF2_ANTENNA_RX2, 1);
 
 	if (rf->channel > 14) {
@@ -1594,13 +1626,13 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	tx_pin = 0;
 
 	/* Turn on unused PA or LNA when not using 1T or 1R */
-	if (rt2x00dev->default_ant.tx != 1) {
+	if (rt2x00dev->default_ant.tx_chain_num == 2) {
 		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A1_EN, 1);
 		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G1_EN, 1);
 	}
 
 	/* Turn on unused PA or LNA when not using 1T or 1R */
-	if (rt2x00dev->default_ant.rx != 1) {
+	if (rt2x00dev->default_ant.rx_chain_num == 2) {
 		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_A1_EN, 1);
 		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_G1_EN, 1);
 	}
@@ -3060,11 +3092,35 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Identify default antenna configuration.
 	 */
-	rt2x00dev->default_ant.tx =
+	rt2x00dev->default_ant.tx_chain_num =
 	    rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_TXPATH);
-	rt2x00dev->default_ant.rx =
+	rt2x00dev->default_ant.rx_chain_num =
 	    rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RXPATH);
 
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
+
+	if (rt2x00_rt(rt2x00dev, RT3070) ||
+	    rt2x00_rt(rt2x00dev, RT3090) ||
+	    rt2x00_rt(rt2x00dev, RT3390)) {
+		value = rt2x00_get_field16(eeprom,
+				EEPROM_NIC_CONF1_ANT_DIVERSITY);
+		switch (value) {
+		case 0:
+		case 1:
+		case 2:
+			rt2x00dev->default_ant.tx = ANTENNA_A;
+			rt2x00dev->default_ant.rx = ANTENNA_A;
+			break;
+		case 3:
+			rt2x00dev->default_ant.tx = ANTENNA_A;
+			rt2x00dev->default_ant.rx = ANTENNA_B;
+			break;
+		}
+	} else {
+		rt2x00dev->default_ant.tx = ANTENNA_A;
+		rt2x00dev->default_ant.rx = ANTENNA_A;
+	}
+
 	/*
 	 * Read frequency offset and RF programming sequence.
 	 */
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 39bc2fa..fd28836 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -225,6 +225,8 @@ struct channel_info {
 struct antenna_setup {
 	enum antenna rx;
 	enum antenna tx;
+	u8 rx_chain_num;
+	u8 tx_chain_num;
 };
 
 /*
-- 
1.7.2.3

