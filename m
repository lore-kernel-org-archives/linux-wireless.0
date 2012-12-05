Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47329 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450Ab2LERrw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 12:47:52 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, wim@iguana.be
Cc: linux-wireless@vger.kernel.org, linux-watchdog@vger.kernel.org,
	castet.matthieu@free.fr, biblbroks@sezampro.rs, m@bues.ch,
	zajec5@gmail.com, linux-mips@linux-mips.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v3 03/11] bcma: set the pmu watchdog if available
Date: Wed,  5 Dec 2012 18:46:00 +0100
Message-Id: <1354729568-19993-4-git-send-email-hauke@hauke-m.de> (sfid-20121205_184803_720171_18442AC3)
In-Reply-To: <1354729568-19993-1-git-send-email-hauke@hauke-m.de>
References: <1354729568-19993-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mostly all bcma based devices have a PMU and the PMU watchdog should be
used and not the old one in chip common. This patch also calculates the
maximal number the watchdog could be set to.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_chipcommon.c |   42 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcommon.c
index ef68553..7c132e5 100644
--- a/drivers/bcma/driver_chipcommon.c
+++ b/drivers/bcma/driver_chipcommon.c
@@ -31,6 +31,28 @@ static u32 bcma_chipco_alp_clock(struct bcma_drv_cc *cc)
 	return 20000000;
 }
 
+static u32 bcma_chipco_watchdog_get_max_timer(struct bcma_drv_cc *cc)
+{
+	struct bcma_bus *bus = cc->core->bus;
+	u32 nb;
+
+	if (cc->capabilities & BCMA_CC_CAP_PMU) {
+		if (bus->chipinfo.id == BCMA_CHIP_ID_BCM4706)
+			nb = 32;
+		else if (cc->core->id.rev < 26)
+			nb = 16;
+		else
+			nb = (cc->core->id.rev >= 37) ? 32 : 24;
+	} else {
+		nb = 28;
+	}
+	if (nb == 32)
+		return 0xffffffff;
+	else
+		return (1 << nb) - 1;
+}
+
+
 void bcma_core_chipcommon_early_init(struct bcma_drv_cc *cc)
 {
 	if (cc->early_setup_done)
@@ -85,8 +107,24 @@ void bcma_core_chipcommon_init(struct bcma_drv_cc *cc)
 /* Set chip watchdog reset timer to fire in 'ticks' backplane cycles */
 void bcma_chipco_watchdog_timer_set(struct bcma_drv_cc *cc, u32 ticks)
 {
-	/* instant NMI */
-	bcma_cc_write32(cc, BCMA_CC_WATCHDOG, ticks);
+	u32 maxt;
+	enum bcma_clkmode clkmode;
+
+	maxt = bcma_chipco_watchdog_get_max_timer(cc);
+	if (cc->capabilities & BCMA_CC_CAP_PMU) {
+		if (ticks == 1)
+			ticks = 2;
+		else if (ticks > maxt)
+			ticks = maxt;
+		bcma_cc_write32(cc, BCMA_CC_PMU_WATCHDOG, ticks);
+	} else {
+		clkmode = ticks ? BCMA_CLKMODE_FAST : BCMA_CLKMODE_DYNAMIC;
+		bcma_core_set_clockmode(cc->core, clkmode);
+		if (ticks > maxt)
+			ticks = maxt;
+		/* instant NMI */
+		bcma_cc_write32(cc, BCMA_CC_WATCHDOG, ticks);
+	}
 }
 
 void bcma_chipco_irq_mask(struct bcma_drv_cc *cc, u32 mask, u32 value)
-- 
1.7.10.4

