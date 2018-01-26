Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:42361 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752642AbeAZJI5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 04:08:57 -0500
From: Jia-Ju Bai <baijiaju1990@gmail.com>
To: zajec5@gmail.com, hauke@hauke-m.de
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] bcma: Replace mdelay with usleep_range in bcma_pmu_resources_init
Date: Fri, 26 Jan 2018 17:13:31 +0800
Message-Id: <1516958011-303-1-git-send-email-baijiaju1990@gmail.com> (sfid-20180126_101003_579860_ABACF0A8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After checking all possible call chains to bcma_pmu_resources_init() here,
my tool finds that this function is never called in atomic context,
namely never in an interrupt handler or holding a spinlock.
Thus mdelay can be replaced with usleep_range to avoid busy wait.

This is found by a static analysis tool named DCNS written by myself.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/bcma/driver_chipcommon_pmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index f1eb4d3..478948c 100644
--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -203,7 +203,7 @@ static void bcma_pmu_resources_init(struct bcma_drv_cc *cc)
 	 * Add some delay; allow resources to come up and settle.
 	 * Delay is required for SoC (early init).
 	 */
-	mdelay(2);
+	usleep_range(1500, 2000);
 }
 
 /* Disable to allow reading SPROM. Don't know the adventages of enabling it. */
-- 
1.7.9.5
