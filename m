Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44995 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755162Ab2D2Avv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2012 20:51:51 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 14/19] brcmsmac: remove pcie_extendL1timer()
Date: Sun, 29 Apr 2012 02:50:38 +0200
Message-Id: <1335660643-26368-15-git-send-email-hauke@hauke-m.de> (sfid-20120429_025155_071356_BEBE0CCD)
In-Reply-To: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
References: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is now done by calling bcma_core_pci_extend_L1time()

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |    6 +-
 drivers/net/wireless/brcm80211/brcmsmac/nicpci.c  |   72 ---------------------
 2 files changed, 3 insertions(+), 75 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index cafacb1..8df7cb5 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -794,8 +794,7 @@ void ai_pci_up(struct si_pub *sih)
 	}
 
 	if (PCIE(sih))
-		pcicore_up(sii->pch, SI_PCIUP);
-
+		bcma_core_pci_extend_L1timer(&sii->icbus->drv_pci, true);
 }
 
 /* Unconfigure and/or apply various WARs when going down */
@@ -812,7 +811,8 @@ void ai_pci_down(struct si_pub *sih)
 		bcma_core_set_clockmode(cc, BCMA_CLKMODE_DYNAMIC);
 	}
 
-	pcicore_down(sii->pch, SI_PCIDOWN);
+	if (PCIE(sih))
+		bcma_core_pci_extend_L1timer(&sii->icbus->drv_pci, false);
 }
 
 /*
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
index 2d615cb..9a3e03b 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
@@ -240,78 +240,6 @@ void pcicore_deinit(struct pcicore_info *pch)
 	kfree(pch);
 }
 
-/* ***** Register Access API */
-static uint
-pcie_readreg(struct bcma_device *core, uint addrtype, uint offset)
-{
-	uint retval = 0xFFFFFFFF;
-
-	switch (addrtype) {
-	case PCIE_CONFIGREGS:
-		bcma_write32(core, PCIEREGOFFS(configaddr), offset);
-		(void)bcma_read32(core, PCIEREGOFFS(configaddr));
-		retval = bcma_read32(core, PCIEREGOFFS(configdata));
-		break;
-	case PCIE_PCIEREGS:
-		bcma_write32(core, PCIEREGOFFS(pcieindaddr), offset);
-		(void)bcma_read32(core, PCIEREGOFFS(pcieindaddr));
-		retval = bcma_read32(core, PCIEREGOFFS(pcieinddata));
-		break;
-	}
-
-	return retval;
-}
-
-static uint pcie_writereg(struct bcma_device *core, uint addrtype,
-			  uint offset, uint val)
-{
-	switch (addrtype) {
-	case PCIE_CONFIGREGS:
-		bcma_write32(core, PCIEREGOFFS(configaddr), offset);
-		bcma_write32(core, PCIEREGOFFS(configdata), val);
-		break;
-	case PCIE_PCIEREGS:
-		bcma_write32(core, PCIEREGOFFS(pcieindaddr), offset);
-		bcma_write32(core, PCIEREGOFFS(pcieinddata), val);
-		break;
-	default:
-		break;
-	}
-	return 0;
-}
-
-/* ***** Support functions ***** */
-static void pcie_extendL1timer(struct pcicore_info *pi, bool extend)
-{
-	u32 w;
-
-	w = pcie_readreg(pi->core, PCIE_PCIEREGS, PCIE_DLLP_PMTHRESHREG);
-	if (extend)
-		w |= PCIE_ASPMTIMER_EXTEND;
-	else
-		w &= ~PCIE_ASPMTIMER_EXTEND;
-	pcie_writereg(pi->core, PCIE_PCIEREGS, PCIE_DLLP_PMTHRESHREG, w);
-	w = pcie_readreg(pi->core, PCIE_PCIEREGS, PCIE_DLLP_PMTHRESHREG);
-}
-
-void pcicore_up(struct pcicore_info *pi, int state)
-{
-	if (!pi || ai_get_buscoretype(pi->sih) != PCIE_CORE_ID)
-		return;
-
-	/* Restore L1 timer for better performance */
-	pcie_extendL1timer(pi, true);
-}
-
-void pcicore_down(struct pcicore_info *pi, int state)
-{
-	if (!pi || ai_get_buscoretype(pi->sih) != PCIE_CORE_ID)
-		return;
-
-	/* Reduce L1 timer for better power savings */
-	pcie_extendL1timer(pi, false);
-}
-
 void pcicore_fixcfg(struct pcicore_info *pi)
 {
 	struct bcma_device *core = pi->core;
-- 
1.7.9.5

