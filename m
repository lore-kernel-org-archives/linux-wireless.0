Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:49846 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759668Ab2JYQjx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 12:39:53 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, m@bues.ch,
	b43-dev@lists.infradead.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] ssb: handle BCM43222 in pmu code.
Date: Thu, 25 Oct 2012 18:39:29 +0200
Message-Id: <1351183169-13392-2-git-send-email-hauke@hauke-m.de> (sfid-20121025_184013_861009_4BC0E7B7)
In-Reply-To: <1351183169-13392-1-git-send-email-hauke@hauke-m.de>
References: <1351183169-13392-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The BCM43222 with the chipid 43222 or 0xa8d6 in hex do not need any
special handling in the pmu code. This prevents some error messages
being shown.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/ssb/driver_chipcommon_pmu.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ssb/driver_chipcommon_pmu.c b/drivers/ssb/driver_chipcommon_pmu.c
index b58fef7..d7d5804 100644
--- a/drivers/ssb/driver_chipcommon_pmu.c
+++ b/drivers/ssb/driver_chipcommon_pmu.c
@@ -346,6 +346,8 @@ static void ssb_pmu_pll_init(struct ssb_chipcommon *cc)
 			chipco_write32(cc, SSB_CHIPCO_PLLCTL_DATA, 0x380005C0);
 		}
 		break;
+	case 43222:
+		break;
 	default:
 		ssb_printk(KERN_ERR PFX
 			   "ERROR: PLL init unknown for device %04X\n",
@@ -434,6 +436,7 @@ static void ssb_pmu_resources_init(struct ssb_chipcommon *cc)
 		 min_msk = 0xCBB;
 		 break;
 	case 0x4322:
+	case 43222:
 		/* We keep the default settings:
 		 * min_msk = 0xCBB
 		 * max_msk = 0x7FFFF
-- 
1.7.9.5

