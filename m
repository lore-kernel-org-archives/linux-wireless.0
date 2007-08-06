Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:47453
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762140AbXHFWyh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2007 18:54:37 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	John Linville <linville@tuxdriver.com>
Subject: [PATCH] ssb: Fix extif compile error
Date: Tue, 7 Aug 2007 00:54:00 +0200
Cc: Aurelien Jarno <aurelien@aurel32.net>,
	Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200708070054.00890.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a compilation fix for a recently applied patch
[PATCH 2/3] Use SSB EXTIF in SSB MIPS core driver
when the extif core is not enabled.

This also makes the extif driver depend on CONFIG_SSB_DRIVER_EXTIF
(sorry, my mistake).

Signed-off-by: Michael Buesch <mb@bu3sch.de>

--

John, please apply to wireless-dev
Andrew, please apply to -mm after applying the other ssb patches.

Index: wireless-dev/drivers/ssb/main.c
===================================================================
--- wireless-dev.orig/drivers/ssb/main.c	2007-08-07 00:48:15.000000000 +0200
+++ wireless-dev/drivers/ssb/main.c	2007-08-07 00:48:18.000000000 +0200
@@ -819,7 +819,7 @@
 	u32 plltype;
 	u32 clkctl_n, clkctl_m;
 
-	if (bus->extif.dev)
+	if (ssb_extif_available(&bus->extif))
 		ssb_extif_get_clockcontrol(&bus->extif, &plltype,
 					   &clkctl_n, &clkctl_m);
 	else if (bus->chipco.dev)
Index: wireless-dev/include/linux/ssb/ssb_driver_extif.h
===================================================================
--- wireless-dev.orig/include/linux/ssb/ssb_driver_extif.h	2007-08-07 00:48:15.000000000 +0200
+++ wireless-dev/include/linux/ssb/ssb_driver_extif.h	2007-08-07 00:48:18.000000000 +0200
@@ -20,10 +20,6 @@
 #ifndef LINUX_SSB_EXTIFCORE_H_
 #define LINUX_SSB_EXTIFCORE_H_
 
-struct ssb_extif {
-	struct ssb_device *dev;
-};
-
 /* external interface address space */
 #define	SSB_EXTIF_PCMCIA_MEMBASE(x)	(x)
 #define	SSB_EXTIF_PCMCIA_IOBASE(x)	((x) + 0x100000)
@@ -156,6 +152,19 @@
 /* watchdog */
 #define SSB_EXTIF_WATCHDOG_CLK		48000000	/* Hz */
 
+
+
+#ifdef CONFIG_SSB_DRIVER_EXTIF
+
+struct ssb_extif {
+	struct ssb_device *dev;
+};
+
+static inline bool ssb_extif_available(struct ssb_extif *extif)
+{
+	return (extif->dev != NULL);
+}
+
 extern void ssb_extif_get_clockcontrol(struct ssb_extif *extif,
 			               u32 *plltype, u32 *n, u32 *m);
 
@@ -167,4 +176,23 @@
 				 struct ssb_serial_port *ports);
 #endif /* CONFIG_SSB_SERIAL */
 
+
+#else /* CONFIG_SSB_DRIVER_EXTIF */
+/* extif disabled */
+
+struct ssb_extif {
+};
+
+static inline bool ssb_extif_available(struct ssb_extif *extif)
+{
+	return 0;
+}
+
+static inline
+void ssb_extif_get_clockcontrol(struct ssb_extif *extif,
+			        u32 *plltype, u32 *n, u32 *m)
+{
+}
+
+#endif /* CONFIG_SSB_DRIVER_EXTIF */
 #endif /* LINUX_SSB_EXTIFCORE_H_ */

-- 
Greetings Michael.
