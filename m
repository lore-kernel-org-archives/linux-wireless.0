Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2126 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345Ab1IBOA6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Sep 2011 10:00:58 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 07/12] staging: brcm80211: cleaned up softmac
 nicpci.c/nicpci.h macro's
Date: Fri, 2 Sep 2011 16:00:34 +0200
Message-ID: <1314972039-27098-8-git-send-email-rvossen@broadcom.com> (sfid-20110902_160115_577860_F84EFA8B)
In-Reply-To: <1314972039-27098-1-git-send-email-rvossen@broadcom.com>
References: <1314972039-27098-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Substituted macro's.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/nicpci.c |   42 ++++++++++++++++-----------
 drivers/staging/brcm80211/brcmsmac/nicpci.h |   12 -------
 2 files changed, 25 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.c b/drivers/staging/brcm80211/brcmsmac/nicpci.c
index 6bffca0..a2cab5c 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.c
@@ -127,6 +127,18 @@
 /* PCIE protocol TLP diagnostic registers */
 #define PCIE_TLP_WORKAROUNDSREG		0x004	/* TLP Workarounds */
 
+/* Sonics to PCI translation types */
+#define	SBTOPCI_PREF	0x4		/* prefetch enable */
+#define	SBTOPCI_BURST	0x8		/* burst enable */
+#define	SBTOPCI_RC_READMULTI	0x20	/* memory read multiple */
+
+#define PCI_CLKRUN_DSBL	0x8000	/* Bit 15 forceClkrun */
+
+/* PCI core index in SROM shadow area */
+#define SRSH_PI_OFFSET	0	/* first word */
+#define SRSH_PI_MASK	0xf000	/* bit 15:12 */
+#define SRSH_PI_SHIFT	12	/* bit 15:12 */
+
 /* Sonics side: PCI core and host control registers */
 struct sbpciregs {
 	u32 control;		/* PCI control */
@@ -211,18 +223,17 @@ struct pcicore_info {
 	bool pmecap;		/* Capable of generating PME */
 };
 
-/* debug/trace */
-#define	PCI_ERROR(args)
-#define PCIE_PUB(sih) ((sih)->buscoretype == PCIE_CORE_ID)
-
 #define PCIE_ASPM(sih)							\
-	((PCIE_PUB(sih)) &&						\
+	(((sih)->buscoretype == PCIE_CORE_ID) &&			\
 	 (((sih)->buscorerev >= 3) &&					\
 	  ((sih)->buscorerev <= 5)))
 
 
 /* delay needed between the mdio control/ mdiodata register data access */
-#define PR28829_DELAY() udelay(10)
+static void pr28829_delay(void)
+{
+	udelay(10);
+}
 
 /* Initialize the PCI core.
  * It's caller's responsibility to make sure that this is done only once
@@ -235,7 +246,6 @@ struct pcicore_info *pcicore_init(struct si_pub *sih, struct pci_dev *pdev,
 	/* alloc struct pcicore_info */
 	pi = kzalloc(sizeof(struct pcicore_info), GFP_ATOMIC);
 	if (pi == NULL) {
-		PCI_ERROR(("pci_attach: malloc failed!\n"));
 		return NULL;
 	}
 
@@ -375,7 +385,7 @@ static bool pcie_mdiosetblock(struct pcicore_info *pi, uint blk)
 		    (blk << 4));
 	W_REG(&pcieregs->mdiodata, mdiodata);
 
-	PR28829_DELAY();
+	pr28829_delay();
 	/* retry till the transaction is complete */
 	while (i < pcie_serdes_spinwait) {
 		if (R_REG(&pcieregs->mdiocontrol) & MDIOCTL_ACCESS_DONE)
@@ -386,7 +396,6 @@ static bool pcie_mdiosetblock(struct pcicore_info *pi, uint blk)
 	}
 
 	if (i >= pcie_serdes_spinwait) {
-		PCI_ERROR(("pcie_mdiosetblock: timed out\n"));
 		return false;
 	}
 
@@ -427,13 +436,13 @@ pcie_mdioop(struct pcicore_info *pi, uint physmedia, uint regaddr, bool write,
 
 	W_REG(&pcieregs->mdiodata, mdiodata);
 
-	PR28829_DELAY();
+	pr28829_delay();
 
 	/* retry till the transaction is complete */
 	while (i < pcie_serdes_spinwait) {
 		if (R_REG(&pcieregs->mdiocontrol) & MDIOCTL_ACCESS_DONE) {
 			if (!write) {
-				PR28829_DELAY();
+				pr28829_delay();
 				*val = (R_REG(&pcieregs->mdiodata) &
 					MDIODATA_MASK);
 			}
@@ -445,8 +454,7 @@ pcie_mdioop(struct pcicore_info *pi, uint physmedia, uint regaddr, bool write,
 		i++;
 	}
 
-	PCI_ERROR(("pcie_mdioop: timed out op: %d\n", write));
-	/* Disable mdio access to SERDES */
+	/* Timed out. Disable mdio access to SERDES. */
 	W_REG(&pcieregs->mdiocontrol, 0);
 	return 1;
 }
@@ -498,7 +506,7 @@ static void pcie_extendL1timer(struct pcicore_info *pi, bool extend)
 	struct si_pub *sih = pi->sih;
 	struct sbpcieregs *pcieregs = pi->regs.pcieregs;
 
-	if (!PCIE_PUB(sih) || sih->buscorerev < 7)
+	if (sih->buscoretype != PCIE_CORE_ID || sih->buscorerev < 7)
 		return;
 
 	w = pcie_readreg(pcieregs, PCIE_PCIEREGS, PCIE_DLLP_PMTHRESHREG);
@@ -736,7 +744,7 @@ void pcicore_attach(struct pcicore_info *pi, char *pvars, int state)
 
 void pcicore_hwup(struct pcicore_info *pi)
 {
-	if (!pi || !PCIE_PUB(pi->sih))
+	if (!pi || pi->sih->buscoretype != PCIE_CORE_ID)
 		return;
 
 	pcie_war_pci_setup(pi);
@@ -744,7 +752,7 @@ void pcicore_hwup(struct pcicore_info *pi)
 
 void pcicore_up(struct pcicore_info *pi, int state)
 {
-	if (!pi || !PCIE_PUB(pi->sih))
+	if (!pi || pi->sih->buscoretype != PCIE_CORE_ID)
 		return;
 
 	/* Restore L1 timer for better performance */
@@ -772,7 +780,7 @@ void pcicore_sleep(struct pcicore_info *pi)
 
 void pcicore_down(struct pcicore_info *pi, int state)
 {
-	if (!pi || !PCIE_PUB(pi->sih))
+	if (!pi || pi->sih->buscoretype != PCIE_CORE_ID)
 		return;
 
 	pcie_clkreq_upd(pi, state);
diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.h b/drivers/staging/brcm80211/brcmsmac/nicpci.h
index 3082db0..4995203 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.h
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.h
@@ -58,18 +58,6 @@
 /* bar0 + 12K accesses chipc core registers */
 #define PCI_16KB0_CCREGS_OFFSET	(12 * 1024)
 
-#define PCI_CLKRUN_DSBL	0x8000	/* Bit 15 forceClkrun */
-
-/* Sonics to PCI translation types */
-#define	SBTOPCI_PREF	0x4		/* prefetch enable */
-#define	SBTOPCI_BURST	0x8		/* burst enable */
-#define	SBTOPCI_RC_READMULTI	0x20	/* memory read multiple */
-
-/* PCI core index in SROM shadow area */
-#define SRSH_PI_OFFSET	0	/* first word */
-#define SRSH_PI_MASK	0xf000	/* bit 15:12 */
-#define SRSH_PI_SHIFT	12	/* bit 15:12 */
-
 struct sbpciregs;
 struct sbpcieregs;
 
-- 
1.7.4.1


