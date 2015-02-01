Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:25275 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbbBAIzi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Feb 2015 03:55:38 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 4/6] wil6210: more Tx debug
Date: Sun,  1 Feb 2015 10:55:14 +0200
Message-Id: <1422780916-8577-5-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150201_095548_057630_690D1313)
In-Reply-To: <1422780916-8577-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1422780916-8577-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Print Tx descriptors
Print ring index for all Tx related messages
Sort prefixes: Tx for transmit, TxC for completion, added "D"
for descriptor related prints

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 85ecea2..8439f65 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -960,16 +960,16 @@ static int __wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 
 	if (avail < 1 + nr_frags) {
 		wil_err_ratelimited(wil,
-				    "Tx ring full. No space for %d fragments\n",
-				    1 + nr_frags);
+				    "Tx ring[%2d] full. No space for %d fragments\n",
+				    vring_index, 1 + nr_frags);
 		return -ENOMEM;
 	}
 	_d = &vring->va[i].tx;
 
 	pa = dma_map_single(dev, skb->data, skb_headlen(skb), DMA_TO_DEVICE);
 
-	wil_dbg_txrx(wil, "Tx skb %d bytes 0x%p -> %pad\n", skb_headlen(skb),
-		     skb->data, &pa);
+	wil_dbg_txrx(wil, "Tx[%2d] skb %d bytes 0x%p -> %pad\n", vring_index,
+		     skb_headlen(skb), skb->data, &pa);
 	wil_hex_dump_txrx("Tx ", DUMP_PREFIX_OFFSET, 16, 1,
 			  skb->data, skb_headlen(skb), false);
 
@@ -980,7 +980,7 @@ static int __wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	wil_tx_desc_map(d, pa, skb_headlen(skb), vring_index);
 	/* Process TCP/UDP checksum offloading */
 	if (wil_tx_desc_offload_cksum_set(wil, d, skb)) {
-		wil_err(wil, "VRING #%d Failed to set cksum, drop packet\n",
+		wil_err(wil, "Tx[%2d] Failed to set cksum, drop packet\n",
 			vring_index);
 		goto dma_error;
 	}
@@ -995,6 +995,9 @@ static int __wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 		int len = skb_frag_size(frag);
 
 		*_d = *d;
+		wil_dbg_txrx(wil, "Tx[%2d] desc[%4d]\n", vring_index, i);
+		wil_hex_dump_txrx("TxD ", DUMP_PREFIX_NONE, 32, 4,
+				  (const void *)d, sizeof(*d), false);
 		i = (swhead + f + 1) % vring->size;
 		_d = &vring->va[i].tx;
 		pa = skb_frag_dma_map(dev, frag, 0, skb_frag_size(frag),
@@ -1014,6 +1017,9 @@ static int __wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	d->dma.d0 |= BIT(DMA_CFG_DESC_TX_0_CMD_MARK_WB_POS);
 	d->dma.d0 |= BIT(DMA_CFG_DESC_TX_0_CMD_DMA_IT_POS);
 	*_d = *d;
+	wil_dbg_txrx(wil, "Tx[%2d] desc[%4d]\n", vring_index, i);
+	wil_hex_dump_txrx("TxD ", DUMP_PREFIX_NONE, 32, 4,
+			  (const void *)d, sizeof(*d), false);
 
 	/* hold reference to skb
 	 * to prevent skb release before accounting
@@ -1021,15 +1027,13 @@ static int __wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	 */
 	vring->ctx[i].skb = skb_get(skb);
 
-	wil_hex_dump_txrx("Tx ", DUMP_PREFIX_NONE, 32, 4,
-			  (const void *)d, sizeof(*d), false);
-
 	if (wil_vring_is_empty(vring)) /* performance monitoring */
 		txdata->idle += get_cycles() - txdata->last_idle;
 
 	/* advance swhead */
 	wil_vring_advance_head(vring, nr_frags + 1);
-	wil_dbg_txrx(wil, "Tx swhead %d -> %d\n", swhead, vring->swhead);
+	wil_dbg_txrx(wil, "Tx[%2d] swhead %d -> %d\n", vring_index, swhead,
+		     vring->swhead);
 	trace_wil6210_tx(vring_index, swhead, skb->len, nr_frags);
 	iowrite32(vring->swhead, wil->csr + HOSTADDR(vring->hwtail));
 
@@ -1211,10 +1215,10 @@ int wil_tx_complete(struct wil6210_priv *wil, int ringid)
 			trace_wil6210_tx_done(ringid, vring->swtail, dmalen,
 					      d->dma.error);
 			wil_dbg_txrx(wil,
-				     "Tx[%3d] : %d bytes, status 0x%02x err 0x%02x\n",
-				     vring->swtail, dmalen, d->dma.status,
-				     d->dma.error);
-			wil_hex_dump_txrx("TxC ", DUMP_PREFIX_NONE, 32, 4,
+				     "TxC[%2d][%3d] : %d bytes, status 0x%02x err 0x%02x\n",
+				     ringid, vring->swtail, dmalen,
+				     d->dma.status, d->dma.error);
+			wil_hex_dump_txrx("TxCD ", DUMP_PREFIX_NONE, 32, 4,
 					  (const void *)d, sizeof(*d), false);
 
 			wil_txdesc_unmap(dev, d, ctx);
-- 
2.1.0

