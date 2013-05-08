Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:48475 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab3EHJfv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 May 2013 05:35:51 -0400
Received: by mail-ea0-f171.google.com with SMTP id b10so819458eae.16
        for <linux-wireless@vger.kernel.org>; Wed, 08 May 2013 02:35:50 -0700 (PDT)
From: wilocity.git@gmail.com
To: qca_vkondrat@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Wilocity Git <wilocity.git@gmail.com>
Subject: [PATCH 3/3] Wi6210: Added TSO support
Date: Wed,  8 May 2013 11:35:04 +0300
Message-Id: <1368002104-11623-1-git-send-email-wilocity.git@gmail.com> (sfid-20130508_113555_776040_1E06E9C1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Erez Kirshenbaum <erezk@wilocitycom>

Added TCP offloading support in TX. The 1st descriptor holds the TCP/IP header used as a pattern
for all packets. Large send data is assigned to descriptors, each chain has MPDU size. The header
descriptor does not have a valid DU value so we ignore it in tx_complete. Due to hardware design
the first data descriptor has increased number of descriptors which compensates the header descriptor.

Signed-off-by: Erez Kirshenbaum <erezk@wilocitycom>
Signed-off-by: Wilocity Git <wilocity.git@gmail.com>
---
 drivers/net/wireless/ath/wil6210/netdev.c  |   3 +-
 drivers/net/wireless/ath/wil6210/txrx.c    | 248 +++++++++++++++++++++++++++--
 drivers/net/wireless/ath/wil6210/wil6210.h |   2 +-
 3 files changed, 241 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index b294729..8449b78 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -100,7 +100,8 @@ void *wil_if_alloc(struct device *dev, void __iomem *csr)
 
 	ndev->netdev_ops = &wil_netdev_ops;
 	ndev->ieee80211_ptr = wdev;
-	ndev->hw_features = NETIF_F_HW_CSUM | NETIF_F_RXCSUM | NETIF_F_SG;
+	ndev->hw_features = NETIF_F_HW_CSUM | NETIF_F_RXCSUM |
+		NETIF_F_SG | NETIF_F_TSO;
 	ndev->features |= NETIF_F_HW_CSUM | NETIF_F_RXCSUM | NETIF_F_SG;
 	SET_NETDEV_DEV(ndev, wiphy_dev(wdev->wiphy));
 	wdev->netdev = ndev;
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 5076abd..b81ff5d 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -647,8 +647,16 @@ static int wil_tx_desc_map(volatile struct vring_tx_desc *d,
 	return 0;
 }
 
-static void wil_tx_desc_offload_setup(struct vring_tx_desc *d,
-				struct sk_buff *skb)
+/**
+ * Sets the descriptor @d up for csum and/or TSO offloaing. The corresponding
+ * @skb is used to obtain the protocol and headers length.
+ * @tso_desc_type is a descriptor type for TSO: -1 - no TSO send,
+ * 0 - a header, 1 - first data, 2 - middle, 3 - last descriptor.
+ * Returns the protocol: 0 - not TCP, 1 - TCPv4, 2 - TCPv6.
+ * Note, if d==NULL, the function only returns the protocol result.
+ */
+static int wil_tx_desc_offload_setup(struct vring_tx_desc *d,
+				struct sk_buff *skb, int tso_desc_type)
 {
 	int is_ip4 = 0, is_ip6 = 0, is_tcp = 0, is_udp = 0;
 
@@ -670,7 +678,7 @@ static void wil_tx_desc_offload_setup(struct vring_tx_desc *d,
 			is_udp = 1;
 	}
 
-	if (is_ip4 || is_ip6) {
+	if (d && (is_ip4 || is_ip6)) {
 		if (is_ip4)
 			d->dma.offload_cfg |=
 				BIT(DMA_CFG_DESC_TX_OFFLOAD_CFG_L3T_IPV4_POS);
@@ -693,6 +701,19 @@ static void wil_tx_desc_offload_setup(struct vring_tx_desc *d,
 				d->dma.d0 |=
 					(tcp_hdrlen(skb) &
 					DMA_CFG_DESC_TX_0_L4_LENGTH_MSK);
+				if (tso_desc_type != -1) {
+					/* Setup TSO: the bit and desc type */
+					d->dma.d0 |=
+				       (BIT(DMA_CFG_DESC_TX_0_TCP_SEG_EN_POS))
+				       | (tso_desc_type <<
+				    DMA_CFG_DESC_TX_0_SEGMENT_BUF_DETAILS_POS);
+					if (is_ip4)
+						d->dma.d0 |=
+				BIT(DMA_CFG_DESC_TX_0_IPV4_CHECKSUM_EN_POS);
+					d->mac.d[2] |= (1 << /* Descs count */
+				MAC_CFG_DESC_TX_2_NUM_OF_DESCRIPTORS_POS);
+
+				}
 			} else  {
 				/* L4 header len: UDP header length */
 				d->dma.d0 |=
@@ -701,6 +722,213 @@ static void wil_tx_desc_offload_setup(struct vring_tx_desc *d,
 			}
 		}
 	}
+	return is_tcp ? (is_ip4 ? 1 : 2) : 0;
+}
+
+static inline void wil_tx_last_desc(struct vring_tx_desc *d, int vring_index)
+{
+	d->dma.d0 |= BIT(DMA_CFG_DESC_TX_0_CMD_EOP_POS)
+		| BIT(9) /* BUG: undocumented bit */
+		| BIT(DMA_CFG_DESC_TX_0_CMD_DMA_IT_POS)
+		| (vring_index << DMA_CFG_DESC_TX_0_QID_POS);
+}
+
+static inline void wil_set_tx_desc_count(struct vring_tx_desc *d, int cnt)
+{
+	d->mac.d[2] &= ~(MAC_CFG_DESC_TX_2_NUM_OF_DESCRIPTORS_MSK);
+	d->mac.d[2] |= (cnt << MAC_CFG_DESC_TX_2_NUM_OF_DESCRIPTORS_POS);
+}
+
+
+static int wil_tx_vring_tso(struct wil6210_priv *wil, struct vring *vring,
+		struct sk_buff *skb)
+{
+	struct device *dev = wil_to_dev(wil);
+	struct vring_tx_desc *d;
+	struct vring_tx_desc *hdrdesc, *firstdata = NULL;
+	struct wil_skb_cb *skbcb = (struct wil_skb_cb *)skb->cb;
+	u32 swhead = vring->swhead;
+	u32 swtail = vring->swtail;
+	int used = (vring->size + swhead - swtail) % vring->size;
+	int avail = vring->size - used - 1;
+	int nr_frags = skb_shinfo(skb)->nr_frags;
+	int min_desc_required = (nr_frags*3)+1;	/* Min required descriptors */
+	int mss = skb_shinfo(skb)->gso_size;	/* payload size w/o headers */
+	int f, len, hdrlen;
+	int vring_index = vring - wil->vring_tx;
+	int i = swhead;
+	int descs_used = 1;	/* Tx descs used. At least 1 with the header */
+	dma_addr_t pa;
+	const struct skb_frag_struct *frag;
+	int tcp_ver = 0;
+	struct vring_tx_desc *sg_desc = NULL;
+	int sg_desc_cnt = 0;
+	int rem_data = 0;
+	int lenmss;
+	int compensate_hdr_desc = 1;
+
+	if (avail < min_desc_required) {
+		/*
+		 A typical page 4K is 3-4 payloads, we assume each fragment
+		 is a full payload, that's how min_desc_required has been
+		 calculated. In real we might need more or less descriptors,
+		 this is the initial check only.
+		*/
+		wil_err(wil, "Tx ring full. Need %d descriptors\n",
+			min_desc_required);
+		netif_tx_stop_all_queues(wil_to_ndev(wil));
+		return -ENOMEM;
+	}
+
+	tcp_ver = wil_tx_desc_offload_setup(NULL, skb, 0);
+	if (tcp_ver == 0) {
+		wil_err(wil, "TSO requires TCP protocol\n");
+		return -EINVAL;
+	}
+	hdrlen = 0x0e +	/* MAC header len */
+		(int)skb_network_header_len(skb) +	/* IP header len */
+		tcp_hdrlen(skb);		/* TCP header len */
+
+	if (tcp_ver == 1) {
+		/* TCP v4, zero out the IP length and IPv4 checksum fields
+		as required by the offloading doc
+		*/
+		ip_hdr(skb)->tot_len = 0;
+		ip_hdr(skb)->check = 0;
+	} else {
+		/* TCP v6, zero out the payload length */
+		ipv6_hdr(skb)->payload_len = 0;
+	}
+
+	/* FIXME FW can accept only unicast frames for the peer */
+	memcpy(skb->data, wil->dst_addr[vring_index], ETH_ALEN);
+
+	d = (struct vring_tx_desc *)&(vring->va[i].tx);
+	pa = dma_map_single(dev, skb->data, hdrlen, DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(dev, pa))) {
+		wil_err(wil, "DMA map error\n");
+		goto err_exit;
+	}
+	wil_tx_desc_map((struct vring_tx_desc *)d, pa, hdrlen);
+	hdrdesc = d;
+	wil_tx_desc_offload_setup(d, skb, 0);
+	wil_tx_last_desc(d, vring_index);
+
+	vring->ctx[i] = skb_get(skb);
+	skbcb->sngl_mapped = i;
+	skbcb->nodma_desc = i;	/* TSO header desc makes no DMA complete */
+
+
+	len = skb_headlen(skb) - hdrlen;
+	rem_data = mss;
+	if (len > 0) {
+		/* There is some data besides the headers, use a different
+		descriptor
+		*/
+		i = (swhead + 1) % vring->size;
+		d = (struct vring_tx_desc *)&(vring->va[i].tx);
+		pa = dma_map_single(dev, skb->data+hdrlen, len,
+				DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(dev, pa)))
+				goto dma_error;
+		wil_tx_desc_map((struct vring_tx_desc *)d, pa, len);
+		firstdata = d;	/* 1st data descriptor */
+		wil_tx_desc_offload_setup(d, skb, 1);
+		skbcb->sngl_mapped = i;
+		vring->ctx[i] = skb_get(skb);
+		descs_used++;
+		sg_desc = d;
+		sg_desc_cnt = 1;
+		rem_data = mss - len;
+
+	}
+	/* Data segments. split each fragment to chunks with mss size */
+	for (f = 0; f < nr_frags; f++)  {
+		frag = &skb_shinfo(skb)->frags[f];
+		len = frag->size;
+		while (len > 0)  {
+			if (rem_data == 0) {
+				/* got full mss descs chain. Complete the
+				previous descriptor
+				*/
+				wil_tx_last_desc(d, vring_index);
+				if (sg_desc)
+					wil_set_tx_desc_count(sg_desc,
+							sg_desc_cnt +
+							compensate_hdr_desc);
+				sg_desc = NULL;
+				sg_desc_cnt = 0;
+				rem_data = mss;
+				compensate_hdr_desc = 0;
+			} else {
+				if (descs_used == avail)  {
+					wil_err(wil,
+					"Tx: ring overflow TSO\n");
+					netif_tx_stop_all_queues(
+							wil_to_ndev(wil));
+					goto dma_error;
+				}
+				lenmss = len > rem_data ? rem_data : len;
+				i = (swhead + descs_used) % vring->size;
+				pa = skb_frag_dma_map(dev, frag,
+						(frag->size - len),
+						lenmss, DMA_TO_DEVICE);
+				if (unlikely(dma_mapping_error(dev, pa)))
+					goto dma_error;
+				d = (struct vring_tx_desc *)&(vring->va[i].tx);
+				wil_tx_desc_map((struct vring_tx_desc *)d,
+						pa, lenmss);
+				if (sg_desc == NULL)
+					sg_desc = d;
+
+				if (firstdata)  {
+					/* middle desc */
+					wil_tx_desc_offload_setup(d, skb, 2);
+				} else {
+					/* 1st data desc */
+					wil_tx_desc_offload_setup(d, skb, 1);
+					firstdata = d;
+				}
+				vring->ctx[i] = skb_get(skb);
+				descs_used++;
+				sg_desc_cnt++;
+				len -= lenmss;
+				rem_data -= lenmss;
+			}
+		}
+	}
+	wil_tx_last_desc(d, vring_index);
+	if (sg_desc)
+		wil_set_tx_desc_count(sg_desc, sg_desc_cnt +
+					compensate_hdr_desc);
+
+	/* Last data descriptor */
+	d->dma.d0 |= (3 << DMA_CFG_DESC_TX_0_SEGMENT_BUF_DETAILS_POS);
+	/* Fill the number of descriptors */
+	wil_set_tx_desc_count(hdrdesc, descs_used);
+
+	/* advance swhead */
+	wil_vring_advance_head(vring, descs_used);
+	iowrite32(vring->swhead, wil->csr + HOSTADDR(vring->hwtail));
+	return 0;
+
+ dma_error:
+	wil_err(wil, "DMA map page error\n");
+	while (descs_used > 0) {
+		i = (swhead + descs_used) % vring->size;
+		d = (struct vring_tx_desc *)&(vring->va[i].tx);
+		d->dma.status = TX_DMA_STATUS_DU;
+		pa = d->dma.addr_low | ((u64)d->dma.addr_high << 32);
+		if (i > skbcb->sngl_mapped)
+			dma_unmap_page(dev, pa, d->dma.length, DMA_TO_DEVICE);
+		else
+			dma_unmap_single(dev, pa, d->dma.length,
+					DMA_TO_DEVICE);
+		descs_used--;
+		dev_kfree_skb_any(skb);	/* Decrease skb reference count */
+	}
+err_exit:
+	return -EINVAL;
 }
 
 static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
@@ -753,7 +981,7 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	 */
 	if ((skb->ip_summed == CHECKSUM_PARTIAL) &&
 		(ndev->features & NETIF_F_HW_CSUM))
-		wil_tx_desc_offload_setup((struct vring_tx_desc *)d, skb);
+		wil_tx_desc_offload_setup((struct vring_tx_desc *)d, skb, -1);
 
 
 
@@ -776,15 +1004,12 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 		if ((skb->ip_summed == CHECKSUM_PARTIAL) &&
 			(ndev->features & NETIF_F_HW_CSUM))
 			wil_tx_desc_offload_setup((struct vring_tx_desc *)d,
-						skb);
+						skb, -1);
 		/* Keep reference to skb till all the fragments are done */
 		vring->ctx[i] = skb_get(skb);
 	}
 	/* for the last seg only */
-	d->dma.d0 |= BIT(DMA_CFG_DESC_TX_0_CMD_EOP_POS);
-	d->dma.d0 |= BIT(9); /* BUG: undocumented bit */
-	d->dma.d0 |= BIT(DMA_CFG_DESC_TX_0_CMD_DMA_IT_POS);
-	d->dma.d0 |= (vring_index << DMA_CFG_DESC_TX_0_QID_POS);
+	wil_tx_last_desc((struct vring_tx_desc *)d, vring_index);
 
 	wil_hex_dump_txrx("Tx ", DUMP_PREFIX_NONE, 32, 4,
 			  (const void *)d, sizeof(*d), false);
@@ -843,7 +1068,10 @@ netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 			goto drop;
 		}
 		/* set up vring entry */
-		rc = wil_tx_vring(wil, vring, skb);
+		if (skb_is_gso(skb))
+			rc = wil_tx_vring_tso(wil, vring, skb);
+		else
+			rc = wil_tx_vring(wil, vring, skb);
 	}
 	switch (rc) {
 	case 0:
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 8f76ecd..6884c45 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -35,7 +35,7 @@ static inline u32 WIL_GET_BITS(u32 x, int b0, int b1)
 #define WIL6210_MEM_SIZE (2*1024*1024UL)
 
 #define WIL6210_RX_RING_SIZE (128)
-#define WIL6210_TX_RING_SIZE (128)
+#define WIL6210_TX_RING_SIZE (512)
 #define WIL6210_MAX_TX_RINGS (24)
 
 /* Hardware definitions begin */
-- 
1.7.11.7

