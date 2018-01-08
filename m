Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:44699 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756322AbeAHUpz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jan 2018 15:45:55 -0500
From: Himanshu Jha <himanshujha199640@gmail.com>
To: kvalo@codeaurora.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        Himanshu Jha <himanshujha199640@gmail.com>
Subject: [PATCH v2] brcmfmac: Use zeroing memory allocator than allocator/memset
Date: Tue,  9 Jan 2018 02:15:31 +0530
Message-Id: <1515444331-19509-1-git-send-email-himanshujha199640@gmail.com> (sfid-20180108_214615_882027_95342CB5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use dma_zalloc_coherent for allocating zeroed
memory and remove unnecessary memset function.

Generated-by: scripts/coccinelle/api/alloc/kzalloc-simple.cocci

Suggested-by: Luis R. Rodriguez <mcgrof@kernel.org>
Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
---
v2:
   -corrected the patch to be applied into the branch without corruption
 .../net/wireless/broadcom/brcm80211/brcmfmac/pcie.c  | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 3c87157..8752707 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1251,14 +1251,14 @@ static int brcmf_pcie_init_scratchbuffers(struct brcmf_pciedev_info *devinfo)
 	u64 address;
 	u32 addr;
 
-	devinfo->shared.scratch = dma_alloc_coherent(&devinfo->pdev->dev,
-		BRCMF_DMA_D2H_SCRATCH_BUF_LEN,
-		&devinfo->shared.scratch_dmahandle, GFP_KERNEL);
+	devinfo->shared.scratch =
+		dma_zalloc_coherent(&devinfo->pdev->dev,
+					BRCMF_DMA_D2H_SCRATCH_BUF_LEN,
+					&devinfo->shared.scratch_dmahandle,
+					GFP_KERNEL);
 	if (!devinfo->shared.scratch)
 		goto fail;
 
-	memset(devinfo->shared.scratch, 0, BRCMF_DMA_D2H_SCRATCH_BUF_LEN);
-
 	addr = devinfo->shared.tcm_base_address +
 	       BRCMF_SHARED_DMA_SCRATCH_ADDR_OFFSET;
 	address = (u64)devinfo->shared.scratch_dmahandle;
@@ -1268,14 +1268,14 @@ static int brcmf_pcie_init_scratchbuffers(struct brcmf_pciedev_info *devinfo)
 	       BRCMF_SHARED_DMA_SCRATCH_LEN_OFFSET;
 	brcmf_pcie_write_tcm32(devinfo, addr, BRCMF_DMA_D2H_SCRATCH_BUF_LEN);
 
-	devinfo->shared.ringupd = dma_alloc_coherent(&devinfo->pdev->dev,
-		BRCMF_DMA_D2H_RINGUPD_BUF_LEN,
-		&devinfo->shared.ringupd_dmahandle, GFP_KERNEL);
+	devinfo->shared.ringupd =
+		dma_zalloc_coherent(&devinfo->pdev->dev,
+					BRCMF_DMA_D2H_RINGUPD_BUF_LEN,
+					&devinfo->shared.ringupd_dmahandle,
+					GFP_KERNEL);
 	if (!devinfo->shared.ringupd)
 		goto fail;
 
-	memset(devinfo->shared.ringupd, 0, BRCMF_DMA_D2H_RINGUPD_BUF_LEN);
-
 	addr = devinfo->shared.tcm_base_address +
 	       BRCMF_SHARED_DMA_RINGUPD_ADDR_OFFSET;
 	address = (u64)devinfo->shared.ringupd_dmahandle;
-- 
2.7.4
