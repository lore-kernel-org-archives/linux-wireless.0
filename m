Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:21904 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668Ab3ELLoQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 May 2013 07:44:16 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 6/7] wil6210: fix remaining use of non-cached copy of tx/rx descriptors
Date: Sun, 12 May 2013 14:43:37 +0300
Message-ID: <1368359018-20870-7-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130512_134426_817350_DC553547)
In-Reply-To: <1368359018-20870-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1368359018-20870-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

- Introduce common code for Tx/Rx descriptor physical address set/parse
- Fix endianness for address fields
- consistent descriptor naming: '_d' for non-cached memory, 'd' for cached copy
- wil_tx_desc_map now modify cached copy, no need for 'volatile'

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 106 ++++++++++++++++++--------------
 drivers/net/wireless/ath/wil6210/txrx.h |  28 +++++++--
 2 files changed, 84 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 109f9bd..5a0657c 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -92,8 +92,8 @@ static int wil_vring_alloc(struct wil6210_priv *wil, struct vring *vring)
 	 * we can use any
 	 */
 	for (i = 0; i < vring->size; i++) {
-		volatile struct vring_tx_desc *d = &(vring->va[i].tx);
-		d->dma.status = TX_DMA_STATUS_DU;
+		volatile struct vring_tx_desc *_d = &(vring->va[i].tx);
+		_d->dma.status = TX_DMA_STATUS_DU;
 	}
 
 	wil_dbg_misc(wil, "vring[%d] 0x%p:0x%016llx 0x%p\n", vring->size,
@@ -109,14 +109,19 @@ static void wil_vring_free(struct wil6210_priv *wil, struct vring *vring,
 	size_t sz = vring->size * sizeof(vring->va[0]);
 
 	while (!wil_vring_is_empty(vring)) {
+		dma_addr_t pa;
+		struct sk_buff *skb;
 		u16 dmalen;
+
 		if (tx) {
-			volatile struct vring_tx_desc *d =
+			struct vring_tx_desc dd, *d = &dd;
+			volatile struct vring_tx_desc *_d =
 					&vring->va[vring->swtail].tx;
-			dma_addr_t pa = d->dma.addr_low |
-					((u64)d->dma.addr_high << 32);
-			struct sk_buff *skb = vring->ctx[vring->swtail];
+
+			*d = *_d;
+			pa = wil_desc_addr(&d->dma.addr);
 			dmalen = le16_to_cpu(d->dma.length);
+			skb = vring->ctx[vring->swtail];
 			if (skb) {
 				dma_unmap_single(dev, pa, dmalen,
 						 DMA_TO_DEVICE);
@@ -128,12 +133,14 @@ static void wil_vring_free(struct wil6210_priv *wil, struct vring *vring,
 			}
 			vring->swtail = wil_vring_next_tail(vring);
 		} else { /* rx */
-			volatile struct vring_rx_desc *d =
+			struct vring_rx_desc dd, *d = &dd;
+			volatile struct vring_rx_desc *_d =
 					&vring->va[vring->swtail].rx;
-			dma_addr_t pa = d->dma.addr_low |
-					((u64)d->dma.addr_high << 32);
-			struct sk_buff *skb = vring->ctx[vring->swhead];
+
+			*d = *_d;
+			pa = wil_desc_addr(&d->dma.addr);
 			dmalen = le16_to_cpu(d->dma.length);
+			skb = vring->ctx[vring->swhead];
 			dma_unmap_single(dev, pa, dmalen, DMA_FROM_DEVICE);
 			kfree_skb(skb);
 			wil_vring_advance_head(vring, 1);
@@ -156,7 +163,8 @@ static int wil_vring_alloc_skb(struct wil6210_priv *wil, struct vring *vring,
 {
 	struct device *dev = wil_to_dev(wil);
 	unsigned int sz = RX_BUF_LEN;
-	volatile struct vring_rx_desc *d = &(vring->va[i].rx);
+	struct vring_rx_desc dd, *d = &dd;
+	volatile struct vring_rx_desc *_d = &(vring->va[i].rx);
 	dma_addr_t pa;
 
 	/* TODO align */
@@ -174,13 +182,13 @@ static int wil_vring_alloc_skb(struct wil6210_priv *wil, struct vring *vring,
 	}
 
 	d->dma.d0 = BIT(9) | RX_DMA_D0_CMD_DMA_IT;
-	d->dma.addr_low = lower_32_bits(pa);
-	d->dma.addr_high = (u16)upper_32_bits(pa);
+	wil_desc_addr_set(&d->dma.addr, pa);
 	/* ip_length don't care */
 	/* b11 don't care */
 	/* error don't care */
 	d->dma.status = 0; /* BIT(0) should be 0 for HW_OWNED */
 	d->dma.length = cpu_to_le16(sz);
+	*_d = *d;
 	vring->ctx[i] = skb;
 
 	return 0;
@@ -326,8 +334,8 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 {
 	struct device *dev = wil_to_dev(wil);
 	struct net_device *ndev = wil_to_ndev(wil);
-	volatile struct vring_rx_desc *d;
-	struct vring_rx_desc *d1;
+	volatile struct vring_rx_desc *_d;
+	struct vring_rx_desc *d;
 	struct sk_buff *skb;
 	dma_addr_t pa;
 	unsigned int sz = RX_BUF_LEN;
@@ -340,20 +348,27 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	if (wil_vring_is_empty(vring))
 		return NULL;
 
-	d = &(vring->va[vring->swhead].rx);
-	if (!(d->dma.status & RX_DMA_STATUS_DU)) {
+	_d = &(vring->va[vring->swhead].rx);
+	if (!(_d->dma.status & RX_DMA_STATUS_DU)) {
 		/* it is not error, we just reached end of Rx done area */
 		return NULL;
 	}
 
-	pa = d->dma.addr_low | ((u64)d->dma.addr_high << 32);
 	skb = vring->ctx[vring->swhead];
+	d = wil_skb_rxdesc(skb);
+	*d = *_d;
+	pa = wil_desc_addr(&d->dma.addr);
+	vring->ctx[vring->swhead] = NULL;
+	wil_vring_advance_head(vring, 1);
+
 	dma_unmap_single(dev, pa, sz, DMA_FROM_DEVICE);
+	dmalen = le16_to_cpu(d->dma.length);
+
+	trace_wil6210_rx(vring->swhead, d);
+	wil_dbg_txrx(wil, "Rx[%3d] : %d bytes\n", vring->swhead, dmalen);
+	wil_hex_dump_txrx("Rx ", DUMP_PREFIX_NONE, 32, 4,
+			  (const void *)d, sizeof(*d), false);
 
-	d1 = wil_skb_rxdesc(skb);
-	*d1 = *d;
-	wil_vring_advance_head(vring, 1);
-	dmalen = le16_to_cpu(d1->dma.length);
 	if (dmalen > sz) {
 		wil_err(wil, "Rx size too large: %d bytes!\n", dmalen);
 		kfree(skb);
@@ -365,18 +380,12 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 			  skb->data, skb_headlen(skb), false);
 
 
-	wil->stats.last_mcs_rx = wil_rxdesc_mcs(d1);
+	wil->stats.last_mcs_rx = wil_rxdesc_mcs(d);
 
 	/* use radiotap header only if required */
 	if (ndev->type == ARPHRD_IEEE80211_RADIOTAP)
 		wil_rx_add_radiotap_header(wil, skb);
 
-	trace_wil6210_rx(vring->swhead, d1);
-	wil_dbg_txrx(wil, "Rx[%3d] : %d bytes\n", vring->swhead,
-		     d1->dma.length);
-	wil_hex_dump_txrx("Rx ", DUMP_PREFIX_NONE, 32, 4,
-			  (const void *)d1, sizeof(*d1), false);
-
 	/* no extra checks if in sniffer mode */
 	if (ndev->type != ARPHRD_ETHER)
 		return skb;
@@ -385,7 +394,7 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	 * Driver should recognize it by frame type, that is found
 	 * in Rx descriptor. If type is not data, it is 802.11 frame as is
 	 */
-	ftype = wil_rxdesc_ftype(d1) << 2;
+	ftype = wil_rxdesc_ftype(d) << 2;
 	if (ftype != IEEE80211_FTYPE_DATA) {
 		wil_dbg_txrx(wil, "Non-data frame ftype 0x%08x\n", ftype);
 		/* TODO: process it */
@@ -400,7 +409,7 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 		return NULL;
 	}
 
-	ds_bits = wil_rxdesc_ds_bits(d1);
+	ds_bits = wil_rxdesc_ds_bits(d);
 	if (ds_bits == 1) {
 		/*
 		 * HW bug - in ToDS mode, i.e. Rx on AP side,
@@ -614,11 +623,9 @@ static struct vring *wil_find_tx_vring(struct wil6210_priv *wil,
 	return NULL;
 }
 
-static int wil_tx_desc_map(volatile struct vring_tx_desc *d,
-			   dma_addr_t pa, u32 len)
+static int wil_tx_desc_map(struct vring_tx_desc *d, dma_addr_t pa, u32 len)
 {
-	d->dma.addr_low = lower_32_bits(pa);
-	d->dma.addr_high = (u16)upper_32_bits(pa);
+	wil_desc_addr_set(&d->dma.addr, pa);
 	d->dma.ip_length = 0;
 	/* 0..6: mac_length; 7:ip_version 0-IP6 1-IP4*/
 	d->dma.b11 = 0/*14 | BIT(7)*/;
@@ -644,7 +651,8 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 			struct sk_buff *skb)
 {
 	struct device *dev = wil_to_dev(wil);
-	volatile struct vring_tx_desc *d;
+	struct vring_tx_desc dd, *d = &dd;
+	volatile struct vring_tx_desc *_d;
 	u32 swhead = vring->swhead;
 	int avail = wil_vring_avail_tx(vring);
 	int nr_frags = skb_shinfo(skb)->nr_frags;
@@ -662,7 +670,7 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 			1 + nr_frags);
 		return -ENOMEM;
 	}
-	d = &(vring->va[i].tx);
+	_d = &(vring->va[i].tx);
 
 	/* FIXME FW can accept only unicast frames for the peer */
 	memcpy(skb->data, wil->dst_addr[vring_index], ETH_ALEN);
@@ -681,25 +689,30 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	wil_tx_desc_map(d, pa, skb_headlen(skb));
 	d->mac.d[2] |= ((nr_frags + 1) <<
 		       MAC_CFG_DESC_TX_2_NUM_OF_DESCRIPTORS_POS);
+	if (nr_frags)
+		*_d = *d;
+
 	/* middle segments */
 	for (f = 0; f < nr_frags; f++) {
 		const struct skb_frag_struct *frag =
 				&skb_shinfo(skb)->frags[f];
 		int len = skb_frag_size(frag);
 		i = (swhead + f + 1) % vring->size;
-		d = &(vring->va[i].tx);
+		_d = &(vring->va[i].tx);
 		pa = skb_frag_dma_map(dev, frag, 0, skb_frag_size(frag),
 				DMA_TO_DEVICE);
 		if (unlikely(dma_mapping_error(dev, pa)))
 			goto dma_error;
 		wil_tx_desc_map(d, pa, len);
 		vring->ctx[i] = NULL;
+		*_d = *d;
 	}
 	/* for the last seg only */
 	d->dma.d0 |= BIT(DMA_CFG_DESC_TX_0_CMD_EOP_POS);
 	d->dma.d0 |= BIT(9); /* BUG: undocumented bit */
 	d->dma.d0 |= BIT(DMA_CFG_DESC_TX_0_CMD_DMA_IT_POS);
 	d->dma.d0 |= (vring_index << DMA_CFG_DESC_TX_0_QID_POS);
+	*_d = *d;
 
 	wil_hex_dump_txrx("Tx ", DUMP_PREFIX_NONE, 32, 4,
 			  (const void *)d, sizeof(*d), false);
@@ -723,9 +736,10 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 		u16 dmalen;
 
 		i = (swhead + f) % vring->size;
-		d = &(vring->va[i].tx);
-		d->dma.status = TX_DMA_STATUS_DU;
-		pa = d->dma.addr_low | ((u64)d->dma.addr_high << 32);
+		_d = &(vring->va[i].tx);
+		*d = *_d;
+		_d->dma.status = TX_DMA_STATUS_DU;
+		pa = wil_desc_addr(&d->dma.addr);
 		dmalen = le16_to_cpu(d->dma.length);
 		if (vring->ctx[i])
 			dma_unmap_single(dev, pa, dmalen, DMA_TO_DEVICE);
@@ -808,14 +822,14 @@ int wil_tx_complete(struct wil6210_priv *wil, int ringid)
 	wil_dbg_txrx(wil, "%s(%d)\n", __func__, ringid);
 
 	while (!wil_vring_is_empty(vring)) {
-		volatile struct vring_tx_desc *d1 =
+		volatile struct vring_tx_desc *_d =
 					      &vring->va[vring->swtail].tx;
 		struct vring_tx_desc dd, *d = &dd;
 		dma_addr_t pa;
 		struct sk_buff *skb;
 		u16 dmalen;
 
-		dd = *d1;
+		*d = *_d;
 
 		if (!(d->dma.status & TX_DMA_STATUS_DU))
 			break;
@@ -830,7 +844,7 @@ int wil_tx_complete(struct wil6210_priv *wil, int ringid)
 		wil_hex_dump_txrx("TxC ", DUMP_PREFIX_NONE, 32, 4,
 				  (const void *)d, sizeof(*d), false);
 
-		pa = d->dma.addr_low | ((u64)d->dma.addr_high << 32);
+		pa = wil_desc_addr(&d->dma.addr);
 		skb = vring->ctx[vring->swtail];
 		if (skb) {
 			if (d->dma.error == 0) {
@@ -846,8 +860,8 @@ int wil_tx_complete(struct wil6210_priv *wil, int ringid)
 		} else {
 			dma_unmap_page(dev, pa, dmalen, DMA_TO_DEVICE);
 		}
-		d->dma.addr_low = 0;
-		d->dma.addr_high = 0;
+		d->dma.addr.addr_low = 0;
+		d->dma.addr.addr_high = 0;
 		d->dma.length = 0;
 		d->dma.status = TX_DMA_STATUS_DU;
 		vring->swtail = wil_vring_next_tail(vring);
diff --git a/drivers/net/wireless/ath/wil6210/txrx.h b/drivers/net/wireless/ath/wil6210/txrx.h
index a40aa0b..23c0781 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.h
+++ b/drivers/net/wireless/ath/wil6210/txrx.h
@@ -27,6 +27,28 @@
 #define WIL6210_RTAP_SIZE (128)
 
 /* Tx/Rx path */
+
+/*
+ * Common representation of physical address in Vring
+ */
+struct vring_dma_addr {
+	__le32 addr_low;
+	__le16 addr_high;
+} __packed;
+
+static inline dma_addr_t wil_desc_addr(struct vring_dma_addr *addr)
+{
+	return le32_to_cpu(addr->addr_low) |
+			   ((u64)le16_to_cpu(addr->addr_high) << 32);
+}
+
+static inline void wil_desc_addr_set(struct vring_dma_addr *addr,
+				     dma_addr_t pa)
+{
+	addr->addr_low = cpu_to_le32(lower_32_bits(pa));
+	addr->addr_high = cpu_to_le16((u16)upper_32_bits(pa));
+}
+
 /*
  * Tx descriptor - MAC part
  * [dword 0]
@@ -216,8 +238,7 @@ struct vring_tx_mac {
 
 struct vring_tx_dma {
 	u32 d0;
-	u32 addr_low;
-	u16 addr_high;
+	struct vring_dma_addr addr;
 	u8  ip_length;
 	u8  b11;       /* 0..6: mac_length; 7:ip_version */
 	u8  error;     /* 0..2: err; 3..7: reserved; */
@@ -315,8 +336,7 @@ struct vring_rx_mac {
 
 struct vring_rx_dma {
 	u32 d0;
-	u32 addr_low;
-	u16 addr_high;
+	struct vring_dma_addr addr;
 	u8  ip_length;
 	u8  b11;
 	u8  error;
-- 
1.8.1.2

