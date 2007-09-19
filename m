Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:35761
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbXISQ4g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 12:56:36 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] ssb: Sparse fixes.
Date: Wed, 19 Sep 2007 18:55:12 +0200
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200709191855.12767.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes all Sparse warnings in SSB.
No semantics change.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-dev/drivers/ssb/b43_pci_bridge.c
===================================================================
--- wireless-dev.orig/drivers/ssb/b43_pci_bridge.c	2007-09-19 17:15:58.000000000 +0200
+++ wireless-dev/drivers/ssb/b43_pci_bridge.c	2007-09-19 18:23:42.000000000 +0200
@@ -13,6 +13,8 @@
 #include <linux/pci.h>
 #include <linux/ssb/ssb.h>
 
+#include "ssb_private.h"
+
 
 static const struct pci_device_id b43_pci_bridge_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4301) },
Index: wireless-dev/drivers/ssb/driver_chipcommon.c
===================================================================
--- wireless-dev.orig/drivers/ssb/driver_chipcommon.c	2007-09-19 17:15:58.000000000 +0200
+++ wireless-dev/drivers/ssb/driver_chipcommon.c	2007-09-19 18:22:31.000000000 +0200
@@ -345,8 +345,7 @@ void ssb_chipco_timing_init(struct ssb_c
 }
 
 /* Set chip watchdog reset timer to fire in 'ticks' backplane cycles */
-void
-ssb_chipco_watchdog_timer_set(struct ssb_chipcommon *cc, u32 ticks)
+void ssb_chipco_watchdog_timer_set(struct ssb_chipcommon *cc, u32 ticks)
 {
 	/* instant NMI */
 	chipco_write32(cc, SSB_CHIPCO_WATCHDOG, ticks);
@@ -359,12 +358,12 @@ u32 ssb_chipco_gpio_in(struct ssb_chipco
 
 void ssb_chipco_gpio_out(struct ssb_chipcommon *cc, u32 mask, u32 value)
 {
-	return chipco_write32_masked(cc, SSB_CHIPCO_GPIOOUT, mask, value);
+	chipco_write32_masked(cc, SSB_CHIPCO_GPIOOUT, mask, value);
 }
 
 void ssb_chipco_gpio_outen(struct ssb_chipcommon *cc, u32 mask, u32 value)
 {
-	return chipco_write32_masked(cc, SSB_CHIPCO_GPIOOUTEN, mask, value);
+	chipco_write32_masked(cc, SSB_CHIPCO_GPIOOUTEN, mask, value);
 }
 
 #ifdef CONFIG_SSB_SERIAL
Index: wireless-dev/drivers/ssb/pci.c
===================================================================
--- wireless-dev.orig/drivers/ssb/pci.c	2007-09-19 18:13:57.000000000 +0200
+++ wireless-dev/drivers/ssb/pci.c	2007-09-19 18:19:45.000000000 +0200
@@ -306,15 +306,15 @@ static void sprom_extract_r1(struct ssb_
 	SPEX(pci_pid, SSB_SPROM1_PID, 0xFFFF, 0);
 	for (i = 0; i < 3; i++) {
 		v = in[SPOFF(SSB_SPROM1_IL0MAC) + i];
-		*(((u16 *)out->il0mac) + i) = cpu_to_be16(v);
+		*(((__be16 *)out->il0mac) + i) = cpu_to_be16(v);
 	}
 	for (i = 0; i < 3; i++) {
 		v = in[SPOFF(SSB_SPROM1_ET0MAC) + i];
-		*(((u16 *)out->et0mac) + i) = cpu_to_be16(v);
+		*(((__be16 *)out->et0mac) + i) = cpu_to_be16(v);
 	}
 	for (i = 0; i < 3; i++) {
 		v = in[SPOFF(SSB_SPROM1_ET1MAC) + i];
-		*(((u16 *)out->et1mac) + i) = cpu_to_be16(v);
+		*(((__be16 *)out->et1mac) + i) = cpu_to_be16(v);
 	}
 	SPEX(et0phyaddr, SSB_SPROM1_ETHPHY, SSB_SPROM1_ETHPHY_ET0A, 0);
 	SPEX(et1phyaddr, SSB_SPROM1_ETHPHY, SSB_SPROM1_ETHPHY_ET1A,
@@ -352,7 +352,7 @@ static void sprom_extract_r1(struct ssb_
 	     SSB_SPROM1_AGAIN_BG_SHIFT);
 	for (i = 0; i < 4; i++) {
 		v = in[SPOFF(SSB_SPROM1_OEM) + i];
-		*(((u16 *)out->oem) + i) = cpu_to_le16(v);
+		*(((__le16 *)out->oem) + i) = cpu_to_le16(v);
 	}
 }
 
@@ -374,7 +374,7 @@ static void sprom_extract_r2(struct ssb_
 	SPEX(ofdm_pwr_off, SSB_SPROM2_OPO, SSB_SPROM2_OPO_VALUE, 0);
 	for (i = 0; i < 4; i++) {
 		v = in[SPOFF(SSB_SPROM2_CCODE) + i];
-		*(((u16 *)out->country_str) + i) = cpu_to_le16(v);
+		*(((__le16 *)out->country_str) + i) = cpu_to_le16(v);
 	}
 }
 
