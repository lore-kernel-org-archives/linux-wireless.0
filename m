Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:50351
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765517AbXHNRA5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 13:00:57 -0400
Message-Id: <20070814165748.319144000@bu3sch.de>
References: <20070814165746.863593000@bu3sch.de>
Date: Tue, 14 Aug 2007 18:57:49 +0200
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Aurelien Jarno <aurelien@aurel32.net>
Subject: [patch 3/7] ssb: Add GPIO support to Chip Common and PCI core drivers
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Aurelien Jarno <aurelien@aurel32.net>

The patch below adds a functions to Chip Common and PCI core drivers to
access the GPIO lines.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: ssb-merge-new/drivers/ssb/driver_chipcommon.c
===================================================================
--- ssb-merge-new.orig/drivers/ssb/driver_chipcommon.c	2007-08-11 20:25:54.000000000 +0200
+++ ssb-merge-new/drivers/ssb/driver_chipcommon.c	2007-08-13 14:16:39.000000000 +0200
@@ -39,6 +39,14 @@ static inline void chipco_write32(struct
 	ssb_write32(cc->dev, offset, value);
 }
 
+static inline void chipco_write32_masked(struct ssb_chipcommon *cc, u16 offset,
+					 u32 mask, u32 value)
+{
+	value &= mask;
+	value |= chipco_read32(cc, offset) & ~mask;
+	chipco_write32(cc, offset, value);
+}
+
 void ssb_chipco_set_clockmode(struct ssb_chipcommon *cc,
 			      enum ssb_clkmode mode)
 {
@@ -344,6 +352,21 @@ ssb_chipco_watchdog_timer_set(struct ssb
 	chipco_write32(cc, SSB_CHIPCO_WATCHDOG, ticks);
 }
 
+u32 ssb_chipco_gpio_in(struct ssb_chipcommon *cc, u32 mask)
+{
+	return chipco_read32(cc, SSB_CHIPCO_GPIOIN) & mask;
+}
+
+void ssb_chipco_gpio_out(struct ssb_chipcommon *cc, u32 mask, u32 value)
+{
+	return chipco_write32_masked(cc, SSB_CHIPCO_GPIOOUT, mask, value);
+}
+
+void ssb_chipco_gpio_outen(struct ssb_chipcommon *cc, u32 mask, u32 value)
+{
+	return chipco_write32_masked(cc, SSB_CHIPCO_GPIOOUTEN, mask, value);
+}
+
 #ifdef CONFIG_SSB_SERIAL
 int ssb_chipco_serial_init(struct ssb_chipcommon *cc,
 			   struct ssb_serial_port *ports)
Index: ssb-merge-new/drivers/ssb/driver_extif.c
===================================================================
--- ssb-merge-new.orig/drivers/ssb/driver_extif.c	2007-08-11 01:57:31.000000000 +0200
+++ ssb-merge-new/drivers/ssb/driver_extif.c	2007-08-13 14:16:39.000000000 +0200
@@ -27,6 +27,14 @@ static inline void extif_write32(struct 
 	ssb_write32(extif->dev, offset, value);
 }
 
+static inline void extif_write32_masked(struct ssb_extif *extif, u16 offset,
+					u32 mask, u32 value)
+{
+	value &= mask;
+	value |= extif_read32(extif, offset) & ~mask;
+	extif_write32(extif, offset, value);
+}
+
 #ifdef CONFIG_SSB_SERIAL
 static bool serial_exists(u8 *regs)
 {
@@ -102,3 +110,20 @@ void ssb_extif_get_clockcontrol(struct s
 	*m = extif_read32(extif, SSB_EXTIF_CLOCK_SB);
 }
 
+u32 ssb_extif_gpio_in(struct ssb_extif *extif, u32 mask)
+{
+	return extif_read32(extif, SSB_EXTIF_GPIO_IN) & mask;
+}
+
+void ssb_extif_gpio_out(struct ssb_extif *extif, u32 mask, u32 value)
+{
+	return extif_write32_masked(extif, SSB_EXTIF_GPIO_OUT(0),
+				   mask, value);
+}
+
+void ssb_extif_gpio_outen(struct ssb_extif *extif, u32 mask, u32 value)
+{
+	return extif_write32_masked(extif, SSB_EXTIF_GPIO_OUTEN(0),
+				   mask, value);
+}
+
Index: ssb-merge-new/include/linux/ssb/ssb_driver_chipcommon.h
===================================================================
--- ssb-merge-new.orig/include/linux/ssb/ssb_driver_chipcommon.h	2007-08-11 01:57:44.000000000 +0200
+++ ssb-merge-new/include/linux/ssb/ssb_driver_chipcommon.h	2007-08-13 14:16:39.000000000 +0200
@@ -382,6 +382,12 @@ extern void ssb_chipco_set_clockmode(str
 extern void ssb_chipco_watchdog_timer_set(struct ssb_chipcommon *cc,
 					  u32 ticks);
 
+u32 ssb_chipco_gpio_in(struct ssb_chipcommon *cc, u32 mask);
+
+void ssb_chipco_gpio_out(struct ssb_chipcommon *cc, u32 mask, u32 value);
+
+void ssb_chipco_gpio_outen(struct ssb_chipcommon *cc, u32 mask, u32 value);
+
 #ifdef CONFIG_SSB_SERIAL
 extern int ssb_chipco_serial_init(struct ssb_chipcommon *cc,
 				  struct ssb_serial_port *ports);
Index: ssb-merge-new/include/linux/ssb/ssb_driver_extif.h
===================================================================
--- ssb-merge-new.orig/include/linux/ssb/ssb_driver_extif.h	2007-08-11 01:57:44.000000000 +0200
+++ ssb-merge-new/include/linux/ssb/ssb_driver_extif.h	2007-08-13 14:16:39.000000000 +0200
@@ -171,6 +171,12 @@ extern void ssb_extif_get_clockcontrol(s
 extern void ssb_extif_timing_init(struct ssb_extif *extif,
 				  unsigned long ns);
 
+u32 ssb_extif_gpio_in(struct ssb_extif *extif, u32 mask);
+
+void ssb_extif_gpio_out(struct ssb_extif *extif, u32 mask, u32 value);
+
+void ssb_extif_gpio_outen(struct ssb_extif *extif, u32 mask, u32 value);
+
 #ifdef CONFIG_SSB_SERIAL
 extern int ssb_extif_serial_init(struct ssb_extif *extif,
 				 struct ssb_serial_port *ports);

-- 

