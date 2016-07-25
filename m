Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:33562 "EHLO
	mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbcGYSeS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jul 2016 14:34:18 -0400
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org (open list:BROADCOM SPECIFIC AMBA DRIVER
	(BCMA)), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] bcma: support BCM53573 series of wireless SoCs
Date: Mon, 25 Jul 2016 20:33:56 +0200
Message-Id: <1469471640-15656-1-git-send-email-zajec5@gmail.com> (sfid-20160725_203438_467336_A5691896)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

BCM53573 seems to be the first series of Northstar family with wireless
on the chip. The base models are BCM53573-s (A0, A1) and there is also
BCM47189B0 which seems to be some small modification.

The only problem with these chipsets seems to be watchdog. It's totally
unavailable on 53573A0 / 53573A1 and preferable PMU watchdog is broken
on 53573B0 / 53573B1.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/driver_chipcommon.c | 32 +++++++++++++++++++++++++++++---
 include/linux/bcma/bcma.h        |  3 +++
 2 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcommon.c
index 921ce18..b4f6520 100644
--- a/drivers/bcma/driver_chipcommon.c
+++ b/drivers/bcma/driver_chipcommon.c
@@ -36,12 +36,31 @@ u32 bcma_chipco_get_alp_clock(struct bcma_drv_cc *cc)
 }
 EXPORT_SYMBOL_GPL(bcma_chipco_get_alp_clock);
 
+static bool bcma_core_cc_has_pmu_watchdog(struct bcma_drv_cc *cc)
+{
+	struct bcma_bus *bus = cc->core->bus;
+
+	if (cc->capabilities & BCMA_CC_CAP_PMU) {
+		if (bus->chipinfo.id == BCMA_CHIP_ID_BCM53573) {
+			WARN(bus->chipinfo.rev <= 1, "No watchdog available\n");
+			/* 53573B0 and 53573B1 have bugged PMU watchdog. It can
+			 * be enabled but timer can't be bumped. Use CC one
+			 * instead.
+			 */
+			return false;
+		}
+		return true;
+	} else {
+		return false;
+	}
+}
+
 static u32 bcma_chipco_watchdog_get_max_timer(struct bcma_drv_cc *cc)
 {
 	struct bcma_bus *bus = cc->core->bus;
 	u32 nb;
 
-	if (cc->capabilities & BCMA_CC_CAP_PMU) {
+	if (bcma_core_cc_has_pmu_watchdog(cc)) {
 		if (bus->chipinfo.id == BCMA_CHIP_ID_BCM4706)
 			nb = 32;
 		else if (cc->core->id.rev < 26)
@@ -95,9 +114,16 @@ static int bcma_chipco_watchdog_ticks_per_ms(struct bcma_drv_cc *cc)
 
 int bcma_chipco_watchdog_register(struct bcma_drv_cc *cc)
 {
+	struct bcma_bus *bus = cc->core->bus;
 	struct bcm47xx_wdt wdt = {};
 	struct platform_device *pdev;
 
+	if (bus->chipinfo.id == BCMA_CHIP_ID_BCM53573 &&
+	    bus->chipinfo.rev <= 1) {
+		pr_debug("No watchdog on 53573A0 / 53573A1\n");
+		return 0;
+	}
+
 	wdt.driver_data = cc;
 	wdt.timer_set = bcma_chipco_watchdog_timer_set_wdt;
 	wdt.timer_set_ms = bcma_chipco_watchdog_timer_set_ms_wdt;
@@ -105,7 +131,7 @@ int bcma_chipco_watchdog_register(struct bcma_drv_cc *cc)
 		bcma_chipco_watchdog_get_max_timer(cc) / cc->ticks_per_ms;
 
 	pdev = platform_device_register_data(NULL, "bcm47xx-wdt",
-					     cc->core->bus->num, &wdt,
+					     bus->num, &wdt,
 					     sizeof(wdt));
 	if (IS_ERR(pdev))
 		return PTR_ERR(pdev);
@@ -217,7 +243,7 @@ u32 bcma_chipco_watchdog_timer_set(struct bcma_drv_cc *cc, u32 ticks)
 	u32 maxt;
 
 	maxt = bcma_chipco_watchdog_get_max_timer(cc);
-	if (cc->capabilities & BCMA_CC_CAP_PMU) {
+	if (bcma_core_cc_has_pmu_watchdog(cc)) {
 		if (ticks == 1)
 			ticks = 2;
 		else if (ticks > maxt)
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index e6b41f4..478e5cf 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -204,6 +204,9 @@ struct bcma_host_ops {
 #define  BCMA_PKG_ID_BCM4709	0
 #define BCMA_CHIP_ID_BCM47094	53030
 #define BCMA_CHIP_ID_BCM53018	53018
+#define BCMA_CHIP_ID_BCM53573	53573
+#define  BCMA_PKG_ID_BCM53573	0
+#define  BCMA_PKG_ID_BCM47189	1
 
 /* Board types (on PCI usually equals to the subsystem dev id) */
 /* BCM4313 */
-- 
1.8.4.5

