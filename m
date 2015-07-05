Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:6122 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252AbbGEIqW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jul 2015 04:46:22 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Vladimir Shulman <QCA_shulmanv@QCA.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 11/13] wil6210: TSO implementation
Date: Sun,  5 Jul 2015 10:24:38 +0300
Message-Id: <1436081080-27305-12-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150705_104710_131891_D919FA9B)
In-Reply-To: <1436081080-27305-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1436081080-27305-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver report supported TSO (v4 & v6) and IP checksum offload
in addition to previously supported features. In data path
skbs are checked for non-zero gso_size, and when detected sent
to additional function for processing TSO SKBs. Since HW does not
fully support TSO, additional effort is required from the driver.
Driver partitions the data into mss sized descriptors which are
then DMAed to the HW.

Signed-off-by: Vladimir Shulman <QCA_shulmanv@QCA.qualcomm.com>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/netdev.c |   5 +-
 drivers/net/wireless/ath/wil6210/txrx.c   | 380 +++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/wil6210/txrx.h   |   8 +
 3 files changed, 380 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index 8ef18ac..0a8a8ed 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -173,7 +173,10 @@ void *wil_if_alloc(struct device *dev)
 	wil_set_ethtoolops(ndev);
 	ndev->ieee80211_ptr = wdev;
 	ndev->hw_features = NETIF_F_HW_CSUM | NETIF_F_RXCSUM |
-			    NETIF_F_SG | NETIF_F_GRO;
+			    NETIF_F_SG | NETIF_F_GRO |
+			    NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_IP_CSUM |
+			    NETIF_F_IPV6_CSUM;
+
 	ndev->features |= ndev->hw_features;
 	SET_NETDEV_DEV(ndev, wiphy_dev(wdev->wiphy));
 	wdev->netdev = ndev;
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 112192f1..8a2f2b6 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -1061,15 +1061,23 @@ static int wil_tx_desc_map(struct vring_tx_desc *d, dma_addr_t pa, u32 len,
 static inline
 void wil_tx_desc_set_nr_frags(struct vring_tx_desc *d, int nr_frags)
 {
-	d->mac.d[2] |= ((nr_frags + 1) <<
-		       MAC_CFG_DESC_TX_2_NUM_OF_DESCRIPTORS_POS);
+	d->mac.d[2] |= (nr_frags << MAC_CFG_DESC_TX_2_NUM_OF_DESCRIPTORS_POS);
 }
 
-static int wil_tx_desc_offload_cksum_set(struct wil6210_priv *wil,
-					 struct vring_tx_desc *d,
-					 struct sk_buff *skb)
-{
+/**
+ * Sets the descriptor @d up for csum and/or TSO offloading. The corresponding
+ * @skb is used to obtain the protocol and headers length.
+ * @tso_desc_type is a descriptor type for TSO: -1 - no TSO send,
+ * 0 - a header, 1 - first data, 2 - middle, 3 - last descriptor.
+ * Returns the protocol: 0 - not TCP, 1 - TCPv4, 2 - TCPv6.
+ * Note, if d==NULL, the function only returns the protocol result.
+ */
+
+static int wil_tx_desc_offload_setup_tso(struct vring_tx_desc *d,
+					 struct sk_buff *skb,
+					 int tso_desc_type) {
 	int protocol;
+	int is_ip4 = 0;
 
 	if (skb->ip_summed != CHECKSUM_PARTIAL)
 		return 0;
@@ -1080,6 +1088,7 @@ static int wil_tx_desc_offload_cksum_set(struct wil6210_priv *wil,
 	case cpu_to_be16(ETH_P_IP):
 		protocol = ip_hdr(skb)->protocol;
 		d->dma.b11 |= BIT(DMA_CFG_DESC_TX_OFFLOAD_CFG_L3T_IPV4_POS);
+		is_ip4 = 1;
 		break;
 	case cpu_to_be16(ETH_P_IPV6):
 		protocol = ipv6_hdr(skb)->nexthdr;
@@ -1094,6 +1103,13 @@ static int wil_tx_desc_offload_cksum_set(struct wil6210_priv *wil,
 		/* L4 header len: TCP header length */
 		d->dma.d0 |=
 		(tcp_hdrlen(skb) & DMA_CFG_DESC_TX_0_L4_LENGTH_MSK);
+
+		/* Setup TSO: bit and desc type */
+		d->dma.d0 |= (BIT(DMA_CFG_DESC_TX_0_TCP_SEG_EN_POS)) |
+			(tso_desc_type <<
+			 DMA_CFG_DESC_TX_0_SEGMENT_BUF_DETAILS_POS);
+		d->dma.d0 |= (is_ip4 <<
+			      DMA_CFG_DESC_TX_0_IPV4_CHECKSUM_EN_POS);
 		break;
 	case IPPROTO_UDP:
 		/* L4 header len: UDP header length */
@@ -1113,6 +1129,334 @@ static int wil_tx_desc_offload_cksum_set(struct wil6210_priv *wil,
 	return 0;
 }
 
+/**
+ * Sets the descriptor @d up for csum. The corresponding
+ * @skb is used to obtain the protocol and headers length.
+ * Returns the protocol: 0 - not TCP, 1 - TCPv4, 2 - TCPv6.
+ * Note, if d==NULL, the function only returns the protocol result.
+ *
+ * It is very similar to previous wil_tx_desc_offload_setup_tso. This
+ * is "if unrolling" to optimize the critical path.
+ */
+
+static int wil_tx_desc_offload_setup(struct vring_tx_desc *d,
+				     struct sk_buff *skb){
+	int protocol;
+
+	if (skb->ip_summed != CHECKSUM_PARTIAL)
+		return 0;
+
+	d->dma.b11 = ETH_HLEN; /* MAC header length */
+
+	switch (skb->protocol) {
+	case cpu_to_be16(ETH_P_IP):
+		protocol = ip_hdr(skb)->protocol;
+		d->dma.b11 |= BIT(DMA_CFG_DESC_TX_OFFLOAD_CFG_L3T_IPV4_POS);
+		break;
+	case cpu_to_be16(ETH_P_IPV6):
+		protocol = ipv6_hdr(skb)->nexthdr;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (protocol) {
+	case IPPROTO_TCP:
+		d->dma.d0 |= (2 << DMA_CFG_DESC_TX_0_L4_TYPE_POS);
+		/* L4 header len: TCP header length */
+		d->dma.d0 |=
+		(tcp_hdrlen(skb) & DMA_CFG_DESC_TX_0_L4_LENGTH_MSK);
+		break;
+	case IPPROTO_UDP:
+		/* L4 header len: UDP header length */
+		d->dma.d0 |=
+		(sizeof(struct udphdr) & DMA_CFG_DESC_TX_0_L4_LENGTH_MSK);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	d->dma.ip_length = skb_network_header_len(skb);
+	/* Enable TCP/UDP checksum */
+	d->dma.d0 |= BIT(DMA_CFG_DESC_TX_0_TCP_UDP_CHECKSUM_EN_POS);
+	/* Calculate pseudo-header */
+	d->dma.d0 |= BIT(DMA_CFG_DESC_TX_0_PSEUDO_HEADER_CALC_EN_POS);
+
+	return 0;
+}
+
+static inline void wil_tx_last_desc(struct vring_tx_desc *d)
+{
+	d->dma.d0 |= BIT(DMA_CFG_DESC_TX_0_CMD_EOP_POS) |
+	      BIT(DMA_CFG_DESC_TX_0_CMD_MARK_WB_POS) |
+	      BIT(DMA_CFG_DESC_TX_0_CMD_DMA_IT_POS);
+}
+
+static inline void wil_set_tx_desc_last_tso(volatile struct vring_tx_desc *d)
+{
+	d->dma.d0 |= wil_tso_type_lst <<
+		  DMA_CFG_DESC_TX_0_SEGMENT_BUF_DETAILS_POS;
+}
+
+static int __wil_tx_vring_tso(struct wil6210_priv *wil, struct vring *vring,
+			      struct sk_buff *skb)
+{
+	struct device *dev = wil_to_dev(wil);
+
+	/* point to descriptors in shared memory */
+	volatile struct vring_tx_desc *_desc = NULL, *_hdr_desc,
+				      *_first_desc = NULL;
+
+	/* pointers to shadow descriptors */
+	struct vring_tx_desc desc_mem, hdr_desc_mem, first_desc_mem,
+			     *d = &hdr_desc_mem, *hdr_desc = &hdr_desc_mem,
+			     *first_desc = &first_desc_mem;
+
+	/* pointer to shadow descriptors' context */
+	struct wil_ctx *hdr_ctx, *first_ctx = NULL;
+
+	int descs_used = 0; /* total number of used descriptors */
+	int sg_desc_cnt = 0; /* number of descriptors for current mss*/
+
+	u32 swhead = vring->swhead;
+	int used, avail = wil_vring_avail_tx(vring);
+	int nr_frags = skb_shinfo(skb)->nr_frags;
+	int min_desc_required = nr_frags + 1;
+	int mss = skb_shinfo(skb)->gso_size;	/* payload size w/o headers */
+	int f, len, hdrlen, headlen;
+	int vring_index = vring - wil->vring_tx;
+	struct vring_tx_data *txdata = &wil->vring_tx_data[vring_index];
+	uint i = swhead;
+	dma_addr_t pa;
+	const skb_frag_t *frag = NULL;
+	int rem_data = mss;
+	int lenmss;
+	int hdr_compensation_need = true;
+	int desc_tso_type = wil_tso_type_first;
+
+	wil_dbg_txrx(wil, "%s() %d bytes to vring %d\n",
+		     __func__, skb->len, vring_index);
+
+	if (unlikely(!txdata->enabled))
+		return -EINVAL;
+
+	/* A typical page 4K is 3-4 payloads, we assume each fragment
+	 * is a full payload, that's how min_desc_required has been
+	 * calculated. In real we might need more or less descriptors,
+	 * this is the initial check only.
+	 */
+	if (unlikely(avail < min_desc_required)) {
+		wil_err_ratelimited(wil,
+				    "TSO: Tx ring[%2d] full. No space for %d fragments\n",
+				    vring_index, min_desc_required);
+		return -ENOMEM;
+	}
+
+	/* Header Length = MAC header len + IP header len + TCP header len */
+	hdrlen = ETH_HLEN +
+		(int)skb_network_header_len(skb) +
+		tcp_hdrlen(skb);
+
+	if (skb->protocol == cpu_to_be16(ETH_P_IP)) {
+		/* TCP v4, zero out the IP length and IPv4 checksum fields
+		 * as required by the offloading doc
+		 */
+		ip_hdr(skb)->tot_len = 0;
+		ip_hdr(skb)->check = 0;
+	} else {
+		/* TCP v6, zero out the payload length */
+		ipv6_hdr(skb)->payload_len = 0;
+	}
+
+	_hdr_desc = &vring->va[i].tx;
+
+	pa = dma_map_single(dev, skb->data, hdrlen, DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(dev, pa))) {
+		wil_err(wil, "TSO: Skb head DMA map error\n");
+		goto err_exit;
+	}
+
+	wil_tx_desc_map(hdr_desc, pa, hdrlen, vring_index);
+	wil_tx_desc_offload_setup_tso(hdr_desc, skb, wil_tso_type_hdr);
+	wil_tx_last_desc(hdr_desc);
+
+	vring->ctx[i].mapped_as = wil_mapped_as_single;
+	hdr_ctx = &vring->ctx[i];
+
+	descs_used++;
+	headlen = skb_headlen(skb) - hdrlen;
+
+	for (f = headlen ? -1 : 0; f < nr_frags; f++)  {
+		if (headlen) {
+			len = headlen;
+			wil_dbg_txrx(wil, "TSO: process skb head, len %u\n",
+				     len);
+		} else {
+			frag = &skb_shinfo(skb)->frags[f];
+			len = frag->size;
+			wil_dbg_txrx(wil, "TSO: frag[%d]: len %u\n", f, len);
+		}
+
+		while (len) {
+			wil_dbg_txrx(wil,
+				     "TSO: len %d, rem_data %d, descs_used %d\n",
+				     len, rem_data, descs_used);
+
+			if (descs_used == avail)  {
+				wil_err(wil, "TSO: ring overflow\n");
+				goto dma_error;
+			}
+
+			lenmss = min_t(int, rem_data, len);
+			i = (swhead + descs_used) % vring->size;
+			wil_dbg_txrx(wil, "TSO: lenmss %d, i %d\n", lenmss, i);
+
+			if (!headlen) {
+				pa = skb_frag_dma_map(dev, frag,
+						      frag->size - len, lenmss,
+						      DMA_TO_DEVICE);
+				vring->ctx[i].mapped_as = wil_mapped_as_page;
+			} else {
+				pa = dma_map_single(dev,
+						    skb->data +
+						    skb_headlen(skb) - headlen,
+						    lenmss,
+						    DMA_TO_DEVICE);
+				vring->ctx[i].mapped_as = wil_mapped_as_single;
+				headlen -= lenmss;
+			}
+
+			if (unlikely(dma_mapping_error(dev, pa)))
+				goto dma_error;
+
+			_desc = &vring->va[i].tx;
+
+			if (!_first_desc) {
+				_first_desc = _desc;
+				first_ctx = &vring->ctx[i];
+				d = first_desc;
+			} else {
+				d = &desc_mem;
+			}
+
+			wil_tx_desc_map(d, pa, lenmss, vring_index);
+			wil_tx_desc_offload_setup_tso(d, skb, desc_tso_type);
+
+			/* use tso_type_first only once */
+			desc_tso_type = wil_tso_type_mid;
+
+			descs_used++;  /* desc used so far */
+			sg_desc_cnt++; /* desc used for this segment */
+			len -= lenmss;
+			rem_data -= lenmss;
+
+			wil_dbg_txrx(wil,
+				     "TSO: len %d, rem_data %d, descs_used %d, sg_desc_cnt %d,\n",
+				     len, rem_data, descs_used, sg_desc_cnt);
+
+			/* Close the segment if reached mss size or last frag*/
+			if (rem_data == 0 || (f == nr_frags - 1 && len == 0)) {
+				if (hdr_compensation_need) {
+					/* first segment include hdr desc for
+					 * release
+					 */
+					hdr_ctx->nr_frags = sg_desc_cnt;
+					wil_tx_desc_set_nr_frags(first_desc,
+								 sg_desc_cnt +
+								 1);
+					hdr_compensation_need = false;
+				} else {
+					wil_tx_desc_set_nr_frags(first_desc,
+								 sg_desc_cnt);
+				}
+				first_ctx->nr_frags = sg_desc_cnt - 1;
+
+				wil_tx_last_desc(d);
+
+				/* first descriptor may also be the last
+				 * for this mss - make sure not to copy
+				 * it twice
+				 */
+				if (first_desc != d)
+					*_first_desc = *first_desc;
+
+				/*last descriptor will be copied at the end
+				 * of this TS processing
+				 */
+				if (f < nr_frags - 1 || len > 0)
+					*_desc = *d;
+
+				rem_data = mss;
+				_first_desc = NULL;
+				sg_desc_cnt = 0;
+			} else if (first_desc != d) /* update mid descriptor */
+					*_desc = *d;
+		}
+	}
+
+	/* first descriptor may also be the last.
+	 * in this case d pointer is invalid
+	 */
+	if (_first_desc == _desc)
+		d = first_desc;
+
+	/* Last data descriptor */
+	wil_set_tx_desc_last_tso(d);
+	*_desc = *d;
+
+	/* Fill the total number of descriptors in first desc (hdr)*/
+	wil_tx_desc_set_nr_frags(hdr_desc, descs_used);
+	*_hdr_desc = *hdr_desc;
+
+	/* hold reference to skb
+	 * to prevent skb release before accounting
+	 * in case of immediate "tx done"
+	 */
+	vring->ctx[i].skb = skb_get(skb);
+
+	/* performance monitoring */
+	used = wil_vring_used_tx(vring);
+	if (wil_val_in_range(vring_idle_trsh,
+			     used, used + descs_used)) {
+		txdata->idle += get_cycles() - txdata->last_idle;
+		wil_dbg_txrx(wil,  "Ring[%2d] not idle %d -> %d\n",
+			     vring_index, used, used + descs_used);
+	}
+
+	/* advance swhead */
+	wil_dbg_txrx(wil, "TSO: Tx swhead %d -> %d\n", swhead, vring->swhead);
+	wil_vring_advance_head(vring, descs_used);
+
+	/* make sure all writes to descriptors (shared memory) are done before
+	 * committing them to HW
+	 */
+	wmb();
+
+	iowrite32(vring->swhead, wil->csr + HOSTADDR(vring->hwtail));
+	return 0;
+
+dma_error:
+	wil_err(wil, "TSO: DMA map page error\n");
+	while (descs_used > 0) {
+		struct wil_ctx *ctx;
+
+		i = (swhead + descs_used) % vring->size;
+		d = (struct vring_tx_desc *)&vring->va[i].tx;
+		_desc = &vring->va[i].tx;
+		*d = *_desc;
+		_desc->dma.status = TX_DMA_STATUS_DU;
+		ctx = &vring->ctx[i];
+		wil_txdesc_unmap(dev, d, ctx);
+		if (ctx->skb)
+			dev_kfree_skb_any(ctx->skb);
+		memset(ctx, 0, sizeof(*ctx));
+		descs_used--;
+	}
+
+err_exit:
+	return -EINVAL;
+}
+
 static int __wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 			  struct sk_buff *skb)
 {
@@ -1131,7 +1475,8 @@ static int __wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	bool mcast = (vring_index == wil->bcast_vring);
 	uint len = skb_headlen(skb);
 
-	wil_dbg_txrx(wil, "%s()\n", __func__);
+	wil_dbg_txrx(wil, "%s() %d bytes to vring %d\n",
+		     __func__, skb->len, vring_index);
 
 	if (unlikely(!txdata->enabled))
 		return -EINVAL;
@@ -1162,14 +1507,14 @@ static int __wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 			d->mac.d[0] |= (1 << MAC_CFG_DESC_TX_0_MCS_INDEX_POS);
 	}
 	/* Process TCP/UDP checksum offloading */
-	if (unlikely(wil_tx_desc_offload_cksum_set(wil, d, skb))) {
+	if (unlikely(wil_tx_desc_offload_setup(d, skb))) {
 		wil_err(wil, "Tx[%2d] Failed to set cksum, drop packet\n",
 			vring_index);
 		goto dma_error;
 	}
 
 	vring->ctx[i].nr_frags = nr_frags;
-	wil_tx_desc_set_nr_frags(d, nr_frags);
+	wil_tx_desc_set_nr_frags(d, nr_frags + 1);
 
 	/* middle segments */
 	for (; f < nr_frags; f++) {
@@ -1193,7 +1538,7 @@ static int __wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 		 * if it succeeded for 1-st descriptor,
 		 * it will succeed here too
 		 */
-		wil_tx_desc_offload_cksum_set(wil, d, skb);
+		wil_tx_desc_offload_setup(d, skb);
 	}
 	/* for the last seg only */
 	d->dma.d0 |= BIT(DMA_CFG_DESC_TX_0_CMD_EOP_POS);
@@ -1224,6 +1569,12 @@ static int __wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	wil_dbg_txrx(wil, "Tx[%2d] swhead %d -> %d\n", vring_index, swhead,
 		     vring->swhead);
 	trace_wil6210_tx(vring_index, swhead, skb->len, nr_frags);
+
+	/* make sure all writes to descriptors (shared memory) are done before
+	 * committing them to HW
+	 */
+	wmb();
+
 	iowrite32(vring->swhead, wil->csr + HOSTADDR(vring->hwtail));
 
 	return 0;
@@ -1257,8 +1608,12 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	int rc;
 
 	spin_lock(&txdata->lock);
-	rc = __wil_tx_vring(wil, vring, skb);
+
+	rc = (skb_is_gso(skb) ? __wil_tx_vring_tso : __wil_tx_vring)
+	     (wil, vring, skb);
+
 	spin_unlock(&txdata->lock);
+
 	return rc;
 }
 
@@ -1385,7 +1740,8 @@ int wil_tx_complete(struct wil6210_priv *wil, int ringid)
 		struct wil_ctx *ctx = &vring->ctx[vring->swtail];
 		/**
 		 * For the fragmented skb, HW will set DU bit only for the
-		 * last fragment. look for it
+		 * last fragment. look for it.
+		 * In TSO the first DU will include hdr desc
 		 */
 		int lf = (vring->swtail + ctx->nr_frags) % vring->size;
 		/* TODO: check we are not past head */
diff --git a/drivers/net/wireless/ath/wil6210/txrx.h b/drivers/net/wireless/ath/wil6210/txrx.h
index 0c46384..82a8f9a 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.h
+++ b/drivers/net/wireless/ath/wil6210/txrx.h
@@ -291,6 +291,14 @@ struct vring_tx_dma {
 	__le16 length;
 } __packed;
 
+/* TSO type used in dma descriptor d0 bits 11-12 */
+enum {
+	wil_tso_type_hdr = 0,
+	wil_tso_type_first = 1,
+	wil_tso_type_mid  = 2,
+	wil_tso_type_lst  = 3,
+};
+
 /* Rx descriptor - MAC part
  * [dword 0]
  * bit  0.. 3 : tid:4 The QoS (b3-0) TID Field
-- 
2.1.4

