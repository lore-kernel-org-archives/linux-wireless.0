Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2291 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758814Ab1FALq3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:29 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 42/83] staging: brcm80211: remove dependency on pci core
 difinitions from aiutils.c
Date: Wed, 1 Jun 2011 13:45:27 +0200
Message-ID: <1306928768-7501-42-git-send-email-rvossen@broadcom.com> (sfid-20110601_134937_612924_0F3028F5)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The file aiutils.c included the register definition includes for the
PCI and PCIe core. This was for two functions which have been partly
moved to nicpci.c. This means that nicpci.h is the only include file
to provide interface to aiutils.c for PCI core related functions.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.c |   41 +++------------------
 drivers/staging/brcm80211/brcmsmac/nicpci.c  |   50 ++++++++++++++++++++++++++
 drivers/staging/brcm80211/brcmsmac/nicpci.h  |    2 +
 3 files changed, 58 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index bae40fe..43320b4 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -27,8 +27,6 @@
 #include <bcmdevs.h>
 
 /* ********** from siutils.c *********** */
-#include <pci_core.h>
-#include <pcie_core.h>
 #include <nicpci.h>
 #include <bcmnvram.h>
 #include <bcmsrom.h>
@@ -1915,7 +1913,7 @@ void ai_pci_down(si_t *sih)
 void ai_pci_setup(si_t *sih, uint coremask)
 {
 	si_info_t *sii;
-	struct sbpciregs *pciregs = NULL;
+	void *regs = NULL;
 	u32 siflag = 0, w;
 	uint idx = 0;
 
@@ -1932,7 +1930,7 @@ void ai_pci_setup(si_t *sih, uint coremask)
 		siflag = ai_flag(sih);
 
 		/* switch over to pci core */
-		pciregs = ai_setcoreidx(sih, sii->pub.buscoreidx);
+		regs = ai_setcoreidx(sih, sii->pub.buscoreidx);
 	}
 
 	/*
@@ -1950,16 +1948,7 @@ void ai_pci_setup(si_t *sih, uint coremask)
 	}
 
 	if (PCI(sii)) {
-		OR_REG(&pciregs->sbtopci2,
-		       (SBTOPCI_PREF | SBTOPCI_BURST));
-		if (sii->pub.buscorerev >= 11) {
-			OR_REG(&pciregs->sbtopci2,
-			       SBTOPCI_RC_READMULTI);
-			w = R_REG(&pciregs->clkrun);
-			W_REG(&pciregs->clkrun,
-			      (w | PCI_CLKRUN_DSBL));
-			w = R_REG(&pciregs->clkrun);
-		}
+		pcicore_pci_setup(sii->pch, regs);
 
 		/* switch back to previous core */
 		ai_setcoreidx(sih, idx);
@@ -1972,11 +1961,8 @@ void ai_pci_setup(si_t *sih, uint coremask)
  */
 int ai_pci_fixcfg(si_t *sih)
 {
-	uint origidx, pciidx;
-	struct sbpciregs *pciregs = NULL;
-	sbpcieregs_t *pcieregs = NULL;
+	uint origidx;
 	void *regs = NULL;
-	u16 val16, *reg16 = NULL;
 
 	si_info_t *sii = SI_INFO(sih);
 
@@ -1985,23 +1971,8 @@ int ai_pci_fixcfg(si_t *sih)
 	origidx = ai_coreidx(&sii->pub);
 
 	/* check 'pi' is correct and fix it if not */
-	if (sii->pub.buscoretype == PCIE_CORE_ID) {
-		pcieregs = ai_setcore(&sii->pub, PCIE_CORE_ID, 0);
-		regs = pcieregs;
-		reg16 = &pcieregs->sprom[SRSH_PI_OFFSET];
-	} else if (sii->pub.buscoretype == PCI_CORE_ID) {
-		pciregs = ai_setcore(&sii->pub, PCI_CORE_ID, 0);
-		regs = pciregs;
-		reg16 = &pciregs->sprom[SRSH_PI_OFFSET];
-	}
-	pciidx = ai_coreidx(&sii->pub);
-	val16 = R_REG(reg16);
-	if (((val16 & SRSH_PI_MASK) >> SRSH_PI_SHIFT) != (u16) pciidx) {
-		val16 =
-		    (u16) (pciidx << SRSH_PI_SHIFT) | (val16 &
-							  ~SRSH_PI_MASK);
-		W_REG(reg16, val16);
-	}
+	regs = ai_setcore(&sii->pub, sii->pub.buscoretype, 0);
+	pcicore_fixcfg(sii->pch, regs);
 
 	/* restore the original index */
 	ai_setcoreidx(&sii->pub, origidx);
diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.c b/drivers/staging/brcm80211/brcmsmac/nicpci.c
index 196cdf1..c509c9a 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.c
@@ -654,3 +654,53 @@ void pcicore_down(void *pch, int state)
 	/* Reduce L1 timer for better power savings */
 	pcie_extendL1timer(pi, false);
 }
+
+/*
+ * precondition: current core is sii->buscoretype
+ */
+void pcicore_fixcfg(void *pch, void *regs)
+{
+	pcicore_info_t *pi = (pcicore_info_t *) pch;
+	struct si_info *sii = SI_INFO(pi->sih);
+	struct sbpciregs *pciregs = regs;
+	sbpcieregs_t *pcieregs = regs;
+	u16 val16, *reg16 = NULL;
+	uint pciidx;
+
+	/* check 'pi' is correct and fix it if not */
+	if (sii->pub.buscoretype == PCIE_CORE_ID) {
+		reg16 = &pcieregs->sprom[SRSH_PI_OFFSET];
+	} else if (sii->pub.buscoretype == PCI_CORE_ID) {
+		reg16 = &pciregs->sprom[SRSH_PI_OFFSET];
+	}
+	pciidx = ai_coreidx(&sii->pub);
+	val16 = R_REG(reg16);
+	if (((val16 & SRSH_PI_MASK) >> SRSH_PI_SHIFT) != (u16) pciidx) {
+		val16 =
+		    (u16) (pciidx << SRSH_PI_SHIFT) | (val16 &
+							  ~SRSH_PI_MASK);
+		W_REG(reg16, val16);
+	}
+}
+
+/*
+ * precondition: current core is pci core
+ */
+void pcicore_pci_setup(void *pch, void *regs)
+{
+	pcicore_info_t *pi = (pcicore_info_t *) pch;
+	struct sbpciregs *pciregs = regs;
+	u32 w;
+
+	OR_REG(&pciregs->sbtopci2,
+	       (SBTOPCI_PREF | SBTOPCI_BURST));
+
+	if (SI_INFO(pi->sih)->pub.buscorerev >= 11) {
+		OR_REG(&pciregs->sbtopci2,
+		       SBTOPCI_RC_READMULTI);
+		w = R_REG(&pciregs->clkrun);
+		W_REG(&pciregs->clkrun,
+		      (w | PCI_CLKRUN_DSBL));
+		w = R_REG(&pciregs->clkrun);
+	}
+}
diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.h b/drivers/staging/brcm80211/brcmsmac/nicpci.h
index b32f1af..f1441c5 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.h
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.h
@@ -67,5 +67,7 @@ extern void pcicore_sleep(void *pch);
 extern void pcicore_down(void *pch, int state);
 extern u8 pcicore_find_pci_capability(void *dev, u8 req_cap_id,
 					 unsigned char *buf, u32 *buflen);
+extern void pcicore_fixcfg(void *pch, void *regs);
+extern void pcicore_pci_setup(void *pch, void *regs);
 
 #endif /* _NICPCI_H */
-- 
1.7.4.1


