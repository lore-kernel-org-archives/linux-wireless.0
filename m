Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36286 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564Ab2FEXIn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 19:08:43 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com, brudley@broadcom.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 15/18] brcmsmac: fix DMA on SoCs
Date: Wed,  6 Jun 2012 01:07:18 +0200
Message-Id: <1338937641-8519-16-git-send-email-hauke@hauke-m.de> (sfid-20120606_012943_486264_54B238B6)
In-Reply-To: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These extra offsets are only needed by PCIe devices and not when
running on an SoC.

This partly reverts commit:
commit 821e4e93172e4f7d5ac1eade04665c3dc5049c4a
Author: Roland Vossen <rvossen@broadcom.com>
Date:   Mon Aug 8 15:58:58 2011 +0200

    staging: brcm80211: removed unused bus code from softmac

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/dma.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/dma.c b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
index b67b20c..fcbd2d2 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/dma.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
@@ -573,6 +573,7 @@ struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 	struct dma_info *di;
 	u8 rev = core->id.rev;
 	uint size;
+	struct si_info *sii = container_of(sih, struct si_info, pub);
 
 	/* allocate private info structure */
 	di = kzalloc(sizeof(struct dma_info), GFP_ATOMIC);
@@ -633,11 +634,14 @@ struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 	 */
 	di->ddoffsetlow = 0;
 	di->dataoffsetlow = 0;
-	/* add offset for pcie with DMA64 bus */
-	di->ddoffsetlow = 0;
-	di->ddoffsethigh = SI_PCIE_DMA_H32;
-	di->dataoffsetlow = di->ddoffsetlow;
-	di->dataoffsethigh = di->ddoffsethigh;
+	/* for pci bus, add offset */
+	if (sii->icbus->hosttype == BCMA_HOSTTYPE_PCI) {
+		/* add offset for pcie with DMA64 bus */
+		di->ddoffsetlow = 0;
+		di->ddoffsethigh = SI_PCIE_DMA_H32;
+		di->dataoffsetlow = di->ddoffsetlow;
+		di->dataoffsethigh = di->ddoffsethigh;
+	}
 	/* WAR64450 : DMACtl.Addr ext fields are not supported in SDIOD core. */
 	if ((core->id.id == BCMA_CORE_SDIO_DEV)
 	    && ((rev > 0) && (rev <= 2)))
-- 
1.7.9.5

