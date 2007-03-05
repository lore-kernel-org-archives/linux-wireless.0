Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:51389 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932190AbXCESx3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2007 13:53:29 -0500
Received: by ug-out-1314.google.com with SMTP id 44so1335977uga
        for <linux-wireless@vger.kernel.org>; Mon, 05 Mar 2007 10:53:27 -0800 (PST)
To: "John Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Move rt2x00debug include file
Date: Mon, 5 Mar 2007 19:53:18 +0100
Cc: linux-wireless@vger.kernel.org
References: <200703051920.25011.IvDoorn@gmail.com>
In-Reply-To: <200703051920.25011.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200703051953.18515.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that we are working on rt2x00debug anyway,
lets remove the #if statements about RT2X00_DEBUGFS
from rt2x00.h and completely handle it in the drivers.

This will remove the ugly define CONFIG_RT2X00_DEBUGFS hack
And the rt2x00_dev structure is only increased slightly because
of the void* pointer.
The rt2x00_debugfs.h needs to be included inside the drivers.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
index 4f612a0..93da031 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
@@ -186,7 +186,9 @@ rf_write:
 	rt2x00_register_write(rt2x00dev, RFCSR, reg);
 }
 
-#ifdef CONFIG_RT2X00_DEBUGFS
+#if defined(CONFIG_RT2X00_DEBUGFS) || defined(CONFIG_RT2X00_DEBUGFS_MODULE)
+#include "rt2x00debug.h"
+
 #define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u32)) )
 
 static void rt2400pci_read_csr(struct rt2x00_dev *rt2x00dev,
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
index 46ca323..1e659aa 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
@@ -186,7 +186,9 @@ rf_write:
 	rt2x00_register_write(rt2x00dev, RFCSR, reg);
 }
 
-#ifdef CONFIG_RT2X00_DEBUGFS
+#if defined(CONFIG_RT2X00_DEBUGFS) || defined(CONFIG_RT2X00_DEBUGFS_MODULE)
+#include "rt2x00debug.h"
+
 #define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u32)) )
 
 static void rt2500pci_read_csr(struct rt2x00_dev *rt2x00dev,
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
index 8c2b955..b9eda8d 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
@@ -228,7 +228,9 @@ rf_write:
 	rt2x00_register_write(rt2x00dev, PHY_CSR10, reg);
 }
 
-#ifdef CONFIG_RT2X00_DEBUGFS
+#if defined(CONFIG_RT2X00_DEBUGFS) || defined(CONFIG_RT2X00_DEBUGFS_MODULE)
+#include "rt2x00debug.h"
+
 #define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u16)) )
 
 static void rt2500usb_read_csr(struct rt2x00_dev *rt2x00dev,
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
index ea05d00..b64d7ee 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
@@ -32,11 +32,6 @@
 #include <linux/workqueue.h>
 #include <net/mac80211.h>
 
-#if defined( CONFIG_RT2X00_DEBUGFS) || defined( CONFIG_RT2X00_DEBUGFS_MODULE)
-#define CONFIG_RT2X00_DEBUGFS
-#include "rt2x00debug.h"
-#endif /* CONFIG_RT2X00_DEBUGFS */
-
 /*
  * Module information.
  */
@@ -983,9 +978,7 @@ struct rt2x00_dev {
 	/*
 	 * If enabled, the structure for the debugfs files.
 	 */
-#ifdef CONFIG_RT2X00_DEBUGFS
 	void *debugfs_data;
-#endif /* CONFIG_RT2X00_DEBUGFS */
 
 	/*
 	 * Queue for deferred work.
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
index 029b506..21278c6 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
@@ -217,7 +217,9 @@ static void rt2x00_mcu_request(const struct rt2x00_dev *rt2x00dev,
 	rt2x00_register_write(rt2x00dev, HOST_CMD_CSR, reg);
 }
 
-#ifdef CONFIG_RT2X00_DEBUGFS
+#if defined(CONFIG_RT2X00_DEBUGFS) || defined(CONFIG_RT2X00_DEBUGFS_MODULE)
+#include "rt2x00debug.h"
+
 #define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u32)) )
 
 static void rt61pci_read_csr(struct rt2x00_dev *rt2x00dev,
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
index c27bdcc..9ede5fa 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
@@ -224,7 +224,9 @@ rf_write:
 	rt2x00_register_write(rt2x00dev, PHY_CSR4, reg);
 }
 
-#ifdef CONFIG_RT2X00_DEBUGFS
+#if defined(CONFIG_RT2X00_DEBUGFS) || defined(CONFIG_RT2X00_DEBUGFS_MODULE)
+#include "rt2x00debug.h"
+
 #define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u32)) )
 
 static void rt73usb_read_csr(struct rt2x00_dev *rt2x00dev,
