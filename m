Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:43870 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752041AbeAZQeA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 11:34:00 -0500
From: Jia-Ju Bai <baijiaju1990@gmail.com>
To: Larry.Finger@lwfinger.net, kvalo@codeaurora.org, zajec5@gmail.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH v2] bcma: Replace mdelay with usleep_range in bcma_pmu_resources_init
Date: Sat, 27 Jan 2018 00:38:35 +0800
Message-Id: <1516984715-9237-1-git-send-email-baijiaju1990@gmail.com> (sfid-20180126_173437_082519_924D8085)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After checking all possible call chains to bcma_pmu_resources_init() here,
my tool finds that this function is never called in atomic context,
namely never in an interrupt handler or holding a spinlock.
Thus mdelay can be replaced with usleep_range to avoid busy wait.

This is found by a static analysis tool named DCNS written by myself.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
v2:
* Use usleep_range(2000, 2500), instead of (1500, 2000) in v1.

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
+	usleep_range(2000, 2500);
 }
 
 /* Disable to allow reading SPROM. Don't know the adventages of enabling it. */
-- 
1.7.9.5
