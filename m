Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36237 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315Ab2FEXIZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 19:08:25 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com, brudley@broadcom.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 07/18] brcmsmac: remove si_pmu_spuravoid_pllupdate()
Date: Wed,  6 Jun 2012 01:07:10 +0200
Message-Id: <1338937641-8519-8-git-send-email-hauke@hauke-m.de> (sfid-20120606_010827_913655_35F3432E)
In-Reply-To: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

si_pmu_spuravoid_pllupdate() is now replaced by
bcma_pmu_spuravoid_pllupdate() which does the same thing, but supports
more chips.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 .../net/wireless/brcm80211/brcmsmac/phy/phy_n.c    |    3 +-
 drivers/net/wireless/brcm80211/brcmsmac/pmu.c      |   84 --------------------
 drivers/net/wireless/brcm80211/brcmsmac/pmu.h      |    1 -
 3 files changed, 2 insertions(+), 86 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
index 13b2615..2247fef 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
@@ -21106,6 +21106,7 @@ wlc_phy_chanspec_nphy_setup(struct brcms_phy *pi, u16 chanspec,
 			    const struct nphy_sfo_cfg *ci)
 {
 	u16 val;
+	struct si_info *sii = container_of(pi->sh->sih, struct si_info, pub);
 
 	val = read_phy_reg(pi, 0x09) & NPHY_BandControl_currentBand;
 	if (CHSPEC_IS5G(chanspec) && !val) {
@@ -21189,7 +21190,7 @@ wlc_phy_chanspec_nphy_setup(struct brcms_phy *pi, u16 chanspec,
 			spuravoid = 1;
 
 		wlapi_bmac_core_phypll_ctl(pi->sh->physhim, false);
-		si_pmu_spuravoid_pllupdate(pi->sh->sih, spuravoid);
+		bcma_pmu_spuravoid_pllupdate(&sii->icbus->drv_cc, spuravoid);
 		wlapi_bmac_core_phypll_ctl(pi->sh->physhim, true);
 
 		if ((pi->sh->chip == BCM43224_CHIP_ID) ||
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pmu.c b/drivers/net/wireless/brcm80211/brcmsmac/pmu.c
index 045f43a..6b4344f 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pmu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pmu.c
@@ -74,16 +74,6 @@
  * PMU<rev>_PLL<num>_XX where <rev> is PMU corerev and <num> is an arbitrary
  * number to differentiate different PLLs controlled by the same PMU rev.
  */
-/* pllcontrol registers:
- * ndiv_pwrdn, pwrdn_ch<x>, refcomp_pwrdn, dly_ch<x>,
- * p1div, p2div, _bypass_sdmod
- */
-#define PMU1_PLL0_PLLCTL0		0
-#define PMU1_PLL0_PLLCTL1		1
-#define PMU1_PLL0_PLLCTL2		2
-#define PMU1_PLL0_PLLCTL3		3
-#define PMU1_PLL0_PLLCTL4		4
-#define PMU1_PLL0_PLLCTL5		5
 
 /* pmu XtalFreqRatio */
 #define	PMU_XTALFREQ_REG_ILPCTR_MASK	0x00001FFF
@@ -108,80 +98,6 @@
 #define	RES4313_HT_AVAIL_RSRC		14
 #define	RES4313_MACPHY_CLK_AVAIL_RSRC	15
 
-void si_pmu_spuravoid_pllupdate(struct si_pub *sih, u8 spuravoid)
-{
-	u32 tmp = 0;
-	struct si_info *sii = container_of(sih, struct si_info, pub);
-	struct bcma_device *core;
-
-	/* switch to chipc */
-	core = sii->icbus->drv_cc.core;
-
-	switch (ai_get_chip_id(sih)) {
-	case BCM43224_CHIP_ID:
-	case BCM43225_CHIP_ID:
-		if (spuravoid == 1) {
-			bcma_write32(core, CHIPCREGOFFS(pllcontrol_addr),
-				     PMU1_PLL0_PLLCTL0);
-			bcma_write32(core, CHIPCREGOFFS(pllcontrol_data),
-				     0x11500010);
-			bcma_write32(core, CHIPCREGOFFS(pllcontrol_addr),
-				     PMU1_PLL0_PLLCTL1);
-			bcma_write32(core, CHIPCREGOFFS(pllcontrol_data),
-				     0x000C0C06);
-			bcma_write32(core, CHIPCREGOFFS(pllcontrol_addr),
-				     PMU1_PLL0_PLLCTL2);
-			bcma_write32(core, CHIPCREGOFFS(pllcontrol_data),
-				     0x0F600a08);
-			bcma_write32(core, CHIPCREGOFFS(pllcontrol_addr),
-				     PMU1_PLL0_PLLCTL3);
-			bcma_write32(core, CHIPCREGOFFS(pllcontrol_data),
-				     0x00000000);
-			bcma_write32(core, CHIPCREGOFFS(pllcontrol_addr),
-				     PMU1_PLL0_PLLCTL4);
-			bcma_write32(core, CHIPCREGOFFS(pllcontrol_data),
-				     0x2001E920);
-			bcma_write32(core, CHIPCREGOFFS(pllcontrol_addr),
-				     PMU1_PLL0_PLLCTL5);
-			bcma_write32(core, CHIPCREGOFFS(pllcontrol_data),
-				     0x88888815);
-		} else {
-			bcma_write32(core, CHIPCREGOFFS(pllcontrol_addr),
-				     PMU1_PLL0_PLLCTL0);
-			bcma_write32(core, CHIPCREGOFFS(pllcontrol_data),
-				     0x11100010);
-			bcma_write32(core, CHIPCREGOFFS(pllcontrol_addr),
-				     PMU1_PLL0_PLLCTL1);
-			bcma_write32(core, CHIPCREGOFFS(pllcontrol_data),
-				     0x000c0c06);
-			bcma_write32(core, CHIPCREGOFFS(pllcontrol_addr),
-				     PMU1_PLL0_PLLCTL2);
-			bcma_write32(core, CHIPCREGOFFS(pllcontrol_data),
-				     0x03000a08);
-			bcma_write32(core, CHIPCREGOFFS(pllcontrol_addr),
-				     PMU1_PLL0_PLLCTL3);
-			bcma_write32(core, CHIPCREGOFFS(pllcontrol_data),
-				     0x00000000);
-			bcma_write32(core, CHIPCREGOFFS(pllcontrol_addr),
-				     PMU1_PLL0_PLLCTL4);
-			bcma_write32(core, CHIPCREGOFFS(pllcontrol_data),
-				     0x200005c0);
-			bcma_write32(core, CHIPCREGOFFS(pllcontrol_addr),
-				     PMU1_PLL0_PLLCTL5);
-			bcma_write32(core, CHIPCREGOFFS(pllcontrol_data),
-				     0x88888815);
-		}
-		tmp = 1 << 10;
-		break;
-
-	default:
-		/* bail out */
-		return;
-	}
-
-	bcma_set32(core, CHIPCREGOFFS(pmucontrol), tmp);
-}
-
 u16 si_pmu_fast_pwrup_delay(struct si_pub *sih)
 {
 	uint delay = PMU_MAX_TRANSITION_DLY;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pmu.h b/drivers/net/wireless/brcm80211/brcmsmac/pmu.h
index 2f0ad28..f7cff87 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pmu.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pmu.h
@@ -26,7 +26,6 @@ extern u32 si_pmu_chipcontrol(struct si_pub *sih, uint reg, u32 mask, u32 val);
 extern u32 si_pmu_regcontrol(struct si_pub *sih, uint reg, u32 mask, u32 val);
 extern u32 si_pmu_alp_clock(struct si_pub *sih);
 extern void si_pmu_pllupd(struct si_pub *sih);
-extern void si_pmu_spuravoid_pllupdate(struct si_pub *sih, u8 spuravoid);
 extern u32 si_pmu_pllcontrol(struct si_pub *sih, uint reg, u32 mask, u32 val);
 extern u32 si_pmu_measure_alpclk(struct si_pub *sih);
 
-- 
1.7.9.5

