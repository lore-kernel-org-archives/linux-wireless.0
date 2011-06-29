Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4582 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757716Ab1F2Xso (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:44 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 010/119] staging: brcm80211: remove code for unsupported
 chipsets from brcmsmac
Date: Wed, 29 Jun 2011 16:46:34 -0700
Message-ID: <1309391303-22741-11-git-send-email-frankyl@broadcom.com> (sfid-20110630_014930_150437_F2D3CA49)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The brcmsmac driver code contains code fragments for chipsets that are not
supported. These have been removed from the brcmsmac source files.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.c |   52 +-------------------------
 drivers/staging/brcm80211/brcmsmac/bmac.c    |    6 +--
 drivers/staging/brcm80211/brcmsmac/main.c    |   10 +----
 3 files changed, 4 insertions(+), 64 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index 82809cb..d41104f 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -1157,25 +1157,6 @@ static si_info_t *ai_doattach(si_info_t *sii,
 		goto exit;
 	}
 
-	/* assume current core is CC */
-	if ((sii->pub.ccrev == 0x25)
-	    &&
-	    ((sih->chip == BCM43236_CHIP_ID
-	      || sih->chip == BCM43235_CHIP_ID
-	      || sih->chip == BCM43238_CHIP_ID)
-	     && (sii->pub.chiprev <= 2))) {
-
-		if ((cc->chipstatus & CST43236_BP_CLK) != 0) {
-			uint clkdiv;
-			clkdiv = R_REG(&cc->clkdiv);
-			/* otp_clk_div is even number, 120/14 < 9mhz */
-			clkdiv = (clkdiv & ~CLKD_OTP) | (14 << CLKD_OTP_SHIFT);
-			W_REG(&cc->clkdiv, clkdiv);
-			SI_ERROR(("%s: set clkdiv to %x\n", __func__, clkdiv));
-		}
-		udelay(10);
-	}
-
 	/* Init nvram from sprom/otp if they exist */
 	if (srom_var_init
 	    (&sii->pub, bustype, regs, vars, varsz)) {
@@ -1215,8 +1196,7 @@ static si_info_t *ai_doattach(si_info_t *sii,
 		pcicore_attach(sii->pch, pvars, SI_DOATTACH);
 	}
 
-	if ((sih->chip == BCM43224_CHIP_ID) ||
-	    (sih->chip == BCM43421_CHIP_ID)) {
+	if (sih->chip == BCM43224_CHIP_ID) {
 		/*
 		 * enable 12 mA drive strenth for 43224 and
 		 * set chipControl register bit 15
@@ -1247,11 +1227,6 @@ static si_info_t *ai_doattach(si_info_t *sii,
 				   CCTRL_4313_12MA_LED_DRIVE);
 	}
 
-	if (sih->chip == BCM4331_CHIP_ID) {
-		/* Enable Ext PA lines depending on chip package option */
-		ai_chipcontrl_epa4331(sih, true);
-	}
-
 	return sii;
  exit:
 	if (sih->bustype == PCI_BUS) {
@@ -2283,18 +2258,8 @@ bool ai_is_sprom_available(struct si_pub *sih)
 	}
 
 	switch (sih->chip) {
-	case BCM4329_CHIP_ID:
-		return (sih->chipst & CST4329_SPROM_SEL) != 0;
-	case BCM4319_CHIP_ID:
-		return (sih->chipst & CST4319_SPROM_SEL) != 0;
-	case BCM4336_CHIP_ID:
-		return (sih->chipst & CST4336_SPROM_PRESENT) != 0;
-	case BCM4330_CHIP_ID:
-		return (sih->chipst & CST4330_SPROM_PRESENT) != 0;
 	case BCM4313_CHIP_ID:
 		return (sih->chipst & CST4313_SPROM_PRESENT) != 0;
-	case BCM4331_CHIP_ID:
-		return (sih->chipst & CST4331_SPROM_PRESENT) != 0;
 	default:
 		return true;
 	}
@@ -2303,26 +2268,11 @@ bool ai_is_sprom_available(struct si_pub *sih)
 bool ai_is_otp_disabled(struct si_pub *sih)
 {
 	switch (sih->chip) {
-	case BCM4329_CHIP_ID:
-		return (sih->chipst & CST4329_SPROM_OTP_SEL_MASK) ==
-		    CST4329_OTP_PWRDN;
-	case BCM4319_CHIP_ID:
-		return (sih->chipst & CST4319_SPROM_OTP_SEL_MASK) ==
-		    CST4319_OTP_PWRDN;
-	case BCM4336_CHIP_ID:
-		return (sih->chipst & CST4336_OTP_PRESENT) == 0;
-	case BCM4330_CHIP_ID:
-		return (sih->chipst & CST4330_OTP_PRESENT) == 0;
 	case BCM4313_CHIP_ID:
 		return (sih->chipst & CST4313_OTP_PRESENT) == 0;
 		/* These chips always have their OTP on */
 	case BCM43224_CHIP_ID:
 	case BCM43225_CHIP_ID:
-	case BCM43421_CHIP_ID:
-	case BCM43235_CHIP_ID:
-	case BCM43236_CHIP_ID:
-	case BCM43238_CHIP_ID:
-	case BCM4331_CHIP_ID:
 	default:
 		return false;
 	}
diff --git a/drivers/staging/brcm80211/brcmsmac/bmac.c b/drivers/staging/brcm80211/brcmsmac/bmac.c
index f8878c7..735230f 100644
--- a/drivers/staging/brcm80211/brcmsmac/bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/bmac.c
@@ -1980,8 +1980,7 @@ bool brcms_b_radio_read_hwdisabled(struct brcms_c_hw_info *wlc_hw)
 
 		/* AI chip doesn't restore bar0win2 on hibernation/resume, need sw fixup */
 		if ((wlc_hw->sih->chip == BCM43224_CHIP_ID) ||
-		    (wlc_hw->sih->chip == BCM43225_CHIP_ID) ||
-		    (wlc_hw->sih->chip == BCM43421_CHIP_ID))
+		    (wlc_hw->sih->chip == BCM43225_CHIP_ID))
 			wlc_hw->regs =
 			    (d11regs_t *) ai_setcore(wlc_hw->sih, D11_CORE_ID,
 						     0);
@@ -2022,8 +2021,7 @@ void brcms_b_hw_up(struct brcms_c_hw_info *wlc_hw)
 
 		/* AI chip doesn't restore bar0win2 on hibernation/resume, need sw fixup */
 		if ((wlc_hw->sih->chip == BCM43224_CHIP_ID) ||
-		    (wlc_hw->sih->chip == BCM43225_CHIP_ID) ||
-		    (wlc_hw->sih->chip == BCM43421_CHIP_ID))
+		    (wlc_hw->sih->chip == BCM43225_CHIP_ID))
 			wlc_hw->regs =
 			    (d11regs_t *) ai_setcore(wlc_hw->sih, D11_CORE_ID,
 						     0);
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 611873c..ca9f195 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -1586,15 +1586,7 @@ void *brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 
 	/* initialize radio_mpc_disable according to wlc->mpc */
 	brcms_c_radio_mpc_upd(wlc);
-
-	if ((wlc->pub->sih->chip) == BCM43235_CHIP_ID) {
-		if ((getintvar(wlc->pub->vars, "aa2g") == 7) ||
-		    (getintvar(wlc->pub->vars, "aa5g") == 7)) {
-			brcms_b_antsel_set(wlc->hw, 1);
-		}
-	} else {
-		brcms_b_antsel_set(wlc->hw, wlc->asi->antsel_avail);
-	}
+	brcms_b_antsel_set(wlc->hw, wlc->asi->antsel_avail);
 
 	if (perr)
 		*perr = 0;
-- 
1.7.1


