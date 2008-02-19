Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:34915 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbYBSL7c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2008 06:59:32 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] ssb: Fix watchdog access for devices without a chipcommon
Date: Tue, 19 Feb 2008 12:41:30 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200802191241.30178.mb@bu3sch.de> (sfid-20080219_115936_388756_E5C9BAD3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes the SSB watchdog access for devices without a chipcommon.
These devices have the watchdog on the extif.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Fix for 2.6.25.


Index: wireless-testing/drivers/ssb/Kconfig
===================================================================
--- wireless-testing.orig/drivers/ssb/Kconfig	2008-02-16 19:08:13.000000000 +0100
+++ wireless-testing/drivers/ssb/Kconfig	2008-02-19 12:22:07.000000000 +0100
@@ -105,6 +105,12 @@ config SSB_DRIVER_MIPS
 
 	  If unsure, say N
 
+# Assumption: We are on embedded, if we compile the MIPS core.
+config SSB_EMBEDDED
+	bool
+	depends on SSB_DRIVER_MIPS
+	default y
+
 config SSB_DRIVER_EXTIF
 	bool "SSB Broadcom EXTIF core driver (EXPERIMENTAL)"
 	depends on SSB_DRIVER_MIPS && EXPERIMENTAL
Index: wireless-testing/drivers/ssb/Makefile
===================================================================
--- wireless-testing.orig/drivers/ssb/Makefile	2008-02-16 19:08:13.000000000 +0100
+++ wireless-testing/drivers/ssb/Makefile	2008-02-19 12:20:56.000000000 +0100
@@ -1,5 +1,6 @@
 # core
 ssb-y					+= main.o scan.o
+ssb-$(CONFIG_SSB_EMBEDDED)		+= embedded.o
 
 # host support
 ssb-$(CONFIG_SSB_PCIHOST)		+= pci.o pcihost_wrapper.o
Index: wireless-testing/drivers/ssb/driver_extif.c
===================================================================
--- wireless-testing.orig/drivers/ssb/driver_extif.c	2008-02-16 19:08:13.000000000 +0100
+++ wireless-testing/drivers/ssb/driver_extif.c	2008-02-19 12:04:06.000000000 +0100
@@ -110,6 +110,12 @@ void ssb_extif_get_clockcontrol(struct s
 	*m = extif_read32(extif, SSB_EXTIF_CLOCK_SB);
 }
 
+void ssb_extif_watchdog_timer_set(struct ssb_extif *extif,
+				  u32 ticks)
+{
+	extif_write32(extif, SSB_EXTIF_WATCHDOG, ticks);
+}
+
 u32 ssb_extif_gpio_in(struct ssb_extif *extif, u32 mask)
 {
 	return extif_read32(extif, SSB_EXTIF_GPIO_IN) & mask;
Index: wireless-testing/drivers/ssb/embedded.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-testing/drivers/ssb/embedded.c	2008-02-19 12:16:54.000000000 +0100
@@ -0,0 +1,26 @@
+/*
+ * Sonics Silicon Backplane
+ * Embedded systems support code
+ *
+ * Copyright 2005-2008, Broadcom Corporation
+ * Copyright 2006-2008, Michael Buesch <mb@bu3sch.de>
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ */
+
+#include <linux/ssb/ssb.h>
+#include <linux/ssb/ssb_embedded.h>
+
+
+int ssb_watchdog_timer_set(struct ssb_bus *bus, u32 ticks)
+{
+	if (ssb_chipco_available(&bus->chipco)) {
+		ssb_chipco_watchdog_timer_set(&bus->chipco, ticks);
+		return 0;
+	}
+	if (ssb_extif_available(&bus->extif)) {
+		ssb_extif_watchdog_timer_set(&bus->extif, ticks);
+		return 0;
+	}
+	return -ENODEV;
+}
Index: wireless-testing/include/linux/ssb/ssb_driver_chipcommon.h
===================================================================
--- wireless-testing.orig/include/linux/ssb/ssb_driver_chipcommon.h	2008-02-19 00:19:22.000000000 +0100
+++ wireless-testing/include/linux/ssb/ssb_driver_chipcommon.h	2008-02-19 12:14:54.000000000 +0100
@@ -357,6 +357,11 @@ struct ssb_chipcommon {
 	u16 fast_pwrup_delay;
 };
 
+static inline bool ssb_chipco_available(struct ssb_chipcommon *cc)
+{
+	return (cc->dev != NULL);
+}
+
 extern void ssb_chipcommon_init(struct ssb_chipcommon *cc);
 
 #include <linux/pm.h>
Index: wireless-testing/include/linux/ssb/ssb_driver_extif.h
===================================================================
--- wireless-testing.orig/include/linux/ssb/ssb_driver_extif.h	2008-02-16 19:08:15.000000000 +0100
+++ wireless-testing/include/linux/ssb/ssb_driver_extif.h	2008-02-19 12:13:34.000000000 +0100
@@ -171,6 +171,9 @@ extern void ssb_extif_get_clockcontrol(s
 extern void ssb_extif_timing_init(struct ssb_extif *extif,
 				  unsigned long ns);
 
+extern void ssb_extif_watchdog_timer_set(struct ssb_extif *extif,
+					 u32 ticks);
+
 u32 ssb_extif_gpio_in(struct ssb_extif *extif, u32 mask);
 
 void ssb_extif_gpio_out(struct ssb_extif *extif, u32 mask, u32 value);
@@ -200,5 +203,11 @@ void ssb_extif_get_clockcontrol(struct s
 {
 }
 
+static inline
+void ssb_extif_watchdog_timer_set(struct ssb_extif *extif,
+				  u32 ticks)
+{
+}
+
 #endif /* CONFIG_SSB_DRIVER_EXTIF */
 #endif /* LINUX_SSB_EXTIFCORE_H_ */
Index: wireless-testing/include/linux/ssb/ssb_embedded.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-testing/include/linux/ssb/ssb_embedded.h	2008-02-19 12:18:38.000000000 +0100
@@ -0,0 +1,10 @@
+#ifndef LINUX_SSB_EMBEDDED_H_
+#define LINUX_SSB_EMBEDDED_H_
+
+#include <linux/types.h>
+#include <linux/ssb/ssb.h>
+
+
+extern int ssb_watchdog_timer_set(struct ssb_bus *bus, u32 ticks);
+
+#endif /* LINUX_SSB_EMBEDDED_H_ */

-- 
Greetings Michael.
