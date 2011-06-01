Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3838 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758822Ab1FALqa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:30 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 39/83] staging: brcm80211: remove functions from
 nicpci.h
Date: Wed, 1 Jun 2011 13:45:24 +0200
Message-ID: <1306928768-7501-39-git-send-email-rvossen@broadcom.com> (sfid-20110601_134925_828291_D957D678)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Couple of functions in the header file are actually only used by
nicpci.c itself and as such made static and removed from the header
file.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/nicpci.c |    6 +++---
 drivers/staging/brcm80211/brcmsmac/nicpci.h |    6 ------
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.c b/drivers/staging/brcm80211/brcmsmac/nicpci.c
index a96173d..4da155a 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.c
@@ -180,7 +180,7 @@ pcicore_find_pci_capability(void *dev, u8 req_cap_id,
 }
 
 /* ***** Register Access API */
-uint
+static uint
 pcie_readreg(sbpcieregs_t *pcieregs, uint addrtype,
 	     uint offset)
 {
@@ -204,7 +204,7 @@ pcie_readreg(sbpcieregs_t *pcieregs, uint addrtype,
 	return retval;
 }
 
-uint
+static uint
 pcie_writereg(sbpcieregs_t *pcieregs, uint addrtype,
 	      uint offset, uint val)
 {
@@ -329,7 +329,7 @@ pcie_mdiowrite(pcicore_info_t *pi, uint physmedia, uint regaddr, uint val)
 }
 
 /* ***** Support functions ***** */
-u8 pcie_clkreq(void *pch, u32 mask, u32 val)
+static u8 pcie_clkreq(void *pch, u32 mask, u32 val)
 {
 	pcicore_info_t *pi = (pcicore_info_t *) pch;
 	u32 reg_val;
diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.h b/drivers/staging/brcm80211/brcmsmac/nicpci.h
index e9058c6..a6baf7f 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.h
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.h
@@ -56,17 +56,11 @@
 /* bar0 + 12K accesses chipc core registers */
 #define PCI_16KB0_CCREGS_OFFSET	(12 * 1024)
 
-struct sbpcieregs;
 struct si_pub;
 
 extern u8 pcicore_find_pci_capability(void *dev, u8 req_cap_id,
 					 unsigned char *buf, u32 *buflen);
-extern uint pcie_readreg(struct sbpcieregs *pcieregs,
-			 uint addrtype, uint offset);
-extern uint pcie_writereg(struct sbpcieregs *pcieregs,
-			  uint addrtype, uint offset, uint val);
 
-extern u8 pcie_clkreq(void *pch, u32 mask, u32 val);
 extern u32 pcie_lcreg(void *pch, u32 mask, u32 val);
 
 extern void *pcicore_init(struct si_pub *sih, void *pdev, void *regs);
-- 
1.7.4.1


