Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2357 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308Ab1ECJg0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:26 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>
Subject: [PATCH 42/61] staging: brcm80211: fix checkpatch issues in
 si_pmu_measure_alpclk
Date: Tue, 3 May 2011 11:35:42 +0200
Message-ID: <1304415361-7813-43-git-send-email-arend@broadcom.com> (sfid-20110503_113646_900583_924832B1)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch "remove dependency between aiutils and siutils sources" introduced
several checkpatch warnings. This patch removes those in the function
si_pmu_measure_alpclk().

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_pmu.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
index 2c3d42fd..e98ace6 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
@@ -1792,7 +1792,10 @@ u32 si_pmu_measure_alpclk(si_t *sih)
 	if (R_REG(&cc->pmustatus) & PST_EXTLPOAVAIL) {
 		u32 ilp_ctr, alp_hz;
 
-		/* Enable the reg to measure the freq, in case disabled before */
+		/*
+		 * Enable the reg to measure the freq,
+		 * in case it was disabled before
+		 */
 		W_REG(&cc->pmu_xtalfreq,
 		      1U << PMU_XTALFREQ_REG_MEASURE_SHIFT);
 
@@ -1803,13 +1806,19 @@ u32 si_pmu_measure_alpclk(si_t *sih)
 		ilp_ctr =
 		    R_REG(&cc->pmu_xtalfreq) & PMU_XTALFREQ_REG_ILPCTR_MASK;
 
-		/* Turn off the PMU_XTALFREQ_REG_MEASURE_SHIFT bit to save power */
+		/*
+		 * Turn off the PMU_XTALFREQ_REG_MEASURE_SHIFT
+		 * bit to save power
+		 */
 		W_REG(&cc->pmu_xtalfreq, 0);
 
 		/* Calculate ALP frequency */
 		alp_hz = (ilp_ctr * EXT_ILP_HZ) / 4;
 
-		/* Round to nearest 100KHz, and at the same time convert to KHz */
+		/*
+		 * Round to nearest 100KHz, and at
+		 * the same time convert to KHz
+		 */
 		alp_khz = (alp_hz + 50000) / 100000 * 100;
 	} else
 		alp_khz = 0;
-- 
1.7.4.1


