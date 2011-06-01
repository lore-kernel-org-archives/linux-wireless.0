Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4837 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161297Ab1FALq1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:27 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 30/83] staging: brcm80211: remove SDIO related
 definitions from nicpci.h
Date: Wed, 1 Jun 2011 13:45:15 +0200
Message-ID: <1306928768-7501-30-git-send-email-rvossen@broadcom.com> (sfid-20110601_134643_937950_27575E61)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The header file nicpci.h is now only used by brcmsmac driver, which
does not support SDIO. The conditional defintions have been removed
from the header file.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/include/nicpci.h |   29 +---------------------------
 1 files changed, 1 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/brcm80211/include/nicpci.h b/drivers/staging/brcm80211/include/nicpci.h
index 30321eb..f901c60 100644
--- a/drivers/staging/brcm80211/include/nicpci.h
+++ b/drivers/staging/brcm80211/include/nicpci.h
@@ -17,32 +17,6 @@
 #ifndef	_NICPCI_H
 #define	_NICPCI_H
 
-#if defined(BCMSDIO) || (defined(BCMBUSTYPE) && (BCMBUSTYPE == SI_BUS))
-#define pcicore_find_pci_capability(a, b, c, d) (0)
-#define pcie_readreg(a, b, c, d) (0)
-#define pcie_writereg(a, b, c, d, e) (0)
-
-#define pcie_clkreq(a, b, c)	(0)
-#define pcie_lcreg(a, b, c)	(0)
-
-#define pcicore_init(a, b, c) (0x0dadbeef)
-#define pcicore_deinit(a)	do { } while (0)
-#define pcicore_attach(a, b, c)	do { } while (0)
-#define pcicore_hwup(a)		do { } while (0)
-#define pcicore_up(a, b)	do { } while (0)
-#define pcicore_sleep(a)	do { } while (0)
-#define pcicore_down(a, b)	do { } while (0)
-
-#define pcie_war_ovr_aspm_update(a, b)	do { } while (0)
-
-#define pcicore_pcieserdesreg(a, b, c, d, e) (0)
-#define pcicore_pciereg(a, b, c, d, e) (0)
-
-#define pcicore_pmecap_fast(a)	(false)
-#define pcicore_pmeen(a)	do { } while (0)
-#define pcicore_pmeclr(a)	do { } while (0)
-#define pcicore_pmestat(a)	(false)
-#else
 struct sbpcieregs;
 
 extern u8 pcicore_find_pci_capability(void *dev, u8 req_cap_id,
@@ -74,6 +48,5 @@ extern bool pcicore_pmecap_fast(void *pch);
 extern void pcicore_pmeen(void *pch);
 extern void pcicore_pmeclr(void *pch);
 extern bool pcicore_pmestat(void *pch);
-#endif /* defined(BCMSDIO)||(defined(BCMBUSTYPE) && (BCMBUSTYPE==SI_BUS)) */
 
-#endif				/* _NICPCI_H */
+#endif /* _NICPCI_H */
-- 
1.7.4.1


