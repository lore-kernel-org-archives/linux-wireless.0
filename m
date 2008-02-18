Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:42142 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbYBRUsA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2008 15:48:00 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] ssb: Fix serial console on new bcm47xx devices
Date: Mon, 18 Feb 2008 21:44:39 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200802182144.39401.mb@bu3sch.de> (sfid-20080218_204806_501705_EB1386B6)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes the baud settings for new devices
like the Linksys WRT350n.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, this is a bugfix for 2.6.25.

Index: wireless-testing/drivers/ssb/driver_chipcommon.c
===================================================================
--- wireless-testing.orig/drivers/ssb/driver_chipcommon.c	2008-02-16 19:08:13.000000000 +0100
+++ wireless-testing/drivers/ssb/driver_chipcommon.c	2008-02-18 21:42:40.000000000 +0100
@@ -376,6 +376,7 @@ int ssb_chipco_serial_init(struct ssb_ch
 	unsigned int irq;
 	u32 baud_base, div;
 	u32 i, n;
+	unsigned int ccrev = cc->dev->id.revision;
 
 	plltype = (cc->capabilities & SSB_CHIPCO_CAP_PLLT);
 	irq = ssb_mips_irq(cc->dev);
@@ -387,14 +388,39 @@ int ssb_chipco_serial_init(struct ssb_ch
 						chipco_read32(cc, SSB_CHIPCO_CLOCK_M2));
 		div = 1;
 	} else {
-		if (cc->dev->id.revision >= 11) {
+		if (ccrev == 20) {
+			/* BCM5354 uses constant 25MHz clock */
+			baud_base = 25000000;
+			div = 48;
+			/* Set the override bit so we don't divide it */
+			chipco_write32(cc, SSB_CHIPCO_CORECTL,
+				       chipco_read32(cc, SSB_CHIPCO_CORECTL)
+				       | SSB_CHIPCO_CORECTL_UARTCLK0);
+		} else if ((ccrev >= 11) && (ccrev != 15)) {
 			/* Fixed ALP clock */
 			baud_base = 20000000;
+			if (cc->capabilities & SSB_CHIPCO_CAP_PMU) {
+				/* FIXME: baud_base is different for devices with a PMU */
+				SSB_WARN_ON(1);
+			}
 			div = 1;
+			if (ccrev >= 21) {
+				/* Turn off UART clock before switching clocksource. */
+				chipco_write32(cc, SSB_CHIPCO_CORECTL,
+					       chipco_read32(cc, SSB_CHIPCO_CORECTL)
+					       & ~SSB_CHIPCO_CORECTL_UARTCLKEN);
+			}
 			/* Set the override bit so we don't divide it */
 			chipco_write32(cc, SSB_CHIPCO_CORECTL,
-				       SSB_CHIPCO_CORECTL_UARTCLK0);
-		} else if (cc->dev->id.revision >= 3) {
+				       chipco_read32(cc, SSB_CHIPCO_CORECTL)
+				       | SSB_CHIPCO_CORECTL_UARTCLK0);
+			if (ccrev >= 21) {
+				/* Re-enable the UART clock. */
+				chipco_write32(cc, SSB_CHIPCO_CORECTL,
+					       chipco_read32(cc, SSB_CHIPCO_CORECTL)
+					       | SSB_CHIPCO_CORECTL_UARTCLKEN);
+			}
+		} else if (ccrev >= 3) {
 			/* Internal backplane clock */
 			baud_base = ssb_clockspeed(bus);
 			div = chipco_read32(cc, SSB_CHIPCO_CLKDIV)
@@ -406,7 +432,7 @@ int ssb_chipco_serial_init(struct ssb_ch
 		}
 
 		/* Clock source depends on strapping if UartClkOverride is unset */
-		if ((cc->dev->id.revision > 0) &&
+		if ((ccrev > 0) &&
 		    !(chipco_read32(cc, SSB_CHIPCO_CORECTL) & SSB_CHIPCO_CORECTL_UARTCLK0)) {
 			if ((cc->capabilities & SSB_CHIPCO_CAP_UARTCLK) ==
 			    SSB_CHIPCO_CAP_UARTCLK_INT) {
@@ -428,7 +454,7 @@ int ssb_chipco_serial_init(struct ssb_ch
 		cc_mmio = cc->dev->bus->mmio + (cc->dev->core_index * SSB_CORE_SIZE);
 		uart_regs = cc_mmio + SSB_CHIPCO_UART0_DATA;
 		/* Offset changed at after rev 0 */
-		if (cc->dev->id.revision == 0)
+		if (ccrev == 0)
 			uart_regs += (i * 8);
 		else
 			uart_regs += (i * 256);
Index: wireless-testing/include/linux/ssb/ssb_driver_chipcommon.h
===================================================================
--- wireless-testing.orig/include/linux/ssb/ssb_driver_chipcommon.h	2008-02-16 19:08:15.000000000 +0100
+++ wireless-testing/include/linux/ssb/ssb_driver_chipcommon.h	2008-02-18 21:42:40.000000000 +0100
@@ -51,9 +51,12 @@
 #define  SSB_CHIPCO_CAP_JTAGM		0x00400000	/* JTAG master present */
 #define  SSB_CHIPCO_CAP_BROM		0x00800000	/* Internal boot ROM active */
 #define  SSB_CHIPCO_CAP_64BIT		0x08000000	/* 64-bit Backplane */
+#define  SSB_CHIPCO_CAP_PMU		0x10000000	/* PMU available (rev >= 20) */
+#define  SSB_CHIPCO_CAP_ECI		0x20000000	/* ECI available (rev >= 20) */
 #define SSB_CHIPCO_CORECTL		0x0008
 #define  SSB_CHIPCO_CORECTL_UARTCLK0	0x00000001	/* Drive UART with internal clock */
 #define	 SSB_CHIPCO_CORECTL_SE		0x00000002	/* sync clk out enable (corerev >= 3) */
+#define  SSB_CHIPCO_CORECTL_UARTCLKEN	0x00000008	/* UART clock enable (rev >= 21) */
 #define SSB_CHIPCO_BIST			0x000C
 #define SSB_CHIPCO_OTPS			0x0010		/* OTP status */
 #define	 SSB_CHIPCO_OTPS_PROGFAIL	0x80000000

-- 
Greetings Michael.
