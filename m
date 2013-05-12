Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:20912 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab3ELLoH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 May 2013 07:44:07 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/7] wil6210: 'length' in Tx/Rx descriptors is little endian
Date: Sun, 12 May 2013 14:43:32 +0300
Message-ID: <1368359018-20870-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130512_134412_623809_7219E4C5)
In-Reply-To: <1368359018-20870-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1368359018-20870-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hardware uses little endian for the Tx/Rx descriptors field 'length',
do appropriate conversions

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c |  8 +++++++-
 drivers/net/wireless/ath/wil6210/txrx.c    | 33 +++++++++++++++++++-----------
 drivers/net/wireless/ath/wil6210/txrx.h    |  4 ++--
 3 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 4be07f5..b32c58e 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -418,9 +418,15 @@ static int wil_txdesc_debugfs_show(struct seq_file *s, void *data)
 		if (skb) {
 			unsigned char printbuf[16 * 3 + 2];
 			int i = 0;
-			int len = skb_headlen(skb);
+			int len = le16_to_cpu(d->dma.length);
 			void *p = skb->data;
 
+			if (len != skb_headlen(skb)) {
+				seq_printf(s, "!!! len: desc = %d skb = %d\n",
+					   len, skb_headlen(skb));
+				len = min_t(int, len, skb_headlen(skb));
+			}
+
 			seq_printf(s, "    len = %d\n", len);
 
 			while (i < len) {
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 91454a4..b9cac7d 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -108,19 +108,21 @@ static void wil_vring_free(struct wil6210_priv *wil, struct vring *vring,
 	size_t sz = vring->size * sizeof(vring->va[0]);
 
 	while (!wil_vring_is_empty(vring)) {
+		u16 dmalen;
 		if (tx) {
 			volatile struct vring_tx_desc *d =
 					&vring->va[vring->swtail].tx;
 			dma_addr_t pa = d->dma.addr_low |
 					((u64)d->dma.addr_high << 32);
 			struct sk_buff *skb = vring->ctx[vring->swtail];
+			dmalen = le16_to_cpu(d->dma.length);
 			if (skb) {
-				dma_unmap_single(dev, pa, d->dma.length,
+				dma_unmap_single(dev, pa, dmalen,
 						 DMA_TO_DEVICE);
 				dev_kfree_skb_any(skb);
 				vring->ctx[vring->swtail] = NULL;
 			} else {
-				dma_unmap_page(dev, pa, d->dma.length,
+				dma_unmap_page(dev, pa, dmalen,
 					       DMA_TO_DEVICE);
 			}
 			vring->swtail = wil_vring_next_tail(vring);
@@ -130,8 +132,8 @@ static void wil_vring_free(struct wil6210_priv *wil, struct vring *vring,
 			dma_addr_t pa = d->dma.addr_low |
 					((u64)d->dma.addr_high << 32);
 			struct sk_buff *skb = vring->ctx[vring->swhead];
-			dma_unmap_single(dev, pa, d->dma.length,
-					 DMA_FROM_DEVICE);
+			dmalen = le16_to_cpu(d->dma.length);
+			dma_unmap_single(dev, pa, dmalen, DMA_FROM_DEVICE);
 			kfree_skb(skb);
 			wil_vring_advance_head(vring, 1);
 		}
@@ -177,7 +179,7 @@ static int wil_vring_alloc_skb(struct wil6210_priv *wil, struct vring *vring,
 	/* b11 don't care */
 	/* error don't care */
 	d->dma.status = 0; /* BIT(0) should be 0 for HW_OWNED */
-	d->dma.length = sz;
+	d->dma.length = cpu_to_le16(sz);
 	vring->ctx[i] = skb;
 
 	return 0;
@@ -328,6 +330,7 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	struct sk_buff *skb;
 	dma_addr_t pa;
 	unsigned int sz = RX_BUF_LEN;
+	u16 dmalen;
 	u8 ftype;
 	u8 ds_bits;
 
@@ -345,10 +348,11 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	pa = d->dma.addr_low | ((u64)d->dma.addr_high << 32);
 	skb = vring->ctx[vring->swhead];
 	dma_unmap_single(dev, pa, sz, DMA_FROM_DEVICE);
-	skb_trim(skb, d->dma.length);
 
 	d1 = wil_skb_rxdesc(skb);
 	*d1 = *d;
+	dmalen = le16_to_cpu(d1->dma.length);
+	skb_trim(skb, dmalen);
 
 	wil->stats.last_mcs_rx = wil_rxdesc_mcs(d1);
 
@@ -612,7 +616,7 @@ static int wil_tx_desc_map(volatile struct vring_tx_desc *d,
 	d->dma.b11 = 0/*14 | BIT(7)*/;
 	d->dma.error = 0;
 	d->dma.status = 0; /* BIT(0) should be 0 for HW_OWNED */
-	d->dma.length = len;
+	d->dma.length = cpu_to_le16((u16)len);
 	d->dma.d0 = 0;
 	d->mac.d[0] = 0;
 	d->mac.d[1] = 0;
@@ -707,14 +711,17 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	/* unmap what we have mapped */
 	/* Note: increment @f to operate with positive index */
 	for (f++; f > 0; f--) {
+		u16 dmalen;
+
 		i = (swhead + f) % vring->size;
 		d = &(vring->va[i].tx);
 		d->dma.status = TX_DMA_STATUS_DU;
 		pa = d->dma.addr_low | ((u64)d->dma.addr_high << 32);
+		dmalen = le16_to_cpu(d->dma.length);
 		if (vring->ctx[i])
-			dma_unmap_single(dev, pa, d->dma.length, DMA_TO_DEVICE);
+			dma_unmap_single(dev, pa, dmalen, DMA_TO_DEVICE);
 		else
-			dma_unmap_page(dev, pa, d->dma.length, DMA_TO_DEVICE);
+			dma_unmap_page(dev, pa, dmalen, DMA_TO_DEVICE);
 	}
 
 	return -EINVAL;
@@ -794,15 +801,17 @@ void wil_tx_complete(struct wil6210_priv *wil, int ringid)
 		struct vring_tx_desc dd, *d = &dd;
 		dma_addr_t pa;
 		struct sk_buff *skb;
+		u16 dmalen;
 
 		dd = *d1;
 
 		if (!(d->dma.status & TX_DMA_STATUS_DU))
 			break;
 
+		dmalen = le16_to_cpu(d->dma.length);
 		wil_dbg_txrx(wil,
 			     "Tx[%3d] : %d bytes, status 0x%02x err 0x%02x\n",
-			     vring->swtail, d->dma.length, d->dma.status,
+			     vring->swtail, dmalen, d->dma.status,
 			     d->dma.error);
 		wil_hex_dump_txrx("TxC ", DUMP_PREFIX_NONE, 32, 4,
 				  (const void *)d, sizeof(*d), false);
@@ -817,11 +826,11 @@ void wil_tx_complete(struct wil6210_priv *wil, int ringid)
 				ndev->stats.tx_errors++;
 			}
 
-			dma_unmap_single(dev, pa, d->dma.length, DMA_TO_DEVICE);
+			dma_unmap_single(dev, pa, dmalen, DMA_TO_DEVICE);
 			dev_kfree_skb_any(skb);
 			vring->ctx[vring->swtail] = NULL;
 		} else {
-			dma_unmap_page(dev, pa, d->dma.length, DMA_TO_DEVICE);
+			dma_unmap_page(dev, pa, dmalen, DMA_TO_DEVICE);
 		}
 		d->dma.addr_low = 0;
 		d->dma.addr_high = 0;
diff --git a/drivers/net/wireless/ath/wil6210/txrx.h b/drivers/net/wireless/ath/wil6210/txrx.h
index adef12f..a40aa0b 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.h
+++ b/drivers/net/wireless/ath/wil6210/txrx.h
@@ -222,7 +222,7 @@ struct vring_tx_dma {
 	u8  b11;       /* 0..6: mac_length; 7:ip_version */
 	u8  error;     /* 0..2: err; 3..7: reserved; */
 	u8  status;    /* 0: used; 1..7; reserved */
-	u16 length;
+	__le16 length;
 } __packed;
 
 /*
@@ -321,7 +321,7 @@ struct vring_rx_dma {
 	u8  b11;
 	u8  error;
 	u8  status;
-	u16 length;
+	__le16 length;
 } __packed;
 
 struct vring_tx_desc {
-- 
1.8.1.2

