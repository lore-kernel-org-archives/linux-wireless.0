Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47304 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820Ab2LERra (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 12:47:30 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, wim@iguana.be
Cc: linux-wireless@vger.kernel.org, linux-watchdog@vger.kernel.org,
	castet.matthieu@free.fr, biblbroks@sezampro.rs, m@bues.ch,
	zajec5@gmail.com, linux-mips@linux-mips.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v3 02/11] bcma: add bcma_chipco_alp_clock
Date: Wed,  5 Dec 2012 18:45:59 +0100
Message-Id: <1354729568-19993-3-git-send-email-hauke@hauke-m.de> (sfid-20121205_184733_067110_DA52B7B3)
In-Reply-To: <1354729568-19993-1-git-send-email-hauke@hauke-m.de>
References: <1354729568-19993-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For devices without a PMU the alp clock is always 20000000.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_chipcommon.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcommon.c
index ffd74e5..ef68553 100644
--- a/drivers/bcma/driver_chipcommon.c
+++ b/drivers/bcma/driver_chipcommon.c
@@ -4,6 +4,7 @@
  *
  * Copyright 2005, Broadcom Corporation
  * Copyright 2006, 2007, Michael Buesch <m@bues.ch>
+ * Copyright 2012, Hauke Mehrtens <hauke@hauke-m.de>
  *
  * Licensed under the GNU/GPL. See COPYING for details.
  */
@@ -22,6 +23,14 @@ static inline u32 bcma_cc_write32_masked(struct bcma_drv_cc *cc, u16 offset,
 	return value;
 }
 
+static u32 bcma_chipco_alp_clock(struct bcma_drv_cc *cc)
+{
+	if (cc->capabilities & BCMA_CC_CAP_PMU)
+		return bcma_pmu_alp_clock(cc);
+
+	return 20000000;
+}
+
 void bcma_core_chipcommon_early_init(struct bcma_drv_cc *cc)
 {
 	if (cc->early_setup_done)
@@ -131,8 +140,7 @@ void bcma_chipco_serial_init(struct bcma_drv_cc *cc)
 	struct bcma_serial_port *ports = cc->serial_ports;
 
 	if (ccrev >= 11 && ccrev != 15) {
-		/* Fixed ALP clock */
-		baud_base = bcma_pmu_alp_clock(cc);
+		baud_base = bcma_chipco_alp_clock(cc);
 		if (ccrev >= 21) {
 			/* Turn off UART clock before switching clocksource. */
 			bcma_cc_write32(cc, BCMA_CC_CORECTL,
-- 
1.7.10.4

