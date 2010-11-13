Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33747 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756310Ab0KMSOP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Nov 2010 13:14:15 -0500
Received: by mail-ew0-f46.google.com with SMTP id 8so221913ewy.19
        for <linux-wireless@vger.kernel.org>; Sat, 13 Nov 2010 10:14:14 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 4/9] rt2x00: Remove RT30XX Kconfig variables.
Date: Sat, 13 Nov 2010 19:10:31 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201011131908.15595.IvDoorn@gmail.com> <201011131909.50885.IvDoorn@gmail.com> <201011131910.11947.IvDoorn@gmail.com>
In-Reply-To: <201011131910.11947.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011131910.32367.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

Enabling of RT30xx devices via Kconfig variables was introduced when these
devices weren't properly supported yet.
Now that that they are properly supported and functional, we can remove these
Kconfig variables for RT30xx devices and simply enable them whenever rt2800pci
and/or rt2800usb is enabled.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/Kconfig     |   29 ++----
 drivers/net/wireless/rt2x00/rt2800pci.c |   10 +-
 drivers/net/wireless/rt2x00/rt2800usb.c |  167 ++++++++++++++-----------------
 3 files changed, 85 insertions(+), 121 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index f2be1d3..a6939cc 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -64,7 +64,7 @@ config RT2800PCI_SOC
 	default y
 
 config RT2800PCI
-	tristate "Ralink rt27xx/rt28xx (PCI/PCIe/PCMCIA) support"
+	tristate "Ralink rt27xx/rt28xx/rt30xx (PCI/PCIe/PCMCIA) support"
 	depends on RT2800PCI_PCI || RT2800PCI_SOC
 	select RT2800_LIB
 	select RT2X00_LIB_PCI if RT2800PCI_PCI
@@ -75,21 +75,14 @@ config RT2800PCI
 	select CRC_CCITT
 	select EEPROM_93CX6
 	---help---
-	  This adds support for rt27xx/rt28xx wireless chipset family.
-	  Supported chips: RT2760, RT2790, RT2860, RT2880, RT2890 & RT3052
+	  This adds support for rt27xx/rt28xx/rt30xx wireless chipset family.
+	  Supported chips: RT2760, RT2790, RT2860, RT2880, RT2890, RT3052,
+			   RT3090, RT3091 & RT3092
 
 	  When compiled as a module, this driver will be called "rt2800pci.ko".
 
 if RT2800PCI
 
-config RT2800PCI_RT30XX
-	bool "rt2800pci - Include support for rt30xx devices"
-	default y
-	---help---
-	  This adds support for rt30xx wireless chipset family to the
-	  rt2800pci driver.
-	  Supported chips: RT3090, RT3091 & RT3092
-
 config RT2800PCI_RT33XX
 	bool "rt2800pci - Include support for rt33xx devices (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
@@ -141,7 +134,7 @@ config RT73USB
 	  When compiled as a module, this driver will be called rt73usb.
 
 config RT2800USB
-	tristate "Ralink rt27xx/rt28xx (USB) support"
+	tristate "Ralink rt27xx/rt28xx/rt30xx (USB) support"
 	depends on USB
 	select RT2800_LIB
 	select RT2X00_LIB_USB
@@ -150,21 +143,13 @@ config RT2800USB
 	select RT2X00_LIB_CRYPTO
 	select CRC_CCITT
 	---help---
-	  This adds support for rt27xx/rt28xx wireless chipset family.
-	  Supported chips: RT2770, RT2870 & RT3070.
+	  This adds support for rt27xx/rt28xx/rt30xx wireless chipset family.
+	  Supported chips: RT2770, RT2870 & RT3070, RT3071 & RT3072
 
 	  When compiled as a module, this driver will be called "rt2800usb.ko".
 
 if RT2800USB
 
-config RT2800USB_RT30XX
-	bool "rt2800usb - Include support for rt30xx devices"
-	default y
-	---help---
-	  This adds support for rt30xx wireless chipset family to the
-	  rt2800usb driver.
-	  Supported chips: RT3070, RT3071 & RT3072
-
 config RT2800USB_RT33XX
 	bool "rt2800usb - Include support for rt33xx devices (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 6642f13..97f4df6 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1037,6 +1037,9 @@ static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table) = {
 	{ PCI_DEVICE(0x1814, 0x0681), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	{ PCI_DEVICE(0x1814, 0x0701), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	{ PCI_DEVICE(0x1814, 0x0781), PCI_DEVICE_DATA(&rt2800pci_ops) },
+	{ PCI_DEVICE(0x1814, 0x3090), PCI_DEVICE_DATA(&rt2800pci_ops) },
+	{ PCI_DEVICE(0x1814, 0x3091), PCI_DEVICE_DATA(&rt2800pci_ops) },
+	{ PCI_DEVICE(0x1814, 0x3092), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	{ PCI_DEVICE(0x1432, 0x7708), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	{ PCI_DEVICE(0x1432, 0x7727), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	{ PCI_DEVICE(0x1432, 0x7728), PCI_DEVICE_DATA(&rt2800pci_ops) },
@@ -1044,13 +1047,8 @@ static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table) = {
 	{ PCI_DEVICE(0x1432, 0x7748), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	{ PCI_DEVICE(0x1432, 0x7758), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	{ PCI_DEVICE(0x1432, 0x7768), PCI_DEVICE_DATA(&rt2800pci_ops) },
-	{ PCI_DEVICE(0x1a3b, 0x1059), PCI_DEVICE_DATA(&rt2800pci_ops) },
-#ifdef CONFIG_RT2800PCI_RT30XX
-	{ PCI_DEVICE(0x1814, 0x3090), PCI_DEVICE_DATA(&rt2800pci_ops) },
-	{ PCI_DEVICE(0x1814, 0x3091), PCI_DEVICE_DATA(&rt2800pci_ops) },
-	{ PCI_DEVICE(0x1814, 0x3092), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	{ PCI_DEVICE(0x1462, 0x891a), PCI_DEVICE_DATA(&rt2800pci_ops) },
-#endif
+	{ PCI_DEVICE(0x1a3b, 0x1059), PCI_DEVICE_DATA(&rt2800pci_ops) },
 #ifdef CONFIG_RT2800PCI_RT33XX
 	{ PCI_DEVICE(0x1814, 0x3390), PCI_DEVICE_DATA(&rt2800pci_ops) },
 #endif
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 61852c5..2933bf1 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -641,11 +641,19 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	/* Abocom */
 	{ USB_DEVICE(0x07b8, 0x2870), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x07b8, 0x2770), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x07b8, 0x3070), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x07b8, 0x3071), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x07b8, 0x3072), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x1482, 0x3c09), USB_DEVICE_DATA(&rt2800usb_ops) },
+	/* AirTies */
+	{ USB_DEVICE(0x1eda, 0x2310), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Allwin */
 	{ USB_DEVICE(0x8516, 0x2070), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x8516, 0x2770), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x8516, 0x2870), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x8516, 0x3070), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x8516, 0x3071), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x8516, 0x3072), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Amit */
 	{ USB_DEVICE(0x15c5, 0x0008), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Askey */
@@ -654,8 +662,13 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x0b05, 0x1731), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0b05, 0x1732), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0b05, 0x1742), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0b05, 0x1784), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* AzureWave */
 	{ USB_DEVICE(0x13d3, 0x3247), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x13d3, 0x3273), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x13d3, 0x3305), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x13d3, 0x3307), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x13d3, 0x3321), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Belkin */
 	{ USB_DEVICE(0x050d, 0x8053), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x050d, 0x805c), USB_DEVICE_DATA(&rt2800usb_ops) },
@@ -666,6 +679,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x14b2, 0x3c06), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x14b2, 0x3c07), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x14b2, 0x3c09), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x14b2, 0x3c12), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x14b2, 0x3c23), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x14b2, 0x3c25), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x14b2, 0x3c27), USB_DEVICE_DATA(&rt2800usb_ops) },
@@ -674,113 +688,27 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x07aa, 0x002f), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x07aa, 0x003c), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x07aa, 0x003f), USB_DEVICE_DATA(&rt2800usb_ops) },
-	/* D-Link */
-	{ USB_DEVICE(0x07d1, 0x3c09), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x07d1, 0x3c11), USB_DEVICE_DATA(&rt2800usb_ops) },
-	/* Edimax */
-	{ USB_DEVICE(0x7392, 0x7717), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x7392, 0x7718), USB_DEVICE_DATA(&rt2800usb_ops) },
-	/* EnGenius */
-	{ USB_DEVICE(0x1740, 0x9701), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x1740, 0x9702), USB_DEVICE_DATA(&rt2800usb_ops) },
-	/* Gigabyte */
-	{ USB_DEVICE(0x1044, 0x800b), USB_DEVICE_DATA(&rt2800usb_ops) },
-	/* Hawking */
-	{ USB_DEVICE(0x0e66, 0x0001), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x0e66, 0x0003), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x0e66, 0x0009), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x0e66, 0x000b), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x0e66, 0x0013), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x0e66, 0x0017), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x0e66, 0x0018), USB_DEVICE_DATA(&rt2800usb_ops) },
-	/* Linksys */
-	{ USB_DEVICE(0x1737, 0x0070), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x1737, 0x0071), USB_DEVICE_DATA(&rt2800usb_ops) },
-	/* Logitec */
-	{ USB_DEVICE(0x0789, 0x0162), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x0789, 0x0163), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x0789, 0x0164), USB_DEVICE_DATA(&rt2800usb_ops) },
-	/* Motorola */
-	{ USB_DEVICE(0x100d, 0x9031), USB_DEVICE_DATA(&rt2800usb_ops) },
-	/* MSI */
-	{ USB_DEVICE(0x0db0, 0x6899), USB_DEVICE_DATA(&rt2800usb_ops) },
-	/* Philips */
-	{ USB_DEVICE(0x0471, 0x200f), USB_DEVICE_DATA(&rt2800usb_ops) },
-	/* Planex */
-	{ USB_DEVICE(0x2019, 0xed06), USB_DEVICE_DATA(&rt2800usb_ops) },
-	/* Ralink */
-	{ USB_DEVICE(0x148f, 0x2770), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x148f, 0x2870), USB_DEVICE_DATA(&rt2800usb_ops) },
-	/* Samsung */
-	{ USB_DEVICE(0x04e8, 0x2018), USB_DEVICE_DATA(&rt2800usb_ops) },
-	/* Siemens */
-	{ USB_DEVICE(0x129b, 0x1828), USB_DEVICE_DATA(&rt2800usb_ops) },
-	/* Sitecom */
-	{ USB_DEVICE(0x0df6, 0x0017), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x0df6, 0x002b), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x0df6, 0x002c), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x0df6, 0x002d), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x0df6, 0x0039), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x0df6, 0x003b), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x0df6, 0x003d), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x0df6, 0x003f), USB_DEVICE_DATA(&rt2800usb_ops) },
-	/* SMC */
-	{ USB_DEVICE(0x083a, 0x6618), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x083a, 0x7512), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x083a, 0x7522), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x083a, 0x8522), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x083a, 0xa618), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x083a, 0xb522), USB_DEVICE_DATA(&rt2800usb_ops) },
-	/* Sparklan */
-	{ USB_DEVICE(0x15a9, 0x0006), USB_DEVICE_DATA(&rt2800usb_ops) },
-	/* Sweex */
-	{ USB_DEVICE(0x177f, 0x0302), USB_DEVICE_DATA(&rt2800usb_ops) },
-	/* U-Media*/
-	{ USB_DEVICE(0x157e, 0x300e), USB_DEVICE_DATA(&rt2800usb_ops) },
-	/* ZCOM */
-	{ USB_DEVICE(0x0cde, 0x0022), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x0cde, 0x0025), USB_DEVICE_DATA(&rt2800usb_ops) },
-	/* Zinwell */
-	{ USB_DEVICE(0x5a57, 0x0280), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x5a57, 0x0282), USB_DEVICE_DATA(&rt2800usb_ops) },
-	/* Zyxel */
-	{ USB_DEVICE(0x0586, 0x3416), USB_DEVICE_DATA(&rt2800usb_ops) },
-#ifdef CONFIG_RT2800USB_RT30XX
-	/* Abocom */
-	{ USB_DEVICE(0x07b8, 0x3070), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x07b8, 0x3071), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x07b8, 0x3072), USB_DEVICE_DATA(&rt2800usb_ops) },
-	/* AirTies */
-	{ USB_DEVICE(0x1eda, 0x2310), USB_DEVICE_DATA(&rt2800usb_ops) },
-	/* Allwin */
-	{ USB_DEVICE(0x8516, 0x3070), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x8516, 0x3071), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x8516, 0x3072), USB_DEVICE_DATA(&rt2800usb_ops) },
-	/* ASUS */
-	{ USB_DEVICE(0x0b05, 0x1784), USB_DEVICE_DATA(&rt2800usb_ops) },
-	/* AzureWave */
-	{ USB_DEVICE(0x13d3, 0x3273), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x13d3, 0x3305), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x13d3, 0x3307), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x13d3, 0x3321), USB_DEVICE_DATA(&rt2800usb_ops) },
-	/* Conceptronic */
-	{ USB_DEVICE(0x14b2, 0x3c12), USB_DEVICE_DATA(&rt2800usb_ops) },
-	/* Corega */
 	{ USB_DEVICE(0x18c5, 0x0012), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* D-Link */
+	{ USB_DEVICE(0x07d1, 0x3c09), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x07d1, 0x3c0a), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x07d1, 0x3c0d), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x07d1, 0x3c0e), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x07d1, 0x3c0f), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x07d1, 0x3c11), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x07d1, 0x3c16), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Draytek */
 	{ USB_DEVICE(0x07fa, 0x7712), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Edimax */
 	{ USB_DEVICE(0x7392, 0x7711), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x7392, 0x7717), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x7392, 0x7718), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Encore */
 	{ USB_DEVICE(0x203d, 0x1480), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x203d, 0x14a9), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* EnGenius */
+	{ USB_DEVICE(0x1740, 0x9701), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x1740, 0x9702), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x1740, 0x9703), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x1740, 0x9705), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x1740, 0x9706), USB_DEVICE_DATA(&rt2800usb_ops) },
@@ -788,19 +716,37 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x1740, 0x9708), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x1740, 0x9709), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Gigabyte */
+	{ USB_DEVICE(0x1044, 0x800b), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x1044, 0x800d), USB_DEVICE_DATA(&rt2800usb_ops) },
+	/* Hawking */
+	{ USB_DEVICE(0x0e66, 0x0001), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0e66, 0x0003), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0e66, 0x0009), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0e66, 0x000b), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0e66, 0x0013), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0e66, 0x0017), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0e66, 0x0018), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* I-O DATA */
 	{ USB_DEVICE(0x04bb, 0x0945), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x04bb, 0x0947), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x04bb, 0x0948), USB_DEVICE_DATA(&rt2800usb_ops) },
+	/* Linksys */
+	{ USB_DEVICE(0x1737, 0x0070), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x1737, 0x0071), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Logitec */
+	{ USB_DEVICE(0x0789, 0x0162), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0789, 0x0163), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0789, 0x0164), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0789, 0x0166), USB_DEVICE_DATA(&rt2800usb_ops) },
+	/* Motorola */
+	{ USB_DEVICE(0x100d, 0x9031), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* MSI */
 	{ USB_DEVICE(0x0db0, 0x3820), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0db0, 0x3821), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0db0, 0x3822), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0db0, 0x3870), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0db0, 0x3871), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0db0, 0x6899), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0db0, 0x821a), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0db0, 0x822a), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0db0, 0x822b), USB_DEVICE_DATA(&rt2800usb_ops) },
@@ -815,30 +761,65 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	/* Pegatron */
 	{ USB_DEVICE(0x1d4d, 0x000c), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x1d4d, 0x000e), USB_DEVICE_DATA(&rt2800usb_ops) },
+	/* Philips */
+	{ USB_DEVICE(0x0471, 0x200f), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Planex */
 	{ USB_DEVICE(0x2019, 0xab25), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x2019, 0xed06), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Quanta */
 	{ USB_DEVICE(0x1a32, 0x0304), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Ralink */
 	{ USB_DEVICE(0x148f, 0x2070), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x148f, 0x2770), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x148f, 0x2870), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x148f, 0x3070), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x148f, 0x3071), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x148f, 0x3072), USB_DEVICE_DATA(&rt2800usb_ops) },
+	/* Samsung */
+	{ USB_DEVICE(0x04e8, 0x2018), USB_DEVICE_DATA(&rt2800usb_ops) },
+	/* Siemens */
+	{ USB_DEVICE(0x129b, 0x1828), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Sitecom */
+	{ USB_DEVICE(0x0df6, 0x0017), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0df6, 0x002b), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0df6, 0x002c), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0df6, 0x002d), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0df6, 0x0039), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0df6, 0x003b), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0df6, 0x003d), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0df6, 0x003e), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0df6, 0x003f), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0df6, 0x0040), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0df6, 0x0042), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0df6, 0x0047), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0df6, 0x0048), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* SMC */
+	{ USB_DEVICE(0x083a, 0x6618), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x083a, 0x7511), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x083a, 0x7512), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x083a, 0x7522), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x083a, 0x8522), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x083a, 0xa618), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x083a, 0xa701), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x083a, 0xa702), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x083a, 0xa703), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x083a, 0xb522), USB_DEVICE_DATA(&rt2800usb_ops) },
+	/* Sparklan */
+	{ USB_DEVICE(0x15a9, 0x0006), USB_DEVICE_DATA(&rt2800usb_ops) },
+	/* Sweex */
+	{ USB_DEVICE(0x177f, 0x0302), USB_DEVICE_DATA(&rt2800usb_ops) },
+	/* U-Media*/
+	{ USB_DEVICE(0x157e, 0x300e), USB_DEVICE_DATA(&rt2800usb_ops) },
+	/* ZCOM */
+	{ USB_DEVICE(0x0cde, 0x0022), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0cde, 0x0025), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Zinwell */
+	{ USB_DEVICE(0x5a57, 0x0280), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x5a57, 0x0282), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x5a57, 0x0283), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x5a57, 0x5257), USB_DEVICE_DATA(&rt2800usb_ops) },
-#endif
+	/* Zyxel */
+	{ USB_DEVICE(0x0586, 0x3416), USB_DEVICE_DATA(&rt2800usb_ops) },
 #ifdef CONFIG_RT2800USB_RT33XX
 	/* Ralink */
 	{ USB_DEVICE(0x148f, 0x3370), USB_DEVICE_DATA(&rt2800usb_ops) },
-- 
1.7.2.3

