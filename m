Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2177 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530Ab1LHXHR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 18:07:17 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 08/23] brcm80211: smac: move fields from struct si_pub
 to struct si_info
Date: Thu, 8 Dec 2011 15:06:44 -0800
Message-ID: <1323385619-7454-9-git-send-email-frankyl@broadcom.com> (sfid-20111209_000823_620907_F7CF4E9B)
In-Reply-To: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
References: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The structure si_pub contained couple of fields that were only
used internally in aiutils.c. These have been moved to the
si_info structure.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |   24 +++++++++++---------
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h |    4 +-
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index 66c79f1..8586ab7 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -928,7 +928,7 @@ ai_buscore_setup(struct si_info *sii, u32 savewin, uint *origidx)
 
 	/* get chipcommon chipstatus */
 	if (sii->pub.ccrev >= 11)
-		sii->pub.chipst = R_REG(&cc->chipstatus);
+		sii->chipst = R_REG(&cc->chipstatus);
 
 	/* get chipcommon capabilites */
 	sii->pub.cccaps = R_REG(&cc->capabilities);
@@ -942,7 +942,7 @@ ai_buscore_setup(struct si_info *sii, u32 savewin, uint *origidx)
 	/* figure out bus/orignal core idx */
 	sii->pub.buscoretype = NODEV_CORE_ID;
 	sii->pub.buscorerev = NOREV;
-	sii->pub.buscoreidx = BADIDX;
+	sii->buscoreidx = BADIDX;
 
 	pci = pcie = false;
 	pcirev = pcierev = NOREV;
@@ -980,11 +980,11 @@ ai_buscore_setup(struct si_info *sii, u32 savewin, uint *origidx)
 	if (pci) {
 		sii->pub.buscoretype = PCI_CORE_ID;
 		sii->pub.buscorerev = pcirev;
-		sii->pub.buscoreidx = pciidx;
+		sii->buscoreidx = pciidx;
 	} else if (pcie) {
 		sii->pub.buscoretype = PCIE_CORE_ID;
 		sii->pub.buscorerev = pcierev;
-		sii->pub.buscoreidx = pcieidx;
+		sii->buscoreidx = pcieidx;
 	}
 
 	/* fixup necessary chip/core configurations */
@@ -1034,7 +1034,7 @@ static struct si_info *ai_doattach(struct si_info *sii,
 
 	savewin = 0;
 
-	sih->buscoreidx = BADIDX;
+	sii->buscoreidx = BADIDX;
 
 	sii->curmap = regs;
 	sii->pbus = pbus;
@@ -1372,7 +1372,7 @@ uint ai_corereg(struct si_pub *sih, uint coreidx, uint regoff, uint mask,
 		fast = true;
 		r = (u32 __iomem *)((__iomem char *)sii->curmap +
 				    PCI_16KB0_CCREGS_OFFSET + regoff);
-	} else if (sii->pub.buscoreidx == coreidx) {
+	} else if (sii->buscoreidx == coreidx) {
 		/*
 		 * pci registers are at either in the last 2KB of
 		 * an 8KB window or, in pcie and pci rev 13 at 8KB
@@ -1904,7 +1904,7 @@ void ai_pci_setup(struct si_pub *sih, uint coremask)
 		siflag = ai_flag(sih);
 
 		/* switch over to pci core */
-		regs = ai_setcoreidx(sih, sii->pub.buscoreidx);
+		regs = ai_setcoreidx(sih, sii->buscoreidx);
 	}
 
 	/*
@@ -2035,8 +2035,9 @@ bool ai_deviceremoved(struct si_pub *sih)
 
 bool ai_is_sprom_available(struct si_pub *sih)
 {
+	struct si_info *sii = (struct si_info *)sih;
+
 	if (sih->ccrev >= 31) {
-		struct si_info *sii;
 		uint origidx;
 		struct chipcregs __iomem *cc;
 		u32 sromctrl;
@@ -2044,7 +2045,6 @@ bool ai_is_sprom_available(struct si_pub *sih)
 		if ((sih->cccaps & CC_CAP_SROM) == 0)
 			return false;
 
-		sii = (struct si_info *)sih;
 		origidx = sii->curidx;
 		cc = ai_setcoreidx(sih, SI_CC_IDX);
 		sromctrl = R_REG(&cc->sromcontrol);
@@ -2054,7 +2054,7 @@ bool ai_is_sprom_available(struct si_pub *sih)
 
 	switch (sih->chip) {
 	case BCM4313_CHIP_ID:
-		return (sih->chipst & CST4313_SPROM_PRESENT) != 0;
+		return (sii->chipst & CST4313_SPROM_PRESENT) != 0;
 	default:
 		return true;
 	}
@@ -2062,9 +2062,11 @@ bool ai_is_sprom_available(struct si_pub *sih)
 
 bool ai_is_otp_disabled(struct si_pub *sih)
 {
+	struct si_info *sii = (struct si_info *)sih;
+
 	switch (sih->chip) {
 	case BCM4313_CHIP_ID:
-		return (sih->chipst & CST4313_OTP_PRESENT) == 0;
+		return (sii->chipst & CST4313_OTP_PRESENT) == 0;
 		/* These chips always have their OTP on */
 	case BCM43224_CHIP_ID:
 	case BCM43225_CHIP_ID:
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
index 1da9759..f049179 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
@@ -146,7 +146,6 @@
 struct si_pub {
 	uint buscoretype;	/* PCI_CORE_ID, PCIE_CORE_ID, PCMCIA_CORE_ID */
 	uint buscorerev;	/* buscore rev */
-	uint buscoreidx;	/* buscore index */
 	int ccrev;		/* chip common core rev */
 	u32 cccaps;		/* chip common capabilities */
 	int pmurev;		/* pmu core rev */
@@ -156,7 +155,6 @@ struct si_pub {
 	uint chip;		/* chip number */
 	uint chiprev;		/* chip revision */
 	uint chippkg;		/* chip package option */
-	u32 chipst;		/* chip status */
 };
 
 struct pci_dev;
@@ -188,7 +186,9 @@ struct si_info {
 	void __iomem *curmap;			/* current regs va */
 	void __iomem *regs[SI_MAXCORES];	/* other regs va */
 
+	u32 chipst;		/* chip status */
 	uint curidx;		/* current core index */
+	uint buscoreidx;	/* buscore index */
 	uint numcores;		/* # discovered cores */
 	uint coreid[SI_MAXCORES]; /* id of each core */
 	u32 coresba[SI_MAXCORES]; /* backplane address of each core */
-- 
1.7.5.4


