Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:26701 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961Ab1BQWQe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 17:16:34 -0500
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000022243.msg
	for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 00:15:56 +0200
Subject: Re: [RFC] AI support (2/14 ssb helpers)
From: George Kashperko <george@znau.edu.ua>
To: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1297980093.13554.5.camel@maggie>
References: <1297958316.5623.27.camel@dev.znau.edu.ua>
	 (sfid-20110217_170718_357395_57E8418D)  <1297980093.13554.5.camel@maggie>
Content-Type: text/plain
Date: Fri, 18 Feb 2011 00:08:04 +0200
Message-Id: <1297980484.23381.4.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: George Kashperko <george@znau.edu.ua>

Reintroduce ssb device enable, disable, is_enabled, admatch base and size
routines as device helpers. This is required for transparent support for AI-style
SB buses later on. As soon as exported routines were just replaced by device
helpers with appropriate inline accessors these changes won't impact
any ssb-related code.
Signed-off-by: George Kashperko <george@znau.edu.ua>
---
 drivers/ssb/main.c        |   23 ++++++++++++---------
 drivers/ssb/scan.c        |    1 
 drivers/ssb/ssb_private.h |    2 +
 include/linux/ssb/ssb.h   |   39 +++++++++++++++++++++++++++++-------
 4 files changed, 48 insertions(+), 17 deletions(-)
--- linux-wireless-testing.orig/drivers/ssb/main.c	2011-02-17 14:02:39.000000000 +0200
+++ linux-wireless-testing/drivers/ssb/main.c	2011-02-17 14:02:57.000000000 +0200
@@ -1136,7 +1136,7 @@ static u32 ssb_tmslow_reject_bitmask(str
 	return (SSB_TMSLOW_REJECT_22 | SSB_TMSLOW_REJECT_23);
 }
 
-int ssb_device_is_enabled(struct ssb_device *dev)
+static int ssb_device_is_enabled_sb(struct ssb_device *dev)
 {
 	u32 val;
 	u32 reject;
@@ -1147,7 +1147,6 @@ int ssb_device_is_enabled(struct ssb_dev
 
 	return (val == SSB_TMSLOW_CLOCK);
 }
-EXPORT_SYMBOL(ssb_device_is_enabled);
 
 static void ssb_flush_tmslow(struct ssb_device *dev)
 {
@@ -1161,7 +1160,7 @@ static void ssb_flush_tmslow(struct ssb_
 	udelay(1);
 }
 
-void ssb_device_enable(struct ssb_device *dev, u32 core_specific_flags)
+static void ssb_device_enable_sb(struct ssb_device *dev, u32 core_specific_flags)
 {
 	u32 val;
 
@@ -1190,7 +1189,6 @@ void ssb_device_enable(struct ssb_device
 		    core_specific_flags);
 	ssb_flush_tmslow(dev);
 }
-EXPORT_SYMBOL(ssb_device_enable);
 
 /* Wait for a bit in a register to get set or unset.
  * timeout is in units of ten-microseconds */
@@ -1218,7 +1216,7 @@ static int ssb_wait_bit(struct ssb_devic
 	return -ETIMEDOUT;
 }
 
-void ssb_device_disable(struct ssb_device *dev, u32 core_specific_flags)
+static void ssb_device_disable_sb(struct ssb_device *dev, u32 core_specific_flags)
 {
 	u32 reject;
 
@@ -1240,7 +1238,6 @@ void ssb_device_disable(struct ssb_devic
 		    core_specific_flags);
 	ssb_flush_tmslow(dev);
 }
-EXPORT_SYMBOL(ssb_device_disable);
 
 u32 ssb_dma_translation(struct ssb_device *dev)
 {
@@ -1312,7 +1309,7 @@ error:
 }
 EXPORT_SYMBOL(ssb_bus_powerup);
 
-u32 ssb_admatch_base(struct ssb_device *dev, u32 adm)
+static u32 ssb_admatch_base_sb(struct ssb_device *dev, u32 adm)
 {
 	u32 base = 0;
 
@@ -1336,9 +1333,8 @@ u32 ssb_admatch_base(struct ssb_device *
 
 	return base;
 }
-EXPORT_SYMBOL(ssb_admatch_base);
 
-u32 ssb_admatch_size(struct ssb_device *dev, u32 adm)
+static u32 ssb_admatch_size_sb(struct ssb_device *dev, u32 adm)
 {
 	u32 size = 0;
 
@@ -1363,7 +1359,14 @@ u32 ssb_admatch_size(struct ssb_device *
 
 	return size;
 }
-EXPORT_SYMBOL(ssb_admatch_size);
+
+const struct ssb_bus_helpers ssb_helpers_sb = {
+	.device_is_enabled	= ssb_device_is_enabled_sb,
+	.device_enable		= ssb_device_enable_sb,
+	.device_disable		= ssb_device_disable_sb,
+	.admatch_base		= ssb_admatch_base_sb,
+	.admatch_size		= ssb_admatch_size_sb,
+};
 
 static int __init ssb_modinit(void)
 {
--- linux-wireless-testing.orig/drivers/ssb/scan.c	2011-02-08 00:22:45.000000000 +0200
+++ linux-wireless-testing/drivers/ssb/scan.c	2011-02-17 14:02:57.000000000 +0200
@@ -351,6 +351,7 @@ int ssb_bus_scan(struct ssb_bus *bus,
 		dev->core_index = i;
 		dev->bus = bus;
 		dev->ops = bus->ops;
+		dev->helpers = &ssb_helpers_sb;
 
 		printk(KERN_DEBUG PFX
 			    "Core %d found: %s "
--- linux-wireless-testing.orig/drivers/ssb/ssb_private.h	2011-02-08 00:22:45.000000000 +0200
+++ linux-wireless-testing/drivers/ssb/ssb_private.h	2011-02-17 14:02:57.000000000 +0200
@@ -206,4 +206,6 @@ static inline void b43_pci_ssb_bridge_ex
 }
 #endif /* CONFIG_SSB_B43_PCI_BRIDGE */
 
+extern const struct ssb_bus_helpers ssb_helpers_sb;
+
 #endif /* LINUX_SSB_PRIVATE_H_ */
--- linux-wireless-testing.orig/include/linux/ssb/ssb.h	2011-02-17 14:02:39.000000000 +0200
+++ linux-wireless-testing/include/linux/ssb/ssb.h	2011-02-17 14:02:57.000000000 +0200
@@ -121,6 +121,15 @@ struct ssb_bus_ops {
 #endif
 };
 
+/* Bus implementation-specific device helpers */
+struct ssb_bus_helpers {
+	int (*device_is_enabled)(struct ssb_device *dev);
+	void (*device_enable)(struct ssb_device *dev, u32 core_specific_flags);
+	void (*device_disable)(struct ssb_device *dev, u32 core_specific_flags);
+	u32 (*admatch_base)(struct ssb_device *dev, u32 adm);
+	u32 (*admatch_size)(struct ssb_device *dev, u32 adm);
+};
+
 
 /* Core-ID values. */
 #define SSB_DEV_CHIPCOMMON	0x800
@@ -170,6 +179,7 @@ struct ssb_device {
 	/* Having a copy of the ops pointer in each dev struct
 	 * is an optimization. */
 	const struct ssb_bus_ops *ops;
+	const struct ssb_bus_helpers *helpers;
 
 	struct device *dev, *dma_dev;
 
@@ -416,12 +426,31 @@ extern int ssb_bus_resume(struct ssb_bus
 extern u32 ssb_clockspeed(struct ssb_bus *bus);
 
 /* Is the device enabled in hardware? */
-int ssb_device_is_enabled(struct ssb_device *dev);
+static inline int ssb_device_is_enabled(struct ssb_device *dev)
+{
+	return dev->helpers->device_is_enabled(dev);
+}
 /* Enable a device and pass device-specific SSB_TMSLOW flags.
  * If no device-specific flags are available, use 0. */
-void ssb_device_enable(struct ssb_device *dev, u32 core_specific_flags);
+static inline void ssb_device_enable(struct ssb_device *dev,
+				     u32 core_specific_flags)
+{
+	return dev->helpers->device_enable(dev, core_specific_flags);
+}
 /* Disable a device in hardware and pass SSB_TMSLOW flags (if any). */
-void ssb_device_disable(struct ssb_device *dev, u32 core_specific_flags);
+static inline void ssb_device_disable(struct ssb_device *dev,
+				      u32 core_specific_flags)
+{
+	return dev->helpers->device_disable(dev, core_specific_flags);
+}
+static inline u32 ssb_admatch_base(struct ssb_device *dev, u32 adm)
+{
+	return dev->helpers->admatch_base(dev, adm);
+}
+static inline u32 ssb_admatch_size(struct ssb_device *dev, u32 adm)
+{
+	return dev->helpers->admatch_size(dev, adm);
+}
 
 
 /* Device MMIO register read/write functions. */
@@ -519,10 +548,6 @@ extern int ssb_bus_may_powerdown(struct 
 extern int ssb_bus_powerup(struct ssb_bus *bus, bool dynamic_pctl);
 
 
-/* Various helper functions */
-extern u32 ssb_admatch_base(struct ssb_device *dev, u32 adm);
-extern u32 ssb_admatch_size(struct ssb_device *dev, u32 adm);
-
 /* PCI device mapping and fixup routines.
  * Called from the architecture pcibios init code.
  * These are only available on SSB_EMBEDDED configurations. */



