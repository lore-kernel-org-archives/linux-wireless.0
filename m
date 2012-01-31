Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39655 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754311Ab2AaXOS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 18:14:18 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, m@bues.ch, b43-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/4] ssb: add support for bcm5354
Date: Wed,  1 Feb 2012 00:13:56 +0100
Message-Id: <1328051636-15449-5-git-send-email-hauke@hauke-m.de> (sfid-20120201_001422_024752_A17A8859)
In-Reply-To: <1328051636-15449-1-git-send-email-hauke@hauke-m.de>
References: <1328051636-15449-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support the the BCM5354 SoC.
It has a PMU and a constant not configurable clock.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/ssb/driver_chipcommon_pmu.c |   48 +++++++++++++++++++++++++++++++---
 drivers/ssb/driver_mipscore.c       |    3 ++
 drivers/ssb/main.c                  |    3 ++
 drivers/ssb/ssb_private.h           |    4 +++
 4 files changed, 53 insertions(+), 5 deletions(-)

diff --git a/drivers/ssb/driver_chipcommon_pmu.c b/drivers/ssb/driver_chipcommon_pmu.c
index e5a2e0e..b58fef7 100644
--- a/drivers/ssb/driver_chipcommon_pmu.c
+++ b/drivers/ssb/driver_chipcommon_pmu.c
@@ -13,6 +13,9 @@
 #include <linux/ssb/ssb_driver_chipcommon.h>
 #include <linux/delay.h>
 #include <linux/export.h>
+#ifdef CONFIG_BCM47XX
+#include <asm/mach-bcm47xx/nvram.h>
+#endif
 
 #include "ssb_private.h"
 
@@ -92,10 +95,6 @@ static void ssb_pmu0_pllinit_r0(struct ssb_chipcommon *cc,
 	u32 pmuctl, tmp, pllctl;
 	unsigned int i;
 
-	if ((bus->chip_id == 0x5354) && !crystalfreq) {
-		/* The 5354 crystal freq is 25MHz */
-		crystalfreq = 25000;
-	}
 	if (crystalfreq)
 		e = pmu0_plltab_find_entry(crystalfreq);
 	if (!e)
@@ -321,7 +320,11 @@ static void ssb_pmu_pll_init(struct ssb_chipcommon *cc)
 	u32 crystalfreq = 0; /* in kHz. 0 = keep default freq. */
 
 	if (bus->bustype == SSB_BUSTYPE_SSB) {
-		/* TODO: The user may override the crystal frequency. */
+#ifdef CONFIG_BCM47XX
+		char buf[20];
+		if (nvram_getenv("xtalfreq", buf, sizeof(buf)) >= 0)
+			crystalfreq = simple_strtoul(buf, NULL, 0);
+#endif
 	}
 
 	switch (bus->chip_id) {
@@ -330,7 +333,11 @@ static void ssb_pmu_pll_init(struct ssb_chipcommon *cc)
 		ssb_pmu1_pllinit_r0(cc, crystalfreq);
 		break;
 	case 0x4328:
+		ssb_pmu0_pllinit_r0(cc, crystalfreq);
+		break;
 	case 0x5354:
+		if (crystalfreq == 0)
+			crystalfreq = 25000;
 		ssb_pmu0_pllinit_r0(cc, crystalfreq);
 		break;
 	case 0x4322:
@@ -607,3 +614,34 @@ void ssb_pmu_set_ldo_paref(struct ssb_chipcommon *cc, bool on)
 
 EXPORT_SYMBOL(ssb_pmu_set_ldo_voltage);
 EXPORT_SYMBOL(ssb_pmu_set_ldo_paref);
+
+u32 ssb_pmu_get_cpu_clock(struct ssb_chipcommon *cc)
+{
+	struct ssb_bus *bus = cc->dev->bus;
+
+	switch (bus->chip_id) {
+	case 0x5354:
+		/* 5354 chip uses a non programmable PLL of frequency 240MHz */
+		return 240000000;
+	default:
+		ssb_printk(KERN_ERR PFX
+			   "ERROR: PMU cpu clock unknown for device %04X\n",
+			   bus->chip_id);
+		return 0;
+	}
+}
+
+u32 ssb_pmu_get_controlclock(struct ssb_chipcommon *cc)
+{
+	struct ssb_bus *bus = cc->dev->bus;
+
+	switch (bus->chip_id) {
+	case 0x5354:
+		return 120000000;
+	default:
+		ssb_printk(KERN_ERR PFX
+			   "ERROR: PMU controlclock unknown for device %04X\n",
+			   bus->chip_id);
+		return 0;
+	}
+}
diff --git a/drivers/ssb/driver_mipscore.c b/drivers/ssb/driver_mipscore.c
index ced5015..d784ec8 100644
--- a/drivers/ssb/driver_mipscore.c
+++ b/drivers/ssb/driver_mipscore.c
@@ -208,6 +208,9 @@ u32 ssb_cpu_clock(struct ssb_mipscore *mcore)
 	struct ssb_bus *bus = mcore->dev->bus;
 	u32 pll_type, n, m, rate = 0;
 
+	if (bus->chipco.capabilities & SSB_CHIPCO_CAP_PMU)
+	    	return ssb_pmu_get_cpu_clock(&bus->chipco);
+
 	if (bus->extif.dev) {
 		ssb_extif_get_clockcontrol(&bus->extif, &pll_type, &n, &m);
 	} else if (bus->chipco.dev) {
diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index bb6317f..d109cf0 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -1094,6 +1094,9 @@ u32 ssb_clockspeed(struct ssb_bus *bus)
 	u32 plltype;
 	u32 clkctl_n, clkctl_m;
 
+	if (bus->chipco.capabilities & SSB_CHIPCO_CAP_PMU)
+	    	return ssb_pmu_get_controlclock(&bus->chipco);
+
 	if (ssb_extif_available(&bus->extif))
 		ssb_extif_get_clockcontrol(&bus->extif, &plltype,
 					   &clkctl_n, &clkctl_m);
diff --git a/drivers/ssb/ssb_private.h b/drivers/ssb/ssb_private.h
index 7765301..a305550 100644
--- a/drivers/ssb/ssb_private.h
+++ b/drivers/ssb/ssb_private.h
@@ -207,4 +207,8 @@ static inline void b43_pci_ssb_bridge_exit(void)
 }
 #endif /* CONFIG_SSB_B43_PCI_BRIDGE */
 
+/* driver_chipcommon_pmu.c */
+extern u32 ssb_pmu_get_cpu_clock(struct ssb_chipcommon *cc);
+extern u32 ssb_pmu_get_controlclock(struct ssb_chipcommon *cc);
+
 #endif /* LINUX_SSB_PRIVATE_H_ */
-- 
1.7.5.4

