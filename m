Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53841 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733Ab2F3NRk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jun 2012 09:17:40 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com
Cc: brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 06/18] brcmsmac: remove si_pmu_init() and si_pmu_res_init()
Date: Sat, 30 Jun 2012 15:16:09 +0200
Message-Id: <1341062181-28071-7-git-send-email-hauke@hauke-m.de> (sfid-20120630_151743_448134_F6F1FF94)
In-Reply-To: <1341062181-28071-1-git-send-email-hauke@hauke-m.de>
References: <1341062181-28071-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is already done by bcma_pmu_init() and bcma_pmu_resources_init() in bcma.

Acked-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |    2 -
 drivers/net/wireless/brcm80211/brcmsmac/pmu.c     |   76 ---------------------
 drivers/net/wireless/brcm80211/brcmsmac/pmu.h     |    2 -
 3 files changed, 80 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index 4abf9b6..c15d9fc 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -503,9 +503,7 @@ static struct si_info *ai_doattach(struct si_info *sii,
 
 	/* PMU specific initializations */
 	if (ai_get_cccaps(sih) & CC_CAP_PMU) {
-		si_pmu_init(sih);
 		(void)si_pmu_measure_alpclk(sih);
-		si_pmu_res_init(sih);
 	}
 
 	/* setup the GPIO based LED powersave register */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pmu.c b/drivers/net/wireless/brcm80211/brcmsmac/pmu.c
index 0399a86..045f43a 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pmu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pmu.c
@@ -108,37 +108,6 @@
 #define	RES4313_HT_AVAIL_RSRC		14
 #define	RES4313_MACPHY_CLK_AVAIL_RSRC	15
 
-/* Determine min/max rsrc masks. Value 0 leaves hardware at default. */
-static void si_pmu_res_masks(struct si_pub *sih, u32 * pmin, u32 * pmax)
-{
-	u32 min_mask = 0, max_mask = 0;
-	uint rsrcs;
-
-	/* # resources */
-	rsrcs = (ai_get_pmucaps(sih) & PCAP_RC_MASK) >> PCAP_RC_SHIFT;
-
-	/* determine min/max rsrc masks */
-	switch (ai_get_chip_id(sih)) {
-	case BCM43224_CHIP_ID:
-	case BCM43225_CHIP_ID:
-		/* ??? */
-		break;
-
-	case BCM4313_CHIP_ID:
-		min_mask = PMURES_BIT(RES4313_BB_PU_RSRC) |
-		    PMURES_BIT(RES4313_XTAL_PU_RSRC) |
-		    PMURES_BIT(RES4313_ALP_AVAIL_RSRC) |
-		    PMURES_BIT(RES4313_BB_PLL_PWRSW_RSRC);
-		max_mask = 0xffff;
-		break;
-	default:
-		break;
-	}
-
-	*pmin = min_mask;
-	*pmax = max_mask;
-}
-
 void si_pmu_spuravoid_pllupdate(struct si_pub *sih, u8 spuravoid)
 {
 	u32 tmp = 0;
@@ -284,51 +253,6 @@ u32 si_pmu_alp_clock(struct si_pub *sih)
 	return clock;
 }
 
-/* initialize PMU */
-void si_pmu_init(struct si_pub *sih)
-{
-	struct si_info *sii = container_of(sih, struct si_info, pub);
-	struct bcma_device *core;
-
-	/* select chipc */
-	core = sii->icbus->drv_cc.core;
-
-	if (ai_get_pmurev(sih) == 1)
-		bcma_mask32(core, CHIPCREGOFFS(pmucontrol),
-			    ~PCTL_NOILP_ON_WAIT);
-	else if (ai_get_pmurev(sih) >= 2)
-		bcma_set32(core, CHIPCREGOFFS(pmucontrol), PCTL_NOILP_ON_WAIT);
-}
-
-/* initialize PMU resources */
-void si_pmu_res_init(struct si_pub *sih)
-{
-	struct si_info *sii = container_of(sih, struct si_info, pub);
-	struct bcma_device *core;
-	u32 min_mask = 0, max_mask = 0;
-
-	/* select to chipc */
-	core = sii->icbus->drv_cc.core;
-
-	/* Determine min/max rsrc masks */
-	si_pmu_res_masks(sih, &min_mask, &max_mask);
-
-	/* It is required to program max_mask first and then min_mask */
-
-	/* Program max resource mask */
-
-	if (max_mask)
-		bcma_write32(core, CHIPCREGOFFS(max_res_mask), max_mask);
-
-	/* Program min resource mask */
-
-	if (min_mask)
-		bcma_write32(core, CHIPCREGOFFS(min_res_mask), min_mask);
-
-	/* Add some delay; allow resources to come up and settle. */
-	mdelay(2);
-}
-
 u32 si_pmu_measure_alpclk(struct si_pub *sih)
 {
 	struct si_info *sii = container_of(sih, struct si_info, pub);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pmu.h b/drivers/net/wireless/brcm80211/brcmsmac/pmu.h
index 3e39c5e..2f0ad28 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pmu.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pmu.h
@@ -28,8 +28,6 @@ extern u32 si_pmu_alp_clock(struct si_pub *sih);
 extern void si_pmu_pllupd(struct si_pub *sih);
 extern void si_pmu_spuravoid_pllupdate(struct si_pub *sih, u8 spuravoid);
 extern u32 si_pmu_pllcontrol(struct si_pub *sih, uint reg, u32 mask, u32 val);
-extern void si_pmu_init(struct si_pub *sih);
-extern void si_pmu_res_init(struct si_pub *sih);
 extern u32 si_pmu_measure_alpclk(struct si_pub *sih);
 
 #endif /* _BRCM_PMU_H_ */
-- 
1.7.9.5

