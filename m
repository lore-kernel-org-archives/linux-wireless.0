Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52498 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445Ab2F2XqO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 19:46:14 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org, arend@broadcom.com,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 3/9] bcma: remove fix for 4329b0 bad LPOM is detection
Date: Sat, 30 Jun 2012 01:44:39 +0200
Message-Id: <1341013486-2520-4-git-send-email-hauke@hauke-m.de> (sfid-20120630_014618_362489_3744CBD2)
In-Reply-To: <1341013486-2520-1-git-send-email-hauke@hauke-m.de>
References: <1341013486-2520-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is not core id with 0x4329, but at the same place in the open
source part of the Broadcom SDK is a check for some device with the
chip id of 0x4329. The device with a chip id of 0x4329 is a full mac
device, so it will never be supported by bcma, this part is running in
the firmware of the device and not on the host CPU.
This code is wrong and will never be used, so just remove it.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_chipcommon_pmu.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index 89528cf..2d9ac3e 100644
--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -180,9 +180,6 @@ void bcma_pmu_init(struct bcma_drv_cc *cc)
 		bcma_cc_set32(cc, BCMA_CC_PMU_CTL,
 			     BCMA_CC_PMU_CTL_NOILPONW);
 
-	if (cc->core->id.id == 0x4329 && cc->core->id.rev == 2)
-		pr_err("Fix for 4329b0 bad LPOM state not implemented!\n");
-
 	bcma_pmu_pll_init(cc);
 	bcma_pmu_resources_init(cc);
 	bcma_pmu_swreg_init(cc);
-- 
1.7.9.5

