Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:55886 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754758AbZAYOuW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2009 09:50:22 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John W Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Dynamically control log verbosity
Date: Sun, 25 Jan 2009 15:49:59 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200901251550.00288.mb@bu3sch.de> (sfid-20090125_155028_483192_81270856)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dynamically control the log verbosity with a module parameter.
This enables us to dynamically enable debugging messages (or disable
info, warn, error messages) via module parameter or /sys/module/b43/parameters/verbose.

This increases the module size by about 3k. But in practice it reduces the
module size for the user, because some distributions ship the b43 module
with CONFIG_B43_DEBUG set, which increases the module by about 15k.

So with this patch applied, distributions should really _disable_ CONFIG_B43_DEBUG.
There is no reason to keep it in a production-release kernel.
So we have a net reduction in size by about 12k.

This patch also adds a printk of the wireless core revision, so people
don't have to enable SSB debugging to get the wireless core revision.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please queue for the next feature push.


Index: wireless-testing/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/b43.h	2009-01-25 15:29:55.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/b43.h	2009-01-25 15:31:41.000000000 +0100
@@ -875,18 +875,15 @@ static inline bool b43_using_pio_transfe
 void b43info(struct b43_wl *wl, const char *fmt, ...)
     __attribute__ ((format(printf, 2, 3)));
 void b43err(struct b43_wl *wl, const char *fmt, ...)
     __attribute__ ((format(printf, 2, 3)));
 void b43warn(struct b43_wl *wl, const char *fmt, ...)
     __attribute__ ((format(printf, 2, 3)));
-#if B43_DEBUG
 void b43dbg(struct b43_wl *wl, const char *fmt, ...)
     __attribute__ ((format(printf, 2, 3)));
-#else /* DEBUG */
-# define b43dbg(wl, fmt...) do { /* nothing */ } while (0)
-#endif /* DEBUG */
+
 
 /* A WARN_ON variant that vanishes when b43 debugging is disabled.
  * This _also_ evaluates the arg with debugging disabled. */
 #if B43_DEBUG
 # define B43_WARN_ON(x)	WARN_ON(x)
 #else
Index: wireless-testing/drivers/net/wireless/b43/debugfs.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/debugfs.c	2009-01-25 15:29:55.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/debugfs.c	2009-01-25 15:31:41.000000000 +0100
@@ -694,15 +694,24 @@ B43_DEBUGFS_FOPS(mmio32write, NULL, mmio
 B43_DEBUGFS_FOPS(tsf, tsf_read_file, tsf_write_file, 1);
 B43_DEBUGFS_FOPS(txstat, txstat_read_file, NULL, 0);
 B43_DEBUGFS_FOPS(restart, NULL, restart_write_file, 1);
 B43_DEBUGFS_FOPS(loctls, loctls_read_file, NULL, 0);
 
 
-int b43_debug(struct b43_wldev *dev, enum b43_dyndbg feature)
+bool b43_debug(struct b43_wldev *dev, enum b43_dyndbg feature)
 {
-	return !!(dev->dfsentry && dev->dfsentry->dyn_debug[feature]);
+	bool enabled;
+
+	enabled = (dev->dfsentry && dev->dfsentry->dyn_debug[feature]);
+	if (unlikely(enabled)) {
+		/* Force full debugging messages, if the user enabled
+		 * some dynamic debugging feature. */
+		b43_modparam_verbose = B43_VERBOSITY_MAX;
+	}
+
+	return enabled;
 }
 
 static void b43_remove_dynamic_debug(struct b43_wldev *dev)
 {
 	struct b43_dfsentry *e = dev->dfsentry;
 	int i;
Index: wireless-testing/drivers/net/wireless/b43/debugfs.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/debugfs.h	2009-01-25 15:29:55.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/debugfs.h	2009-01-25 15:31:41.000000000 +0100
@@ -69,24 +69,24 @@ struct b43_dfsentry {
 	/* Enabled/Disabled list for the dynamic debugging features. */
 	u32 dyn_debug[__B43_NR_DYNDBG];
 	/* Dentries for the dynamic debugging entries. */
 	struct dentry *dyn_debug_dentries[__B43_NR_DYNDBG];
 };
 
-int b43_debug(struct b43_wldev *dev, enum b43_dyndbg feature);
+bool b43_debug(struct b43_wldev *dev, enum b43_dyndbg feature);
 
 void b43_debugfs_init(void);
 void b43_debugfs_exit(void);
 void b43_debugfs_add_device(struct b43_wldev *dev);
 void b43_debugfs_remove_device(struct b43_wldev *dev);
 void b43_debugfs_log_txstat(struct b43_wldev *dev,
 			    const struct b43_txstatus *status);
 
 #else /* CONFIG_B43_DEBUG */
 
-static inline int b43_debug(struct b43_wldev *dev, enum b43_dyndbg feature)
+static inline bool b43_debug(struct b43_wldev *dev, enum b43_dyndbg feature)
 {
 	return 0;
 }
 
 static inline void b43_debugfs_init(void)
 {
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-01-25 15:29:55.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/main.c	2009-01-25 15:31:41.000000000 +0100
@@ -1,13 +1,13 @@
 /*
 
   Broadcom B43 wireless driver
 
   Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>
   Copyright (c) 2005 Stefano Brivio <stefano.brivio@polimi.it>
-  Copyright (c) 2005, 2006 Michael Buesch <mb@bu3sch.de>
+  Copyright (c) 2005-2009 Michael Buesch <mb@bu3sch.de>
   Copyright (c) 2005 Danny van Dyk <kugelfang@gentoo.org>
   Copyright (c) 2005 Andreas Jaggi <andreas.jaggi@waterwave.ch>
 
   Some parts of the code in this file are derived from the ipw2200
   driver  Copyright(c) 2003 - 2004 Intel Corporation.
 
@@ -85,12 +85,16 @@ module_param_named(qos, b43_modparam_qos
 MODULE_PARM_DESC(qos, "Enable QOS support (default on)");
 
 static int modparam_btcoex = 1;
 module_param_named(btcoex, modparam_btcoex, int, 0444);
 MODULE_PARM_DESC(btcoex, "Enable Bluetooth coexistance (default on)");
 
+int b43_modparam_verbose = B43_VERBOSITY_DEFAULT;
+module_param_named(verbose, b43_modparam_verbose, int, 0644);
+MODULE_PARM_DESC(verbose, "Log message verbosity: 0=error, 1=warn, 2=info(default), 3=debug");
+
 
 static const struct ssb_device_id b43_ssb_tbl[] = {
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 5),
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 6),
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 7),
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 9),
@@ -297,12 +301,14 @@ static int b43_ratelimit(struct b43_wl *
 }
 
 void b43info(struct b43_wl *wl, const char *fmt, ...)
 {
 	va_list args;
 
+	if (b43_modparam_verbose < B43_VERBOSITY_INFO)
+		return;
 	if (!b43_ratelimit(wl))
 		return;
 	va_start(args, fmt);
 	printk(KERN_INFO "b43-%s: ",
 	       (wl && wl->hw) ? wiphy_name(wl->hw->wiphy) : "wlan");
 	vprintk(fmt, args);
@@ -310,12 +316,14 @@ void b43info(struct b43_wl *wl, const ch
 }
 
 void b43err(struct b43_wl *wl, const char *fmt, ...)
 {
 	va_list args;
 
+	if (b43_modparam_verbose < B43_VERBOSITY_ERROR)
+		return;
 	if (!b43_ratelimit(wl))
 		return;
 	va_start(args, fmt);
 	printk(KERN_ERR "b43-%s ERROR: ",
 	       (wl && wl->hw) ? wiphy_name(wl->hw->wiphy) : "wlan");
 	vprintk(fmt, args);
@@ -323,33 +331,35 @@ void b43err(struct b43_wl *wl, const cha
 }
 
 void b43warn(struct b43_wl *wl, const char *fmt, ...)
 {
 	va_list args;
 
+	if (b43_modparam_verbose < B43_VERBOSITY_WARN)
+		return;
 	if (!b43_ratelimit(wl))
 		return;
 	va_start(args, fmt);
 	printk(KERN_WARNING "b43-%s warning: ",
 	       (wl && wl->hw) ? wiphy_name(wl->hw->wiphy) : "wlan");
 	vprintk(fmt, args);
 	va_end(args);
 }
 
-#if B43_DEBUG
 void b43dbg(struct b43_wl *wl, const char *fmt, ...)
 {
 	va_list args;
 
+	if (b43_modparam_verbose < B43_VERBOSITY_DEBUG)
+		return;
 	va_start(args, fmt);
 	printk(KERN_DEBUG "b43-%s debug: ",
 	       (wl && wl->hw) ? wiphy_name(wl->hw->wiphy) : "wlan");
 	vprintk(fmt, args);
 	va_end(args);
 }
-#endif /* DEBUG */
 
 static void b43_ram_write(struct b43_wldev *dev, u16 offset, u32 val)
 {
 	u32 macctl;
 
 	B43_WARN_ON(offset % 4 != 0);
@@ -3549,15 +3559,13 @@ static int b43_op_set_key(struct ieee802
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev;
 	u8 algorithm;
 	u8 index;
 	int err;
-#if B43_DEBUG
-	static const u8 bcast_addr[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
-#endif
+	static const u8 bcast_addr[ETH_ALEN] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
 
 	if (modparam_nohwcrypt)
 		return -ENOSPC; /* User disabled HW-crypto */
 
 	mutex_lock(&wl->mutex);
 	spin_lock_irq(&wl->irq_lock);
@@ -4702,15 +4710,16 @@ static int b43_wireless_init(struct ssb_
 	mutex_init(&wl->mutex);
 	INIT_LIST_HEAD(&wl->devlist);
 	INIT_WORK(&wl->beacon_update_trigger, b43_beacon_update_trigger_work);
 	INIT_WORK(&wl->txpower_adjust_work, b43_phy_txpower_adjust_work);
 
 	ssb_set_devtypedata(dev, wl);
-	b43info(wl, "Broadcom %04X WLAN found\n", dev->bus->chip_id);
+	b43info(wl, "Broadcom %04X WLAN found (core revision %u)\n",
+		dev->bus->chip_id, dev->id.revision);
 	err = 0;
-      out:
+out:
 	return err;
 }
 
 static int b43_probe(struct ssb_device *dev, const struct ssb_device_id *id)
 {
 	struct b43_wl *wl;
Index: wireless-testing/drivers/net/wireless/b43/main.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.h	2009-01-25 15:29:55.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/main.h	2009-01-25 15:31:41.000000000 +0100
@@ -37,12 +37,30 @@
 #define P4D_BYTES(line, nr_bytes)	P4D_BYT3S(line, nr_bytes)
 /* Magic helper macro to pad structures. Ignore those above. It's magic. */
 #define PAD_BYTES(nr_bytes)		P4D_BYTES( __LINE__ , (nr_bytes))
 
 
 extern int b43_modparam_qos;
+extern int b43_modparam_verbose;
+
+/* Logmessage verbosity levels. Update the b43_modparam_verbose helptext, if
+ * you add or remove levels. */
+enum b43_verbosity {
+	B43_VERBOSITY_ERROR,
+	B43_VERBOSITY_WARN,
+	B43_VERBOSITY_INFO,
+	B43_VERBOSITY_DEBUG,
+	__B43_VERBOSITY_AFTERLAST, /* keep last */
+
+	B43_VERBOSITY_MAX = __B43_VERBOSITY_AFTERLAST - 1,
+#if B43_DEBUG
+	B43_VERBOSITY_DEFAULT = B43_VERBOSITY_DEBUG,
+#else
+	B43_VERBOSITY_DEFAULT = B43_VERBOSITY_INFO,
+#endif
+};
 
 
 /* Lightweight function to convert a frequency (in Mhz) to a channel number. */
 static inline u8 b43_freq_to_channel_5ghz(int freq)
 {
 	return ((freq - 5000) / 5);
Index: wireless-testing/drivers/net/wireless/b43/Kconfig
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/Kconfig	2009-01-25 15:29:55.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/Kconfig	2009-01-25 15:31:41.000000000 +0100
@@ -107,16 +107,24 @@ config B43_RFKILL
 	default y
 
 config B43_DEBUG
 	bool "Broadcom 43xx debugging"
 	depends on B43
 	---help---
-	  Broadcom 43xx debugging messages.
+	  Broadcom 43xx debugging.
 
-	  Say Y, if you want to find out why the driver does not
-	  work for you.
+	  This adds additional runtime sanity checks and statistics to the driver.
+	  These checks and statistics might me expensive and hurt runtime performance
+	  of your system.
+	  This also adds the b43 debugfs interface.
+
+	  Do not enable this, unless you are debugging the driver.
+
+	  Say N, if you are a distributor or user building a release kernel
+	  for production use.
+	  Only say Y, if you are debugging a problem in the b43 driver sourcecode.
 
 config B43_FORCE_PIO
 	bool "Force usage of PIO instead of DMA"
 	depends on B43 && B43_DEBUG
 	---help---
 	  This will disable DMA and always enable PIO instead.

-- 
Greetings, Michael.
