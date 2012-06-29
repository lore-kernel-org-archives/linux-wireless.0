Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52478 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445Ab2F2XqL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 19:46:11 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org, arend@broadcom.com,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 1/9] bcma: extend workaround for bcm4331
Date: Sat, 30 Jun 2012 01:44:37 +0200
Message-Id: <1341013486-2520-2-git-send-email-hauke@hauke-m.de> (sfid-20120630_014613_970015_72E86943)
In-Reply-To: <1341013486-2520-1-git-send-email-hauke@hauke-m.de>
References: <1341013486-2520-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is based on a recent version of the Broadcom SDK.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_chipcommon_pmu.c        |    3 +++
 include/linux/bcma/bcma_driver_chipcommon.h |    1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index 61ce405..f18df1f 100644
--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -123,8 +123,11 @@ void bcma_chipco_bcm4331_ext_pa_lines_ctl(struct bcma_drv_cc *cc, bool enable)
 		val |= BCMA_CHIPCTL_4331_EXTPA_EN;
 		if (bus->chipinfo.pkg == 9 || bus->chipinfo.pkg == 11)
 			val |= BCMA_CHIPCTL_4331_EXTPA_ON_GPIO2_5;
+		else if (bus->chipinfo.rev > 0)
+			val |= BCMA_CHIPCTL_4331_EXTPA_EN2;
 	} else {
 		val &= ~BCMA_CHIPCTL_4331_EXTPA_EN;
+		val &= ~BCMA_CHIPCTL_4331_EXTPA_EN2;
 		val &= ~BCMA_CHIPCTL_4331_EXTPA_ON_GPIO2_5;
 	}
 	bcma_cc_write32(cc, BCMA_CC_CHIPCTL, val);
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index 8bbfe31..1e523cc 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -321,6 +321,7 @@
 #define BCMA_CHIPCTL_4331_OVR_PIPEAUXPWRDOWN	BIT(9)	/* override core control on pipe_AuxPowerDown */
 #define BCMA_CHIPCTL_4331_PCIE_AUXCLKEN		BIT(10)	/* pcie_auxclkenable */
 #define BCMA_CHIPCTL_4331_PCIE_PIPE_PLLDOWN	BIT(11)	/* pcie_pipe_pllpowerdown */
+#define BCMA_CHIPCTL_4331_EXTPA_EN2		BIT(12)	/* 0 ext pa disable, 1 ext pa enabled */
 #define BCMA_CHIPCTL_4331_BT_SHD0_ON_GPIO4	BIT(16)	/* enable bt_shd0 at gpio4 */
 #define BCMA_CHIPCTL_4331_BT_SHD1_ON_GPIO5	BIT(17)	/* enable bt_shd1 at gpio5 */
 
-- 
1.7.9.5

