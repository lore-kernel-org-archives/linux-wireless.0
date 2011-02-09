Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:20935 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528Ab1BIOjJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 09:39:09 -0500
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000019974.msg
	for <linux-wireless@vger.kernel.org>; Wed, 09 Feb 2011 16:38:33 +0200
Subject: Re: SSB AI support code ([RFC2/11] SSB reintroduce handlers as
	device ops)
From: George Kashperko <george@znau.edu.ua>
To: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1297258590.17400.37.camel@dev.znau.edu.ua>
References: <1297258590.17400.37.camel@dev.znau.edu.ua>
Content-Type: text/plain
Date: Wed, 09 Feb 2011 16:31:43 +0200
Message-Id: <1297261903.18053.18.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: George Kashperko <george@znau.edu.ua>

Reintroduce ssb device enable, disable, is_enabled, admatch base and size
routines as device ops. This is required for transparent support for AI-style
SB buses later on. As soon as exported routines were just replaced by device
ops with appropriate inline accessor helpers these changes won't impact
any ssb-related code.
Signed-off-by: George Kashperko <george@znau.edu.ua>
---
 drivers/ssb/main.c      |   52 ++++++++++++++++++++------------------
 include/linux/ssb/ssb.h |   43 ++++++++++++++++++++++---------
 2 files changed, 59 insertions(+), 36 deletions(-)
--- linux-next-20110203.orig/drivers/ssb/main.c	2011-02-07 16:28:54.000000000 +0200
+++ linux-next-20110203/drivers/ssb/main.c	2011-02-07 16:04:14.000000000 +0200
@@ -49,6 +49,8 @@ static bool ssb_is_early_boot = 1;
 static void ssb_buses_lock(void);
 static void ssb_buses_unlock(void);
 
+static const struct ssb_bus_ops ssb_ssb_ops;
+
 
 #ifdef CONFIG_SSB_PCIHOST
 struct ssb_bus *ssb_pci_dev_to_bus(struct pci_dev *pdev)
@@ -737,20 +739,6 @@ static void ssb_ssb_block_write(struct s
 }
 #endif /* CONFIG_SSB_BLOCKIO */
 
-/* Ops for the plain SSB bus without a host-device (no PCI or PCMCIA). */
-static const struct ssb_bus_ops ssb_ssb_ops = {
-	.read8		= ssb_ssb_read8,
-	.read16		= ssb_ssb_read16,
-	.read32		= ssb_ssb_read32,
-	.write8		= ssb_ssb_write8,
-	.write16	= ssb_ssb_write16,
-	.write32	= ssb_ssb_write32,
-#ifdef CONFIG_SSB_BLOCKIO
-	.block_read	= ssb_ssb_block_read,
-	.block_write	= ssb_ssb_block_write,
-#endif
-};
-
 static int ssb_fetch_invariants(struct ssb_bus *bus,
 				ssb_invariants_func_t get_invariants)
 {
@@ -1136,7 +1124,7 @@ static u32 ssb_tmslow_reject_bitmask(str
 	return (SSB_TMSLOW_REJECT_22 | SSB_TMSLOW_REJECT_23);
 }
 
-int ssb_device_is_enabled(struct ssb_device *dev)
+static int ssb_device_is_enabled_sb(struct ssb_device *dev)
 {
 	u32 val;
 	u32 reject;
@@ -1147,7 +1135,6 @@ int ssb_device_is_enabled(struct ssb_dev
 
 	return (val == SSB_TMSLOW_CLOCK);
 }
-EXPORT_SYMBOL(ssb_device_is_enabled);
 
 static void ssb_flush_tmslow(struct ssb_device *dev)
 {
@@ -1161,7 +1148,8 @@ static void ssb_flush_tmslow(struct ssb_
 	udelay(1);
 }
 
-void ssb_device_enable(struct ssb_device *dev, u32 core_specific_flags)
+static void ssb_device_enable_sb(struct ssb_device *dev,
+				 u32 core_specific_flags)
 {
 	u32 val;
 
@@ -1190,7 +1178,6 @@ void ssb_device_enable(struct ssb_device
 		    core_specific_flags);
 	ssb_flush_tmslow(dev);
 }
-EXPORT_SYMBOL(ssb_device_enable);
 
 /* Wait for a bit in a register to get set or unset.
  * timeout is in units of ten-microseconds */
@@ -1218,7 +1205,8 @@ static int ssb_wait_bit(struct ssb_devic
 	return -ETIMEDOUT;
 }
 
-void ssb_device_disable(struct ssb_device *dev, u32 core_specific_flags)
+static void ssb_device_disable_sb(struct ssb_device *dev,
+				  u32 core_specific_flags)
 {
 	u32 reject;
 
@@ -1240,7 +1228,6 @@ void ssb_device_disable(struct ssb_devic
 		    core_specific_flags);
 	ssb_flush_tmslow(dev);
 }
-EXPORT_SYMBOL(ssb_device_disable);
 
 u32 ssb_dma_translation(struct ssb_device *dev)
 {
@@ -1312,7 +1299,7 @@ error:
 }
 EXPORT_SYMBOL(ssb_bus_powerup);
 
-u32 ssb_admatch_base(struct ssb_device *dev, u32 adm)
+static u32 ssb_admatch_base_sb(struct ssb_device *dev, u32 adm)
 {
 	u32 base = 0;
 
@@ -1336,9 +1323,8 @@ u32 ssb_admatch_base(struct ssb_device *
 
 	return base;
 }
-EXPORT_SYMBOL(ssb_admatch_base);
 
-u32 ssb_admatch_size(struct ssb_device *dev, u32 adm)
+static u32 ssb_admatch_size_sb(struct ssb_device *dev, u32 adm)
 {
 	u32 size = 0;
 
@@ -1363,7 +1349,25 @@ u32 ssb_admatch_size(struct ssb_device *
 
 	return size;
 }
-EXPORT_SYMBOL(ssb_admatch_size);
+
+/* Ops for the plain SSB bus without a host-device (no PCI or PCMCIA). */
+static const struct ssb_bus_ops ssb_ssb_ops = {
+	.read8			= ssb_ssb_read8,
+	.read16			= ssb_ssb_read16,
+	.read32			= ssb_ssb_read32,
+	.write8			= ssb_ssb_write8,
+	.write16		= ssb_ssb_write16,
+	.write32		= ssb_ssb_write32,
+#ifdef CONFIG_SSB_BLOCKIO
+	.block_read		= ssb_ssb_block_read,
+	.block_write		= ssb_ssb_block_write,
+#endif
+	.device_is_enabled	= ssb_device_is_enabled_sb,
+	.device_enable		= ssb_device_enable_sb,
+	.device_disable		= ssb_device_disable_sb,
+	.admatch_base		= ssb_admatch_base_sb,
+	.admatch_size		= ssb_admatch_size_sb,
+};
 
 static int __init ssb_modinit(void)
 {
--- linux-next-20110203.orig/include/linux/ssb/ssb.h	2011-02-07 16:28:54.000000000 +0200
+++ linux-next-20110203/include/linux/ssb/ssb.h	2011-02-07 16:29:56.000000000 +0200
@@ -119,6 +119,11 @@ struct ssb_bus_ops {
 	void (*block_write)(struct ssb_device *dev, const void *buffer,
 			    size_t count, u16 offset, u8 reg_width);
 #endif
+	int (*device_is_enabled)(struct ssb_device *dev);
+	void (*device_enable)(struct ssb_device *dev, u32 core_specific_flags);
+	void (*device_disable)(struct ssb_device *dev, u32 core_specific_flags);
+	u32 (*admatch_base)(struct ssb_device *dev, u32 adm);
+	u32 (*admatch_size)(struct ssb_device *dev, u32 adm);
 };
 
 
@@ -415,14 +420,6 @@ extern int ssb_bus_resume(struct ssb_bus
 
 extern u32 ssb_clockspeed(struct ssb_bus *bus);
 
-/* Is the device enabled in hardware? */
-int ssb_device_is_enabled(struct ssb_device *dev);
-/* Enable a device and pass device-specific SSB_TMSLOW flags.
- * If no device-specific flags are available, use 0. */
-void ssb_device_enable(struct ssb_device *dev, u32 core_specific_flags);
-/* Disable a device in hardware and pass SSB_TMSLOW flags (if any). */
-void ssb_device_disable(struct ssb_device *dev, u32 core_specific_flags);
-
 
 /* Device MMIO register read/write functions. */
 static inline u8 ssb_read8(struct ssb_device *dev, u16 offset)
@@ -462,6 +459,32 @@ static inline void ssb_block_write(struc
 	dev->ops->block_write(dev, buffer, count, offset, reg_width);
 }
 #endif /* CONFIG_SSB_BLOCKIO */
+/* Is the device enabled in hardware? */
+static inline int ssb_device_is_enabled(struct ssb_device *dev)
+{
+	return dev->ops->device_is_enabled(dev);
+}
+/* Enable a device and pass device-specific SSB_TMSLOW flags.
+ * If no device-specific flags are available, use 0. */
+static inline void ssb_device_enable(struct ssb_device *dev,
+				     u32 core_specific_flags)
+{
+	return dev->ops->device_enable(dev, core_specific_flags);
+}
+/* Disable a device in hardware and pass SSB_TMSLOW flags (if any). */
+static inline void ssb_device_disable(struct ssb_device *dev,
+				      u32 core_specific_flags)
+{
+	return dev->ops->device_disable(dev, core_specific_flags);
+}
+static inline u32 ssb_admatch_base(struct ssb_device *dev, u32 adm)
+{
+	return dev->ops->admatch_base(dev, adm);
+}
+static inline u32 ssb_admatch_size(struct ssb_device *dev, u32 adm)
+{
+	return dev->ops->admatch_size(dev, adm);
+}
 
 
 /* The SSB DMA API. Use this API for any DMA operation on the device.
@@ -519,10 +542,6 @@ extern int ssb_bus_may_powerdown(struct 
 extern int ssb_bus_powerup(struct ssb_bus *bus, bool dynamic_pctl);
 
 
-/* Various helper functions */
-extern u32 ssb_admatch_base(struct ssb_device *dev, u32 adm);
-extern u32 ssb_admatch_size(struct ssb_device *dev, u32 adm);
-
 /* PCI device mapping and fixup routines.
  * Called from the architecture pcibios init code.
  * These are only available on SSB_EMBEDDED configurations. */



