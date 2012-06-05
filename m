Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36211 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239Ab2FEXIM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 19:08:12 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com, brudley@broadcom.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 02/18] brcmsmac: remove PCI_FORCEHT() makro
Date: Wed,  6 Jun 2012 01:07:05 +0200
Message-Id: <1338937641-8519-3-git-send-email-hauke@hauke-m.de> (sfid-20120606_010816_503857_AB200485)
In-Reply-To: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The BCM4716 is a SoC and does not have a PCI client interface, so this
condition is never true.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |   19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index ce276bd..180cdd2 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -318,9 +318,6 @@
 #define	IS_SIM(chippkg)	\
 	((chippkg == HDLSIM_PKG_ID) || (chippkg == HWSIM_PKG_ID))
 
-#define PCI_FORCEHT(sih) ((ai_get_buscoretype(sih) == PCIE_CORE_ID) && \
-			  (ai_get_chip_id(sih) == BCM4716_CHIP_ID))
-
 #ifdef DEBUG
 #define	SI_MSG(fmt, ...)	pr_debug(fmt, ##__VA_ARGS__)
 #else
@@ -754,9 +751,6 @@ bool ai_clkctl_cc(struct si_pub *sih, enum bcma_clkmode mode)
 
 	sii = (struct si_info *)sih;
 
-	if (PCI_FORCEHT(sih))
-		return mode == BCMA_CLKMODE_FAST;
-
 	cc = ai_findcore(&sii->pub, BCMA_CORE_CHIPCOMMON, 0);
 	bcma_core_set_clockmode(cc, mode);
 	return mode == BCMA_CLKMODE_FAST;
@@ -765,15 +759,9 @@ bool ai_clkctl_cc(struct si_pub *sih, enum bcma_clkmode mode)
 void ai_pci_up(struct si_pub *sih)
 {
 	struct si_info *sii;
-	struct bcma_device *cc;
 
 	sii = (struct si_info *)sih;
 
-	if (PCI_FORCEHT(sih)) {
-		cc = ai_findcore(&sii->pub, BCMA_CORE_CHIPCOMMON, 0);
-		bcma_core_set_clockmode(cc, BCMA_CLKMODE_FAST);
-	}
-
 	if (sii->icbus->hosttype == BCMA_HOSTTYPE_PCI)
 		bcma_core_pci_extend_L1timer(&sii->icbus->drv_pci, true);
 }
@@ -782,16 +770,9 @@ void ai_pci_up(struct si_pub *sih)
 void ai_pci_down(struct si_pub *sih)
 {
 	struct si_info *sii;
-	struct bcma_device *cc;
 
 	sii = (struct si_info *)sih;
 
-	/* release FORCEHT since chip is going to "down" state */
-	if (PCI_FORCEHT(sih)) {
-		cc = ai_findcore(&sii->pub, BCMA_CORE_CHIPCOMMON, 0);
-		bcma_core_set_clockmode(cc, BCMA_CLKMODE_DYNAMIC);
-	}
-
 	if (sii->icbus->hosttype == BCMA_HOSTTYPE_PCI)
 		bcma_core_pci_extend_L1timer(&sii->icbus->drv_pci, false);
 }
-- 
1.7.9.5

