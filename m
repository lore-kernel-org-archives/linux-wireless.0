Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47363 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035Ab2LERsK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 12:48:10 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, wim@iguana.be
Cc: linux-wireless@vger.kernel.org, linux-watchdog@vger.kernel.org,
	castet.matthieu@free.fr, biblbroks@sezampro.rs, m@bues.ch,
	zajec5@gmail.com, linux-mips@linux-mips.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v3 07/11] ssb: set the PMU watchdog if available
Date: Wed,  5 Dec 2012 18:46:04 +0100
Message-Id: <1354729568-19993-8-git-send-email-hauke@hauke-m.de> (sfid-20121205_184814_984484_8E343F9E)
In-Reply-To: <1354729568-19993-1-git-send-email-hauke@hauke-m.de>
References: <1354729568-19993-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some ssb based devices have a PMU and the PMU watchdog register should
be used instead of the register in the chip common part, if the device
has a PMU. This patch also calculates the maximal number the watchdog
could be set to.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/ssb/driver_chipcommon.c |   38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/ssb/driver_chipcommon.c b/drivers/ssb/driver_chipcommon.c
index 603b630..6e080f6 100644
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

