Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2171 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638Ab1LHXHR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 18:07:17 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 22/23] brcm80211: smac: use bcma core control functions
Date: Thu, 8 Dec 2011 15:06:58 -0800
Message-ID: <1323385619-7454-23-git-send-email-frankyl@broadcom.com> (sfid-20111209_000819_932102_CDB6693D)
In-Reply-To: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
References: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

BCMA provides functions to control the state of the cores so
using that and remove similar implementation from the driver.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c  |  102 --------------------
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h  |    6 +-
 drivers/net/wireless/brcm80211/brcmsmac/dma.c      |    3 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   72 ++++++++------
 .../net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c  |    4 +-
 5 files changed, 47 insertions(+), 140 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index fa8067b..a68f24a 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -535,36 +535,6 @@ uint ai_corerev(struct si_pub *sih)
 	return (cib & CIB_REV_MASK) >> CIB_REV_SHIFT;
 }
 
-bool ai_iscoreup(struct si_pub *sih)
-{
-	struct si_info *sii;
-	struct aidmp *ai;
-
-	sii = (struct si_info *)sih;
-	ai = sii->curwrap;
-
-	return (((R_REG(&ai->ioctrl) & (SICF_FGC | SICF_CLOCK_EN)) ==
-		 SICF_CLOCK_EN)
-		&& ((R_REG(&ai->resetctrl) & AIRC_RESET) == 0));
-}
-
-u32 ai_core_cflags(struct si_pub *sih, u32 mask, u32 val)
-{
-	struct si_info *sii;
-	struct aidmp *ai;
-	u32 w;
-
-	sii = (struct si_info *)sih;
-	ai = sii->curwrap;
-
-	if (mask || val) {
-		w = ((R_REG(&ai->ioctrl) & ~mask) | val);
-		W_REG(&ai->ioctrl, w);
-	}
-
-	return R_REG(&ai->ioctrl);
-}
-
 /* return true if PCIE capability exists in the pci config space */
 static bool ai_ispcie(struct si_info *sii)
 {
@@ -587,23 +557,6 @@ static bool ai_buscore_prep(struct si_info *sii)
 	return true;
 }
 
-u32 ai_core_sflags(struct si_pub *sih, u32 mask, u32 val)
-{
-	struct si_info *sii;
-	struct aidmp *ai;
-	u32 w;
-
-	sii = (struct si_info *)sih;
-	ai = sii->curwrap;
-
-	if (mask || val) {
-		w = ((R_REG(&ai->iostatus) & ~mask) | val);
-		W_REG(&ai->iostatus, w);
-	}
-
-	return R_REG(&ai->iostatus);
-}
-
 static bool
 ai_buscore_setup(struct si_info *sii, u32 savewin, uint *origidx)
 {
@@ -1037,61 +990,6 @@ uint ai_cc_reg(struct si_pub *sih, uint regoff, u32 mask, u32 val)
 	return w;
 }
 
-void ai_core_disable(struct si_pub *sih, u32 bits)
-{
-	struct si_info *sii;
-	u32 dummy;
-	struct aidmp *ai;
-
-	sii = (struct si_info *)sih;
-
-	ai = sii->curwrap;
-
-	/* if core is already in reset, just return */
-	if (R_REG(&ai->resetctrl) & AIRC_RESET)
-		return;
-
-	W_REG(&ai->ioctrl, bits);
-	dummy = R_REG(&ai->ioctrl);
-	udelay(10);
-
-	W_REG(&ai->resetctrl, AIRC_RESET);
-	udelay(1);
-}
-
-/* reset and re-enable a core
- * inputs:
- * bits - core specific bits that are set during and after reset sequence
- * resetbits - core specific bits that are set only during reset sequence
- */
-void ai_core_reset(struct si_pub *sih, u32 bits, u32 resetbits)
-{
-	struct si_info *sii;
-	struct aidmp *ai;
-	u32 dummy;
-
-	sii = (struct si_info *)sih;
-	ai = sii->curwrap;
-
-	/*
-	 * Must do the disable sequence first to work
-	 * for arbitrary current core state.
-	 */
-	ai_core_disable(sih, (bits | resetbits));
-
-	/*
-	 * Now do the initialization sequence.
-	 */
-	W_REG(&ai->ioctrl, (bits | SICF_FGC | SICF_CLOCK_EN));
-	dummy = R_REG(&ai->ioctrl);
-	W_REG(&ai->resetctrl, 0);
-	udelay(1);
-
-	W_REG(&ai->ioctrl, (bits | SICF_CLOCK_EN));
-	dummy = R_REG(&ai->ioctrl);
-	udelay(1);
-}
-
 /* return the slow clock source - LPO, XTAL, or PCI */
 static uint ai_slowclk_src(struct si_info *sii)
 {
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
index 40d0070..67b378f 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
@@ -221,11 +221,7 @@ struct si_info {
 /* AMBA Interconnect exported externs */
 extern uint ai_coreidx(struct si_pub *sih);
 extern uint ai_corerev(struct si_pub *sih);
-extern bool ai_iscoreup(struct si_pub *sih);
-extern u32 ai_core_cflags(struct si_pub *sih, u32 mask, u32 val);
-extern u32 ai_core_sflags(struct si_pub *sih, u32 mask, u32 val);
-extern void ai_core_reset(struct si_pub *sih, u32 bits, u32 resetbits);
-extern void ai_core_disable(struct si_pub *sih, u32 bits);
+extern u32 ai_core_cflags(struct bcma_device *core, u32 mask, u32 val);
 
 /* === exported functions === */
 extern struct si_pub *ai_attach(struct bcma_bus *pbus);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/dma.c b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
index dfcd9cf..dab04bb 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/dma.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
@@ -581,7 +581,8 @@ struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 	di->msg_level = msg_level ? msg_level : &dma_msg_level;
 
 
-	di->dma64 = ((ai_core_sflags(sih, 0, 0) & SISF_DMA64) == SISF_DMA64);
+	di->dma64 =
+		((bcma_aread32(d11core, BCMA_IOST) & SISF_DMA64) == SISF_DMA64);
 
 	/* init dma reg info */
 	di->d11core = d11core;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 7ee86d4a0..d974809 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -738,6 +738,14 @@ static void brcms_c_ucode_bsinit(struct brcms_hardware *wlc_hw)
 	}
 }
 
+static void brcms_b_core_ioctl(struct brcms_hardware *wlc_hw, u32 m, u32 v)
+{
+	struct bcma_device *core = wlc_hw->d11core;
+	u32 ioctl = bcma_aread32(core, BCMA_IOCTL) & ~m;
+
+	bcma_awrite32(core, BCMA_IOCTL, ioctl | v);
+}
+
 static void brcms_b_core_phy_clk(struct brcms_hardware *wlc_hw, bool clk)
 {
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d: clk %d\n", wlc_hw->unit, clk);
@@ -746,17 +754,17 @@ static void brcms_b_core_phy_clk(struct brcms_hardware *wlc_hw, bool clk)
 
 	if (OFF == clk) {	/* clear gmode bit, put phy into reset */
 
-		ai_core_cflags(wlc_hw->sih, (SICF_PRST | SICF_FGC | SICF_GMODE),
-			       (SICF_PRST | SICF_FGC));
+		brcms_b_core_ioctl(wlc_hw, (SICF_PRST | SICF_FGC | SICF_GMODE),
+				   (SICF_PRST | SICF_FGC));
 		udelay(1);
-		ai_core_cflags(wlc_hw->sih, (SICF_PRST | SICF_FGC), SICF_PRST);
+		brcms_b_core_ioctl(wlc_hw, (SICF_PRST | SICF_FGC), SICF_PRST);
 		udelay(1);
 
 	} else {		/* take phy out of reset */
 
-		ai_core_cflags(wlc_hw->sih, (SICF_PRST | SICF_FGC), SICF_FGC);
+		brcms_b_core_ioctl(wlc_hw, (SICF_PRST | SICF_FGC), SICF_FGC);
 		udelay(1);
-		ai_core_cflags(wlc_hw->sih, (SICF_FGC), 0);
+		brcms_b_core_ioctl(wlc_hw, SICF_FGC, 0);
 		udelay(1);
 
 	}
@@ -777,9 +785,14 @@ static void brcms_c_setxband(struct brcms_hardware *wlc_hw, uint bandunit)
 	wlc_hw->wlc->band = wlc_hw->wlc->bandstate[bandunit];
 
 	/* set gmode core flag */
-	if (wlc_hw->sbclk && !wlc_hw->noreset)
-		ai_core_cflags(wlc_hw->sih, SICF_GMODE,
-			       ((bandunit == 0) ? SICF_GMODE : 0));
+	if (wlc_hw->sbclk && !wlc_hw->noreset) {
+		u32 gmode = 0;
+
+		if (bandunit == 0)
+			gmode = SICF_GMODE;
+
+		brcms_b_core_ioctl(wlc_hw, SICF_GMODE, gmode);
+	}
 }
 
 /* switch to new band but leave it inactive */
@@ -1257,7 +1270,7 @@ static void brcms_b_clkctl_clk(struct brcms_hardware *wlc_hw, uint mode)
 
 		/* check fast clock is available (if core is not in reset) */
 		if (wlc_hw->forcefastclk && wlc_hw->clk)
-			WARN_ON(!(ai_core_sflags(wlc_hw->sih, 0, 0) &
+			WARN_ON(!(bcma_aread32(wlc_hw->d11core, BCMA_IOST) &
 				  SISF_FCLKA));
 
 		/*
@@ -1733,18 +1746,18 @@ void brcms_b_phyclk_fgc(struct brcms_hardware *wlc_hw, bool clk)
 		return;
 
 	if (ON == clk)
-		ai_core_cflags(wlc_hw->sih, SICF_FGC, SICF_FGC);
+		brcms_b_core_ioctl(wlc_hw, SICF_FGC, SICF_FGC);
 	else
-		ai_core_cflags(wlc_hw->sih, SICF_FGC, 0);
+		brcms_b_core_ioctl(wlc_hw, SICF_FGC, 0);
 
 }
 
 void brcms_b_macphyclk_set(struct brcms_hardware *wlc_hw, bool clk)
 {
 	if (ON == clk)
-		ai_core_cflags(wlc_hw->sih, SICF_MPCLKE, SICF_MPCLKE);
+		brcms_b_core_ioctl(wlc_hw, SICF_MPCLKE, SICF_MPCLKE);
 	else
-		ai_core_cflags(wlc_hw->sih, SICF_MPCLKE, 0);
+		brcms_b_core_ioctl(wlc_hw, SICF_MPCLKE, 0);
 }
 
 void brcms_b_phy_reset(struct brcms_hardware *wlc_hw)
@@ -1764,7 +1777,7 @@ void brcms_b_phy_reset(struct brcms_hardware *wlc_hw)
 	if (BRCMS_ISNPHY(wlc_hw->band) && NREV_GE(wlc_hw->band->phyrev, 3) &&
 	    NREV_LE(wlc_hw->band->phyrev, 4)) {
 		/* Set the PHY bandwidth */
-		ai_core_cflags(wlc_hw->sih, SICF_BWMASK, phy_bw_clkbits);
+		brcms_b_core_ioctl(wlc_hw, SICF_BWMASK, phy_bw_clkbits);
 
 		udelay(1);
 
@@ -1772,13 +1785,13 @@ void brcms_b_phy_reset(struct brcms_hardware *wlc_hw)
 		brcms_b_core_phypll_reset(wlc_hw);
 
 		/* reset the PHY */
-		ai_core_cflags(wlc_hw->sih, (SICF_PRST | SICF_PCLKE),
-			       (SICF_PRST | SICF_PCLKE));
+		brcms_b_core_ioctl(wlc_hw, (SICF_PRST | SICF_PCLKE),
+				   (SICF_PRST | SICF_PCLKE));
 		phy_in_reset = true;
 	} else {
-		ai_core_cflags(wlc_hw->sih,
-			       (SICF_PRST | SICF_PCLKE | SICF_BWMASK),
-			       (SICF_PRST | SICF_PCLKE | phy_bw_clkbits));
+		brcms_b_core_ioctl(wlc_hw,
+				   (SICF_PRST | SICF_PCLKE | SICF_BWMASK),
+				   (SICF_PRST | SICF_PCLKE | phy_bw_clkbits));
 	}
 
 	udelay(2);
@@ -1795,8 +1808,8 @@ static void brcms_b_setband(struct brcms_hardware *wlc_hw, uint bandunit,
 	u32 macintmask;
 
 	/* Enable the d11 core before accessing it */
-	if (!ai_iscoreup(wlc_hw->sih)) {
-		ai_core_reset(wlc_hw->sih, 0, 0);
+	if (!bcma_core_is_enabled(wlc_hw->d11core)) {
+		bcma_core_enable(wlc_hw->d11core, 0);
 		brcms_c_mctrl_reset(wlc_hw);
 	}
 
@@ -1923,7 +1936,7 @@ static void brcms_b_xtal(struct brcms_hardware *wlc_hw, bool want)
 static bool brcms_b_radio_read_hwdisabled(struct brcms_hardware *wlc_hw)
 {
 	bool v, clk, xtal;
-	u32 resetbits = 0, flags = 0;
+	u32 flags = 0;
 
 	xtal = wlc_hw->sbclk;
 	if (!xtal)
@@ -1947,7 +1960,7 @@ static bool brcms_b_radio_read_hwdisabled(struct brcms_hardware *wlc_hw)
 		    (ai_get_chip_id(wlc_hw->sih) == BCM43225_CHIP_ID))
 			(void)ai_setcore(wlc_hw->sih, D11_CORE_ID, 0);
 
-		ai_core_reset(wlc_hw->sih, flags, resetbits);
+		bcma_core_enable(wlc_hw->d11core, flags);
 		brcms_c_mctrl_reset(wlc_hw);
 	}
 
@@ -1956,7 +1969,7 @@ static bool brcms_b_radio_read_hwdisabled(struct brcms_hardware *wlc_hw)
 
 	/* put core back into reset */
 	if (!clk)
-		ai_core_disable(wlc_hw->sih, 0);
+		bcma_core_disable(wlc_hw->d11core, 0);
 
 	if (!xtal)
 		brcms_b_xtal(wlc_hw, OFF);
@@ -1982,7 +1995,6 @@ void brcms_b_corereset(struct brcms_hardware *wlc_hw, u32 flags)
 {
 	uint i;
 	bool fastclk;
-	u32 resetbits = 0;
 
 	if (flags == BRCMS_USE_COREFLAGS)
 		flags = (wlc_hw->band->pi ? wlc_hw->band->core_flags : 0);
@@ -1995,7 +2007,7 @@ void brcms_b_corereset(struct brcms_hardware *wlc_hw, u32 flags)
 		brcms_b_clkctl_clk(wlc_hw, CLK_FAST);
 
 	/* reset the dma engines except first time thru */
-	if (ai_iscoreup(wlc_hw->sih)) {
+	if (bcma_core_is_enabled(wlc_hw->d11core)) {
 		for (i = 0; i < NFIFO; i++)
 			if ((wlc_hw->di[i]) && (!dma_txreset(wlc_hw->di[i])))
 				wiphy_err(wlc_hw->wlc->wiphy, "wl%d: %s: "
@@ -2033,7 +2045,7 @@ void brcms_b_corereset(struct brcms_hardware *wlc_hw, u32 flags)
 	 * they may touch chipcommon as well.
 	 */
 	wlc_hw->clk = false;
-	ai_core_reset(wlc_hw->sih, flags, resetbits);
+	bcma_core_enable(wlc_hw->d11core, flags);
 	wlc_hw->clk = true;
 	if (wlc_hw->band && wlc_hw->band->pi)
 		wlc_phy_hw_clk_state_upd(wlc_hw->band->pi, true);
@@ -2876,7 +2888,7 @@ static void brcms_c_coredisable(struct brcms_hardware *wlc_hw)
 	brcms_b_core_phypll_ctl(wlc_hw, false);
 
 	wlc_hw->clk = false;
-	ai_core_disable(wlc_hw->sih, 0);
+	bcma_core_disable(wlc_hw->d11core, 0);
 	wlc_phy_hw_clk_state_upd(wlc_hw->band->pi, false);
 }
 
@@ -3234,7 +3246,7 @@ static void brcms_b_coreinit(struct brcms_c_info *wlc)
 
 	brcms_c_gpio_init(wlc);
 
-	sflags = ai_core_sflags(wlc_hw->sih, 0, 0);
+	sflags = bcma_aread32(core, BCMA_IOST);
 
 	if (D11REV_IS(wlc_hw->corerev, 23)) {
 		if (BRCMS_ISNPHY(wlc_hw->band))
@@ -5318,7 +5330,7 @@ static int brcms_b_down_finish(struct brcms_hardware *wlc_hw)
 	} else {
 
 		/* Reset and disable the core */
-		if (ai_iscoreup(wlc_hw->sih)) {
+		if (bcma_core_is_enabled(wlc_hw->d11core)) {
 			if (bcma_read32(wlc_hw->d11core,
 					D11REGOFFS(maccontrol)) & MCTL_EN_MAC)
 				brcms_c_suspend_mac_and_wait(wlc_hw->wlc);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
index 21418c7..687aafa 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -437,7 +437,7 @@ wlc_phy_attach(struct shared_phy *sh, struct bcma_device *d11core,
 	if (D11REV_IS(sh->corerev, 4))
 		sflags = SISF_2G_PHY | SISF_5G_PHY;
 	else
-		sflags = ai_core_sflags(sh->sih, 0, 0);
+		sflags = bcma_aread32(d11core, BCMA_IOST);
 
 	if (bandtype == BRCM_BAND_5G) {
 		if ((sflags & (SISF_5G_PHY | SISF_DB_PHY)) == 0)
@@ -761,7 +761,7 @@ void wlc_phy_init(struct brcms_phy_pub *pih, u16 chanspec)
 	if (!(pi->measure_hold & PHY_HOLD_FOR_SCAN))
 		pi->measure_hold |= PHY_HOLD_FOR_NOT_ASSOC;
 
-	if (WARN(!(ai_core_sflags(pi->sh->sih, 0, 0) & SISF_FCLKA),
+	if (WARN(!(bcma_aread32(pi->d11core, BCMA_IOST) & SISF_FCLKA),
 		 "HW error SISF_FCLKA\n"))
 		return;
 
-- 
1.7.5.4


