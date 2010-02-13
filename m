Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:63397 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757930Ab0BMT4H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Feb 2010 14:56:07 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 1/3] rt2x00: Introduce SoC interface type.
Date: Sat, 13 Feb 2010 20:55:47 +0100
Message-Id: <1266090949-5468-2-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1266090949-5468-1-git-send-email-gwingerde@gmail.com>
References: <1266090949-5468-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce the SoC interface type to detect SoC devices, instead of having
them mimic being PCI devices.
This allows for easier detection of SoC devices.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   38 +++++++++++++++---------------
 drivers/net/wireless/rt2x00/rt2800pci.c |   18 +++++---------
 drivers/net/wireless/rt2x00/rt2x00.h    |   10 ++++++-
 drivers/net/wireless/rt2x00/rt2x00soc.c |    6 +----
 4 files changed, 34 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index a45e027..e78df53 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -89,7 +89,7 @@ static void rt2800_bbp_write(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field32(&reg, BBP_CSR_CFG_REGNUM, word);
 		rt2x00_set_field32(&reg, BBP_CSR_CFG_BUSY, 1);
 		rt2x00_set_field32(&reg, BBP_CSR_CFG_READ_CONTROL, 0);
-		if (rt2x00_intf_is_pci(rt2x00dev))
+		if (rt2x00_is_pci(rt2x00dev) || rt2x00_is_soc(rt2x00dev))
 			rt2x00_set_field32(&reg, BBP_CSR_CFG_BBP_RW_MODE, 1);
 
 		rt2800_register_write_lock(rt2x00dev, BBP_CSR_CFG, reg);
@@ -118,7 +118,7 @@ static void rt2800_bbp_read(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field32(&reg, BBP_CSR_CFG_REGNUM, word);
 		rt2x00_set_field32(&reg, BBP_CSR_CFG_BUSY, 1);
 		rt2x00_set_field32(&reg, BBP_CSR_CFG_READ_CONTROL, 1);
-		if (rt2x00_intf_is_pci(rt2x00dev))
+		if (rt2x00_is_pci(rt2x00dev) || rt2x00_is_soc(rt2x00dev))
 			rt2x00_set_field32(&reg, BBP_CSR_CFG_BBP_RW_MODE, 1);
 
 		rt2800_register_write_lock(rt2x00dev, BBP_CSR_CFG, reg);
@@ -218,9 +218,9 @@ void rt2800_mcu_request(struct rt2x00_dev *rt2x00dev,
 	u32 reg;
 
 	/*
-	 * RT2880 and RT3052 don't support MCU requests.
+	 * SOC devices don't support MCU requests.
 	 */
-	if (rt2x00_rt(rt2x00dev, RT2880) || rt2x00_rt(rt2x00dev, RT3052))
+	if (rt2x00_is_soc(rt2x00dev))
 		return;
 
 	mutex_lock(&rt2x00dev->csr_mutex);
@@ -660,7 +660,7 @@ void rt2800_config_ant(struct rt2x00_dev *rt2x00dev, struct antenna_setup *ant)
 	switch ((int)ant->tx) {
 	case 1:
 		rt2x00_set_field8(&r1, BBP1_TX_ANTENNA, 0);
-		if (rt2x00_intf_is_pci(rt2x00dev))
+		if (rt2x00_is_pci(rt2x00dev) || rt2x00_is_soc(rt2x00dev))
 			rt2x00_set_field8(&r3, BBP3_RX_ANTENNA, 0);
 		break;
 	case 2:
@@ -1057,7 +1057,7 @@ EXPORT_SYMBOL_GPL(rt2800_link_stats);
 static u8 rt2800_get_default_vgc(struct rt2x00_dev *rt2x00dev)
 {
 	if (rt2x00dev->curr_band == IEEE80211_BAND_2GHZ) {
-		if (rt2x00_intf_is_usb(rt2x00dev) &&
+		if (rt2x00_is_usb(rt2x00dev) &&
 		    rt2x00_rev(rt2x00dev) == RT3070_VERSION)
 			return 0x1c + (2 * rt2x00dev->lna_gain);
 		else
@@ -1109,7 +1109,7 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	u32 reg;
 	unsigned int i;
 
-	if (rt2x00_intf_is_usb(rt2x00dev)) {
+	if (rt2x00_is_usb(rt2x00dev)) {
 		/*
 		 * Wait until BBP and RF are ready.
 		 */
@@ -1128,7 +1128,7 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 		rt2800_register_read(rt2x00dev, PBF_SYS_CTRL, &reg);
 		rt2800_register_write(rt2x00dev, PBF_SYS_CTRL,
 				      reg & ~0x00002000);
-	} else if (rt2x00_intf_is_pci(rt2x00dev))
+	} else if (rt2x00_is_pci(rt2x00dev) || rt2x00_is_soc(rt2x00dev))
 		rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000003);
 
 	rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
@@ -1136,7 +1136,7 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_BBP, 1);
 	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
 
-	if (rt2x00_intf_is_usb(rt2x00dev)) {
+	if (rt2x00_is_usb(rt2x00dev)) {
 		rt2800_register_write(rt2x00dev, USB_DMA_CFG, 0x00000000);
 #if defined(CONFIG_RT2X00_LIB_USB) || defined(CONFIG_RT2X00_LIB_USB_MODULE)
 		rt2x00usb_vendor_request_sw(rt2x00dev, USB_DEVICE_MODE, 0,
@@ -1174,7 +1174,7 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, BCN_TIME_CFG_TX_TIME_COMPENSATE, 0);
 	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
 
-	if (rt2x00_intf_is_usb(rt2x00dev) &&
+	if (rt2x00_is_usb(rt2x00dev) &&
 	    rt2x00_rev(rt2x00dev) == RT3070_VERSION) {
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000400);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00000000);
@@ -1293,7 +1293,7 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, GF40_PROT_CFG_TX_OP_ALLOW_GF40, 1);
 	rt2800_register_write(rt2x00dev, GF40_PROT_CFG, reg);
 
-	if (rt2x00_intf_is_usb(rt2x00dev)) {
+	if (rt2x00_is_usb(rt2x00dev)) {
 		rt2800_register_write(rt2x00dev, PBF_CFG, 0xf40006);
 
 		rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
@@ -1353,7 +1353,7 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_write(rt2x00dev, HW_BEACON_BASE6, 0);
 	rt2800_register_write(rt2x00dev, HW_BEACON_BASE7, 0);
 
-	if (rt2x00_intf_is_usb(rt2x00dev)) {
+	if (rt2x00_is_usb(rt2x00dev)) {
 		rt2800_register_read(rt2x00dev, USB_CYC_CFG, &reg);
 		rt2x00_set_field32(&reg, USB_CYC_CFG_CLOCK_CYCLE, 30);
 		rt2800_register_write(rt2x00dev, USB_CYC_CFG, reg);
@@ -1490,7 +1490,7 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	if (rt2x00_rev(rt2x00dev) > RT2860D_VERSION)
 		rt2800_bbp_write(rt2x00dev, 84, 0x19);
 
-	if (rt2x00_intf_is_usb(rt2x00dev) &&
+	if (rt2x00_is_usb(rt2x00dev) &&
 	    rt2x00_rev(rt2x00dev) == RT3070_VERSION) {
 		rt2800_bbp_write(rt2x00dev, 70, 0x0a);
 		rt2800_bbp_write(rt2x00dev, 84, 0x99);
@@ -1582,11 +1582,11 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	u8 rfcsr;
 	u8 bbp;
 
-	if (rt2x00_intf_is_usb(rt2x00dev) &&
+	if (rt2x00_is_usb(rt2x00dev) &&
 	    rt2x00_rev(rt2x00dev) != RT3070_VERSION)
 		return 0;
 
-	if (rt2x00_intf_is_pci(rt2x00dev)) {
+	if (rt2x00_is_pci(rt2x00dev) || rt2x00_is_soc(rt2x00dev)) {
 		if (!rt2x00_rf(rt2x00dev, RF3020) &&
 		    !rt2x00_rf(rt2x00dev, RF3021) &&
 		    !rt2x00_rf(rt2x00dev, RF3022))
@@ -1603,7 +1603,7 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 0);
 	rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
 
-	if (rt2x00_intf_is_usb(rt2x00dev)) {
+	if (rt2x00_is_usb(rt2x00dev)) {
 		rt2800_rfcsr_write(rt2x00dev, 4, 0x40);
 		rt2800_rfcsr_write(rt2x00dev, 5, 0x03);
 		rt2800_rfcsr_write(rt2x00dev, 6, 0x02);
@@ -1624,7 +1624,7 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 		rt2800_rfcsr_write(rt2x00dev, 25, 0x01);
 		rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
 		rt2800_rfcsr_write(rt2x00dev, 29, 0x1f);
-	} else if (rt2x00_intf_is_pci(rt2x00dev)) {
+	} else if (rt2x00_is_pci(rt2x00dev) || rt2x00_is_soc(rt2x00dev)) {
 		rt2800_rfcsr_write(rt2x00dev, 0, 0x50);
 		rt2800_rfcsr_write(rt2x00dev, 1, 0x01);
 		rt2800_rfcsr_write(rt2x00dev, 2, 0xf7);
@@ -1855,7 +1855,7 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 
 	rt2x00_set_chip_rf(rt2x00dev, value, reg);
 
-	if (rt2x00_intf_is_usb(rt2x00dev)) {
+	if (rt2x00_is_usb(rt2x00dev)) {
 		/*
 		 * The check for rt2860 is not a typo, some rt2870 hardware
 		 * identifies itself as rt2860 in the CSR register.
@@ -2039,7 +2039,7 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Disable powersaving as default on PCI devices.
 	 */
-	if (rt2x00_intf_is_pci(rt2x00dev))
+	if (rt2x00_is_pci(rt2x00dev) || rt2x00_is_soc(rt2x00dev))
 		rt2x00dev->hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index daea0b7..d57531c 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1041,18 +1041,12 @@ static int rt2800pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Read EEPROM into buffer
 	 */
-	switch (rt2x00dev->chip.rt) {
-	case RT2880:
-	case RT3052:
+	if (rt2x00_is_soc(rt2x00dev))
 		rt2800pci_read_eeprom_soc(rt2x00dev);
-		break;
-	default:
-		if (rt2800pci_efuse_detect(rt2x00dev))
-			rt2800pci_read_eeprom_efuse(rt2x00dev);
-		else
-			rt2800pci_read_eeprom_pci(rt2x00dev);
-		break;
-	}
+	else if (rt2800pci_efuse_detect(rt2x00dev))
+		rt2800pci_read_eeprom_efuse(rt2x00dev);
+	else
+		rt2800pci_read_eeprom_pci(rt2x00dev);
 
 	return rt2800_validate_eeprom(rt2x00dev);
 }
@@ -1103,7 +1097,7 @@ static int rt2800pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * This device requires firmware.
 	 */
-	if (!rt2x00_rt(rt2x00dev, RT2880) && !rt2x00_rt(rt2x00dev, RT3052))
+	if (!rt2x00_is_soc(rt2x00dev))
 		__set_bit(DRIVER_REQUIRE_FIRMWARE, &rt2x00dev->flags);
 	__set_bit(DRIVER_REQUIRE_DMA, &rt2x00dev->flags);
 	__set_bit(DRIVER_REQUIRE_L2PAD, &rt2x00dev->flags);
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 43b70c6..d741367 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -160,6 +160,7 @@ struct avg_val {
 enum rt2x00_chip_intf {
 	RT2X00_CHIP_INTF_PCI,
 	RT2X00_CHIP_INTF_USB,
+	RT2X00_CHIP_INTF_SOC,
 };
 
 /*
@@ -976,16 +977,21 @@ static inline bool rt2x00_intf(struct rt2x00_dev *rt2x00dev,
 	return (rt2x00dev->chip.intf == intf);
 }
 
-static inline bool rt2x00_intf_is_pci(struct rt2x00_dev *rt2x00dev)
+static inline bool rt2x00_is_pci(struct rt2x00_dev *rt2x00dev)
 {
 	return rt2x00_intf(rt2x00dev, RT2X00_CHIP_INTF_PCI);
 }
 
-static inline bool rt2x00_intf_is_usb(struct rt2x00_dev *rt2x00dev)
+static inline bool rt2x00_is_usb(struct rt2x00_dev *rt2x00dev)
 {
 	return rt2x00_intf(rt2x00dev, RT2X00_CHIP_INTF_USB);
 }
 
+static inline bool rt2x00_is_soc(struct rt2x00_dev *rt2x00dev)
+{
+	return rt2x00_intf(rt2x00dev, RT2X00_CHIP_INTF_SOC);
+}
+
 /**
  * rt2x00queue_map_txskb - Map a skb into DMA for TX purposes.
  * @rt2x00dev: Pointer to &struct rt2x00_dev.
diff --git a/drivers/net/wireless/rt2x00/rt2x00soc.c b/drivers/net/wireless/rt2x00/rt2x00soc.c
index 19e684f..0d6b43a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00soc.c
+++ b/drivers/net/wireless/rt2x00/rt2x00soc.c
@@ -94,11 +94,7 @@ int rt2x00soc_probe(struct platform_device *pdev,
 	rt2x00dev->irq = platform_get_irq(pdev, 0);
 	rt2x00dev->name = pdev->dev.driver->name;
 
-	/*
-	 * SoC devices mimic PCI behavior.
-	 */
-	rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_PCI);
-
+	rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_SOC);
 	rt2x00_set_chip_rt(rt2x00dev, chipset);
 
 	retval = rt2x00soc_alloc_reg(rt2x00dev);
-- 
1.6.6.1

