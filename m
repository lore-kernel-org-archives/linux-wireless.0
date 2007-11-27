Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:23631 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbXK0Tjj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 14:39:39 -0500
Received: by ug-out-1314.google.com with SMTP id z38so1321058ugc
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2007 11:39:38 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 01/11] rt2x00: Replace DRV_NAME with KBUILD_MODNAME
Date: Tue, 27 Nov 2007 21:47:34 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200711272146.53518.IvDoorn@gmail.com>
In-Reply-To: <200711272146.53518.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200711272147.34175.IvDoorn@gmail.com> (sfid-20071127_200527_488920_EB850994)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

DRV_NAME was always set to the KBUILD_MODNAME value,
lets clean everything up by removing DRV_NAME and just
use KBUILD_MODNAME directly.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c      |    9 ++-------
 drivers/net/wireless/rt2x00/rt2500pci.c      |    9 ++-------
 drivers/net/wireless/rt2x00/rt2500usb.c      |    9 ++-------
 drivers/net/wireless/rt2x00/rt2x00.h         |    3 +--
 drivers/net/wireless/rt2x00/rt2x00config.c   |    5 -----
 drivers/net/wireless/rt2x00/rt2x00debug.c    |    5 -----
 drivers/net/wireless/rt2x00/rt2x00dev.c      |    5 -----
 drivers/net/wireless/rt2x00/rt2x00firmware.c |    5 -----
 drivers/net/wireless/rt2x00/rt2x00mac.c      |    5 -----
 drivers/net/wireless/rt2x00/rt2x00pci.c      |    5 -----
 drivers/net/wireless/rt2x00/rt2x00rfkill.c   |    5 -----
 drivers/net/wireless/rt2x00/rt2x00usb.c      |    5 -----
 drivers/net/wireless/rt2x00/rt61pci.c        |    9 ++-------
 drivers/net/wireless/rt2x00/rt73usb.c        |    9 ++-------
 14 files changed, 11 insertions(+), 77 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index bdf3edc..6d3cdaf 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -24,11 +24,6 @@
 	Supported chipsets: RT2460.
  */
 
-/*
- * Set enviroment defines for rt2x00.h
- */
-#define DRV_NAME "rt2400pci"
-
 #include <linux/delay.h>
 #include <linux/etherdevice.h>
 #include <linux/init.h>
@@ -1610,7 +1605,7 @@ static const struct rt2x00lib_ops rt2400pci_rt2x00_ops = {
 };
 
 static const struct rt2x00_ops rt2400pci_ops = {
-	.name		= DRV_NAME,
+	.name		= KBUILD_MODNAME,
 	.rxd_size	= RXD_DESC_SIZE,
 	.txd_size	= TXD_DESC_SIZE,
 	.eeprom_size	= EEPROM_SIZE,
@@ -1638,7 +1633,7 @@ MODULE_DEVICE_TABLE(pci, rt2400pci_device_table);
 MODULE_LICENSE("GPL");
 
 static struct pci_driver rt2400pci_driver = {
-	.name		= DRV_NAME,
+	.name		= KBUILD_MODNAME,
 	.id_table	= rt2400pci_device_table,
 	.probe		= rt2x00pci_probe,
 	.remove		= __devexit_p(rt2x00pci_remove),
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index b6bb964..a623454 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -24,11 +24,6 @@
 	Supported chipsets: RT2560.
  */
 
-/*
- * Set enviroment defines for rt2x00.h
- */
-#define DRV_NAME "rt2500pci"
-
 #include <linux/delay.h>
 #include <linux/etherdevice.h>
 #include <linux/init.h>
@@ -1903,7 +1898,7 @@ static const struct rt2x00lib_ops rt2500pci_rt2x00_ops = {
 };
 
 static const struct rt2x00_ops rt2500pci_ops = {
-	.name		= DRV_NAME,
+	.name		= KBUILD_MODNAME,
 	.rxd_size	= RXD_DESC_SIZE,
 	.txd_size	= TXD_DESC_SIZE,
 	.eeprom_size	= EEPROM_SIZE,
@@ -1931,7 +1926,7 @@ MODULE_DEVICE_TABLE(pci, rt2500pci_device_table);
 MODULE_LICENSE("GPL");
 
 static struct pci_driver rt2500pci_driver = {
-	.name		= DRV_NAME,
+	.name		= KBUILD_MODNAME,
 	.id_table	= rt2500pci_device_table,
 	.probe		= rt2x00pci_probe,
 	.remove		= __devexit_p(rt2x00pci_remove),
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 5bfbac4..f56f3ef 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -24,11 +24,6 @@
 	Supported chipsets: RT2570.
  */
 
-/*
- * Set enviroment defines for rt2x00.h
- */
-#define DRV_NAME "rt2500usb"
-
 #include <linux/delay.h>
 #include <linux/etherdevice.h>
 #include <linux/init.h>
@@ -1790,7 +1785,7 @@ static const struct rt2x00lib_ops rt2500usb_rt2x00_ops = {
 };
 
 static const struct rt2x00_ops rt2500usb_ops = {
-	.name		= DRV_NAME,
+	.name		= KBUILD_MODNAME,
 	.rxd_size	= RXD_DESC_SIZE,
 	.txd_size	= TXD_DESC_SIZE,
 	.eeprom_size	= EEPROM_SIZE,
@@ -1862,7 +1857,7 @@ MODULE_DEVICE_TABLE(usb, rt2500usb_device_table);
 MODULE_LICENSE("GPL");
 
 static struct usb_driver rt2500usb_driver = {
-	.name		= DRV_NAME,
+	.name		= KBUILD_MODNAME,
 	.id_table	= rt2500usb_device_table,
 	.probe		= rt2x00usb_probe,
 	.disconnect	= rt2x00usb_disconnect,
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 84b0fc9..b2283ce 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -41,7 +41,6 @@
 
 /*
  * Module information.
- * DRV_NAME should be set within the individual module source files.
  */
 #define DRV_VERSION	"2.0.12"
 #define DRV_PROJECT	"http://rt2x00.serialmonkey.com"
@@ -56,7 +55,7 @@
 
 #define DEBUG_PRINTK_PROBE(__kernlvl, __lvl, __msg, __args...)	\
 	printk(__kernlvl "%s -> %s: %s - " __msg,		\
-	       DRV_NAME, __FUNCTION__, __lvl, ##__args)
+	       KBUILD_MODNAME, __FUNCTION__, __lvl, ##__args)
 
 #ifdef CONFIG_RT2X00_DEBUG
 #define DEBUG_PRINTK(__dev, __kernlvl, __lvl, __msg, __args...)	\
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 9f0733b..72cfe00 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -23,11 +23,6 @@
 	Abstract: rt2x00 generic configuration routines.
  */
 
-/*
- * Set enviroment defines for rt2x00.h
- */
-#define DRV_NAME "rt2x00lib"
-
 #include <linux/kernel.h>
 #include <linux/module.h>
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index 9275d6f..6dc9a25 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -23,11 +23,6 @@
 	Abstract: rt2x00 debugfs specific routines.
  */
 
-/*
- * Set enviroment defines for rt2x00.h
- */
-#define DRV_NAME "rt2x00lib"
-
 #include <linux/debugfs.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 3ab1fb9..e894978 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -23,11 +23,6 @@
 	Abstract: rt2x00 generic device routines.
  */
 
-/*
- * Set enviroment defines for rt2x00.h
- */
-#define DRV_NAME "rt2x00lib"
-
 #include <linux/kernel.h>
 #include <linux/module.h>
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00firmware.c b/drivers/net/wireless/rt2x00/rt2x00firmware.c
index 236025f..0a475e4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00firmware.c
+++ b/drivers/net/wireless/rt2x00/rt2x00firmware.c
@@ -23,11 +23,6 @@
 	Abstract: rt2x00 firmware loading routines.
  */
 
-/*
- * Set enviroment defines for rt2x00.h
- */
-#define DRV_NAME "rt2x00lib"
-
 #include <linux/crc-itu-t.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 85ea8a8..e216c34 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -23,11 +23,6 @@
 	Abstract: rt2x00 generic mac80211 routines.
  */
 
-/*
- * Set enviroment defines for rt2x00.h
- */
-#define DRV_NAME "rt2x00lib"
-
 #include <linux/kernel.h>
 #include <linux/module.h>
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 30ef4f9..e654568 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -23,11 +23,6 @@
 	Abstract: rt2x00 generic pci device routines.
  */
 
-/*
- * Set enviroment defines for rt2x00.h
- */
-#define DRV_NAME "rt2x00pci"
-
 #include <linux/dma-mapping.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
diff --git a/drivers/net/wireless/rt2x00/rt2x00rfkill.c b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
index 16d365d..bbbf51d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00rfkill.c
+++ b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
@@ -23,11 +23,6 @@
 	Abstract: rt2x00 rfkill routines.
  */
 
-/*
- * Set enviroment defines for rt2x00.h
- */
-#define DRV_NAME "rt2x00lib"
-
 #include <linux/input-polldev.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 936e554..152058f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -23,11 +23,6 @@
 	Abstract: rt2x00 generic usb device routines.
  */
 
-/*
- * Set enviroment defines for rt2x00.h
- */
-#define DRV_NAME "rt2x00usb"
-
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/usb.h>
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index c2b4509..924f415 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -24,11 +24,6 @@
 	Supported chipsets: RT2561, RT2561s, RT2661.
  */
 
-/*
- * Set enviroment defines for rt2x00.h
- */
-#define DRV_NAME "rt61pci"
-
 #include <linux/delay.h>
 #include <linux/etherdevice.h>
 #include <linux/init.h>
@@ -2498,7 +2493,7 @@ static const struct rt2x00lib_ops rt61pci_rt2x00_ops = {
 };
 
 static const struct rt2x00_ops rt61pci_ops = {
-	.name		= DRV_NAME,
+	.name		= KBUILD_MODNAME,
 	.rxd_size	= RXD_DESC_SIZE,
 	.txd_size	= TXD_DESC_SIZE,
 	.eeprom_size	= EEPROM_SIZE,
@@ -2535,7 +2530,7 @@ MODULE_FIRMWARE(FIRMWARE_RT2661);
 MODULE_LICENSE("GPL");
 
 static struct pci_driver rt61pci_driver = {
-	.name		= DRV_NAME,
+	.name		= KBUILD_MODNAME,
 	.id_table	= rt61pci_device_table,
 	.probe		= rt2x00pci_probe,
 	.remove		= __devexit_p(rt2x00pci_remove),
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 4d1227a..49180de 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -24,11 +24,6 @@
 	Supported chipsets: rt2571W & rt2671.
  */
 
-/*
- * Set enviroment defines for rt2x00.h
- */
-#define DRV_NAME "rt73usb"
-
 #include <linux/delay.h>
 #include <linux/etherdevice.h>
 #include <linux/init.h>
@@ -2046,7 +2041,7 @@ static const struct rt2x00lib_ops rt73usb_rt2x00_ops = {
 };
 
 static const struct rt2x00_ops rt73usb_ops = {
-	.name		= DRV_NAME,
+	.name		= KBUILD_MODNAME,
 	.rxd_size	= RXD_DESC_SIZE,
 	.txd_size	= TXD_DESC_SIZE,
 	.eeprom_size	= EEPROM_SIZE,
@@ -2133,7 +2128,7 @@ MODULE_FIRMWARE(FIRMWARE_RT2571);
 MODULE_LICENSE("GPL");
 
 static struct usb_driver rt73usb_driver = {
-	.name		= DRV_NAME,
+	.name		= KBUILD_MODNAME,
 	.id_table	= rt73usb_device_table,
 	.probe		= rt2x00usb_probe,
 	.disconnect	= rt2x00usb_disconnect,
-- 
1.5.3.6

