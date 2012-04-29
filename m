Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44978 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755162Ab2D2Avq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2012 20:51:46 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 11/19] brcmsmac: remove _ai_clkctl_cc()
Date: Sun, 29 Apr 2012 02:50:35 +0200
Message-Id: <1335660643-26368-12-git-send-email-hauke@hauke-m.de> (sfid-20120429_025150_512964_732F73E8)
In-Reply-To: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
References: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is now done by calling bcma_core_set_clockmode()

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |   56 ++++++---------------
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h |    4 --
 drivers/net/wireless/brcm80211/brcmsmac/main.c    |   30 +++++------
 3 files changed, 31 insertions(+), 59 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index 1b7b172..b64fbc0 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -761,39 +761,6 @@ u16 ai_clkctl_fast_pwrup_delay(struct si_pub *sih)
 	return fpdelay;
 }
 
-/* clk control mechanism through chipcommon, no policy checking */
-static bool _ai_clkctl_cc(struct si_info *sii, uint mode)
-{
-	struct bcma_device *cc;
-	u32 scc;
-
-	cc = ai_findcore(&sii->pub, BCMA_CORE_CHIPCOMMON, 0);
-
-	switch (mode) {
-	case CLK_FAST:		/* FORCEHT, fast (pll) clock */
-		bcma_set32(cc, CHIPCREGOFFS(clk_ctl_st), CCS_FORCEHT);
-
-		/* wait for the PLL */
-		if (ai_get_cccaps(&sii->pub) & CC_CAP_PMU) {
-			u32 htavail = CCS_HTAVAIL;
-			SPINWAIT(((bcma_read32(cc, CHIPCREGOFFS(clk_ctl_st)) &
-				   htavail) == 0), PMU_MAX_TRANSITION_DLY);
-		} else {
-			udelay(PLL_DELAY);
-		}
-		break;
-
-	case CLK_DYNAMIC:	/* enable dynamic clock control */
-		bcma_mask32(cc, CHIPCREGOFFS(clk_ctl_st), ~CCS_FORCEHT);
-		break;
-
-	default:
-		break;
-	}
-
-	return mode == CLK_FAST;
-}
-
 /*
  *  clock control policy function throught chipcommon
  *
@@ -802,26 +769,32 @@ static bool _ai_clkctl_cc(struct si_info *sii, uint mode)
  *    this is a wrapper over the next internal function
  *      to allow flexible policy settings for outside caller
  */
-bool ai_clkctl_cc(struct si_pub *sih, uint mode)
+bool ai_clkctl_cc(struct si_pub *sih, enum bcma_clkmode mode)
 {
 	struct si_info *sii;
+	struct bcma_device *cc;
 
 	sii = (struct si_info *)sih;
 
 	if (PCI_FORCEHT(sih))
-		return mode == CLK_FAST;
+		return mode == BCMA_CLKMODE_FAST;
 
-	return _ai_clkctl_cc(sii, mode);
+	cc = ai_findcore(&sii->pub, BCMA_CORE_CHIPCOMMON, 0);
+	bcma_core_set_clockmode(cc, mode);
+	return mode == BCMA_CLKMODE_FAST;
 }
 
 void ai_pci_up(struct si_pub *sih)
 {
 	struct si_info *sii;
+	struct bcma_device *cc;
 
 	sii = (struct si_info *)sih;
 
-	if (PCI_FORCEHT(sih))
-		_ai_clkctl_cc(sii, CLK_FAST);
+	if (PCI_FORCEHT(sih)) {
+		cc = ai_findcore(&sii->pub, BCMA_CORE_CHIPCOMMON, 0);
+		bcma_core_set_clockmode(cc, BCMA_CLKMODE_FAST);
+	}
 
 	if (PCIE(sih))
 		pcicore_up(sii->pch, SI_PCIUP);
@@ -832,12 +805,15 @@ void ai_pci_up(struct si_pub *sih)
 void ai_pci_down(struct si_pub *sih)
 {
 	struct si_info *sii;
+	struct bcma_device *cc;
 
 	sii = (struct si_info *)sih;
 
 	/* release FORCEHT since chip is going to "down" state */
-	if (PCI_FORCEHT(sih))
-		_ai_clkctl_cc(sii, CLK_DYNAMIC);
+	if (PCI_FORCEHT(sih)) {
+		cc = ai_findcore(&sii->pub, BCMA_CORE_CHIPCOMMON, 0);
+		bcma_core_set_clockmode(cc, BCMA_CLKMODE_DYNAMIC);
+	}
 
 	pcicore_down(sii->pch, SI_PCIDOWN);
 }
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
index 62c3a63..14ae9f5 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
@@ -113,10 +113,6 @@
 #define	XTAL			0x1	/* primary crystal oscillator (2050) */
 #define	PLL			0x2	/* main chip pll */
 
-/* clkctl clk mode */
-#define	CLK_FAST		0	/* force fast (pll) clock */
-#define	CLK_DYNAMIC		2	/* enable dynamic clock control */
-
 /* GPIO usage priorities */
 #define GPIO_DRV_PRIORITY	0	/* Driver */
 #define GPIO_APP_PRIORITY	1	/* Application */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index f8b0e09..0d4a511 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -1219,7 +1219,7 @@ static void brcms_b_wait_for_wake(struct brcms_hardware *wlc_hw)
 }
 
 /* control chip clock to save power, enable dynamic clock or force fast clock */
-static void brcms_b_clkctl_clk(struct brcms_hardware *wlc_hw, uint mode)
+static void brcms_b_clkctl_clk(struct brcms_hardware *wlc_hw, enum bcma_clkmode mode)
 {
 	if (ai_get_cccaps(wlc_hw->sih) & CC_CAP_PMU) {
 		/* new chips with PMU, CCS_FORCEHT will distribute the HT clock
@@ -1229,7 +1229,7 @@ static void brcms_b_clkctl_clk(struct brcms_hardware *wlc_hw, uint mode)
 		 */
 
 		if (wlc_hw->clk) {
-			if (mode == CLK_FAST) {
+			if (mode == BCMA_CLKMODE_FAST) {
 				bcma_set32(wlc_hw->d11core,
 					   D11REGOFFS(clk_ctl_st),
 					   CCS_FORCEHT);
@@ -1260,7 +1260,7 @@ static void brcms_b_clkctl_clk(struct brcms_hardware *wlc_hw, uint mode)
 					~CCS_FORCEHT);
 			}
 		}
-		wlc_hw->forcefastclk = (mode == CLK_FAST);
+		wlc_hw->forcefastclk = (mode == BCMA_CLKMODE_FAST);
 	} else {
 
 		/* old chips w/o PMU, force HT through cc,
@@ -1567,7 +1567,7 @@ void brcms_b_bw_set(struct brcms_hardware *wlc_hw, u16 bw)
 	/* request FAST clock if not on */
 	fastclk = wlc_hw->forcefastclk;
 	if (!fastclk)
-		brcms_b_clkctl_clk(wlc_hw, CLK_FAST);
+		brcms_b_clkctl_clk(wlc_hw, BCMA_CLKMODE_FAST);
 
 	wlc_phy_bw_state_set(wlc_hw->band->pi, bw);
 
@@ -1576,7 +1576,7 @@ void brcms_b_bw_set(struct brcms_hardware *wlc_hw, u16 bw)
 
 	/* restore the clk */
 	if (!fastclk)
-		brcms_b_clkctl_clk(wlc_hw, CLK_DYNAMIC);
+		brcms_b_clkctl_clk(wlc_hw, BCMA_CLKMODE_DYNAMIC);
 }
 
 static void brcms_b_upd_synthpu(struct brcms_hardware *wlc_hw)
@@ -1994,7 +1994,7 @@ void brcms_b_corereset(struct brcms_hardware *wlc_hw, u32 flags)
 	/* request FAST clock if not on  */
 	fastclk = wlc_hw->forcefastclk;
 	if (!fastclk)
-		brcms_b_clkctl_clk(wlc_hw, CLK_FAST);
+		brcms_b_clkctl_clk(wlc_hw, BCMA_CLKMODE_FAST);
 
 	/* reset the dma engines except first time thru */
 	if (bcma_core_is_enabled(wlc_hw->d11core)) {
@@ -2043,7 +2043,7 @@ void brcms_b_corereset(struct brcms_hardware *wlc_hw, u32 flags)
 	brcms_c_mctrl_reset(wlc_hw);
 
 	if (ai_get_cccaps(wlc_hw->sih) & CC_CAP_PMU)
-		brcms_b_clkctl_clk(wlc_hw, CLK_FAST);
+		brcms_b_clkctl_clk(wlc_hw, BCMA_CLKMODE_FAST);
 
 	brcms_b_phy_reset(wlc_hw);
 
@@ -2055,7 +2055,7 @@ void brcms_b_corereset(struct brcms_hardware *wlc_hw, u32 flags)
 
 	/* restore the clk setting */
 	if (!fastclk)
-		brcms_b_clkctl_clk(wlc_hw, CLK_DYNAMIC);
+		brcms_b_clkctl_clk(wlc_hw, BCMA_CLKMODE_DYNAMIC);
 }
 
 /* txfifo sizes needs to be modified(increased) since the newer cores
@@ -3361,7 +3361,7 @@ static brcms_b_init(struct brcms_hardware *wlc_hw, u16 chanspec) {
 	/* request FAST clock if not on */
 	fastclk = wlc_hw->forcefastclk;
 	if (!fastclk)
-		brcms_b_clkctl_clk(wlc_hw, CLK_FAST);
+		brcms_b_clkctl_clk(wlc_hw, BCMA_CLKMODE_FAST);
 
 	/* disable interrupts */
 	macintmask = brcms_intrsoff(wlc->wl);
@@ -3395,7 +3395,7 @@ static brcms_b_init(struct brcms_hardware *wlc_hw, u16 chanspec) {
 
 	/* restore the clk */
 	if (!fastclk)
-		brcms_b_clkctl_clk(wlc_hw, CLK_DYNAMIC);
+		brcms_b_clkctl_clk(wlc_hw, BCMA_CLKMODE_DYNAMIC);
 }
 
 static void brcms_c_set_phy_chanspec(struct brcms_c_info *wlc,
@@ -4491,7 +4491,7 @@ static int brcms_b_attach(struct brcms_c_info *wlc, struct bcma_device *core,
 	 *   is still false; But it will be called again inside wlc_corereset,
 	 *   after d11 is out of reset.
 	 */
-	brcms_b_clkctl_clk(wlc_hw, CLK_FAST);
+	brcms_b_clkctl_clk(wlc_hw, BCMA_CLKMODE_FAST);
 	brcms_b_corereset(wlc_hw, BRCMS_USE_COREFLAGS);
 
 	if (!brcms_b_validate_chip_access(wlc_hw)) {
@@ -5019,7 +5019,7 @@ static void brcms_b_hw_up(struct brcms_hardware *wlc_hw)
 	 */
 	brcms_b_xtal(wlc_hw, ON);
 	ai_clkctl_init(wlc_hw->sih);
-	brcms_b_clkctl_clk(wlc_hw, CLK_FAST);
+	brcms_b_clkctl_clk(wlc_hw, BCMA_CLKMODE_FAST);
 
 	ai_pci_fixcfg(wlc_hw->sih);
 
@@ -5058,7 +5058,7 @@ static int brcms_b_up_prep(struct brcms_hardware *wlc_hw)
 	 */
 	brcms_b_xtal(wlc_hw, ON);
 	ai_clkctl_init(wlc_hw->sih);
-	brcms_b_clkctl_clk(wlc_hw, CLK_FAST);
+	brcms_b_clkctl_clk(wlc_hw, BCMA_CLKMODE_FAST);
 
 	/*
 	 * Configure pci/pcmcia here instead of in brcms_c_attach()
@@ -5095,7 +5095,7 @@ static int brcms_b_up_finish(struct brcms_hardware *wlc_hw)
 	wlc_phy_hw_state_upd(wlc_hw->band->pi, true);
 
 	/* FULLY enable dynamic power control and d11 core interrupt */
-	brcms_b_clkctl_clk(wlc_hw, CLK_DYNAMIC);
+	brcms_b_clkctl_clk(wlc_hw, BCMA_CLKMODE_DYNAMIC);
 	brcms_intrson(wlc_hw->wlc->wl);
 	return 0;
 }
@@ -5236,7 +5236,7 @@ static int brcms_b_bmac_down_prep(struct brcms_hardware *wlc_hw)
 		brcms_intrsoff(wlc_hw->wlc->wl);
 
 		/* ensure we're running on the pll clock again */
-		brcms_b_clkctl_clk(wlc_hw, CLK_FAST);
+		brcms_b_clkctl_clk(wlc_hw, BCMA_CLKMODE_FAST);
 	}
 	/* down phy at the last of this stage */
 	callbacks += wlc_phy_down(wlc_hw->band->pi);
-- 
1.7.9.5

