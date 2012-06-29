Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52545 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755446Ab2F2XqZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 19:46:25 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org, arend@broadcom.com,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 9/9] bcma: add mdelay bcma_pmu_resources_init()
Date: Sat, 30 Jun 2012 01:44:45 +0200
Message-Id: <1341013486-2520-10-git-send-email-hauke@hauke-m.de> (sfid-20120630_014628_420973_169A3D27)
In-Reply-To: <1341013486-2520-1-git-send-email-hauke@hauke-m.de>
References: <1341013486-2520-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is based on code from brcmsmac.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_chipcommon_pmu.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index 35c9130..ca5a919 100644
--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -75,6 +75,9 @@ static void bcma_pmu_resources_init(struct bcma_drv_cc *cc)
 		bcma_cc_write32(cc, BCMA_CC_PMU_MINRES_MSK, min_msk);
 	if (max_msk)
 		bcma_cc_write32(cc, BCMA_CC_PMU_MAXRES_MSK, max_msk);
+
+	/* Add some delay; allow resources to come up and settle. */
+	mdelay(2);
 }
 
 /* Disable to allow reading SPROM. Don't know the adventages of enabling it. */
-- 
1.7.9.5

