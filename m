Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:57146 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbZK3RMD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 12:12:03 -0500
Date: Mon, 30 Nov 2009 18:12:08 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 03/12] mwl8k: prevent corruption of QoS field on receive
Message-ID: <20091130171208.GF20214@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Packets exchanged between the mwl8k driver and the firmware always
have a 4-address header without QoS field.  For QoS packets, the QoS
field is passed to/from the firmware via the tx/rx descriptors.

We were handling this correctly on transmit, but not on receive -- if
a QoS packet was received, we would leave garbage in the QoS field in
the packet passed up to the stack, which is Bad(tm).

Also, if the packet received on the air was a 4-address without QoS
packet, we would forget to skb_pull the 2-byte DMA length prefix off.

This patch adds an argument to the ->rxd_process() receive descriptor
operation to retrieve the QoS field from the receive descriptor, and
extends mwl8k_remove_dma_header() to insert this field back into the
packet if the packet received is a QoS packet.  It also fixes
mwl8k_remove_dma_header() to strip off the length prefix in all cases.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   48 ++++++++++++++++++++++++++++--------------
 1 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index a72ee1f..8eed851 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -84,7 +84,8 @@ struct rxd_ops {
 	int rxd_size;
 	void (*rxd_init)(void *rxd, dma_addr_t next_dma_addr);
 	void (*rxd_refill)(void *rxd, dma_addr_t addr, int len);
-	int (*rxd_process)(void *rxd, struct ieee80211_rx_status *status);
+	int (*rxd_process)(void *rxd, struct ieee80211_rx_status *status,
+			   __le16 *qos);
 };
 
 struct mwl8k_device_info {
@@ -699,21 +700,29 @@ static inline u16 mwl8k_qos_setbit_qlen(u16 qos, u8 len)
 struct mwl8k_dma_data {
 	__le16 fwlen;
 	struct ieee80211_hdr wh;
+	char data[0];
 } __attribute__((packed));
 
 /* Routines to add/remove DMA header from skb.  */
-static inline void mwl8k_remove_dma_header(struct sk_buff *skb)
+static inline void mwl8k_remove_dma_header(struct sk_buff *skb, __le16 qos)
 {
-	struct mwl8k_dma_data *tr = (struct mwl8k_dma_data *)skb->data;
-	void *dst, *src = &tr->wh;
-	int hdrlen = ieee80211_hdrlen(tr->wh.frame_control);
-	u16 space = sizeof(struct mwl8k_dma_data) - hdrlen;
+	struct mwl8k_dma_data *tr;
+	int hdrlen;
+
+	tr = (struct mwl8k_dma_data *)skb->data;
+	hdrlen = ieee80211_hdrlen(tr->wh.frame_control);
 
-	dst = (void *)tr + space;
-	if (dst != src) {
-		memmove(dst, src, hdrlen);
-		skb_pull(skb, space);
+	if (hdrlen != sizeof(tr->wh)) {
+		if (ieee80211_is_data_qos(tr->wh.frame_control)) {
+			memmove(tr->data - hdrlen, &tr->wh, hdrlen - 2);
+			*((__le16 *)(tr->data - 2)) = qos;
+		} else {
+			memmove(tr->data - hdrlen, &tr->wh, hdrlen);
+		}
 	}
+
+	if (hdrlen != sizeof(*tr))
+		skb_pull(skb, sizeof(*tr) - hdrlen);
 }
 
 static inline void mwl8k_add_dma_header(struct sk_buff *skb)
@@ -793,7 +802,8 @@ static void mwl8k_rxd_8366_refill(void *_rxd, dma_addr_t addr, int len)
 }
 
 static int
-mwl8k_rxd_8366_process(void *_rxd, struct ieee80211_rx_status *status)
+mwl8k_rxd_8366_process(void *_rxd, struct ieee80211_rx_status *status,
+		       __le16 *qos)
 {
 	struct mwl8k_rxd_8366 *rxd = _rxd;
 
@@ -823,6 +833,8 @@ mwl8k_rxd_8366_process(void *_rxd, struct ieee80211_rx_status *status)
 	status->band = IEEE80211_BAND_2GHZ;
 	status->freq = ieee80211_channel_to_frequency(rxd->channel);
 
+	*qos = rxd->qos_control;
+
 	return le16_to_cpu(rxd->pkt_len);
 }
 
@@ -881,7 +893,8 @@ static void mwl8k_rxd_8687_refill(void *_rxd, dma_addr_t addr, int len)
 }
 
 static int
-mwl8k_rxd_8687_process(void *_rxd, struct ieee80211_rx_status *status)
+mwl8k_rxd_8687_process(void *_rxd, struct ieee80211_rx_status *status,
+		       __le16 *qos)
 {
 	struct mwl8k_rxd_8687 *rxd = _rxd;
 	u16 rate_info;
@@ -912,6 +925,8 @@ mwl8k_rxd_8687_process(void *_rxd, struct ieee80211_rx_status *status)
 	status->band = IEEE80211_BAND_2GHZ;
 	status->freq = ieee80211_channel_to_frequency(rxd->channel);
 
+	*qos = rxd->qos_control;
+
 	return le16_to_cpu(rxd->pkt_len);
 }
 
@@ -1083,6 +1098,7 @@ static int rxq_process(struct ieee80211_hw *hw, int index, int limit)
 		void *rxd;
 		int pkt_len;
 		struct ieee80211_rx_status status;
+		__le16 qos;
 
 		skb = rxq->buf[rxq->head].skb;
 		if (skb == NULL)
@@ -1090,7 +1106,7 @@ static int rxq_process(struct ieee80211_hw *hw, int index, int limit)
 
 		rxd = rxq->rxd + (rxq->head * priv->rxd_ops->rxd_size);
 
-		pkt_len = priv->rxd_ops->rxd_process(rxd, &status);
+		pkt_len = priv->rxd_ops->rxd_process(rxd, &status, &qos);
 		if (pkt_len < 0)
 			break;
 
@@ -1108,7 +1124,7 @@ static int rxq_process(struct ieee80211_hw *hw, int index, int limit)
 		rxq->rxd_count--;
 
 		skb_put(skb, pkt_len);
-		mwl8k_remove_dma_header(skb);
+		mwl8k_remove_dma_header(skb, qos);
 
 		/*
 		 * Check for a pending join operation.  Save a
@@ -1354,7 +1370,7 @@ static void mwl8k_txq_reclaim(struct ieee80211_hw *hw, int index, int force)
 		BUG_ON(skb == NULL);
 		pci_unmap_single(priv->pdev, addr, size, PCI_DMA_TODEVICE);
 
-		mwl8k_remove_dma_header(skb);
+		mwl8k_remove_dma_header(skb, tx_desc->qos_control);
 
 		/* Mark descriptor as unused */
 		tx_desc->pkt_phys_addr = 0;
-- 
1.5.6.4
