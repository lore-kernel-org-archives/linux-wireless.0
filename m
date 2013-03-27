Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:37193 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660Ab3C0Q0T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 12:26:19 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: arend@broadcom.com, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] brcmsmac: remove some pmu functions and use the bcma equivalents
Date: Wed, 27 Mar 2013 17:26:05 +0100
Message-Id: <1364401565-30423-1-git-send-email-hauke@hauke-m.de> (sfid-20130327_172629_159309_CB1323BB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This removes the following functions:
si_pmu_chipcontrol() => bcma_chipco_chipctl_maskset()
si_pmu_regcontrol() => bcma_chipco_regctl_maskset()
si_pmu_pllcontrol() => bcma_chipco_pll_maskset()
si_pmu_pllupd() => bcma_cc_set32()
si_pmu_alp_clock() => bcma_chipco_get_alp_clock()

This also removed the sih member from struct shared_phy.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---

This depends on "bcma: preparation for brcmsmac using more bcma functions"

 .../net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c  |   40 ++++++---------
 .../net/wireless/brcm80211/brcmsmac/phy/phy_int.h  |    1 -
 .../net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c  |   35 ++++++++-----
 .../net/wireless/brcm80211/brcmsmac/phy/phy_n.c    |   14 +++--
 drivers/net/wireless/brcm80211/brcmsmac/pmu.c      |   54 --------------------
 drivers/net/wireless/brcm80211/brcmsmac/pmu.h      |    6 ---
 6 files changed, 43 insertions(+), 107 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
index 91937c5..b0fd807 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -198,8 +198,6 @@ u16 read_radio_reg(struct brcms_phy *pi, u16 addr)
 
 void write_radio_reg(struct brcms_phy *pi, u16 addr, u16 val)
 {
-	struct si_info *sii = container_of(pi->sh->sih, struct si_info, pub);
-
 	if ((D11REV_GE(pi->sh->corerev, 24)) ||
 	    (D11REV_IS(pi->sh->corerev, 22)
 	     && (pi->pubpi.phy_type != PHY_TYPE_SSN))) {
@@ -211,7 +209,7 @@ void write_radio_reg(struct brcms_phy *pi, u16 addr, u16 val)
 		bcma_write16(pi->d11core, D11REGOFFS(phy4wdatalo), val);
 	}
 
-	if ((sii->icbus->hosttype == BCMA_HOSTTYPE_PCI) &&
+	if ((pi->d11core->bus->hosttype == BCMA_HOSTTYPE_PCI) &&
 	    (++pi->phy_wreg >= pi->phy_wreg_limit)) {
 		(void)bcma_read32(pi->d11core, D11REGOFFS(maccontrol));
 		pi->phy_wreg = 0;
@@ -297,10 +295,8 @@ void write_phy_reg(struct brcms_phy *pi, u16 addr, u16 val)
 	if (addr == 0x72)
 		(void)bcma_read16(pi->d11core, D11REGOFFS(phyregdata));
 #else
-	struct si_info *sii = container_of(pi->sh->sih, struct si_info, pub);
-
 	bcma_write32(pi->d11core, D11REGOFFS(phyregaddr), addr | (val << 16));
-	if ((sii->icbus->hosttype == BCMA_HOSTTYPE_PCI) &&
+	if ((pi->d11core->bus->hosttype == BCMA_HOSTTYPE_PCI) &&
 	    (++pi->phy_wreg >= pi->phy_wreg_limit)) {
 		pi->phy_wreg = 0;
 		(void)bcma_read16(pi->d11core, D11REGOFFS(phyversion));
@@ -374,7 +370,6 @@ struct shared_phy *wlc_phy_shared_attach(struct shared_phy_params *shp)
 	if (sh == NULL)
 		return NULL;
 
-	sh->sih = shp->sih;
 	sh->physhim = shp->physhim;
 	sh->unit = shp->unit;
 	sh->corerev = shp->corerev;
@@ -2911,29 +2906,24 @@ void wlc_lcnphy_epa_switch(struct brcms_phy *pi, bool mode)
 				mod_phy_reg(pi, 0x44c, (0x1 << 2), (1) << 2);
 
 			}
-			ai_cc_reg(pi->sh->sih,
-				  offsetof(struct chipcregs, gpiocontrol),
-				  ~0x0, 0x0);
-			ai_cc_reg(pi->sh->sih,
-				  offsetof(struct chipcregs, gpioout),
-				  0x40, 0x40);
-			ai_cc_reg(pi->sh->sih,
-				  offsetof(struct chipcregs, gpioouten),
-				  0x40, 0x40);
+
+			bcma_chipco_gpio_control(&pi->d11core->bus->drv_cc,
+						 0x0, 0x0);
+			bcma_chipco_gpio_out(&pi->d11core->bus->drv_cc,
+					     ~0x40, 0x40);
+			bcma_chipco_gpio_outen(&pi->d11core->bus->drv_cc,
+					       ~0x40, 0x40);
 		} else {
 			mod_phy_reg(pi, 0x44c, (0x1 << 2), (0) << 2);
 
 			mod_phy_reg(pi, 0x44d, (0x1 << 2), (0) << 2);
 
-			ai_cc_reg(pi->sh->sih,
-				  offsetof(struct chipcregs, gpioout),
-				  0x40, 0x00);
-			ai_cc_reg(pi->sh->sih,
-				  offsetof(struct chipcregs, gpioouten),
-				  0x40, 0x0);
-			ai_cc_reg(pi->sh->sih,
-				  offsetof(struct chipcregs, gpiocontrol),
-				  ~0x0, 0x40);
+			bcma_chipco_gpio_out(&pi->d11core->bus->drv_cc,
+					     ~0x40, 0x00);
+			bcma_chipco_gpio_outen(&pi->d11core->bus->drv_cc,
+					       ~0x40, 0x00);
+			bcma_chipco_gpio_control(&pi->d11core->bus->drv_cc,
+						 0x0, 0x40);
 		}
 	}
 }
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_int.h b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_int.h
index af00e2c..1dc767c 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_int.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_int.h
@@ -488,7 +488,6 @@ struct lcnphy_cal_results {
 struct shared_phy {
 	struct brcms_phy *phy_head;
 	uint unit;
-	struct si_pub *sih;
 	struct phy_shim_info *physhim;
 	uint corerev;
 	u32 machwcap;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
index 21a8242..427b0f6 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -1643,11 +1643,15 @@ wlc_lcnphy_set_chanspec_tweaks(struct brcms_phy *pi, u16 chanspec)
 	if (channel == 1 || channel == 2 || channel == 3 ||
 	    channel == 4 || channel == 9 ||
 	    channel == 10 || channel == 11 || channel == 12) {
-		si_pmu_pllcontrol(pi->sh->sih, 0x2, 0xffffffff, 0x03000c04);
-		si_pmu_pllcontrol(pi->sh->sih, 0x3, 0xffffff, 0x0);
-		si_pmu_pllcontrol(pi->sh->sih, 0x4, 0xffffffff, 0x200005c0);
-
-		si_pmu_pllupd(pi->sh->sih);
+		bcma_chipco_pll_write(&pi->d11core->bus->drv_cc, 0x2,
+				      0x03000c04);
+		bcma_chipco_pll_maskset(&pi->d11core->bus->drv_cc, 0x3,
+					~0x00ffffff, 0x0);
+		bcma_chipco_pll_write(&pi->d11core->bus->drv_cc, 0x4,
+				      0x200005c0);
+
+		bcma_cc_set32(&pi->d11core->bus->drv_cc, BCMA_CC_PMU_CTL,
+			      BCMA_CC_PMU_CTL_PLL_UPD);
 		write_phy_reg(pi, 0x942, 0);
 		wlc_lcnphy_txrx_spur_avoidance_mode(pi, false);
 		pi_lcn->lcnphy_spurmod = false;
@@ -1655,11 +1659,15 @@ wlc_lcnphy_set_chanspec_tweaks(struct brcms_phy *pi, u16 chanspec)
 
 		write_phy_reg(pi, 0x425, 0x5907);
 	} else {
-		si_pmu_pllcontrol(pi->sh->sih, 0x2, 0xffffffff, 0x03140c04);
-		si_pmu_pllcontrol(pi->sh->sih, 0x3, 0xffffff, 0x333333);
-		si_pmu_pllcontrol(pi->sh->sih, 0x4, 0xffffffff, 0x202c2820);
-
-		si_pmu_pllupd(pi->sh->sih);
+		bcma_chipco_pll_write(&pi->d11core->bus->drv_cc, 0x2,
+				      0x03140c04);
+		bcma_chipco_pll_maskset(&pi->d11core->bus->drv_cc, 0x3,
+					~0x00ffffff, 0x333333);
+		bcma_chipco_pll_write(&pi->d11core->bus->drv_cc, 0x4,
+				      0x202c2820);
+
+		bcma_cc_set32(&pi->d11core->bus->drv_cc, BCMA_CC_PMU_CTL,
+			      BCMA_CC_PMU_CTL_PLL_UPD);
 		write_phy_reg(pi, 0x942, 0);
 		wlc_lcnphy_txrx_spur_avoidance_mode(pi, true);
 
@@ -4864,9 +4872,10 @@ void wlc_phy_init_lcnphy(struct brcms_phy *pi)
 
 	wlc_phy_chanspec_set((struct brcms_phy_pub *) pi, pi->radio_chanspec);
 
-	si_pmu_regcontrol(pi->sh->sih, 0, 0xf, 0x9);
+	bcma_chipco_regctl_maskset(&pi->d11core->bus->drv_cc, 0, ~0xf, 0x9);
 
-	si_pmu_chipcontrol(pi->sh->sih, 0, 0xffffffff, 0x03CDDDDD);
+	bcma_chipco_chipctl_maskset(&pi->d11core->bus->drv_cc, 0, 0x0,
+				    0x03CDDDDD);
 
 	if ((pi->sh->boardflags & BFL_FEM)
 	    && wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi))
@@ -5078,7 +5087,7 @@ bool wlc_phy_attach_lcnphy(struct brcms_phy *pi)
 		pi->hwpwrctrl_capable = true;
 	}
 
-	pi->xtalfreq = si_pmu_alp_clock(pi->sh->sih);
+	pi->xtalfreq = bcma_chipco_get_alp_clock(&pi->d11core->bus->drv_cc);
 	pi_lcn->lcnphy_papd_rxGnCtrl_init = 0;
 
 	pi->pi_fptr.init = wlc_phy_init_lcnphy;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
index 65db9b7..3e9f5b2 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
@@ -19321,14 +19321,13 @@ void wlc_phy_init_nphy(struct brcms_phy *pi)
 	     (pi->sh->chippkg == BCMA_PKG_ID_BCM4718))) {
 		if ((pi->sh->boardflags & BFL_EXTLNA) &&
 		    (CHSPEC_IS2G(pi->radio_chanspec)))
-			ai_cc_reg(pi->sh->sih,
-				  offsetof(struct chipcregs, chipcontrol),
-				  0x40, 0x40);
+			bcma_cc_set32(&pi->d11core->bus->drv_cc,
+				      BCMA_CC_CHIPCTL, 0x40);
 	}
 
 	if ((!PHY_IPA(pi)) && (pi->sh->chip == BCMA_CHIP_ID_BCM5357))
-		si_pmu_chipcontrol(pi->sh->sih, 1, CCTRL5357_EXTPA,
-				   CCTRL5357_EXTPA);
+		bcma_chipco_chipctl_maskset(&pi->d11core->bus->drv_cc, 1,
+					    ~CCTRL5357_EXTPA, CCTRL5357_EXTPA);
 
 	if ((pi->nphy_gband_spurwar2_en) && CHSPEC_IS2G(pi->radio_chanspec) &&
 	    CHSPEC_IS40(pi->radio_chanspec)) {
@@ -21133,7 +21132,6 @@ wlc_phy_chanspec_nphy_setup(struct brcms_phy *pi, u16 chanspec,
 			    const struct nphy_sfo_cfg *ci)
 {
 	u16 val;
-	struct si_info *sii = container_of(pi->sh->sih, struct si_info, pub);
 
 	val = read_phy_reg(pi, 0x09) & NPHY_BandControl_currentBand;
 	if (CHSPEC_IS5G(chanspec) && !val) {
@@ -21221,11 +21219,11 @@ wlc_phy_chanspec_nphy_setup(struct brcms_phy *pi, u16 chanspec,
 
 		if ((pi->sh->chip == BCMA_CHIP_ID_BCM4716) ||
 		    (pi->sh->chip == BCMA_CHIP_ID_BCM43225)) {
-			bcma_pmu_spuravoid_pllupdate(&sii->icbus->drv_cc,
+			bcma_pmu_spuravoid_pllupdate(&pi->d11core->bus->drv_cc,
 						     spuravoid);
 		} else {
 			wlapi_bmac_core_phypll_ctl(pi->sh->physhim, false);
-			bcma_pmu_spuravoid_pllupdate(&sii->icbus->drv_cc,
+			bcma_pmu_spuravoid_pllupdate(&pi->d11core->bus->drv_cc,
 						     spuravoid);
 			wlapi_bmac_core_phypll_ctl(pi->sh->physhim, true);
 		}
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pmu.c b/drivers/net/wireless/brcm80211/brcmsmac/pmu.c
index 7e9df56..71b8038 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pmu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pmu.c
@@ -115,60 +115,6 @@ u16 si_pmu_fast_pwrup_delay(struct si_pub *sih)
 	return (u16) delay;
 }
 
-/* Read/write a chipcontrol reg */
-u32 si_pmu_chipcontrol(struct si_pub *sih, uint reg, u32 mask, u32 val)
-{
-	ai_cc_reg(sih, offsetof(struct chipcregs, chipcontrol_addr), ~0, reg);
-	return ai_cc_reg(sih, offsetof(struct chipcregs, chipcontrol_data),
-			 mask, val);
-}
-
-/* Read/write a regcontrol reg */
-u32 si_pmu_regcontrol(struct si_pub *sih, uint reg, u32 mask, u32 val)
-{
-	ai_cc_reg(sih, offsetof(struct chipcregs, regcontrol_addr), ~0, reg);
-	return ai_cc_reg(sih, offsetof(struct chipcregs, regcontrol_data),
-			 mask, val);
-}
-
-/* Read/write a pllcontrol reg */
-u32 si_pmu_pllcontrol(struct si_pub *sih, uint reg, u32 mask, u32 val)
-{
-	ai_cc_reg(sih, offsetof(struct chipcregs, pllcontrol_addr), ~0, reg);
-	return ai_cc_reg(sih, offsetof(struct chipcregs, pllcontrol_data),
-			 mask, val);
-}
-
-/* PMU PLL update */
-void si_pmu_pllupd(struct si_pub *sih)
-{
-	ai_cc_reg(sih, offsetof(struct chipcregs, pmucontrol),
-		  PCTL_PLL_PLLCTL_UPD, PCTL_PLL_PLLCTL_UPD);
-}
-
-/* query alp/xtal clock frequency */
-u32 si_pmu_alp_clock(struct si_pub *sih)
-{
-	u32 clock = ALP_CLOCK;
-
-	/* bail out with default */
-	if (!(ai_get_cccaps(sih) & CC_CAP_PMU))
-		return clock;
-
-	switch (ai_get_chip_id(sih)) {
-	case BCMA_CHIP_ID_BCM43224:
-	case BCMA_CHIP_ID_BCM43225:
-	case BCMA_CHIP_ID_BCM4313:
-		/* always 20Mhz */
-		clock = 20000 * 1000;
-		break;
-	default:
-		break;
-	}
-
-	return clock;
-}
-
 u32 si_pmu_measure_alpclk(struct si_pub *sih)
 {
 	struct si_info *sii = container_of(sih, struct si_info, pub);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pmu.h b/drivers/net/wireless/brcm80211/brcmsmac/pmu.h
index f7cff87..20e2012 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pmu.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pmu.h
@@ -21,12 +21,6 @@
 #include "types.h"
 
 extern u16 si_pmu_fast_pwrup_delay(struct si_pub *sih);
-extern void si_pmu_sprom_enable(struct si_pub *sih, bool enable);
-extern u32 si_pmu_chipcontrol(struct si_pub *sih, uint reg, u32 mask, u32 val);
-extern u32 si_pmu_regcontrol(struct si_pub *sih, uint reg, u32 mask, u32 val);
-extern u32 si_pmu_alp_clock(struct si_pub *sih);
-extern void si_pmu_pllupd(struct si_pub *sih);
-extern u32 si_pmu_pllcontrol(struct si_pub *sih, uint reg, u32 mask, u32 val);
 extern u32 si_pmu_measure_alpclk(struct si_pub *sih);
 
 #endif /* _BRCM_PMU_H_ */
-- 
1.7.10.4

