Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:47198 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692Ab2GKHXr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 03:23:47 -0400
Received: by wibhq12 with SMTP id hq12so4303656wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jul 2012 00:23:45 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V2] bcma: add trivial GBIT MAC COMMON driver
Date: Wed, 11 Jul 2012 09:23:43 +0200
Message-Id: <1341991423-1476-1-git-send-email-zajec5@gmail.com> (sfid-20120711_092350_907644_C067D30B)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

GMAC COMMON core is present on BCM4706 and is used for example to access
board PHYs (PHYs can not be accessed directly using GBIT MAC core).

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: Fix printing GMAC Common name. Core's manufacturer is ARM not BCM!
---
 drivers/bcma/Kconfig                      |    9 +++
 drivers/bcma/Makefile                     |    1 +
 drivers/bcma/driver_gmac_cmn.c            |   14 ++++
 drivers/bcma/main.c                       |    8 ++
 drivers/bcma/scan.c                       |   16 +++--
 include/linux/bcma/bcma.h                 |    2 +
 include/linux/bcma/bcma_driver_gmac_cmn.h |  100 +++++++++++++++++++++++++++++
 7 files changed, 144 insertions(+), 6 deletions(-)
 create mode 100644 drivers/bcma/driver_gmac_cmn.c
 create mode 100644 include/linux/bcma/bcma_driver_gmac_cmn.h

diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
index 1c31433..d878e03 100644
--- a/drivers/bcma/Kconfig
+++ b/drivers/bcma/Kconfig
@@ -47,6 +47,15 @@ config BCMA_DRIVER_MIPS
 
 	  If unsure, say N
 
+config BCMA_DRIVER_GMAC_CMN
+	bool "BCMA Broadcom GBIT MAC COMMON core driver"
+	depends on BCMA
+	help
+	  Driver for the Broadcom GBIT MAC COMMON core attached to Broadcom
+	  specific Advanced Microcontroller Bus.
+
+	  If unsure, say N
+
 config BCMA_DEBUG
 	bool "BCMA debugging"
 	depends on BCMA
diff --git a/drivers/bcma/Makefile b/drivers/bcma/Makefile
index 82de24e..d13803f 100644
--- a/drivers/bcma/Makefile
+++ b/drivers/bcma/Makefile
@@ -3,6 +3,7 @@ bcma-y					+= driver_chipcommon.o driver_chipcommon_pmu.o
 bcma-y					+= driver_pci.o
 bcma-$(CONFIG_BCMA_DRIVER_PCI_HOSTMODE)	+= driver_pci_host.o
 bcma-$(CONFIG_BCMA_DRIVER_MIPS)		+= driver_mips.o
+bcma-$(CONFIG_BCMA_DRIVER_GMAC_CMN)	+= driver_gmac_cmn.o
 bcma-$(CONFIG_BCMA_HOST_PCI)		+= host_pci.o
 bcma-$(CONFIG_BCMA_HOST_SOC)		+= host_soc.o
 obj-$(CONFIG_BCMA)			+= bcma.o
diff --git a/drivers/bcma/driver_gmac_cmn.c b/drivers/bcma/driver_gmac_cmn.c
new file mode 100644
index 0000000..834225f
--- /dev/null
+++ b/drivers/bcma/driver_gmac_cmn.c
@@ -0,0 +1,14 @@
+/*
+ * Broadcom specific AMBA
+ * GBIT MAC COMMON Core
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ */
+
+#include "bcma_private.h"
+#include <linux/bcma/bcma.h>
+
+void __devinit bcma_core_gmac_cmn_init(struct bcma_drv_gmac_cmn *gc)
+{
+	mutex_init(&gc->phy_mutex);
+}
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 151bddc..758af9c 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -103,6 +103,7 @@ static int bcma_register_cores(struct bcma_bus *bus)
 		case BCMA_CORE_PCI:
 		case BCMA_CORE_PCIE:
 		case BCMA_CORE_MIPS_74K:
+		case BCMA_CORE_4706_MAC_GBIT_COMMON:
 			continue;
 		}
 
@@ -185,6 +186,13 @@ int __devinit bcma_bus_register(struct bcma_bus *bus)
 		bcma_core_pci_init(&bus->drv_pci);
 	}
 
+	/* Init GBIT MAC COMMON core */
+	core = bcma_find_core(bus, BCMA_CORE_4706_MAC_GBIT_COMMON);
+	if (core) {
+		bus->drv_gmac_cmn.core = core;
+		bcma_core_gmac_cmn_init(&bus->drv_gmac_cmn);
+	}
+
 	/* Try to get SPROM */
 	err = bcma_sprom_get(bus);
 	if (err == -ENOENT) {
diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index a0272bb..3bc3ec2 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -21,6 +21,7 @@ struct bcma_device_id_name {
 };
 
 static const struct bcma_device_id_name bcma_arm_device_names[] = {
+	{ BCMA_CORE_4706_MAC_GBIT_COMMON, "BCM4706 GBit MAC Common" },
 	{ BCMA_CORE_ARM_1176, "ARM 1176" },
 	{ BCMA_CORE_ARM_7TDMI, "ARM 7TDMI" },
 	{ BCMA_CORE_ARM_CM3, "ARM CM3" },
@@ -33,7 +34,6 @@ static const struct bcma_device_id_name bcma_bcm_device_names[] = {
 	{ BCMA_CORE_4706_MAC_GBIT, "BCM4706 GBit MAC" },
 	{ BCMA_CORE_AMEMC, "AMEMC (DDR)" },
 	{ BCMA_CORE_ALTA, "ALTA (I2S)" },
-	{ BCMA_CORE_4706_MAC_GBIT_COMMON, "BCM4706 GBit MAC Common" },
 	{ BCMA_CORE_INVALID, "Invalid" },
 	{ BCMA_CORE_CHIPCOMMON, "ChipCommon" },
 	{ BCMA_CORE_ILINE20, "ILine 20" },
@@ -295,11 +295,15 @@ static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
 
 	/* check if component is a core at all */
 	if (wrappers[0] + wrappers[1] == 0) {
-		/* we could save addrl of the router
-		if (cid == BCMA_CORE_OOB_ROUTER)
-		 */
-		bcma_erom_skip_component(bus, eromptr);
-		return -ENXIO;
+		/* Some specific cores don't need wrappers */
+		switch (core->id.id) {
+		case BCMA_CORE_4706_MAC_GBIT_COMMON:
+		/* Not used yet: case BCMA_CORE_OOB_ROUTER: */
+			break;
+		default:
+			bcma_erom_skip_component(bus, eromptr);
+			return -ENXIO;
+		}
 	}
 
 	if (bcma_erom_is_bridge(bus, eromptr)) {
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 03b2f30..1954a4e 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -7,6 +7,7 @@
 #include <linux/bcma/bcma_driver_chipcommon.h>
 #include <linux/bcma/bcma_driver_pci.h>
 #include <linux/bcma/bcma_driver_mips.h>
+#include <linux/bcma/bcma_driver_gmac_cmn.h>
 #include <linux/ssb/ssb.h> /* SPROM sharing */
 
 #include "bcma_regs.h"
@@ -252,6 +253,7 @@ struct bcma_bus {
 	struct bcma_drv_cc drv_cc;
 	struct bcma_drv_pci drv_pci;
 	struct bcma_drv_mips drv_mips;
+	struct bcma_drv_gmac_cmn drv_gmac_cmn;
 
 	/* We decided to share SPROM struct with SSB as long as we do not need
 	 * any hacks for BCMA. This simplifies drivers code. */
diff --git a/include/linux/bcma/bcma_driver_gmac_cmn.h b/include/linux/bcma/bcma_driver_gmac_cmn.h
new file mode 100644
index 0000000..def894b
--- /dev/null
+++ b/include/linux/bcma/bcma_driver_gmac_cmn.h
@@ -0,0 +1,100 @@
+#ifndef LINUX_BCMA_DRIVER_GMAC_CMN_H_
+#define LINUX_BCMA_DRIVER_GMAC_CMN_H_
+
+#include <linux/types.h>
+
+#define BCMA_GMAC_CMN_STAG0		0x000
+#define BCMA_GMAC_CMN_STAG1		0x004
+#define BCMA_GMAC_CMN_STAG2		0x008
+#define BCMA_GMAC_CMN_STAG3		0x00C
+#define BCMA_GMAC_CMN_PARSER_CTL	0x020
+#define BCMA_GMAC_CMN_MIB_MAX_LEN	0x024
+#define BCMA_GMAC_CMN_PHY_ACCESS	0x100
+#define  BCMA_GMAC_CMN_PA_DATA_MASK	0x0000ffff
+#define  BCMA_GMAC_CMN_PA_ADDR_MASK	0x001f0000
+#define  BCMA_GMAC_CMN_PA_ADDR_SHIFT	16
+#define  BCMA_GMAC_CMN_PA_REG_MASK	0x1f000000
+#define  BCMA_GMAC_CMN_PA_REG_SHIFT	24
+#define  BCMA_GMAC_CMN_PA_WRITE		0x20000000
+#define  BCMA_GMAC_CMN_PA_START		0x40000000
+#define BCMA_GMAC_CMN_PHY_CTL		0x104
+#define  BCMA_GMAC_CMN_PC_EPA_MASK	0x0000001f
+#define  BCMA_GMAC_CMN_PC_MCT_MASK	0x007f0000
+#define  BCMA_GMAC_CMN_PC_MCT_SHIFT	16
+#define  BCMA_GMAC_CMN_PC_MTE		0x00800000
+#define BCMA_GMAC_CMN_GMAC0_RGMII_CTL	0x110
+#define BCMA_GMAC_CMN_CFP_ACCESS	0x200
+#define BCMA_GMAC_CMN_CFP_TCAM_DATA0	0x210
+#define BCMA_GMAC_CMN_CFP_TCAM_DATA1	0x214
+#define BCMA_GMAC_CMN_CFP_TCAM_DATA2	0x218
+#define BCMA_GMAC_CMN_CFP_TCAM_DATA3	0x21C
+#define BCMA_GMAC_CMN_CFP_TCAM_DATA4	0x220
+#define BCMA_GMAC_CMN_CFP_TCAM_DATA5	0x224
+#define BCMA_GMAC_CMN_CFP_TCAM_DATA6	0x228
+#define BCMA_GMAC_CMN_CFP_TCAM_DATA7	0x22C
+#define BCMA_GMAC_CMN_CFP_TCAM_MASK0	0x230
+#define BCMA_GMAC_CMN_CFP_TCAM_MASK1	0x234
+#define BCMA_GMAC_CMN_CFP_TCAM_MASK2	0x238
+#define BCMA_GMAC_CMN_CFP_TCAM_MASK3	0x23C
+#define BCMA_GMAC_CMN_CFP_TCAM_MASK4	0x240
+#define BCMA_GMAC_CMN_CFP_TCAM_MASK5	0x244
+#define BCMA_GMAC_CMN_CFP_TCAM_MASK6	0x248
+#define BCMA_GMAC_CMN_CFP_TCAM_MASK7	0x24C
+#define BCMA_GMAC_CMN_CFP_ACTION_DATA	0x250
+#define BCMA_GMAC_CMN_TCAM_BIST_CTL	0x2A0
+#define BCMA_GMAC_CMN_TCAM_BIST_STATUS	0x2A4
+#define BCMA_GMAC_CMN_TCAM_CMP_STATUS	0x2A8
+#define BCMA_GMAC_CMN_TCAM_DISABLE	0x2AC
+#define BCMA_GMAC_CMN_TCAM_TEST_CTL	0x2F0
+#define BCMA_GMAC_CMN_UDF_0_A3_A0	0x300
+#define BCMA_GMAC_CMN_UDF_0_A7_A4	0x304
+#define BCMA_GMAC_CMN_UDF_0_A8		0x308
+#define BCMA_GMAC_CMN_UDF_1_A3_A0	0x310
+#define BCMA_GMAC_CMN_UDF_1_A7_A4	0x314
+#define BCMA_GMAC_CMN_UDF_1_A8		0x318
+#define BCMA_GMAC_CMN_UDF_2_A3_A0	0x320
+#define BCMA_GMAC_CMN_UDF_2_A7_A4	0x324
+#define BCMA_GMAC_CMN_UDF_2_A8		0x328
+#define BCMA_GMAC_CMN_UDF_0_B3_B0	0x330
+#define BCMA_GMAC_CMN_UDF_0_B7_B4	0x334
+#define BCMA_GMAC_CMN_UDF_0_B8		0x338
+#define BCMA_GMAC_CMN_UDF_1_B3_B0	0x340
+#define BCMA_GMAC_CMN_UDF_1_B7_B4	0x344
+#define BCMA_GMAC_CMN_UDF_1_B8		0x348
+#define BCMA_GMAC_CMN_UDF_2_B3_B0	0x350
+#define BCMA_GMAC_CMN_UDF_2_B7_B4	0x354
+#define BCMA_GMAC_CMN_UDF_2_B8		0x358
+#define BCMA_GMAC_CMN_UDF_0_C3_C0	0x360
+#define BCMA_GMAC_CMN_UDF_0_C7_C4	0x364
+#define BCMA_GMAC_CMN_UDF_0_C8		0x368
+#define BCMA_GMAC_CMN_UDF_1_C3_C0	0x370
+#define BCMA_GMAC_CMN_UDF_1_C7_C4	0x374
+#define BCMA_GMAC_CMN_UDF_1_C8		0x378
+#define BCMA_GMAC_CMN_UDF_2_C3_C0	0x380
+#define BCMA_GMAC_CMN_UDF_2_C7_C4	0x384
+#define BCMA_GMAC_CMN_UDF_2_C8		0x388
+#define BCMA_GMAC_CMN_UDF_0_D3_D0	0x390
+#define BCMA_GMAC_CMN_UDF_0_D7_D4	0x394
+#define BCMA_GMAC_CMN_UDF_0_D11_D8	0x394
+
+struct bcma_drv_gmac_cmn {
+	struct bcma_device *core;
+
+	/* Drivers accessing BCMA_GMAC_CMN_PHY_ACCESS and
+	 * BCMA_GMAC_CMN_PHY_CTL need to take that mutex first. */
+	struct mutex phy_mutex;
+};
+
+/* Register access */
+#define gmac_cmn_read16(gc, offset)		bcma_read16((gc)->core, offset)
+#define gmac_cmn_read32(gc, offset)		bcma_read32((gc)->core, offset)
+#define gmac_cmn_write16(gc, offset, val)	bcma_write16((gc)->core, offset, val)
+#define gmac_cmn_write32(gc, offset, val)	bcma_write32((gc)->core, offset, val)
+
+#ifdef CONFIG_BCMA_DRIVER_GMAC_CMN
+extern void __devinit bcma_core_gmac_cmn_init(struct bcma_drv_gmac_cmn *gc);
+#else
+static inline void bcma_core_gmac_cmn_init(struct bcma_drv_gmac_cmn *gc) { }
+#endif
+
+#endif /* LINUX_BCMA_DRIVER_GMAC_CMN_H_ */
-- 
1.7.7

