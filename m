Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2172 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504Ab1LHXHR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 18:07:17 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 12/23] brcm80211: smac: rename struct si_info field pbus
 to pcibus
Date: Thu, 8 Dec 2011 15:06:48 -0800
Message-ID: <1323385619-7454-13-git-send-email-frankyl@broadcom.com> (sfid-20111209_000826_244915_89593806)
In-Reply-To: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
References: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

When moving to bcma usage there are two busses in play. The pci bus
connecting the device to the host and the bcma bus connecting the
cores in the device. To distinguish this the attribute pbus has been
renamed to a more explicit name, ie. pcibus.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |   46 ++++++++++----------
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h |    2 +-
 drivers/net/wireless/brcm80211/brcmsmac/dma.c     |    2 +-
 3 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index 83a0138..5c73119 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -564,7 +564,7 @@ static void ai_scan(struct si_pub *sih, struct chipcregs __iomem *cc)
 	sii->curwrap = (void *)((unsigned long)cc + SI_CORE_SIZE);
 
 	/* Now point the window at the erom */
-	pci_write_config_dword(sii->pbus, PCI_BAR0_WIN, erombase);
+	pci_write_config_dword(sii->pcibus, PCI_BAR0_WIN, erombase);
 	eromptr = regs;
 	eromlim = eromptr + (ER_REMAPCONTROL / sizeof(u32));
 
@@ -741,9 +741,9 @@ void __iomem *ai_setcoreidx(struct si_pub *sih, uint coreidx)
 		return NULL;
 
 	/* point bar0 window */
-	pci_write_config_dword(sii->pbus, PCI_BAR0_WIN, addr);
+	pci_write_config_dword(sii->pcibus, PCI_BAR0_WIN, addr);
 	/* point bar0 2nd 4KB window */
-	pci_write_config_dword(sii->pbus, PCI_BAR0_WIN2, wrap);
+	pci_write_config_dword(sii->pcibus, PCI_BAR0_WIN2, wrap);
 	sii->curidx = coreidx;
 
 	return sii->curmap;
@@ -880,7 +880,7 @@ static bool ai_ispcie(struct si_info *sii)
 	u8 cap_ptr;
 
 	cap_ptr =
-	    pcicore_find_pci_capability(sii->pbus, PCI_CAP_ID_EXP, NULL,
+	    pcicore_find_pci_capability(sii->pcibus, PCI_CAP_ID_EXP, NULL,
 					NULL);
 	if (!cap_ptr)
 		return false;
@@ -990,7 +990,7 @@ ai_buscore_setup(struct si_info *sii, u32 savewin, uint *origidx)
 	/* fixup necessary chip/core configurations */
 	if (SI_FAST(&sii->pub)) {
 		if (!sii->pch) {
-			sii->pch = pcicore_init(&sii->pub, sii->pbus,
+			sii->pch = pcicore_init(&sii->pub, sii->pcibus,
 						(__iomem void *)PCIEREGS(sii));
 			if (sii->pch == NULL)
 				return false;
@@ -1015,7 +1015,7 @@ static __used void ai_nvram_process(struct si_info *sii)
 	uint w = 0;
 
 	/* do a pci config read to get subsystem id and subvendor id */
-	pci_read_config_dword(sii->pbus, PCI_SUBSYSTEM_VENDOR_ID, &w);
+	pci_read_config_dword(sii->pcibus, PCI_SUBSYSTEM_VENDOR_ID, &w);
 
 	sii->pub.boardvendor = w & 0xffff;
 	sii->pub.boardtype = (w >> 16) & 0xffff;
@@ -1037,14 +1037,14 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	sii->buscoreidx = BADIDX;
 
 	sii->curmap = regs;
-	sii->pbus = pbus;
+	sii->pcibus = pbus;
 
 	/* find Chipcommon address */
-	pci_read_config_dword(sii->pbus, PCI_BAR0_WIN, &savewin);
+	pci_read_config_dword(sii->pcibus, PCI_BAR0_WIN, &savewin);
 	if (!GOODCOREADDR(savewin, SI_ENUM_BASE))
 		savewin = SI_ENUM_BASE;
 
-	pci_write_config_dword(sii->pbus, PCI_BAR0_WIN,
+	pci_write_config_dword(sii->pcibus, PCI_BAR0_WIN,
 			       SI_ENUM_BASE);
 	cc = (struct chipcregs __iomem *) regs;
 
@@ -1481,7 +1481,7 @@ static uint ai_slowclk_src(struct si_info *sii)
 	u32 val;
 
 	if (ai_get_ccrev(&sii->pub) < 6) {
-		pci_read_config_dword(sii->pbus, PCI_GPIO_OUT,
+		pci_read_config_dword(sii->pcibus, PCI_GPIO_OUT,
 				      &val);
 		if (val & PCI_CFG_GPIO_SCS)
 			return SCC_SS_PCI;
@@ -1663,9 +1663,9 @@ int ai_clkctl_xtal(struct si_pub *sih, uint what, bool on)
 	if (PCIE(sih))
 		return -1;
 
-	pci_read_config_dword(sii->pbus, PCI_GPIO_IN, &in);
-	pci_read_config_dword(sii->pbus, PCI_GPIO_OUT, &out);
-	pci_read_config_dword(sii->pbus, PCI_GPIO_OUTEN, &outen);
+	pci_read_config_dword(sii->pcibus, PCI_GPIO_IN, &in);
+	pci_read_config_dword(sii->pcibus, PCI_GPIO_OUT, &out);
+	pci_read_config_dword(sii->pcibus, PCI_GPIO_OUTEN, &outen);
 
 	/*
 	 * Avoid glitching the clock if GPRS is already using it.
@@ -1686,9 +1686,9 @@ int ai_clkctl_xtal(struct si_pub *sih, uint what, bool on)
 			out |= PCI_CFG_GPIO_XTAL;
 			if (what & PLL)
 				out |= PCI_CFG_GPIO_PLL;
-			pci_write_config_dword(sii->pbus,
+			pci_write_config_dword(sii->pcibus,
 					       PCI_GPIO_OUT, out);
-			pci_write_config_dword(sii->pbus,
+			pci_write_config_dword(sii->pcibus,
 					       PCI_GPIO_OUTEN, outen);
 			udelay(XTAL_ON_DELAY);
 		}
@@ -1696,7 +1696,7 @@ int ai_clkctl_xtal(struct si_pub *sih, uint what, bool on)
 		/* turn pll on */
 		if (what & PLL) {
 			out &= ~PCI_CFG_GPIO_PLL;
-			pci_write_config_dword(sii->pbus,
+			pci_write_config_dword(sii->pcibus,
 					       PCI_GPIO_OUT, out);
 			mdelay(2);
 		}
@@ -1705,9 +1705,9 @@ int ai_clkctl_xtal(struct si_pub *sih, uint what, bool on)
 			out &= ~PCI_CFG_GPIO_XTAL;
 		if (what & PLL)
 			out |= PCI_CFG_GPIO_PLL;
-		pci_write_config_dword(sii->pbus,
+		pci_write_config_dword(sii->pcibus,
 				       PCI_GPIO_OUT, out);
-		pci_write_config_dword(sii->pbus,
+		pci_write_config_dword(sii->pcibus,
 				       PCI_GPIO_OUTEN, outen);
 	}
 
@@ -1835,9 +1835,9 @@ int ai_devpath(struct si_pub *sih, char *path, int size)
 		return -1;
 
 	slen = snprintf(path, (size_t) size, "pci/%u/%u/",
-		((struct si_info *)sih)->pbus->bus->number,
+		((struct si_info *)sih)->pcibus->bus->number,
 		PCI_SLOT(((struct pci_dev *)
-				(((struct si_info *)(sih))->pbus))->devfn));
+				(((struct si_info *)(sih))->pcibus))->devfn));
 
 	if (slen < 0 || slen >= size) {
 		path[0] = '\0';
@@ -1915,9 +1915,9 @@ void ai_pci_setup(struct si_pub *sih, uint coremask)
 	 */
 	if (PCIE(sih) || (PCI(sih) && (ai_get_buscorerev(sih) >= 6))) {
 		/* pci config write to set this core bit in PCIIntMask */
-		pci_read_config_dword(sii->pbus, PCI_INT_MASK, &w);
+		pci_read_config_dword(sii->pcibus, PCI_INT_MASK, &w);
 		w |= (coremask << PCI_SBIM_SHIFT);
-		pci_write_config_dword(sii->pbus, PCI_INT_MASK, w);
+		pci_write_config_dword(sii->pcibus, PCI_INT_MASK, w);
 	} else {
 		/* set sbintvec bit for our flag number */
 		ai_setint(sih, siflag);
@@ -2028,7 +2028,7 @@ bool ai_deviceremoved(struct si_pub *sih)
 
 	sii = (struct si_info *)sih;
 
-	pci_read_config_dword(sii->pbus, PCI_VENDOR_ID, &w);
+	pci_read_config_dword(sii->pcibus, PCI_VENDOR_ID, &w);
 	if ((w & 0xFFFF) != PCI_VENDOR_ID_BROADCOM)
 		return true;
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
index 347b8a2..0a8e2f7 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
@@ -170,7 +170,7 @@ struct gpioh_item {
 /* misc si info needed by some of the routines */
 struct si_info {
 	struct si_pub pub;	/* back plane public state (must be first) */
-	struct pci_dev *pbus;	/* handle to pci bus */
+	struct pci_dev *pcibus;	/* handle to pci bus */
 	uint dev_coreid;	/* the core provides driver functions */
 	void *intr_arg;		/* interrupt callback function arg */
 	u32 (*intrsoff_fn) (void *intr_arg); /* turns chip interrupts off */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/dma.c b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
index b55b1f6..3a60eb8 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/dma.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
@@ -594,7 +594,7 @@ struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 	strncpy(di->name, name, MAXNAMEL);
 	di->name[MAXNAMEL - 1] = '\0';
 
-	di->pbus = ((struct si_info *)sih)->pbus;
+	di->pbus = ((struct si_info *)sih)->pcibus;
 
 	/* save tunables */
 	di->ntxd = (u16) ntxd;
-- 
1.7.5.4


