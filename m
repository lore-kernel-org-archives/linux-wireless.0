Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:48509 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab3FZICT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 04:02:19 -0400
Received: by mail-ee0-f48.google.com with SMTP id b47so7212139eek.35
        for <linux-wireless@vger.kernel.org>; Wed, 26 Jun 2013 01:02:18 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: add support for BCM43142
Date: Wed, 26 Jun 2013 10:02:11 +0200
Message-Id: <1372233731-3342-1-git-send-email-zajec5@gmail.com> (sfid-20130626_100226_093504_4A90BBE9)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/bcma_private.h                 |    2 +
 drivers/bcma/driver_chipcommon.c            |   11 ++-
 drivers/bcma/driver_chipcommon_pmu.c        |  123 +++++++++++++++++++++++++++
 drivers/bcma/host_pci.c                     |    1 +
 drivers/bcma/main.c                         |   19 +++++
 drivers/bcma/sprom.c                        |    1 +
 include/linux/bcma/bcma.h                   |    1 +
 include/linux/bcma/bcma_driver_chipcommon.h |   55 ++++++++++++
 8 files changed, 211 insertions(+), 2 deletions(-)

diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index 79595a0..0215f9a 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -22,6 +22,8 @@
 struct bcma_bus;
 
 /* main.c */
+bool bcma_wait_value(struct bcma_device *core, u16 reg, u32 mask, u32 value,
+		     int timeout);
 int bcma_bus_register(struct bcma_bus *bus);
 void bcma_bus_unregister(struct bcma_bus *bus);
 int __init bcma_bus_early_register(struct bcma_bus *bus,
diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcommon.c
index 036c674..b068f98 100644
--- a/drivers/bcma/driver_chipcommon.c
+++ b/drivers/bcma/driver_chipcommon.c
@@ -140,8 +140,15 @@ void bcma_core_chipcommon_init(struct bcma_drv_cc *cc)
 	bcma_core_chipcommon_early_init(cc);
 
 	if (cc->core->id.rev >= 20) {
-		bcma_cc_write32(cc, BCMA_CC_GPIOPULLUP, 0);
-		bcma_cc_write32(cc, BCMA_CC_GPIOPULLDOWN, 0);
+		u32 pullup = 0, pulldown = 0;
+
+		if (cc->core->bus->chipinfo.id == BCMA_CHIP_ID_BCM43142) {
+			pullup = 0x402e0;
+			pulldown = 0x20500;
+		}
+
+		bcma_cc_write32(cc, BCMA_CC_GPIOPULLUP, pullup);
+		bcma_cc_write32(cc, BCMA_CC_GPIOPULLDOWN, pulldown);
 	}
 
 	if (cc->capabilities & BCMA_CC_CAP_PMU)
diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index edca73a..5081a8c 100644
--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -56,6 +56,109 @@ void bcma_chipco_regctl_maskset(struct bcma_drv_cc *cc, u32 offset, u32 mask,
 }
 EXPORT_SYMBOL_GPL(bcma_chipco_regctl_maskset);
 
+static u32 bcma_pmu_xtalfreq(struct bcma_drv_cc *cc)
+{
+	u32 ilp_ctl, alp_hz;
+
+	if (!(bcma_cc_read32(cc, BCMA_CC_PMU_STAT) &
+	      BCMA_CC_PMU_STAT_EXT_LPO_AVAIL))
+		return 0;
+
+	bcma_cc_write32(cc, BCMA_CC_PMU_XTAL_FREQ,
+			BIT(BCMA_CC_PMU_XTAL_FREQ_MEASURE_SHIFT));
+	usleep_range(1000, 2000);
+
+	ilp_ctl = bcma_cc_read32(cc, BCMA_CC_PMU_XTAL_FREQ);
+	ilp_ctl &= BCMA_CC_PMU_XTAL_FREQ_ILPCTL_MASK;
+
+	bcma_cc_write32(cc, BCMA_CC_PMU_XTAL_FREQ, 0);
+
+	alp_hz = ilp_ctl * 32768 / 4;
+	return (alp_hz + 50000) / 100000 * 100;
+}
+
+static void bcma_pmu2_pll_init0(struct bcma_drv_cc *cc, u32 xtalfreq)
+{
+	struct bcma_bus *bus = cc->core->bus;
+	u32 freq_tgt_target = 0, freq_tgt_current;
+	u32 pll0, mask;
+
+	switch (bus->chipinfo.id) {
+	case BCMA_CHIP_ID_BCM43142:
+		/* pmu2_xtaltab0_adfll_485 */
+		switch (xtalfreq) {
+		case 12000:
+			freq_tgt_target = 0x50D52;
+			break;
+		case 20000:
+			freq_tgt_target = 0x307FE;
+			break;
+		case 26000:
+			freq_tgt_target = 0x254EA;
+			break;
+		case 37400:
+			freq_tgt_target = 0x19EF8;
+			break;
+		case 52000:
+			freq_tgt_target = 0x12A75;
+			break;
+		}
+		break;
+	}
+
+	if (!freq_tgt_target) {
+		bcma_err(bus, "Unknown TGT frequency for xtalfreq %d\n",
+			 xtalfreq);
+		return;
+	}
+
+	pll0 = bcma_chipco_pll_read(cc, BCMA_CC_PMU15_PLL_PLLCTL0);
+	freq_tgt_current = (pll0 & BCMA_CC_PMU15_PLL_PC0_FREQTGT_MASK) >>
+		BCMA_CC_PMU15_PLL_PC0_FREQTGT_SHIFT;
+
+	if (freq_tgt_current == freq_tgt_target) {
+		bcma_debug(bus, "Target TGT frequency already set\n");
+		return;
+	}
+
+	/* Turn off PLL */
+	switch (bus->chipinfo.id) {
+	case BCMA_CHIP_ID_BCM43142:
+		mask = (u32)~(BCMA_RES_4314_HT_AVAIL |
+			      BCMA_RES_4314_MACPHY_CLK_AVAIL);
+
+		bcma_cc_mask32(cc, BCMA_CC_PMU_MINRES_MSK, mask);
+		bcma_cc_mask32(cc, BCMA_CC_PMU_MAXRES_MSK, mask);
+		bcma_wait_value(cc->core, BCMA_CLKCTLST,
+				BCMA_CLKCTLST_HAVEHT, 0, 20000);
+		break;
+	}
+
+	pll0 &= ~BCMA_CC_PMU15_PLL_PC0_FREQTGT_MASK;
+	pll0 |= freq_tgt_target << BCMA_CC_PMU15_PLL_PC0_FREQTGT_SHIFT;
+	bcma_chipco_pll_write(cc, BCMA_CC_PMU15_PLL_PLLCTL0, pll0);
+
+	/* Flush */
+	if (cc->pmu.rev >= 2)
+		bcma_cc_set32(cc, BCMA_CC_PMU_CTL, BCMA_CC_PMU_CTL_PLL_UPD);
+
+	/* TODO: Do we need to update OTP? */
+}
+
+static void bcma_pmu_pll_init(struct bcma_drv_cc *cc)
+{
+	struct bcma_bus *bus = cc->core->bus;
+	u32 xtalfreq = bcma_pmu_xtalfreq(cc);
+
+	switch (bus->chipinfo.id) {
+	case BCMA_CHIP_ID_BCM43142:
+		if (xtalfreq == 0)
+			xtalfreq = 20000;
+		bcma_pmu2_pll_init0(cc, xtalfreq);
+		break;
+	}
+}
+
 static void bcma_pmu_resources_init(struct bcma_drv_cc *cc)
 {
 	struct bcma_bus *bus = cc->core->bus;
@@ -66,6 +169,25 @@ static void bcma_pmu_resources_init(struct bcma_drv_cc *cc)
 		min_msk = 0x200D;
 		max_msk = 0xFFFF;
 		break;
+	case BCMA_CHIP_ID_BCM43142:
+		min_msk = BCMA_RES_4314_LPLDO_PU |
+			  BCMA_RES_4314_PMU_SLEEP_DIS |
+			  BCMA_RES_4314_PMU_BG_PU |
+			  BCMA_RES_4314_CBUCK_LPOM_PU |
+			  BCMA_RES_4314_CBUCK_PFM_PU |
+			  BCMA_RES_4314_CLDO_PU |
+			  BCMA_RES_4314_LPLDO2_LVM |
+			  BCMA_RES_4314_WL_PMU_PU |
+			  BCMA_RES_4314_LDO3P3_PU |
+			  BCMA_RES_4314_OTP_PU |
+			  BCMA_RES_4314_WL_PWRSW_PU |
+			  BCMA_RES_4314_LQ_AVAIL |
+			  BCMA_RES_4314_LOGIC_RET |
+			  BCMA_RES_4314_MEM_SLEEP |
+			  BCMA_RES_4314_MACPHY_RET |
+			  BCMA_RES_4314_WL_CORE_READY;
+		max_msk = 0x3FFFFFFF;
+		break;
 	default:
 		bcma_debug(bus, "PMU resource config unknown or not needed for device 0x%04X\n",
 			   bus->chipinfo.id);
@@ -165,6 +287,7 @@ void bcma_pmu_init(struct bcma_drv_cc *cc)
 		bcma_cc_set32(cc, BCMA_CC_PMU_CTL,
 			     BCMA_CC_PMU_CTL_NOILPONW);
 
+	bcma_pmu_pll_init(cc);
 	bcma_pmu_resources_init(cc);
 	bcma_pmu_workarounds(cc);
 }
diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index fbf2759..a355e63 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -275,6 +275,7 @@ static DEFINE_PCI_DEVICE_TABLE(bcma_pci_bridge_tbl) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4357) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4358) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4359) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4365) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4727) },
 	{ 0, },
 };
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index f72f52b..0067422 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -93,6 +93,25 @@ struct bcma_device *bcma_find_core_unit(struct bcma_bus *bus, u16 coreid,
 	return NULL;
 }
 
+bool bcma_wait_value(struct bcma_device *core, u16 reg, u32 mask, u32 value,
+		     int timeout)
+{
+	unsigned long deadline = jiffies + timeout;
+	u32 val;
+
+	do {
+		val = bcma_read32(core, reg);
+		if ((val & mask) == value)
+			return true;
+		cpu_relax();
+		udelay(10);
+	} while (!time_after_eq(jiffies, deadline));
+
+	bcma_warn(core->bus, "Timeout waiting for register 0x%04X!\n", reg);
+
+	return false;
+}
+
 static void bcma_release_core_dev(struct device *dev)
 {
 	struct bcma_device *core = container_of(dev, struct bcma_device, dev);
diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
index de15b4f..72bf454 100644
--- a/drivers/bcma/sprom.c
+++ b/drivers/bcma/sprom.c
@@ -503,6 +503,7 @@ static bool bcma_sprom_onchip_available(struct bcma_bus *bus)
 	case BCMA_CHIP_ID_BCM4331:
 		present = chip_status & BCMA_CC_CHIPST_4331_OTP_PRESENT;
 		break;
+	case BCMA_CHIP_ID_BCM43142:
 	case BCMA_CHIP_ID_BCM43224:
 	case BCMA_CHIP_ID_BCM43225:
 		/* for these chips OTP is always available */
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 2e34db8..622fc50 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -144,6 +144,7 @@ struct bcma_host_ops {
 
 /* Chip IDs of PCIe devices */
 #define BCMA_CHIP_ID_BCM4313	0x4313
+#define BCMA_CHIP_ID_BCM43142	43142
 #define BCMA_CHIP_ID_BCM43224	43224
 #define  BCMA_PKG_ID_BCM43224_FAB_CSM	0x8
 #define  BCMA_PKG_ID_BCM43224_FAB_SMIC	0xa
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index b8b09ea..c49e1a1 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -330,6 +330,8 @@
 #define BCMA_CC_PMU_CAP			0x0604 /* PMU capabilities */
 #define  BCMA_CC_PMU_CAP_REVISION	0x000000FF /* Revision mask */
 #define BCMA_CC_PMU_STAT		0x0608 /* PMU status */
+#define  BCMA_CC_PMU_STAT_EXT_LPO_AVAIL	0x00000100
+#define  BCMA_CC_PMU_STAT_WDRESET	0x00000080
 #define  BCMA_CC_PMU_STAT_INTPEND	0x00000040 /* Interrupt pending */
 #define  BCMA_CC_PMU_STAT_SBCLKST	0x00000030 /* Backplane clock status? */
 #define  BCMA_CC_PMU_STAT_HAVEALP	0x00000008 /* ALP available */
@@ -355,6 +357,11 @@
 #define BCMA_CC_REGCTL_DATA		0x065C
 #define BCMA_CC_PLLCTL_ADDR		0x0660
 #define BCMA_CC_PLLCTL_DATA		0x0664
+#define BCMA_CC_PMU_STRAPOPT		0x0668 /* (corerev >= 28) */
+#define BCMA_CC_PMU_XTAL_FREQ		0x066C /* (pmurev >= 10) */
+#define  BCMA_CC_PMU_XTAL_FREQ_ILPCTL_MASK	0x00001FFF
+#define  BCMA_CC_PMU_XTAL_FREQ_MEASURE_MASK	0x80000000
+#define  BCMA_CC_PMU_XTAL_FREQ_MEASURE_SHIFT	31
 #define BCMA_CC_SPROM			0x0800 /* SPROM beginning */
 /* NAND flash MLC controller registers (corerev >= 38) */
 #define BCMA_CC_NAND_REVISION		0x0C00
@@ -435,6 +442,23 @@
 #define  BCMA_CC_PMU6_4706_PROC_NDIV_MODE_MASK	0x00000007
 #define  BCMA_CC_PMU6_4706_PROC_NDIV_MODE_SHIFT	0
 
+/* PMU rev 15 */
+#define BCMA_CC_PMU15_PLL_PLLCTL0	0
+#define  BCMA_CC_PMU15_PLL_PC0_CLKSEL_MASK	0x00000003
+#define  BCMA_CC_PMU15_PLL_PC0_CLKSEL_SHIFT	0
+#define  BCMA_CC_PMU15_PLL_PC0_FREQTGT_MASK	0x003FFFFC
+#define  BCMA_CC_PMU15_PLL_PC0_FREQTGT_SHIFT	2
+#define  BCMA_CC_PMU15_PLL_PC0_PRESCALE_MASK	0x00C00000
+#define  BCMA_CC_PMU15_PLL_PC0_PRESCALE_SHIFT	22
+#define  BCMA_CC_PMU15_PLL_PC0_KPCTRL_MASK	0x07000000
+#define  BCMA_CC_PMU15_PLL_PC0_KPCTRL_SHIFT	24
+#define  BCMA_CC_PMU15_PLL_PC0_FCNTCTRL_MASK	0x38000000
+#define  BCMA_CC_PMU15_PLL_PC0_FCNTCTRL_SHIFT	27
+#define  BCMA_CC_PMU15_PLL_PC0_FDCMODE_MASK	0x40000000
+#define  BCMA_CC_PMU15_PLL_PC0_FDCMODE_SHIFT	30
+#define  BCMA_CC_PMU15_PLL_PC0_CTRLBIAS_MASK	0x80000000
+#define  BCMA_CC_PMU15_PLL_PC0_CTRLBIAS_SHIFT	31
+
 /* ALP clock on pre-PMU chips */
 #define BCMA_CC_PMU_ALP_CLOCK		20000000
 /* HT clock for systems with PMU-enabled chipcommon */
@@ -507,6 +531,37 @@
 #define BCMA_CHIPCTL_5357_I2S_PINS_ENABLE	BIT(18)
 #define BCMA_CHIPCTL_5357_I2CSPI_PINS_ENABLE	BIT(19)
 
+#define BCMA_RES_4314_LPLDO_PU			BIT(0)
+#define BCMA_RES_4314_PMU_SLEEP_DIS		BIT(1)
+#define BCMA_RES_4314_PMU_BG_PU			BIT(2)
+#define BCMA_RES_4314_CBUCK_LPOM_PU		BIT(3)
+#define BCMA_RES_4314_CBUCK_PFM_PU		BIT(4)
+#define BCMA_RES_4314_CLDO_PU			BIT(5)
+#define BCMA_RES_4314_LPLDO2_LVM		BIT(6)
+#define BCMA_RES_4314_WL_PMU_PU			BIT(7)
+#define BCMA_RES_4314_LNLDO_PU			BIT(8)
+#define BCMA_RES_4314_LDO3P3_PU			BIT(9)
+#define BCMA_RES_4314_OTP_PU			BIT(10)
+#define BCMA_RES_4314_XTAL_PU			BIT(11)
+#define BCMA_RES_4314_WL_PWRSW_PU		BIT(12)
+#define BCMA_RES_4314_LQ_AVAIL			BIT(13)
+#define BCMA_RES_4314_LOGIC_RET			BIT(14)
+#define BCMA_RES_4314_MEM_SLEEP			BIT(15)
+#define BCMA_RES_4314_MACPHY_RET		BIT(16)
+#define BCMA_RES_4314_WL_CORE_READY		BIT(17)
+#define BCMA_RES_4314_ILP_REQ			BIT(18)
+#define BCMA_RES_4314_ALP_AVAIL			BIT(19)
+#define BCMA_RES_4314_MISC_PWRSW_PU		BIT(20)
+#define BCMA_RES_4314_SYNTH_PWRSW_PU		BIT(21)
+#define BCMA_RES_4314_RX_PWRSW_PU		BIT(22)
+#define BCMA_RES_4314_RADIO_PU			BIT(23)
+#define BCMA_RES_4314_VCO_LDO_PU		BIT(24)
+#define BCMA_RES_4314_AFE_LDO_PU		BIT(25)
+#define BCMA_RES_4314_RX_LDO_PU			BIT(26)
+#define BCMA_RES_4314_TX_LDO_PU			BIT(27)
+#define BCMA_RES_4314_HT_AVAIL			BIT(28)
+#define BCMA_RES_4314_MACPHY_CLK_AVAIL		BIT(29)
+
 /* Data for the PMU, if available.
  * Check availability with ((struct bcma_chipcommon)->capabilities & BCMA_CC_CAP_PMU)
  */
-- 
1.7.10.4

