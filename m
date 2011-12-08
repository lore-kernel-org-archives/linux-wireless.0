Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2180 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598Ab1LHXHR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 18:07:17 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 13/23] brcm80211: smac: change ai_attach interface
 taking a bcma_bus object
Date: Thu, 8 Dec 2011 15:06:49 -0800
Message-ID: <1323385619-7454-14-git-send-email-frankyl@broadcom.com> (sfid-20111209_000821_109946_EF4AD171)
In-Reply-To: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
References: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The ai_attach now takes a bcma_bus object as its parameter to
obtain all required information needed for chip control.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |   18 +++++++++---------
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h |    5 ++++-
 drivers/net/wireless/brcm80211/brcmsmac/main.c    |    2 +-
 3 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index 5c73119..c1e4f35 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -1022,22 +1022,25 @@ static __used void ai_nvram_process(struct si_info *sii)
 }
 
 static struct si_info *ai_doattach(struct si_info *sii,
-				   void __iomem *regs, struct pci_dev *pbus)
+				   struct bcma_bus *pbus)
 {
+	void __iomem *regs = pbus->mmio;
 	struct si_pub *sih = &sii->pub;
 	u32 w, savewin;
 	struct chipcregs __iomem *cc;
 	uint socitype;
 	uint origidx;
 
+	/* assume the window is looking at chipcommon */
+	WARN_ON(pbus->mapped_core->id.id != BCMA_CORE_CHIPCOMMON);
 	memset((unsigned char *) sii, 0, sizeof(struct si_info));
 
 	savewin = 0;
 
+	sii->icbus = pbus;
 	sii->buscoreidx = BADIDX;
-
 	sii->curmap = regs;
-	sii->pcibus = pbus;
+	sii->pcibus = pbus->host_pci;
 
 	/* find Chipcommon address */
 	pci_read_config_dword(sii->pcibus, PCI_BAR0_WIN, &savewin);
@@ -1160,13 +1163,10 @@ static struct si_info *ai_doattach(struct si_info *sii,
 }
 
 /*
- * Allocate a si handle.
- * devid - pci device id (used to determine chip#)
- * osh - opaque OS handle
- * regs - virtual address of initial core registers
+ * Allocate a si handle and do the attach.
  */
 struct si_pub *
-ai_attach(void __iomem *regs, struct pci_dev *sdh)
+ai_attach(struct bcma_bus *pbus)
 {
 	struct si_info *sii;
 
@@ -1175,7 +1175,7 @@ ai_attach(void __iomem *regs, struct pci_dev *sdh)
 	if (sii == NULL)
 		return NULL;
 
-	if (ai_doattach(sii, regs, sdh) == NULL) {
+	if (ai_doattach(sii, pbus) == NULL) {
 		kfree(sii);
 		return NULL;
 	}
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
index 0a8e2f7..1e93599 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
@@ -17,6 +17,8 @@
 #ifndef	_BRCM_AIUTILS_H_
 #define	_BRCM_AIUTILS_H_
 
+#include <linux/bcma/bcma.h>
+
 #include "types.h"
 
 /*
@@ -170,6 +172,7 @@ struct gpioh_item {
 /* misc si info needed by some of the routines */
 struct si_info {
 	struct si_pub pub;	/* back plane public state (must be first) */
+	struct bcma_bus *icbus;	/* handle to soc interconnect bus */
 	struct pci_dev *pcibus;	/* handle to pci bus */
 	uint dev_coreid;	/* the core provides driver functions */
 	void *intr_arg;		/* interrupt callback function arg */
@@ -235,7 +238,7 @@ extern u32 ai_addrspacesize(struct si_pub *sih, uint asidx);
 extern void ai_write_wrap_reg(struct si_pub *sih, u32 offset, u32 val);
 
 /* === exported functions === */
-extern struct si_pub *ai_attach(void __iomem *regs, struct pci_dev *sdh);
+extern struct si_pub *ai_attach(struct bcma_bus *pbus);
 extern void ai_detach(struct si_pub *sih);
 extern uint ai_coreid(struct si_pub *sih);
 extern uint ai_corerev(struct si_pub *sih);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index d329c90..73bc0ab 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -4469,7 +4469,7 @@ static int brcms_b_attach(struct brcms_c_info *wlc, struct bcma_device *core,
 	 * Do the hardware portion of the attach. Also initialize software
 	 * state that depends on the particular hardware we are running.
 	 */
-	wlc_hw->sih = ai_attach(core->bus->mmio, core->bus->host_pci);
+	wlc_hw->sih = ai_attach(core->bus);
 	if (wlc_hw->sih == NULL) {
 		wiphy_err(wiphy, "wl%d: brcms_b_attach: si_attach failed\n",
 			  unit);
-- 
1.7.5.4


