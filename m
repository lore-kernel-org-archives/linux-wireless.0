Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44951 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755155Ab2D2Avg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2012 20:51:36 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 07/19] brcmsmac: remove pcicore_hwup()
Date: Sun, 29 Apr 2012 02:50:31 +0200
Message-Id: <1335660643-26368-8-git-send-email-hauke@hauke-m.de> (sfid-20120429_025157_329335_C9369944)
In-Reply-To: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
References: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is now done by bcma_core_pci_config_fixup() in drivers/bcma/driver_pci.c

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |    1 -
 drivers/net/wireless/brcm80211/brcmsmac/nicpci.c  |   30 ---------------------
 drivers/net/wireless/brcm80211/brcmsmac/nicpci.h  |    1 -
 3 files changed, 32 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index daa7f25..fd99e7b 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -876,7 +876,6 @@ int ai_pci_fixcfg(struct si_pub *sih)
 	/* Fixup PI in SROM shadow area to enable the correct PCI core access */
 	/* check 'pi' is correct and fix it if not */
 	pcicore_fixcfg(sii->pch);
-	pcicore_hwup(sii->pch);
 	return 0;
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
index e57a5b1..c217f8d 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
@@ -500,28 +500,6 @@ static void pcie_war_serdes(struct pcicore_info *pi)
 	}
 }
 
-/* Fix MISC config to allow coming out of L2/L3-Ready state w/o PRST */
-/* Needs to happen when coming out of 'standby'/'hibernate' */
-static void pcie_misc_config_fixup(struct pcicore_info *pi)
-{
-	u16 val16;
-
-	val16 = bcma_read16(pi->core,
-			    PCIEREGOFFS(sprom[SRSH_PCIE_MISC_CONFIG]));
-
-	if ((val16 & SRSH_L23READY_EXIT_NOPERST) == 0) {
-		val16 |= SRSH_L23READY_EXIT_NOPERST;
-		bcma_write16(pi->core,
-			     PCIEREGOFFS(sprom[SRSH_PCIE_MISC_CONFIG]), val16);
-	}
-}
-
-/* Needs to happen when coming out of 'standby'/'hibernate' */
-static void pcie_war_pci_setup(struct pcicore_info *pi)
-{
-	pcie_misc_config_fixup(pi);
-}
-
 /* ***** Functions called during driver state changes ***** */
 void pcicore_attach(struct pcicore_info *pi, int state)
 {
@@ -531,14 +509,6 @@ void pcicore_attach(struct pcicore_info *pi, int state)
 	pcie_war_serdes(pi);
 }
 
-void pcicore_hwup(struct pcicore_info *pi)
-{
-	if (!pi || ai_get_buscoretype(pi->sih) != PCIE_CORE_ID)
-		return;
-
-	pcie_war_pci_setup(pi);
-}
-
 void pcicore_up(struct pcicore_info *pi, int state)
 {
 	if (!pi || ai_get_buscoretype(pi->sih) != PCIE_CORE_ID)
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.h b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.h
index 21271b4..7d7e5e5 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.h
@@ -65,7 +65,6 @@ extern struct pcicore_info *pcicore_init(struct si_pub *sih,
 					 struct bcma_device *core);
 extern void pcicore_deinit(struct pcicore_info *pch);
 extern void pcicore_attach(struct pcicore_info *pch, int state);
-extern void pcicore_hwup(struct pcicore_info *pch);
 extern void pcicore_up(struct pcicore_info *pch, int state);
 extern void pcicore_down(struct pcicore_info *pch, int state);
 extern u8 pcicore_find_pci_capability(struct pci_dev *dev, u8 req_cap_id,
-- 
1.7.9.5

