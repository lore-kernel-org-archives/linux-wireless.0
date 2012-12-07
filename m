Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63647 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933053Ab2LGL5F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 06:57:05 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so174080bkw.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Dec 2012 03:57:04 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V2] bcma: unify naming schema for clock functions
Date: Fri,  7 Dec 2012 12:56:56 +0100
Message-Id: <1354881416-8520-1-git-send-email-zajec5@gmail.com> (sfid-20121207_125711_477039_12F27049)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
V2: rename also bcma_chipco_alp_clock
---
 drivers/bcma/bcma_private.h          |    4 +-
 drivers/bcma/driver_chipcommon.c     |   10 ++++----
 drivers/bcma/driver_chipcommon_pmu.c |   39 ++++++++++++++++++---------------
 drivers/bcma/driver_mips.c           |    2 +-
 4 files changed, 29 insertions(+), 26 deletions(-)

diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index bcb830e..537ae53 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -48,8 +48,8 @@ void bcma_chipco_serial_init(struct bcma_drv_cc *cc);
 #endif /* CONFIG_BCMA_DRIVER_MIPS */
 
 /* driver_chipcommon_pmu.c */
-u32 bcma_pmu_alp_clock(struct bcma_drv_cc *cc);
-u32 bcma_pmu_get_clockcpu(struct bcma_drv_cc *cc);
+u32 bcma_pmu_get_alp_clock(struct bcma_drv_cc *cc);
+u32 bcma_pmu_get_cpu_clock(struct bcma_drv_cc *cc);
 
 #ifdef CONFIG_BCMA_SFLASH
 /* driver_chipcommon_sflash.c */
diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcommon.c
index d017f25..dc96dd8 100644
--- a/drivers/bcma/driver_chipcommon.c
+++ b/drivers/bcma/driver_chipcommon.c
@@ -25,10 +25,10 @@ static inline u32 bcma_cc_write32_masked(struct bcma_drv_cc *cc, u16 offset,
 	return value;
 }
 
-static u32 bcma_chipco_alp_clock(struct bcma_drv_cc *cc)
+static u32 bcma_chipco_get_alp_clock(struct bcma_drv_cc *cc)
 {
 	if (cc->capabilities & BCMA_CC_CAP_PMU)
-		return bcma_pmu_alp_clock(cc);
+		return bcma_pmu_get_alp_clock(cc);
 
 	return 20000000;
 }
@@ -79,12 +79,12 @@ static int bcma_chipco_watchdog_ticks_per_ms(struct bcma_drv_cc *cc)
 	if (cc->capabilities & BCMA_CC_CAP_PMU) {
 		if (bus->chipinfo.id == BCMA_CHIP_ID_BCM4706)
 			/* 4706 CC and PMU watchdogs are clocked at 1/4 of ALP clock */
-			return bcma_chipco_alp_clock(cc) / 4000;
+			return bcma_chipco_get_alp_clock(cc) / 4000;
 		else
 			/* based on 32KHz ILP clock */
 			return 32;
 	} else {
-		return bcma_chipco_alp_clock(cc) / 1000;
+		return bcma_chipco_get_alp_clock(cc) / 1000;
 	}
 }
 
@@ -236,7 +236,7 @@ void bcma_chipco_serial_init(struct bcma_drv_cc *cc)
 	struct bcma_serial_port *ports = cc->serial_ports;
 
 	if (ccrev >= 11 && ccrev != 15) {
-		baud_base = bcma_chipco_alp_clock(cc);
+		baud_base = bcma_chipco_get_alp_clock(cc);
 		if (ccrev >= 21) {
 			/* Turn off UART clock before switching clocksource. */
 			bcma_cc_write32(cc, BCMA_CC_CORECTL,
diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index a63ddd9..e162999 100644
--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -168,7 +168,7 @@ void bcma_pmu_init(struct bcma_drv_cc *cc)
 	bcma_pmu_workarounds(cc);
 }
 
-u32 bcma_pmu_alp_clock(struct bcma_drv_cc *cc)
+u32 bcma_pmu_get_alp_clock(struct bcma_drv_cc *cc)
 {
 	struct bcma_bus *bus = cc->core->bus;
 
@@ -196,7 +196,7 @@ u32 bcma_pmu_alp_clock(struct bcma_drv_cc *cc)
 /* Find the output of the "m" pll divider given pll controls that start with
  * pllreg "pll0" i.e. 12 for main 6 for phy, 0 for misc.
  */
-static u32 bcma_pmu_clock(struct bcma_drv_cc *cc, u32 pll0, u32 m)
+static u32 bcma_pmu_pll_clock(struct bcma_drv_cc *cc, u32 pll0, u32 m)
 {
 	u32 tmp, div, ndiv, p1, p2, fc;
 	struct bcma_bus *bus = cc->core->bus;
@@ -225,14 +225,14 @@ static u32 bcma_pmu_clock(struct bcma_drv_cc *cc, u32 pll0, u32 m)
 	ndiv = (tmp & BCMA_CC_PPL_NDIV_MASK) >> BCMA_CC_PPL_NDIV_SHIFT;
 
 	/* Do calculation in Mhz */
-	fc = bcma_pmu_alp_clock(cc) / 1000000;
+	fc = bcma_pmu_get_alp_clock(cc) / 1000000;
 	fc = (p1 * ndiv * fc) / p2;
 
 	/* Return clock in Hertz */
 	return (fc / div) * 1000000;
 }
 
-static u32 bcma_pmu_clock_bcm4706(struct bcma_drv_cc *cc, u32 pll0, u32 m)
+static u32 bcma_pmu_pll_clock_bcm4706(struct bcma_drv_cc *cc, u32 pll0, u32 m)
 {
 	u32 tmp, ndiv, p1div, p2div;
 	u32 clock;
@@ -263,7 +263,7 @@ static u32 bcma_pmu_clock_bcm4706(struct bcma_drv_cc *cc, u32 pll0, u32 m)
 }
 
 /* query bus clock frequency for PMU-enabled chipcommon */
-static u32 bcma_pmu_get_clockcontrol(struct bcma_drv_cc *cc)
+static u32 bcma_pmu_get_bus_clock(struct bcma_drv_cc *cc)
 {
 	struct bcma_bus *bus = cc->core->bus;
 
@@ -271,40 +271,42 @@ static u32 bcma_pmu_get_clockcontrol(struct bcma_drv_cc *cc)
 	case BCMA_CHIP_ID_BCM4716:
 	case BCMA_CHIP_ID_BCM4748:
 	case BCMA_CHIP_ID_BCM47162:
-		return bcma_pmu_clock(cc, BCMA_CC_PMU4716_MAINPLL_PLL0,
-				      BCMA_CC_PMU5_MAINPLL_SSB);
+		return bcma_pmu_pll_clock(cc, BCMA_CC_PMU4716_MAINPLL_PLL0,
+					  BCMA_CC_PMU5_MAINPLL_SSB);
 	case BCMA_CHIP_ID_BCM5356:
-		return bcma_pmu_clock(cc, BCMA_CC_PMU5356_MAINPLL_PLL0,
-				      BCMA_CC_PMU5_MAINPLL_SSB);
+		return bcma_pmu_pll_clock(cc, BCMA_CC_PMU5356_MAINPLL_PLL0,
+					  BCMA_CC_PMU5_MAINPLL_SSB);
 	case BCMA_CHIP_ID_BCM5357:
 	case BCMA_CHIP_ID_BCM4749:
-		return bcma_pmu_clock(cc, BCMA_CC_PMU5357_MAINPLL_PLL0,
-				      BCMA_CC_PMU5_MAINPLL_SSB);
+		return bcma_pmu_pll_clock(cc, BCMA_CC_PMU5357_MAINPLL_PLL0,
+					  BCMA_CC_PMU5_MAINPLL_SSB);
 	case BCMA_CHIP_ID_BCM4706:
-		return bcma_pmu_clock_bcm4706(cc, BCMA_CC_PMU4706_MAINPLL_PLL0,
-					      BCMA_CC_PMU5_MAINPLL_SSB);
+		return bcma_pmu_pll_clock_bcm4706(cc,
+						  BCMA_CC_PMU4706_MAINPLL_PLL0,
+						  BCMA_CC_PMU5_MAINPLL_SSB);
 	case BCMA_CHIP_ID_BCM53572:
 		return 75000000;
 	default:
-		bcma_warn(bus, "No backplane clock specified for %04X device, pmu rev. %d, using default %d Hz\n",
+		bcma_warn(bus, "No bus clock specified for %04X device, pmu rev. %d, using default %d Hz\n",
 			  bus->chipinfo.id, cc->pmu.rev, BCMA_CC_PMU_HT_CLOCK);
 	}
 	return BCMA_CC_PMU_HT_CLOCK;
 }
 
 /* query cpu clock frequency for PMU-enabled chipcommon */
-u32 bcma_pmu_get_clockcpu(struct bcma_drv_cc *cc)
+u32 bcma_pmu_get_cpu_clock(struct bcma_drv_cc *cc)
 {
 	struct bcma_bus *bus = cc->core->bus;
 
 	if (bus->chipinfo.id == BCMA_CHIP_ID_BCM53572)
 		return 300000000;
 
+	/* New PMUs can have different clock for bus and CPU */
 	if (cc->pmu.rev >= 5) {
 		u32 pll;
 		switch (bus->chipinfo.id) {
 		case BCMA_CHIP_ID_BCM4706:
-			return bcma_pmu_clock_bcm4706(cc,
+			return bcma_pmu_pll_clock_bcm4706(cc,
 						BCMA_CC_PMU4706_MAINPLL_PLL0,
 						BCMA_CC_PMU5_MAINPLL_CPU);
 		case BCMA_CHIP_ID_BCM5356:
@@ -319,10 +321,11 @@ u32 bcma_pmu_get_clockcpu(struct bcma_drv_cc *cc)
 			break;
 		}
 
-		return bcma_pmu_clock(cc, pll, BCMA_CC_PMU5_MAINPLL_CPU);
+		return bcma_pmu_pll_clock(cc, pll, BCMA_CC_PMU5_MAINPLL_CPU);
 	}
 
-	return bcma_pmu_get_clockcontrol(cc);
+	/* On old PMUs CPU has the same clock as the bus */
+	return bcma_pmu_get_bus_clock(cc);
 }
 
 static void bcma_pmu_spuravoid_pll_write(struct bcma_drv_cc *cc, u32 offset,
diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
index 170822e..c45ded8 100644
--- a/drivers/bcma/driver_mips.c
+++ b/drivers/bcma/driver_mips.c
@@ -171,7 +171,7 @@ u32 bcma_cpu_clock(struct bcma_drv_mips *mcore)
 	struct bcma_bus *bus = mcore->core->bus;
 
 	if (bus->drv_cc.capabilities & BCMA_CC_CAP_PMU)
-		return bcma_pmu_get_clockcpu(&bus->drv_cc);
+		return bcma_pmu_get_cpu_clock(&bus->drv_cc);
 
 	bcma_err(bus, "No PMU available, need this to get the cpu clock\n");
 	return 0;
-- 
1.7.7

