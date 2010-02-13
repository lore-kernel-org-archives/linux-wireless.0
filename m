Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:61080 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757944Ab0BMT4I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Feb 2010 14:56:08 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 3/3] rt2x00: rework RT chipset and revision determination for PCI an SOC devices.
Date: Sat, 13 Feb 2010 20:55:49 +0100
Message-Id: <1266090949-5468-4-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1266090949-5468-3-git-send-email-gwingerde@gmail.com>
References: <1266090949-5468-1-git-send-email-gwingerde@gmail.com>
 <1266090949-5468-2-git-send-email-gwingerde@gmail.com>
 <1266090949-5468-3-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The recent rt2800 devices are no longer really identified by their PCI
ID's, but rather by the contents of their CSR0 register. Also for the
other chipsets is the contents of this CSR0 register important.
Change the chipset determination logic to be more aligned with the rt2800
model.
Preparation for the support of rt3070 / rt3090 based devices.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c   |    9 +--
 drivers/net/wireless/rt2x00/rt2400pci.h   |    1 +
 drivers/net/wireless/rt2x00/rt2500pci.c   |    9 +--
 drivers/net/wireless/rt2x00/rt2500pci.h   |    1 +
 drivers/net/wireless/rt2x00/rt2500usb.c   |    3 +-
 drivers/net/wireless/rt2x00/rt2800.h      |   14 ++--
 drivers/net/wireless/rt2x00/rt2800lib.c   |   92 +++++++++++++++--------------
 drivers/net/wireless/rt2x00/rt2800usb.c   |   20 +++----
 drivers/net/wireless/rt2x00/rt2x00.h      |   41 ++++++-------
 drivers/net/wireless/rt2x00/rt2x00debug.c |    4 +-
 drivers/net/wireless/rt2x00/rt61pci.c     |   19 +++----
 drivers/net/wireless/rt2x00/rt61pci.h     |    9 +++
 drivers/net/wireless/rt2x00/rt73usb.c     |    6 +-
 drivers/net/wireless/rt2x00/rt73usb.h     |    2 +
 14 files changed, 112 insertions(+), 118 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 9207b9b..676814d 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1327,7 +1327,6 @@ static int rt2400pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 static int rt2400pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
-	u16 chip;
 	u16 value;
 	u16 eeprom;
 
@@ -1337,16 +1336,12 @@ static int rt2400pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_ANTENNA, &eeprom);
 
 	/*
-	 * Identify RT chipset.
-	 */
-	pci_read_config_word(to_pci_dev(rt2x00dev->dev), PCI_DEVICE_ID, &chip);
-
-	/*
 	 * Identify RF chipset.
 	 */
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RF_TYPE);
 	rt2x00pci_register_read(rt2x00dev, CSR0, &reg);
-	rt2x00_set_chip(rt2x00dev, chip, value, reg);
+	rt2x00_set_chip(rt2x00dev, RT2460, value,
+			rt2x00_get_field32(reg, CSR0_REVISION));
 
 	if (!rt2x00_rf(rt2x00dev, RF2420) && !rt2x00_rf(rt2x00dev, RF2421)) {
 		ERROR(rt2x00dev, "Invalid RF chipset detected.\n");
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.h b/drivers/net/wireless/rt2x00/rt2400pci.h
index 6c21ef6..6061377 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.h
+++ b/drivers/net/wireless/rt2x00/rt2400pci.h
@@ -65,6 +65,7 @@
  * CSR0: ASIC revision number.
  */
 #define CSR0				0x0000
+#define CSR0_REVISION			FIELD32(0x0000ffff)
 
 /*
  * CSR1: System control register.
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 0f6d001..c712661 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1490,7 +1490,6 @@ static int rt2500pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 static int rt2500pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
-	u16 chip;
 	u16 value;
 	u16 eeprom;
 
@@ -1500,16 +1499,12 @@ static int rt2500pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_ANTENNA, &eeprom);
 
 	/*
-	 * Identify RT chipset.
-	 */
-	pci_read_config_word(to_pci_dev(rt2x00dev->dev), PCI_DEVICE_ID, &chip);
-
-	/*
 	 * Identify RF chipset.
 	 */
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RF_TYPE);
 	rt2x00pci_register_read(rt2x00dev, CSR0, &reg);
-	rt2x00_set_chip(rt2x00dev, chip, value, reg);
+	rt2x00_set_chip(rt2x00dev, RT2560, value,
+			rt2x00_get_field32(reg, CSR0_REVISION));
 
 	if (!rt2x00_rf(rt2x00dev, RF2522) &&
 	    !rt2x00_rf(rt2x00dev, RF2523) &&
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.h b/drivers/net/wireless/rt2x00/rt2500pci.h
index b007567..6471f8e 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.h
+++ b/drivers/net/wireless/rt2x00/rt2500pci.h
@@ -76,6 +76,7 @@
  * CSR0: ASIC revision number.
  */
 #define CSR0				0x0000
+#define CSR0_REVISION			FIELD32(0x0000ffff)
 
 /*
  * CSR1: System control register.
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 99b7cb8..ee34c13 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1409,8 +1409,7 @@ static int rt2500usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2500usb_register_read(rt2x00dev, MAC_CSR0, &reg);
 	rt2x00_set_chip(rt2x00dev, RT2570, value, reg);
 
-	if (!rt2x00_check_rev(rt2x00dev, 0x000ffff0, 0) ||
-	    rt2x00_check_rev(rt2x00dev, 0x0000000f, 0)) {
+	if (((reg & 0xfff0) != 0) || ((reg & 0x0000000f) == 0)) {
 		ERROR(rt2x00dev, "Invalid RT chipset detected.\n");
 		return -ENODEV;
 	}
diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 1a7eae3..74c0433 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -60,11 +60,11 @@
 /*
  * Chipset version.
  */
-#define RT2860C_VERSION			0x28600100
-#define RT2860D_VERSION			0x28600101
-#define RT2880E_VERSION			0x28720200
-#define RT2883_VERSION			0x28830300
-#define RT3070_VERSION			0x30700200
+#define RT2860C_VERSION			0x0100
+#define RT2860D_VERSION			0x0101
+#define RT2880E_VERSION			0x0200
+#define RT2883_VERSION			0x0300
+#define RT3070_VERSION			0x0200
 
 /*
  * Signal information.
@@ -408,8 +408,8 @@
  * ASIC_VER: 2860 or 2870
  */
 #define MAC_CSR0			0x1000
-#define MAC_CSR0_ASIC_REV		FIELD32(0x0000ffff)
-#define MAC_CSR0_ASIC_VER		FIELD32(0xffff0000)
+#define MAC_CSR0_REVISION		FIELD32(0x0000ffff)
+#define MAC_CSR0_CHIPSET		FIELD32(0xffff0000)
 
 /*
  * MAC_SYS_CTRL:
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 7340e48..18d4d8e 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -898,7 +898,8 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field8(&bbp, BBP3_HT40_PLUS, conf_is_ht40_plus(conf));
 	rt2800_bbp_write(rt2x00dev, 3, bbp);
 
-	if (rt2x00_rev(rt2x00dev) == RT2860C_VERSION) {
+	if (rt2x00_rt(rt2x00dev, RT2860) &&
+	    (rt2x00_rev(rt2x00dev) == RT2860C_VERSION)) {
 		if (conf_is_ht40(conf)) {
 			rt2800_bbp_write(rt2x00dev, 69, 0x1a);
 			rt2800_bbp_write(rt2x00dev, 70, 0x0a);
@@ -1061,7 +1062,8 @@ static u8 rt2800_get_default_vgc(struct rt2x00_dev *rt2x00dev)
 {
 	if (rt2x00dev->curr_band == IEEE80211_BAND_2GHZ) {
 		if (rt2x00_is_usb(rt2x00dev) &&
-		    rt2x00_rev(rt2x00dev) == RT3070_VERSION)
+		    rt2x00_rt(rt2x00dev, RT3070) &&
+		    (rt2x00_rev(rt2x00dev) == RT3070_VERSION))
 			return 0x1c + (2 * rt2x00dev->lna_gain);
 		else
 			return 0x2e + rt2x00dev->lna_gain;
@@ -1092,7 +1094,8 @@ EXPORT_SYMBOL_GPL(rt2800_reset_tuner);
 void rt2800_link_tuner(struct rt2x00_dev *rt2x00dev, struct link_qual *qual,
 		       const u32 count)
 {
-	if (rt2x00_rev(rt2x00dev) == RT2860C_VERSION)
+	if (rt2x00_rt(rt2x00dev, RT2860) &&
+	    (rt2x00_rev(rt2x00dev) == RT2860C_VERSION))
 		return;
 
 	/*
@@ -1178,7 +1181,8 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
 
 	if (rt2x00_is_usb(rt2x00dev) &&
-	    rt2x00_rev(rt2x00dev) == RT3070_VERSION) {
+	    rt2x00_rt(rt2x00dev, RT3070) &&
+	    (rt2x00_rev(rt2x00dev) == RT3070_VERSION)) {
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000400);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00000000);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
@@ -1205,8 +1209,14 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_register_read(rt2x00dev, MAX_LEN_CFG, &reg);
 	rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_MPDU, AGGREGATION_SIZE);
-	if (rt2x00_rev(rt2x00dev) >= RT2880E_VERSION &&
-	    rt2x00_rev(rt2x00dev) < RT3070_VERSION)
+	if ((rt2x00_rt(rt2x00dev, RT2872) &&
+	     (rt2x00_rev(rt2x00dev) >= RT2880E_VERSION)) ||
+	    rt2x00_rt(rt2x00dev, RT2880) ||
+	    rt2x00_rt(rt2x00dev, RT2883) ||
+	    rt2x00_rt(rt2x00dev, RT2890) ||
+	    rt2x00_rt(rt2x00dev, RT3052) ||
+	    (rt2x00_rt(rt2x00dev, RT3070) &&
+	     (rt2x00_rev(rt2x00dev) < RT3070_VERSION)))
 		rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_PSDU, 2);
 	else
 		rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_PSDU, 1);
@@ -1485,16 +1495,19 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 103, 0x00);
 	rt2800_bbp_write(rt2x00dev, 105, 0x05);
 
-	if (rt2x00_rev(rt2x00dev) == RT2860C_VERSION) {
+	if (rt2x00_rt(rt2x00dev, RT2860) &&
+	    (rt2x00_rev(rt2x00dev) == RT2860C_VERSION)) {
 		rt2800_bbp_write(rt2x00dev, 69, 0x16);
 		rt2800_bbp_write(rt2x00dev, 73, 0x12);
 	}
 
-	if (rt2x00_rev(rt2x00dev) > RT2860D_VERSION)
+	if (rt2x00_rt(rt2x00dev, RT2860) &&
+	    (rt2x00_rev(rt2x00dev) > RT2860D_VERSION))
 		rt2800_bbp_write(rt2x00dev, 84, 0x19);
 
 	if (rt2x00_is_usb(rt2x00dev) &&
-	    rt2x00_rev(rt2x00dev) == RT3070_VERSION) {
+	    rt2x00_rt(rt2x00dev, RT3070) &&
+	    (rt2x00_rev(rt2x00dev) == RT3070_VERSION)) {
 		rt2800_bbp_write(rt2x00dev, 70, 0x0a);
 		rt2800_bbp_write(rt2x00dev, 84, 0x99);
 		rt2800_bbp_write(rt2x00dev, 105, 0x05);
@@ -1586,7 +1599,8 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	u8 bbp;
 
 	if (rt2x00_is_usb(rt2x00dev) &&
-	    rt2x00_rev(rt2x00dev) != RT3070_VERSION)
+	    rt2x00_rt(rt2x00dev, RT3070) &&
+	    (rt2x00_rev(rt2x00dev) != RT3070_VERSION))
 		return 0;
 
 	if (rt2x00_is_pci(rt2x00dev) || rt2x00_is_soc(rt2x00dev)) {
@@ -1757,7 +1771,12 @@ int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 		rt2x00_set_field16(&word, EEPROM_ANTENNA_RF_TYPE, RF2820);
 		rt2x00_eeprom_write(rt2x00dev, EEPROM_ANTENNA, word);
 		EEPROM(rt2x00dev, "Antenna: 0x%04x\n", word);
-	} else if (rt2x00_rev(rt2x00dev) < RT2883_VERSION) {
+	} else if (rt2x00_rt(rt2x00dev, RT2860) ||
+		   rt2x00_rt(rt2x00dev, RT2870) ||
+		   rt2x00_rt(rt2x00dev, RT2872) ||
+		   rt2x00_rt(rt2x00dev, RT2880) ||
+		   (rt2x00_rt(rt2x00dev, RT2883) &&
+		    (rt2x00_rev(rt2x00dev) < RT2883_VERSION))) {
 		/*
 		 * There is a max of 2 RX streams for RT28x0 series
 		 */
@@ -1842,7 +1861,6 @@ EXPORT_SYMBOL_GPL(rt2800_validate_eeprom);
 int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
-	u16 chip;
 	u16 value;
 	u16 eeprom;
 
@@ -1857,41 +1875,25 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RF_TYPE);
 	rt2800_register_read(rt2x00dev, MAC_CSR0, &reg);
 
-	if (rt2x00_is_pci(rt2x00dev)) {
-#if defined(CONFIG_RT2X00_LIB_PCI) || defined(CONFIG_RT2X00_LIB_PCI_MODULE)
-		pci_read_config_word(to_pci_dev(rt2x00dev->dev),
-				     PCI_DEVICE_ID,
-				     &chip);
-#else
-		BUG();
-#endif
-	} else if (rt2x00_is_usb(rt2x00dev)) {
-		/*
-		 * The check for rt2860 is not a typo, some rt2870 hardware
-		 * identifies itself as rt2860 in the CSR register.
-		 */
-		if (((reg & 0xfff00000) == 0x28600000) ||
-		    ((reg & 0xfff00000) == 0x28700000) ||
-		    ((reg & 0xfff00000) == 0x28800000)) {
-			chip = RT2870;
-		} else if ((reg & 0xffff0000) == 0x30700000) {
-			chip = RT3070;
-		} else {
-			ERROR(rt2x00dev, "Invalid RT chipset detected.\n");
-			return -ENODEV;
-		}
-	} else if (rt2x00_is_soc(rt2x00dev)) {
-#if defined(CONFIG_RALINK_RT288X)
-		chip = RT2880;
-#elif defined(CONFIG_RALINK_RT305X)
-		chip = RT3052;
-#else
-		BUG();
-#endif
+	rt2x00_set_chip(rt2x00dev, rt2x00_get_field32(reg, MAC_CSR0_CHIPSET),
+			value, rt2x00_get_field32(reg, MAC_CSR0_REVISION));
+
+	if (!rt2x00_rt(rt2x00dev, RT2860) &&
+	    !rt2x00_rt(rt2x00dev, RT2870) &&
+	    !rt2x00_rt(rt2x00dev, RT2872) &&
+	    !rt2x00_rt(rt2x00dev, RT2880) &&
+	    !rt2x00_rt(rt2x00dev, RT2883) &&
+	    !rt2x00_rt(rt2x00dev, RT2890) &&
+	    !rt2x00_rt(rt2x00dev, RT3052) &&
+	    !rt2x00_rt(rt2x00dev, RT3070) &&
+	    !rt2x00_rt(rt2x00dev, RT3071) &&
+	    !rt2x00_rt(rt2x00dev, RT3090) &&
+	    !rt2x00_rt(rt2x00dev, RT3390) &&
+	    !rt2x00_rt(rt2x00dev, RT3572)) {
+		ERROR(rt2x00dev, "Invalid RT chipset detected.\n");
+		return -ENODEV;
 	}
 
-	rt2x00_set_chip(rt2x00dev, chip, value, reg);
-
 	if (!rt2x00_rf(rt2x00dev, RF2820) &&
 	    !rt2x00_rf(rt2x00dev, RF2850) &&
 	    !rt2x00_rf(rt2x00dev, RF2720) &&
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 82755cf..79ea379 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -92,7 +92,6 @@ static bool rt2800usb_check_crc(const u8 *data, const size_t len)
 static int rt2800usb_check_firmware(struct rt2x00_dev *rt2x00dev,
 				    const u8 *data, const size_t len)
 {
-	u16 chipset = (rt2x00_rev(rt2x00dev) >> 16) & 0xffff;
 	size_t offset = 0;
 
 	/*
@@ -111,9 +110,9 @@ static int rt2800usb_check_firmware(struct rt2x00_dev *rt2x00dev,
 	 * Check if we need the upper 4kb firmware data or not.
 	 */
 	if ((len == 4096) &&
-	    (chipset != 0x2860) &&
-	    (chipset != 0x2872) &&
-	    (chipset != 0x3070))
+	    !rt2x00_rt(rt2x00dev, RT2860) &&
+	    !rt2x00_rt(rt2x00dev, RT2872) &&
+	    !rt2x00_rt(rt2x00dev, RT3070))
 		return FW_BAD_VERSION;
 
 	/*
@@ -138,14 +137,13 @@ static int rt2800usb_load_firmware(struct rt2x00_dev *rt2x00dev,
 	u32 reg;
 	u32 offset;
 	u32 length;
-	u16 chipset = (rt2x00_rev(rt2x00dev) >> 16) & 0xffff;
 
 	/*
 	 * Check which section of the firmware we need.
 	 */
-	if ((chipset == 0x2860) ||
-	    (chipset == 0x2872) ||
-	    (chipset == 0x3070)) {
+	if (rt2x00_rt(rt2x00dev, RT2860) ||
+	    rt2x00_rt(rt2x00dev, RT2872) ||
+	    rt2x00_rt(rt2x00dev, RT3070)) {
 		offset = 0;
 		length = 4096;
 	} else {
@@ -200,9 +198,9 @@ static int rt2800usb_load_firmware(struct rt2x00_dev *rt2x00dev,
 	 */
 	rt2800_mcu_request(rt2x00dev, MCU_BOOT_SIGNAL, 0xff, 0, 0);
 
-	if ((chipset == 0x3070) ||
-	    (chipset == 0x3071) ||
-	    (chipset == 0x3572)) {
+	if (rt2x00_rt(rt2x00dev, RT3070) ||
+	    rt2x00_rt(rt2x00dev, RT3071) ||
+	    rt2x00_rt(rt2x00dev, RT3572)) {
 		udelay(200);
 		rt2800_mcu_request(rt2x00dev, MCU_CURRENT, 0, 0, 0);
 		udelay(10);
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 1fed90a..d9daa9c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -170,25 +170,26 @@ enum rt2x00_chip_intf {
  */
 struct rt2x00_chip {
 	u16 rt;
-#define RT2460		0x0101
-#define RT2560		0x0201
-#define RT2570		0x1201
-#define RT2561s		0x0301	/* Turbo */
-#define RT2561		0x0302
-#define RT2661		0x0401
-#define RT2571		0x1300
-#define RT2860		0x0601	/* 2.4GHz PCI/CB */
-#define RT2860D		0x0681	/* 2.4GHz, 5GHz PCI/CB */
-#define RT2890		0x0701	/* 2.4GHz PCIe */
-#define RT2890D		0x0781	/* 2.4GHz, 5GHz PCIe */
+#define RT2460		0x2460
+#define RT2560		0x2560
+#define RT2570		0x2570
+#define RT2661		0x2661
+#define RT2573		0x2573
+#define RT2860		0x2860	/* 2.4GHz PCI/CB */
+#define RT2870		0x2870
+#define RT2872		0x2872
 #define RT2880		0x2880	/* WSOC */
+#define RT2883		0x2883	/* WSOC */
+#define RT2890		0x2890	/* 2.4GHz PCIe */
 #define RT3052		0x3052	/* WSOC */
+#define RT3070		0x3070
+#define RT3071		0x3071
 #define RT3090		0x3090	/* 2.4GHz PCIe */
-#define RT2870		0x1600
-#define RT3070		0x1800
+#define RT3390		0x3390
+#define RT3572		0x3572
 
 	u16 rf;
-	u32 rev;
+	u16 rev;
 
 	enum rt2x00_chip_intf intf;
 };
@@ -918,14 +919,14 @@ static inline void rt2x00_eeprom_write(struct rt2x00_dev *rt2x00dev,
  * Chipset handlers
  */
 static inline void rt2x00_set_chip(struct rt2x00_dev *rt2x00dev,
-				   const u16 rt, const u16 rf, const u32 rev)
+				   const u16 rt, const u16 rf, const u16 rev)
 {
 	rt2x00dev->chip.rt = rt;
 	rt2x00dev->chip.rf = rf;
 	rt2x00dev->chip.rev = rev;
 
 	INFO(rt2x00dev,
-	     "Chipset detected - rt: %04x, rf: %04x, rev: %08x.\n",
+	     "Chipset detected - rt: %04x, rf: %04x, rev: %04x.\n",
 	     rt2x00dev->chip.rt, rt2x00dev->chip.rf, rt2x00dev->chip.rev);
 }
 
@@ -939,17 +940,11 @@ static inline char rt2x00_rf(struct rt2x00_dev *rt2x00dev, const u16 rf)
 	return (rt2x00dev->chip.rf == rf);
 }
 
-static inline u32 rt2x00_rev(struct rt2x00_dev *rt2x00dev)
+static inline u16 rt2x00_rev(struct rt2x00_dev *rt2x00dev)
 {
 	return rt2x00dev->chip.rev;
 }
 
-static inline bool rt2x00_check_rev(struct rt2x00_dev *rt2x00dev,
-				    const u32 mask, const u32 rev)
-{
-	return ((rt2x00dev->chip.rev & mask) == rev);
-}
-
 static inline void rt2x00_set_chip_intf(struct rt2x00_dev *rt2x00dev,
 					enum rt2x00_chip_intf intf)
 {
diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index 7d323a7..70c04c2 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -184,7 +184,7 @@ void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
 	dump_hdr->data_length = cpu_to_le32(skb->len);
 	dump_hdr->chip_rt = cpu_to_le16(rt2x00dev->chip.rt);
 	dump_hdr->chip_rf = cpu_to_le16(rt2x00dev->chip.rf);
-	dump_hdr->chip_rev = cpu_to_le32(rt2x00dev->chip.rev);
+	dump_hdr->chip_rev = cpu_to_le16(rt2x00dev->chip.rev);
 	dump_hdr->type = cpu_to_le16(type);
 	dump_hdr->queue_index = desc->entry->queue->qid;
 	dump_hdr->entry_index = desc->entry->entry_idx;
@@ -573,7 +573,7 @@ static struct dentry *rt2x00debug_create_file_chipset(const char *name,
 	blob->data = data;
 	data += sprintf(data, "rt chip:\t%04x\n", intf->rt2x00dev->chip.rt);
 	data += sprintf(data, "rf chip:\t%04x\n", intf->rt2x00dev->chip.rf);
-	data += sprintf(data, "revision:\t%08x\n", intf->rt2x00dev->chip.rev);
+	data += sprintf(data, "revision:\t%04x\n", intf->rt2x00dev->chip.rev);
 	data += sprintf(data, "\n");
 	data += sprintf(data, "register\tbase\twords\twordsize\n");
 	data += sprintf(data, "csr\t%d\t%d\t%d\n",
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 4ca1d48..ee9c696 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1131,16 +1131,18 @@ dynamic_cca_tune:
  */
 static char *rt61pci_get_firmware_name(struct rt2x00_dev *rt2x00dev)
 {
+	u16 chip;
 	char *fw_name;
 
-	switch (rt2x00dev->chip.rt) {
-	case RT2561:
+	pci_read_config_word(to_pci_dev(rt2x00dev->dev), PCI_DEVICE_ID, &chip);
+	switch (chip) {
+	case RT2561_PCI_ID:
 		fw_name = FIRMWARE_RT2561;
 		break;
-	case RT2561s:
+	case RT2561s_PCI_ID:
 		fw_name = FIRMWARE_RT2561s;
 		break;
-	case RT2661:
+	case RT2661_PCI_ID:
 		fw_name = FIRMWARE_RT2661;
 		break;
 	default:
@@ -2282,7 +2284,6 @@ static int rt61pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 static int rt61pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
-	u16 chip;
 	u16 value;
 	u16 eeprom;
 
@@ -2292,16 +2293,12 @@ static int rt61pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_ANTENNA, &eeprom);
 
 	/*
-	 * Identify RT chipset.
-	 */
-	pci_read_config_word(to_pci_dev(rt2x00dev->dev), PCI_DEVICE_ID, &chip);
-
-	/*
 	 * Identify RF chipset.
 	 */
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RF_TYPE);
 	rt2x00pci_register_read(rt2x00dev, MAC_CSR0, &reg);
-	rt2x00_set_chip(rt2x00dev, chip, value, reg);
+	rt2x00_set_chip(rt2x00dev, rt2x00_get_field32(reg, MAC_CSR0_CHIPSET),
+			value, rt2x00_get_field32(reg, MAC_CSR0_REVISION));
 
 	if (!rt2x00_rf(rt2x00dev, RF5225) &&
 	    !rt2x00_rf(rt2x00dev, RF5325) &&
diff --git a/drivers/net/wireless/rt2x00/rt61pci.h b/drivers/net/wireless/rt2x00/rt61pci.h
index 6f33f7f..ab20c77 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/rt2x00/rt61pci.h
@@ -28,6 +28,13 @@
 #define RT61PCI_H
 
 /*
+ * RT chip PCI IDs.
+ */
+#define RT2561s_PCI_ID			0x0301
+#define RT2561_PCI_ID			0x0302
+#define RT2661_PCI_ID			0x0401
+
+/*
  * RF chip defines.
  */
 #define RF5225				0x0001
@@ -225,6 +232,8 @@ struct hw_pairwise_ta_entry {
  * MAC_CSR0: ASIC revision number.
  */
 #define MAC_CSR0			0x3000
+#define MAC_CSR0_REVISION		FIELD32(0x0000000f)
+#define MAC_CSR0_CHIPSET		FIELD32(0x000ffff0)
 
 /*
  * MAC_CSR1: System control register.
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 2950ac7..f39a8ed 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1820,10 +1820,10 @@ static int rt73usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	 */
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RF_TYPE);
 	rt2x00usb_register_read(rt2x00dev, MAC_CSR0, &reg);
-	rt2x00_set_chip(rt2x00dev, RT2571, value, reg);
+	rt2x00_set_chip(rt2x00dev, rt2x00_get_field32(reg, MAC_CSR0_CHIPSET),
+			value, rt2x00_get_field32(reg, MAC_CSR0_REVISION));
 
-	if (!rt2x00_check_rev(rt2x00dev, 0x000ffff0, 0x25730) ||
-	    rt2x00_check_rev(rt2x00dev, 0x0000000f, 0)) {
+	if (!rt2x00_rt(rt2x00dev, RT2573) || (rt2x00_rev(rt2x00dev) == 0)) {
 		ERROR(rt2x00dev, "Invalid RT chipset detected.\n");
 		return -ENODEV;
 	}
diff --git a/drivers/net/wireless/rt2x00/rt73usb.h b/drivers/net/wireless/rt2x00/rt73usb.h
index e783a09..b4e3ddd 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.h
+++ b/drivers/net/wireless/rt2x00/rt73usb.h
@@ -142,6 +142,8 @@ struct hw_pairwise_ta_entry {
  * MAC_CSR0: ASIC revision number.
  */
 #define MAC_CSR0			0x3000
+#define MAC_CSR0_REVISION		FIELD32(0x0000000f)
+#define MAC_CSR0_CHIPSET		FIELD32(0x000ffff0)
 
 /*
  * MAC_CSR1: System control register.
-- 
1.6.6.1

