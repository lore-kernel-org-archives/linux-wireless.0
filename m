Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2340 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294Ab1ECJgY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:24 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: [PATCH 51/61] staging: brcm80211: removed ASSERTs from
 wlc_pmu.c
Date: Tue, 3 May 2011 11:35:51 +0200
Message-ID: <1304415361-7813-52-git-send-email-arend@broadcom.com> (sfid-20110503_113651_856875_4EE40F47)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_pmu.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
index 8fc644f..5b1697a 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2010 Broadcom Corporation
+ * Copyright (c) 2011 Broadcom Corporation
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -1220,7 +1220,6 @@ u32 si_pmu_ilp_clock(si_t *sih)
 		u32 start, end, delta;
 		u32 origidx = ai_coreidx(sih);
 		chipcregs_t *cc = ai_setcoreidx(sih, SI_CC_IDX);
-		ASSERT(cc != NULL);
 		start = R_REG(&cc->pmutimer);
 		mdelay(ILP_CALC_DUR);
 		end = R_REG(&cc->pmutimer);
@@ -1473,7 +1472,6 @@ void si_pmu_spuravoid(si_t *sih, u8 spuravoid)
 		/* wait for the ht to really go away */
 		SPINWAIT(((R_REG(&cc->clk_ctl_st) & CCS_HTAVAIL) == 0),
 			 10000);
-		ASSERT((R_REG(&cc->clk_ctl_st) & CCS_HTAVAIL) == 0);
 	}
 
 	/* update the pll changes */
@@ -1523,7 +1521,6 @@ void si_pmu_chip_init(si_t *sih)
 {
 	uint origidx;
 
-
 	/* Gate off SPROM clock and chip select signals */
 	si_pmu_sprom_enable(sih, false);
 
@@ -1537,7 +1534,6 @@ void si_pmu_chip_init(si_t *sih)
 /* initialize PMU switch/regulators */
 void si_pmu_swreg_init(si_t *sih)
 {
-
 	switch (sih->chip) {
 	case BCM4336_CHIP_ID:
 		/* Reduce CLDO PWM output voltage to 1.2V */
@@ -1566,7 +1562,6 @@ void si_pmu_pll_init(si_t *sih, uint xtalfreq)
 	chipcregs_t *cc;
 	uint origidx;
 
-
 	/* Remember original core before switch to chipc */
 	origidx = ai_coreidx(sih);
 	cc = ai_setcoreidx(sih, SI_CC_IDX);
@@ -1736,7 +1731,6 @@ void si_pmu_res_init(si_t *sih)
 					[pmu_res_depend_table_sz].depend_mask);
 				break;
 			default:
-				ASSERT(0);
 				break;
 			}
 		}
@@ -1783,11 +1777,9 @@ u32 si_pmu_measure_alpclk(si_t *sih)
 	if (sih->pmurev < 10)
 		return 0;
 
-
 	/* Remember original core before switch to chipc */
 	origidx = ai_coreidx(sih);
 	cc = ai_setcoreidx(sih, SI_CC_IDX);
-	ASSERT(cc != NULL);
 
 	if (R_REG(&cc->pmustatus) & PST_EXTLPOAVAIL) {
 		u32 ilp_ctr, alp_hz;
-- 
1.7.4.1


