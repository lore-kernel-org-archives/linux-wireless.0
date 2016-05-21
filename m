Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33586 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbcEUNny (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 May 2016 09:43:54 -0400
Received: by mail-wm0-f65.google.com with SMTP id 67so3621119wmg.0
        for <linux-wireless@vger.kernel.org>; Sat, 21 May 2016 06:43:53 -0700 (PDT)
From: Mathias Krause <minipli@googlemail.com>
To: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Dennis Wassenberg <dennis.wassenberg@secunet.com>,
	Mathias Krause <minipli@googlemail.com>,
	Xinming Hu <huxm@marvell.com>,
	Brad Spengler <spender@grsecurity.net>,
	PaX Team <pageexec@freemail.hu>
Subject: [PATCH] mwifiex: remove misleading GFP_DMA flag in buffer allocations
Date: Sat, 21 May 2016 15:43:31 +0200
Message-Id: <1463838211-31888-1-git-send-email-minipli@googlemail.com> (sfid-20160521_154405_930000_777B9CB1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The GFP_DMA flag is obviously misunderstood in the mwifiex driver. It's
meant for legacy ISA DMA memory mappings only -- the lower 16MB on x86.
That doesn't apply to PCIe or SDIO devices, I guess.

Remove the GFP_DMA flag to reduce the need to place the socket buffer
allocation into the low mem DMA area, which might already be in use by
other drivers.

This misuse was flagged by the PaX USERCOPY feature by chance, as it
detected the user copy operation from a DMA buffer in the recvfrom()
syscall path.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Tested-by: Dennis Wassenberg <dennis.wassenberg@secunet.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>
Cc: Nishant Sarmukadam <nishants@marvell.com>
Cc: Xinming Hu <huxm@marvell.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Brad Spengler <spender@grsecurity.net>
Cc: PaX Team <pageexec@freemail.hu>
---

This should go on top of wireless-drivers-next.git as it's an extension
of commit 00c547804968 ("mwifiex: remove redundant GFP_DMA flag").

 drivers/net/wireless/marvell/mwifiex/11n_aggr.c |    2 +-
 drivers/net/wireless/marvell/mwifiex/pcie.c     |    4 ++--
 drivers/net/wireless/marvell/mwifiex/sdio.c     |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n_aggr.c b/drivers/net/wireless/marvell/mwifiex/11n_aggr.c
index 1efef3b8273d..dc49c3de1f25 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n_aggr.c
@@ -184,7 +184,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 
 	tx_info_src = MWIFIEX_SKB_TXCB(skb_src);
 	skb_aggr = mwifiex_alloc_dma_align_buf(adapter->tx_buf_size,
-					       GFP_ATOMIC | GFP_DMA);
+					       GFP_ATOMIC);
 	if (!skb_aggr) {
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 0c7937eb6b77..adcf08bb14d5 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -507,7 +507,7 @@ static int mwifiex_init_rxq_ring(struct mwifiex_adapter *adapter)
 	for (i = 0; i < MWIFIEX_MAX_TXRX_BD; i++) {
 		/* Allocate skb here so that firmware can DMA data from it */
 		skb = mwifiex_alloc_dma_align_buf(MWIFIEX_RX_DATA_BUF_SIZE,
-						  GFP_KERNEL | GFP_DMA);
+						  GFP_KERNEL);
 		if (!skb) {
 			mwifiex_dbg(adapter, ERROR,
 				    "Unable to allocate skb for RX ring.\n");
@@ -1319,7 +1319,7 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
 		}
 
 		skb_tmp = mwifiex_alloc_dma_align_buf(MWIFIEX_RX_DATA_BUF_SIZE,
-						      GFP_KERNEL | GFP_DMA);
+						      GFP_KERNEL);
 		if (!skb_tmp) {
 			mwifiex_dbg(adapter, ERROR,
 				    "Unable to allocate skb.\n");
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index bdc51ffd43ec..674465e0d837 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -1492,7 +1492,7 @@ rx_curr_single:
 		mwifiex_dbg(adapter, INFO, "info: RX: port: %d, rx_len: %d\n",
 			    port, rx_len);
 
-		skb = mwifiex_alloc_dma_align_buf(rx_len, GFP_KERNEL | GFP_DMA);
+		skb = mwifiex_alloc_dma_align_buf(rx_len, GFP_KERNEL);
 		if (!skb) {
 			mwifiex_dbg(adapter, ERROR,
 				    "single skb allocated fail,\t"
@@ -1597,7 +1597,7 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 		rx_len = (u16) (rx_blocks * MWIFIEX_SDIO_BLOCK_SIZE);
 		mwifiex_dbg(adapter, INFO, "info: rx_len = %d\n", rx_len);
 
-		skb = mwifiex_alloc_dma_align_buf(rx_len, GFP_KERNEL | GFP_DMA);
+		skb = mwifiex_alloc_dma_align_buf(rx_len, GFP_KERNEL);
 		if (!skb)
 			return -1;
 
-- 
1.7.10.4

