Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:35874 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885Ab2FEVz1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 17:55:27 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org, arend@broadcom.com,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/8] bcma: add constants for chip ids
Date: Tue,  5 Jun 2012 23:55:01 +0200
Message-Id: <1338933307-13446-3-git-send-email-hauke@hauke-m.de> (sfid-20120605_235530_929266_AF4FDC9B)
In-Reply-To: <1338933307-13446-1-git-send-email-hauke@hauke-m.de>
References: <1338933307-13446-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The chip IDs are used all over bcma and no constants where defined.
This patch adds the constants and makes bcma use them.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_chipcommon_pmu.c |   81 +++++++++++++++++-----------------
 drivers/bcma/driver_mips.c           |    8 ++--
 drivers/bcma/driver_pci_host.c       |    8 ++--
 drivers/bcma/sprom.c                 |   18 ++++----
 include/linux/bcma/bcma.h            |   30 +++++++++++++
 5 files changed, 90 insertions(+), 55 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index 65fae62..da8769e 100644
--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -59,10 +59,10 @@ static void bcma_pmu_pll_init(struct bcma_drv_cc *cc)
 	struct bcma_bus *bus = cc->core->bus;
 
 	switch (bus->chipinfo.id) {
-	case 0x4313:
-	case 0x4331:
-	case 43224:
-	case 43225:
+	case BCMA_CHIP_ID_BCM4313:
+	case BCMA_CHIP_ID_BCM4331:
+	case BCMA_CHIP_ID_BCM43224:
+	case BCMA_CHIP_ID_BCM43225:
 		break;
 	default:
 		pr_err("PLL init unknown for device 0x%04X\n",
@@ -76,13 +76,13 @@ static void bcma_pmu_resources_init(struct bcma_drv_cc *cc)
 	u32 min_msk = 0, max_msk = 0;
 
 	switch (bus->chipinfo.id) {
-	case 0x4313:
+	case BCMA_CHIP_ID_BCM4313:
 		min_msk = 0x200D;
 		max_msk = 0xFFFF;
 		break;
-	case 0x4331:
-	case 43224:
-	case 43225:
+	case BCMA_CHIP_ID_BCM4331:
+	case BCMA_CHIP_ID_BCM43224:
+	case BCMA_CHIP_ID_BCM43225:
 		break;
 	default:
 		pr_err("PMU resource config unknown for device 0x%04X\n",
@@ -101,10 +101,10 @@ static void bcma_pmu_swreg_init(struct bcma_drv_cc *cc)
 	struct bcma_bus *bus = cc->core->bus;
 
 	switch (bus->chipinfo.id) {
-	case 0x4313:
-	case 0x4331:
-	case 43224:
-	case 43225:
+	case BCMA_CHIP_ID_BCM4313:
+	case BCMA_CHIP_ID_BCM4331:
+	case BCMA_CHIP_ID_BCM43224:
+	case BCMA_CHIP_ID_BCM43225:
 		break;
 	default:
 		pr_err("PMU switch/regulators init unknown for device "
@@ -138,15 +138,15 @@ static void bcma_pmu_workarounds(struct bcma_drv_cc *cc)
 	struct bcma_bus *bus = cc->core->bus;
 
 	switch (bus->chipinfo.id) {
-	case 0x4313:
+	case BCMA_CHIP_ID_BCM4313:
 		bcma_chipco_chipctl_maskset(cc, 0, ~0, 0x7);
 		break;
-	case 0x4331:
-	case 43431:
+	case BCMA_CHIP_ID_BCM4331:
+	case BCMA_CHIP_ID_BCM43431:
 		/* Ext PA lines must be enabled for tx on BCM4331 */
 		bcma_chipco_bcm4331_ext_pa_lines_ctl(cc, true);
 		break;
-	case 43224:
+	case BCMA_CHIP_ID_BCM43224:
 		if (bus->chipinfo.rev == 0) {
 			pr_err("Workarounds for 43224 rev 0 not fully "
 				"implemented\n");
@@ -155,7 +155,7 @@ static void bcma_pmu_workarounds(struct bcma_drv_cc *cc)
 			bcma_chipco_chipctl_maskset(cc, 0, ~0, 0xF0);
 		}
 		break;
-	case 43225:
+	case BCMA_CHIP_ID_BCM43225:
 		break;
 	default:
 		pr_err("Workarounds unknown for device 0x%04X\n",
@@ -194,17 +194,17 @@ u32 bcma_pmu_alp_clock(struct bcma_drv_cc *cc)
 	struct bcma_bus *bus = cc->core->bus;
 
 	switch (bus->chipinfo.id) {
-	case 0x4716:
-	case 0x4748:
-	case 47162:
-	case 0x4313:
-	case 0x5357:
-	case 0x4749:
-	case 53572:
+	case BCMA_CHIP_ID_BCM4716:
+	case BCMA_CHIP_ID_BCM4748:
+	case BCMA_CHIP_ID_BCM47162:
+	case BCMA_CHIP_ID_BCM4313:
+	case BCMA_CHIP_ID_BCM5357:
+	case BCMA_CHIP_ID_BCM4749:
+	case BCMA_CHIP_ID_BCM53572:
 		/* always 20Mhz */
 		return 20000 * 1000;
-	case 0x5356:
-	case 0x5300:
+	case BCMA_CHIP_ID_BCM5356:
+	case BCMA_CHIP_ID_BCM4706:
 		/* always 25Mhz */
 		return 25000 * 1000;
 	default:
@@ -227,7 +227,8 @@ static u32 bcma_pmu_clock(struct bcma_drv_cc *cc, u32 pll0, u32 m)
 
 	BUG_ON(!m || m > 4);
 
-	if (bus->chipinfo.id == 0x5357 || bus->chipinfo.id == 0x4749) {
+	if (bus->chipinfo.id == BCMA_CHIP_ID_BCM5357 ||
+	    bus->chipinfo.id == BCMA_CHIP_ID_BCM4749) {
 		/* Detect failure in clock setting */
 		tmp = bcma_cc_read32(cc, BCMA_CC_CHIPSTAT);
 		if (tmp & 0x40000)
@@ -259,22 +260,22 @@ static u32 bcma_pmu_get_clockcontrol(struct bcma_drv_cc *cc)
 	struct bcma_bus *bus = cc->core->bus;
 
 	switch (bus->chipinfo.id) {
-	case 0x4716:
-	case 0x4748:
-	case 47162:
+	case BCMA_CHIP_ID_BCM4716:
+	case BCMA_CHIP_ID_BCM4748:
+	case BCMA_CHIP_ID_BCM47162:
 		return bcma_pmu_clock(cc, BCMA_CC_PMU4716_MAINPLL_PLL0,
 				      BCMA_CC_PMU5_MAINPLL_SSB);
-	case 0x5356:
+	case BCMA_CHIP_ID_BCM5356:
 		return bcma_pmu_clock(cc, BCMA_CC_PMU5356_MAINPLL_PLL0,
 				      BCMA_CC_PMU5_MAINPLL_SSB);
-	case 0x5357:
-	case 0x4749:
+	case BCMA_CHIP_ID_BCM5357:
+	case BCMA_CHIP_ID_BCM4749:
 		return bcma_pmu_clock(cc, BCMA_CC_PMU5357_MAINPLL_PLL0,
 				      BCMA_CC_PMU5_MAINPLL_SSB);
-	case 0x5300:
+	case BCMA_CHIP_ID_BCM4706:
 		return bcma_pmu_clock(cc, BCMA_CC_PMU4706_MAINPLL_PLL0,
 				      BCMA_CC_PMU5_MAINPLL_SSB);
-	case 53572:
+	case BCMA_CHIP_ID_BCM53572:
 		return 75000000;
 	default:
 		pr_warn("No backplane clock specified for %04X device, "
@@ -289,17 +290,17 @@ u32 bcma_pmu_get_clockcpu(struct bcma_drv_cc *cc)
 {
 	struct bcma_bus *bus = cc->core->bus;
 
-	if (bus->chipinfo.id == 53572)
+	if (bus->chipinfo.id == BCMA_CHIP_ID_BCM53572)
 		return 300000000;
 
 	if (cc->pmu.rev >= 5) {
 		u32 pll;
 		switch (bus->chipinfo.id) {
-		case 0x5356:
+		case BCMA_CHIP_ID_BCM5356:
 			pll = BCMA_CC_PMU5356_MAINPLL_PLL0;
 			break;
-		case 0x5357:
-		case 0x4749:
+		case BCMA_CHIP_ID_BCM5357:
+		case BCMA_CHIP_ID_BCM4749:
 			pll = BCMA_CC_PMU5357_MAINPLL_PLL0;
 			break;
 		default:
@@ -307,7 +308,7 @@ u32 bcma_pmu_get_clockcpu(struct bcma_drv_cc *cc)
 			break;
 		}
 
-		/* TODO: if (bus->chipinfo.id == 0x5300)
+		/* TODO: if (bus->chipinfo.id == BCMA_CHIP_ID_BCM4706)
 		  return si_4706_pmu_clock(sih, osh, cc, PMU4706_MAINPLL_PLL0, PMU5_MAINPLL_CPU); */
 		return bcma_pmu_clock(cc, pll, BCMA_CC_PMU5_MAINPLL_CPU);
 	}
diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
index c3e9dff..73ed3017 100644
--- a/drivers/bcma/driver_mips.c
+++ b/drivers/bcma/driver_mips.c
@@ -22,15 +22,15 @@
 /* The 47162a0 hangs when reading MIPS DMP registers registers */
 static inline bool bcma_core_mips_bcm47162a0_quirk(struct bcma_device *dev)
 {
-	return dev->bus->chipinfo.id == 47162 && dev->bus->chipinfo.rev == 0 &&
-	       dev->id.id == BCMA_CORE_MIPS_74K;
+	return dev->bus->chipinfo.id == BCMA_CHIP_ID_BCM47162 &&
+	       dev->bus->chipinfo.rev == 0 && dev->id.id == BCMA_CORE_MIPS_74K;
 }
 
 /* The 5357b0 hangs when reading USB20H DMP registers */
 static inline bool bcma_core_mips_bcm5357b0_quirk(struct bcma_device *dev)
 {
-	return (dev->bus->chipinfo.id == 0x5357 ||
-		dev->bus->chipinfo.id == 0x4749) &&
+	return (dev->bus->chipinfo.id == BCMA_CHIP_ID_BCM5357 ||
+		dev->bus->chipinfo.id == BCMA_CHIP_ID_BCM4749) &&
 	       dev->bus->chipinfo.pkg == 11 &&
 	       dev->id.id == BCMA_CORE_USB20_HOST;
 }
diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
index b9a86ed..d6e8a37 100644
--- a/drivers/bcma/driver_pci_host.c
+++ b/drivers/bcma/driver_pci_host.c
@@ -215,7 +215,8 @@ static int bcma_extpci_write_config(struct bcma_drv_pci *pc, unsigned int dev,
 	} else {
 		writel(val, mmio);
 
-		if (chipid == 0x4716 || chipid == 0x4748)
+		if (chipid == BCMA_CHIP_ID_BCM4716 ||
+		    chipid == BCMA_CHIP_ID_BCM4748)
 			readl(mmio);
 	}
 
@@ -434,13 +435,14 @@ void __devinit bcma_core_pci_hostmode_init(struct bcma_drv_pci *pc)
 	 * as mips can't generate 64-bit address on the
 	 * backplane.
 	 */
-	if (bus->chipinfo.id == 0x4716 || bus->chipinfo.id == 0x4748) {
+	if (bus->chipinfo.id == BCMA_CHIP_ID_BCM4716 ||
+	    bus->chipinfo.id == BCMA_CHIP_ID_BCM4748) {
 		pc_host->mem_resource.start = BCMA_SOC_PCI_MEM;
 		pc_host->mem_resource.end = BCMA_SOC_PCI_MEM +
 					    BCMA_SOC_PCI_MEM_SZ - 1;
 		pcicore_write32(pc, BCMA_CORE_PCI_SBTOPCI0,
 				BCMA_CORE_PCI_SBTOPCI_MEM | BCMA_SOC_PCI_MEM);
-	} else if (bus->chipinfo.id == 0x5300) {
+	} else if (bus->chipinfo.id == BCMA_CHIP_ID_BCM4706) {
 		tmp = BCMA_CORE_PCI_SBTOPCI_MEM;
 		tmp |= BCMA_CORE_PCI_SBTOPCI_PREF;
 		tmp |= BCMA_CORE_PCI_SBTOPCI_BURST;
diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
index f16f42d..e1eb598 100644
--- a/drivers/bcma/sprom.c
+++ b/drivers/bcma/sprom.c
@@ -468,11 +468,11 @@ static bool bcma_sprom_ext_available(struct bcma_bus *bus)
 	/* older chipcommon revisions use chip status register */
 	chip_status = bcma_read32(bus->drv_cc.core, BCMA_CC_CHIPSTAT);
 	switch (bus->chipinfo.id) {
-	case 0x4313:
+	case BCMA_CHIP_ID_BCM4313:
 		present_mask = BCMA_CC_CHIPST_4313_SPROM_PRESENT;
 		break;
 
-	case 0x4331:
+	case BCMA_CHIP_ID_BCM4331:
 		present_mask = BCMA_CC_CHIPST_4331_SPROM_PRESENT;
 		break;
 
@@ -494,16 +494,16 @@ static bool bcma_sprom_onchip_available(struct bcma_bus *bus)
 
 	chip_status = bcma_read32(bus->drv_cc.core, BCMA_CC_CHIPSTAT);
 	switch (bus->chipinfo.id) {
-	case 0x4313:
+	case BCMA_CHIP_ID_BCM4313:
 		present = chip_status & BCMA_CC_CHIPST_4313_OTP_PRESENT;
 		break;
 
-	case 0x4331:
+	case BCMA_CHIP_ID_BCM4331:
 		present = chip_status & BCMA_CC_CHIPST_4331_OTP_PRESENT;
 		break;
 
-	case 43224:
-	case 43225:
+	case BCMA_CHIP_ID_BCM43224:
+	case BCMA_CHIP_ID_BCM43225:
 		/* for these chips OTP is always available */
 		present = true;
 		break;
@@ -579,13 +579,15 @@ int bcma_sprom_get(struct bcma_bus *bus)
 	if (!sprom)
 		return -ENOMEM;
 
-	if (bus->chipinfo.id == 0x4331 || bus->chipinfo.id == 43431)
+	if (bus->chipinfo.id == BCMA_CHIP_ID_BCM4331 ||
+	    bus->chipinfo.id == BCMA_CHIP_ID_BCM43431)
 		bcma_chipco_bcm4331_ext_pa_lines_ctl(&bus->drv_cc, false);
 
 	pr_debug("SPROM offset 0x%x\n", offset);
 	bcma_sprom_read(bus, offset, sprom);
 
-	if (bus->chipinfo.id == 0x4331 || bus->chipinfo.id == 43431)
+	if (bus->chipinfo.id == BCMA_CHIP_ID_BCM4331 ||
+	    bus->chipinfo.id == BCMA_CHIP_ID_BCM43431)
 		bcma_chipco_bcm4331_ext_pa_lines_ctl(&bus->drv_cc, true);
 
 	err = bcma_sprom_valid(sprom);
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 8deaf6d..3f0d564 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -130,6 +130,36 @@ struct bcma_host_ops {
 
 #define BCMA_MAX_NR_CORES		16
 
+/* Chip IDs of PCIe devices */
+#define BCMA_CHIP_ID_BCM4313	0x4313
+#define BCMA_CHIP_ID_BCM43224	43224
+#define  BCMA_PKG_ID_BCM43224_FAB_CSM	0x8
+#define  BCMA_PKG_ID_BCM43224_FAB_SMIC	0xa
+#define BCMA_CHIP_ID_BCM43225	43225
+#define BCMA_CHIP_ID_BCM43227	43227
+#define BCMA_CHIP_ID_BCM43228	43228
+#define BCMA_CHIP_ID_BCM43421	43421
+#define BCMA_CHIP_ID_BCM43428	43428
+#define BCMA_CHIP_ID_BCM43431	43431
+#define BCMA_CHIP_ID_BCM43460	43460
+#define BCMA_CHIP_ID_BCM4331	0x4331
+#define BCMA_CHIP_ID_BCM6362	0x6362
+#define BCMA_CHIP_ID_BCM4360	0x4360
+#define BCMA_CHIP_ID_BCM4352	0x4352
+
+/* Chip IDs of SoCs */
+#define BCMA_CHIP_ID_BCM4706	0x5300
+#define BCMA_CHIP_ID_BCM4716	0x4716
+#define  BCMA_PKG_ID_BCM4716	8
+#define  BCMA_PKG_ID_BCM4717	9
+#define  BCMA_PKG_ID_BCM4718	10
+#define BCMA_CHIP_ID_BCM47162	47162
+#define BCMA_CHIP_ID_BCM4748	0x4748
+#define BCMA_CHIP_ID_BCM4749	0x4749
+#define BCMA_CHIP_ID_BCM5356	0x5356
+#define BCMA_CHIP_ID_BCM5357	0x5357
+#define BCMA_CHIP_ID_BCM53572	53572
+
 struct bcma_device {
 	struct bcma_bus *bus;
 	struct bcma_device_id id;
-- 
1.7.9.5

