Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52532 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755548Ab2F2XqV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 19:46:21 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org, arend@broadcom.com,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 7/9] bcma: remove chip ids doing nothing from PMU initialization.
Date: Sat, 30 Jun 2012 01:44:43 +0200
Message-Id: <1341013486-2520-8-git-send-email-hauke@hauke-m.de> (sfid-20120630_014626_423533_326347DC)
In-Reply-To: <1341013486-2520-1-git-send-email-hauke@hauke-m.de>
References: <1341013486-2520-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The list of devices where nothing has to be done in
bcma_pmu_resources_init() and bcma_pmu_workarounds() is longer as all
the SoCs are missing there and some new devices will be added in some
time later. This patch changes the default case to just log on debug
level and also let the other devices which do not need any special
handling into the default case, instead of adding the missing 8 SoC
chip ids.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_chipcommon_pmu.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index 069fca7..1a7a72f 100644
--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -64,13 +64,9 @@ static void bcma_pmu_resources_init(struct bcma_drv_cc *cc)
 		min_msk = 0x200D;
 		max_msk = 0xFFFF;
 		break;
-	case BCMA_CHIP_ID_BCM4331:
-	case BCMA_CHIP_ID_BCM43224:
-	case BCMA_CHIP_ID_BCM43225:
-		break;
 	default:
-		pr_err("PMU resource config unknown for device 0x%04X\n",
-			bus->chipinfo.id);
+		pr_debug("PMU resource config unknown or not needed for device 0x%04X\n",
+			 bus->chipinfo.id);
 	}
 
 	/* Set the resource masks. */
@@ -135,11 +131,9 @@ void bcma_pmu_workarounds(struct bcma_drv_cc *cc)
 						    BCMA_CCTRL_43224B0_12MA_LED_DRIVE);
 		}
 		break;
-	case BCMA_CHIP_ID_BCM43225:
-		break;
 	default:
-		pr_err("Workarounds unknown for device 0x%04X\n",
-			bus->chipinfo.id);
+		pr_debug("Workarounds unknown or not needed for device 0x%04X\n",
+			 bus->chipinfo.id);
 	}
 }
 
-- 
1.7.9.5

