Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50757 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756278AbaCQNet (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2014 09:34:49 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 05/21] wil6210: generalize tx desc mapping
Date: Mon, 17 Mar 2014 15:34:09 +0200
Message-ID: <1395063265-6522-6-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140317_143455_148941_53467EAC)
In-Reply-To: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce enum to describe mapping type; allow 'none' in addition to
'single' and 'page'; this is preparation for GSO

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c    | 52 +++++++++++++++---------------
 drivers/net/wireless/ath/wil6210/wil6210.h |  8 ++++-
 2 files changed, 33 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 2eb545e..41f88ee 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -104,6 +104,23 @@ static int wil_vring_alloc(struct wil6210_priv *wil, struct vring *vring)
 	return 0;
 }
 
+static void wil_txdesc_unmap(struct device *dev, struct vring_tx_desc *d,
+			     struct wil_ctx *ctx)
+{
+	dma_addr_t pa = wil_desc_addr(&d->dma.addr);
+	u16 dmalen = le16_to_cpu(d->dma.length);
+	switch (ctx->mapped_as) {
+	case wil_mapped_as_single:
+		dma_unmap_single(dev, pa, dmalen, DMA_TO_DEVICE);
+		break;
+	case wil_mapped_as_page:
+		dma_unmap_page(dev, pa, dmalen, DMA_TO_DEVICE);
+		break;
+	default:
+		break;
+	}
+}
+
 static void wil_vring_free(struct wil6210_priv *wil, struct vring *vring,
 			   int tx)
 {
@@ -122,15 +139,7 @@ static void wil_vring_free(struct wil6210_priv *wil, struct vring *vring,
 
 			ctx = &vring->ctx[vring->swtail];
 			*d = *_d;
-			pa = wil_desc_addr(&d->dma.addr);
-			dmalen = le16_to_cpu(d->dma.length);
-			if (vring->ctx[vring->swtail].mapped_as_page) {
-				dma_unmap_page(dev, pa, dmalen,
-					       DMA_TO_DEVICE);
-			} else {
-				dma_unmap_single(dev, pa, dmalen,
-						 DMA_TO_DEVICE);
-			}
+			wil_txdesc_unmap(dev, d, ctx);
 			if (ctx->skb)
 				dev_kfree_skb_any(ctx->skb);
 			vring->swtail = wil_vring_next_tail(vring);
@@ -845,8 +854,6 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 
 	wil_dbg_txrx(wil, "%s()\n", __func__);
 
-	if (avail < vring->size/8)
-		netif_tx_stop_all_queues(wil_to_ndev(wil));
 	if (avail < 1 + nr_frags) {
 		wil_err(wil, "Tx ring full. No space for %d fragments\n",
 			1 + nr_frags);
@@ -864,6 +871,7 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 
 	if (unlikely(dma_mapping_error(dev, pa)))
 		return -EINVAL;
+	vring->ctx[i].mapped_as = wil_mapped_as_single;
 	/* 1-st segment */
 	wil_tx_desc_map(d, pa, skb_headlen(skb), vring_index);
 	/* Process TCP/UDP checksum offloading */
@@ -889,13 +897,13 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 				DMA_TO_DEVICE);
 		if (unlikely(dma_mapping_error(dev, pa)))
 			goto dma_error;
+		vring->ctx[i].mapped_as = wil_mapped_as_page;
 		wil_tx_desc_map(d, pa, len, vring_index);
 		/* no need to check return code -
 		 * if it succeeded for 1-st descriptor,
 		 * it will succeed here too
 		 */
 		wil_tx_desc_offload_cksum_set(wil, d, skb);
-		vring->ctx[i].mapped_as_page = 1;
 		*_d = *d;
 	}
 	/* for the last seg only */
@@ -924,7 +932,6 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	/* unmap what we have mapped */
 	nr_frags = f + 1; /* frags mapped + one for skb head */
 	for (f = 0; f < nr_frags; f++) {
-		u16 dmalen;
 		struct wil_ctx *ctx;
 
 		i = (swhead + f) % vring->size;
@@ -932,12 +939,7 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 		_d = &(vring->va[i].tx);
 		*d = *_d;
 		_d->dma.status = TX_DMA_STATUS_DU;
-		pa = wil_desc_addr(&d->dma.addr);
-		dmalen = le16_to_cpu(d->dma.length);
-		if (ctx->mapped_as_page)
-			dma_unmap_page(dev, pa, dmalen, DMA_TO_DEVICE);
-		else
-			dma_unmap_single(dev, pa, dmalen, DMA_TO_DEVICE);
+		wil_txdesc_unmap(dev, d, ctx);
 
 		if (ctx->skb)
 			dev_kfree_skb_any(ctx->skb);
@@ -983,6 +985,10 @@ netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	/* set up vring entry */
 	rc = wil_tx_vring(wil, vring, skb);
 
+	/* do we still have enough room in the vring? */
+	if (wil_vring_avail_tx(vring) < vring->size/8)
+		netif_tx_stop_all_queues(wil_to_ndev(wil));
+
 	switch (rc) {
 	case 0:
 		/* statistics will be updated on the tx_complete */
@@ -1041,7 +1047,6 @@ int wil_tx_complete(struct wil6210_priv *wil, int ringid)
 		new_swtail = (lf + 1) % vring->size;
 		while (vring->swtail != new_swtail) {
 			struct vring_tx_desc dd, *d = &dd;
-			dma_addr_t pa;
 			u16 dmalen;
 			struct wil_ctx *ctx = &vring->ctx[vring->swtail];
 			struct sk_buff *skb = ctx->skb;
@@ -1059,12 +1064,7 @@ int wil_tx_complete(struct wil6210_priv *wil, int ringid)
 			wil_hex_dump_txrx("TxC ", DUMP_PREFIX_NONE, 32, 4,
 					  (const void *)d, sizeof(*d), false);
 
-			pa = wil_desc_addr(&d->dma.addr);
-			if (ctx->mapped_as_page)
-				dma_unmap_page(dev, pa, dmalen, DMA_TO_DEVICE);
-			else
-				dma_unmap_single(dev, pa, dmalen,
-						 DMA_TO_DEVICE);
+			wil_txdesc_unmap(dev, d, ctx);
 
 			if (skb) {
 				if (d->dma.error == 0) {
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 574f4d9..11e0898 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -209,13 +209,19 @@ struct pending_wmi_event {
 	} __packed event;
 };
 
+enum { /* for wil_ctx.mapped_as */
+	wil_mapped_as_none = 0,
+	wil_mapped_as_single = 1,
+	wil_mapped_as_page = 2,
+};
+
 /**
  * struct wil_ctx - software context for Vring descriptor
  */
 struct wil_ctx {
 	struct sk_buff *skb;
 	u8 nr_frags;
-	u8 mapped_as_page:1;
+	u8 mapped_as;
 };
 
 union vring_desc;
-- 
1.8.3.2

