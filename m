Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:35865 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885Ab2FEVzZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 17:55:25 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org, arend@broadcom.com,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/8] bcma: Fix for 4329b0 bad LPOM is detection
Date: Tue,  5 Jun 2012 23:55:02 +0200
Message-Id: <1338933307-13446-4-git-send-email-hauke@hauke-m.de> (sfid-20120605_235528_196942_BBA0B19D)
In-Reply-To: <1338933307-13446-1-git-send-email-hauke@hauke-m.de>
References: <1338933307-13446-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This workaround should be triggered based on the chipid and rev and not
the core id and rev. This is based on code in the Broadcom SDK.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_chipcommon_pmu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index da8769e..dd2b55d 100644
--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -166,6 +166,7 @@ static void bcma_pmu_workarounds(struct bcma_drv_cc *cc)
 void bcma_pmu_init(struct bcma_drv_cc *cc)
 {
 	u32 pmucap;
+	struct bcma_bus *bus = cc->core->bus;
 
 	pmucap = bcma_cc_read32(cc, BCMA_CC_PMU_CAP);
 	cc->pmu.rev = (pmucap & BCMA_CC_PMU_CAP_REVISION);
@@ -180,7 +181,7 @@ void bcma_pmu_init(struct bcma_drv_cc *cc)
 		bcma_cc_set32(cc, BCMA_CC_PMU_CTL,
 			     BCMA_CC_PMU_CTL_NOILPONW);
 
-	if (cc->core->id.id == 0x4329 && cc->core->id.rev == 2)
+	if (bus->chipinfo.id == 0x4329 && bus->chipinfo.rev == 2)
 		pr_err("Fix for 4329b0 bad LPOM state not implemented!\n");
 
 	bcma_pmu_pll_init(cc);
-- 
1.7.9.5

