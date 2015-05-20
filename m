Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:61003 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbbETMJ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 08:09:56 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Franky Lin <frankyl@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 4/6] brcmfmac: remove dummy cache flush/invalidate function
Date: Wed, 20 May 2015 14:09:50 +0200
Message-ID: <1432123792-4155-5-git-send-email-arend@broadcom.com> (sfid-20150520_141014_190887_411B5C7C)
In-Reply-To: <1432123792-4155-1-git-send-email-arend@broadcom.com>
References: <1432123792-4155-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

brcmf_dma_flush and brcmf_dma_invalidate_cache are not necessary and
have never been implemented.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/commonring.c | 18 ------------------
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c     | 11 -----------
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c       | 11 -----------
 3 files changed, 40 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/commonring.c b/drivers/net/wireless/brcm80211/brcmfmac/commonring.c
index 77656c7..26c6587 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/commonring.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/commonring.c
@@ -22,17 +22,6 @@
 #include "core.h"
 #include "commonring.h"
 
-
-/* dma flushing needs implementation for mips and arm platforms. Should
- * be put in util. Note, this is not real flushing. It is virtual non
- * cached memory. Only write buffers should have to be drained. Though
- * this may be different depending on platform......
- * SEE ALSO msgbuf.c
- */
-#define brcmf_dma_flush(addr, len)
-#define brcmf_dma_invalidate_cache(addr, len)
-
-
 void brcmf_commonring_register_cb(struct brcmf_commonring *commonring,
 				  int (*cr_ring_bell)(void *ctx),
 				  int (*cr_update_rptr)(void *ctx),
@@ -206,14 +195,9 @@ int brcmf_commonring_write_complete(struct brcmf_commonring *commonring)
 	address = commonring->buf_addr;
 	address += (commonring->f_ptr * commonring->item_len);
 	if (commonring->f_ptr > commonring->w_ptr) {
-		brcmf_dma_flush(address,
-				(commonring->depth - commonring->f_ptr) *
-				commonring->item_len);
 		address = commonring->buf_addr;
 		commonring->f_ptr = 0;
 	}
-	brcmf_dma_flush(address, (commonring->w_ptr - commonring->f_ptr) *
-			commonring->item_len);
 
 	commonring->f_ptr = commonring->w_ptr;
 
@@ -258,8 +242,6 @@ void *brcmf_commonring_get_read_ptr(struct brcmf_commonring *commonring,
 	if (commonring->r_ptr == commonring->depth)
 		commonring->r_ptr = 0;
 
-	brcmf_dma_invalidate_cache(ret_addr, *n_ items * commonring->item_len);
-
 	return ret_addr;
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
index b182f53..a932e45 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
@@ -278,16 +278,6 @@ struct brcmf_msgbuf_pktids {
 	struct brcmf_msgbuf_pktid *array;
 };
 
-
-/* dma flushing needs implementation for mips and arm platforms. Should
- * be put in util. Note, this is not real flushing. It is virtual non
- * cached memory. Only write buffers should have to be drained. Though
- * this may be different depending on platform......
- */
-#define brcmf_dma_flush(addr, len)
-#define brcmf_dma_invalidate_cache(addr, len)
-
-
 static void brcmf_msgbuf_rxbuf_ioctlresp_post(struct brcmf_msgbuf *msgbuf);
 
 
@@ -462,7 +452,6 @@ static int brcmf_msgbuf_tx_ioctl(struct brcmf_pub *drvr, int ifidx,
 		memcpy(msgbuf->ioctbuf, buf, buf_len);
 	else
 		memset(msgbuf->ioctbuf, 0, buf_len);
-	brcmf_dma_flush(ioctl_buf, buf_len);
 
 	err = brcmf_commonring_write_complete(commonring);
 	brcmf_commonring_unlock(commonring);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
index 6ca3037..2bc24a4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
@@ -276,15 +276,6 @@ static const u32 brcmf_ring_itemsize[BRCMF_NROF_COMMON_MSGRINGS] = {
 };
 
 
-/* dma flushing needs implementation for mips and arm platforms. Should
- * be put in util. Note, this is not real flushing. It is virtual non
- * cached memory. Only write buffers should have to be drained. Though
- * this may be different depending on platform......
- */
-#define brcmf_dma_flush(addr, len)
-#define brcmf_dma_invalidate_cache(addr, len)
-
-
 static u32
 brcmf_pcie_read_reg32(struct brcmf_pciedev_info *devinfo, u32 reg_offset)
 {
@@ -1174,7 +1165,6 @@ static int brcmf_pcie_init_scratchbuffers(struct brcmf_pciedev_info *devinfo)
 		goto fail;
 
 	memset(devinfo->shared.scratch, 0, BRCMF_DMA_D2H_SCRATCH_BUF_LEN);
-	brcmf_dma_flush(devinfo->shared.scratch, BRCMF_DMA_D2H_SCRATCH_BUF_LEN);
 
 	addr = devinfo->shared.tcm_base_address +
 	       BRCMF_SHARED_DMA_SCRATCH_ADDR_OFFSET;
@@ -1192,7 +1182,6 @@ static int brcmf_pcie_init_scratchbuffers(struct brcmf_pciedev_info *devinfo)
 		goto fail;
 
 	memset(devinfo->shared.ringupd, 0, BRCMF_DMA_D2H_RINGUPD_BUF_LEN);
-	brcmf_dma_flush(devinfo->shared.ringupd, BRCMF_DMA_D2H_RINGUPD_BUF_LEN);
 
 	addr = devinfo->shared.tcm_base_address +
 	       BRCMF_SHARED_DMA_RINGUPD_ADDR_OFFSET;
-- 
1.9.1

