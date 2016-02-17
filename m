Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 5520-maca-inet1-outside.broadcom.com ([216.31.211.11]:54602
	"EHLO mail-irv-18.broadcom.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161115AbcBQK11 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2016 05:27:27 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 09/21] brcmfmac: use bar1 window size as provided by pci subsystem
Date: Wed, 17 Feb 2016 11:26:58 +0100
Message-Id: <1455704830-10088-10-git-send-email-arend@broadcom.com> (sfid-20160217_112835_727508_37A7E38A)
In-Reply-To: <1455704830-10088-1-git-send-email-arend@broadcom.com>
References: <1455704830-10088-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

The PCIE bar1 window size is specified by chip. Currently the
ioremap of bar1 was using a define which always matched the size
of bar1, but newer chips can have a different bar1 sizes. With
this patch the ioremap will be called with the by chip provided
window size.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index d89212b..3fd4e3b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -72,7 +72,6 @@ static struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
 
 #define BRCMF_PCIE_FW_UP_TIMEOUT		2000 /* msec */
 
-#define BRCMF_PCIE_TCM_MAP_SIZE			(4096 * 1024)
 #define BRCMF_PCIE_REG_MAP_SIZE			(32 * 1024)
 
 /* backplane addres space accessed by BAR0 */
@@ -252,7 +251,6 @@ struct brcmf_pciedev_info {
 	char nvram_name[BRCMF_FW_NAME_LEN];
 	void __iomem *regs;
 	void __iomem *tcm;
-	u32 tcm_size;
 	u32 ram_base;
 	u32 ram_size;
 	struct brcmf_chip *ci;
@@ -1592,8 +1590,7 @@ static int brcmf_pcie_get_resource(struct brcmf_pciedev_info *devinfo)
 	}
 
 	devinfo->regs = ioremap_nocache(bar0_addr, BRCMF_PCIE_REG_MAP_SIZE);
-	devinfo->tcm = ioremap_nocache(bar1_addr, BRCMF_PCIE_TCM_MAP_SIZE);
-	devinfo->tcm_size = BRCMF_PCIE_TCM_MAP_SIZE;
+	devinfo->tcm = ioremap_nocache(bar1_addr, bar1_size);
 
 	if (!devinfo->regs || !devinfo->tcm) {
 		brcmf_err("ioremap() failed (%p,%p)\n", devinfo->regs,
@@ -1602,8 +1599,9 @@ static int brcmf_pcie_get_resource(struct brcmf_pciedev_info *devinfo)
 	}
 	brcmf_dbg(PCIE, "Phys addr : reg space = %p base addr %#016llx\n",
 		  devinfo->regs, (unsigned long long)bar0_addr);
-	brcmf_dbg(PCIE, "Phys addr : mem space = %p base addr %#016llx\n",
-		  devinfo->tcm, (unsigned long long)bar1_addr);
+	brcmf_dbg(PCIE, "Phys addr : mem space = %p base addr %#016llx size 0x%x\n",
+		  devinfo->tcm, (unsigned long long)bar1_addr,
+		  (unsigned int)bar1_size);
 
 	return 0;
 }
-- 
1.9.1

