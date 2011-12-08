Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2179 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589Ab1LHXHR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 18:07:17 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 20/23] brcm80211: smac: replace ai_corereg() function
 with ai_cc_reg()
Date: Thu, 8 Dec 2011 15:06:56 -0800
Message-ID: <1323385619-7454-21-git-send-email-frankyl@broadcom.com> (sfid-20111209_000821_676090_1F886FA3)
In-Reply-To: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
References: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The ai_corereg() function is only used in the driver to safely
access the chipcommon core. The function has been renamed to
ai_cc_reg() removing the need to provide a core index parameter.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c  |   36 +++++++------------
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h  |    5 +--
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   16 ++++----
 drivers/net/wireless/brcm80211/brcmsmac/nicpci.c   |   28 ++++++++--------
 .../net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c  |   36 ++++++++++----------
 .../net/wireless/brcm80211/brcmsmac/phy/phy_n.c    |    6 ++--
 drivers/net/wireless/brcm80211/brcmsmac/pmu.c      |   28 ++++++---------
 7 files changed, 68 insertions(+), 87 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index 7aa47b3..d72e993 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -885,8 +885,8 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	w = getintvar(sih, BRCMS_SROM_LEDDC);
 	if (w == 0)
 		w = DEFAULT_GPIOTIMERVAL;
-	ai_corereg(sih, SI_CC_IDX, offsetof(struct chipcregs, gpiotimerval),
-		   ~0, w);
+	ai_cc_reg(sih, offsetof(struct chipcregs, gpiotimerval),
+		  ~0, w);
 
 	if (PCIE(sih))
 		pcicore_attach(sii->pch, SI_DOATTACH);
@@ -898,10 +898,9 @@ static struct si_info *ai_doattach(struct si_info *sii,
 		 */
 		if (ai_get_chiprev(sih) == 0) {
 			SI_MSG("Applying 43224A0 WARs\n");
-			ai_corereg(sih, SI_CC_IDX,
-				   offsetof(struct chipcregs, chipcontrol),
-				   CCTRL43224_GPIO_TOGGLE,
-				   CCTRL43224_GPIO_TOGGLE);
+			ai_cc_reg(sih, offsetof(struct chipcregs, chipcontrol),
+				  CCTRL43224_GPIO_TOGGLE,
+				  CCTRL43224_GPIO_TOGGLE);
 			si_pmu_chipcontrol(sih, 0, CCTRL_43224A0_12MA_LED_DRIVE,
 					   CCTRL_43224A0_12MA_LED_DRIVE);
 		}
@@ -1104,41 +1103,32 @@ void ai_write_wrapperreg(struct si_pub *sih, u32 offset, u32 val)
  * Also, when using pci/pcie, we can optimize away the core switching for pci
  * registers and (on newer pci cores) chipcommon registers.
  */
-uint ai_corereg(struct si_pub *sih, uint coreidx, uint regoff, uint mask,
-		uint val)
+uint ai_cc_reg(struct si_pub *sih, uint regoff, u32 mask, u32 val)
 {
+	struct bcma_device *cc;
 	uint origidx = 0;
-	u32 __iomem *r = NULL;
-	uint w;
+	u32 w;
 	uint intr_val = 0;
 	struct si_info *sii;
 
 	sii = (struct si_info *)sih;
-
-	if (coreidx >= SI_MAXCORES)
-		return 0;
+	cc = sii->icbus->drv_cc.core;
 
 	INTR_OFF(sii, intr_val);
 
 	/* save current core index */
 	origidx = ai_coreidx(&sii->pub);
 
-	/* switch core */
-	r = (u32 __iomem *) ((unsigned char __iomem *)
-		ai_setcoreidx(&sii->pub, coreidx) + regoff);
-
 	/* mask and set */
 	if (mask || val) {
-		w = (R_REG(r) & ~mask) | val;
-		W_REG(r, w);
+		bcma_maskset32(cc, regoff, ~mask, val);
 	}
 
 	/* readback */
-	w = R_REG(r);
+	w = bcma_read32(cc, regoff);
 
 	/* restore core index */
-	if (origidx != coreidx)
-		ai_setcoreidx(&sii->pub, origidx);
+	ai_setcoreidx(&sii->pub, origidx);
 
 	INTR_RESTORE(sii, intr_val);
 
@@ -1664,7 +1654,7 @@ u32 ai_gpiocontrol(struct si_pub *sih, u32 mask, u32 val, u8 priority)
 	uint regoff;
 
 	regoff = offsetof(struct chipcregs, gpiocontrol);
-	return ai_corereg(sih, SI_CC_IDX, regoff, mask, val);
+	return ai_cc_reg(sih, regoff, mask, val);
 }
 
 void ai_chipcontrl_epa4331(struct si_pub *sih, bool on)
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
index 1e93599..7923108 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
@@ -228,8 +228,6 @@ extern bool ai_iscoreup(struct si_pub *sih);
 extern u32 ai_core_cflags(struct si_pub *sih, u32 mask, u32 val);
 extern void ai_core_cflags_wo(struct si_pub *sih, u32 mask, u32 val);
 extern u32 ai_core_sflags(struct si_pub *sih, u32 mask, u32 val);
-extern uint ai_corereg(struct si_pub *sih, uint coreidx, uint regoff, uint mask,
-		       uint val);
 extern void ai_core_reset(struct si_pub *sih, u32 bits, u32 resetbits);
 extern void ai_core_disable(struct si_pub *sih, u32 bits);
 extern int ai_numaddrspaces(struct si_pub *sih);
@@ -242,8 +240,7 @@ extern struct si_pub *ai_attach(struct bcma_bus *pbus);
 extern void ai_detach(struct si_pub *sih);
 extern uint ai_coreid(struct si_pub *sih);
 extern uint ai_corerev(struct si_pub *sih);
-extern uint ai_corereg(struct si_pub *sih, uint coreidx, uint regoff, uint mask,
-		uint val);
+extern uint ai_cc_reg(struct si_pub *sih, uint regoff, u32 mask, u32 val);
 extern void ai_write_wrapperreg(struct si_pub *sih, u32 offset, u32 val);
 extern u32 ai_core_cflags(struct si_pub *sih, u32 mask, u32 val);
 extern u32 ai_core_sflags(struct si_pub *sih, u32 mask, u32 val);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 5db2bdc..7ee86d4a0 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -1709,17 +1709,17 @@ void brcms_b_core_phypll_reset(struct brcms_hardware *wlc_hw)
 {
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
-	ai_corereg(wlc_hw->sih, SI_CC_IDX,
-		   offsetof(struct chipcregs, chipcontrol_addr), ~0, 0);
+	ai_cc_reg(wlc_hw->sih, offsetof(struct chipcregs, chipcontrol_addr),
+		  ~0, 0);
 	udelay(1);
-	ai_corereg(wlc_hw->sih, SI_CC_IDX,
-		   offsetof(struct chipcregs, chipcontrol_data), 0x4, 0);
+	ai_cc_reg(wlc_hw->sih, offsetof(struct chipcregs, chipcontrol_data),
+		  0x4, 0);
 	udelay(1);
-	ai_corereg(wlc_hw->sih, SI_CC_IDX,
-		   offsetof(struct chipcregs, chipcontrol_data), 0x4, 4);
+	ai_cc_reg(wlc_hw->sih, offsetof(struct chipcregs, chipcontrol_data),
+		  0x4, 4);
 	udelay(1);
-	ai_corereg(wlc_hw->sih, SI_CC_IDX,
-		   offsetof(struct chipcregs, chipcontrol_data), 0x4, 0);
+	ai_cc_reg(wlc_hw->sih, offsetof(struct chipcregs, chipcontrol_data),
+		  0x4, 0);
 	udelay(1);
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
index 2e8b5a1..6c3a9f9 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
@@ -530,12 +530,12 @@ static void pcie_clkreq_upd(struct pcicore_info *pi, uint state)
 	case SI_PCIDOWN:
 		/* turn on serdes PLL down */
 		if (ai_get_buscorerev(sih) == 6) {
-			ai_corereg(sih, SI_CC_IDX,
-				   offsetof(struct chipcregs, chipcontrol_addr),
-				   ~0, 0);
-			ai_corereg(sih, SI_CC_IDX,
-				   offsetof(struct chipcregs, chipcontrol_data),
-				   ~0x40, 0);
+			ai_cc_reg(sih,
+				  offsetof(struct chipcregs, chipcontrol_addr),
+				  ~0, 0);
+			ai_cc_reg(sih,
+				  offsetof(struct chipcregs, chipcontrol_data),
+				  ~0x40, 0);
 		} else if (pi->pcie_pr42767) {
 			pcie_clkreq(pi, 1, 1);
 		}
@@ -543,12 +543,12 @@ static void pcie_clkreq_upd(struct pcicore_info *pi, uint state)
 	case SI_PCIUP:
 		/* turn off serdes PLL down */
 		if (ai_get_buscorerev(sih) == 6) {
-			ai_corereg(sih, SI_CC_IDX,
-				   offsetof(struct chipcregs, chipcontrol_addr),
-				   ~0, 0);
-			ai_corereg(sih, SI_CC_IDX,
-				   offsetof(struct chipcregs, chipcontrol_data),
-				   ~0x40, 0x40);
+			ai_cc_reg(sih,
+				  offsetof(struct chipcregs, chipcontrol_addr),
+				  ~0, 0);
+			ai_cc_reg(sih,
+				  offsetof(struct chipcregs, chipcontrol_data),
+				  ~0x40, 0x40);
 		} else if (PCIE_ASPM(sih)) {	/* disable clkreq */
 			pcie_clkreq(pi, 1, 0);
 		}
@@ -666,8 +666,8 @@ static void pcie_war_noplldown(struct pcicore_info *pi)
 	u16 __iomem *reg16;
 
 	/* turn off serdes PLL down */
-	ai_corereg(pi->sih, SI_CC_IDX, offsetof(struct chipcregs, chipcontrol),
-		   CHIPCTRL_4321_PLL_DOWN, CHIPCTRL_4321_PLL_DOWN);
+	ai_cc_reg(pi->sih, offsetof(struct chipcregs, chipcontrol),
+		  CHIPCTRL_4321_PLL_DOWN, CHIPCTRL_4321_PLL_DOWN);
 
 	/* clear srom shadow backdoor */
 	reg16 = &pcieregs->sprom[SRSH_BD_OFFSET];
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
index 51719b2..21418c7 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -2905,29 +2905,29 @@ void wlc_lcnphy_epa_switch(struct brcms_phy *pi, bool mode)
 				mod_phy_reg(pi, 0x44c, (0x1 << 2), (1) << 2);
 
 			}
-			ai_corereg(pi->sh->sih, SI_CC_IDX,
-				   offsetof(struct chipcregs, gpiocontrol),
-				   ~0x0, 0x0);
-			ai_corereg(pi->sh->sih, SI_CC_IDX,
-				   offsetof(struct chipcregs, gpioout), 0x40,
-				   0x40);
-			ai_corereg(pi->sh->sih, SI_CC_IDX,
-				   offsetof(struct chipcregs, gpioouten), 0x40,
-				   0x40);
+			ai_cc_reg(pi->sh->sih,
+				  offsetof(struct chipcregs, gpiocontrol),
+				  ~0x0, 0x0);
+			ai_cc_reg(pi->sh->sih,
+				  offsetof(struct chipcregs, gpioout),
+				  0x40, 0x40);
+			ai_cc_reg(pi->sh->sih,
+				  offsetof(struct chipcregs, gpioouten),
+				  0x40, 0x40);
 		} else {
 			mod_phy_reg(pi, 0x44c, (0x1 << 2), (0) << 2);
 
 			mod_phy_reg(pi, 0x44d, (0x1 << 2), (0) << 2);
 
-			ai_corereg(pi->sh->sih, SI_CC_IDX,
-				   offsetof(struct chipcregs, gpioout), 0x40,
-				   0x00);
-			ai_corereg(pi->sh->sih, SI_CC_IDX,
-				   offsetof(struct chipcregs, gpioouten), 0x40,
-				   0x0);
-			ai_corereg(pi->sh->sih, SI_CC_IDX,
-				   offsetof(struct chipcregs, gpiocontrol),
-				   ~0x0, 0x40);
+			ai_cc_reg(pi->sh->sih,
+				  offsetof(struct chipcregs, gpioout),
+				  0x40, 0x00);
+			ai_cc_reg(pi->sh->sih,
+				  offsetof(struct chipcregs, gpioouten),
+				  0x40, 0x0);
+			ai_cc_reg(pi->sh->sih,
+				  offsetof(struct chipcregs, gpiocontrol),
+				  ~0x0, 0x40);
 		}
 	}
 }
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
index 7a20919..e0237e4 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
@@ -19461,9 +19461,9 @@ void wlc_phy_init_nphy(struct brcms_phy *pi)
 	     (pi->sh->chippkg == BCM4718_PKG_ID))) {
 		if ((pi->sh->boardflags & BFL_EXTLNA) &&
 		    (CHSPEC_IS2G(pi->radio_chanspec)))
-			ai_corereg(pi->sh->sih, SI_CC_IDX,
-				   offsetof(struct chipcregs, chipcontrol),
-				   0x40, 0x40);
+			ai_cc_reg(pi->sh->sih,
+				  offsetof(struct chipcregs, chipcontrol),
+				  0x40, 0x40);
 	}
 
 	if ((pi->nphy_gband_spurwar2_en) && CHSPEC_IS2G(pi->radio_chanspec) &&
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pmu.c b/drivers/net/wireless/brcm80211/brcmsmac/pmu.c
index d4e909a..ba319f3 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pmu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pmu.c
@@ -236,38 +236,32 @@ void si_pmu_sprom_enable(struct si_pub *sih, bool enable)
 /* Read/write a chipcontrol reg */
 u32 si_pmu_chipcontrol(struct si_pub *sih, uint reg, u32 mask, u32 val)
 {
-	ai_corereg(sih, SI_CC_IDX, offsetof(struct chipcregs, chipcontrol_addr),
-		   ~0, reg);
-	return ai_corereg(sih, SI_CC_IDX,
-			  offsetof(struct chipcregs, chipcontrol_data), mask,
-			  val);
+	ai_cc_reg(sih, offsetof(struct chipcregs, chipcontrol_addr), ~0, reg);
+	return ai_cc_reg(sih, offsetof(struct chipcregs, chipcontrol_data),
+			 mask, val);
 }
 
 /* Read/write a regcontrol reg */
 u32 si_pmu_regcontrol(struct si_pub *sih, uint reg, u32 mask, u32 val)
 {
-	ai_corereg(sih, SI_CC_IDX, offsetof(struct chipcregs, regcontrol_addr),
-		   ~0, reg);
-	return ai_corereg(sih, SI_CC_IDX,
-			  offsetof(struct chipcregs, regcontrol_data), mask,
-			  val);
+	ai_cc_reg(sih, offsetof(struct chipcregs, regcontrol_addr), ~0, reg);
+	return ai_cc_reg(sih, offsetof(struct chipcregs, regcontrol_data),
+			 mask, val);
 }
 
 /* Read/write a pllcontrol reg */
 u32 si_pmu_pllcontrol(struct si_pub *sih, uint reg, u32 mask, u32 val)
 {
-	ai_corereg(sih, SI_CC_IDX, offsetof(struct chipcregs, pllcontrol_addr),
-		   ~0, reg);
-	return ai_corereg(sih, SI_CC_IDX,
-			  offsetof(struct chipcregs, pllcontrol_data), mask,
-			  val);
+	ai_cc_reg(sih, offsetof(struct chipcregs, pllcontrol_addr), ~0, reg);
+	return ai_cc_reg(sih, offsetof(struct chipcregs, pllcontrol_data),
+			 mask, val);
 }
 
 /* PMU PLL update */
 void si_pmu_pllupd(struct si_pub *sih)
 {
-	ai_corereg(sih, SI_CC_IDX, offsetof(struct chipcregs, pmucontrol),
-		   PCTL_PLL_PLLCTL_UPD, PCTL_PLL_PLLCTL_UPD);
+	ai_cc_reg(sih, offsetof(struct chipcregs, pmucontrol),
+		  PCTL_PLL_PLLCTL_UPD, PCTL_PLL_PLLCTL_UPD);
 }
 
 /* query alp/xtal clock frequency */
-- 
1.7.5.4


