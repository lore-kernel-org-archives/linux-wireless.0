Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2675 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754685Ab1LLXP5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 18:15:57 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 07/15] brcm80211: smac: remove empty or unused functions
 from pmu.c
Date: Mon, 12 Dec 2011 15:15:05 -0800
Message-ID: <1323731713-14942-8-git-send-email-frankyl@broadcom.com> (sfid-20111213_002944_665724_4B8E9747)
In-Reply-To: <1323731713-14942-1-git-send-email-frankyl@broadcom.com>
References: <1323731713-14942-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

A number of functions in pmu.c are not used or adding no functionality
at all. These have been removed.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |    7 +--
 drivers/net/wireless/brcm80211/brcmsmac/pmu.c     |   57 ---------------------
 drivers/net/wireless/brcm80211/brcmsmac/pmu.h     |    3 -
 3 files changed, 1 insertions(+), 66 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index 7e5d41b..3d37b0a 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -721,14 +721,9 @@ static struct si_info *ai_doattach(struct si_info *sii,
 
 	/* PMU specific initializations */
 	if (ai_get_cccaps(sih) & CC_CAP_PMU) {
-		u32 xtalfreq;
 		si_pmu_init(sih);
-		si_pmu_chip_init(sih);
-
-		xtalfreq = si_pmu_measure_alpclk(sih);
-		si_pmu_pll_init(sih, xtalfreq);
+		(void)si_pmu_measure_alpclk(sih);
 		si_pmu_res_init(sih);
-		si_pmu_swreg_init(sih);
 	}
 
 	/* setup the GPIO based LED powersave register */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pmu.c b/drivers/net/wireless/brcm80211/brcmsmac/pmu.c
index 9a4d367..d972e9c 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pmu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pmu.c
@@ -227,19 +227,6 @@ u16 si_pmu_fast_pwrup_delay(struct si_pub *sih)
 	return (u16) delay;
 }
 
-void si_pmu_sprom_enable(struct si_pub *sih, bool enable)
-{
-	struct chipcregs __iomem *cc;
-	uint origidx;
-
-	/* Remember original core before switch to chipc */
-	origidx = ai_coreidx(sih);
-	cc = ai_setcoreidx(sih, SI_CC_IDX);
-
-	/* Return to original core */
-	ai_setcoreidx(sih, origidx);
-}
-
 /* Read/write a chipcontrol reg */
 u32 si_pmu_chipcontrol(struct si_pub *sih, uint reg, u32 mask, u32 val)
 {
@@ -325,50 +312,6 @@ void si_pmu_init(struct si_pub *sih)
 		bcma_set32(core, CHIPCREGOFFS(pmucontrol), PCTL_NOILP_ON_WAIT);
 }
 
-/* initialize PMU chip controls and other chip level stuff */
-void si_pmu_chip_init(struct si_pub *sih)
-{
-	uint origidx;
-
-	/* Gate off SPROM clock and chip select signals */
-	si_pmu_sprom_enable(sih, false);
-
-	/* Remember original core */
-	origidx = ai_coreidx(sih);
-
-	/* Return to original core */
-	ai_setcoreidx(sih, origidx);
-}
-
-/* initialize PMU switch/regulators */
-void si_pmu_swreg_init(struct si_pub *sih)
-{
-}
-
-/* initialize PLL */
-void si_pmu_pll_init(struct si_pub *sih, uint xtalfreq)
-{
-	struct chipcregs __iomem *cc;
-	uint origidx;
-
-	/* Remember original core before switch to chipc */
-	origidx = ai_coreidx(sih);
-	cc = ai_setcoreidx(sih, SI_CC_IDX);
-
-	switch (ai_get_chip_id(sih)) {
-	case BCM4313_CHIP_ID:
-	case BCM43224_CHIP_ID:
-	case BCM43225_CHIP_ID:
-		/* ??? */
-		break;
-	default:
-		break;
-	}
-
-	/* Return to original core */
-	ai_setcoreidx(sih, origidx);
-}
-
 /* initialize PMU resources */
 void si_pmu_res_init(struct si_pub *sih)
 {
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pmu.h b/drivers/net/wireless/brcm80211/brcmsmac/pmu.h
index 3a08c62..dcd893c 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pmu.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pmu.h
@@ -29,10 +29,7 @@ extern void si_pmu_pllupd(struct si_pub *sih);
 extern void si_pmu_spuravoid(struct si_pub *sih, u8 spuravoid);
 extern u32 si_pmu_pllcontrol(struct si_pub *sih, uint reg, u32 mask, u32 val);
 extern void si_pmu_init(struct si_pub *sih);
-extern void si_pmu_chip_init(struct si_pub *sih);
-extern void si_pmu_pll_init(struct si_pub *sih, u32 xtalfreq);
 extern void si_pmu_res_init(struct si_pub *sih);
-extern void si_pmu_swreg_init(struct si_pub *sih);
 extern u32 si_pmu_measure_alpclk(struct si_pub *sih);
 
 #endif /* _BRCM_PMU_H_ */
-- 
1.7.5.4


