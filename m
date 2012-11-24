Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36497 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492Ab2KXWZj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2012 17:25:39 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wim@iguana.be,
	linux-watchdog@vger.kernel.org, castet.matthieu@free.fr,
	biblbroks@sezampro.rs, m@bues.ch, zajec5@gmail.com,
	linux-mips@linux-mips.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 12/15] ssb: add methods for watchdog driver
Date: Sat, 24 Nov 2012 23:24:12 +0100
Message-Id: <1353795855-22236-13-git-send-email-hauke@hauke-m.de> (sfid-20121124_233122_787619_B492D0BF)
In-Reply-To: <1353795855-22236-1-git-send-email-hauke@hauke-m.de>
References: <1353795855-22236-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The watchdog driver wants to set the watchdog timeout in ms and not in
ticks, which is depending on the SoC type and the clock.
Calculate the number of ticks per millisecond and provide two functions
for the watchdog driver. Also return the ticks or millisecond the timer
was set to in case the provided value was bigger than the max allowed
value.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/ssb/driver_chipcommon.c           |   47 ++++++++++++++++++++++++++++-
 drivers/ssb/ssb_private.h                 |    5 +++
 include/linux/ssb/ssb_driver_chipcommon.h |    5 +--
 3 files changed, 54 insertions(+), 3 deletions(-)

diff --git a/drivers/ssb/driver_chipcommon.c b/drivers/ssb/driver_chipcommon.c
index 5631640..92de046 100644
--- a/drivers/ssb/driver_chipcommon.c
+++ b/drivers/ssb/driver_chipcommon.c
@@ -4,6 +4,7 @@
  *
  * Copyright 2005, Broadcom Corporation
  * Copyright 2006, 2007, Michael Buesch <m@bues.ch>
+ * Copyright 2012, Hauke Mehrtens <hauke@hauke-m.de>
  *
  * Licensed under the GNU/GPL. See COPYING for details.
  */
@@ -12,6 +13,7 @@
 #include <linux/ssb/ssb_regs.h>
 #include <linux/export.h>
 #include <linux/pci.h>
+#include <linux/bcm47xx_wdt.h>
 
 #include "ssb_private.h"
 
@@ -306,6 +308,43 @@ static u32 ssb_chipco_watchdog_get_max_timer(struct ssb_chipcommon *cc)
 		return (1 << nb) - 1;
 }
 
+u32 ssb_chipco_watchdog_timer_set_wdt(struct bcm47xx_wdt *wdt, u32 ticks)
+{
+	struct ssb_chipcommon *cc = bcm47xx_wdt_get_drvdata(wdt);
+
+	if (cc->dev->bus->bustype != SSB_BUSTYPE_SSB)
+		return 0;
+
+	return ssb_chipco_watchdog_timer_set(cc, ticks);
+}
+
+u32 ssb_chipco_watchdog_timer_set_ms(struct bcm47xx_wdt *wdt, u32 ms)
+{
+	struct ssb_chipcommon *cc = bcm47xx_wdt_get_drvdata(wdt);
+	u32 ticks;
+
+	if (cc->dev->bus->bustype != SSB_BUSTYPE_SSB)
+		return 0;
+
+	ticks = ssb_chipco_watchdog_timer_set(cc, cc->ticks_per_ms * ms);
+	return ticks / cc->ticks_per_ms;
+}
+
+static int ssb_chipco_watchdog_ticks_per_ms(struct ssb_chipcommon *cc)
+{
+	struct ssb_bus *bus = cc->dev->bus;
+
+	if (cc->capabilities & SSB_CHIPCO_CAP_PMU) {
+			/* based on 32KHz ILP clock */
+			return 32;
+	} else {
+		if (cc->dev->id.revision < 18)
+			return ssb_clockspeed(bus) / 1000;
+		else
+			return ssb_chipco_alp_clock(cc) / 1000;
+	}
+}
+
 void ssb_chipcommon_init(struct ssb_chipcommon *cc)
 {
 	if (!cc->dev)
@@ -323,6 +362,11 @@ void ssb_chipcommon_init(struct ssb_chipcommon *cc)
 	chipco_powercontrol_init(cc);
 	ssb_chipco_set_clockmode(cc, SSB_CLKMODE_FAST);
 	calc_fast_powerup_delay(cc);
+
+	if (cc->dev->bus->bustype == SSB_BUSTYPE_SSB) {
+		cc->ticks_per_ms = ssb_chipco_watchdog_ticks_per_ms(cc);
+		cc->max_timer_ms = ssb_chipco_watchdog_get_max_timer(cc) / cc->ticks_per_ms;
+	}
 }
 
 void ssb_chipco_suspend(struct ssb_chipcommon *cc)
@@ -421,7 +465,7 @@ void ssb_chipco_timing_init(struct ssb_chipcommon *cc,
 }
 
 /* Set chip watchdog reset timer to fire in 'ticks' backplane cycles */
-void ssb_chipco_watchdog_timer_set(struct ssb_chipcommon *cc, u32 ticks)
+u32 ssb_chipco_watchdog_timer_set(struct ssb_chipcommon *cc, u32 ticks)
 {
 	u32 maxt;
 	enum ssb_clkmode clkmode;
@@ -441,6 +485,7 @@ void ssb_chipco_watchdog_timer_set(struct ssb_chipcommon *cc, u32 ticks)
 		/* instant NMI */
 		chipco_write32(cc, SSB_CHIPCO_WATCHDOG, ticks);
 	}
+	return ticks;
 }
 
 void ssb_chipco_irq_mask(struct ssb_chipcommon *cc, u32 mask, u32 value)
diff --git a/drivers/ssb/ssb_private.h b/drivers/ssb/ssb_private.h
index 98b2915..03cc40a 100644
--- a/drivers/ssb/ssb_private.h
+++ b/drivers/ssb/ssb_private.h
@@ -3,6 +3,7 @@
 
 #include <linux/ssb/ssb.h>
 #include <linux/types.h>
+#include <linux/bcm47xx_wdt.h>
 
 
 #define PFX	"ssb: "
@@ -212,4 +213,8 @@ extern u32 ssb_pmu_get_cpu_clock(struct ssb_chipcommon *cc);
 extern u32 ssb_pmu_get_controlclock(struct ssb_chipcommon *cc);
 extern u32 ssb_pmu_get_alp_clock(struct ssb_chipcommon *cc);
 
+extern u32 ssb_chipco_watchdog_timer_set_wdt(struct bcm47xx_wdt *wdt,
+					     u32 ticks);
+extern u32 ssb_chipco_watchdog_timer_set_ms(struct bcm47xx_wdt *wdt, u32 ms);
+
 #endif /* LINUX_SSB_PRIVATE_H_ */
diff --git a/include/linux/ssb/ssb_driver_chipcommon.h b/include/linux/ssb/ssb_driver_chipcommon.h
index c2b02a5..38339fd 100644
--- a/include/linux/ssb/ssb_driver_chipcommon.h
+++ b/include/linux/ssb/ssb_driver_chipcommon.h
@@ -591,6 +591,8 @@ struct ssb_chipcommon {
 	/* Fast Powerup Delay constant */
 	u16 fast_pwrup_delay;
 	struct ssb_chipcommon_pmu pmu;
+	u32 ticks_per_ms;
+	u32 max_timer_ms;
 };
 
 static inline bool ssb_chipco_available(struct ssb_chipcommon *cc)
@@ -630,8 +632,7 @@ enum ssb_clkmode {
 extern void ssb_chipco_set_clockmode(struct ssb_chipcommon *cc,
 				     enum ssb_clkmode mode);
 
-extern void ssb_chipco_watchdog_timer_set(struct ssb_chipcommon *cc,
-					  u32 ticks);
+extern u32 ssb_chipco_watchdog_timer_set(struct ssb_chipcommon *cc, u32 ticks);
 
 void ssb_chipco_irq_mask(struct ssb_chipcommon *cc, u32 mask, u32 value);
 
-- 
1.7.10.4

