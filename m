Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:9677 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbaCQNer (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2014 09:34:47 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 04/21] wil6210: add scatter-gather support
Date: Mon, 17 Mar 2014 15:34:08 +0200
Message-ID: <1395063265-6522-5-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140317_143454_546904_8D961FCE)
In-Reply-To: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When setting fragmented skb for Tx, assign skb to the last descriptor
and set number of fragments in the 1-st one
On Tx complete, HW sets "DU" bit in Tx descriptor only for the last
descriptor; so search for it using number of fragments field.
Middle descriptors may have "DU" bit not set by the hardware.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c |  61 ++++++++++-----
 drivers/net/wireless/ath/wil6210/netdev.c  |   5 +-
 drivers/net/wireless/ath/wil6210/txrx.c    | 115 ++++++++++++++++++-----------
 drivers/net/wireless/ath/wil6210/wil6210.h |   1 +
 4 files changed, 115 insertions(+), 67 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index ea868be..ecdabe4 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -398,6 +398,44 @@ static const struct file_operations fops_reset = {
 	.open  = simple_open,
 };
 
+static void wil_seq_hexdump(struct seq_file *s, void *p, int len,
+			    const char *prefix)
+{
+	char printbuf[16 * 3 + 2];
+	int i = 0;
+	while (i < len) {
+		int l = min(len - i, 16);
+		hex_dump_to_buffer(p + i, l, 16, 1, printbuf,
+				   sizeof(printbuf), false);
+		seq_printf(s, "%s%s\n", prefix, printbuf);
+		i += l;
+	}
+}
+
+static void wil_seq_print_skb(struct seq_file *s, struct sk_buff *skb)
+{
+	int i = 0;
+	int len = skb_headlen(skb);
+	void *p = skb->data;
+	int nr_frags = skb_shinfo(skb)->nr_frags;
+
+	seq_printf(s, "    len = %d\n", len);
+	wil_seq_hexdump(s, p, len, "      : ");
+
+	if (nr_frags) {
+		seq_printf(s, "    nr_frags = %d\n", nr_frags);
+		for (i = 0; i < nr_frags; i++) {
+			const struct skb_frag_struct *frag =
+					&skb_shinfo(skb)->frags[i];
+
+			len = skb_frag_size(frag);
+			p = skb_frag_address_safe(frag);
+			seq_printf(s, "    [%2d] : len = %d\n", i, len);
+			wil_seq_hexdump(s, p, len, "      : ");
+		}
+	}
+}
+
 /*---------Tx/Rx descriptor------------*/
 static int wil_txdesc_debugfs_show(struct seq_file *s, void *data)
 {
@@ -438,26 +476,9 @@ static int wil_txdesc_debugfs_show(struct seq_file *s, void *data)
 		seq_printf(s, "  SKB = %p\n", skb);
 
 		if (skb) {
-			char printbuf[16 * 3 + 2];
-			int i = 0;
-			int len = le16_to_cpu(d->dma.length);
-			void *p = skb->data;
-
-			if (len != skb_headlen(skb)) {
-				seq_printf(s, "!!! len: desc = %d skb = %d\n",
-					   len, skb_headlen(skb));
-				len = min_t(int, len, skb_headlen(skb));
-			}
-
-			seq_printf(s, "    len = %d\n", len);
-
-			while (i < len) {
-				int l = min(len - i, 16);
-				hex_dump_to_buffer(p + i, l, 16, 1, printbuf,
-						   sizeof(printbuf), false);
-				seq_printf(s, "      : %s\n", printbuf);
-				i += l;
-			}
+			skb_get(skb);
+			wil_seq_print_skb(s, skb);
+			kfree_skb(skb);
 		}
 		seq_printf(s, "}\n");
 	} else {
diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index 717178f..5991802 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -127,8 +127,9 @@ void *wil_if_alloc(struct device *dev, void __iomem *csr)
 
 	ndev->netdev_ops = &wil_netdev_ops;
 	ndev->ieee80211_ptr = wdev;
-	ndev->hw_features = NETIF_F_HW_CSUM | NETIF_F_RXCSUM;
-	ndev->features |= NETIF_F_HW_CSUM | NETIF_F_RXCSUM;
+	ndev->hw_features = NETIF_F_HW_CSUM | NETIF_F_RXCSUM |
+			    NETIF_F_SG;
+	ndev->features |= ndev->hw_features;
 	SET_NETDEV_DEV(ndev, wiphy_dev(wdev->wiphy));
 	wdev->netdev = ndev;
 
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 29f13e0..2eb545e 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -774,6 +774,13 @@ static int wil_tx_desc_map(struct vring_tx_desc *d, dma_addr_t pa, u32 len,
 	return 0;
 }
 
+static inline
+void wil_tx_desc_set_nr_frags(struct vring_tx_desc *d, int nr_frags)
+{
+	d->mac.d[2] |= ((nr_frags + 1) <<
+		       MAC_CFG_DESC_TX_2_NUM_OF_DESCRIPTORS_POS);
+}
+
 static int wil_tx_desc_offload_cksum_set(struct wil6210_priv *wil,
 				struct vring_tx_desc *d,
 				struct sk_buff *skb)
@@ -866,8 +873,8 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 		goto dma_error;
 	}
 
-	d->mac.d[2] |= ((nr_frags + 1) <<
-		       MAC_CFG_DESC_TX_2_NUM_OF_DESCRIPTORS_POS);
+	vring->ctx[i].nr_frags = nr_frags;
+	wil_tx_desc_set_nr_frags(d, nr_frags);
 	if (nr_frags)
 		*_d = *d;
 
@@ -883,6 +890,11 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 		if (unlikely(dma_mapping_error(dev, pa)))
 			goto dma_error;
 		wil_tx_desc_map(d, pa, len, vring_index);
+		/* no need to check return code -
+		 * if it succeeded for 1-st descriptor,
+		 * it will succeed here too
+		 */
+		wil_tx_desc_offload_cksum_set(wil, d, skb);
 		vring->ctx[i].mapped_as_page = 1;
 		*_d = *d;
 	}
@@ -1003,6 +1015,7 @@ int wil_tx_complete(struct wil6210_priv *wil, int ringid)
 	int done = 0;
 	int cid = wil->vring2cid_tid[ringid][0];
 	struct wil_net_stats *stats = &wil->sta[cid].stats;
+	volatile struct vring_tx_desc *_d;
 
 	if (!vring->va) {
 		wil_err(wil, "Tx irq[%d]: vring not initialized\n", ringid);
@@ -1012,57 +1025,69 @@ int wil_tx_complete(struct wil6210_priv *wil, int ringid)
 	wil_dbg_txrx(wil, "%s(%d)\n", __func__, ringid);
 
 	while (!wil_vring_is_empty(vring)) {
-		volatile struct vring_tx_desc *_d =
-					      &vring->va[vring->swtail].tx;
-		struct vring_tx_desc dd, *d = &dd;
-		dma_addr_t pa;
-		u16 dmalen;
+		int new_swtail;
 		struct wil_ctx *ctx = &vring->ctx[vring->swtail];
-		struct sk_buff *skb = ctx->skb;
-
-		*d = *_d;
+		/**
+		 * For the fragmented skb, HW will set DU bit only for the
+		 * last fragment. look for it
+		 */
+		int lf = (vring->swtail + ctx->nr_frags) % vring->size;
+		/* TODO: check we are not past head */
 
-		if (!(d->dma.status & TX_DMA_STATUS_DU))
+		_d = &vring->va[lf].tx;
+		if (!(_d->dma.status & TX_DMA_STATUS_DU))
 			break;
 
-		dmalen = le16_to_cpu(d->dma.length);
-		trace_wil6210_tx_done(ringid, vring->swtail, dmalen,
-				      d->dma.error);
-		wil_dbg_txrx(wil,
-			     "Tx[%3d] : %d bytes, status 0x%02x err 0x%02x\n",
-			     vring->swtail, dmalen, d->dma.status,
-			     d->dma.error);
-		wil_hex_dump_txrx("TxC ", DUMP_PREFIX_NONE, 32, 4,
-				  (const void *)d, sizeof(*d), false);
+		new_swtail = (lf + 1) % vring->size;
+		while (vring->swtail != new_swtail) {
+			struct vring_tx_desc dd, *d = &dd;
+			dma_addr_t pa;
+			u16 dmalen;
+			struct wil_ctx *ctx = &vring->ctx[vring->swtail];
+			struct sk_buff *skb = ctx->skb;
+			_d = &vring->va[vring->swtail].tx;
 
-		pa = wil_desc_addr(&d->dma.addr);
-		if (ctx->mapped_as_page)
-			dma_unmap_page(dev, pa, dmalen, DMA_TO_DEVICE);
-		else
-			dma_unmap_single(dev, pa, dmalen, DMA_TO_DEVICE);
+			*d = *_d;
 
-		if (skb) {
-			if (d->dma.error == 0) {
-				ndev->stats.tx_packets++;
-				stats->tx_packets++;
-				ndev->stats.tx_bytes += skb->len;
-				stats->tx_bytes += skb->len;
-			} else {
-				ndev->stats.tx_errors++;
-				stats->tx_errors++;
-			}
+			dmalen = le16_to_cpu(d->dma.length);
+			trace_wil6210_tx_done(ringid, vring->swtail, dmalen,
+					      d->dma.error);
+			wil_dbg_txrx(wil,
+				     "Tx[%3d] : %d bytes, status 0x%02x err 0x%02x\n",
+				     vring->swtail, dmalen, d->dma.status,
+				     d->dma.error);
+			wil_hex_dump_txrx("TxC ", DUMP_PREFIX_NONE, 32, 4,
+					  (const void *)d, sizeof(*d), false);
 
-			dev_kfree_skb_any(skb);
+			pa = wil_desc_addr(&d->dma.addr);
+			if (ctx->mapped_as_page)
+				dma_unmap_page(dev, pa, dmalen, DMA_TO_DEVICE);
+			else
+				dma_unmap_single(dev, pa, dmalen,
+						 DMA_TO_DEVICE);
+
+			if (skb) {
+				if (d->dma.error == 0) {
+					ndev->stats.tx_packets++;
+					stats->tx_packets++;
+					ndev->stats.tx_bytes += skb->len;
+					stats->tx_bytes += skb->len;
+				} else {
+					ndev->stats.tx_errors++;
+					stats->tx_errors++;
+				}
+
+				dev_kfree_skb_any(skb);
+			}
+			memset(ctx, 0, sizeof(*ctx));
+			/* There is no need to touch HW descriptor:
+			 * - ststus bit TX_DMA_STATUS_DU is set by design,
+			 *   so hardware will not try to process this desc.,
+			 * - rest of descriptor will be initialized on Tx.
+			 */
+			vring->swtail = wil_vring_next_tail(vring);
+			done++;
 		}
-		memset(ctx, 0, sizeof(*ctx));
-		/*
-		 * There is no need to touch HW descriptor:
-		 * - ststus bit TX_DMA_STATUS_DU is set by design,
-		 *   so hardware will not try to process this desc.,
-		 * - rest of descriptor will be initialized on Tx.
-		 */
-		vring->swtail = wil_vring_next_tail(vring);
-		done++;
 	}
 	if (wil_vring_avail_tx(vring) > vring->size/4)
 		netif_tx_wake_all_queues(wil_to_ndev(wil));
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index f06f717..574f4d9 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -214,6 +214,7 @@ struct pending_wmi_event {
  */
 struct wil_ctx {
 	struct sk_buff *skb;
+	u8 nr_frags;
 	u8 mapped_as_page:1;
 };
 
-- 
1.8.3.2

