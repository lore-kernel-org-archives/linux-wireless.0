Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36488 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477Ab2KXWZj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2012 17:25:39 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wim@iguana.be,
	linux-watchdog@vger.kernel.org, castet.matthieu@free.fr,
	biblbroks@sezampro.rs, m@bues.ch, zajec5@gmail.com,
	linux-mips@linux-mips.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 11/15] ssb: set the pmu watchdog if available
Date: Sat, 24 Nov 2012 23:24:11 +0100
Message-Id: <1353795855-22236-12-git-send-email-hauke@hauke-m.de> (sfid-20121124_232544_055229_CCCEFC08)
In-Reply-To: <1353795855-22236-1-git-send-email-hauke@hauke-m.de>
References: <1353795855-22236-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some all ssb based devices have a PMU and the PMU watchdog should be
used and not the old one in chip common in this case. This patch also
calculates the maximal number the watchdog could be set to.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/ssb/driver_chipcommon.c |   38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/ssb/driver_chipcommon.c b/drivers/ssb/driver_chipcommon.c
index 7789f42..5631640 100644
--- a/drivers/ssb/driver_chipcommon.c
+++ b/drivers/ssb/driver_chipcommon.c
@@ -288,6 +288,24 @@ static u32 ssb_chipco_alp_clock(struct ssb_chipcommon *cc)
 	return 20000000;
 }
 
+static u32 ssb_chipco_watchdog_get_max_timer(struct ssb_chipcommon *cc)
+{
+	u32 nb;
+
+	if (cc->capabilities & SSB_CHIPCO_CAP_PMU) {
+		if (cc->dev->id.revision < 26)
+			nb = 16;
+		else
+			nb = (cc->dev->id.revision >= 37) ? 32 : 24;
+	} else {
+		nb = 28;
+	}
+	if (nb == 32)
+		return 0xffffffff;
+	else
+		return (1 << nb) - 1;
+}
+
 void ssb_chipcommon_init(struct ssb_chipcommon *cc)
 {
 	if (!cc->dev)
@@ -405,8 +423,24 @@ void ssb_chipco_timing_init(struct ssb_chipcommon *cc,
 /* Set chip watchdog reset timer to fire in 'ticks' backplane cycles */
 void ssb_chipco_watchdog_timer_set(struct ssb_chipcommon *cc, u32 ticks)
 {
-	/* instant NMI */
-	chipco_write32(cc, SSB_CHIPCO_WATCHDOG, ticks);
+	u32 maxt;
+	enum ssb_clkmode clkmode;
+
+	maxt = ssb_chipco_watchdog_get_max_timer(cc);
+	if (cc->capabilities & SSB_CHIPCO_CAP_PMU) {
+		if (ticks == 1)
+			ticks = 2;
+		else if (ticks > maxt)
+			ticks = maxt;
+		chipco_write32(cc, SSB_CHIPCO_PMU_WATCHDOG, ticks);
+	} else {
+		clkmode = ticks ? SSB_CLKMODE_FAST : SSB_CLKMODE_DYNAMIC;
+		ssb_chipco_set_clockmode(cc, clkmode);
+		if (ticks > maxt)
+			ticks = maxt;
+		/* instant NMI */
+		chipco_write32(cc, SSB_CHIPCO_WATCHDOG, ticks);
+	}
 }
 
 void ssb_chipco_irq_mask(struct ssb_chipcommon *cc, u32 mask, u32 value)
-- 
1.7.10.4

