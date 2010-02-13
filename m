Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml103.kpnxchange.com ([195.121.3.7]:56726 "EHLO
	CPSMTPM-EML103.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757962Ab0BMT4I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Feb 2010 14:56:08 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 2/3] rt2x00: Reorganize RT chipset setting for PCI/SOC devices.
Date: Sat, 13 Feb 2010 20:55:48 +0100
Message-Id: <1266090949-5468-3-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1266090949-5468-2-git-send-email-gwingerde@gmail.com>
References: <1266090949-5468-1-git-send-email-gwingerde@gmail.com>
 <1266090949-5468-2-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't set the RT chipset for a device from within the generic PCI/SOC code,
but rather from the individual drivers, so that individual drivers have
more control over what RT chipset is set.
Preparation for chip handling updates for rt2800 devices.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    9 +++++-
 drivers/net/wireless/rt2x00/rt2500pci.c |    9 +++++-
 drivers/net/wireless/rt2x00/rt2500usb.c |    1 -
 drivers/net/wireless/rt2x00/rt2800lib.c |   39 +++++++++++++++++++++++--------
 drivers/net/wireless/rt2x00/rt2800pci.c |   11 ++++----
 drivers/net/wireless/rt2x00/rt2x00.h    |   15 ------------
 drivers/net/wireless/rt2x00/rt2x00pci.c |    7 -----
 drivers/net/wireless/rt2x00/rt2x00pci.h |    1 +
 drivers/net/wireless/rt2x00/rt2x00soc.c |    5 +---
 drivers/net/wireless/rt2x00/rt2x00soc.h |   10 +-------
 drivers/net/wireless/rt2x00/rt61pci.c   |    9 +++++-
 drivers/net/wireless/rt2x00/rt73usb.c   |    1 -
 12 files changed, 58 insertions(+), 59 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 1843359..9207b9b 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1327,6 +1327,7 @@ static int rt2400pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 static int rt2400pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
+	u16 chip;
 	u16 value;
 	u16 eeprom;
 
@@ -1336,12 +1337,16 @@ static int rt2400pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_ANTENNA, &eeprom);
 
 	/*
+	 * Identify RT chipset.
+	 */
+	pci_read_config_word(to_pci_dev(rt2x00dev->dev), PCI_DEVICE_ID, &chip);
+
+	/*
 	 * Identify RF chipset.
 	 */
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RF_TYPE);
 	rt2x00pci_register_read(rt2x00dev, CSR0, &reg);
-	rt2x00_set_chip_rf(rt2x00dev, value, reg);
-	rt2x00_print_chip(rt2x00dev);
+	rt2x00_set_chip(rt2x00dev, chip, value, reg);
 
 	if (!rt2x00_rf(rt2x00dev, RF2420) && !rt2x00_rf(rt2x00dev, RF2421)) {
 		ERROR(rt2x00dev, "Invalid RF chipset detected.\n");
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 7dfcffa..0f6d001 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1490,6 +1490,7 @@ static int rt2500pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 static int rt2500pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
+	u16 chip;
 	u16 value;
 	u16 eeprom;
 
@@ -1499,12 +1500,16 @@ static int rt2500pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_ANTENNA, &eeprom);
 
 	/*
+	 * Identify RT chipset.
+	 */
+	pci_read_config_word(to_pci_dev(rt2x00dev->dev), PCI_DEVICE_ID, &chip);
+
+	/*
 	 * Identify RF chipset.
 	 */
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RF_TYPE);
 	rt2x00pci_register_read(rt2x00dev, CSR0, &reg);
-	rt2x00_set_chip_rf(rt2x00dev, value, reg);
-	rt2x00_print_chip(rt2x00dev);
+	rt2x00_set_chip(rt2x00dev, chip, value, reg);
 
 	if (!rt2x00_rf(rt2x00dev, RF2522) &&
 	    !rt2x00_rf(rt2x00dev, RF2523) &&
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 81ca4ec..99b7cb8 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1408,7 +1408,6 @@ static int rt2500usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RF_TYPE);
 	rt2500usb_register_read(rt2x00dev, MAC_CSR0, &reg);
 	rt2x00_set_chip(rt2x00dev, RT2570, value, reg);
-	rt2x00_print_chip(rt2x00dev);
 
 	if (!rt2x00_check_rev(rt2x00dev, 0x000ffff0, 0) ||
 	    rt2x00_check_rev(rt2x00dev, 0x0000000f, 0)) {
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index e78df53..7340e48 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -40,6 +40,9 @@
 #if defined(CONFIG_RT2X00_LIB_USB) || defined(CONFIG_RT2X00_LIB_USB_MODULE)
 #include "rt2x00usb.h"
 #endif
+#if defined(CONFIG_RT2X00_LIB_PCI) || defined(CONFIG_RT2X00_LIB_PCI_MODULE)
+#include "rt2x00pci.h"
+#endif
 #include "rt2800lib.h"
 #include "rt2800.h"
 #include "rt2800usb.h"
@@ -1839,6 +1842,7 @@ EXPORT_SYMBOL_GPL(rt2800_validate_eeprom);
 int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
+	u16 chip;
 	u16 value;
 	u16 eeprom;
 
@@ -1853,25 +1857,40 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RF_TYPE);
 	rt2800_register_read(rt2x00dev, MAC_CSR0, &reg);
 
-	rt2x00_set_chip_rf(rt2x00dev, value, reg);
-
-	if (rt2x00_is_usb(rt2x00dev)) {
+	if (rt2x00_is_pci(rt2x00dev)) {
+#if defined(CONFIG_RT2X00_LIB_PCI) || defined(CONFIG_RT2X00_LIB_PCI_MODULE)
+		pci_read_config_word(to_pci_dev(rt2x00dev->dev),
+				     PCI_DEVICE_ID,
+				     &chip);
+#else
+		BUG();
+#endif
+	} else if (rt2x00_is_usb(rt2x00dev)) {
 		/*
 		 * The check for rt2860 is not a typo, some rt2870 hardware
 		 * identifies itself as rt2860 in the CSR register.
 		 */
-		if (rt2x00_check_rev(rt2x00dev, 0xfff00000, 0x28600000) ||
-		    rt2x00_check_rev(rt2x00dev, 0xfff00000, 0x28700000) ||
-		    rt2x00_check_rev(rt2x00dev, 0xfff00000, 0x28800000)) {
-			rt2x00_set_chip_rt(rt2x00dev, RT2870);
-		} else if (rt2x00_check_rev(rt2x00dev, 0xffff0000, 0x30700000)) {
-			rt2x00_set_chip_rt(rt2x00dev, RT3070);
+		if (((reg & 0xfff00000) == 0x28600000) ||
+		    ((reg & 0xfff00000) == 0x28700000) ||
+		    ((reg & 0xfff00000) == 0x28800000)) {
+			chip = RT2870;
+		} else if ((reg & 0xffff0000) == 0x30700000) {
+			chip = RT3070;
 		} else {
 			ERROR(rt2x00dev, "Invalid RT chipset detected.\n");
 			return -ENODEV;
 		}
+	} else if (rt2x00_is_soc(rt2x00dev)) {
+#if defined(CONFIG_RALINK_RT288X)
+		chip = RT2880;
+#elif defined(CONFIG_RALINK_RT305X)
+		chip = RT3052;
+#else
+		BUG();
+#endif
 	}
-	rt2x00_print_chip(rt2x00dev);
+
+	rt2x00_set_chip(rt2x00dev, chip, value, reg);
 
 	if (!rt2x00_rf(rt2x00dev, RF2820) &&
 	    !rt2x00_rf(rt2x00dev, RF2850) &&
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index d57531c..fc35105 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1219,11 +1219,10 @@ MODULE_DEVICE_TABLE(pci, rt2800pci_device_table);
 MODULE_LICENSE("GPL");
 
 #ifdef CONFIG_RT2800PCI_SOC
-#if defined(CONFIG_RALINK_RT288X)
-__rt2x00soc_probe(RT2880, &rt2800pci_ops);
-#elif defined(CONFIG_RALINK_RT305X)
-__rt2x00soc_probe(RT3052, &rt2800pci_ops);
-#endif
+static int rt2800soc_probe(struct platform_device *pdev)
+{
+	return rt2x00soc_probe(pdev, rt2800pci_ops);
+}
 
 static struct platform_driver rt2800soc_driver = {
 	.driver		= {
@@ -1231,7 +1230,7 @@ static struct platform_driver rt2800soc_driver = {
 		.owner		= THIS_MODULE,
 		.mod_name	= KBUILD_MODNAME,
 	},
-	.probe		= __rt2x00soc_probe,
+	.probe		= rt2800soc_probe,
 	.remove		= __devexit_p(rt2x00soc_remove),
 	.suspend	= rt2x00soc_suspend,
 	.resume		= rt2x00soc_resume,
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index d741367..1fed90a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -923,22 +923,7 @@ static inline void rt2x00_set_chip(struct rt2x00_dev *rt2x00dev,
 	rt2x00dev->chip.rt = rt;
 	rt2x00dev->chip.rf = rf;
 	rt2x00dev->chip.rev = rev;
-}
-
-static inline void rt2x00_set_chip_rt(struct rt2x00_dev *rt2x00dev,
-				      const u16 rt)
-{
-	rt2x00dev->chip.rt = rt;
-}
 
-static inline void rt2x00_set_chip_rf(struct rt2x00_dev *rt2x00dev,
-				      const u16 rf, const u32 rev)
-{
-	rt2x00_set_chip(rt2x00dev, rt2x00dev->chip.rt, rf, rev);
-}
-
-static inline void rt2x00_print_chip(struct rt2x00_dev *rt2x00dev)
-{
 	INFO(rt2x00dev,
 	     "Chipset detected - rt: %04x, rf: %04x, rev: %08x.\n",
 	     rt2x00dev->chip.rt, rt2x00dev->chip.rf, rt2x00dev->chip.rev);
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 801be43..047123b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -272,7 +272,6 @@ int rt2x00pci_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 	struct ieee80211_hw *hw;
 	struct rt2x00_dev *rt2x00dev;
 	int retval;
-	u16 chip;
 
 	retval = pci_request_regions(pci_dev, pci_name(pci_dev));
 	if (retval) {
@@ -315,12 +314,6 @@ int rt2x00pci_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 
 	rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_PCI);
 
-	/*
-	 * Determine RT chipset by reading PCI header.
-	 */
-	pci_read_config_word(pci_dev, PCI_DEVICE_ID, &chip);
-	rt2x00_set_chip_rt(rt2x00dev, chip);
-
 	retval = rt2x00pci_alloc_reg(rt2x00dev);
 	if (retval)
 		goto exit_free_device;
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.h b/drivers/net/wireless/rt2x00/rt2x00pci.h
index d4f9449..8149ff6 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.h
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.h
@@ -27,6 +27,7 @@
 #define RT2X00PCI_H
 
 #include <linux/io.h>
+#include <linux/pci.h>
 
 /*
  * This variable should be used with the
diff --git a/drivers/net/wireless/rt2x00/rt2x00soc.c b/drivers/net/wireless/rt2x00/rt2x00soc.c
index 0d6b43a..4efdc96 100644
--- a/drivers/net/wireless/rt2x00/rt2x00soc.c
+++ b/drivers/net/wireless/rt2x00/rt2x00soc.c
@@ -71,9 +71,7 @@ exit:
 	return -ENOMEM;
 }
 
-int rt2x00soc_probe(struct platform_device *pdev,
-		    const unsigned short chipset,
-		    const struct rt2x00_ops *ops)
+int rt2x00soc_probe(struct platform_device *pdev, const struct rt2x00_ops *ops)
 {
 	struct ieee80211_hw *hw;
 	struct rt2x00_dev *rt2x00dev;
@@ -95,7 +93,6 @@ int rt2x00soc_probe(struct platform_device *pdev,
 	rt2x00dev->name = pdev->dev.driver->name;
 
 	rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_SOC);
-	rt2x00_set_chip_rt(rt2x00dev, chipset);
 
 	retval = rt2x00soc_alloc_reg(rt2x00dev);
 	if (retval)
diff --git a/drivers/net/wireless/rt2x00/rt2x00soc.h b/drivers/net/wireless/rt2x00/rt2x00soc.h
index 8a34166..4739edf 100644
--- a/drivers/net/wireless/rt2x00/rt2x00soc.h
+++ b/drivers/net/wireless/rt2x00/rt2x00soc.h
@@ -28,18 +28,10 @@
 
 #define KSEG1ADDR(__ptr) __ptr
 
-#define __rt2x00soc_probe(__chipset, __ops) \
-static int __rt2x00soc_probe(struct platform_device *pdev) \
-{ \
-	return rt2x00soc_probe(pdev, (__chipset), (__ops)); \
-}
-
 /*
  * SoC driver handlers.
  */
-int rt2x00soc_probe(struct platform_device *pdev,
-		    const unsigned short chipset,
-		    const struct rt2x00_ops *ops);
+int rt2x00soc_probe(struct platform_device *pdev, const struct rt2x00_ops *ops);
 int rt2x00soc_remove(struct platform_device *pdev);
 #ifdef CONFIG_PM
 int rt2x00soc_suspend(struct platform_device *pdev, pm_message_t state);
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 8813400..4ca1d48 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2282,6 +2282,7 @@ static int rt61pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 static int rt61pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
+	u16 chip;
 	u16 value;
 	u16 eeprom;
 
@@ -2291,12 +2292,16 @@ static int rt61pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_ANTENNA, &eeprom);
 
 	/*
+	 * Identify RT chipset.
+	 */
+	pci_read_config_word(to_pci_dev(rt2x00dev->dev), PCI_DEVICE_ID, &chip);
+
+	/*
 	 * Identify RF chipset.
 	 */
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RF_TYPE);
 	rt2x00pci_register_read(rt2x00dev, MAC_CSR0, &reg);
-	rt2x00_set_chip_rf(rt2x00dev, value, reg);
-	rt2x00_print_chip(rt2x00dev);
+	rt2x00_set_chip(rt2x00dev, chip, value, reg);
 
 	if (!rt2x00_rf(rt2x00dev, RF5225) &&
 	    !rt2x00_rf(rt2x00dev, RF5325) &&
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 3781eb7..2950ac7 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1821,7 +1821,6 @@ static int rt73usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RF_TYPE);
 	rt2x00usb_register_read(rt2x00dev, MAC_CSR0, &reg);
 	rt2x00_set_chip(rt2x00dev, RT2571, value, reg);
-	rt2x00_print_chip(rt2x00dev);
 
 	if (!rt2x00_check_rev(rt2x00dev, 0x000ffff0, 0x25730) ||
 	    rt2x00_check_rev(rt2x00dev, 0x0000000f, 0)) {
-- 
1.6.6.1

