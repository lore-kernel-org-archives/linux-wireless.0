Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53798 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682Ab2F3NRN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jun 2012 09:17:13 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com
Cc: brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 01/18] brcmsmac: remove PCIE() macro
Date: Sat, 30 Jun 2012 15:16:04 +0200
Message-Id: <1341062181-28071-2-git-send-email-hauke@hauke-m.de> (sfid-20120630_151717_399202_2CB833B3)
In-Reply-To: <1341062181-28071-1-git-send-email-hauke@hauke-m.de>
References: <1341062181-28071-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of checking if there is a PCIe core on the bus, better check if
hosttype is PCIe.

In the original submission to staging PCIE() checked, if the bustype is
PCI and the buscore is a PCIe core. Now we assume that all cores bcma
supports are PCIe based, so we just have to check if the bustype is PCI.

The old code bcmsmac currently uses searches for a PCIe core on the bus
and if there is one assumes that this is the buscore, which is wrong.
Some SoCs have a PCIe core operating in host mode and this is not the
bus core. The old code also caused a null pointer in
ai_get_buscoretype() and ai_get_buscorerev() if buscore was not set
because there was no PCIe core on the bus.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index 3c6f9b1..c942a88 100644
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
@@ -774,7 +773,7 @@ void ai_pci_up(struct si_pub *sih)
 		bcma_core_set_clockmode(cc, BCMA_CLKMODE_FAST);
 	}
 
-	if (PCIE(sih))
+	if (sii->icbus->hosttype == BCMA_HOSTTYPE_PCI)
 		bcma_core_pci_extend_L1timer(&sii->icbus->drv_pci, true);
 }
 
@@ -792,7 +791,7 @@ void ai_pci_down(struct si_pub *sih)
 		bcma_core_set_clockmode(cc, BCMA_CLKMODE_DYNAMIC);
 	}
 
-	if (PCIE(sih))
+	if (sii->icbus->hosttype == BCMA_HOSTTYPE_PCI)
 		bcma_core_pci_extend_L1timer(&sii->icbus->drv_pci, false);
 }
 
-- 
1.7.9.5

