Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53815 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab2F3NRa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jun 2012 09:17:30 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com
Cc: brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 02/18] brcmsmac: remove PCI_FORCEHT() macro
Date: Sat, 30 Jun 2012 15:16:05 +0200
Message-Id: <1341062181-28071-3-git-send-email-hauke@hauke-m.de> (sfid-20120630_151733_572102_7E36EC60)
In-Reply-To: <1341062181-28071-1-git-send-email-hauke@hauke-m.de>
References: <1341062181-28071-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The BCM4716 is a SoC and does not have a PCI client interface, so this
condition is never true.

Acked-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |   19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index c942a88..c7ec9b7 100644
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
@@ -753,9 +750,6 @@ bool ai_clkctl_cc(struct si_pub *sih, enum bcma_clkmode mode)
 
 	sii = (struct si_info *)sih;
 
-	if (PCI_FORCEHT(sih))
-		return mode == BCMA_CLKMODE_FAST;
-
 	cc = ai_findcore(&sii->pub, BCMA_CORE_CHIPCOMMON, 0);
 	bcma_core_set_clockmode(cc, mode);
 	return mode == BCMA_CLKMODE_FAST;
@@ -764,15 +758,9 @@ bool ai_clkctl_cc(struct si_pub *sih, enum bcma_clkmode mode)
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
@@ -781,16 +769,9 @@ void ai_pci_up(struct si_pub *sih)
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

