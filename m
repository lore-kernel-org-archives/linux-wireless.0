Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:51359 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab1GNTKx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 15:10:53 -0400
Received: by mail-fx0-f52.google.com with SMTP id 18so1505335fxd.11
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jul 2011 12:10:52 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/4] bcma: cc: set GPIOTIMER register
Date: Thu, 14 Jul 2011 21:49:19 +0200
Message-Id: <1310672961-5311-2-git-send-email-zajec5@gmail.com> (sfid-20110714_211055_467539_93191364)
In-Reply-To: <1310672961-5311-1-git-send-email-zajec5@gmail.com>
References: <1310672961-5311-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We use value supplied via SPROM, or default 10:90 as fallback.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/driver_chipcommon.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcommon.c
index 6061022..fb54302 100644
--- a/drivers/bcma/driver_chipcommon.c
+++ b/drivers/bcma/driver_chipcommon.c
@@ -23,6 +23,9 @@ static inline u32 bcma_cc_write32_masked(struct bcma_drv_cc *cc, u16 offset,
 
 void bcma_core_chipcommon_init(struct bcma_drv_cc *cc)
 {
+	u32 leddc_on = 10;
+	u32 leddc_off = 90;
+
 	if (cc->core->id.rev >= 11)
 		cc->status = bcma_cc_read32(cc, BCMA_CC_CHIPSTAT);
 	cc->capabilities = bcma_cc_read32(cc, BCMA_CC_CAP);
@@ -38,6 +41,17 @@ void bcma_core_chipcommon_init(struct bcma_drv_cc *cc)
 		bcma_pmu_init(cc);
 	if (cc->capabilities & BCMA_CC_CAP_PCTL)
 		pr_err("Power control not implemented!\n");
+
+	if (cc->core->id.rev >= 16) {
+		if (cc->core->bus->sprom.leddc_on_time &&
+		    cc->core->bus->sprom.leddc_off_time) {
+			leddc_on = cc->core->bus->sprom.leddc_on_time;
+			leddc_off = cc->core->bus->sprom.leddc_off_time;
+		}
+		bcma_cc_write32(cc, BCMA_CC_GPIOTIMER,
+			((leddc_on << BCMA_CC_GPIOTIMER_ONTIME_SHIFT) |
+			 (leddc_off << BCMA_CC_GPIOTIMER_OFFTIME_SHIFT)));
+	}
 }
 
 /* Set chip watchdog reset timer to fire in 'ticks' backplane cycles */
-- 
1.7.3.4

