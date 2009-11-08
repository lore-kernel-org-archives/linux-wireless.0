Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:62471 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbZKHNjX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 08:39:23 -0500
Received: by mail-ew0-f207.google.com with SMTP id 3so2371374ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 05:39:28 -0800 (PST)
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Date: Sun, 08 Nov 2009 14:39:01 +0100
Message-Id: <20091108133901.23584.3606.sendpatchset@localhost.localdomain>
In-Reply-To: <20091108133854.23584.86842.sendpatchset@localhost.localdomain>
References: <20091108133854.23584.86842.sendpatchset@localhost.localdomain>
Subject: [PATCH 2/9] rt2800: unify EEPROM support code
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2800: unify EEPROM support code

Add rt2800_validate_eeprom() and rt2800_init_eeprom() to rt2800lib.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |  199 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2800lib.h |    3 
 drivers/net/wireless/rt2x00/rt2800pci.c |  183 -----------------------------
 drivers/net/wireless/rt2x00/rt2800usb.c |  195 -------------------------------
 4 files changed, 204 insertions(+), 376 deletions(-)

Index: b/drivers/net/wireless/rt2x00/rt2800lib.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1659,6 +1659,205 @@ int rt2800_init_rfcsr(struct rt2x00_dev 
 }
 EXPORT_SYMBOL_GPL(rt2800_init_rfcsr);
 
+int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
+{
+	u16 word;
+	u8 *mac;
+	u8 default_lna_gain;
+
+	/*
+	 * Start validation of the data that has been read.
+	 */
+	mac = rt2x00_eeprom_addr(rt2x00dev, EEPROM_MAC_ADDR_0);
+	if (!is_valid_ether_addr(mac)) {
+		random_ether_addr(mac);
+		EEPROM(rt2x00dev, "MAC: %pM\n", mac);
+	}
+
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_ANTENNA, &word);
+	if (word == 0xffff) {
+		rt2x00_set_field16(&word, EEPROM_ANTENNA_RXPATH, 2);
+		rt2x00_set_field16(&word, EEPROM_ANTENNA_TXPATH, 1);
+		rt2x00_set_field16(&word, EEPROM_ANTENNA_RF_TYPE, RF2820);
+		rt2x00_eeprom_write(rt2x00dev, EEPROM_ANTENNA, word);
+		EEPROM(rt2x00dev, "Antenna: 0x%04x\n", word);
+	} else if (rt2x00_rev(&rt2x00dev->chip) < RT2883_VERSION) {
+		/*
+		 * There is a max of 2 RX streams for RT28x0 series
+		 */
+		if (rt2x00_get_field16(word, EEPROM_ANTENNA_RXPATH) > 2)
+			rt2x00_set_field16(&word, EEPROM_ANTENNA_RXPATH, 2);
+		rt2x00_eeprom_write(rt2x00dev, EEPROM_ANTENNA, word);
+	}
+
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC, &word);
+	if (word == 0xffff) {
+		rt2x00_set_field16(&word, EEPROM_NIC_HW_RADIO, 0);
+		rt2x00_set_field16(&word, EEPROM_NIC_DYNAMIC_TX_AGC, 0);
+		rt2x00_set_field16(&word, EEPROM_NIC_EXTERNAL_LNA_BG, 0);
+		rt2x00_set_field16(&word, EEPROM_NIC_EXTERNAL_LNA_A, 0);
+		rt2x00_set_field16(&word, EEPROM_NIC_CARDBUS_ACCEL, 0);
+		rt2x00_set_field16(&word, EEPROM_NIC_BW40M_SB_BG, 0);
+		rt2x00_set_field16(&word, EEPROM_NIC_BW40M_SB_A, 0);
+		rt2x00_set_field16(&word, EEPROM_NIC_WPS_PBC, 0);
+		rt2x00_set_field16(&word, EEPROM_NIC_BW40M_BG, 0);
+		rt2x00_set_field16(&word, EEPROM_NIC_BW40M_A, 0);
+		rt2x00_eeprom_write(rt2x00dev, EEPROM_NIC, word);
+		EEPROM(rt2x00dev, "NIC: 0x%04x\n", word);
+	}
+
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_FREQ, &word);
+	if ((word & 0x00ff) == 0x00ff) {
+		rt2x00_set_field16(&word, EEPROM_FREQ_OFFSET, 0);
+		rt2x00_set_field16(&word, EEPROM_FREQ_LED_MODE,
+				   LED_MODE_TXRX_ACTIVITY);
+		rt2x00_set_field16(&word, EEPROM_FREQ_LED_POLARITY, 0);
+		rt2x00_eeprom_write(rt2x00dev, EEPROM_FREQ, word);
+		rt2x00_eeprom_write(rt2x00dev, EEPROM_LED1, 0x5555);
+		rt2x00_eeprom_write(rt2x00dev, EEPROM_LED2, 0x2221);
+		rt2x00_eeprom_write(rt2x00dev, EEPROM_LED3, 0xa9f8);
+		EEPROM(rt2x00dev, "Freq: 0x%04x\n", word);
+	}
+
+	/*
+	 * During the LNA validation we are going to use
+	 * lna0 as correct value. Note that EEPROM_LNA
+	 * is never validated.
+	 */
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_LNA, &word);
+	default_lna_gain = rt2x00_get_field16(word, EEPROM_LNA_A0);
+
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_BG, &word);
+	if (abs(rt2x00_get_field16(word, EEPROM_RSSI_BG_OFFSET0)) > 10)
+		rt2x00_set_field16(&word, EEPROM_RSSI_BG_OFFSET0, 0);
+	if (abs(rt2x00_get_field16(word, EEPROM_RSSI_BG_OFFSET1)) > 10)
+		rt2x00_set_field16(&word, EEPROM_RSSI_BG_OFFSET1, 0);
+	rt2x00_eeprom_write(rt2x00dev, EEPROM_RSSI_BG, word);
+
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_BG2, &word);
+	if (abs(rt2x00_get_field16(word, EEPROM_RSSI_BG2_OFFSET2)) > 10)
+		rt2x00_set_field16(&word, EEPROM_RSSI_BG2_OFFSET2, 0);
+	if (rt2x00_get_field16(word, EEPROM_RSSI_BG2_LNA_A1) == 0x00 ||
+	    rt2x00_get_field16(word, EEPROM_RSSI_BG2_LNA_A1) == 0xff)
+		rt2x00_set_field16(&word, EEPROM_RSSI_BG2_LNA_A1,
+				   default_lna_gain);
+	rt2x00_eeprom_write(rt2x00dev, EEPROM_RSSI_BG2, word);
+
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_A, &word);
+	if (abs(rt2x00_get_field16(word, EEPROM_RSSI_A_OFFSET0)) > 10)
+		rt2x00_set_field16(&word, EEPROM_RSSI_A_OFFSET0, 0);
+	if (abs(rt2x00_get_field16(word, EEPROM_RSSI_A_OFFSET1)) > 10)
+		rt2x00_set_field16(&word, EEPROM_RSSI_A_OFFSET1, 0);
+	rt2x00_eeprom_write(rt2x00dev, EEPROM_RSSI_A, word);
+
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_A2, &word);
+	if (abs(rt2x00_get_field16(word, EEPROM_RSSI_A2_OFFSET2)) > 10)
+		rt2x00_set_field16(&word, EEPROM_RSSI_A2_OFFSET2, 0);
+	if (rt2x00_get_field16(word, EEPROM_RSSI_A2_LNA_A2) == 0x00 ||
+	    rt2x00_get_field16(word, EEPROM_RSSI_A2_LNA_A2) == 0xff)
+		rt2x00_set_field16(&word, EEPROM_RSSI_A2_LNA_A2,
+				   default_lna_gain);
+	rt2x00_eeprom_write(rt2x00dev, EEPROM_RSSI_A2, word);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rt2800_validate_eeprom);
+
+int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
+{
+	u32 reg;
+	u16 value;
+	u16 eeprom;
+
+	/*
+	 * Read EEPROM word for configuration.
+	 */
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_ANTENNA, &eeprom);
+
+	/*
+	 * Identify RF chipset.
+	 */
+	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RF_TYPE);
+	rt2800_register_read(rt2x00dev, MAC_CSR0, &reg);
+
+	if (rt2x00_intf_is_usb(rt2x00dev)) {
+		struct rt2x00_chip *chip = &rt2x00dev->chip;
+
+		rt2x00_set_chip(rt2x00dev, RT2870, value, reg);
+
+		/*
+		 * The check for rt2860 is not a typo, some rt2870 hardware
+		 * identifies itself as rt2860 in the CSR register.
+		 */
+		if (!rt2x00_check_rev(chip, 0xfff00000, 0x28600000) &&
+		    !rt2x00_check_rev(chip, 0xfff00000, 0x28700000) &&
+		    !rt2x00_check_rev(chip, 0xfff00000, 0x28800000) &&
+		    !rt2x00_check_rev(chip, 0xffff0000, 0x30700000)) {
+			ERROR(rt2x00dev, "Invalid RT chipset detected.\n");
+			return -ENODEV;
+		}
+	} else if (rt2x00_intf_is_pci(rt2x00dev))
+		rt2x00_set_chip_rf(rt2x00dev, value, reg);
+
+	if (!rt2x00_rf(&rt2x00dev->chip, RF2820) &&
+	    !rt2x00_rf(&rt2x00dev->chip, RF2850) &&
+	    !rt2x00_rf(&rt2x00dev->chip, RF2720) &&
+	    !rt2x00_rf(&rt2x00dev->chip, RF2750) &&
+	    !rt2x00_rf(&rt2x00dev->chip, RF3020) &&
+	    !rt2x00_rf(&rt2x00dev->chip, RF2020) &&
+	    (rt2x00_intf_is_usb(rt2x00dev) ||
+	     (rt2x00_intf_is_pci(rt2x00dev) &&
+	      !rt2x00_rf(&rt2x00dev->chip, RF3021) &&
+	      !rt2x00_rf(&rt2x00dev->chip, RF3022)))) {
+		ERROR(rt2x00dev, "Invalid RF chipset detected.\n");
+		return -ENODEV;
+	}
+
+	/*
+	 * Identify default antenna configuration.
+	 */
+	rt2x00dev->default_ant.tx =
+	    rt2x00_get_field16(eeprom, EEPROM_ANTENNA_TXPATH);
+	rt2x00dev->default_ant.rx =
+	    rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RXPATH);
+
+	/*
+	 * Read frequency offset and RF programming sequence.
+	 */
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_FREQ, &eeprom);
+	rt2x00dev->freq_offset = rt2x00_get_field16(eeprom, EEPROM_FREQ_OFFSET);
+
+	/*
+	 * Read external LNA informations.
+	 */
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC, &eeprom);
+
+	if (rt2x00_get_field16(eeprom, EEPROM_NIC_EXTERNAL_LNA_A))
+		__set_bit(CONFIG_EXTERNAL_LNA_A, &rt2x00dev->flags);
+	if (rt2x00_get_field16(eeprom, EEPROM_NIC_EXTERNAL_LNA_BG))
+		__set_bit(CONFIG_EXTERNAL_LNA_BG, &rt2x00dev->flags);
+
+	/*
+	 * Detect if this device has an hardware controlled radio.
+	 */
+	if (rt2x00_get_field16(eeprom, EEPROM_NIC_HW_RADIO))
+		__set_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags);
+
+	/*
+	 * Store led settings, for correct led behaviour.
+	 */
+#ifdef CONFIG_RT2X00_LIB_LEDS
+	rt2800_init_led(rt2x00dev, &rt2x00dev->led_radio, LED_TYPE_RADIO);
+	rt2800_init_led(rt2x00dev, &rt2x00dev->led_assoc, LED_TYPE_ASSOC);
+	rt2800_init_led(rt2x00dev, &rt2x00dev->led_qual, LED_TYPE_QUALITY);
+
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_FREQ, &rt2x00dev->led_mcu_reg);
+#endif /* CONFIG_RT2X00_LIB_LEDS */
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rt2800_init_eeprom);
+
 /*
  * IEEE80211 stack callback functions.
  */
Index: b/drivers/net/wireless/rt2x00/rt2800lib.h
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -129,6 +129,9 @@ int rt2800_init_registers(struct rt2x00_
 int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev);
 int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev);
 
+int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev);
+int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev);
+
 extern const struct ieee80211_ops rt2800_mac80211_ops;
 
 #endif /* RT2800LIB_H */
Index: b/drivers/net/wireless/rt2x00/rt2800pci.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1077,109 +1077,6 @@ static irqreturn_t rt2800pci_interrupt(i
 /*
  * Device probe functions.
  */
-static int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
-{
-	u16 word;
-	u8 *mac;
-	u8 default_lna_gain;
-
-	/*
-	 * Start validation of the data that has been read.
-	 */
-	mac = rt2x00_eeprom_addr(rt2x00dev, EEPROM_MAC_ADDR_0);
-	if (!is_valid_ether_addr(mac)) {
-		random_ether_addr(mac);
-		EEPROM(rt2x00dev, "MAC: %pM\n", mac);
-	}
-
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_ANTENNA, &word);
-	if (word == 0xffff) {
-		rt2x00_set_field16(&word, EEPROM_ANTENNA_RXPATH, 2);
-		rt2x00_set_field16(&word, EEPROM_ANTENNA_TXPATH, 1);
-		rt2x00_set_field16(&word, EEPROM_ANTENNA_RF_TYPE, RF2820);
-		rt2x00_eeprom_write(rt2x00dev, EEPROM_ANTENNA, word);
-		EEPROM(rt2x00dev, "Antenna: 0x%04x\n", word);
-	} else if (rt2x00_rev(&rt2x00dev->chip) < RT2883_VERSION) {
-		/*
-		 * There is a max of 2 RX streams for RT28x0 series
-		 */
-		if (rt2x00_get_field16(word, EEPROM_ANTENNA_RXPATH) > 2)
-			rt2x00_set_field16(&word, EEPROM_ANTENNA_RXPATH, 2);
-		rt2x00_eeprom_write(rt2x00dev, EEPROM_ANTENNA, word);
-	}
-
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC, &word);
-	if (word == 0xffff) {
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
-		rt2x00_eeprom_write(rt2x00dev, EEPROM_NIC, word);
-		EEPROM(rt2x00dev, "NIC: 0x%04x\n", word);
-	}
-
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_FREQ, &word);
-	if ((word & 0x00ff) == 0x00ff) {
-		rt2x00_set_field16(&word, EEPROM_FREQ_OFFSET, 0);
-		rt2x00_set_field16(&word, EEPROM_FREQ_LED_MODE,
-				   LED_MODE_TXRX_ACTIVITY);
-		rt2x00_set_field16(&word, EEPROM_FREQ_LED_POLARITY, 0);
-		rt2x00_eeprom_write(rt2x00dev, EEPROM_FREQ, word);
-		rt2x00_eeprom_write(rt2x00dev, EEPROM_LED1, 0x5555);
-		rt2x00_eeprom_write(rt2x00dev, EEPROM_LED2, 0x2221);
-		rt2x00_eeprom_write(rt2x00dev, EEPROM_LED3, 0xa9f8);
-		EEPROM(rt2x00dev, "Freq: 0x%04x\n", word);
-	}
-
-	/*
-	 * During the LNA validation we are going to use
-	 * lna0 as correct value. Note that EEPROM_LNA
-	 * is never validated.
-	 */
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_LNA, &word);
-	default_lna_gain = rt2x00_get_field16(word, EEPROM_LNA_A0);
-
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_BG, &word);
-	if (abs(rt2x00_get_field16(word, EEPROM_RSSI_BG_OFFSET0)) > 10)
-		rt2x00_set_field16(&word, EEPROM_RSSI_BG_OFFSET0, 0);
-	if (abs(rt2x00_get_field16(word, EEPROM_RSSI_BG_OFFSET1)) > 10)
-		rt2x00_set_field16(&word, EEPROM_RSSI_BG_OFFSET1, 0);
-	rt2x00_eeprom_write(rt2x00dev, EEPROM_RSSI_BG, word);
-
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_BG2, &word);
-	if (abs(rt2x00_get_field16(word, EEPROM_RSSI_BG2_OFFSET2)) > 10)
-		rt2x00_set_field16(&word, EEPROM_RSSI_BG2_OFFSET2, 0);
-	if (rt2x00_get_field16(word, EEPROM_RSSI_BG2_LNA_A1) == 0x00 ||
-	    rt2x00_get_field16(word, EEPROM_RSSI_BG2_LNA_A1) == 0xff)
-		rt2x00_set_field16(&word, EEPROM_RSSI_BG2_LNA_A1,
-				   default_lna_gain);
-	rt2x00_eeprom_write(rt2x00dev, EEPROM_RSSI_BG2, word);
-
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_A, &word);
-	if (abs(rt2x00_get_field16(word, EEPROM_RSSI_A_OFFSET0)) > 10)
-		rt2x00_set_field16(&word, EEPROM_RSSI_A_OFFSET0, 0);
-	if (abs(rt2x00_get_field16(word, EEPROM_RSSI_A_OFFSET1)) > 10)
-		rt2x00_set_field16(&word, EEPROM_RSSI_A_OFFSET1, 0);
-	rt2x00_eeprom_write(rt2x00dev, EEPROM_RSSI_A, word);
-
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_A2, &word);
-	if (abs(rt2x00_get_field16(word, EEPROM_RSSI_A2_OFFSET2)) > 10)
-		rt2x00_set_field16(&word, EEPROM_RSSI_A2_OFFSET2, 0);
-	if (rt2x00_get_field16(word, EEPROM_RSSI_A2_LNA_A2) == 0x00 ||
-	    rt2x00_get_field16(word, EEPROM_RSSI_A2_LNA_A2) == 0xff)
-		rt2x00_set_field16(&word, EEPROM_RSSI_A2_LNA_A2,
-				   default_lna_gain);
-	rt2x00_eeprom_write(rt2x00dev, EEPROM_RSSI_A2, word);
-
-	return 0;
-}
-
 static int rt2800pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 {
 	/*
@@ -1201,84 +1098,6 @@ static int rt2800pci_validate_eeprom(str
 	return rt2800_validate_eeprom(rt2x00dev);
 }
 
-static int rt2800pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
-{
-	u32 reg;
-	u16 value;
-	u16 eeprom;
-
-	/*
-	 * Read EEPROM word for configuration.
-	 */
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_ANTENNA, &eeprom);
-
-	/*
-	 * Identify RF chipset.
-	 */
-	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RF_TYPE);
-	rt2800_register_read(rt2x00dev, MAC_CSR0, &reg);
-
-	if (rt2x00_intf_is_pci(rt2x00dev))
-		rt2x00_set_chip_rf(rt2x00dev, value, reg);
-
-	if (!rt2x00_rf(&rt2x00dev->chip, RF2820) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF2850) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF2720) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF2750) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF3020) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF2020) &&
-	    (rt2x00_intf_is_usb(rt2x00dev) ||
-	     (rt2x00_intf_is_pci(rt2x00dev) &&
-	      !rt2x00_rf(&rt2x00dev->chip, RF3021) &&
-	      !rt2x00_rf(&rt2x00dev->chip, RF3022)))) {
-		ERROR(rt2x00dev, "Invalid RF chipset detected.\n");
-		return -ENODEV;
-	}
-
-	/*
-	 * Identify default antenna configuration.
-	 */
-	rt2x00dev->default_ant.tx =
-	    rt2x00_get_field16(eeprom, EEPROM_ANTENNA_TXPATH);
-	rt2x00dev->default_ant.rx =
-	    rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RXPATH);
-
-	/*
-	 * Read frequency offset and RF programming sequence.
-	 */
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_FREQ, &eeprom);
-	rt2x00dev->freq_offset = rt2x00_get_field16(eeprom, EEPROM_FREQ_OFFSET);
-
-	/*
-	 * Read external LNA informations.
-	 */
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC, &eeprom);
-
-	if (rt2x00_get_field16(eeprom, EEPROM_NIC_EXTERNAL_LNA_A))
-		__set_bit(CONFIG_EXTERNAL_LNA_A, &rt2x00dev->flags);
-	if (rt2x00_get_field16(eeprom, EEPROM_NIC_EXTERNAL_LNA_BG))
-		__set_bit(CONFIG_EXTERNAL_LNA_BG, &rt2x00dev->flags);
-
-	/*
-	 * Detect if this device has an hardware controlled radio.
-	 */
-	if (rt2x00_get_field16(eeprom, EEPROM_NIC_HW_RADIO))
-		__set_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags);
-
-	/*
-	 * Store led settings, for correct led behaviour.
-	 */
-#ifdef CONFIG_RT2X00_LIB_LEDS
-	rt2800_init_led(rt2x00dev, &rt2x00dev->led_radio, LED_TYPE_RADIO);
-	rt2800_init_led(rt2x00dev, &rt2x00dev->led_assoc, LED_TYPE_ASSOC);
-	rt2800_init_led(rt2x00dev, &rt2x00dev->led_qual, LED_TYPE_QUALITY);
-
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_FREQ, &rt2x00dev->led_mcu_reg);
-#endif /* CONFIG_RT2X00_LIB_LEDS */
-
-	return 0;
-}
-
 /*
  * RF value list for rt2860
  * Supports: 2.4 GHz (all) & 5.2 GHz (RF2850 & RF2750)
@@ -1485,7 +1304,7 @@ static int rt2800pci_probe_hw(struct rt2
 	if (retval)
 		return retval;
 
-	retval = rt2800pci_init_eeprom(rt2x00dev);
+	retval = rt2800_init_eeprom(rt2x00dev);
 	if (retval)
 		return retval;
 
Index: b/drivers/net/wireless/rt2x00/rt2800usb.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -665,109 +665,6 @@ static void rt2800usb_fill_rxdone(struct
 /*
  * Device probe functions.
  */
-static int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
-{
-	u16 word;
-	u8 *mac;
-	u8 default_lna_gain;
-
-	/*
-	 * Start validation of the data that has been read.
-	 */
-	mac = rt2x00_eeprom_addr(rt2x00dev, EEPROM_MAC_ADDR_0);
-	if (!is_valid_ether_addr(mac)) {
-		random_ether_addr(mac);
-		EEPROM(rt2x00dev, "MAC: %pM\n", mac);
-	}
-
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_ANTENNA, &word);
-	if (word == 0xffff) {
-		rt2x00_set_field16(&word, EEPROM_ANTENNA_RXPATH, 2);
-		rt2x00_set_field16(&word, EEPROM_ANTENNA_TXPATH, 1);
-		rt2x00_set_field16(&word, EEPROM_ANTENNA_RF_TYPE, RF2820);
-		rt2x00_eeprom_write(rt2x00dev, EEPROM_ANTENNA, word);
-		EEPROM(rt2x00dev, "Antenna: 0x%04x\n", word);
-	} else if (rt2x00_rev(&rt2x00dev->chip) < RT2883_VERSION) {
-		/*
-		 * There is a max of 2 RX streams for RT28x0 series
-		 */
-		if (rt2x00_get_field16(word, EEPROM_ANTENNA_RXPATH) > 2)
-			rt2x00_set_field16(&word, EEPROM_ANTENNA_RXPATH, 2);
-		rt2x00_eeprom_write(rt2x00dev, EEPROM_ANTENNA, word);
-	}
-
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC, &word);
-	if (word == 0xffff) {
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
-		rt2x00_eeprom_write(rt2x00dev, EEPROM_NIC, word);
-		EEPROM(rt2x00dev, "NIC: 0x%04x\n", word);
-	}
-
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_FREQ, &word);
-	if ((word & 0x00ff) == 0x00ff) {
-		rt2x00_set_field16(&word, EEPROM_FREQ_OFFSET, 0);
-		rt2x00_set_field16(&word, EEPROM_FREQ_LED_MODE,
-				   LED_MODE_TXRX_ACTIVITY);
-		rt2x00_set_field16(&word, EEPROM_FREQ_LED_POLARITY, 0);
-		rt2x00_eeprom_write(rt2x00dev, EEPROM_FREQ, word);
-		rt2x00_eeprom_write(rt2x00dev, EEPROM_LED1, 0x5555);
-		rt2x00_eeprom_write(rt2x00dev, EEPROM_LED2, 0x2221);
-		rt2x00_eeprom_write(rt2x00dev, EEPROM_LED3, 0xa9f8);
-		EEPROM(rt2x00dev, "Freq: 0x%04x\n", word);
-	}
-
-	/*
-	 * During the LNA validation we are going to use
-	 * lna0 as correct value. Note that EEPROM_LNA
-	 * is never validated.
-	 */
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_LNA, &word);
-	default_lna_gain = rt2x00_get_field16(word, EEPROM_LNA_A0);
-
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_BG, &word);
-	if (abs(rt2x00_get_field16(word, EEPROM_RSSI_BG_OFFSET0)) > 10)
-		rt2x00_set_field16(&word, EEPROM_RSSI_BG_OFFSET0, 0);
-	if (abs(rt2x00_get_field16(word, EEPROM_RSSI_BG_OFFSET1)) > 10)
-		rt2x00_set_field16(&word, EEPROM_RSSI_BG_OFFSET1, 0);
-	rt2x00_eeprom_write(rt2x00dev, EEPROM_RSSI_BG, word);
-
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_BG2, &word);
-	if (abs(rt2x00_get_field16(word, EEPROM_RSSI_BG2_OFFSET2)) > 10)
-		rt2x00_set_field16(&word, EEPROM_RSSI_BG2_OFFSET2, 0);
-	if (rt2x00_get_field16(word, EEPROM_RSSI_BG2_LNA_A1) == 0x00 ||
-	    rt2x00_get_field16(word, EEPROM_RSSI_BG2_LNA_A1) == 0xff)
-		rt2x00_set_field16(&word, EEPROM_RSSI_BG2_LNA_A1,
-				   default_lna_gain);
-	rt2x00_eeprom_write(rt2x00dev, EEPROM_RSSI_BG2, word);
-
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_A, &word);
-	if (abs(rt2x00_get_field16(word, EEPROM_RSSI_A_OFFSET0)) > 10)
-		rt2x00_set_field16(&word, EEPROM_RSSI_A_OFFSET0, 0);
-	if (abs(rt2x00_get_field16(word, EEPROM_RSSI_A_OFFSET1)) > 10)
-		rt2x00_set_field16(&word, EEPROM_RSSI_A_OFFSET1, 0);
-	rt2x00_eeprom_write(rt2x00dev, EEPROM_RSSI_A, word);
-
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_A2, &word);
-	if (abs(rt2x00_get_field16(word, EEPROM_RSSI_A2_OFFSET2)) > 10)
-		rt2x00_set_field16(&word, EEPROM_RSSI_A2_OFFSET2, 0);
-	if (rt2x00_get_field16(word, EEPROM_RSSI_A2_LNA_A2) == 0x00 ||
-	    rt2x00_get_field16(word, EEPROM_RSSI_A2_LNA_A2) == 0xff)
-		rt2x00_set_field16(&word, EEPROM_RSSI_A2_LNA_A2,
-				   default_lna_gain);
-	rt2x00_eeprom_write(rt2x00dev, EEPROM_RSSI_A2, word);
-
-	return 0;
-}
-
 static int rt2800usb_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 {
 	rt2x00usb_eeprom_read(rt2x00dev, rt2x00dev->eeprom, EEPROM_SIZE);
@@ -775,96 +672,6 @@ static int rt2800usb_validate_eeprom(str
 	return rt2800_validate_eeprom(rt2x00dev);
 }
 
-static int rt2800usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
-{
-	u32 reg;
-	u16 value;
-	u16 eeprom;
-
-	/*
-	 * Read EEPROM word for configuration.
-	 */
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_ANTENNA, &eeprom);
-
-	/*
-	 * Identify RF chipset.
-	 */
-	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RF_TYPE);
-	rt2800_register_read(rt2x00dev, MAC_CSR0, &reg);
-
-	if (rt2x00_intf_is_usb(rt2x00dev)) {
-		struct rt2x00_chip *chip = &rt2x00dev->chip;
-
-		rt2x00_set_chip(rt2x00dev, RT2870, value, reg);
-
-		/*
-		 * The check for rt2860 is not a typo, some rt2870 hardware
-		 * identifies itself as rt2860 in the CSR register.
-		 */
-		if (!rt2x00_check_rev(chip, 0xfff00000, 0x28600000) &&
-		    !rt2x00_check_rev(chip, 0xfff00000, 0x28700000) &&
-		    !rt2x00_check_rev(chip, 0xfff00000, 0x28800000) &&
-		    !rt2x00_check_rev(chip, 0xffff0000, 0x30700000)) {
-			ERROR(rt2x00dev, "Invalid RT chipset detected.\n");
-			return -ENODEV;
-		}
-	}
-
-	if (!rt2x00_rf(&rt2x00dev->chip, RF2820) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF2850) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF2720) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF2750) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF3020) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF2020)) {
-		ERROR(rt2x00dev, "Invalid RF chipset detected.\n");
-		return -ENODEV;
-	}
-
-	/*
-	 * Identify default antenna configuration.
-	 */
-	rt2x00dev->default_ant.tx =
-	    rt2x00_get_field16(eeprom, EEPROM_ANTENNA_TXPATH);
-	rt2x00dev->default_ant.rx =
-	    rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RXPATH);
-
-	/*
-	 * Read frequency offset and RF programming sequence.
-	 */
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_FREQ, &eeprom);
-	rt2x00dev->freq_offset = rt2x00_get_field16(eeprom, EEPROM_FREQ_OFFSET);
-
-	/*
-	 * Read external LNA informations.
-	 */
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC, &eeprom);
-
-	if (rt2x00_get_field16(eeprom, EEPROM_NIC_EXTERNAL_LNA_A))
-		__set_bit(CONFIG_EXTERNAL_LNA_A, &rt2x00dev->flags);
-	if (rt2x00_get_field16(eeprom, EEPROM_NIC_EXTERNAL_LNA_BG))
-		__set_bit(CONFIG_EXTERNAL_LNA_BG, &rt2x00dev->flags);
-
-	/*
-	 * Detect if this device has an hardware controlled radio.
-	 */
-	if (rt2x00_get_field16(eeprom, EEPROM_NIC_HW_RADIO))
-		__set_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags);
-
-	/*
-	 * Store led settings, for correct led behaviour.
-	 */
-#ifdef CONFIG_RT2X00_LIB_LEDS
-	rt2800_init_led(rt2x00dev, &rt2x00dev->led_radio, LED_TYPE_RADIO);
-	rt2800_init_led(rt2x00dev, &rt2x00dev->led_assoc, LED_TYPE_ASSOC);
-	rt2800_init_led(rt2x00dev, &rt2x00dev->led_qual, LED_TYPE_QUALITY);
-
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_FREQ,
-			   &rt2x00dev->led_mcu_reg);
-#endif /* CONFIG_RT2X00_LIB_LEDS */
-
-	return 0;
-}
-
 /*
  * RF value list for rt2870
  * Supports: 2.4 GHz (all) & 5.2 GHz (RF2850 & RF2750)
@@ -1095,7 +902,7 @@ static int rt2800usb_probe_hw(struct rt2
 	if (retval)
 		return retval;
 
-	retval = rt2800usb_init_eeprom(rt2x00dev);
+	retval = rt2800_init_eeprom(rt2x00dev);
 	if (retval)
 		return retval;
 
