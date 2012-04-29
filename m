Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44938 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755106Ab2D2Avc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2012 20:51:32 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 05/19] brcmsmac: remove references to PCI
Date: Sun, 29 Apr 2012 02:50:29 +0200
Message-Id: <1335660643-26368-6-git-send-email-hauke@hauke-m.de> (sfid-20120429_025213_730032_D91AC9DE)
In-Reply-To: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
References: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are no devices which are using bcma and have a PCI bus, just a
PCIe bus or something else. bcma does not support PCI devices, so lets
also remove PCI support from brcmsmac. All devices currently supported
by brcmsmac are PCIe based.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |  126 +--------------------
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h |    1 -
 drivers/net/wireless/brcm80211/brcmsmac/main.c    |    3 -
 drivers/net/wireless/brcm80211/brcmsmac/nicpci.c  |   36 +-----
 drivers/net/wireless/brcm80211/brcmsmac/nicpci.h  |    1 -
 5 files changed, 6 insertions(+), 161 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index ebec0a2..bcefe67 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -320,7 +320,6 @@
 #define	IS_SIM(chippkg)	\
 	((chippkg == HDLSIM_PKG_ID) || (chippkg == HWSIM_PKG_ID))
 
-#define PCI(sih)	(ai_get_buscoretype(sih) == PCI_CORE_ID)
 #define PCIE(sih)	(ai_get_buscoretype(sih) == PCIE_CORE_ID)
 
 #define PCI_FORCEHT(sih) (PCIE(sih) && (ai_get_chip_id(sih) == BCM4716_CHIP_ID))
@@ -453,36 +452,9 @@ struct aidmp {
 	u32 componentid3;	/* 0xffc */
 };
 
-/* return true if PCIE capability exists in the pci config space */
-static bool ai_ispcie(struct si_info *sii)
-{
-	u8 cap_ptr;
-
-	cap_ptr =
-	    pcicore_find_pci_capability(sii->pcibus, PCI_CAP_ID_EXP, NULL,
-					NULL);
-	if (!cap_ptr)
-		return false;
-
-	return true;
-}
-
-static bool ai_buscore_prep(struct si_info *sii)
-{
-	/* kludge to enable the clock on the 4306 which lacks a slowclock */
-	if (!ai_ispcie(sii))
-		ai_clkctl_xtal(&sii->pub, XTAL | PLL, ON);
-	return true;
-}
-
 static bool
 ai_buscore_setup(struct si_info *sii, struct bcma_device *cc)
 {
-	struct bcma_device *pci = NULL;
-	struct bcma_device *pcie = NULL;
-	struct bcma_device *core;
-
-
 	/* no cores found, bail out */
 	if (cc->bus->nr_cores == 0)
 		return false;
@@ -504,30 +476,7 @@ ai_buscore_setup(struct si_info *sii, struct bcma_device *cc)
 	}
 
 	/* figure out buscore */
-	list_for_each_entry(core, &cc->bus->cores, list) {
-		uint cid, crev;
-
-		cid = core->id.id;
-		crev = core->id.rev;
-
-		if (cid == PCI_CORE_ID) {
-			pci = core;
-		} else if (cid == PCIE_CORE_ID) {
-			pcie = core;
-		}
-	}
-
-	if (pci && pcie) {
-		if (ai_ispcie(sii))
-			pci = NULL;
-		else
-			pcie = NULL;
-	}
-	if (pci) {
-		sii->buscore = pci;
-	} else if (pcie) {
-		sii->buscore = pcie;
-	}
+	sii->buscore = ai_findcore(&sii->pub, PCIE_CORE_ID, 0);
 
 	/* fixup necessary chip/core configurations */
 	if (!sii->pch) {
@@ -557,10 +506,6 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	/* switch to Chipcommon core */
 	cc = pbus->drv_cc.core;
 
-	/* bus/core/clk setup for register access */
-	if (!ai_buscore_prep(sii))
-		return NULL;
-
 	sih->chip = pbus->chipinfo.id;
 	sih->chiprev = pbus->chipinfo.rev;
 	sih->chippkg = pbus->chipinfo.pkg;
@@ -816,69 +761,6 @@ u16 ai_clkctl_fast_pwrup_delay(struct si_pub *sih)
 	return fpdelay;
 }
 
-/* turn primary xtal and/or pll off/on */
-int ai_clkctl_xtal(struct si_pub *sih, uint what, bool on)
-{
-	struct si_info *sii;
-	u32 in, out, outen;
-
-	sii = (struct si_info *)sih;
-
-	/* pcie core doesn't have any mapping to control the xtal pu */
-	if (PCIE(sih))
-		return -1;
-
-	pci_read_config_dword(sii->pcibus, PCI_GPIO_IN, &in);
-	pci_read_config_dword(sii->pcibus, PCI_GPIO_OUT, &out);
-	pci_read_config_dword(sii->pcibus, PCI_GPIO_OUTEN, &outen);
-
-	/*
-	 * Avoid glitching the clock if GPRS is already using it.
-	 * We can't actually read the state of the PLLPD so we infer it
-	 * by the value of XTAL_PU which *is* readable via gpioin.
-	 */
-	if (on && (in & PCI_CFG_GPIO_XTAL))
-		return 0;
-
-	if (what & XTAL)
-		outen |= PCI_CFG_GPIO_XTAL;
-	if (what & PLL)
-		outen |= PCI_CFG_GPIO_PLL;
-
-	if (on) {
-		/* turn primary xtal on */
-		if (what & XTAL) {
-			out |= PCI_CFG_GPIO_XTAL;
-			if (what & PLL)
-				out |= PCI_CFG_GPIO_PLL;
-			pci_write_config_dword(sii->pcibus,
-					       PCI_GPIO_OUT, out);
-			pci_write_config_dword(sii->pcibus,
-					       PCI_GPIO_OUTEN, outen);
-			udelay(XTAL_ON_DELAY);
-		}
-
-		/* turn pll on */
-		if (what & PLL) {
-			out &= ~PCI_CFG_GPIO_PLL;
-			pci_write_config_dword(sii->pcibus,
-					       PCI_GPIO_OUT, out);
-			mdelay(2);
-		}
-	} else {
-		if (what & XTAL)
-			out &= ~PCI_CFG_GPIO_XTAL;
-		if (what & PLL)
-			out |= PCI_CFG_GPIO_PLL;
-		pci_write_config_dword(sii->pcibus,
-				       PCI_GPIO_OUT, out);
-		pci_write_config_dword(sii->pcibus,
-				       PCI_GPIO_OUTEN, outen);
-	}
-
-	return 0;
-}
-
 /* clk control mechanism through chipcommon, no policy checking */
 static bool _ai_clkctl_cc(struct si_info *sii, uint mode)
 {
@@ -985,16 +867,12 @@ void ai_pci_setup(struct si_pub *sih, uint coremask)
 	 * Enable sb->pci interrupts.  Assume
 	 * PCI rev 2.3 support was added in pci core rev 6 and things changed..
 	 */
-	if (PCIE(sih) || (PCI(sih) && (ai_get_buscorerev(sih) >= 6))) {
+	if (PCIE(sih)) {
 		/* pci config write to set this core bit in PCIIntMask */
 		pci_read_config_dword(sii->pcibus, PCI_INT_MASK, &w);
 		w |= (coremask << PCI_SBIM_SHIFT);
 		pci_write_config_dword(sii->pcibus, PCI_INT_MASK, w);
 	}
-
-	if (PCI(sih)) {
-		pcicore_pci_setup(sii->pch);
-	}
 }
 
 /*
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
index 32f1597..db78197 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
@@ -200,7 +200,6 @@ extern void ai_pci_setup(struct si_pub *sih, uint coremask);
 extern void ai_clkctl_init(struct si_pub *sih);
 extern u16 ai_clkctl_fast_pwrup_delay(struct si_pub *sih);
 extern bool ai_clkctl_cc(struct si_pub *sih, uint mode);
-extern int ai_clkctl_xtal(struct si_pub *sih, uint what, bool on);
 extern bool ai_deviceremoved(struct si_pub *sih);
 extern u32 ai_gpiocontrol(struct si_pub *sih, u32 mask, u32 val,
 			     u8 priority);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index b9ab8de..13c7bb1 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -1910,9 +1910,6 @@ static void brcms_b_xtal(struct brcms_hardware *wlc_hw, bool want)
 	if (!want && wlc_hw->pllreq)
 		return;
 
-	if (wlc_hw->sih)
-		ai_clkctl_xtal(wlc_hw->sih, XTAL | PLL, want);
-
 	wlc_hw->sbclk = want;
 	if (!wlc_hw->sbclk) {
 		wlc_hw->clk = false;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
index 239927c..4678bf2 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
@@ -240,6 +240,7 @@ static void pr28829_delay(void)
 struct pcicore_info *pcicore_init(struct si_pub *sih, struct bcma_device *core)
 {
 	struct pcicore_info *pi;
+	u8 cap_ptr;
 
 	/* alloc struct pcicore_info */
 	pi = kzalloc(sizeof(struct pcicore_info), GFP_ATOMIC);
@@ -250,12 +251,9 @@ struct pcicore_info *pcicore_init(struct si_pub *sih, struct bcma_device *core)
 	pi->dev = core->bus->host_pci;
 	pi->core = core;
 
-	if (core->id.id == PCIE_CORE_ID) {
-		u8 cap_ptr;
-		cap_ptr = pcicore_find_pci_capability(pi->dev, PCI_CAP_ID_EXP,
+	cap_ptr = pcicore_find_pci_capability(pi->dev, PCI_CAP_ID_EXP,
 						      NULL, NULL);
-		pi->pciecap_lcreg_offset = cap_ptr + PCIE_CAP_LINKCTRL_OFFSET;
-	}
+	pi->pciecap_lcreg_offset = cap_ptr + PCIE_CAP_LINKCTRL_OFFSET;
 	return pi;
 }
 
@@ -791,18 +789,7 @@ void pcicore_fixcfg(struct pcicore_info *pi)
 	u16 val16;
 	uint regoff;
 
-	switch (pi->core->id.id) {
-	case BCMA_CORE_PCI:
-		regoff = PCIREGOFFS(sprom[SRSH_PI_OFFSET]);
-		break;
-
-	case BCMA_CORE_PCIE:
-		regoff = PCIEREGOFFS(sprom[SRSH_PI_OFFSET]);
-		break;
-
-	default:
-		return;
-	}
+	regoff = PCIEREGOFFS(sprom[SRSH_PI_OFFSET]);
 
 	val16 = bcma_read16(pi->core, regoff);
 	if (((val16 & SRSH_PI_MASK) >> SRSH_PI_SHIFT) !=
@@ -812,18 +799,3 @@ void pcicore_fixcfg(struct pcicore_info *pi)
 		bcma_write16(pi->core, regoff, val16);
 	}
 }
-
-/* precondition: current core is pci core */
-void
-pcicore_pci_setup(struct pcicore_info *pi)
-{
-	bcma_set32(pi->core, PCIREGOFFS(sbtopci2),
-		   SBTOPCI_PREF | SBTOPCI_BURST);
-
-	if (pi->core->id.rev >= 11) {
-		bcma_set32(pi->core, PCIREGOFFS(sbtopci2),
-			   SBTOPCI_RC_READMULTI);
-		bcma_set32(pi->core, PCIREGOFFS(clkrun), PCI_CLKRUN_DSBL);
-		(void)bcma_read32(pi->core, PCIREGOFFS(clkrun));
-	}
-}
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.h b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.h
index 9fc3ead..e24babe 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.h
@@ -72,6 +72,5 @@ extern void pcicore_down(struct pcicore_info *pch, int state);
 extern u8 pcicore_find_pci_capability(struct pci_dev *dev, u8 req_cap_id,
 				      unsigned char *buf, u32 *buflen);
 extern void pcicore_fixcfg(struct pcicore_info *pch);
-extern void pcicore_pci_setup(struct pcicore_info *pch);
 
 #endif /* _BRCM_NICPCI_H_ */
-- 
1.7.9.5

