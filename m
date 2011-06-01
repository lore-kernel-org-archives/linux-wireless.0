Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4862 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161311Ab1FALq1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:27 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 40/83] staging: brcm80211: remove unused functions from
 nicpci.c
Date: Wed, 1 Jun 2011 13:45:25 +0200
Message-ID: <1306928768-7501-40-git-send-email-rvossen@broadcom.com> (sfid-20110601_134649_899521_3DD4D5BA)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Several functions are defined but not used. These have been removed.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/nicpci.c |  182 ---------------------------
 drivers/staging/brcm80211/brcmsmac/nicpci.h |   19 +---
 2 files changed, 2 insertions(+), 199 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.c b/drivers/staging/brcm80211/brcmsmac/nicpci.c
index 4da155a..196cdf1 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.c
@@ -71,8 +71,6 @@ static void pcie_war_noplldown(pcicore_info_t *pi);
 static void pcie_war_polarity(pcicore_info_t *pi);
 static void pcie_war_pci_setup(pcicore_info_t *pi);
 
-static bool pcicore_pmecap(pcicore_info_t *pi);
-
 #define PCIE_ASPM(sih)	((PCIE_PUB(sih)) && (((sih)->buscorerev >= 3) && ((sih)->buscorerev <= 5)))
 
 
@@ -579,23 +577,6 @@ static void pcie_war_pci_setup(pcicore_info_t *pi)
 		pcie_misc_config_fixup(pi);
 }
 
-void pcie_war_ovr_aspm_update(void *pch, u8 aspm)
-{
-	pcicore_info_t *pi = (pcicore_info_t *) pch;
-
-	if (!PCIE_ASPM(pi->sih))
-		return;
-
-	/* Validate */
-	if (aspm > PCIE_ASPM_ENAB)
-		return;
-
-	pi->pcie_war_aspm_ovr = aspm;
-
-	/* Update the current state */
-	pcie_war_aspm_clkreq(pi);
-}
-
 /* ***** Functions called during driver state changes ***** */
 void pcicore_attach(void *pch, char *pvars, int state)
 {
@@ -673,166 +654,3 @@ void pcicore_down(void *pch, int state)
 	/* Reduce L1 timer for better power savings */
 	pcie_extendL1timer(pi, false);
 }
-
-/* ***** Wake-on-wireless-LAN (WOWL) support functions ***** */
-/* Just uses PCI config accesses to find out, when needed before sb_attach is done */
-bool pcicore_pmecap_fast(void *pch)
-{
-	pcicore_info_t *pi = (pcicore_info_t *) pch;
-	u8 cap_ptr;
-	u32 pmecap;
-
-	cap_ptr = pcicore_find_pci_capability(pi->dev, PCI_CAP_ID_PM, NULL,
-					      NULL);
-
-	if (!cap_ptr)
-		return false;
-
-	pci_read_config_dword(pi->dev, cap_ptr, &pmecap);
-
-	return (pmecap & (PCI_PM_CAP_PME_MASK << 16)) != 0;
-}
-
-/* return true if PM capability exists in the pci config space
- * Uses and caches the information using core handle
- */
-static bool pcicore_pmecap(pcicore_info_t *pi)
-{
-	u8 cap_ptr;
-	u32 pmecap;
-
-	if (!pi->pmecap_offset) {
-		cap_ptr = pcicore_find_pci_capability(pi->dev,
-						      PCI_CAP_ID_PM,
-						      NULL, NULL);
-		if (!cap_ptr)
-			return false;
-
-		pi->pmecap_offset = cap_ptr;
-
-		pci_read_config_dword(pi->dev, pi->pmecap_offset,
-					&pmecap);
-
-		/* At least one state can generate PME */
-		pi->pmecap = (pmecap & (PCI_PM_CAP_PME_MASK << 16)) != 0;
-	}
-
-	return pi->pmecap;
-}
-
-/* Enable PME generation */
-void pcicore_pmeen(void *pch)
-{
-	pcicore_info_t *pi = (pcicore_info_t *) pch;
-	u32 w;
-
-	/* if not pmecapable return */
-	if (!pcicore_pmecap(pi))
-		return;
-
-	pci_read_config_dword(pi->dev, pi->pmecap_offset + PCI_PM_CTRL,
-				&w);
-	w |= (PCI_PM_CTRL_PME_ENABLE);
-	pci_write_config_dword(pi->dev,
-				pi->pmecap_offset + PCI_PM_CTRL, w);
-}
-
-/*
- * Return true if PME status set
- */
-bool pcicore_pmestat(void *pch)
-{
-	pcicore_info_t *pi = (pcicore_info_t *) pch;
-	u32 w;
-
-	if (!pcicore_pmecap(pi))
-		return false;
-
-	pci_read_config_dword(pi->dev, pi->pmecap_offset + PCI_PM_CTRL,
-				&w);
-
-	return (w & PCI_PM_CTRL_PME_STATUS) == PCI_PM_CTRL_PME_STATUS;
-}
-
-/* Disable PME generation, clear the PME status bit if set
- */
-void pcicore_pmeclr(void *pch)
-{
-	pcicore_info_t *pi = (pcicore_info_t *) pch;
-	u32 w;
-
-	if (!pcicore_pmecap(pi))
-		return;
-
-	pci_read_config_dword(pi->dev, pi->pmecap_offset + PCI_PM_CTRL,
-				&w);
-
-	PCI_ERROR(("pcicore_pci_pmeclr PMECSR : 0x%x\n", w));
-
-	/* PMESTAT is cleared by writing 1 to it */
-	w &= ~(PCI_PM_CTRL_PME_ENABLE);
-
-	pci_write_config_dword(pi->dev,
-				pi->pmecap_offset + PCI_PM_CTRL, w);
-}
-
-u32 pcie_lcreg(void *pch, u32 mask, u32 val)
-{
-	pcicore_info_t *pi = (pcicore_info_t *) pch;
-	u8 offset;
-	u32 tmpval;
-
-	offset = pi->pciecap_lcreg_offset;
-	if (!offset)
-		return 0;
-
-	/* set operation */
-	if (mask)
-		pci_write_config_dword(pi->dev, offset, val);
-
-	pci_read_config_dword(pi->dev, offset, &tmpval);
-	return tmpval;
-}
-
-u32
-pcicore_pciereg(void *pch, u32 offset, u32 mask, u32 val, uint type)
-{
-	u32 reg_val = 0;
-	pcicore_info_t *pi = (pcicore_info_t *) pch;
-	sbpcieregs_t *pcieregs = pi->regs.pcieregs;
-
-	if (mask) {
-		PCI_ERROR(("PCIEREG: 0x%x writeval  0x%x\n", offset, val));
-		pcie_writereg(pcieregs, type, offset, val);
-	}
-
-	/* Should not read register 0x154 */
-	if (pi->sih->buscorerev <= 5 && offset == PCIE_DLLP_PCIE11
-	    && type == PCIE_PCIEREGS)
-		return reg_val;
-
-	reg_val = pcie_readreg(pcieregs, type, offset);
-	PCI_ERROR(("PCIEREG: 0x%x readval is 0x%x\n", offset, reg_val));
-
-	return reg_val;
-}
-
-u32
-pcicore_pcieserdesreg(void *pch, u32 mdioslave, u32 offset, u32 mask,
-		      u32 val)
-{
-	u32 reg_val = 0;
-	pcicore_info_t *pi = (pcicore_info_t *) pch;
-
-	if (mask) {
-		PCI_ERROR(("PCIEMDIOREG: 0x%x writeval  0x%x\n", offset, val));
-		pcie_mdiowrite(pi, mdioslave, offset, val);
-	}
-
-	if (pcie_mdioread(pi, mdioslave, offset, &reg_val))
-		reg_val = 0xFFFFFFFF;
-	PCI_ERROR(("PCIEMDIOREG: dev 0x%x offset 0x%x read 0x%x\n", mdioslave,
-		   offset, reg_val));
-
-	return reg_val;
-}
diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.h b/drivers/staging/brcm80211/brcmsmac/nicpci.h
index a6baf7f..b32f1af 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.h
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.h
@@ -58,11 +58,6 @@
 
 struct si_pub;
 
-extern u8 pcicore_find_pci_capability(void *dev, u8 req_cap_id,
-					 unsigned char *buf, u32 *buflen);
-
-extern u32 pcie_lcreg(void *pch, u32 mask, u32 val);
-
 extern void *pcicore_init(struct si_pub *sih, void *pdev, void *regs);
 extern void pcicore_deinit(void *pch);
 extern void pcicore_attach(void *pch, char *pvars, int state);
@@ -70,17 +65,7 @@ extern void pcicore_hwup(void *pch);
 extern void pcicore_up(void *pch, int state);
 extern void pcicore_sleep(void *pch);
 extern void pcicore_down(void *pch, int state);
-
-extern void pcie_war_ovr_aspm_update(void *pch, u8 aspm);
-extern u32 pcicore_pcieserdesreg(void *pch, u32 mdioslave, u32 offset,
-				    u32 mask, u32 val);
-
-extern u32 pcicore_pciereg(void *pch, u32 offset, u32 mask,
-			      u32 val, uint type);
-
-extern bool pcicore_pmecap_fast(void *pch);
-extern void pcicore_pmeen(void *pch);
-extern void pcicore_pmeclr(void *pch);
-extern bool pcicore_pmestat(void *pch);
+extern u8 pcicore_find_pci_capability(void *dev, u8 req_cap_id,
+					 unsigned char *buf, u32 *buflen);
 
 #endif /* _NICPCI_H */
-- 
1.7.4.1


