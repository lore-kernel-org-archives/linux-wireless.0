Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1521 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab1LHXHM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 18:07:12 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 19/23] brcm80211: smac: remove SI_FAST() macro usage
Date: Thu, 8 Dec 2011 15:06:55 -0800
Message-ID: <1323385619-7454-20-git-send-email-frankyl@broadcom.com> (sfid-20111209_000813_997166_96713638)
In-Reply-To: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
References: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The use of SI_FAST() macro interferes with the BCMA integration as
it causes BCMA and aiutils.c to get out of sync on what the current
core is. When everything is using BCMA we will try to add SI_FAST
functionality to BCMA to avoid unnecessary core switching.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |  157 +++++----------------
 1 files changed, 35 insertions(+), 122 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index ef1441a..7aa47b3 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -318,16 +318,6 @@
 
 #define	BADIDX		(SI_MAXCORES + 1)
 
-/* Newer chips can access PCI/PCIE and CC core without requiring to change
- * PCI BAR0 WIN
- */
-#define SI_FAST(sih) ((ai_get_buscoretype(sih) == PCIE_CORE_ID) || \
-		     ((ai_get_buscoretype(sih) == PCI_CORE_ID) && \
-		      ai_get_buscorerev(sih) >= 13))
-
-#define CCREGS_FAST(si) (((char __iomem *)((si)->curmap) + \
-			  PCI_16KB0_CCREGS_OFFSET))
-
 #define	IS_SIM(chippkg)	\
 	((chippkg == HDLSIM_PKG_ID) || (chippkg == HWSIM_PKG_ID))
 
@@ -360,9 +350,6 @@
 	(((x) >= (b)) && ((x) < ((b) + SI_MAXCORES * SI_CORE_SIZE)) && \
 		IS_ALIGNED((x), SI_CORE_SIZE))
 
-#define PCIEREGS(si) ((__iomem char *)((si)->curmap) + \
-			PCI_16KB0_PCIREGS_OFFSET)
-
 struct aidmp {
 	u32 oobselina30;	/* 0x000 */
 	u32 oobselina74;	/* 0x004 */
@@ -777,13 +764,11 @@ ai_buscore_setup(struct si_info *sii, u32 savewin, uint *origidx)
 	}
 
 	/* fixup necessary chip/core configurations */
-	if (SI_FAST(&sii->pub)) {
-		if (!sii->pch) {
-			sii->pch = pcicore_init(&sii->pub, sii->pcibus,
-						(__iomem void *)PCIEREGS(sii));
-			if (sii->pch == NULL)
-				return false;
-		}
+	if (!sii->pch) {
+		sii->pch = pcicore_init(&sii->pub, sii->pcibus,
+					sii->curmap + PCI_16KB0_PCIREGS_OFFSET);
+		if (sii->pch == NULL)
+			return false;
 	}
 	if (ai_pci_fixcfg(&sii->pub)) {
 		/* si_doattach: si_pci_fixcfg failed */
@@ -1084,17 +1069,6 @@ void __iomem *ai_switch_core(struct si_pub *sih, uint coreid, uint *origidx,
 
 	sii = (struct si_info *)sih;
 
-	if (SI_FAST(sih)) {
-		/* Overloading the origidx variable to remember the coreid,
-		 * this works because the core ids cannot be confused with
-		 * core indices.
-		 */
-		*origidx = coreid;
-		if (coreid == CC_CORE_ID)
-			return CCREGS_FAST(sii);
-		else if (coreid == ai_get_buscoretype(sih))
-			return PCIEREGS(sii);
-	}
 	INTR_OFF(sii, *intr_val);
 	*origidx = sii->curidx;
 	cc = ai_setcore(sih, coreid, 0);
@@ -1107,9 +1081,6 @@ void ai_restore_core(struct si_pub *sih, uint coreid, uint intr_val)
 	struct si_info *sii;
 
 	sii = (struct si_info *)sih;
-	if (SI_FAST(sih)
-	    && ((coreid == CC_CORE_ID) || (coreid == ai_get_buscoretype(sih))))
-		return;
 
 	ai_setcoreidx(sih, coreid);
 	INTR_RESTORE(sii, intr_val);
@@ -1140,7 +1111,6 @@ uint ai_corereg(struct si_pub *sih, uint coreidx, uint regoff, uint mask,
 	u32 __iomem *r = NULL;
 	uint w;
 	uint intr_val = 0;
-	bool fast = false;
 	struct si_info *sii;
 
 	sii = (struct si_info *)sih;
@@ -1148,41 +1118,14 @@ uint ai_corereg(struct si_pub *sih, uint coreidx, uint regoff, uint mask,
 	if (coreidx >= SI_MAXCORES)
 		return 0;
 
-	/*
-	 * If pci/pcie, we can get at pci/pcie regs
-	 * and on newer cores to chipc
-	 */
-	if ((sii->coreid[coreidx] == CC_CORE_ID) && SI_FAST(sih)) {
-		/* Chipc registers are mapped at 12KB */
-		fast = true;
-		r = (u32 __iomem *)((__iomem char *)sii->curmap +
-				    PCI_16KB0_CCREGS_OFFSET + regoff);
-	} else if (sii->buscoreidx == coreidx) {
-		/*
-		 * pci registers are at either in the last 2KB of
-		 * an 8KB window or, in pcie and pci rev 13 at 8KB
-		 */
-		fast = true;
-		if (SI_FAST(sih))
-			r = (u32 __iomem *)((__iomem char *)sii->curmap +
-				    PCI_16KB0_PCIREGS_OFFSET + regoff);
-		else
-			r = (u32 __iomem *)((__iomem char *)sii->curmap +
-				    ((regoff >= SBCONFIGOFF) ?
-				      PCI_BAR0_PCISBR_OFFSET :
-				      PCI_BAR0_PCIREGS_OFFSET) + regoff);
-	}
-
-	if (!fast) {
-		INTR_OFF(sii, intr_val);
+	INTR_OFF(sii, intr_val);
 
-		/* save current core index */
-		origidx = ai_coreidx(&sii->pub);
+	/* save current core index */
+	origidx = ai_coreidx(&sii->pub);
 
-		/* switch core */
-		r = (u32 __iomem *) ((unsigned char __iomem *)
-			ai_setcoreidx(&sii->pub, coreidx) + regoff);
-	}
+	/* switch core */
+	r = (u32 __iomem *) ((unsigned char __iomem *)
+		ai_setcoreidx(&sii->pub, coreidx) + regoff);
 
 	/* mask and set */
 	if (mask || val) {
@@ -1193,13 +1136,11 @@ uint ai_corereg(struct si_pub *sih, uint coreidx, uint regoff, uint mask,
 	/* readback */
 	w = R_REG(r);
 
-	if (!fast) {
-		/* restore core index */
-		if (origidx != coreidx)
-			ai_setcoreidx(&sii->pub, origidx);
+	/* restore core index */
+	if (origidx != coreidx)
+		ai_setcoreidx(&sii->pub, origidx);
 
-		INTR_RESTORE(sii, intr_val);
-	}
+	INTR_RESTORE(sii, intr_val);
 
 	return w;
 }
@@ -1354,24 +1295,16 @@ void ai_clkctl_init(struct si_pub *sih)
 	struct si_info *sii;
 	uint origidx = 0;
 	struct chipcregs __iomem *cc;
-	bool fast;
 
 	if (!(ai_get_cccaps(sih) & CC_CAP_PWR_CTL))
 		return;
 
 	sii = (struct si_info *)sih;
-	fast = SI_FAST(sih);
-	if (!fast) {
-		origidx = sii->curidx;
-		cc = (struct chipcregs __iomem *)
-			ai_setcore(sih, CC_CORE_ID, 0);
-		if (cc == NULL)
-			return;
-	} else {
-		cc = (struct chipcregs __iomem *) CCREGS_FAST(sii);
-		if (cc == NULL)
-			return;
-	}
+	origidx = sii->curidx;
+	cc = (struct chipcregs __iomem *)
+		ai_setcore(sih, CC_CORE_ID, 0);
+	if (cc == NULL)
+		return;
 
 	/* set all Instaclk chip ILP to 1 MHz */
 	if (ai_get_ccrev(sih) >= 10)
@@ -1380,8 +1313,7 @@ void ai_clkctl_init(struct si_pub *sih)
 
 	ai_clkctl_setdelay(sii, cc);
 
-	if (!fast)
-		ai_setcoreidx(sih, origidx);
+	ai_setcoreidx(sih, origidx);
 }
 
 /*
@@ -1396,7 +1328,6 @@ u16 ai_clkctl_fast_pwrup_delay(struct si_pub *sih)
 	uint slowminfreq;
 	u16 fpdelay;
 	uint intr_val = 0;
-	bool fast;
 
 	sii = (struct si_info *)sih;
 	if (ai_get_cccaps(sih) & CC_CAP_PMU) {
@@ -1409,30 +1340,21 @@ u16 ai_clkctl_fast_pwrup_delay(struct si_pub *sih)
 	if (!(ai_get_cccaps(sih) & CC_CAP_PWR_CTL))
 		return 0;
 
-	fast = SI_FAST(sih);
 	fpdelay = 0;
-	if (!fast) {
-		origidx = sii->curidx;
-		INTR_OFF(sii, intr_val);
-		cc = (struct chipcregs __iomem *)
-			ai_setcore(sih, CC_CORE_ID, 0);
-		if (cc == NULL)
-			goto done;
-	} else {
-		cc = (struct chipcregs __iomem *) CCREGS_FAST(sii);
-		if (cc == NULL)
-			goto done;
-	}
+	origidx = sii->curidx;
+	INTR_OFF(sii, intr_val);
+	cc = (struct chipcregs __iomem *)
+		ai_setcore(sih, CC_CORE_ID, 0);
+	if (cc == NULL)
+		goto done;
 
 	slowminfreq = ai_slowclk_freq(sii, false, cc);
 	fpdelay = (((R_REG(&cc->pll_on_delay) + 2) * 1000000) +
 		   (slowminfreq - 1)) / slowminfreq;
 
  done:
-	if (!fast) {
-		ai_setcoreidx(sih, origidx);
-		INTR_RESTORE(sii, intr_val);
-	}
+	ai_setcoreidx(sih, origidx);
+	INTR_RESTORE(sii, intr_val);
 	return fpdelay;
 }
 
@@ -1506,22 +1428,15 @@ static bool _ai_clkctl_cc(struct si_info *sii, uint mode)
 	struct chipcregs __iomem *cc;
 	u32 scc;
 	uint intr_val = 0;
-	bool fast = SI_FAST(&sii->pub);
 
 	/* chipcommon cores prior to rev6 don't support dynamic clock control */
 	if (ai_get_ccrev(&sii->pub) < 6)
 		return false;
 
-	if (!fast) {
-		INTR_OFF(sii, intr_val);
-		origidx = sii->curidx;
-		cc = (struct chipcregs __iomem *)
-					ai_setcore(&sii->pub, CC_CORE_ID, 0);
-	} else {
-		cc = (struct chipcregs __iomem *) CCREGS_FAST(sii);
-		if (cc == NULL)
-			goto done;
-	}
+	INTR_OFF(sii, intr_val);
+	origidx = sii->curidx;
+	cc = (struct chipcregs __iomem *)
+				ai_setcore(&sii->pub, CC_CORE_ID, 0);
 
 	if (!(ai_get_cccaps(&sii->pub) & CC_CAP_PWR_CTL) &&
 	    (ai_get_ccrev(&sii->pub) < 20))
@@ -1580,10 +1495,8 @@ static bool _ai_clkctl_cc(struct si_info *sii, uint mode)
 	}
 
  done:
-	if (!fast) {
-		ai_setcoreidx(&sii->pub, origidx);
-		INTR_RESTORE(sii, intr_val);
-	}
+	ai_setcoreidx(&sii->pub, origidx);
+	INTR_RESTORE(sii, intr_val);
 	return mode == CLK_FAST;
 }
 
-- 
1.7.5.4


