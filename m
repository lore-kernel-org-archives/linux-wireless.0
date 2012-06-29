Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52516 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116Ab2F2XqS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 19:46:18 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org, arend@broadcom.com,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 5/9] bcma: complete workaround for BCMA43224 and BCM4313
Date: Sat, 30 Jun 2012 01:44:41 +0200
Message-Id: <1341013486-2520-6-git-send-email-hauke@hauke-m.de> (sfid-20120630_014622_327813_BA04EE03)
In-Reply-To: <1341013486-2520-1-git-send-email-hauke@hauke-m.de>
References: <1341013486-2520-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This code is based on the Broadcom SDK and brcmsmac.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_chipcommon_pmu.c        |   22 +++++++++++++++++-----
 include/linux/bcma/bcma_driver_chipcommon.h |    8 ++++++++
 2 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index 2d9ac3e..a8fcdf0 100644
--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -139,7 +139,11 @@ void bcma_pmu_workarounds(struct bcma_drv_cc *cc)
 
 	switch (bus->chipinfo.id) {
 	case BCMA_CHIP_ID_BCM4313:
-		bcma_chipco_chipctl_maskset(cc, 0, ~0, 0x7);
+		/* enable 12 mA drive strenth for 4313 and set chipControl
+		   register bit 1 */
+		bcma_chipco_chipctl_maskset(cc, 0,
+					    BCMA_CCTRL_4313_12MA_LED_DRIVE,
+					    BCMA_CCTRL_4313_12MA_LED_DRIVE);
 		break;
 	case BCMA_CHIP_ID_BCM4331:
 	case BCMA_CHIP_ID_BCM43431:
@@ -147,12 +151,20 @@ void bcma_pmu_workarounds(struct bcma_drv_cc *cc)
 		bcma_chipco_bcm4331_ext_pa_lines_ctl(cc, true);
 		break;
 	case BCMA_CHIP_ID_BCM43224:
+	case BCMA_CHIP_ID_BCM43421:
+		/* enable 12 mA drive strenth for 43224 and set chipControl
+		   register bit 15 */
 		if (bus->chipinfo.rev == 0) {
-			pr_err("Workarounds for 43224 rev 0 not fully "
-				"implemented\n");
-			bcma_chipco_chipctl_maskset(cc, 0, ~0, 0x00F000F0);
+			bcma_cc_maskset32(cc, BCMA_CC_CHIPCTL,
+					  BCMA_CCTRL_43224_GPIO_TOGGLE,
+					  BCMA_CCTRL_43224_GPIO_TOGGLE);
+			bcma_chipco_chipctl_maskset(cc, 0,
+						    BCMA_CCTRL_43224A0_12MA_LED_DRIVE,
+						    BCMA_CCTRL_43224A0_12MA_LED_DRIVE);
 		} else {
-			bcma_chipco_chipctl_maskset(cc, 0, ~0, 0xF0);
+			bcma_chipco_chipctl_maskset(cc, 0,
+						    BCMA_CCTRL_43224B0_12MA_LED_DRIVE,
+						    BCMA_CCTRL_43224B0_12MA_LED_DRIVE);
 		}
 		break;
 	case BCMA_CHIP_ID_BCM43225:
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index 1e523cc..09f31ad 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -325,6 +325,14 @@
 #define BCMA_CHIPCTL_4331_BT_SHD0_ON_GPIO4	BIT(16)	/* enable bt_shd0 at gpio4 */
 #define BCMA_CHIPCTL_4331_BT_SHD1_ON_GPIO5	BIT(17)	/* enable bt_shd1 at gpio5 */
 
+/* 43224 chip-specific ChipControl register bits */
+#define BCMA_CCTRL_43224_GPIO_TOGGLE		0x8000		/* gpio[3:0] pins as btcoex or s/w gpio */
+#define BCMA_CCTRL_43224A0_12MA_LED_DRIVE	0x00F000F0	/* 12 mA drive strength */
+#define BCMA_CCTRL_43224B0_12MA_LED_DRIVE	0xF0		/* 12 mA drive strength for later 43224s */
+
+/* 4313 Chip specific ChipControl register bits */
+#define BCMA_CCTRL_4313_12MA_LED_DRIVE		0x00000007	/* 12 mA drive strengh for later 4313 */
+
 /* Data for the PMU, if available.
  * Check availability with ((struct bcma_chipcommon)->capabilities & BCMA_CC_CAP_PMU)
  */
-- 
1.7.9.5

