Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:63353 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab3GKPEC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 11:04:02 -0400
Cc: Kirshenbaum Erez <erezk@wilocity.com>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 4/5] wil6210: Introduce struct for sw context
Date: Thu, 11 Jul 2013 18:03:40 +0300
Message-ID: <1373555021-11763-5-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130711_170415_151526_A032CF38)
In-Reply-To: <1373555021-11763-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1373555021-11763-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable adding more data to the SW context.
For now, add flag "mapped_as_page", to separate decisions on free-ing skb
and type of DMA mapping.
This allows linking skb itself to any descriptor of fragmented skb.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c |  4 +--
 drivers/net/wireless/ath/wil6210/txrx.c    | 58 +++++++++++++++++-------------
 drivers/net/wireless/ath/wil6210/wil6210.h | 10 +++++-
 3 files changed, 44 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index e8308ec..971ce46 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -51,7 +51,7 @@ static void wil_print_vring(struct seq_file *s, struct wil6210_priv *wil,
 			if ((i % 64) == 0 && (i != 0))
 				seq_printf(s, "\n");
 			seq_printf(s, "%s", (d->dma.status & BIT(0)) ?
-					"S" : (vring->ctx[i] ? "H" : "h"));
+					"S" : (vring->ctx[i].skb ? "H" : "h"));
 		}
 		seq_printf(s, "\n");
 	}
@@ -406,7 +406,7 @@ static int wil_txdesc_debugfs_show(struct seq_file *s, void *data)
 		volatile struct vring_tx_desc *d =
 				&(vring->va[dbg_txdesc_index].tx);
 		volatile u32 *u = (volatile u32 *)d;
-		struct sk_buff *skb = vring->ctx[dbg_txdesc_index];
+		struct sk_buff *skb = vring->ctx[dbg_txdesc_index].skb;
 
 		seq_printf(s, "Tx[%3d] = {\n", dbg_txdesc_index);
 		seq_printf(s, "  MAC = 0x%08x 0x%08x 0x%08x 0x%08x\n",
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index dd5f35e..44cdd2a 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -70,7 +70,7 @@ static int wil_vring_alloc(struct wil6210_priv *wil, struct vring *vring)
 
 	vring->swhead = 0;
 	vring->swtail = 0;
-	vring->ctx = kzalloc(vring->size * sizeof(vring->ctx[0]), GFP_KERNEL);
+	vring->ctx = kcalloc(vring->size, sizeof(vring->ctx[0]), GFP_KERNEL);
 	if (!vring->ctx) {
 		vring->va = NULL;
 		return -ENOMEM;
@@ -108,39 +108,39 @@ static void wil_vring_free(struct wil6210_priv *wil, struct vring *vring,
 
 	while (!wil_vring_is_empty(vring)) {
 		dma_addr_t pa;
-		struct sk_buff *skb;
 		u16 dmalen;
+		struct wil_ctx *ctx;
 
 		if (tx) {
 			struct vring_tx_desc dd, *d = &dd;
 			volatile struct vring_tx_desc *_d =
 					&vring->va[vring->swtail].tx;
 
+			ctx = &vring->ctx[vring->swtail];
 			*d = *_d;
 			pa = wil_desc_addr(&d->dma.addr);
 			dmalen = le16_to_cpu(d->dma.length);
-			skb = vring->ctx[vring->swtail];
-			if (skb) {
-				dma_unmap_single(dev, pa, dmalen,
-						 DMA_TO_DEVICE);
-				dev_kfree_skb_any(skb);
-				vring->ctx[vring->swtail] = NULL;
-			} else {
+			if (vring->ctx[vring->swtail].mapped_as_page) {
 				dma_unmap_page(dev, pa, dmalen,
 					       DMA_TO_DEVICE);
+			} else {
+				dma_unmap_single(dev, pa, dmalen,
+						 DMA_TO_DEVICE);
 			}
+			if (ctx->skb)
+				dev_kfree_skb_any(ctx->skb);
 			vring->swtail = wil_vring_next_tail(vring);
 		} else { /* rx */
 			struct vring_rx_desc dd, *d = &dd;
 			volatile struct vring_rx_desc *_d =
 					&vring->va[vring->swhead].rx;
 
+			ctx = &vring->ctx[vring->swhead];
 			*d = *_d;
 			pa = wil_desc_addr(&d->dma.addr);
 			dmalen = le16_to_cpu(d->dma.length);
-			skb = vring->ctx[vring->swhead];
 			dma_unmap_single(dev, pa, dmalen, DMA_FROM_DEVICE);
-			kfree_skb(skb);
+			kfree_skb(ctx->skb);
 			wil_vring_advance_head(vring, 1);
 		}
 	}
@@ -187,7 +187,7 @@ static int wil_vring_alloc_skb(struct wil6210_priv *wil, struct vring *vring,
 	d->dma.status = 0; /* BIT(0) should be 0 for HW_OWNED */
 	d->dma.length = cpu_to_le16(sz);
 	*_d = *d;
-	vring->ctx[i] = skb;
+	vring->ctx[i].skb = skb;
 
 	return 0;
 }
@@ -352,11 +352,11 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 		return NULL;
 	}
 
-	skb = vring->ctx[vring->swhead];
+	skb = vring->ctx[vring->swhead].skb;
 	d = wil_skb_rxdesc(skb);
 	*d = *_d;
 	pa = wil_desc_addr(&d->dma.addr);
-	vring->ctx[vring->swhead] = NULL;
+	vring->ctx[vring->swhead].skb = NULL;
 	wil_vring_advance_head(vring, 1);
 
 	dma_unmap_single(dev, pa, sz, DMA_FROM_DEVICE);
@@ -703,7 +703,7 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 		if (unlikely(dma_mapping_error(dev, pa)))
 			goto dma_error;
 		wil_tx_desc_map(d, pa, len, vring_index);
-		vring->ctx[i] = NULL;
+		vring->ctx[i].mapped_as_page = 1;
 		*_d = *d;
 	}
 	/* for the last seg only */
@@ -724,7 +724,7 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	 * to prevent skb release before accounting
 	 * in case of immediate "tx done"
 	 */
-	vring->ctx[i] = skb_get(skb);
+	vring->ctx[i].skb = skb_get(skb);
 
 	return 0;
  dma_error:
@@ -732,6 +732,7 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	/* Note: increment @f to operate with positive index */
 	for (f++; f > 0; f--) {
 		u16 dmalen;
+		struct wil_ctx *ctx = &vring->ctx[i];
 
 		i = (swhead + f) % vring->size;
 		_d = &(vring->va[i].tx);
@@ -739,10 +740,15 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 		_d->dma.status = TX_DMA_STATUS_DU;
 		pa = wil_desc_addr(&d->dma.addr);
 		dmalen = le16_to_cpu(d->dma.length);
-		if (vring->ctx[i])
-			dma_unmap_single(dev, pa, dmalen, DMA_TO_DEVICE);
-		else
+		if (ctx->mapped_as_page)
 			dma_unmap_page(dev, pa, dmalen, DMA_TO_DEVICE);
+		else
+			dma_unmap_single(dev, pa, dmalen, DMA_TO_DEVICE);
+
+		if (ctx->skb)
+			dev_kfree_skb_any(ctx->skb);
+
+		memset(ctx, 0, sizeof(*ctx));
 	}
 
 	return -EINVAL;
@@ -821,8 +827,9 @@ int wil_tx_complete(struct wil6210_priv *wil, int ringid)
 					      &vring->va[vring->swtail].tx;
 		struct vring_tx_desc dd, *d = &dd;
 		dma_addr_t pa;
-		struct sk_buff *skb;
 		u16 dmalen;
+		struct wil_ctx *ctx = &vring->ctx[vring->swtail];
+		struct sk_buff *skb = ctx->skb;
 
 		*d = *_d;
 
@@ -840,7 +847,11 @@ int wil_tx_complete(struct wil6210_priv *wil, int ringid)
 				  (const void *)d, sizeof(*d), false);
 
 		pa = wil_desc_addr(&d->dma.addr);
-		skb = vring->ctx[vring->swtail];
+		if (ctx->mapped_as_page)
+			dma_unmap_page(dev, pa, dmalen, DMA_TO_DEVICE);
+		else
+			dma_unmap_single(dev, pa, dmalen, DMA_TO_DEVICE);
+
 		if (skb) {
 			if (d->dma.error == 0) {
 				ndev->stats.tx_packets++;
@@ -849,12 +860,9 @@ int wil_tx_complete(struct wil6210_priv *wil, int ringid)
 				ndev->stats.tx_errors++;
 			}
 
-			dma_unmap_single(dev, pa, dmalen, DMA_TO_DEVICE);
 			dev_kfree_skb_any(skb);
-			vring->ctx[vring->swtail] = NULL;
-		} else {
-			dma_unmap_page(dev, pa, dmalen, DMA_TO_DEVICE);
 		}
+		memset(ctx, 0, sizeof(*ctx));
 		/*
 		 * There is no need to touch HW descriptor:
 		 * - ststus bit TX_DMA_STATUS_DU is set by design,
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 129c480..c4a5163 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -183,6 +183,14 @@ struct pending_wmi_event {
 	} __packed event;
 };
 
+/**
+ * struct wil_ctx - software context for Vring descriptor
+ */
+struct wil_ctx {
+	struct sk_buff *skb;
+	u8 mapped_as_page:1;
+};
+
 union vring_desc;
 
 struct vring {
@@ -192,7 +200,7 @@ struct vring {
 	u32 swtail;
 	u32 swhead;
 	u32 hwtail; /* write here to inform hw */
-	void **ctx; /* void *ctx[size] - software context */
+	struct wil_ctx *ctx; /* ctx[size] - software context */
 };
 
 enum { /* for wil6210_priv.status */
-- 
1.8.1.2

