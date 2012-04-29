Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44935 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755082Ab2D2Av3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2012 20:51:29 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 04/19] brcmsmac: remove support for cc rev < 20
Date: Sun, 29 Apr 2012 02:50:28 +0200
Message-Id: <1335660643-26368-5-git-send-email-hauke@hauke-m.de> (sfid-20120429_025145_412014_E271BD8C)
In-Reply-To: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
References: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The lowest chip common version used on bcma based devices is 31 on the
bcm4718 and 32 on the bcm4313, bcm43224, and bcm43225, so the support
for the old versions could be removed.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |  105 +++------------------
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h |    5 -
 2 files changed, 11 insertions(+), 99 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index d2c8f14..ebec0a2 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -491,8 +491,7 @@ ai_buscore_setup(struct si_info *sii, struct bcma_device *cc)
 	sii->pub.ccrev = cc->id.rev;
 
 	/* get chipcommon chipstatus */
-	if (ai_get_ccrev(&sii->pub) >= 11)
-		sii->chipst = bcma_read32(cc, CHIPCREGOFFS(chipstatus));
+	sii->chipst = bcma_read32(cc, CHIPCREGOFFS(chipstatus));
 
 	/* get chipcommon capabilites */
 	sii->pub.cccaps = bcma_read32(cc, CHIPCREGOFFS(capabilities));
@@ -721,21 +720,7 @@ uint ai_cc_reg(struct si_pub *sih, uint regoff, u32 mask, u32 val)
 /* return the slow clock source - LPO, XTAL, or PCI */
 static uint ai_slowclk_src(struct si_pub *sih, struct bcma_device *cc)
 {
-	struct si_info *sii;
-	u32 val;
-
-	sii = (struct si_info *)sih;
-	if (ai_get_ccrev(&sii->pub) < 6) {
-		pci_read_config_dword(sii->pcibus, PCI_GPIO_OUT,
-				      &val);
-		if (val & PCI_CFG_GPIO_SCS)
-			return SCC_SS_PCI;
-		return SCC_SS_XTAL;
-	} else if (ai_get_ccrev(&sii->pub) < 10) {
-		return bcma_read32(cc, CHIPCREGOFFS(slow_clk_ctl)) &
-		       SCC_SS_MASK;
-	} else			/* Insta-clock */
-		return SCC_SS_XTAL;
+	return SCC_SS_XTAL;
 }
 
 /*
@@ -745,36 +730,12 @@ static uint ai_slowclk_src(struct si_pub *sih, struct bcma_device *cc)
 static uint ai_slowclk_freq(struct si_pub *sih, bool max_freq,
 			    struct bcma_device *cc)
 {
-	u32 slowclk;
 	uint div;
 
-	slowclk = ai_slowclk_src(sih, cc);
-	if (ai_get_ccrev(sih) < 6) {
-		if (slowclk == SCC_SS_PCI)
-			return max_freq ? (PCIMAXFREQ / 64)
-				: (PCIMINFREQ / 64);
-		else
-			return max_freq ? (XTALMAXFREQ / 32)
-				: (XTALMINFREQ / 32);
-	} else if (ai_get_ccrev(sih) < 10) {
-		div = 4 *
-		    (((bcma_read32(cc, CHIPCREGOFFS(slow_clk_ctl)) &
-		      SCC_CD_MASK) >> SCC_CD_SHIFT) + 1);
-		if (slowclk == SCC_SS_LPO)
-			return max_freq ? LPOMAXFREQ : LPOMINFREQ;
-		else if (slowclk == SCC_SS_XTAL)
-			return max_freq ? (XTALMAXFREQ / div)
-				: (XTALMINFREQ / div);
-		else if (slowclk == SCC_SS_PCI)
-			return max_freq ? (PCIMAXFREQ / div)
-				: (PCIMINFREQ / div);
-	} else {
-		/* Chipc rev 10 is InstaClock */
-		div = bcma_read32(cc, CHIPCREGOFFS(system_clk_ctl));
-		div = 4 * ((div >> SYCC_CD_SHIFT) + 1);
-		return max_freq ? XTALMAXFREQ : (XTALMINFREQ / div);
-	}
-	return 0;
+	/* Chipc rev 10 is InstaClock */
+	div = bcma_read32(cc, CHIPCREGOFFS(system_clk_ctl));
+	div = 4 * ((div >> SYCC_CD_SHIFT) + 1);
+	return max_freq ? XTALMAXFREQ : (XTALMINFREQ / div);
 }
 
 static void
@@ -797,8 +758,7 @@ ai_clkctl_setdelay(struct si_pub *sih, struct bcma_device *cc)
 
 	/* Starting with 4318 it is ILP that is used for the delays */
 	slowmaxfreq =
-	    ai_slowclk_freq(sih,
-			    (ai_get_ccrev(sih) >= 10) ? false : true, cc);
+	    ai_slowclk_freq(sih, false, cc);
 
 	pll_on_delay = ((slowmaxfreq * pll_delay) + 999999) / 1000000;
 	fref_sel_delay = ((slowmaxfreq * FREF_DELAY) + 999999) / 1000000;
@@ -820,9 +780,8 @@ void ai_clkctl_init(struct si_pub *sih)
 		return;
 
 	/* set all Instaclk chip ILP to 1 MHz */
-	if (ai_get_ccrev(sih) >= 10)
-		bcma_maskset32(cc, CHIPCREGOFFS(system_clk_ctl), SYCC_CD_MASK,
-			       (ILP_DIV_1MHZ << SYCC_CD_SHIFT));
+	bcma_maskset32(cc, CHIPCREGOFFS(system_clk_ctl), SYCC_CD_MASK,
+		       (ILP_DIV_1MHZ << SYCC_CD_SHIFT));
 
 	ai_clkctl_setdelay(sih, cc);
 }
@@ -926,31 +885,11 @@ static bool _ai_clkctl_cc(struct si_info *sii, uint mode)
 	struct bcma_device *cc;
 	u32 scc;
 
-	/* chipcommon cores prior to rev6 don't support dynamic clock control */
-	if (ai_get_ccrev(&sii->pub) < 6)
-		return false;
-
 	cc = ai_findcore(&sii->pub, BCMA_CORE_CHIPCOMMON, 0);
 
-	if (!(ai_get_cccaps(&sii->pub) & CC_CAP_PWR_CTL) &&
-	    (ai_get_ccrev(&sii->pub) < 20))
-		return mode == CLK_FAST;
-
 	switch (mode) {
 	case CLK_FAST:		/* FORCEHT, fast (pll) clock */
-		if (ai_get_ccrev(&sii->pub) < 10) {
-			/*
-			 * don't forget to force xtal back
-			 * on before we clear SCC_DYN_XTAL..
-			 */
-			ai_clkctl_xtal(&sii->pub, XTAL, ON);
-			bcma_maskset32(cc, CHIPCREGOFFS(slow_clk_ctl),
-				       (SCC_XC | SCC_FS | SCC_IP), SCC_IP);
-		} else if (ai_get_ccrev(&sii->pub) < 20) {
-			bcma_set32(cc, CHIPCREGOFFS(system_clk_ctl), SYCC_HR);
-		} else {
-			bcma_set32(cc, CHIPCREGOFFS(clk_ctl_st), CCS_FORCEHT);
-		}
+		bcma_set32(cc, CHIPCREGOFFS(clk_ctl_st), CCS_FORCEHT);
 
 		/* wait for the PLL */
 		if (ai_get_cccaps(&sii->pub) & CC_CAP_PMU) {
@@ -963,25 +902,7 @@ static bool _ai_clkctl_cc(struct si_info *sii, uint mode)
 		break;
 
 	case CLK_DYNAMIC:	/* enable dynamic clock control */
-		if (ai_get_ccrev(&sii->pub) < 10) {
-			scc = bcma_read32(cc, CHIPCREGOFFS(slow_clk_ctl));
-			scc &= ~(SCC_FS | SCC_IP | SCC_XC);
-			if ((scc & SCC_SS_MASK) != SCC_SS_XTAL)
-				scc |= SCC_XC;
-			bcma_write32(cc, CHIPCREGOFFS(slow_clk_ctl), scc);
-
-			/*
-			 * for dynamic control, we have to
-			 * release our xtal_pu "force on"
-			 */
-			if (scc & SCC_XC)
-				ai_clkctl_xtal(&sii->pub, XTAL, OFF);
-		} else if (ai_get_ccrev(&sii->pub) < 20) {
-			/* Instaclock */
-			bcma_mask32(cc, CHIPCREGOFFS(system_clk_ctl), ~SYCC_HR);
-		} else {
-			bcma_mask32(cc, CHIPCREGOFFS(clk_ctl_st), ~CCS_FORCEHT);
-		}
+		bcma_mask32(cc, CHIPCREGOFFS(clk_ctl_st), ~CCS_FORCEHT);
 		break;
 
 	default:
@@ -1005,10 +926,6 @@ bool ai_clkctl_cc(struct si_pub *sih, uint mode)
 
 	sii = (struct si_info *)sih;
 
-	/* chipcommon cores prior to rev6 don't support dynamic clock control */
-	if (ai_get_ccrev(sih) < 6)
-		return false;
-
 	if (PCI_FORCEHT(sih))
 		return mode == CLK_FAST;
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
index e198b63..32f1597 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
@@ -217,11 +217,6 @@ extern void ai_epa_4313war(struct si_pub *sih);
 extern uint ai_get_buscoretype(struct si_pub *sih);
 extern uint ai_get_buscorerev(struct si_pub *sih);
 
-static inline int ai_get_ccrev(struct si_pub *sih)
-{
-	return sih->ccrev;
-}
-
 static inline u32 ai_get_cccaps(struct si_pub *sih)
 {
 	return sih->cccaps;
-- 
1.7.9.5

