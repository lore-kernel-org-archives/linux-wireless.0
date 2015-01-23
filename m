Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:58491 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbbAWXXm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 18:23:42 -0500
Received: by mail-wi0-f179.google.com with SMTP id l15so231190wiw.0
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2015 15:23:41 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: fix watchdog on some ARM chipsets
Date: Sat, 24 Jan 2015 00:23:21 +0100
Message-Id: <1422055401-15029-1-git-send-email-zajec5@gmail.com> (sfid-20150124_002345_842912_C2037917)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These chipsets don't need changing clock mode.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
This patch adds one line with more than 80 columns, I hope it's OK, IMO it
improves readability.
---
 drivers/bcma/driver_chipcommon.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcommon.c
index 84d4a95..b7c8a8d 100644
--- a/drivers/bcma/driver_chipcommon.c
+++ b/drivers/bcma/driver_chipcommon.c
@@ -178,7 +178,6 @@ void bcma_core_chipcommon_init(struct bcma_drv_cc *cc)
 u32 bcma_chipco_watchdog_timer_set(struct bcma_drv_cc *cc, u32 ticks)
 {
 	u32 maxt;
-	enum bcma_clkmode clkmode;
 
 	maxt = bcma_chipco_watchdog_get_max_timer(cc);
 	if (cc->capabilities & BCMA_CC_CAP_PMU) {
@@ -188,8 +187,13 @@ u32 bcma_chipco_watchdog_timer_set(struct bcma_drv_cc *cc, u32 ticks)
 			ticks = maxt;
 		bcma_cc_write32(cc, BCMA_CC_PMU_WATCHDOG, ticks);
 	} else {
-		clkmode = ticks ? BCMA_CLKMODE_FAST : BCMA_CLKMODE_DYNAMIC;
-		bcma_core_set_clockmode(cc->core, clkmode);
+		struct bcma_bus *bus = cc->core->bus;
+
+		if (bus->chipinfo.id != BCMA_CHIP_ID_BCM4707 &&
+		    bus->chipinfo.id != BCMA_CHIP_ID_BCM53018)
+			bcma_core_set_clockmode(cc->core,
+						ticks ? BCMA_CLKMODE_FAST : BCMA_CLKMODE_DYNAMIC);
+
 		if (ticks > maxt)
 			ticks = maxt;
 		/* instant NMI */
-- 
1.8.4.5

