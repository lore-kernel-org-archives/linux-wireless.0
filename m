Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42879 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab2GIUDQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 16:03:16 -0400
Received: by mail-ey0-f174.google.com with SMTP id k11so4463223eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2012 13:03:15 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=5D=20bcma=3A=20add=20PMU=20clock=20support=20for=20BCM4706?=
Date: Mon,  9 Jul 2012 22:03:10 +0200
Message-Id: <1341864190-19188-1-git-send-email-zajec5@gmail.com> (sfid-20120709_220355_002309_1F0A655E)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hauke Mehrtens <hauke@hauke-m.de>

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Tested-by: Rafał Miłecki <zajec5@gmail.com>
---
This correctly calculates clock (as 600000000) on my WNDR4500.
---
 drivers/bcma/driver_chipcommon_pmu.c        |   40 ++++++++++++++++++++++++---
 include/linux/bcma/bcma_driver_chipcommon.h |   14 +++++++++
 2 files changed, 50 insertions(+), 4 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index 74a87d5..4432617 100644
--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -226,6 +226,36 @@ static u32 bcma_pmu_clock(struct bcma_drv_cc *cc, u32 pll0, u32 m)
 	return (fc / div) * 1000000;
 }
 
+static u32 bcma_pmu_clock_bcm4706(struct bcma_drv_cc *cc, u32 pll0, u32 m)
+{
+	u32 tmp, ndiv, p1div, p2div;
+	u32 clock;
+
+	BUG_ON(!m || m > 4);
+
+	/* Get N, P1 and P2 dividers to determine CPU clock */
+	tmp = bcma_chipco_pll_read(cc, pll0 + BCMA_CC_PMU6_4706_PROCPLL_OFF);
+	ndiv = (tmp & BCMA_CC_PMU6_4706_PROC_NDIV_INT_MASK)
+		>> BCMA_CC_PMU6_4706_PROC_NDIV_INT_SHIFT;
+	p1div = (tmp & BCMA_CC_PMU6_4706_PROC_P1DIV_MASK)
+		>> BCMA_CC_PMU6_4706_PROC_P1DIV_SHIFT;
+	p2div = (tmp & BCMA_CC_PMU6_4706_PROC_P2DIV_MASK)
+		>> BCMA_CC_PMU6_4706_PROC_P2DIV_SHIFT;
+
+	tmp = bcma_cc_read32(cc, BCMA_CC_CHIPSTAT);
+	if (tmp & BCMA_CC_CHIPST_4706_PKG_OPTION)
+		/* Low cost bonding: Fixed reference clock 25MHz and m = 4 */
+		clock = (25000000 / 4) * ndiv * p2div / p1div;
+	else
+		/* Fixed reference clock 25MHz and m = 2 */
+		clock = (25000000 / 2) * ndiv * p2div / p1div;
+
+	if (m == BCMA_CC_PMU5_MAINPLL_SSB)
+		clock = clock / 4;
+
+	return clock;
+}
+
 /* query bus clock frequency for PMU-enabled chipcommon */
 u32 bcma_pmu_get_clockcontrol(struct bcma_drv_cc *cc)
 {
@@ -245,8 +275,8 @@ u32 bcma_pmu_get_clockcontrol(struct bcma_drv_cc *cc)
 		return bcma_pmu_clock(cc, BCMA_CC_PMU5357_MAINPLL_PLL0,
 				      BCMA_CC_PMU5_MAINPLL_SSB);
 	case BCMA_CHIP_ID_BCM4706:
-		return bcma_pmu_clock(cc, BCMA_CC_PMU4706_MAINPLL_PLL0,
-				      BCMA_CC_PMU5_MAINPLL_SSB);
+		return bcma_pmu_clock_bcm4706(cc, BCMA_CC_PMU4706_MAINPLL_PLL0,
+					      BCMA_CC_PMU5_MAINPLL_SSB);
 	case BCMA_CHIP_ID_BCM53572:
 		return 75000000;
 	default:
@@ -267,6 +297,10 @@ u32 bcma_pmu_get_clockcpu(struct bcma_drv_cc *cc)
 	if (cc->pmu.rev >= 5) {
 		u32 pll;
 		switch (bus->chipinfo.id) {
+		case BCMA_CHIP_ID_BCM4706:
+			return bcma_pmu_clock_bcm4706(cc,
+						BCMA_CC_PMU4706_MAINPLL_PLL0,
+						BCMA_CC_PMU5_MAINPLL_CPU);
 		case BCMA_CHIP_ID_BCM5356:
 			pll = BCMA_CC_PMU5356_MAINPLL_PLL0;
 			break;
@@ -279,8 +313,6 @@ u32 bcma_pmu_get_clockcpu(struct bcma_drv_cc *cc)
 			break;
 		}
 
-		/* TODO: if (bus->chipinfo.id == BCMA_CHIP_ID_BCM4706)
-		  return si_4706_pmu_clock(sih, osh, cc, PMU4706_MAINPLL_PLL0, PMU5_MAINPLL_CPU); */
 		return bcma_pmu_clock(cc, pll, BCMA_CC_PMU5_MAINPLL_CPU);
 	}
 
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index 12975ea..53f7d4b 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -88,6 +88,11 @@
 #define  BCMA_CC_CHIPST_4313_OTP_PRESENT	2
 #define  BCMA_CC_CHIPST_4331_SPROM_PRESENT	2
 #define  BCMA_CC_CHIPST_4331_OTP_PRESENT	4
+#define  BCMA_CC_CHIPST_4706_PKG_OPTION		BIT(0) /* 0: full-featured package 1: low-cost package */
+#define  BCMA_CC_CHIPST_4706_SFLASH_PRESENT	BIT(1) /* 0: parallel, 1: serial flash is present */
+#define  BCMA_CC_CHIPST_4706_SFLASH_TYPE	BIT(2) /* 0: 8b-p/ST-s flash, 1: 16b-p/Atmal-s flash */
+#define  BCMA_CC_CHIPST_4706_MIPS_BENDIAN	BIT(3) /* 0: little, 1: big endian */
+#define  BCMA_CC_CHIPST_4706_PCIE1_DISABLE	BIT(5) /* PCIE1 enable strap pin */
 #define BCMA_CC_JCMD			0x0030		/* Rev >= 10 only */
 #define  BCMA_CC_JCMD_START		0x80000000
 #define  BCMA_CC_JCMD_BUSY		0x80000000
@@ -280,6 +285,15 @@
 
 /* 4706 PMU */
 #define BCMA_CC_PMU4706_MAINPLL_PLL0	0
+#define BCMA_CC_PMU6_4706_PROCPLL_OFF	4	/* The CPU PLL */
+#define  BCMA_CC_PMU6_4706_PROC_P2DIV_MASK	0x000f0000
+#define  BCMA_CC_PMU6_4706_PROC_P2DIV_SHIFT	16
+#define  BCMA_CC_PMU6_4706_PROC_P1DIV_MASK	0x0000f000
+#define  BCMA_CC_PMU6_4706_PROC_P1DIV_SHIFT	12
+#define  BCMA_CC_PMU6_4706_PROC_NDIV_INT_MASK	0x00000ff8
+#define  BCMA_CC_PMU6_4706_PROC_NDIV_INT_SHIFT	3
+#define  BCMA_CC_PMU6_4706_PROC_NDIV_MODE_MASK	0x00000007
+#define  BCMA_CC_PMU6_4706_PROC_NDIV_MODE_SHIFT	0
 
 /* ALP clock on pre-PMU chips */
 #define BCMA_CC_PMU_ALP_CLOCK		20000000
-- 
1.7.7

