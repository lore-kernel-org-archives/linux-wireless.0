Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:36291 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750931AbdL3PwQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 30 Dec 2017 10:52:16 -0500
From: Himanshu Jha <himanshujha199640@gmail.com>
To: arend.vanspriel@broadcom.com
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        chi-hsien.lin@cypress.com, wright.feng@cypress.com,
        kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mcgrof@kernel.org,
        Himanshu Jha <himanshujha199640@gmail.com>
Subject: [PATCH] brcmfmac: Use zeroing memory allocator than allocator/memset
Date: Sat, 30 Dec 2017 21:21:53 +0530
Message-Id: <1514649113-7366-1-git-send-email-himanshujha199640@gmail.com> (sfid-20171230_165238_832967_95E6DB69)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use dma_zalloc_coherent for allocating zeroed
memory and remove unnecessary memset function.

Done using Coccinelle.
Generated-by: scripts/coccinelle/api/alloc/kzalloc-simple.cocci
0-day tested with no failures.

Suggested-by: Luis R. Rodriguez <mcgrof@kernel.org>
Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/pcie.c    | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 3c87157..bdef2ac 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1251,14 +1251,13 @@ static int brcmf_pcie_init_scratchbuffers(struct brcmf_pciedev_info *devinfo)
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
@@ -1268,14 +1267,13 @@ static int brcmf_pcie_init_scratchbuffers(struct brcmf_pciedev_info *devinfo)
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
