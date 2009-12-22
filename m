Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:60035 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753472AbZLVXDq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2009 18:03:46 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 2/5] rt2x00: Fix checks for rt2800 SOC support.
Date: Wed, 23 Dec 2009 00:03:22 +0100
Message-Id: <1261523005-5856-3-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1261523005-5856-2-git-send-email-gwingerde@gmail.com>
References: <1261523005-5856-1-git-send-email-gwingerde@gmail.com>
 <1261523005-5856-2-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix checking for SOC support in rt2800pci. The wrong config (an unexisting
one) was checked.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 458378c..96e0244 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -52,8 +52,8 @@
 #define CONFIG_RT2800PCI_PCI
 #endif
 
-#ifdef CONFIG_RT2800PCI_WISOC_MODULE
-#define CONFIG_RT2800PCI_WISOC
+#ifdef CONFIG_RT2800PCI_SOC_MODULE
+#define CONFIG_RT2800PCI_SOC
 #endif
 
 /*
@@ -87,7 +87,7 @@ static void rt2800pci_mcu_status(struct rt2x00_dev *rt2x00dev, const u8 token)
 	rt2800_register_write(rt2x00dev, H2M_MAILBOX_CID, ~0);
 }
 
-#ifdef CONFIG_RT2800PCI_WISOC
+#ifdef CONFIG_RT2800PCI_SOC
 static void rt2800pci_read_eeprom_soc(struct rt2x00_dev *rt2x00dev)
 {
 	u32 *base_addr = (u32 *) KSEG1ADDR(0x1F040000); /* XXX for RT3052 */
@@ -98,7 +98,7 @@ static void rt2800pci_read_eeprom_soc(struct rt2x00_dev *rt2x00dev)
 static inline void rt2800pci_read_eeprom_soc(struct rt2x00_dev *rt2x00dev)
 {
 }
-#endif /* CONFIG_RT2800PCI_WISOC */
+#endif /* CONFIG_RT2800PCI_SOC */
 
 #ifdef CONFIG_RT2800PCI_PCI
 static void rt2800pci_eepromregister_read(struct eeprom_93cx6 *eeprom)
@@ -1251,7 +1251,7 @@ MODULE_DEVICE_TABLE(pci, rt2800pci_device_table);
 #endif /* CONFIG_RT2800PCI_PCI */
 MODULE_LICENSE("GPL");
 
-#ifdef CONFIG_RT2800PCI_WISOC
+#ifdef CONFIG_RT2800PCI_SOC
 #if defined(CONFIG_RALINK_RT288X)
 __rt2x00soc_probe(RT2880, &rt2800pci_ops);
 #elif defined(CONFIG_RALINK_RT305X)
@@ -1269,7 +1269,7 @@ static struct platform_driver rt2800soc_driver = {
 	.suspend	= rt2x00soc_suspend,
 	.resume		= rt2x00soc_resume,
 };
-#endif /* CONFIG_RT2800PCI_WISOC */
+#endif /* CONFIG_RT2800PCI_SOC */
 
 #ifdef CONFIG_RT2800PCI_PCI
 static struct pci_driver rt2800pci_driver = {
@@ -1286,7 +1286,7 @@ static int __init rt2800pci_init(void)
 {
 	int ret = 0;
 
-#ifdef CONFIG_RT2800PCI_WISOC
+#ifdef CONFIG_RT2800PCI_SOC
 	ret = platform_driver_register(&rt2800soc_driver);
 	if (ret)
 		return ret;
@@ -1294,7 +1294,7 @@ static int __init rt2800pci_init(void)
 #ifdef CONFIG_RT2800PCI_PCI
 	ret = pci_register_driver(&rt2800pci_driver);
 	if (ret) {
-#ifdef CONFIG_RT2800PCI_WISOC
+#ifdef CONFIG_RT2800PCI_SOC
 		platform_driver_unregister(&rt2800soc_driver);
 #endif
 		return ret;
@@ -1309,7 +1309,7 @@ static void __exit rt2800pci_exit(void)
 #ifdef CONFIG_RT2800PCI_PCI
 	pci_unregister_driver(&rt2800pci_driver);
 #endif
-#ifdef CONFIG_RT2800PCI_WISOC
+#ifdef CONFIG_RT2800PCI_SOC
 	platform_driver_unregister(&rt2800soc_driver);
 #endif
 }
-- 
1.6.5.7

