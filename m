Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4581 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173Ab1IXCJU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Sep 2011 22:09:20 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 12/20] staging: brcm80211: remove unused function
 si_pmu_ilp_clock()
Date: Fri, 23 Sep 2011 19:09:00 -0700
Message-ID: <1316830148-28661-13-git-send-email-frankyl@broadcom.com> (sfid-20110924_040949_900644_D7DCD8EC)
In-Reply-To: <1316830148-28661-1-git-send-email-frankyl@broadcom.com>
References: <1316830148-28661-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The function is not used in the driver and has been removed.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/pmu.c |   22 ----------------------
 drivers/staging/brcm80211/brcmsmac/pmu.h |    1 -
 2 files changed, 0 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/pmu.c b/drivers/staging/brcm80211/brcmsmac/pmu.c
index 61ba373..6d4cd9f 100644
--- a/drivers/staging/brcm80211/brcmsmac/pmu.c
+++ b/drivers/staging/brcm80211/brcmsmac/pmu.c
@@ -202,28 +202,6 @@ si_pmu_spuravoid_pllupdate(struct si_pub *sih, struct chipcregs *cc,
 	W_REG(&cc->pmucontrol, tmp);
 }
 
-u32 si_pmu_ilp_clock(struct si_pub *sih)
-{
-	static u32 ilpcycles_per_sec;
-
-	if (!(sih->cccaps & CC_CAP_PMU))
-		return ILP_CLOCK;
-
-	if (ilpcycles_per_sec == 0) {
-		u32 start, end, delta;
-		u32 origidx = ai_coreidx(sih);
-		struct chipcregs *cc = ai_setcoreidx(sih, SI_CC_IDX);
-		start = R_REG(&cc->pmutimer);
-		mdelay(ILP_CALC_DUR);
-		end = R_REG(&cc->pmutimer);
-		delta = end - start;
-		ilpcycles_per_sec = delta * (1000 / ILP_CALC_DUR);
-		ai_setcoreidx(sih, origidx);
-	}
-
-	return ilpcycles_per_sec;
-}
-
 u16 si_pmu_fast_pwrup_delay(struct si_pub *sih)
 {
 	uint delay = PMU_MAX_TRANSITION_DLY;
diff --git a/drivers/staging/brcm80211/brcmsmac/pmu.h b/drivers/staging/brcm80211/brcmsmac/pmu.h
index 2917e6f..3a08c62 100644
--- a/drivers/staging/brcm80211/brcmsmac/pmu.h
+++ b/drivers/staging/brcm80211/brcmsmac/pmu.h
@@ -24,7 +24,6 @@ extern u16 si_pmu_fast_pwrup_delay(struct si_pub *sih);
 extern void si_pmu_sprom_enable(struct si_pub *sih, bool enable);
 extern u32 si_pmu_chipcontrol(struct si_pub *sih, uint reg, u32 mask, u32 val);
 extern u32 si_pmu_regcontrol(struct si_pub *sih, uint reg, u32 mask, u32 val);
-extern u32 si_pmu_ilp_clock(struct si_pub *sih);
 extern u32 si_pmu_alp_clock(struct si_pub *sih);
 extern void si_pmu_pllupd(struct si_pub *sih);
 extern void si_pmu_spuravoid(struct si_pub *sih, u8 spuravoid);
-- 
1.7.1


