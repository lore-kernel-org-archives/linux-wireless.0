Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34995 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242Ab0KMSOR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Nov 2010 13:14:17 -0500
Received: by ewy8 with SMTP id 8so221945ewy.19
        for <linux-wireless@vger.kernel.org>; Sat, 13 Nov 2010 10:14:16 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 5/9] rt2x00: Remove unneccessary internal Kconfig symbols.
Date: Sat, 13 Nov 2010 19:10:54 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201011131908.15595.IvDoorn@gmail.com> <201011131910.11947.IvDoorn@gmail.com> <201011131910.32367.IvDoorn@gmail.com>
In-Reply-To: <201011131910.32367.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011131910.55175.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

CONFIG_RT2800PCI_PCI and CONFIG_RT2800PCI_SOC are strictly not needed
as we can check the dependent symbols directly in the rest of Kconfig
and the code, so clean up the Kconfig namespace a bit.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/Kconfig     |   16 ++-----------
 drivers/net/wireless/rt2x00/rt2800pci.c |   34 +++++++++++++++---------------
 2 files changed, 20 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index a6939cc..ade3025 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -53,22 +53,12 @@ config RT61PCI
 
 	  When compiled as a module, this driver will be called rt61pci.
 
-config RT2800PCI_PCI
-	boolean
-	depends on PCI
-	default y
-
-config RT2800PCI_SOC
-	boolean
-	depends on RALINK_RT288X || RALINK_RT305X
-	default y
-
 config RT2800PCI
 	tristate "Ralink rt27xx/rt28xx/rt30xx (PCI/PCIe/PCMCIA) support"
-	depends on RT2800PCI_PCI || RT2800PCI_SOC
+	depends on PCI || RALINK_RT288X || RALINK_RT305X
 	select RT2800_LIB
-	select RT2X00_LIB_PCI if RT2800PCI_PCI
-	select RT2X00_LIB_SOC if RT2800PCI_SOC
+	select RT2X00_LIB_PCI if PCI
+	select RT2X00_LIB_SOC if RALINK_RT288X || RALINK_RT305X
 	select RT2X00_LIB_HT
 	select RT2X00_LIB_FIRMWARE
 	select RT2X00_LIB_CRYPTO
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 97f4df6..b0946f8 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -84,7 +84,7 @@ static void rt2800pci_mcu_status(struct rt2x00_dev *rt2x00dev, const u8 token)
 	rt2800_register_write(rt2x00dev, H2M_MAILBOX_CID, ~0);
 }
 
-#ifdef CONFIG_RT2800PCI_SOC
+#if defined(CONFIG_RALINK_RT288X) || defined(CONFIG_RALINK_RT305X)
 static void rt2800pci_read_eeprom_soc(struct rt2x00_dev *rt2x00dev)
 {
 	u32 *base_addr = (u32 *) KSEG1ADDR(0x1F040000); /* XXX for RT3052 */
@@ -95,9 +95,9 @@ static void rt2800pci_read_eeprom_soc(struct rt2x00_dev *rt2x00dev)
 static inline void rt2800pci_read_eeprom_soc(struct rt2x00_dev *rt2x00dev)
 {
 }
-#endif /* CONFIG_RT2800PCI_SOC */
+#endif /* CONFIG_RALINK_RT288X || CONFIG_RALINK_RT305X */
 
-#ifdef CONFIG_RT2800PCI_PCI
+#ifdef CONFIG_PCI
 static void rt2800pci_eepromregister_read(struct eeprom_93cx6 *eeprom)
 {
 	struct rt2x00_dev *rt2x00dev = eeprom->data;
@@ -181,7 +181,7 @@ static inline int rt2800pci_efuse_detect(struct rt2x00_dev *rt2x00dev)
 static inline void rt2800pci_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev)
 {
 }
-#endif /* CONFIG_RT2800PCI_PCI */
+#endif /* CONFIG_PCI */
 
 /*
  * Firmware functions
@@ -1031,7 +1031,7 @@ static const struct rt2x00_ops rt2800pci_ops = {
 /*
  * RT2800pci module information.
  */
-#ifdef CONFIG_RT2800PCI_PCI
+#ifdef CONFIG_PCI
 static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table) = {
 	{ PCI_DEVICE(0x1814, 0x0601), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	{ PCI_DEVICE(0x1814, 0x0681), PCI_DEVICE_DATA(&rt2800pci_ops) },
@@ -1061,19 +1061,19 @@ static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table) = {
 #endif
 	{ 0, }
 };
-#endif /* CONFIG_RT2800PCI_PCI */
+#endif /* CONFIG_PCI */
 
 MODULE_AUTHOR(DRV_PROJECT);
 MODULE_VERSION(DRV_VERSION);
 MODULE_DESCRIPTION("Ralink RT2800 PCI & PCMCIA Wireless LAN driver.");
 MODULE_SUPPORTED_DEVICE("Ralink RT2860 PCI & PCMCIA chipset based cards");
-#ifdef CONFIG_RT2800PCI_PCI
+#ifdef CONFIG_PCI
 MODULE_FIRMWARE(FIRMWARE_RT2860);
 MODULE_DEVICE_TABLE(pci, rt2800pci_device_table);
-#endif /* CONFIG_RT2800PCI_PCI */
+#endif /* CONFIG_PCI */
 MODULE_LICENSE("GPL");
 
-#ifdef CONFIG_RT2800PCI_SOC
+#if defined(CONFIG_RALINK_RT288X) || defined(CONFIG_RALINK_RT305X)
 static int rt2800soc_probe(struct platform_device *pdev)
 {
 	return rt2x00soc_probe(pdev, &rt2800pci_ops);
@@ -1090,9 +1090,9 @@ static struct platform_driver rt2800soc_driver = {
 	.suspend	= rt2x00soc_suspend,
 	.resume		= rt2x00soc_resume,
 };
-#endif /* CONFIG_RT2800PCI_SOC */
+#endif /* CONFIG_RALINK_RT288X || CONFIG_RALINK_RT305X */
 
-#ifdef CONFIG_RT2800PCI_PCI
+#ifdef CONFIG_PCI
 static struct pci_driver rt2800pci_driver = {
 	.name		= KBUILD_MODNAME,
 	.id_table	= rt2800pci_device_table,
@@ -1101,21 +1101,21 @@ static struct pci_driver rt2800pci_driver = {
 	.suspend	= rt2x00pci_suspend,
 	.resume		= rt2x00pci_resume,
 };
-#endif /* CONFIG_RT2800PCI_PCI */
+#endif /* CONFIG_PCI */
 
 static int __init rt2800pci_init(void)
 {
 	int ret = 0;
 
-#ifdef CONFIG_RT2800PCI_SOC
+#if defined(CONFIG_RALINK_RT288X) || defined(CONFIG_RALINK_RT305X)
 	ret = platform_driver_register(&rt2800soc_driver);
 	if (ret)
 		return ret;
 #endif
-#ifdef CONFIG_RT2800PCI_PCI
+#ifdef CONFIG_PCI
 	ret = pci_register_driver(&rt2800pci_driver);
 	if (ret) {
-#ifdef CONFIG_RT2800PCI_SOC
+#if defined(CONFIG_RALINK_RT288X) || defined(CONFIG_RALINK_RT305X)
 		platform_driver_unregister(&rt2800soc_driver);
 #endif
 		return ret;
@@ -1127,10 +1127,10 @@ static int __init rt2800pci_init(void)
 
 static void __exit rt2800pci_exit(void)
 {
-#ifdef CONFIG_RT2800PCI_PCI
+#ifdef CONFIG_PCI
 	pci_unregister_driver(&rt2800pci_driver);
 #endif
-#ifdef CONFIG_RT2800PCI_SOC
+#if defined(CONFIG_RALINK_RT288X) || defined(CONFIG_RALINK_RT305X)
 	platform_driver_unregister(&rt2800soc_driver);
 #endif
 }
-- 
1.7.2.3

