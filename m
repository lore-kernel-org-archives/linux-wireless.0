Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2659 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754616Ab1LLXP5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 18:15:57 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 08/15] brcm80211: smac: INTROFF/INTRESTORE macros
 removed
Date: Mon, 12 Dec 2011 15:15:06 -0800
Message-ID: <1323731713-14942-9-git-send-email-frankyl@broadcom.com> (sfid-20111213_002944_784138_357B2CEE)
In-Reply-To: <1323731713-14942-1-git-send-email-frankyl@broadcom.com>
References: <1323731713-14942-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The macros were used to assure that the correct core was accessed in
the ISR, but register access is now done giving the explicit core so
no need to change interrupt state.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |   30 ++++----------------
 1 files changed, 6 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index 3d37b0a..3a78f5f 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -940,14 +940,11 @@ uint ai_cc_reg(struct si_pub *sih, uint regoff, u32 mask, u32 val)
 	struct bcma_device *cc;
 	uint origidx = 0;
 	u32 w;
-	uint intr_val = 0;
 	struct si_info *sii;
 
 	sii = (struct si_info *)sih;
 	cc = sii->icbus->drv_cc.core;
 
-	INTR_OFF(sii, intr_val);
-
 	/* save current core index */
 	origidx = ai_coreidx(&sii->pub);
 
@@ -962,8 +959,6 @@ uint ai_cc_reg(struct si_pub *sih, uint regoff, u32 mask, u32 val)
 	/* restore core index */
 	ai_setcoreidx(&sii->pub, origidx);
 
-	INTR_RESTORE(sii, intr_val);
-
 	return w;
 }
 
@@ -1086,13 +1081,10 @@ u16 ai_clkctl_fast_pwrup_delay(struct si_pub *sih)
 	struct bcma_device *cc;
 	uint slowminfreq;
 	u16 fpdelay;
-	uint intr_val = 0;
 
 	sii = (struct si_info *)sih;
 	if (ai_get_cccaps(sih) & CC_CAP_PMU) {
-		INTR_OFF(sii, intr_val);
 		fpdelay = si_pmu_fast_pwrup_delay(sih);
-		INTR_RESTORE(sii, intr_val);
 		return fpdelay;
 	}
 
@@ -1100,18 +1092,12 @@ u16 ai_clkctl_fast_pwrup_delay(struct si_pub *sih)
 		return 0;
 
 	fpdelay = 0;
-	INTR_OFF(sii, intr_val);
 	cc = ai_findcore(sih, CC_CORE_ID, 0);
-	if (cc == NULL)
-		goto done;
-
-
-	slowminfreq = ai_slowclk_freq(sih, false, cc);
-	fpdelay = (((bcma_read32(cc, CHIPCREGOFFS(pll_on_delay)) + 2) * 1000000)
-		   + (slowminfreq - 1)) / slowminfreq;
-
- done:
-	INTR_RESTORE(sii, intr_val);
+	if (cc) {
+		slowminfreq = ai_slowclk_freq(sih, false, cc);
+		fpdelay = (((bcma_read32(cc, CHIPCREGOFFS(pll_on_delay)) + 2)
+			    * 1000000) + (slowminfreq - 1)) / slowminfreq;
+	}
 	return fpdelay;
 }
 
@@ -1183,18 +1169,16 @@ static bool _ai_clkctl_cc(struct si_info *sii, uint mode)
 {
 	struct bcma_device *cc;
 	u32 scc;
-	uint intr_val = 0;
 
 	/* chipcommon cores prior to rev6 don't support dynamic clock control */
 	if (ai_get_ccrev(&sii->pub) < 6)
 		return false;
 
-	INTR_OFF(sii, intr_val);
 	cc = ai_findcore(&sii->pub, BCMA_CORE_CHIPCOMMON, 0);
 
 	if (!(ai_get_cccaps(&sii->pub) & CC_CAP_PWR_CTL) &&
 	    (ai_get_ccrev(&sii->pub) < 20))
-		goto done;
+		return mode == CLK_FAST;
 
 	switch (mode) {
 	case CLK_FAST:		/* FORCEHT, fast (pll) clock */
@@ -1248,8 +1232,6 @@ static bool _ai_clkctl_cc(struct si_info *sii, uint mode)
 		break;
 	}
 
- done:
-	INTR_RESTORE(sii, intr_val);
 	return mode == CLK_FAST;
 }
 
-- 
1.7.5.4


