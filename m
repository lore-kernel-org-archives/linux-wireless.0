Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:49309 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461AbXB1OHZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 09:07:25 -0500
Received: by nf-out-0910.google.com with SMTP id o25so562649nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 06:07:23 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/28] rt2x00: Make debug option rt2x00-global
Date: Wed, 28 Feb 2007 15:07:12 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702281507.12495.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove per-driver debug option, and replace it with a
rt2x00 global debug option.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/mac80211/rt2x00/Kconfig b/drivers/net/wireless/mac80211/rt2x00/Kconfig
index 7206cb6..491fe08 100644
--- a/drivers/net/wireless/mac80211/rt2x00/Kconfig
+++ b/drivers/net/wireless/mac80211/rt2x00/Kconfig
@@ -16,12 +16,6 @@ config RT2400PCI
 
 	When compiled as a module, this driver will be called "rt2400pci.ko".
 
-config RT2400PCI_DEBUG
-	bool "Ralink rt2400 debug output"
-	depends on RT2400PCI
-	---help---
-	Enable debugging output.
-
 config RT2500PCI
 	tristate "Ralink rt2500 pci/pcmcia support"
 	depends on RT2X00 && PCI
@@ -31,12 +25,6 @@ config RT2500PCI
 
 	When compiled as a module, this driver will be called "rt2500pci.ko".
 
-config RT2500PCI_DEBUG
-	bool "Ralink rt2500 debug output"
-	depends on RT2500PCI
-	---help---
-	Enable debugging output.
-
 config RT61PCI
 	tristate "Ralink rt61 pci/pcmcia support"
 	depends on RT2X00 && FW_LOADER && PCI
@@ -47,12 +35,6 @@ config RT61PCI
 
 	When compiled as a module, this driver will be called "rt61pci.ko".
 
-config RT61PCI_DEBUG
-	bool "Ralink rt61 debug output"
-	depends on RT61PCI
-	---help---
-	Enable debugging output.
-
 config RT2500USB
 	tristate "Ralink rt2500 usb support"
 	depends on RT2X00 && USB
@@ -61,12 +43,6 @@ config RT2500USB
 
 	When compiled as a module, this driver will be called "rt2500usb.ko".
 
-config RT2500USB_DEBUG
-	bool "Ralink rt2500 debug output"
-	depends on RT2500USB
-	---help---
-	Enable debugging output.
-
 config RT73USB
 	tristate "Ralink rt73 usb support"
 	depends on RT2X00 && FW_LOADER && USB
@@ -76,12 +52,6 @@ config RT73USB
 
 	When compiled as a module, this driver will be called "rt73usb.ko".
 
-config RT73USB_DEBUG
-	bool "Ralink rt73 debug output"
-	depends on RT73USB
-	---help---
-	Enable debugging output.
-
 config RT2X00_DEBUGFS
 	tristate "Ralink debugfs support"
 	depends on RT2X00 && DEBUG_FS
@@ -89,3 +59,9 @@ config RT2X00_DEBUGFS
 	Enable creation of debugfs files for the rt2x00 drivers.
 	These debugfs files support both reading and writing of the
 	most important register types of the rt2x00 devices.
+
+config RT2X00_DEBUG
+	bool "Ralink debug output"
+	depends on RT2X00
+	---help---
+	Enable debugging output for all rt2x00 modules
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
index df1e569..14e55b9 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
@@ -47,10 +47,6 @@
  */
 #define DRV_NAME "rt2400pci"
 
-#ifdef CONFIG_RT2400PCI_DEBUG
-#define CONFIG_RT2X00_DEBUG
-#endif /* CONFIG_RT2400PCI_DEBUG */
-
 #include "rt2x00.h"
 #include "rt2x00pci.h"
 #include "rt2400pci.h"
@@ -3037,10 +3033,10 @@ MODULE_SUPPORTED_DEVICE("Ralink RT2460 PCI & PCMCIA chipset based cards");
 MODULE_DEVICE_TABLE(pci, rt2400pci_device_table);
 MODULE_LICENSE("GPL");
 
-#ifdef CONFIG_RT2400PCI_DEBUG
+#ifdef CONFIG_RT2X00_DEBUG
 module_param_named(debug, rt2x00_debug_level, bool, S_IWUSR | S_IRUGO);
 MODULE_PARM_DESC(debug, "Set this parameter to 1 to enable debug output.");
-#endif /* CONFIG_RT2400PCI_DEBUG */
+#endif /* CONFIG_RT2X00_DEBUG */
 
 static struct pci_driver rt2400pci_driver = {
 	.name		= DRV_NAME,
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
index 3594dc5..6722135 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
@@ -47,10 +47,6 @@
  */
 #define DRV_NAME "rt2500pci"
 
-#ifdef CONFIG_RT2500PCI_DEBUG
-#define CONFIG_RT2X00_DEBUG
-#endif /* CONFIG_RT2500PCI_DEBUG */
-
 #include "rt2x00.h"
 #include "rt2x00pci.h"
 #include "rt2500pci.h"
@@ -3349,10 +3345,10 @@ MODULE_SUPPORTED_DEVICE("Ralink RT2560 PCI & PCMCIA chipset based cards");
 MODULE_DEVICE_TABLE(pci, rt2500pci_device_table);
 MODULE_LICENSE("GPL");
 
-#ifdef CONFIG_RT2500PCI_DEBUG
+#ifdef CONFIG_RT2X00_DEBUG
 module_param_named(debug, rt2x00_debug_level, bool, S_IWUSR | S_IRUGO);
 MODULE_PARM_DESC(debug, "Set this parameter to 1 to enable debug output.");
-#endif /* CONFIG_RT2500PCI_DEBUG */
+#endif /* CONFIG_RT2X00_DEBUG */
 
 static struct pci_driver rt2500pci_driver = {
 	.name		= DRV_NAME,
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
index 0a0de18..df155ba 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
@@ -43,10 +43,6 @@
  */
 #define DRV_NAME "rt2500usb"
 
-#ifdef CONFIG_RT2500USB_DEBUG
-#define CONFIG_RT2X00_DEBUG
-#endif /* CONFIG_RT2500USB_DEBUG */
-
 #include "rt2x00.h"
 #include "rt2x00usb.h"
 #include "rt2500usb.h"
@@ -3183,10 +3179,10 @@ MODULE_SUPPORTED_DEVICE("Ralink RT2570 USB chipset based cards");
 MODULE_DEVICE_TABLE(usb, rt2500usb_device_table);
 MODULE_LICENSE("GPL");
 
-#ifdef CONFIG_RT2500USB_DEBUG
+#ifdef CONFIG_RT2X00_DEBUG
 module_param_named(debug, rt2x00_debug_level, bool, S_IWUSR | S_IRUGO);
 MODULE_PARM_DESC(debug, "Set this parameter to 1 to enable debug output.");
-#endif /* CONFIG_RT2500USB_DEBUG */
+#endif /* CONFIG_RT2X00_DEBUG */
 
 static struct usb_driver rt2500usb_driver = {
 	.name		= DRV_NAME,
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
index 757cd9e..abe458e 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
@@ -49,10 +49,6 @@
  */
 #define DRV_NAME "rt61pci"
 
-#ifdef CONFIG_RT61PCI_DEBUG
-#define CONFIG_RT2X00_DEBUG
-#endif /* CONFIG_RT61PCI_DEBUG */
-
 #include "rt2x00.h"
 #include "rt2x00pci.h"
 #include "rt61pci.h"
@@ -3879,10 +3875,10 @@ MODULE_SUPPORTED_DEVICE("Ralink RT2561, RT2561s & RT2661 "
 MODULE_DEVICE_TABLE(pci, rt61pci_device_table);
 MODULE_LICENSE("GPL");
 
-#ifdef CONFIG_RT61PCI_DEBUG
+#ifdef CONFIG_RT2X00_DEBUG
 module_param_named(debug, rt2x00_debug_level, bool, S_IWUSR | S_IRUGO);
 MODULE_PARM_DESC(debug, "Set this parameter to 1 to enable debug output.");
-#endif /* CONFIG_RT61PCI_DEBUG */
+#endif /* CONFIG_RT2X00_DEBUG */
 
 static struct pci_driver rt61pci_driver = {
 	.name		= DRV_NAME,
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
index 7311764..9626cf1 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
@@ -45,10 +45,6 @@
  */
 #define DRV_NAME "rt73usb"
 
-#ifdef CONFIG_RT73USB_DEBUG
-#define CONFIG_RT2X00_DEBUG
-#endif /* CONFIG_RT73USB_DEBUG */
-
 #include "rt2x00.h"
 #include "rt2x00usb.h"
 #include "rt73usb.h"
@@ -3519,10 +3515,10 @@ MODULE_SUPPORTED_DEVICE("Ralink RT2573 USB chipset based cards");
 MODULE_DEVICE_TABLE(usb, rt73usb_device_table);
 MODULE_LICENSE("GPL");
 
-#ifdef CONFIG_RT73USB_DEBUG
+#ifdef CONFIG_RT2X00_DEBUG
 module_param_named(debug, rt2x00_debug_level, bool, S_IWUSR | S_IRUGO);
 MODULE_PARM_DESC(debug, "Set this parameter to 1 to enable debug output.");
-#endif /* CONFIG_RT73USB_DEBUG */
+#endif /* CONFIG_RT2X00_DEBUG */
 
 static struct usb_driver rt73usb_driver = {
 	.name		= DRV_NAME,
