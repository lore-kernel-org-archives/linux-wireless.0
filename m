Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:52361
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbXGaWMl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 18:12:41 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	John Linville <linville@tuxdriver.com>
Subject: [PATCH] ssb-chipcommon: Add function to get processor clock
Date: Wed, 1 Aug 2007 00:11:56 +0200
Cc: linux-wireless@vger.kernel.org,
	Aurelien Jarno <aurelien@aurel32.net>,
	Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
Message-Id: <200708010011.56753.mb@bu3sch.de>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Aurelien Jarno <aurelien@aurel32.net>

The patch below (against 2.6.23-rc1-mm1) adds a new function to get the 
processor clock. It originally comes from the OpenWrt patches.

Cc: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Michael Buesch <mb@bu3sch.de>

--- a/drivers/ssb/driver_chipcommon.c	2007-07-14 21:05:44.000000000 +0200
+++ b/drivers/ssb/driver_chipcommon.c	2007-07-14 21:22:04.000000000 +0200
@@ -264,6 +264,30 @@
 	ssb_chipco_set_clockmode(cc, SSB_CLKMODE_FAST);
 }
 
+/* Get the processor clock */
+void ssb_chipco_get_clockcpu(struct ssb_chipcommon *cc,
+                             u32 *plltype, u32 *n, u32 *m)
+{
+	*n = chipco_read32(cc, SSB_CHIPCO_CLOCK_N);
+	*plltype = (cc->capabilities & SSB_CHIPCO_CAP_PLLT);
+	switch (*plltype) {
+		case SSB_PLLTYPE_2:
+		case SSB_PLLTYPE_4:
+		case SSB_PLLTYPE_6:
+		case SSB_PLLTYPE_7:
+			*m = chipco_read32(cc, SSB_CHIPCO_CLOCK_MIPS);
+			break;
+		case SSB_PLLTYPE_3:
+			/* 5350 uses m2 to control mips */
+			*m = chipco_read32(cc, SSB_CHIPCO_CLOCK_M2);
+			break;
+		default:
+			*m = chipco_read32(cc, SSB_CHIPCO_CLOCK_SB);
+			break;
+	}
+}
+
+/* Get the bus clock */
 void ssb_chipco_get_clockcontrol(struct ssb_chipcommon *cc,
 				 u32 *plltype, u32 *n, u32 *m)
 {
--- a/include/linux/ssb/ssb_driver_chipcommon.h	2007-07-14 21:05:44.000000000 +0200
+++ b/include/linux/ssb/ssb_driver_chipcommon.h	2007-07-14 21:17:28.000000000 +0200
@@ -364,6 +364,8 @@
 extern void ssb_chipco_suspend(struct ssb_chipcommon *cc, pm_message_t state);
 extern void ssb_chipco_resume(struct ssb_chipcommon *cc);
 
+extern void ssb_chipco_get_clockcpu(struct ssb_chipcommon *cc,
+                                    u32 *plltype, u32 *n, u32 *m);
 extern void ssb_chipco_get_clockcontrol(struct ssb_chipcommon *cc,
 					u32 *plltype, u32 *n, u32 *m);
 extern void ssb_chipco_timing_init(struct ssb_chipcommon *cc,


-- 
Greetings Michael.
