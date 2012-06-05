Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:35895 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170Ab2FEVzc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 17:55:32 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org, arend@broadcom.com,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 6/8] bcma: handle SoCs in pmu initialization
Date: Tue,  5 Jun 2012 23:55:05 +0200
Message-Id: <1338933307-13446-7-git-send-email-hauke@hauke-m.de> (sfid-20120605_235536_172239_4928A01E)
In-Reply-To: <1338933307-13446-1-git-send-email-hauke@hauke-m.de>
References: <1338933307-13446-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The SoCs do not need any special handling in bcma_pmu_pll_init(),
bcma_pmu_resources_init(), bcma_pmu_swreg_init() and
bcma_pmu_workarounds. This patches suppresses some warnings in the log.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_chipcommon_pmu.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index 2ebba9c..9bf2dff 100644
--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -63,6 +63,14 @@ static void bcma_pmu_pll_init(struct bcma_drv_cc *cc)
 	case BCMA_CHIP_ID_BCM4331:
 	case BCMA_CHIP_ID_BCM43224:
 	case BCMA_CHIP_ID_BCM43225:
+	case BCMA_CHIP_ID_BCM4716:
+	case BCMA_CHIP_ID_BCM4748:
+	case BCMA_CHIP_ID_BCM47162:
+	case BCMA_CHIP_ID_BCM4749:
+	case BCMA_CHIP_ID_BCM5357:
+	case BCMA_CHIP_ID_BCM5356:
+	case BCMA_CHIP_ID_BCM53572:
+	case BCMA_CHIP_ID_BCM4706:
 		break;
 	default:
 		pr_err("PLL init unknown for device 0x%04X\n",
@@ -83,6 +91,14 @@ static void bcma_pmu_resources_init(struct bcma_drv_cc *cc)
 	case BCMA_CHIP_ID_BCM4331:
 	case BCMA_CHIP_ID_BCM43224:
 	case BCMA_CHIP_ID_BCM43225:
+	case BCMA_CHIP_ID_BCM4716:
+	case BCMA_CHIP_ID_BCM4748:
+	case BCMA_CHIP_ID_BCM47162:
+	case BCMA_CHIP_ID_BCM4749:
+	case BCMA_CHIP_ID_BCM5357:
+	case BCMA_CHIP_ID_BCM5356:
+	case BCMA_CHIP_ID_BCM53572:
+	case BCMA_CHIP_ID_BCM4706:
 		break;
 	default:
 		pr_err("PMU resource config unknown for device 0x%04X\n",
@@ -105,6 +121,14 @@ static void bcma_pmu_swreg_init(struct bcma_drv_cc *cc)
 	case BCMA_CHIP_ID_BCM4331:
 	case BCMA_CHIP_ID_BCM43224:
 	case BCMA_CHIP_ID_BCM43225:
+	case BCMA_CHIP_ID_BCM4716:
+	case BCMA_CHIP_ID_BCM4748:
+	case BCMA_CHIP_ID_BCM47162:
+	case BCMA_CHIP_ID_BCM4749:
+	case BCMA_CHIP_ID_BCM5357:
+	case BCMA_CHIP_ID_BCM5356:
+	case BCMA_CHIP_ID_BCM53572:
+	case BCMA_CHIP_ID_BCM4706:
 		break;
 	default:
 		pr_err("PMU switch/regulators init unknown for device "
@@ -168,6 +192,14 @@ static void bcma_pmu_workarounds(struct bcma_drv_cc *cc)
 		}
 		break;
 	case BCMA_CHIP_ID_BCM43225:
+	case BCMA_CHIP_ID_BCM4716:
+	case BCMA_CHIP_ID_BCM4748:
+	case BCMA_CHIP_ID_BCM47162:
+	case BCMA_CHIP_ID_BCM4749:
+	case BCMA_CHIP_ID_BCM5357:
+	case BCMA_CHIP_ID_BCM5356:
+	case BCMA_CHIP_ID_BCM53572:
+	case BCMA_CHIP_ID_BCM4706:
 		break;
 	default:
 		pr_err("Workarounds unknown for device 0x%04X\n",
-- 
1.7.9.5

