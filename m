Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:54366 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab3EHJe5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 May 2013 05:34:57 -0400
Received: by mail-ea0-f178.google.com with SMTP id m14so818351eaj.23
        for <linux-wireless@vger.kernel.org>; Wed, 08 May 2013 02:34:55 -0700 (PDT)
From: wilocity.git@gmail.com
To: qca_vkondrat@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Wilocity Git <wilocity.git@gmail.com>
Subject: [PATCH 2/3] wil6210: Add scatter gather support
Date: Wed,  8 May 2013 11:34:11 +0300
Message-Id: <1368002051-11587-1-git-send-email-wilocity.git@gmail.com> (sfid-20130508_113500_928904_028FA3F1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Erez Kirshenbaum <erezk@wilocitycom>

Add scatter gather support in TX flow, each SKB may provide multiple fragments to be handled
by more then one DMA descriptor. tx_complete is able to release multiple descriptors by
checking the DU bit of the sent descriptors till the last descriptor "done" (with DU bit set).

Signed-off-by: Erez Kirshenbaum <erezk@wilocitycom>
Signed-off-by: Wilocity Git <wilocity.git@gmail.com>
---
 drivers/net/wireless/ath/wil6210/netdev.c |   4 +-
 drivers/net/wireless/ath/wil6210/txrx.c   | 206 ++++++++++++++++++------------
 2 files changed, 129 insertions(+), 81 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index 4f2a61f..b294729 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -100,8 +100,8 @@ void *wil_if_alloc(struct device *dev, void __iomem *csr)
 
 	ndev->netdev_ops = &wil_netdev_ops;
 	ndev->ieee80211_ptr = wdev;
-	ndev->hw_features = NETIF_F_HW_CSUM | NETIF_F_RXCSUM;
-	ndev->features |= NETIF_F_HW_CSUM | NETIF_F_RXCSUM;
+	ndev->hw_features = NETIF_F_HW_CSUM | NETIF_F_RXCSUM | NETIF_F_SG;
+	ndev->features |= NETIF_F_HW_CSUM | NETIF_F_RXCSUM | NETIF_F_SG;
 	SET_NETDEV_DEV(ndev, wiphy_dev(wdev->wiphy));
 	wdev->netdev = ndev;
 
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 3f44a6c..5076abd 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -26,6 +26,14 @@
 #include "wmi.h"
 #include "txrx.h"
 
+struct  wil_skb_cb {
+	int sngl_mapped;	/* Last desc. index, single_mapped skb data */
+	int nodma_desc;		/* Header desc. index with no DMA completion
+				happens in some modes, e.g. in TSO
+				*/
+};
+
+
 static bool rtap_include_phy_info;
 module_param(rtap_include_phy_info, bool, S_IRUGO);
 MODULE_PARM_DESC(rtap_include_phy_info,
@@ -107,6 +115,7 @@ static void wil_vring_free(struct wil6210_priv *wil, struct vring *vring,
 {
 	struct device *dev = wil_to_dev(wil);
 	size_t sz = vring->size * sizeof(vring->va[0]);
+	struct wil_skb_cb *skbcb;
 
 	while (!wil_vring_is_empty(vring)) {
 		if (tx) {
@@ -116,13 +125,15 @@ static void wil_vring_free(struct wil6210_priv *wil, struct vring *vring,
 					((u64)d->dma.addr_high << 32);
 			struct sk_buff *skb = vring->ctx[vring->swtail];
 			if (skb) {
-				dma_unmap_single(dev, pa, d->dma.length,
-						 DMA_TO_DEVICE);
+				skbcb = (struct wil_skb_cb *)skb->cb;
+				if (vring->swtail <= skbcb->sngl_mapped)
+					dma_unmap_single(dev, pa,
+						d->dma.length, DMA_TO_DEVICE);
+				else
+					dma_unmap_page(dev, pa,
+						d->dma.length, DMA_TO_DEVICE);
 				dev_kfree_skb_any(skb);
 				vring->ctx[vring->swtail] = NULL;
-			} else {
-				dma_unmap_page(dev, pa, d->dma.length,
-					       DMA_TO_DEVICE);
 			}
 			vring->swtail = wil_vring_next_tail(vring);
 		} else { /* rx */
@@ -636,12 +647,69 @@ static int wil_tx_desc_map(volatile struct vring_tx_desc *d,
 	return 0;
 }
 
+static void wil_tx_desc_offload_setup(struct vring_tx_desc *d,
+				struct sk_buff *skb)
+{
+	int is_ip4 = 0, is_ip6 = 0, is_tcp = 0, is_udp = 0;
+
+
+	if (skb->protocol == htons(ETH_P_IP)) {
+		is_ip4 = 1;
+	if (ip_hdr(skb)->protocol == IPPROTO_TCP)
+		is_tcp = 1;
+	else if (ip_hdr(skb)->protocol == IPPROTO_UDP)
+		is_udp = 1;
+	} else if (skb->protocol == htons(ETH_P_IPV6)) {
+		unsigned int offset = 0;
+		int ipv6hdr =  ipv6_find_hdr(skb,
+					&offset, -1, NULL, NULL);
+		is_ip6 = 1;
+		if (ipv6hdr == NEXTHDR_TCP)
+			is_tcp = 1;
+		else if (ipv6hdr == NEXTHDR_UDP)
+			is_udp = 1;
+	}
+
+	if (is_ip4 || is_ip6) {
+		if (is_ip4)
+			d->dma.offload_cfg |=
+				BIT(DMA_CFG_DESC_TX_OFFLOAD_CFG_L3T_IPV4_POS);
+		d->dma.offload_cfg |=
+			(skb_network_header_len(skb) &
+			DMA_CFG_DESC_TX_OFFLOAD_CFG_IP_LEN_MSK);
+		d->dma.offload_cfg |=
+			(0x0e << DMA_CFG_DESC_TX_OFFLOAD_CFG_MAC_LEN_POS);
+		if (is_tcp || is_udp) {
+			/* Enable TCP/UDP checksum */
+			d->dma.d0 |=
+				BIT(DMA_CFG_DESC_TX_0_TCP_UDP_CHECKSUM_EN_POS);
+			/* Calculate pseudo-header */
+			d->dma.d0 |=
+			   BIT(DMA_CFG_DESC_TX_0_PSEUDO_HEADER_CALC_EN_POS);
+			if (is_tcp)  {
+				d->dma.d0 |=
+					(2 << DMA_CFG_DESC_TX_0_L4_TYPE_POS);
+			/* L4 header len: TCP header length */
+				d->dma.d0 |=
+					(tcp_hdrlen(skb) &
+					DMA_CFG_DESC_TX_0_L4_LENGTH_MSK);
+			} else  {
+				/* L4 header len: UDP header length */
+				d->dma.d0 |=
+					(sizeof(struct udphdr) &
+					DMA_CFG_DESC_TX_0_L4_LENGTH_MSK);
+			}
+		}
+	}
+}
+
 static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 			struct sk_buff *skb)
 {
 	struct device *dev = wil_to_dev(wil);
 	struct net_device *ndev = wil_to_ndev(wil);
 	volatile struct vring_tx_desc *d;
+	struct wil_skb_cb *skbcb = (struct wil_skb_cb *)skb->cb;
 	u32 swhead = vring->swhead;
 	int avail = wil_vring_avail_tx(vring);
 	int nr_frags = skb_shinfo(skb)->nr_frags;
@@ -649,7 +717,7 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	int vring_index = vring - wil->vring_tx;
 	uint i = swhead;
 	dma_addr_t pa;
-	int is_ip4 = 0, is_ip6 = 0, is_tcp = 0, is_udp = 0;
+
 
 
 	wil_dbg_txrx(wil, "%s()\n", __func__);
@@ -662,6 +730,8 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 		return -ENOMEM;
 	}
 	d = &(vring->va[i].tx);
+	skbcb->sngl_mapped = i;
+	skbcb->nodma_desc = -1;
 
 	/* FIXME FW can accept only unicast frames for the peer */
 	memcpy(skb->data, wil->dst_addr[vring_index], ETH_ALEN);
@@ -682,60 +752,15 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	 * Process offloading
 	 */
 	if ((skb->ip_summed == CHECKSUM_PARTIAL) &&
-		(ndev->features & NETIF_F_HW_CSUM))  {
-		if (skb->protocol == htons(ETH_P_IP)) {
-			is_ip4 = 1;
-		if (ip_hdr(skb)->protocol == IPPROTO_TCP)
-			is_tcp = 1;
-		else if (ip_hdr(skb)->protocol == IPPROTO_UDP)
-			is_udp = 1;
-		} else if (skb->protocol == htons(ETH_P_IPV6)) {
-			unsigned int offset = 0;
-			int ipv6hdr =  ipv6_find_hdr(skb,
-						&offset, -1, NULL, NULL);
-			is_ip6 = 1;
-			if (ipv6hdr == NEXTHDR_TCP)
-				is_tcp = 1;
-			else if (ipv6hdr == NEXTHDR_UDP)
-				is_udp = 1;
-		}
-	}
+		(ndev->features & NETIF_F_HW_CSUM))
+		wil_tx_desc_offload_setup((struct vring_tx_desc *)d, skb);
 
 
-	if (is_ip4 || is_ip6) {
-		if (is_ip4)
-			d->dma.offload_cfg |=
-				BIT(DMA_CFG_DESC_TX_OFFLOAD_CFG_L3T_IPV4_POS);
-		d->dma.offload_cfg |=
-			(skb_network_header_len(skb) &
-			DMA_CFG_DESC_TX_OFFLOAD_CFG_IP_LEN_MSK);
-		d->dma.offload_cfg |=
-			(0x0e << DMA_CFG_DESC_TX_OFFLOAD_CFG_MAC_LEN_POS);
-		if (is_tcp || is_udp) {
-			/* Enable TCP/UDP checksum */
-			d->dma.d0 |=
-				BIT(DMA_CFG_DESC_TX_0_TCP_UDP_CHECKSUM_EN_POS);
-			/* Calculate pseudo-header */
-			d->dma.d0 |=
-			   BIT(DMA_CFG_DESC_TX_0_PSEUDO_HEADER_CALC_EN_POS);
-			if (is_tcp)  {
-				d->dma.d0 |=
-					(2 << DMA_CFG_DESC_TX_0_L4_TYPE_POS);
-			/* L4 header len: TCP header length */
-				d->dma.d0 |=
-					(tcp_hdrlen(skb) &
-					DMA_CFG_DESC_TX_0_L4_LENGTH_MSK);
-			} else  {
-				/* L4 header len: UDP header length */
-				d->dma.d0 |=
-					(sizeof(struct udphdr) &
-					DMA_CFG_DESC_TX_0_L4_LENGTH_MSK);
-			}
-		}
-	}
 
 	d->mac.d[2] |= ((nr_frags + 1) <<
 		       MAC_CFG_DESC_TX_2_NUM_OF_DESCRIPTORS_POS);
+	/* Keep reference to skb till the fragments and skb_data are done */
+	vring->ctx[i] = skb_get(skb);
 	/* middle segments */
 	for (f = 0; f < nr_frags; f++) {
 		const struct skb_frag_struct *frag =
@@ -748,7 +773,12 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 		if (unlikely(dma_mapping_error(dev, pa)))
 			goto dma_error;
 		wil_tx_desc_map(d, pa, len);
-		vring->ctx[i] = NULL;
+		if ((skb->ip_summed == CHECKSUM_PARTIAL) &&
+			(ndev->features & NETIF_F_HW_CSUM))
+			wil_tx_desc_offload_setup((struct vring_tx_desc *)d,
+						skb);
+		/* Keep reference to skb till all the fragments are done */
+		vring->ctx[i] = skb_get(skb);
 	}
 	/* for the last seg only */
 	d->dma.d0 |= BIT(DMA_CFG_DESC_TX_0_CMD_EOP_POS);
@@ -763,25 +793,21 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	wil_vring_advance_head(vring, nr_frags + 1);
 	wil_dbg_txrx(wil, "Tx swhead %d -> %d\n", swhead, vring->swhead);
 	iowrite32(vring->swhead, wil->csr + HOSTADDR(vring->hwtail));
-	/* hold reference to skb
-	 * to prevent skb release before accounting
-	 * in case of immediate "tx done"
-	 */
-	vring->ctx[i] = skb_get(skb);
 
 	return 0;
  dma_error:
 	/* unmap what we have mapped */
 	/* Note: increment @f to operate with positive index */
 	for (f++; f > 0; f--) {
-		i = (swhead + f) % vring->size;
+		i = (swhead + f - 1) % vring->size;
 		d = &(vring->va[i].tx);
 		d->dma.status = TX_DMA_STATUS_DU;
 		pa = d->dma.addr_low | ((u64)d->dma.addr_high << 32);
-		if (vring->ctx[i])
+		if (i <= skbcb->sngl_mapped)
 			dma_unmap_single(dev, pa, d->dma.length, DMA_TO_DEVICE);
 		else
 			dma_unmap_page(dev, pa, d->dma.length, DMA_TO_DEVICE);
+		dev_kfree_skb_any(skb);	/* Decrease skb reference count */
 	}
 
 	return -EINVAL;
@@ -847,7 +873,9 @@ void wil_tx_complete(struct wil6210_priv *wil, int ringid)
 	struct net_device *ndev = wil_to_ndev(wil);
 	struct device *dev = wil_to_dev(wil);
 	struct vring *vring = &wil->vring_tx[ringid];
-
+	struct wil_skb_cb *skbcb;
+	int swtail, swtail_to_rel;
+	int nodma_comp;
 	if (!vring->va) {
 		wil_err(wil, "Tx irq[%d]: vring not initialized\n", ringid);
 		return;
@@ -855,17 +883,22 @@ void wil_tx_complete(struct wil6210_priv *wil, int ringid)
 
 	wil_dbg_txrx(wil, "%s(%d)\n", __func__, ringid);
 
-	while (!wil_vring_is_empty(vring)) {
-		volatile struct vring_tx_desc *d1 =
-					      &vring->va[vring->swtail].tx;
-		struct vring_tx_desc dd, *d = &dd;
-		dma_addr_t pa;
-		struct sk_buff *skb;
+	swtail_to_rel = vring->swtail;
 
-		dd = *d1;
+	for (swtail = vring->swtail; swtail != vring->swhead;
+		swtail = (swtail + 1) % vring->size) {
+		struct vring_tx_desc *d = (struct vring_tx_desc *)
+			&vring->va[swtail].tx;
+		if (d->dma.status & TX_DMA_STATUS_DU)
+			swtail_to_rel = swtail;
+	}
 
-		if (!(d->dma.status & TX_DMA_STATUS_DU))
-			break;
+	for (swtail = vring->swtail; swtail != swtail_to_rel;
+		swtail = (swtail + 1) % vring->size) {
+		struct vring_tx_desc *d = (struct vring_tx_desc *)
+			&vring->va[swtail].tx;
+		dma_addr_t pa;
+		struct sk_buff *skb;
 
 		wil_dbg_txrx(wil,
 			     "Tx[%3d] : %d bytes, status 0x%02x err 0x%02x\n",
@@ -875,7 +908,9 @@ void wil_tx_complete(struct wil6210_priv *wil, int ringid)
 				  (const void *)d, sizeof(*d), false);
 
 		pa = d->dma.addr_low | ((u64)d->dma.addr_high << 32);
-		skb = vring->ctx[vring->swtail];
+		nodma_comp = false;
+		skbcb = NULL;
+		skb = vring->ctx[swtail];
 		if (skb) {
 			if (d->dma.error == 0) {
 				ndev->stats.tx_packets++;
@@ -884,18 +919,31 @@ void wil_tx_complete(struct wil6210_priv *wil, int ringid)
 				ndev->stats.tx_errors++;
 			}
 
-			dma_unmap_single(dev, pa, d->dma.length, DMA_TO_DEVICE);
+			skbcb = (struct wil_skb_cb *)skb->cb;
+			if (swtail == skbcb->nodma_desc)
+				nodma_comp = true;
+		}
+		if ((!nodma_comp) && (d->dma.d0 &
+			BIT(DMA_CFG_DESC_TX_0_CMD_EOP_POS)))
+			if ((!(d->dma.status & TX_DMA_STATUS_DU)))
+				break;
+
+		if (skbcb) {
+			if (swtail <= skbcb->sngl_mapped)
+				dma_unmap_single(dev, pa, d->dma.length,
+						DMA_TO_DEVICE);
+			else
+				dma_unmap_page(dev, pa, d->dma.length,
+						DMA_TO_DEVICE);
 			dev_kfree_skb_any(skb);
-			vring->ctx[vring->swtail] = NULL;
-		} else {
-			dma_unmap_page(dev, pa, d->dma.length, DMA_TO_DEVICE);
 		}
+		vring->ctx[swtail] = NULL;
 		d->dma.addr_low = 0;
 		d->dma.addr_high = 0;
 		d->dma.length = 0;
 		d->dma.status = TX_DMA_STATUS_DU;
-		vring->swtail = wil_vring_next_tail(vring);
 	}
+	vring->swtail = swtail;
 	if (wil_vring_avail_tx(vring) > vring->size/4)
 		netif_tx_wake_all_queues(wil_to_ndev(wil));
 }
-- 
1.7.11.7

