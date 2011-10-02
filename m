Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2419 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688Ab1JBRPA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Oct 2011 13:15:00 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 07/20] staging: brcm80211: added __iomem qualifier to
 softmac dma.c
Date: Sun, 2 Oct 2011 10:14:32 -0700
Message-ID: <1317575685-3156-8-git-send-email-frankyl@broadcom.com> (sfid-20111002_191523_710580_B44FA21F)
In-Reply-To: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
References: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. Makes it clear when an address is mapped IO space.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/dma.c |   17 +++++++++--------
 drivers/staging/brcm80211/brcmsmac/dma.h |    5 +++--
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index ef856ce..b56a302 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -224,9 +224,9 @@ struct dma_info {
 	bool addrext;	/* this dma engine supports DmaExtendedAddrChanges */
 
 	/* 64-bit dma tx engine registers */
-	struct dma64regs *d64txregs;
+	struct dma64regs __iomem *d64txregs;
 	/* 64-bit dma rx engine registers */
-	struct dma64regs *d64rxregs;
+	struct dma64regs __iomem *d64rxregs;
 	/* pointer to dma64 tx descriptor ring */
 	struct dma64desc *txd64;
 	/* pointer to dma64 rx descriptor ring */
@@ -391,7 +391,7 @@ static uint _dma_ctrlflags(struct dma_info *di, uint mask, uint flags)
 	return dmactrlflags;
 }
 
-static bool _dma64_addrext(struct dma64regs *dma64regs)
+static bool _dma64_addrext(struct dma64regs __iomem *dma64regs)
 {
 	u32 w;
 	OR_REG(&dma64regs->control, D64_XC_AE);
@@ -553,8 +553,9 @@ static bool _dma_alloc(struct dma_info *di, uint direction)
 }
 
 struct dma_pub *dma_attach(char *name, struct si_pub *sih,
-		     void *dmaregstx, void *dmaregsrx, uint ntxd,
-		     uint nrxd, uint rxbufsize, int rxextheadroom,
+		     void __iomem *dmaregstx, void __iomem *dmaregsrx,
+		     uint ntxd, uint nrxd,
+		     uint rxbufsize, int rxextheadroom,
 		     uint nrxpost, uint rxoffset, uint *msg_level)
 {
 	struct dma_info *di;
@@ -571,8 +572,8 @@ struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 	di->dma64 = ((ai_core_sflags(sih, 0, 0) & SISF_DMA64) == SISF_DMA64);
 
 	/* init dma reg pointer */
-	di->d64txregs = (struct dma64regs *) dmaregstx;
-	di->d64rxregs = (struct dma64regs *) dmaregsrx;
+	di->d64txregs = (struct dma64regs __iomem *) dmaregstx;
+	di->d64rxregs = (struct dma64regs __iomem *) dmaregsrx;
 
 	/*
 	 * Default flags (which can be changed by the driver calling
@@ -1344,7 +1345,7 @@ struct sk_buff *dma_getnexttxp(struct dma_pub *pub, enum txd_range range)
 	if (range == DMA_RANGE_ALL)
 		end = di->txout;
 	else {
-		struct dma64regs *dregs = di->d64txregs;
+		struct dma64regs __iomem *dregs = di->d64txregs;
 
 		end = (u16) (B2I(((R_REG(&dregs->status0) &
 				 D64_XS0_CD_MASK) -
diff --git a/drivers/staging/brcm80211/brcmsmac/dma.h b/drivers/staging/brcm80211/brcmsmac/dma.h
index 4075dc9..ebc5bc5 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.h
+++ b/drivers/staging/brcm80211/brcmsmac/dma.h
@@ -74,8 +74,9 @@ struct dma_pub {
 };
 
 extern struct dma_pub *dma_attach(char *name, struct si_pub *sih,
-			    void *dmaregstx, void *dmaregsrx, uint ntxd,
-			    uint nrxd, uint rxbufsize, int rxextheadroom,
+			    void __iomem *dmaregstx, void __iomem *dmaregsrx,
+			    uint ntxd, uint nrxd,
+			    uint rxbufsize, int rxextheadroom,
 			    uint nrxpost, uint rxoffset, uint *msg_level);
 
 void dma_rxinit(struct dma_pub *pub);
-- 
1.7.1


