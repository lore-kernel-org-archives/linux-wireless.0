Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:51359 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab1GNTK5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 15:10:57 -0400
Received: by mail-fx0-f52.google.com with SMTP id 18so1505335fxd.11
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jul 2011 12:10:57 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/4] bcma: implement BCM4331 workaround for external PA lines
Date: Thu, 14 Jul 2011 21:49:20 +0200
Message-Id: <1310672961-5311-3-git-send-email-zajec5@gmail.com> (sfid-20110714_211100_053383_81E548D9)
In-Reply-To: <1310672961-5311-1-git-send-email-zajec5@gmail.com>
References: <1310672961-5311-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/driver_chipcommon_pmu.c        |   19 ++++++++++++++++++-
 include/linux/bcma/bcma_driver_chipcommon.h |   16 ++++++++++++++++
 2 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index dd5846b..9fab4cd 100644
--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -83,6 +83,23 @@ void bcma_pmu_swreg_init(struct bcma_drv_cc *cc)
 	}
 }
 
+static void bcma_bcm4331_exp_pa_lines_ctl(struct bcma_drv_cc *cc, bool enable)
+{
+	struct bcma_bus *bus = cc->core->bus;
+	u32 val;
+
+	val = bcma_cc_read32(cc, BCMA_CC_CHIPCTL);
+	if (enable) {
+		val |= BCMA_CHIPCTL_4331_EXTPA_EN;
+		if (bus->chipinfo.pkg == 9 || bus->chipinfo.pkg == 11)
+			val |= BCMA_CHIPCTL_4331_EXTPA_ON_GPIO2_5;
+	} else {
+		val &= ~BCMA_CHIPCTL_4331_EXTPA_EN;
+		val &= ~BCMA_CHIPCTL_4331_EXTPA_ON_GPIO2_5;
+	}
+	bcma_cc_write32(cc, BCMA_CC_CHIPCTL, val);
+}
+
 void bcma_pmu_workarounds(struct bcma_drv_cc *cc)
 {
 	struct bcma_bus *bus = cc->core->bus;
@@ -92,7 +109,7 @@ void bcma_pmu_workarounds(struct bcma_drv_cc *cc)
 		bcma_chipco_chipctl_maskset(cc, 0, ~0, 0x7);
 		break;
 	case 0x4331:
-		pr_err("Enabling Ext PA lines not implemented\n");
+		bcma_bcm4331_exp_pa_lines_ctl(cc, true);
 		break;
 	case 43224:
 		if (bus->chipinfo.rev == 0) {
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index 9c5b69f..ac659f0 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -246,6 +246,22 @@
 #define BCMA_CC_PLLCTL_DATA		0x0664
 #define BCMA_CC_SPROM			0x0830 /* SPROM beginning */
 
+/* BCM4331 ChipControl numbers. */
+#define BCMA_CHIPCTL_4331_BT_COEXIST		BIT(0)	/* 0 disable */
+#define BCMA_CHIPCTL_4331_SECI			BIT(1)	/* 0 SECI is disabled (JATG functional) */
+#define BCMA_CHIPCTL_4331_EXT_LNA		BIT(2)	/* 0 disable */
+#define BCMA_CHIPCTL_4331_SPROM_GPIO13_15	BIT(3)	/* sprom/gpio13-15 mux */
+#define BCMA_CHIPCTL_4331_EXTPA_EN		BIT(4)	/* 0 ext pa disable, 1 ext pa enabled */
+#define BCMA_CHIPCTL_4331_GPIOCLK_ON_SPROMCS	BIT(5)	/* set drive out GPIO_CLK on sprom_cs pin */
+#define BCMA_CHIPCTL_4331_PCIE_MDIO_ON_SPROMCS	BIT(6)	/* use sprom_cs pin as PCIE mdio interface */
+#define BCMA_CHIPCTL_4331_EXTPA_ON_GPIO2_5	BIT(7)	/* aband extpa will be at gpio2/5 and sprom_dout */
+#define BCMA_CHIPCTL_4331_OVR_PIPEAUXCLKEN	BIT(8)	/* override core control on pipe_AuxClkEnable */
+#define BCMA_CHIPCTL_4331_OVR_PIPEAUXPWRDOWN	BIT(9)	/* override core control on pipe_AuxPowerDown */
+#define BCMA_CHIPCTL_4331_PCIE_AUXCLKEN		BIT(10)	/* pcie_auxclkenable */
+#define BCMA_CHIPCTL_4331_PCIE_PIPE_PLLDOWN	BIT(11)	/* pcie_pipe_pllpowerdown */
+#define BCMA_CHIPCTL_4331_BT_SHD0_ON_GPIO4	BIT(16)	/* enable bt_shd0 at gpio4 */
+#define BCMA_CHIPCTL_4331_BT_SHD1_ON_GPIO5	BIT(17)	/* enable bt_shd1 at gpio5 */
+
 /* Data for the PMU, if available.
  * Check availability with ((struct bcma_chipcommon)->capabilities & BCMA_CC_CAP_PMU)
  */
-- 
1.7.3.4

