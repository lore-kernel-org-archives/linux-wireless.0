Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2273 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758812Ab1FALq3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:29 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 37/83] staging: brcm80211: remove usage of pcicfg.h from
 brcmsmac driver
Date: Wed, 1 Jun 2011 13:45:22 +0200
Message-ID: <1306928768-7501-37-git-send-email-rvossen@broadcom.com> (sfid-20110601_134942_403261_F0584323)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

All PCI related definitions needed by the brcmsmac driver are going to
be consolidated in single header file nicpci.h. This commit removes
need to include pcicfg.h in brcmsmac driver sources.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.c      |    1 -
 drivers/staging/brcm80211/brcmsmac/bcmsrom.c      |    2 +-
 drivers/staging/brcm80211/brcmsmac/nicpci.c       |    3 +-
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c  |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c     |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_main.c     |    1 -
 drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c |    2 -
 drivers/staging/brcm80211/include/nicpci.h        |   42 ++++++++++++++++++++-
 8 files changed, 45 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index 9aec084..bae40fe 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -24,7 +24,6 @@
 #include <aiutils.h>
 #include <bcmsoc.h>
 #include <sbchipc.h>
-#include <pcicfg.h>
 #include <bcmdevs.h>
 
 /* ********** from siutils.c *********** */
diff --git a/drivers/staging/brcm80211/brcmsmac/bcmsrom.c b/drivers/staging/brcm80211/brcmsmac/bcmsrom.c
index 952bc40..e0899c8 100644
--- a/drivers/staging/brcm80211/brcmsmac/bcmsrom.c
+++ b/drivers/staging/brcm80211/brcmsmac/bcmsrom.c
@@ -25,7 +25,7 @@
 #include <bcmsoc.h>
 #include <sbchipc.h>
 #include <bcmdevs.h>
-#include <pcicfg.h>
+#include <nicpci.h>
 #include <aiutils.h>
 #include <bcmsrom.h>
 
diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.c b/drivers/staging/brcm80211/brcmsmac/nicpci.c
index 806b2ca..a96173d 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.c
@@ -27,7 +27,6 @@
 #include <pci_core.h>
 #include <pcie_core.h>
 #include <nicpci.h>
-#include <pcicfg.h>
 
 /* chipcontrol */
 #define CHIPCTRL_4321_PLL_DOWN	0x800000	/* serdes PLL down override */
@@ -83,7 +82,7 @@ static bool pcicore_pmecap(pcicore_info_t *pi);
 /* Initialize the PCI core. It's caller's responsibility to make sure that this is done
  * only once
  */
-void *pcicore_init(si_t *sih, void *pdev, void *regs)
+void *pcicore_init(struct si_pub *sih, void *pdev, void *regs)
 {
 	pcicore_info_t *pi;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
index 3d9f791..ee026d3 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@ -29,7 +29,7 @@
 #include <bcmwifi.h>
 #include <bcmutils.h>
 #include <bcmnvram.h>
-#include <pcicfg.h>
+#include <nicpci.h>
 #include <sbdma.h>
 
 #include "phy/wlc_phy_int.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index a7994e4..2ee0785 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -30,7 +30,7 @@
 #include <bcmutils.h>
 #include <bcmnvram.h>
 #include <sbchipc.h>
-#include <pcicfg.h>
+#include <nicpci.h>
 #include <sbdma.h>
 #include <bcmdma.h>
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index c50f335..18a5463 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -25,7 +25,6 @@
 #include <bcmwifi.h>
 #include <bcmnvram.h>
 #include <aiutils.h>
-#include <pcicfg.h>
 #include <bcmsrom.h>
 #include <sbdma.h>
 #include <bcmdma.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c b/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
index 7bb122b..c94b459 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
@@ -23,14 +23,12 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/pci.h>
 
 #include <bcmdefs.h>
 #include <bcmutils.h>
 #include <bcmwifi.h>
 #include <aiutils.h>
 #include <sbchipc.h>
-#include <pcicfg.h>
 #include <sbdma.h>
 #include <bcmdma.h>
 #include <wlc_pmu.h>
diff --git a/drivers/staging/brcm80211/include/nicpci.h b/drivers/staging/brcm80211/include/nicpci.h
index f901c60..e9058c6 100644
--- a/drivers/staging/brcm80211/include/nicpci.h
+++ b/drivers/staging/brcm80211/include/nicpci.h
@@ -17,7 +17,47 @@
 #ifndef	_NICPCI_H
 #define	_NICPCI_H
 
+/* PCI configuration address space size */
+#define PCI_SZPCR		256
+
+/* Brcm PCI configuration registers */
+/* backplane address space accessed by BAR0 */
+#define PCI_BAR0_WIN		0x80
+/* sprom property control */
+#define PCI_SPROM_CONTROL	0x88
+/* mask of PCI and other cores interrupts */
+#define PCI_INT_MASK		0x94
+/* backplane core interrupt mask bits offset */
+#define  PCI_SBIM_SHIFT		8
+/* backplane address space accessed by second 4KB of BAR0 */
+#define PCI_BAR0_WIN2		0xac
+/* pci config space gpio input (>=rev3) */
+#define PCI_GPIO_IN		0xb0
+/* pci config space gpio output (>=rev3) */
+#define PCI_GPIO_OUT		0xb4
+/* pci config space gpio output enable (>=rev3) */
+#define PCI_GPIO_OUTEN		0xb8
+
+/* bar0 + 4K accesses external sprom */
+#define PCI_BAR0_SPROM_OFFSET	(4 * 1024)
+/* bar0 + 6K accesses pci core registers */
+#define PCI_BAR0_PCIREGS_OFFSET	(6 * 1024)
+/*
+ * pci core SB registers are at the end of the
+ * 8KB window, so their address is the "regular"
+ * address plus 4K
+ */
+#define PCI_BAR0_PCISBR_OFFSET	(4 * 1024)
+/* bar0 window size Match with corerev 13 */
+#define PCI_BAR0_WINSZ		(16 * 1024)
+/* On pci corerev >= 13 and all pcie, the bar0 is now 16KB and it maps: */
+/* bar0 + 8K accesses pci/pcie core registers */
+#define PCI_16KB0_PCIREGS_OFFSET (8 * 1024)
+/* bar0 + 12K accesses chipc core registers */
+#define PCI_16KB0_CCREGS_OFFSET	(12 * 1024)
+
 struct sbpcieregs;
+struct si_pub;
 
 extern u8 pcicore_find_pci_capability(void *dev, u8 req_cap_id,
 					 unsigned char *buf, u32 *buflen);
@@ -29,7 +69,7 @@ extern uint pcie_writereg(struct sbpcieregs *pcieregs,
 extern u8 pcie_clkreq(void *pch, u32 mask, u32 val);
 extern u32 pcie_lcreg(void *pch, u32 mask, u32 val);
 
-extern void *pcicore_init(si_t *sih, void *pdev, void *regs);
+extern void *pcicore_init(struct si_pub *sih, void *pdev, void *regs);
 extern void pcicore_deinit(void *pch);
 extern void pcicore_attach(void *pch, char *pvars, int state);
 extern void pcicore_hwup(void *pch);
-- 
1.7.4.1


