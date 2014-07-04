Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:63807 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030955AbaGDXKu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jul 2014 19:10:50 -0400
Received: by mail-we0-f180.google.com with SMTP id x48so2154624wes.11
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jul 2014 16:10:49 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: add driver for PCIe Gen 2 core
Date: Sat,  5 Jul 2014 01:10:41 +0200
Message-Id: <1404515441-10902-1-git-send-email-zajec5@gmail.com> (sfid-20140705_011057_854473_81FA769D)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New Broadcom PCIe devices (802.11ac ones?) use Gen2 and have to be
initialized differently.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/Makefile                  |   1 +
 drivers/bcma/driver_pcie2.c            | 175 +++++++++++++++++++++++++++++++++
 drivers/bcma/main.c                    |   8 ++
 include/linux/bcma/bcma.h              |   2 +
 include/linux/bcma/bcma_driver_pcie2.h | 158 +++++++++++++++++++++++++++++
 5 files changed, 344 insertions(+)
 create mode 100644 drivers/bcma/driver_pcie2.c
 create mode 100644 include/linux/bcma/bcma_driver_pcie2.h

diff --git a/drivers/bcma/Makefile b/drivers/bcma/Makefile
index 734b32f..91290f7 100644
--- a/drivers/bcma/Makefile
+++ b/drivers/bcma/Makefile
@@ -3,6 +3,7 @@ bcma-y					+= driver_chipcommon.o driver_chipcommon_pmu.o
 bcma-$(CONFIG_BCMA_SFLASH)		+= driver_chipcommon_sflash.o
 bcma-$(CONFIG_BCMA_NFLASH)		+= driver_chipcommon_nflash.o
 bcma-y					+= driver_pci.o
+bcma-y					+= driver_pcie2.o
 bcma-$(CONFIG_BCMA_DRIVER_PCI_HOSTMODE)	+= driver_pci_host.o
 bcma-$(CONFIG_BCMA_DRIVER_MIPS)		+= driver_mips.o
 bcma-$(CONFIG_BCMA_DRIVER_GMAC_CMN)	+= driver_gmac_cmn.o
diff --git a/drivers/bcma/driver_pcie2.c b/drivers/bcma/driver_pcie2.c
new file mode 100644
index 0000000..e4be537
--- /dev/null
+++ b/drivers/bcma/driver_pcie2.c
@@ -0,0 +1,175 @@
+/*
+ * Broadcom specific AMBA
+ * PCIe Gen 2 Core
+ *
+ * Copyright 2014, Broadcom Corporation
+ * Copyright 2014, Rafał Miłecki <zajec5@gmail.com>
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ */
+
+#include "bcma_private.h"
+#include <linux/bcma/bcma.h>
+
+/**************************************************
+ * R/W ops.
+ **************************************************/
+
+#if 0
+static u32 bcma_core_pcie2_cfg_read(struct bcma_drv_pcie2 *pcie2, u32 addr)
+{
+	pcie2_write32(pcie2, BCMA_CORE_PCIE2_CONFIGINDADDR, addr);
+	pcie2_read32(pcie2, BCMA_CORE_PCIE2_CONFIGINDADDR);
+	return pcie2_read32(pcie2, BCMA_CORE_PCIE2_CONFIGINDDATA);
+}
+#endif
+
+static void bcma_core_pcie2_cfg_write(struct bcma_drv_pcie2 *pcie2, u32 addr,
+				      u32 val)
+{
+	pcie2_write32(pcie2, BCMA_CORE_PCIE2_CONFIGINDADDR, addr);
+	pcie2_write32(pcie2, BCMA_CORE_PCIE2_CONFIGINDDATA, val);
+}
+
+/**************************************************
+ * Init.
+ **************************************************/
+
+static u32 bcma_core_pcie2_war_delay_perst_enab(struct bcma_drv_pcie2 *pcie2,
+						bool enable)
+{
+	u32 val;
+
+	/* restore back to default */
+	val = pcie2_read32(pcie2, BCMA_CORE_PCIE2_CLK_CONTROL);
+	val |= PCIE2_CLKC_DLYPERST;
+	val &= ~PCIE2_CLKC_DISSPROMLD;
+	if (enable) {
+		val &= ~PCIE2_CLKC_DLYPERST;
+		val |= PCIE2_CLKC_DISSPROMLD;
+	}
+	pcie2_write32(pcie2, (BCMA_CORE_PCIE2_CLK_CONTROL), val);
+	/* flush */
+	return pcie2_read32(pcie2, BCMA_CORE_PCIE2_CLK_CONTROL);
+}
+
+static void bcma_core_pcie2_set_ltr_vals(struct bcma_drv_pcie2 *pcie2)
+{
+	/* LTR0 */
+	pcie2_write32(pcie2, BCMA_CORE_PCIE2_CONFIGINDADDR, 0x844);
+	pcie2_write32(pcie2, BCMA_CORE_PCIE2_CONFIGINDDATA, 0x883c883c);
+	/* LTR1 */
+	pcie2_write32(pcie2, BCMA_CORE_PCIE2_CONFIGINDADDR, 0x848);
+	pcie2_write32(pcie2, BCMA_CORE_PCIE2_CONFIGINDDATA, 0x88648864);
+	/* LTR2 */
+	pcie2_write32(pcie2, BCMA_CORE_PCIE2_CONFIGINDADDR, 0x84C);
+	pcie2_write32(pcie2, BCMA_CORE_PCIE2_CONFIGINDDATA, 0x90039003);
+}
+
+static void bcma_core_pcie2_hw_ltr_war(struct bcma_drv_pcie2 *pcie2)
+{
+	u8 core_rev = pcie2->core->id.rev;
+	u32 devstsctr2;
+
+	if (core_rev < 2 || core_rev == 10 || core_rev > 13)
+		return;
+
+	pcie2_write32(pcie2, BCMA_CORE_PCIE2_CONFIGINDADDR,
+		      PCIE2_CAP_DEVSTSCTRL2_OFFSET);
+	devstsctr2 = pcie2_read32(pcie2, BCMA_CORE_PCIE2_CONFIGINDDATA);
+	if (devstsctr2 & PCIE2_CAP_DEVSTSCTRL2_LTRENAB) {
+		/* force the right LTR values */
+		bcma_core_pcie2_set_ltr_vals(pcie2);
+
+		/* TODO:
+		si_core_wrapperreg(pcie2, 3, 0x60, 0x8080, 0); */
+
+		/* enable the LTR */
+		devstsctr2 |= PCIE2_CAP_DEVSTSCTRL2_LTRENAB;
+		pcie2_write32(pcie2, BCMA_CORE_PCIE2_CONFIGINDADDR,
+			      PCIE2_CAP_DEVSTSCTRL2_OFFSET);
+		pcie2_write32(pcie2, BCMA_CORE_PCIE2_CONFIGINDDATA, devstsctr2);
+
+		/* set the LTR state to be active */
+		pcie2_write32(pcie2, BCMA_CORE_PCIE2_LTR_STATE,
+			      PCIE2_LTR_ACTIVE);
+		usleep_range(1000, 2000);
+
+		/* set the LTR state to be sleep */
+		pcie2_write32(pcie2, BCMA_CORE_PCIE2_LTR_STATE,
+			      PCIE2_LTR_SLEEP);
+		usleep_range(1000, 2000);
+	}
+}
+
+static void pciedev_crwlpciegen2(struct bcma_drv_pcie2 *pcie2)
+{
+	u8 core_rev = pcie2->core->id.rev;
+	bool pciewar160, pciewar162;
+
+	pciewar160 = core_rev == 7 || core_rev == 9 || core_rev == 11;
+	pciewar162 = core_rev == 5 || core_rev == 7 || core_rev == 8 ||
+		     core_rev == 9 || core_rev == 11;
+
+	if (!pciewar160 && !pciewar162)
+		return;
+
+/* TODO */
+#if 0
+	pcie2_set32(pcie2, BCMA_CORE_PCIE2_CLK_CONTROL,
+		    PCIE_DISABLE_L1CLK_GATING);
+#if 0
+	pcie2_write32(pcie2, BCMA_CORE_PCIE2_CONFIGINDADDR,
+		      PCIEGEN2_COE_PVT_TL_CTRL_0);
+	pcie2_mask32(pcie2, BCMA_CORE_PCIE2_CONFIGINDDATA,
+		     ~(1 << COE_PVT_TL_CTRL_0_PM_DIS_L1_REENTRY_BIT));
+#endif
+#endif
+}
+
+static void pciedev_crwlpciegen2_180(struct bcma_drv_pcie2 *pcie2)
+{
+	pcie2_write32(pcie2, BCMA_CORE_PCIE2_CONFIGINDADDR, PCIE2_PMCR_REFUP);
+	pcie2_set32(pcie2, BCMA_CORE_PCIE2_CONFIGINDDATA, 0x1f);
+}
+
+static void pciedev_crwlpciegen2_182(struct bcma_drv_pcie2 *pcie2)
+{
+	pcie2_write32(pcie2, BCMA_CORE_PCIE2_CONFIGINDADDR, PCIE2_SBMBX);
+	pcie2_write32(pcie2, BCMA_CORE_PCIE2_CONFIGINDDATA, 1 << 0);
+}
+
+static void pciedev_reg_pm_clk_period(struct bcma_drv_pcie2 *pcie2)
+{
+	struct bcma_drv_cc *drv_cc = &pcie2->core->bus->drv_cc;
+	u8 core_rev = pcie2->core->id.rev;
+	u32 alp_khz, pm_value;
+
+	if (core_rev <= 13) {
+		alp_khz = bcma_pmu_get_alp_clock(drv_cc) / 1000;
+		pm_value = (1000000 * 2) / alp_khz;
+		pcie2_write32(pcie2, BCMA_CORE_PCIE2_CONFIGINDADDR,
+			      PCIE2_PVT_REG_PM_CLK_PERIOD);
+		pcie2_write32(pcie2, BCMA_CORE_PCIE2_CONFIGINDDATA, pm_value);
+	}
+}
+
+void bcma_core_pcie2_init(struct bcma_drv_pcie2 *pcie2)
+{
+	struct bcma_chipinfo *ci = &pcie2->core->bus->chipinfo;
+	u32 tmp;
+
+	tmp = pcie2_read32(pcie2, BCMA_CORE_PCIE2_SPROM(54));
+	if ((tmp & 0xe) >> 1 == 2)
+		bcma_core_pcie2_cfg_write(pcie2, 0x4e0, 0x17);
+
+	/* TODO: Do we need pcie_reqsize? */
+
+	if (ci->id == BCMA_CHIP_ID_BCM4360 && ci->rev > 3)
+		bcma_core_pcie2_war_delay_perst_enab(pcie2, true);
+	bcma_core_pcie2_hw_ltr_war(pcie2);
+	pciedev_crwlpciegen2(pcie2);
+	pciedev_reg_pm_clk_period(pcie2);
+	pciedev_crwlpciegen2_180(pcie2);
+	pciedev_crwlpciegen2_182(pcie2);
+}
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 34ea4c5..0ff8d58 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -132,6 +132,7 @@ static int bcma_register_cores(struct bcma_bus *bus)
 		case BCMA_CORE_CHIPCOMMON:
 		case BCMA_CORE_PCI:
 		case BCMA_CORE_PCIE:
+		case BCMA_CORE_PCIE2:
 		case BCMA_CORE_MIPS_74K:
 		case BCMA_CORE_4706_MAC_GBIT_COMMON:
 			continue;
@@ -281,6 +282,13 @@ int bcma_bus_register(struct bcma_bus *bus)
 		bcma_core_pci_init(&bus->drv_pci[1]);
 	}
 
+	/* Init PCIe Gen 2 core */
+	core = bcma_find_core_unit(bus, BCMA_CORE_PCIE2, 0);
+	if (core) {
+		bus->drv_pcie2.core = core;
+		bcma_core_pcie2_init(&bus->drv_pcie2);
+	}
+
 	/* Init GBIT MAC COMMON core */
 	core = bcma_find_core(bus, BCMA_CORE_4706_MAC_GBIT_COMMON);
 	if (core) {
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 0b3bb16..452286a 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -6,6 +6,7 @@
 
 #include <linux/bcma/bcma_driver_chipcommon.h>
 #include <linux/bcma/bcma_driver_pci.h>
+#include <linux/bcma/bcma_driver_pcie2.h>
 #include <linux/bcma/bcma_driver_mips.h>
 #include <linux/bcma/bcma_driver_gmac_cmn.h>
 #include <linux/ssb/ssb.h> /* SPROM sharing */
@@ -333,6 +334,7 @@ struct bcma_bus {
 
 	struct bcma_drv_cc drv_cc;
 	struct bcma_drv_pci drv_pci[2];
+	struct bcma_drv_pcie2 drv_pcie2;
 	struct bcma_drv_mips drv_mips;
 	struct bcma_drv_gmac_cmn drv_gmac_cmn;
 
diff --git a/include/linux/bcma/bcma_driver_pcie2.h b/include/linux/bcma/bcma_driver_pcie2.h
new file mode 100644
index 0000000..5988b05
--- /dev/null
+++ b/include/linux/bcma/bcma_driver_pcie2.h
@@ -0,0 +1,158 @@
+#ifndef LINUX_BCMA_DRIVER_PCIE2_H_
+#define LINUX_BCMA_DRIVER_PCIE2_H_
+
+#define BCMA_CORE_PCIE2_CLK_CONTROL		0x0000
+#define  PCIE2_CLKC_RST_OE			0x0001 /* When set, drives PCI_RESET out to pin */
+#define  PCIE2_CLKC_RST				0x0002 /* Value driven out to pin */
+#define  PCIE2_CLKC_SPERST			0x0004 /* SurvivePeRst */
+#define  PCIE2_CLKC_DISABLE_L1CLK_GATING	0x0010
+#define  PCIE2_CLKC_DLYPERST			0x0100 /* Delay PeRst to CoE Core */
+#define  PCIE2_CLKC_DISSPROMLD			0x0200 /* DisableSpromLoadOnPerst */
+#define  PCIE2_CLKC_WAKE_MODE_L2		0x1000 /* Wake on L2 */
+#define BCMA_CORE_PCIE2_RC_PM_CONTROL		0x0004
+#define BCMA_CORE_PCIE2_RC_PM_STATUS		0x0008
+#define BCMA_CORE_PCIE2_EP_PM_CONTROL		0x000C
+#define BCMA_CORE_PCIE2_EP_PM_STATUS		0x0010
+#define BCMA_CORE_PCIE2_EP_LTR_CONTROL		0x0014
+#define BCMA_CORE_PCIE2_EP_LTR_STATUS		0x0018
+#define BCMA_CORE_PCIE2_EP_OBFF_STATUS		0x001C
+#define BCMA_CORE_PCIE2_PCIE_ERR_STATUS		0x0020
+#define BCMA_CORE_PCIE2_RC_AXI_CONFIG		0x0100
+#define BCMA_CORE_PCIE2_EP_AXI_CONFIG		0x0104
+#define BCMA_CORE_PCIE2_RXDEBUG_STATUS0		0x0108
+#define BCMA_CORE_PCIE2_RXDEBUG_CONTROL0	0x010C
+#define BCMA_CORE_PCIE2_CONFIGINDADDR		0x0120
+#define BCMA_CORE_PCIE2_CONFIGINDDATA		0x0124
+#define BCMA_CORE_PCIE2_MDIOCONTROL		0x0128
+#define BCMA_CORE_PCIE2_MDIOWRDATA		0x012C
+#define BCMA_CORE_PCIE2_MDIORDDATA		0x0130
+#define BCMA_CORE_PCIE2_DATAINTF		0x0180
+#define BCMA_CORE_PCIE2_D2H_INTRLAZY_0		0x0188
+#define BCMA_CORE_PCIE2_H2D_INTRLAZY_0		0x018c
+#define BCMA_CORE_PCIE2_H2D_INTSTAT_0		0x0190
+#define BCMA_CORE_PCIE2_H2D_INTMASK_0		0x0194
+#define BCMA_CORE_PCIE2_D2H_INTSTAT_0		0x0198
+#define BCMA_CORE_PCIE2_D2H_INTMASK_0		0x019c
+#define BCMA_CORE_PCIE2_LTR_STATE		0x01A0 /* Latency Tolerance Reporting */
+#define  PCIE2_LTR_ACTIVE			2
+#define  PCIE2_LTR_ACTIVE_IDLE			1
+#define  PCIE2_LTR_SLEEP			0
+#define  PCIE2_LTR_FINAL_MASK			0x300
+#define  PCIE2_LTR_FINAL_SHIFT			8
+#define BCMA_CORE_PCIE2_PWR_INT_STATUS		0x01A4
+#define BCMA_CORE_PCIE2_PWR_INT_MASK		0x01A8
+#define BCMA_CORE_PCIE2_CFG_ADDR		0x01F8
+#define BCMA_CORE_PCIE2_CFG_DATA		0x01FC
+#define BCMA_CORE_PCIE2_SYS_EQ_PAGE		0x0200
+#define BCMA_CORE_PCIE2_SYS_MSI_PAGE		0x0204
+#define BCMA_CORE_PCIE2_SYS_MSI_INTREN		0x0208
+#define BCMA_CORE_PCIE2_SYS_MSI_CTRL0		0x0210
+#define BCMA_CORE_PCIE2_SYS_MSI_CTRL1		0x0214
+#define BCMA_CORE_PCIE2_SYS_MSI_CTRL2		0x0218
+#define BCMA_CORE_PCIE2_SYS_MSI_CTRL3		0x021C
+#define BCMA_CORE_PCIE2_SYS_MSI_CTRL4		0x0220
+#define BCMA_CORE_PCIE2_SYS_MSI_CTRL5		0x0224
+#define BCMA_CORE_PCIE2_SYS_EQ_HEAD0		0x0250
+#define BCMA_CORE_PCIE2_SYS_EQ_TAIL0		0x0254
+#define BCMA_CORE_PCIE2_SYS_EQ_HEAD1		0x0258
+#define BCMA_CORE_PCIE2_SYS_EQ_TAIL1		0x025C
+#define BCMA_CORE_PCIE2_SYS_EQ_HEAD2		0x0260
+#define BCMA_CORE_PCIE2_SYS_EQ_TAIL2		0x0264
+#define BCMA_CORE_PCIE2_SYS_EQ_HEAD3		0x0268
+#define BCMA_CORE_PCIE2_SYS_EQ_TAIL3		0x026C
+#define BCMA_CORE_PCIE2_SYS_EQ_HEAD4		0x0270
+#define BCMA_CORE_PCIE2_SYS_EQ_TAIL4		0x0274
+#define BCMA_CORE_PCIE2_SYS_EQ_HEAD5		0x0278
+#define BCMA_CORE_PCIE2_SYS_EQ_TAIL5		0x027C
+#define BCMA_CORE_PCIE2_SYS_RC_INTX_EN		0x0330
+#define BCMA_CORE_PCIE2_SYS_RC_INTX_CSR		0x0334
+#define BCMA_CORE_PCIE2_SYS_MSI_REQ		0x0340
+#define BCMA_CORE_PCIE2_SYS_HOST_INTR_EN	0x0344
+#define BCMA_CORE_PCIE2_SYS_HOST_INTR_CSR	0x0348
+#define BCMA_CORE_PCIE2_SYS_HOST_INTR0		0x0350
+#define BCMA_CORE_PCIE2_SYS_HOST_INTR1		0x0354
+#define BCMA_CORE_PCIE2_SYS_HOST_INTR2		0x0358
+#define BCMA_CORE_PCIE2_SYS_HOST_INTR3		0x035C
+#define BCMA_CORE_PCIE2_SYS_EP_INT_EN0		0x0360
+#define BCMA_CORE_PCIE2_SYS_EP_INT_EN1		0x0364
+#define BCMA_CORE_PCIE2_SYS_EP_INT_CSR0		0x0370
+#define BCMA_CORE_PCIE2_SYS_EP_INT_CSR1		0x0374
+#define BCMA_CORE_PCIE2_SPROM(wordoffset)	(0x0800 + ((wordoffset) * 2))
+#define BCMA_CORE_PCIE2_FUNC0_IMAP0_0		0x0C00
+#define BCMA_CORE_PCIE2_FUNC0_IMAP0_1		0x0C04
+#define BCMA_CORE_PCIE2_FUNC0_IMAP0_2		0x0C08
+#define BCMA_CORE_PCIE2_FUNC0_IMAP0_3		0x0C0C
+#define BCMA_CORE_PCIE2_FUNC0_IMAP0_4		0x0C10
+#define BCMA_CORE_PCIE2_FUNC0_IMAP0_5		0x0C14
+#define BCMA_CORE_PCIE2_FUNC0_IMAP0_6		0x0C18
+#define BCMA_CORE_PCIE2_FUNC0_IMAP0_7		0x0C1C
+#define BCMA_CORE_PCIE2_FUNC1_IMAP0_0		0x0C20
+#define BCMA_CORE_PCIE2_FUNC1_IMAP0_1		0x0C24
+#define BCMA_CORE_PCIE2_FUNC1_IMAP0_2		0x0C28
+#define BCMA_CORE_PCIE2_FUNC1_IMAP0_3		0x0C2C
+#define BCMA_CORE_PCIE2_FUNC1_IMAP0_4		0x0C30
+#define BCMA_CORE_PCIE2_FUNC1_IMAP0_5		0x0C34
+#define BCMA_CORE_PCIE2_FUNC1_IMAP0_6		0x0C38
+#define BCMA_CORE_PCIE2_FUNC1_IMAP0_7		0x0C3C
+#define BCMA_CORE_PCIE2_FUNC0_IMAP1		0x0C80
+#define BCMA_CORE_PCIE2_FUNC1_IMAP1		0x0C88
+#define BCMA_CORE_PCIE2_FUNC0_IMAP2		0x0CC0
+#define BCMA_CORE_PCIE2_FUNC1_IMAP2		0x0CC8
+#define BCMA_CORE_PCIE2_IARR0_LOWER		0x0D00
+#define BCMA_CORE_PCIE2_IARR0_UPPER		0x0D04
+#define BCMA_CORE_PCIE2_IARR1_LOWER		0x0D08
+#define BCMA_CORE_PCIE2_IARR1_UPPER		0x0D0C
+#define BCMA_CORE_PCIE2_IARR2_LOWER		0x0D10
+#define BCMA_CORE_PCIE2_IARR2_UPPER		0x0D14
+#define BCMA_CORE_PCIE2_OARR0			0x0D20
+#define BCMA_CORE_PCIE2_OARR1			0x0D28
+#define BCMA_CORE_PCIE2_OARR2			0x0D30
+#define BCMA_CORE_PCIE2_OMAP0_LOWER		0x0D40
+#define BCMA_CORE_PCIE2_OMAP0_UPPER		0x0D44
+#define BCMA_CORE_PCIE2_OMAP1_LOWER		0x0D48
+#define BCMA_CORE_PCIE2_OMAP1_UPPER		0x0D4C
+#define BCMA_CORE_PCIE2_OMAP2_LOWER		0x0D50
+#define BCMA_CORE_PCIE2_OMAP2_UPPER		0x0D54
+#define BCMA_CORE_PCIE2_FUNC1_IARR1_SIZE	0x0D58
+#define BCMA_CORE_PCIE2_FUNC1_IARR2_SIZE	0x0D5C
+#define BCMA_CORE_PCIE2_MEM_CONTROL		0x0F00
+#define BCMA_CORE_PCIE2_MEM_ECC_ERRLOG0		0x0F04
+#define BCMA_CORE_PCIE2_MEM_ECC_ERRLOG1		0x0F08
+#define BCMA_CORE_PCIE2_LINK_STATUS		0x0F0C
+#define BCMA_CORE_PCIE2_STRAP_STATUS		0x0F10
+#define BCMA_CORE_PCIE2_RESET_STATUS		0x0F14
+#define BCMA_CORE_PCIE2_RESETEN_IN_LINKDOWN	0x0F18
+#define BCMA_CORE_PCIE2_MISC_INTR_EN		0x0F1C
+#define BCMA_CORE_PCIE2_TX_DEBUG_CFG		0x0F20
+#define BCMA_CORE_PCIE2_MISC_CONFIG		0x0F24
+#define BCMA_CORE_PCIE2_MISC_STATUS		0x0F28
+#define BCMA_CORE_PCIE2_INTR_EN			0x0F30
+#define BCMA_CORE_PCIE2_INTR_CLEAR		0x0F34
+#define BCMA_CORE_PCIE2_INTR_STATUS		0x0F38
+
+/* PCIE gen2 config regs */
+#define PCIE2_INTSTATUS				0x090
+#define PCIE2_INTMASK				0x094
+#define PCIE2_SBMBX				0x098
+
+#define PCIE2_PMCR_REFUP			0x1814 /* Trefup time */
+
+#define PCIE2_CAP_DEVSTSCTRL2_OFFSET		0xD4
+#define PCIE2_CAP_DEVSTSCTRL2_LTRENAB		0x400
+#define PCIE2_PVT_REG_PM_CLK_PERIOD		0x184c
+
+struct bcma_drv_pcie2 {
+	struct bcma_device *core;
+};
+
+#define pcie2_read16(pcie2, offset)		bcma_read16((pcie2)->core, offset)
+#define pcie2_read32(pcie2, offset)		bcma_read32((pcie2)->core, offset)
+#define pcie2_write16(pcie2, offset, val)	bcma_write16((pcie2)->core, offset, val)
+#define pcie2_write32(pcie2, offset, val)	bcma_write32((pcie2)->core, offset, val)
+
+#define pcie2_set32(pcie2, offset, set)		bcma_set32((pcie2)->core, offset, set)
+#define pcie2_mask32(pcie2, offset, mask)	bcma_mask32((pcie2)->core, offset, mask)
+
+void bcma_core_pcie2_init(struct bcma_drv_pcie2 *pcie2);
+
+#endif /* LINUX_BCMA_DRIVER_PCIE2_H_ */
-- 
1.8.4.5

