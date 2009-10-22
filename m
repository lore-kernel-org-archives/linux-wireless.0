Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:59619 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918AbZJVSxs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 14:53:48 -0400
Date: Thu, 22 Oct 2009 20:20:59 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 19/28] mwl8k: allow for different receive descriptor formats
Message-ID: <20091022182059.GU1583@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As the receive descriptor format is determined by the firmware running
on the hardware and not by the hardware itself, and as these
descriptor formats vary a bit between different firmware releases,
abstract out the receive descriptor init/refill/process methods, and
allow choosing between different formats at run time depending on the
chip and firmware we're running on.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |  180 ++++++++++++++++++++++++++++--------------
 1 files changed, 119 insertions(+), 61 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 96faec6..9c10c88 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -79,10 +79,18 @@
 #define MWL8K_RX_QUEUES		1
 #define MWL8K_TX_QUEUES		4
 
+struct rxd_ops {
+	int rxd_size;
+	void (*rxd_init)(void *rxd, dma_addr_t next_dma_addr);
+	void (*rxd_refill)(void *rxd, dma_addr_t addr, int len);
+	int (*rxd_process)(void *rxd, struct ieee80211_rx_status *status);
+};
+
 struct mwl8k_device_info {
 	char *part_name;
 	char *helper_image;
 	char *fw_image;
+	struct rxd_ops *rxd_ops;
 };
 
 struct mwl8k_rx_queue {
@@ -94,7 +102,7 @@ struct mwl8k_rx_queue {
 	/* refill descs here */
 	int tail;
 
-	struct mwl8k_rx_desc *rxd;
+	void *rxd;
 	dma_addr_t rxd_dma;
 	struct {
 		struct sk_buff *skb;
@@ -133,6 +141,7 @@ struct mwl8k_priv {
 
 	struct mwl8k_device_info *device_info;
 	bool ap_fw;
+	struct rxd_ops *rxd_ops;
 
 	/* firmware files and meta data */
 	struct mwl8k_firmware fw;
@@ -743,9 +752,7 @@ static inline void mwl8k_add_dma_header(struct sk_buff *skb)
 /*
  * Packet reception.
  */
-#define MWL8K_RX_CTRL_OWNED_BY_HOST	0x02
-
-struct mwl8k_rx_desc {
+struct mwl8k_rxd_8687 {
 	__le16 pkt_len;
 	__u8 link_quality;
 	__u8 noise_level;
@@ -762,16 +769,79 @@ struct mwl8k_rx_desc {
 	__u8 pad2[2];
 } __attribute__((packed));
 
+#define MWL8K_8687_RATE_INFO_SHORTPRE		0x8000
+#define MWL8K_8687_RATE_INFO_ANTSELECT(x)	(((x) >> 11) & 0x3)
+#define MWL8K_8687_RATE_INFO_RATEID(x)		(((x) >> 3) & 0x3f)
+#define MWL8K_8687_RATE_INFO_40MHZ		0x0004
+#define MWL8K_8687_RATE_INFO_SHORTGI		0x0002
+#define MWL8K_8687_RATE_INFO_MCS_FORMAT		0x0001
+
+#define MWL8K_8687_RX_CTRL_OWNED_BY_HOST	0x02
+
+static void mwl8k_rxd_8687_init(void *_rxd, dma_addr_t next_dma_addr)
+{
+	struct mwl8k_rxd_8687 *rxd = _rxd;
+
+	rxd->next_rxd_phys_addr = cpu_to_le32(next_dma_addr);
+	rxd->rx_ctrl = MWL8K_8687_RX_CTRL_OWNED_BY_HOST;
+}
+
+static void mwl8k_rxd_8687_refill(void *_rxd, dma_addr_t addr, int len)
+{
+	struct mwl8k_rxd_8687 *rxd = _rxd;
+
+	rxd->pkt_len = cpu_to_le16(len);
+	rxd->pkt_phys_addr = cpu_to_le32(addr);
+	wmb();
+	rxd->rx_ctrl = 0;
+}
+
+static int
+mwl8k_rxd_8687_process(void *_rxd, struct ieee80211_rx_status *status)
+{
+	struct mwl8k_rxd_8687 *rxd = _rxd;
+	u16 rate_info;
+
+	if (!(rxd->rx_ctrl & MWL8K_8687_RX_CTRL_OWNED_BY_HOST))
+		return -1;
+	rmb();
+
+	rate_info = le16_to_cpu(rxd->rate_info);
+
+	memset(status, 0, sizeof(*status));
+
+	status->signal = -rxd->rssi;
+	status->noise = -rxd->noise_level;
+	status->qual = rxd->link_quality;
+	status->antenna = MWL8K_8687_RATE_INFO_ANTSELECT(rate_info);
+	status->rate_idx = MWL8K_8687_RATE_INFO_RATEID(rate_info);
+
+	if (rate_info & MWL8K_8687_RATE_INFO_SHORTPRE)
+		status->flag |= RX_FLAG_SHORTPRE;
+	if (rate_info & MWL8K_8687_RATE_INFO_40MHZ)
+		status->flag |= RX_FLAG_40MHZ;
+	if (rate_info & MWL8K_8687_RATE_INFO_SHORTGI)
+		status->flag |= RX_FLAG_SHORT_GI;
+	if (rate_info & MWL8K_8687_RATE_INFO_MCS_FORMAT)
+		status->flag |= RX_FLAG_HT;
+
+	status->band = IEEE80211_BAND_2GHZ;
+	status->freq = ieee80211_channel_to_frequency(rxd->channel);
+
+	return le16_to_cpu(rxd->pkt_len);
+}
+
+static struct rxd_ops rxd_8687_ops = {
+	.rxd_size	= sizeof(struct mwl8k_rxd_8687),
+	.rxd_init	= mwl8k_rxd_8687_init,
+	.rxd_refill	= mwl8k_rxd_8687_refill,
+	.rxd_process	= mwl8k_rxd_8687_process,
+};
+
+
 #define MWL8K_RX_DESCS		256
 #define MWL8K_RX_MAXSZ		3800
 
-#define RATE_INFO_SHORTPRE		0x8000
-#define RATE_INFO_ANTSELECT(x)		(((x) >> 11) & 0x3)
-#define RATE_INFO_RATEID(x)		(((x) >> 3) & 0x3f)
-#define RATE_INFO_40MHZ			0x0004
-#define RATE_INFO_SHORTGI		0x0002
-#define RATE_INFO_MCS_FORMAT		0x0001
-
 static int mwl8k_rxq_init(struct ieee80211_hw *hw, int index)
 {
 	struct mwl8k_priv *priv = hw->priv;
@@ -783,7 +853,7 @@ static int mwl8k_rxq_init(struct ieee80211_hw *hw, int index)
 	rxq->head = 0;
 	rxq->tail = 0;
 
-	size = MWL8K_RX_DESCS * sizeof(struct mwl8k_rx_desc);
+	size = MWL8K_RX_DESCS * priv->rxd_ops->rxd_size;
 
 	rxq->rxd = pci_alloc_consistent(priv->pdev, size, &rxq->rxd_dma);
 	if (rxq->rxd == NULL) {
@@ -803,15 +873,20 @@ static int mwl8k_rxq_init(struct ieee80211_hw *hw, int index)
 	memset(rxq->buf, 0, MWL8K_RX_DESCS * sizeof(*rxq->buf));
 
 	for (i = 0; i < MWL8K_RX_DESCS; i++) {
-		struct mwl8k_rx_desc *rx_desc;
+		int desc_size;
+		void *rxd;
 		int nexti;
+		dma_addr_t next_dma_addr;
+
+		desc_size = priv->rxd_ops->rxd_size;
+		rxd = rxq->rxd + (i * priv->rxd_ops->rxd_size);
 
-		rx_desc = rxq->rxd + i;
-		nexti = (i + 1) % MWL8K_RX_DESCS;
+		nexti = i + 1;
+		if (nexti == MWL8K_RX_DESCS)
+			nexti = 0;
+		next_dma_addr = rxq->rxd_dma + (nexti * desc_size);
 
-		rx_desc->next_rxd_phys_addr =
-			cpu_to_le32(rxq->rxd_dma + nexti * sizeof(*rx_desc));
-		rx_desc->rx_ctrl = MWL8K_RX_CTRL_OWNED_BY_HOST;
+		priv->rxd_ops->rxd_init(rxd, next_dma_addr);
 	}
 
 	return 0;
@@ -828,25 +903,24 @@ static int rxq_refill(struct ieee80211_hw *hw, int index, int limit)
 		struct sk_buff *skb;
 		dma_addr_t addr;
 		int rx;
+		void *rxd;
 
 		skb = dev_alloc_skb(MWL8K_RX_MAXSZ);
 		if (skb == NULL)
 			break;
 
-		rxq->rxd_count++;
-
-		rx = rxq->tail;
-		rxq->tail = (rx + 1) % MWL8K_RX_DESCS;
-
 		addr = pci_map_single(priv->pdev, skb->data,
 				      MWL8K_RX_MAXSZ, DMA_FROM_DEVICE);
 
-		rxq->rxd[rx].pkt_len = cpu_to_le16(MWL8K_RX_MAXSZ);
-		rxq->rxd[rx].pkt_phys_addr = cpu_to_le32(addr);
+		rxq->rxd_count++;
+		rx = rxq->tail++;
+		if (rxq->tail == MWL8K_RX_DESCS)
+			rxq->tail = 0;
 		rxq->buf[rx].skb = skb;
 		pci_unmap_addr_set(&rxq->buf[rx], dma, addr);
-		wmb();
-		rxq->rxd[rx].rx_ctrl = 0;
+
+		rxd = rxq->rxd + (rx * priv->rxd_ops->rxd_size);
+		priv->rxd_ops->rxd_refill(rxd, addr, MWL8K_RX_MAXSZ);
 
 		refilled++;
 	}
@@ -877,7 +951,7 @@ static void mwl8k_rxq_deinit(struct ieee80211_hw *hw, int index)
 	rxq->buf = NULL;
 
 	pci_free_consistent(priv->pdev,
-			    MWL8K_RX_DESCS * sizeof(struct mwl8k_rx_desc),
+			    MWL8K_RX_DESCS * priv->rxd_ops->rxd_size,
 			    rxq->rxd, rxq->rxd_dma);
 	rxq->rxd = NULL;
 }
@@ -921,20 +995,21 @@ static int rxq_process(struct ieee80211_hw *hw, int index, int limit)
 
 	processed = 0;
 	while (rxq->rxd_count && limit--) {
-		struct mwl8k_rx_desc *rx_desc;
 		struct sk_buff *skb;
+		void *rxd;
+		int pkt_len;
 		struct ieee80211_rx_status status;
-		struct ieee80211_hdr *wh;
-		u16 rate_info;
-
-		rx_desc = rxq->rxd + rxq->head;
-		if (!(rx_desc->rx_ctrl & MWL8K_RX_CTRL_OWNED_BY_HOST))
-			break;
-		rmb();
 
 		skb = rxq->buf[rxq->head].skb;
 		if (skb == NULL)
 			break;
+
+		rxd = rxq->rxd + (rxq->head * priv->rxd_ops->rxd_size);
+
+		pkt_len = priv->rxd_ops->rxd_process(rxd, &status);
+		if (pkt_len < 0)
+			break;
+
 		rxq->buf[rxq->head].skb = NULL;
 
 		pci_unmap_single(priv->pdev,
@@ -942,42 +1017,23 @@ static int rxq_process(struct ieee80211_hw *hw, int index, int limit)
 				 MWL8K_RX_MAXSZ, PCI_DMA_FROMDEVICE);
 		pci_unmap_addr_set(&rxq->buf[rxq->head], dma, 0);
 
-		rxq->head = (rxq->head + 1) % MWL8K_RX_DESCS;
+		rxq->head++;
+		if (rxq->head == MWL8K_RX_DESCS)
+			rxq->head = 0;
+
 		rxq->rxd_count--;
 
-		skb_put(skb, le16_to_cpu(rx_desc->pkt_len));
+		skb_put(skb, pkt_len);
 		mwl8k_remove_dma_header(skb);
 
-		wh = (struct ieee80211_hdr *)skb->data;
-
 		/*
 		 * Check for a pending join operation.  Save a
 		 * copy of the beacon and schedule a tasklet to
 		 * send a FINALIZE_JOIN command to the firmware.
 		 */
-		if (mwl8k_capture_bssid(priv, wh))
+		if (mwl8k_capture_bssid(priv, (void *)skb->data))
 			mwl8k_save_beacon(hw, skb);
 
-		rate_info = le16_to_cpu(rx_desc->rate_info);
-
-		memset(&status, 0, sizeof(status));
-		status.mactime = 0;
-		status.signal = -rx_desc->rssi;
-		status.noise = -rx_desc->noise_level;
-		status.qual = rx_desc->link_quality;
-		status.antenna = RATE_INFO_ANTSELECT(rate_info);
-		status.rate_idx = RATE_INFO_RATEID(rate_info);
-		status.flag = 0;
-		if (rate_info & RATE_INFO_SHORTPRE)
-			status.flag |= RX_FLAG_SHORTPRE;
-		if (rate_info & RATE_INFO_40MHZ)
-			status.flag |= RX_FLAG_40MHZ;
-		if (rate_info & RATE_INFO_SHORTGI)
-			status.flag |= RX_FLAG_SHORT_GI;
-		if (rate_info & RATE_INFO_MCS_FORMAT)
-			status.flag |= RX_FLAG_HT;
-		status.band = IEEE80211_BAND_2GHZ;
-		status.freq = ieee80211_channel_to_frequency(rx_desc->channel);
 		memcpy(IEEE80211_SKB_RXCB(skb), &status, sizeof(status));
 		ieee80211_rx_irqsafe(hw, skb);
 
@@ -2958,6 +3014,7 @@ static struct mwl8k_device_info di_8687 = {
 	.part_name	= "88w8687",
 	.helper_image	= "mwl8k/helper_8687.fw",
 	.fw_image	= "mwl8k/fmimage_8687.fw",
+	.rxd_ops	= &rxd_8687_ops,
 };
 
 static DEFINE_PCI_DEVICE_TABLE(mwl8k_pci_id_table) = {
@@ -3013,6 +3070,7 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	priv->hw = hw;
 	priv->pdev = pdev;
 	priv->device_info = (void *)id->driver_data;
+	priv->rxd_ops = priv->device_info->rxd_ops;
 	priv->sniffer_enabled = false;
 	priv->wmm_enabled = false;
 	priv->pending_tx_pkts = 0;
-- 
1.5.6.4
