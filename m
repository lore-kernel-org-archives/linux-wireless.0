Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:37146 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744Ab3C0QXg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 12:23:36 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/4] bcma: export bcma_chipco_get_alp_clock()
Date: Wed, 27 Mar 2013 17:23:11 +0100
Message-Id: <1364401392-30360-4-git-send-email-hauke@hauke-m.de> (sfid-20130327_172352_438795_4E31A6E5)
In-Reply-To: <1364401392-30360-1-git-send-email-hauke@hauke-m.de>
References: <1364401392-30360-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function will be used by brcmsmac.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_chipcommon.c            |    3 ++-
 include/linux/bcma/bcma_driver_chipcommon.h |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcommon.c
index 28fa50a..88db0cb 100644
--- a/drivers/bcma/driver_chipcommon.c
+++ b/drivers/bcma/driver_chipcommon.c
@@ -25,13 +25,14 @@ static inline u32 bcma_cc_write32_masked(struct bcma_drv_cc *cc, u16 offset,
 	return value;
 }
 
-static u32 bcma_chipco_get_alp_clock(struct bcma_drv_cc *cc)
+u32 bcma_chipco_get_alp_clock(struct bcma_drv_cc *cc)
 {
 	if (cc->capabilities & BCMA_CC_CAP_PMU)
 		return bcma_pmu_get_alp_clock(cc);
 
 	return 20000000;
 }
+EXPORT_SYMBOL_GPL(bcma_chipco_get_alp_clock);
 
 static u32 bcma_chipco_watchdog_get_max_timer(struct bcma_drv_cc *cc)
 {
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index 1db4c6d..453fcc9 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -608,6 +608,8 @@ void bcma_chipco_bcm4331_ext_pa_lines_ctl(struct bcma_drv_cc *cc, bool enable);
 
 extern u32 bcma_chipco_watchdog_timer_set(struct bcma_drv_cc *cc, u32 ticks);
 
+extern u32 bcma_chipco_get_alp_clock(struct bcma_drv_cc *cc);
+
 void bcma_chipco_irq_mask(struct bcma_drv_cc *cc, u32 mask, u32 value);
 
 u32 bcma_chipco_irq_status(struct bcma_drv_cc *cc, u32 mask);
-- 
1.7.10.4

