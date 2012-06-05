Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36195 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239Ab2FEXIJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 19:08:09 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com, brudley@broadcom.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 01/18] brcmsmac: remove PCIE() makro
Date: Wed,  6 Jun 2012 01:07:04 +0200
Message-Id: <1338937641-8519-2-git-send-email-hauke@hauke-m.de> (sfid-20120606_010813_656675_CEF38E60)
In-Reply-To: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of checking if there is a PCIe core on the bus, better check if
hosttype is PCIe.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index 6d8b721..ce276bd 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -318,9 +318,8 @@
 #define	IS_SIM(chippkg)	\
 	((chippkg == HDLSIM_PKG_ID) || (chippkg == HWSIM_PKG_ID))
 
-#define PCIE(sih)	(ai_get_buscoretype(sih) == PCIE_CORE_ID)
-
-#define PCI_FORCEHT(sih) (PCIE(sih) && (ai_get_chip_id(sih) == BCM4716_CHIP_ID))
+#define PCI_FORCEHT(sih) ((ai_get_buscoretype(sih) == PCIE_CORE_ID) && \
+			  (ai_get_chip_id(sih) == BCM4716_CHIP_ID))
 
 #ifdef DEBUG
 #define	SI_MSG(fmt, ...)	pr_debug(fmt, ##__VA_ARGS__)
@@ -775,7 +774,7 @@ void ai_pci_up(struct si_pub *sih)
 		bcma_core_set_clockmode(cc, BCMA_CLKMODE_FAST);
 	}
 
-	if (PCIE(sih))
+	if (sii->icbus->hosttype == BCMA_HOSTTYPE_PCI)
 		bcma_core_pci_extend_L1timer(&sii->icbus->drv_pci, true);
 }
 
@@ -793,7 +792,7 @@ void ai_pci_down(struct si_pub *sih)
 		bcma_core_set_clockmode(cc, BCMA_CLKMODE_DYNAMIC);
 	}
 
-	if (PCIE(sih))
+	if (sii->icbus->hosttype == BCMA_HOSTTYPE_PCI)
 		bcma_core_pci_extend_L1timer(&sii->icbus->drv_pci, false);
 }
 
-- 
1.7.9.5

