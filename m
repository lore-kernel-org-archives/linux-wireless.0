Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46658 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751541AbeCWFD4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Mar 2018 01:03:56 -0400
From: Govind Singh <govinds@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH v2 03/13] ath10k: Add hif start/stop methods for wcn3990 snoc layer
Date: Fri, 23 Mar 2018 10:33:34 +0530
Message-Id: <1521781424-24972-4-git-send-email-govinds@codeaurora.org> (sfid-20180323_060404_879911_BD067127)
In-Reply-To: <1521781424-24972-1-git-send-email-govinds@codeaurora.org>
References: <1521781424-24972-1-git-send-email-govinds@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add hif start/stop callback for allocating/freeing buffers
on tx/rx pipe and enabling/disabling the tx/rx pipe
interrupts.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 189 ++++++++++++++++++++++++++++++++-
 1 file changed, 187 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 575355c..dcd8bb7 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -25,6 +25,7 @@
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
 #define  WCN3990_CE_ATTR_FLAGS 0
+#define ATH10K_SNOC_RX_POST_RETRY_MS 50
 
 static char *const ce_name[] = {
 	"WLAN_CE_0",
@@ -170,9 +171,193 @@ u32 ath10k_snoc_read32(struct ath10k *ar, u32 offset)
 	return val;
 }
 
+static int __ath10k_snoc_rx_post_buf(struct ath10k_snoc_pipe *pipe)
+{
+	struct ath10k_ce_pipe *ce_pipe = pipe->ce_hdl;
+	struct ath10k *ar = pipe->hif_ce_state;
+	struct ath10k_ce *ce = ath10k_ce_priv(ar);
+	struct sk_buff *skb;
+	dma_addr_t paddr;
+	int ret;
+
+	skb = dev_alloc_skb(pipe->buf_sz);
+	if (!skb)
+		return -ENOMEM;
+
+	WARN_ONCE((unsigned long)skb->data & 3, "unaligned skb");
+
+	paddr = dma_map_single(ar->dev, skb->data,
+			       skb->len + skb_tailroom(skb),
+			       DMA_FROM_DEVICE);
+	if (unlikely(dma_mapping_error(ar->dev, paddr))) {
+		ath10k_warn(ar, "failed to dma map snoc rx buf\n");
+		dev_kfree_skb_any(skb);
+		return -EIO;
+	}
+
+	ATH10K_SKB_RXCB(skb)->paddr = paddr;
+
+	spin_lock_bh(&ce->ce_lock);
+	ret = ce_pipe->ops->ce_rx_post_buf(ce_pipe, skb, paddr);
+	spin_unlock_bh(&ce->ce_lock);
+	if (ret) {
+		dma_unmap_single(ar->dev, paddr, skb->len + skb_tailroom(skb),
+				 DMA_FROM_DEVICE);
+		dev_kfree_skb_any(skb);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void ath10k_snoc_rx_post_pipe(struct ath10k_snoc_pipe *pipe)
+{
+	struct ath10k *ar = pipe->hif_ce_state;
+	struct ath10k_ce *ce = ath10k_ce_priv(ar);
+	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
+	struct ath10k_ce_pipe *ce_pipe = pipe->ce_hdl;
+	int ret, num;
+
+	if (pipe->buf_sz == 0)
+		return;
+
+	if (!ce_pipe->dest_ring)
+		return;
+
+	spin_lock_bh(&ce->ce_lock);
+	num = __ath10k_ce_rx_num_free_bufs(ce_pipe);
+	spin_unlock_bh(&ce->ce_lock);
+	while (num--) {
+		ret = __ath10k_snoc_rx_post_buf(pipe);
+		if (ret) {
+			if (ret == -ENOSPC)
+				break;
+			ath10k_warn(ar, "failed to post rx buf: %d\n", ret);
+			mod_timer(&ar_snoc->rx_post_retry, jiffies +
+				  ATH10K_SNOC_RX_POST_RETRY_MS);
+			break;
+		}
+	}
+}
+
+static void ath10k_snoc_rx_post(struct ath10k *ar)
+{
+	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
+	int i;
+
+	for (i = 0; i < CE_COUNT; i++)
+		ath10k_snoc_rx_post_pipe(&ar_snoc->pipe_info[i]);
+}
+
+static inline void ath10k_snoc_irq_disable(struct ath10k *ar)
+{
+	ath10k_ce_disable_interrupts(ar);
+}
+
+static inline void ath10k_snoc_irq_enable(struct ath10k *ar)
+{
+	ath10k_ce_enable_interrupts(ar);
+}
+
+static void ath10k_snoc_rx_pipe_cleanup(struct ath10k_snoc_pipe *snoc_pipe)
+{
+	struct ath10k_ce_pipe *ce_pipe;
+	struct ath10k_ce_ring *ce_ring;
+	struct sk_buff *skb;
+	struct ath10k *ar;
+	int i;
+
+	ar = snoc_pipe->hif_ce_state;
+	ce_pipe = snoc_pipe->ce_hdl;
+	ce_ring = ce_pipe->dest_ring;
+
+	if (!ce_ring)
+		return;
+
+	if (!snoc_pipe->buf_sz)
+		return;
+
+	for (i = 0; i < ce_ring->nentries; i++) {
+		skb = ce_ring->per_transfer_context[i];
+		if (!skb)
+			continue;
+
+		ce_ring->per_transfer_context[i] = NULL;
+
+		dma_unmap_single(ar->dev, ATH10K_SKB_RXCB(skb)->paddr,
+				 skb->len + skb_tailroom(skb),
+				 DMA_FROM_DEVICE);
+		dev_kfree_skb_any(skb);
+	}
+}
+
+static void ath10k_snoc_tx_pipe_cleanup(struct ath10k_snoc_pipe *snoc_pipe)
+{
+	struct ath10k_ce_pipe *ce_pipe;
+	struct ath10k_ce_ring *ce_ring;
+	struct ath10k_snoc *ar_snoc;
+	struct sk_buff *skb;
+	struct ath10k *ar;
+	int i;
+
+	ar = snoc_pipe->hif_ce_state;
+	ar_snoc = ath10k_snoc_priv(ar);
+	ce_pipe = snoc_pipe->ce_hdl;
+	ce_ring = ce_pipe->src_ring;
+
+	if (!ce_ring)
+		return;
+
+	if (!snoc_pipe->buf_sz)
+		return;
+
+	for (i = 0; i < ce_ring->nentries; i++) {
+		skb = ce_ring->per_transfer_context[i];
+		if (!skb)
+			continue;
+
+		ce_ring->per_transfer_context[i] = NULL;
+
+		ath10k_htc_tx_completion_handler(ar, skb);
+	}
+}
+
+static void ath10k_snoc_buffer_cleanup(struct ath10k *ar)
+{
+	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
+	struct ath10k_snoc_pipe *pipe_info;
+	int pipe_num;
+
+	del_timer_sync(&ar_snoc->rx_post_retry);
+	for (pipe_num = 0; pipe_num < CE_COUNT; pipe_num++) {
+		pipe_info = &ar_snoc->pipe_info[pipe_num];
+		ath10k_snoc_rx_pipe_cleanup(pipe_info);
+		ath10k_snoc_tx_pipe_cleanup(pipe_info);
+	}
+}
+
+static void ath10k_snoc_hif_stop(struct ath10k *ar)
+{
+	ath10k_snoc_irq_disable(ar);
+	ath10k_snoc_buffer_cleanup(ar);
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot hif stop\n");
+}
+
+static int ath10k_snoc_hif_start(struct ath10k *ar)
+{
+	ath10k_snoc_irq_enable(ar);
+	ath10k_snoc_rx_post(ar);
+
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot hif start\n");
+
+	return 0;
+}
+
 static const struct ath10k_hif_ops ath10k_snoc_hif_ops = {
-	.read32			= ath10k_snoc_read32,
-	.write32		= ath10k_snoc_write32,
+	.read32		= ath10k_snoc_read32,
+	.write32	= ath10k_snoc_write32,
+	.start		= ath10k_snoc_hif_start,
+	.stop		= ath10k_snoc_hif_stop,
 };
 
 static const struct ath10k_bus_ops ath10k_snoc_bus_ops = {
-- 
1.9.1
