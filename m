Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2705 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753297Ab1HONei (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 09:34:38 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 01/15] staging: brcm80211: got rid of several void
 pointers for softmac PCI
Date: Mon, 15 Aug 2011 15:34:13 +0200
Message-ID: <1313415267-5264-2-git-send-email-arend@broadcom.com> (sfid-20110815_153445_979548_69A0399C)
In-Reply-To: <1313415267-5264-1-git-send-email-arend@broadcom.com>
References: <1313415267-5264-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. Replace void * related to PCI functionality by less generic
pointer types.

Reported-by: Julian Calaby <julian.calaby@gmail.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.c |   10 +++--
 drivers/staging/brcm80211/brcmsmac/aiutils.h |    2 +-
 drivers/staging/brcm80211/brcmsmac/dma.c     |    2 +-
 drivers/staging/brcm80211/brcmsmac/nicpci.c  |   61 +++++++++++---------------
 drivers/staging/brcm80211/brcmsmac/nicpci.h  |   30 ++++++++-----
 5 files changed, 53 insertions(+), 52 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index 3d392a3..c9c41a5 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -1850,7 +1850,7 @@ int ai_devpath(struct si_pub *sih, char *path, int size)
 		return -1;
 
 	slen = snprintf(path, (size_t) size, "pci/%u/%u/",
-		((struct pci_dev *)((SI_INFO(sih))->pbus))->bus->number,
+		(((SI_INFO(sih))->pbus))->bus->number,
 		PCI_SLOT(((struct pci_dev *)((SI_INFO(sih))->pbus))->devfn));
 
 	if (slen < 0 || slen >= size) {
@@ -2025,8 +2025,7 @@ void ai_pci_setup(struct si_pub *sih, uint coremask)
 int ai_pci_fixcfg(struct si_pub *sih)
 {
 	uint origidx;
-	struct sbpciregs *regs = NULL;
-
+	void *regs = NULL;
 	struct si_info *sii = SI_INFO(sih);
 
 	/* Fixup PI in SROM shadow area to enable the correct PCI core access */
@@ -2035,7 +2034,10 @@ int ai_pci_fixcfg(struct si_pub *sih)
 
 	/* check 'pi' is correct and fix it if not */
 	regs = ai_setcore(&sii->pub, sii->pub.buscoretype, 0);
-	pcicore_fixcfg(sii->pch, regs);
+	if (sii->pub.buscoretype == PCIE_CORE_ID)
+		pcicore_fixcfg_pcie(sii->pch, (struct sbpcieregs *)regs);
+	else if (sii->pub.buscoretype == PCI_CORE_ID)
+		pcicore_fixcfg_pci(sii->pch, (struct sbpciregs *)regs);
 
 	/* restore the original index */
 	ai_setcoreidx(&sii->pub, origidx);
diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.h b/drivers/staging/brcm80211/brcmsmac/aiutils.h
index 84c6901..7ea42af 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.h
@@ -459,7 +459,7 @@ struct gpioh_item {
 /* misc si info needed by some of the routines */
 struct si_info {
 	struct si_pub pub;	/* back plane public state (must be first) */
-	void *pbus;		/* handle to bus (pci/sdio/..) */
+	struct pci_dev *pbus;	/* handle to pci bus */
 	uint dev_coreid;	/* the core provides driver functions */
 	void *intr_arg;		/* interrupt callback function arg */
 	u32 (*intrsoff_fn) (void *intr_arg); /* turns chip interrupts off */
diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index 64d7639..10a25d2 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -252,7 +252,7 @@ struct dma_info {
 	uint *msg_level;	/* message level pointer */
 	char name[MAXNAMEL];	/* callers name for diag msgs */
 
-	void *pbus;		/* bus handle */
+	struct pci_dev *pbus;		/* bus handle */
 
 	bool dma64;	/* this dma engine is operating in 64-bit mode */
 	bool addrext;	/* this dma engine supports DmaExtendedAddrChanges */
diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.c b/drivers/staging/brcm80211/brcmsmac/nicpci.c
index 8249ea9..2d46e70 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.c
@@ -245,7 +245,8 @@ static void pcie_war_pci_setup(struct pcicore_info *pi);
 /* Initialize the PCI core.
  * It's caller's responsibility to make sure that this is done only once
  */
-void *pcicore_init(struct si_pub *sih, void *pdev, void *regs)
+struct pcicore_info *pcicore_init(struct si_pub *sih, struct pci_dev *pdev,
+				  void *regs)
 {
 	struct pcicore_info *pi;
 
@@ -271,7 +272,7 @@ void *pcicore_init(struct si_pub *sih, void *pdev, void *regs)
 	return pi;
 }
 
-void pcicore_deinit(void *pch)
+void pcicore_deinit(struct pcicore_info *pch)
 {
 	kfree(pch);
 }
@@ -279,7 +280,7 @@ void pcicore_deinit(void *pch)
 /* return cap_offset if requested capability exists in the PCI config space */
 /* Note that it's caller's responsibility to make sure it's a pci bus */
 u8
-pcicore_find_pci_capability(void *dev, u8 req_cap_id,
+pcicore_find_pci_capability(struct pci_dev *dev, u8 req_cap_id,
 			    unsigned char *buf, u32 *buflen)
 {
 	u8 cap_id;
@@ -484,9 +485,8 @@ pcie_mdiowrite(struct pcicore_info *pi, uint physmedia, uint regaddr, uint val)
 }
 
 /* ***** Support functions ***** */
-static u8 pcie_clkreq(void *pch, u32 mask, u32 val)
+static u8 pcie_clkreq(struct pcicore_info *pi, u32 mask, u32 val)
 {
-	struct pcicore_info *pi = pch;
 	u32 reg_val;
 	u8 offset;
 
@@ -536,7 +536,7 @@ static void pcie_clkreq_upd(struct pcicore_info *pi, uint state)
 	switch (state) {
 	case SI_DOATTACH:
 		if (PCIE_ASPM(sih))
-			pcie_clkreq((void *)pi, 1, 0);
+			pcie_clkreq(pi, 1, 0);
 		break;
 	case SI_PCIDOWN:
 		if (sih->buscorerev == 6) {	/* turn on serdes PLL down */
@@ -547,7 +547,7 @@ static void pcie_clkreq_upd(struct pcicore_info *pi, uint state)
 				   offsetof(struct chipcregs, chipcontrol_data),
 				   ~0x40, 0);
 		} else if (pi->pcie_pr42767) {
-			pcie_clkreq((void *)pi, 1, 1);
+			pcie_clkreq(pi, 1, 1);
 		}
 		break;
 	case SI_PCIUP:
@@ -559,7 +559,7 @@ static void pcie_clkreq_upd(struct pcicore_info *pi, uint state)
 				   offsetof(struct chipcregs, chipcontrol_data),
 				   ~0x40, 0x40);
 		} else if (PCIE_ASPM(sih)) {	/* disable clkreq */
-			pcie_clkreq((void *)pi, 1, 0);
+			pcie_clkreq(pi, 1, 0);
 		}
 		break;
 	}
@@ -729,9 +729,8 @@ static void pcie_war_pci_setup(struct pcicore_info *pi)
 }
 
 /* ***** Functions called during driver state changes ***** */
-void pcicore_attach(void *pch, char *pvars, int state)
+void pcicore_attach(struct pcicore_info *pi, char *pvars, int state)
 {
-	struct pcicore_info *pi = pch;
 	struct si_pub *sih = pi->sih;
 
 	/* Determine if this board needs override */
@@ -753,20 +752,16 @@ void pcicore_attach(void *pch, char *pvars, int state)
 
 }
 
-void pcicore_hwup(void *pch)
+void pcicore_hwup(struct pcicore_info *pi)
 {
-	struct pcicore_info *pi = pch;
-
 	if (!pi || !PCIE_PUB(pi->sih))
 		return;
 
 	pcie_war_pci_setup(pi);
 }
 
-void pcicore_up(void *pch, int state)
+void pcicore_up(struct pcicore_info *pi, int state)
 {
-	struct pcicore_info *pi = pch;
-
 	if (!pi || !PCIE_PUB(pi->sih))
 		return;
 
@@ -779,9 +774,8 @@ void pcicore_up(void *pch, int state)
 /* When the device is going to enter D3 state
  * (or the system is going to enter S3/S4 states)
  */
-void pcicore_sleep(void *pch)
+void pcicore_sleep(struct pcicore_info *pi)
 {
-	struct pcicore_info *pi = pch;
 	u32 w;
 
 	if (!pi || !PCIE_ASPM(pi->sih))
@@ -794,10 +788,8 @@ void pcicore_sleep(void *pch)
 	pi->pcie_pr42767 = false;
 }
 
-void pcicore_down(void *pch, int state)
+void pcicore_down(struct pcicore_info *pi, int state)
 {
-	struct pcicore_info *pi = pch;
-
 	if (!pi || !PCIE_PUB(pi->sih))
 		return;
 
@@ -808,21 +800,12 @@ void pcicore_down(void *pch, int state)
 }
 
 /* precondition: current core is sii->buscoretype */
-void pcicore_fixcfg(void *pch, void *regs)
+static void pcicore_fixcfg(struct pcicore_info *pi, u16 *reg16)
 {
-	struct pcicore_info *pi = pch;
 	struct si_info *sii = SI_INFO(pi->sih);
-	struct sbpciregs *pciregs = regs;
-	struct sbpcieregs *pcieregs = regs;
-	u16 val16, *reg16 = NULL;
+	u16 val16;
 	uint pciidx;
 
-	/* check 'pi' is correct and fix it if not */
-	if (sii->pub.buscoretype == PCIE_CORE_ID)
-		reg16 = &pcieregs->sprom[SRSH_PI_OFFSET];
-	else if (sii->pub.buscoretype == PCI_CORE_ID)
-		reg16 = &pciregs->sprom[SRSH_PI_OFFSET];
-
 	pciidx = ai_coreidx(&sii->pub);
 	val16 = R_REG(reg16);
 	if (((val16 & SRSH_PI_MASK) >> SRSH_PI_SHIFT) != (u16)pciidx) {
@@ -832,11 +815,19 @@ void pcicore_fixcfg(void *pch, void *regs)
 	}
 }
 
+void pcicore_fixcfg_pci(struct pcicore_info *pi, struct sbpciregs *pciregs)
+{
+	pcicore_fixcfg(pi, &pciregs->sprom[SRSH_PI_OFFSET]);
+}
+
+void pcicore_fixcfg_pcie(struct pcicore_info *pi, struct sbpcieregs *pcieregs)
+{
+	pcicore_fixcfg(pi, &pcieregs->sprom[SRSH_PI_OFFSET]);
+}
+
 /* precondition: current core is pci core */
-void pcicore_pci_setup(void *pch, void *regs)
+void pcicore_pci_setup(struct pcicore_info *pi, struct sbpciregs *pciregs)
 {
-	struct pcicore_info *pi = pch;
-	struct sbpciregs *pciregs = regs;
 	u32 w;
 
 	OR_REG(&pciregs->sbtopci2, SBTOPCI_PREF | SBTOPCI_BURST);
diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.h b/drivers/staging/brcm80211/brcmsmac/nicpci.h
index f71f842..3082db0 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.h
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.h
@@ -70,16 +70,24 @@
 #define SRSH_PI_MASK	0xf000	/* bit 15:12 */
 #define SRSH_PI_SHIFT	12	/* bit 15:12 */
 
-extern void *pcicore_init(struct si_pub *sih, void *pdev, void *regs);
-extern void pcicore_deinit(void *pch);
-extern void pcicore_attach(void *pch, char *pvars, int state);
-extern void pcicore_hwup(void *pch);
-extern void pcicore_up(void *pch, int state);
-extern void pcicore_sleep(void *pch);
-extern void pcicore_down(void *pch, int state);
-extern u8 pcicore_find_pci_capability(void *dev, u8 req_cap_id,
-					 unsigned char *buf, u32 *buflen);
-extern void pcicore_fixcfg(void *pch, void *regs);
-extern void pcicore_pci_setup(void *pch, void *regs);
+struct sbpciregs;
+struct sbpcieregs;
+
+extern struct pcicore_info *pcicore_init(struct si_pub *sih,
+					 struct pci_dev *pdev, void *regs);
+extern void pcicore_deinit(struct pcicore_info *pch);
+extern void pcicore_attach(struct pcicore_info *pch, char *pvars, int state);
+extern void pcicore_hwup(struct pcicore_info *pch);
+extern void pcicore_up(struct pcicore_info *pch, int state);
+extern void pcicore_sleep(struct pcicore_info *pch);
+extern void pcicore_down(struct pcicore_info *pch, int state);
+extern u8 pcicore_find_pci_capability(struct pci_dev *dev, u8 req_cap_id,
+				      unsigned char *buf, u32 *buflen);
+extern void pcicore_fixcfg_pci(struct pcicore_info *pch,
+			       struct sbpciregs *pciregs);
+extern void pcicore_fixcfg_pcie(struct pcicore_info *pch,
+				struct sbpcieregs *pciregs);
+extern void pcicore_pci_setup(struct pcicore_info *pch,
+			      struct sbpciregs *pciregs);
 
 #endif /* _BRCM_NICPCI_H_ */
-- 
1.7.4.1


