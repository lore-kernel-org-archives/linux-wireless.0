Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:35907 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170Ab2FEVzf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 17:55:35 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org, arend@broadcom.com,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 8/8] bcma: add mdelay bcma_pmu_resources_init()
Date: Tue,  5 Jun 2012 23:55:07 +0200
Message-Id: <1338933307-13446-9-git-send-email-hauke@hauke-m.de> (sfid-20120605_235539_423984_C4C7A610)
In-Reply-To: <1338933307-13446-1-git-send-email-hauke@hauke-m.de>
References: <1338933307-13446-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is based on code from brcmsmac.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_chipcommon_pmu.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index ea054a2..812ea41 100644
--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -111,6 +111,9 @@ static void bcma_pmu_resources_init(struct bcma_drv_cc *cc)
 		bcma_cc_write32(cc, BCMA_CC_PMU_MINRES_MSK, min_msk);
 	if (max_msk)
 		bcma_cc_write32(cc, BCMA_CC_PMU_MAXRES_MSK, max_msk);
+
+	/* Add some delay; allow resources to come up and settle. */
+	mdelay(2);
 }
 
 static void bcma_pmu_swreg_init(struct bcma_drv_cc *cc)
-- 
1.7.9.5

