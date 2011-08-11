Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37793 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab1HKVHk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 17:07:40 -0400
Received: by fxh19 with SMTP id 19so1940231fxh.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 14:07:38 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH V2] bcma: implement BCM4331 workaround for external PA lines
Date: Thu, 11 Aug 2011 23:46:44 +0200
Message-Id: <1313099204-24930-1-git-send-email-zajec5@gmail.com> (sfid-20110811_230743_715866_2E8076A2)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We need to disable ext. PA lines for reading SPROM. It's disabled by
default, but this patch allows using bcma after loading wl, which leaves
workaround enabled.

Cc: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: Fixed typo in function name. Thanks Arend.
---
 drivers/bcma/driver_chipcommon_pmu.c        |   20 +++++++++++++++++++-
 drivers/bcma/sprom.c                        |    6 ++++++
 include/linux/bcma/bcma_driver_chipcommon.h |   18 ++++++++++++++++++
 3 files changed, 43 insertions(+), 1 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index 5940c81..4bc10aa 100644
--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -90,6 +90,24 @@ void bcma_pmu_swreg_init(struct bcma_drv_cc *cc)
 	}
 }
 
+/* Disable to allow reading SPROM. Don't know the adventages of enabling it. */
+void bcma_chipco_bcm4331_ext_pa_lines_ctl(struct bcma_drv_cc *cc, bool enable)
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
@@ -99,7 +117,7 @@ void bcma_pmu_workarounds(struct bcma_drv_cc *cc)
 		bcma_chipco_chipctl_maskset(cc, 0, ~0, 0x7);
 		break;
 	case 0x4331:
-		pr_err("Enabling Ext PA lines not implemented\n");
+		/* BCM4331 workaround is SPROM-related, we put it in sprom.c */
 		break;
 	case 43224:
 		if (bus->chipinfo.rev == 0) {
diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
index 8b5b785..166ed13 100644
--- a/drivers/bcma/sprom.c
+++ b/drivers/bcma/sprom.c
@@ -152,6 +152,9 @@ int bcma_sprom_get(struct bcma_bus *bus)
 	if (!sprom)
 		return -ENOMEM;
 
+	if (bus->chipinfo.id == 0x4331)
+		bcma_chipco_bcm4331_ext_pa_lines_ctl(&bus->drv_cc, false);
+
 	/* Most cards have SPROM moved by additional offset 0x30 (48 dwords).
 	 * According to brcm80211 this applies to cards with PCIe rev >= 6
 	 * TODO: understand this condition and use it */
@@ -159,6 +162,9 @@ int bcma_sprom_get(struct bcma_bus *bus)
 		BCMA_CC_SPROM_PCIE6;
 	bcma_sprom_read(bus, offset, sprom);
 
+	if (bus->chipinfo.id == 0x4331)
+		bcma_chipco_bcm4331_ext_pa_lines_ctl(&bus->drv_cc, true);
+
 	err = bcma_sprom_valid(sprom);
 	if (err)
 		goto out;
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index 6083725..a7ae33d 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -283,6 +283,22 @@
 #define BCMA_CC_PPL_PCHI_OFF		5
 #define BCMA_CC_PPL_PCHI_MASK		0x0000003f
 
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
@@ -342,6 +358,8 @@ extern void bcma_core_chipcommon_init(struct bcma_drv_cc *cc);
 extern void bcma_chipco_suspend(struct bcma_drv_cc *cc);
 extern void bcma_chipco_resume(struct bcma_drv_cc *cc);
 
+void bcma_chipco_bcm4331_ext_pa_lines_ctl(struct bcma_drv_cc *cc, bool enable);
+
 extern void bcma_chipco_watchdog_timer_set(struct bcma_drv_cc *cc,
 					  u32 ticks);
 
-- 
1.7.3.4

