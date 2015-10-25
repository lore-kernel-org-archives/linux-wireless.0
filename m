Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:29747 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbbJYN7i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 09:59:38 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Hamad Kadmany <QCA_hkadmany@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 2/4] wil6210: Fix TSO overflow handling
Date: Sun, 25 Oct 2015 15:59:22 +0200
Message-Id: <1445781564-24455-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20151025_145941_082192_9C086D5E)
In-Reply-To: <1445781564-24455-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1445781564-24455-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>

When Tx ring full is encountered with TSO,
printout of "DMA error" was wrongly printed.

In addition, in case of Tx ring full return
proper error code so that NETDEV_TX_BUSY is
returned to network stack in order not to
drop the packets and retry transmission of the
packets when ring is emptied.

Signed-off-by: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 0f8b687..3bc9bc0 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -1242,6 +1242,7 @@ static int __wil_tx_vring_tso(struct wil6210_priv *wil, struct vring *vring,
 	int tcp_hdr_len;
 	int skb_net_hdr_len;
 	int gso_type;
+	int rc = -EINVAL;
 
 	wil_dbg_txrx(wil, "%s() %d bytes to vring %d\n",
 		     __func__, skb->len, vring_index);
@@ -1333,8 +1334,9 @@ static int __wil_tx_vring_tso(struct wil6210_priv *wil, struct vring *vring,
 				     len, rem_data, descs_used);
 
 			if (descs_used == avail)  {
-				wil_err(wil, "TSO: ring overflow\n");
-				goto dma_error;
+				wil_err_ratelimited(wil, "TSO: ring overflow\n");
+				rc = -ENOMEM;
+				goto mem_error;
 			}
 
 			lenmss = min_t(int, rem_data, len);
@@ -1356,8 +1358,10 @@ static int __wil_tx_vring_tso(struct wil6210_priv *wil, struct vring *vring,
 				headlen -= lenmss;
 			}
 
-			if (unlikely(dma_mapping_error(dev, pa)))
-				goto dma_error;
+			if (unlikely(dma_mapping_error(dev, pa))) {
+				wil_err(wil, "TSO: DMA map page error\n");
+				goto mem_error;
+			}
 
 			_desc = &vring->va[i].tx;
 
@@ -1456,8 +1460,8 @@ static int __wil_tx_vring_tso(struct wil6210_priv *wil, struct vring *vring,
 	}
 
 	/* advance swhead */
-	wil_dbg_txrx(wil, "TSO: Tx swhead %d -> %d\n", swhead, vring->swhead);
 	wil_vring_advance_head(vring, descs_used);
+	wil_dbg_txrx(wil, "TSO: Tx swhead %d -> %d\n", swhead, vring->swhead);
 
 	/* make sure all writes to descriptors (shared memory) are done before
 	 * committing them to HW
@@ -1467,8 +1471,7 @@ static int __wil_tx_vring_tso(struct wil6210_priv *wil, struct vring *vring,
 	wil_w(wil, vring->hwtail, vring->swhead);
 	return 0;
 
-dma_error:
-	wil_err(wil, "TSO: DMA map page error\n");
+mem_error:
 	while (descs_used > 0) {
 		struct wil_ctx *ctx;
 
@@ -1479,14 +1482,11 @@ dma_error:
 		_desc->dma.status = TX_DMA_STATUS_DU;
 		ctx = &vring->ctx[i];
 		wil_txdesc_unmap(dev, d, ctx);
-		if (ctx->skb)
-			dev_kfree_skb_any(ctx->skb);
 		memset(ctx, 0, sizeof(*ctx));
 		descs_used--;
 	}
-
 err_exit:
-	return -EINVAL;
+	return rc;
 }
 
 static int __wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
@@ -1562,8 +1562,11 @@ static int __wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 		_d = &vring->va[i].tx;
 		pa = skb_frag_dma_map(dev, frag, 0, skb_frag_size(frag),
 				      DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(dev, pa)))
+		if (unlikely(dma_mapping_error(dev, pa))) {
+			wil_err(wil, "Tx[%2d] failed to map fragment\n",
+				vring_index);
 			goto dma_error;
+		}
 		vring->ctx[i].mapped_as = wil_mapped_as_page;
 		wil_tx_desc_map(d, pa, len, vring_index);
 		/* no need to check return code -
@@ -1623,9 +1626,6 @@ static int __wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 		_d->dma.status = TX_DMA_STATUS_DU;
 		wil_txdesc_unmap(dev, d, ctx);
 
-		if (ctx->skb)
-			dev_kfree_skb_any(ctx->skb);
-
 		memset(ctx, 0, sizeof(*ctx));
 	}
 
-- 
2.1.4

