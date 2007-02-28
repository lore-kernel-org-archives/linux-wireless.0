Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:48635 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932420AbXB1OHN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 09:07:13 -0500
Received: by nf-out-0910.google.com with SMTP id o25so562562nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 06:07:11 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 27/28] rt2x00: Include cleanup
Date: Wed, 28 Feb 2007 15:07:06 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702281507.06387.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup includes a bit.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
index f1e3624..04ceda9 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
@@ -24,6 +24,11 @@
 	Supported chipsets: RT2460.
  */
 
+/*
+ * Set enviroment defines for rt2x00.h
+ */
+#define DRV_NAME "rt2400pci"
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/version.h>
@@ -31,22 +36,11 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
-#include <linux/skbuff.h>
-#include <linux/netdevice.h>
 #include <linux/etherdevice.h>
-#include <linux/wireless.h>
 #include <linux/eeprom_93cx6.h>
 
-#include <net/iw_handler.h>
-#include <net/mac80211.h>
-
 #include <asm/io.h>
 
-/*
- * Set enviroment defines for rt2x00.h
- */
-#define DRV_NAME "rt2400pci"
-
 #include "rt2x00.h"
 #include "rt2x00lib.h"
 #include "rt2x00pci.h"
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
index 06562e1..e1f244e 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
@@ -24,6 +24,11 @@
 	Supported chipsets: RT2560.
  */
 
+/*
+ * Set enviroment defines for rt2x00.h
+ */
+#define DRV_NAME "rt2500pci"
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/version.h>
@@ -31,22 +36,11 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
-#include <linux/skbuff.h>
-#include <linux/netdevice.h>
 #include <linux/etherdevice.h>
-#include <linux/wireless.h>
 #include <linux/eeprom_93cx6.h>
 
-#include <net/iw_handler.h>
-#include <net/mac80211.h>
-
 #include <asm/io.h>
 
-/*
- * Set enviroment defines for rt2x00.h
- */
-#define DRV_NAME "rt2500pci"
-
 #include "rt2x00.h"
 #include "rt2x00lib.h"
 #include "rt2x00pci.h"
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
index 32dcc06..47d4a78 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
@@ -24,24 +24,18 @@
 	Supported chipsets: RT2570.
  */
 
+/*
+ * Set enviroment defines for rt2x00.h
+ */
+#define DRV_NAME "rt2500usb"
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/version.h>
 #include <linux/init.h>
 #include <linux/usb.h>
 #include <linux/delay.h>
-#include <linux/skbuff.h>
-#include <linux/netdevice.h>
 #include <linux/etherdevice.h>
-#include <linux/wireless.h>
-
-#include <net/iw_handler.h>
-#include <net/mac80211.h>
-
-/*
- * Set enviroment defines for rt2x00.h
- */
-#define DRV_NAME "rt2500usb"
 
 #include "rt2x00.h"
 #include "rt2x00lib.h"
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
index bd15702..743eccc 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
@@ -28,6 +28,10 @@
 #ifndef RT2X00_H
 #define RT2X00_H
 
+#include <linux/skbuff.h>
+#include <linux/workqueue.h>
+#include <net/mac80211.h>
+
 #if defined( CONFIG_RT2X00_DEBUGFS) || defined( CONFIG_RT2X00_DEBUGFS_MODULE)
 #define CONFIG_RT2X00_DEBUGFS
 #include "rt2x00debug.h"
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00lib.c b/drivers/net/wireless/mac80211/rt2x00/rt2x00lib.c
index 33fd035..e882182 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00lib.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00lib.c
@@ -37,8 +37,6 @@
 #include <linux/delay.h>
 #include <linux/netdevice.h>
 
-#include <net/mac80211.h>
-
 #include "rt2x00.h"
 #include "rt2x00lib.h"
 
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
index f160e66..3625843 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
@@ -24,6 +24,11 @@
 	Supported chipsets: RT2561, RT2561s, RT2661.
  */
 
+/*
+ * Set enviroment defines for rt2x00.h
+ */
+#define DRV_NAME "rt61pci"
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/version.h>
@@ -31,24 +36,13 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
-#include <linux/skbuff.h>
-#include <linux/netdevice.h>
 #include <linux/etherdevice.h>
-#include <linux/wireless.h>
 #include <linux/eeprom_93cx6.h>
 #include <linux/firmware.h>
 #include <linux/crc-itu-t.h>
 
-#include <net/iw_handler.h>
-#include <net/mac80211.h>
-
 #include <asm/io.h>
 
-/*
- * Set enviroment defines for rt2x00.h
- */
-#define DRV_NAME "rt61pci"
-
 #include "rt2x00.h"
 #include "rt2x00lib.h"
 #include "rt2x00pci.h"
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
index e75a478..170fbb6 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
@@ -24,27 +24,21 @@
 	Supported chipsets: RT2573.
  */
 
+/*
+ * Set enviroment defines for rt2x00.h
+ */
+#define DRV_NAME "rt73usb"
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/version.h>
 #include <linux/init.h>
 #include <linux/usb.h>
 #include <linux/delay.h>
-#include <linux/skbuff.h>
-#include <linux/netdevice.h>
 #include <linux/etherdevice.h>
-#include <linux/wireless.h>
 #include <linux/firmware.h>
 #include <linux/crc-itu-t.h>
 
-#include <net/iw_handler.h>
-#include <net/mac80211.h>
-
-/*
- * Set enviroment defines for rt2x00.h
- */
-#define DRV_NAME "rt73usb"
-
 #include "rt2x00.h"
 #include "rt2x00lib.h"
 #include "rt2x00usb.h"
