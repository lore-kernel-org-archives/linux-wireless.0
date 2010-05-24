Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:58313 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755766Ab0EXT5R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 May 2010 15:57:17 -0400
Received: by wwb28 with SMTP id 28so434854wwb.1
        for <linux-wireless@vger.kernel.org>; Mon, 24 May 2010 12:57:16 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] ssb: update PMU init to match specs
Date: Mon, 24 May 2010 21:50:23 +0200
Message-Id: <1274730624-22922-2-git-send-email-zajec5@gmail.com>
In-Reply-To: <1274730624-22922-1-git-send-email-zajec5@gmail.com>
References: <1274730624-22922-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/ssb/driver_chipcommon_pmu.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/ssb/driver_chipcommon_pmu.c b/drivers/ssb/driver_chipcommon_pmu.c
index 3d55124..5732bb2 100644
--- a/drivers/ssb/driver_chipcommon_pmu.c
+++ b/drivers/ssb/driver_chipcommon_pmu.c
@@ -502,9 +502,9 @@ static void ssb_pmu_resources_init(struct ssb_chipcommon *cc)
 		chipco_write32(cc, SSB_CHIPCO_PMU_MAXRES_MSK, max_msk);
 }
 
+/* http://bcm-v4.sipsolutions.net/802.11/SSB/PmuInit */
 void ssb_pmu_init(struct ssb_chipcommon *cc)
 {
-	struct ssb_bus *bus = cc->dev->bus;
 	u32 pmucap;
 
 	if (!(cc->capabilities & SSB_CHIPCO_CAP_PMU))
@@ -516,15 +516,12 @@ void ssb_pmu_init(struct ssb_chipcommon *cc)
 	ssb_dprintk(KERN_DEBUG PFX "Found rev %u PMU (capabilities 0x%08X)\n",
 		    cc->pmu.rev, pmucap);
 
-	if (cc->pmu.rev >= 1) {
-		if ((bus->chip_id == 0x4325) && (bus->chip_rev < 2)) {
-			chipco_mask32(cc, SSB_CHIPCO_PMU_CTL,
-				      ~SSB_CHIPCO_PMU_CTL_NOILPONW);
-		} else {
-			chipco_set32(cc, SSB_CHIPCO_PMU_CTL,
-				     SSB_CHIPCO_PMU_CTL_NOILPONW);
-		}
-	}
+	if (cc->pmu.rev == 1)
+		chipco_mask32(cc, SSB_CHIPCO_PMU_CTL,
+			      ~SSB_CHIPCO_PMU_CTL_NOILPONW);
+	else
+		chipco_set32(cc, SSB_CHIPCO_PMU_CTL,
+			     SSB_CHIPCO_PMU_CTL_NOILPONW);
 	ssb_pmu_pll_init(cc);
 	ssb_pmu_resources_init(cc);
 }
-- 
1.6.4.2

