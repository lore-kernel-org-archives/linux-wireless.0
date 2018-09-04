Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:48888 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726168AbeIDTH6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 15:07:58 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 15/22] mt76: unify txwi and rxwi structures
Date: Tue,  4 Sep 2018 16:41:08 +0200
Message-Id: <1536072075-6990-16-git-send-email-sgruszka@redhat.com> (sfid-20180904_164253_466612_AB606E77)
In-Reply-To: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
References: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

txwi and rxwi are the same for mt76x0 and mt76x2.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/dma.c    | 12 ++--
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.c    |  4 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.h    | 67 ----------------------
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |  4 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/trace.h  | 12 ++--
 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c     | 18 +++---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h   | 54 +++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_common.c |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_dma.c    |  6 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c   |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c    |  6 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.h    | 57 +-----------------
 .../net/wireless/mediatek/mt76/mt76x2_mac_common.c |  4 +-
 drivers/net/wireless/mediatek/mt76/mt76x2u_core.c  |  8 +--
 15 files changed, 94 insertions(+), 164 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/dma.c b/drivers/net/wireless/mediatek/mt76/mt76x0/dma.c
index 715c3734a307..05e577342a90 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/dma.c
@@ -34,7 +34,7 @@ static unsigned int ieee80211_get_hdrlen_from_buf(const u8 *data, unsigned len)
 }
 
 static struct sk_buff *
-mt76x0_rx_skb_from_seg(struct mt76x0_dev *dev, struct mt76x0_rxwi *rxwi,
+mt76x0_rx_skb_from_seg(struct mt76x0_dev *dev, struct mt76x02_rxwi *rxwi,
 			void *data, u32 seg_len, u32 truesize, struct page *p)
 {
 	struct sk_buff *skb;
@@ -86,7 +86,7 @@ static void mt76x0_rx_process_seg(struct mt76x0_dev *dev, u8 *data,
 				   u32 seg_len, struct page *p)
 {
 	struct sk_buff *skb;
-	struct mt76x0_rxwi *rxwi;
+	struct mt76x02_rxwi *rxwi;
 	u32 fce_info, truesize = seg_len;
 
 	/* DMA_INFO field at the beginning of the segment contains only some of
@@ -98,9 +98,9 @@ static void mt76x0_rx_process_seg(struct mt76x0_dev *dev, u8 *data,
 	data += MT_DMA_HDR_LEN;
 	seg_len -= MT_DMA_HDR_LEN;
 
-	rxwi = (struct mt76x0_rxwi *) data;
-	data += sizeof(struct mt76x0_rxwi);
-	seg_len -= sizeof(struct mt76x0_rxwi);
+	rxwi = (struct mt76x02_rxwi *) data;
+	data += sizeof(struct mt76x02_rxwi);
+	seg_len -= sizeof(struct mt76x02_rxwi);
 
 	if (unlikely(FIELD_GET(MT_RXD_INFO_TYPE, fce_info)))
 		dev_err_once(dev->mt76.dev, "Error: RX path seen a non-pkt urb\n");
@@ -119,7 +119,7 @@ static void mt76x0_rx_process_seg(struct mt76x0_dev *dev, u8 *data,
 static u16 mt76x0_rx_next_seg_len(u8 *data, u32 data_len)
 {
 	u32 min_seg_len = MT_DMA_HDR_LEN + MT_RX_INFO_LEN +
-		sizeof(struct mt76x0_rxwi) + MT_FCE_INFO_LEN;
+		sizeof(struct mt76x02_rxwi) + MT_FCE_INFO_LEN;
 	u16 dma_len = get_unaligned_le16(data);
 
 	if (data_len < min_seg_len ||
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
index 65b04e314621..46646a7461bd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
@@ -431,7 +431,7 @@ mt76_mac_process_rate(struct ieee80211_rx_status *status, u16 rate)
 }
 
 static void
-mt76x0_rx_monitor_beacon(struct mt76x0_dev *dev, struct mt76x0_rxwi *rxwi,
+mt76x0_rx_monitor_beacon(struct mt76x0_dev *dev, struct mt76x02_rxwi *rxwi,
 			  u16 rate, int rssi)
 {
 	dev->bcn_phy_mode = FIELD_GET(MT_RXWI_RATE_PHY, rate);
@@ -451,7 +451,7 @@ u32 mt76x0_mac_process_rx(struct mt76x0_dev *dev, struct sk_buff *skb,
 			u8 *data, void *rxi)
 {
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
-	struct mt76x0_rxwi *rxwi = rxi;
+	struct mt76x02_rxwi *rxwi = rxi;
 	u32 len, ctl = le32_to_cpu(rxwi->ctl);
 	u16 rate = le16_to_cpu(rxwi->rate);
 	int rssi;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h
index aee7dc8f258e..33b6e1e82eaa 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h
@@ -15,73 +15,6 @@
 #ifndef __MT76_MAC_H
 #define __MT76_MAC_H
 
-/* Note: values in original "RSSI" and "SNR" fields are not actually what they
- *	 are called for MT76X0U, names used by this driver are educated guesses
- *	 (see vendor mac/ral_omac.c).
- */
-struct mt76x0_rxwi {
-	__le32 rxinfo;
-
-	__le32 ctl;
-
-	__le16 tid_sn;
-	__le16 rate;
-
-	s8 rssi[4];
-
-	__le32 bbp_rxinfo[4];
-} __packed __aligned(4);
-
-enum mt76_phy_bandwidth {
-	MT_PHY_BW_20,
-	MT_PHY_BW_40,
-	MT_PHY_BW_80,
-};
-
-struct mt76_txwi {
-	__le16 flags;
-	__le16 rate_ctl;
-	u8 ack_ctl;
-	u8 wcid;
-	__le16 len_ctl;
-	__le32 iv;
-	__le32 eiv;
-	u8 aid;
-	u8 txstream;
-	u8 ctl2;
-	u8 pktid;
-} __packed __aligned(4);
-
-#define MT_TXWI_FLAGS_FRAG		BIT(0)
-#define MT_TXWI_FLAGS_MMPS		BIT(1)
-#define MT_TXWI_FLAGS_CFACK		BIT(2)
-#define MT_TXWI_FLAGS_TS		BIT(3)
-#define MT_TXWI_FLAGS_AMPDU		BIT(4)
-#define MT_TXWI_FLAGS_MPDU_DENSITY	GENMASK(7, 5)
-#define MT_TXWI_FLAGS_TXOP		GENMASK(9, 8)
-#define MT_TXWI_FLAGS_CWMIN		GENMASK(12, 10)
-#define MT_TXWI_FLAGS_NO_RATE_FALLBACK	BIT(13)
-#define MT_TXWI_FLAGS_TX_RPT		BIT(14)
-#define MT_TXWI_FLAGS_TX_RATE_LUT	BIT(15)
-
-#define MT_TXWI_RATE_MCS		GENMASK(6, 0)
-#define MT_TXWI_RATE_BW			BIT(7)
-#define MT_TXWI_RATE_SGI		BIT(8)
-#define MT_TXWI_RATE_STBC		GENMASK(10, 9)
-#define MT_TXWI_RATE_PHY_MODE		GENMASK(15, 14)
-
-#define MT_TXWI_ACK_CTL_REQ		BIT(0)
-#define MT_TXWI_ACK_CTL_NSEQ		BIT(1)
-#define MT_TXWI_ACK_CTL_BA_WINDOW	GENMASK(7, 2)
-
-#define MT_TXWI_LEN_BYTE_CNT		GENMASK(11, 0)
-
-#define MT_TXWI_CTL_TX_POWER_ADJ	GENMASK(3, 0)
-#define MT_TXWI_CTL_CHAN_CHECK_PKT	BIT(4)
-#define MT_TXWI_CTL_PIFS_REV		BIT(6)
-
-#define MT_TXWI_PKTID_PROBE             BIT(7)
-
 u32 mt76x0_mac_process_rx(struct mt76x0_dev *dev, struct sk_buff *skb,
 			u8 *data, void *rxi);
 struct mt76x02_tx_status
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index c3669735965b..7fbf379064f1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -187,8 +187,6 @@ struct mt76x0_wcid {
 	u8 tx_rate_nss;
 };
 
-struct mt76x0_rxwi;
-
 extern const struct ieee80211_ops mt76x0_ops;
 
 static inline bool is_mt7610e(struct mt76x0_dev *dev)
@@ -229,7 +227,7 @@ void mt76x0_agc_restore(struct mt76x0_dev *dev);
 int mt76x0_phy_set_channel(struct mt76x0_dev *dev,
 			    struct cfg80211_chan_def *chandef);
 void mt76x0_phy_recalibrate_after_assoc(struct mt76x0_dev *dev);
-int mt76x0_phy_get_rssi(struct mt76x0_dev *dev, struct mt76x0_rxwi *rxwi);
+int mt76x0_phy_get_rssi(struct mt76x0_dev *dev, struct mt76x02_rxwi *rxwi);
 void mt76x0_phy_con_cal_onoff(struct mt76x0_dev *dev,
 			       struct ieee80211_bss_conf *info);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 5da7bfbe907f..af30885b7e5e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -225,7 +225,7 @@ mt76x0_bbp_set_ctrlch(struct mt76x0_dev *dev, enum nl80211_chan_width width,
 	mt76_rmw_field(dev, MT_BBP(TXBE, 0), MT_BBP_TXBE_R0_CTRL_CHAN, ctrl);
 }
 
-int mt76x0_phy_get_rssi(struct mt76x0_dev *dev, struct mt76x0_rxwi *rxwi)
+int mt76x0_phy_get_rssi(struct mt76x0_dev *dev, struct mt76x02_rxwi *rxwi)
 {
 	s8 lna_gain, rssi_offset;
 	int val;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/trace.h b/drivers/net/wireless/mediatek/mt76/mt76x0/trace.h
index d31ba71b9d5b..36bbdd585163 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/trace.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/trace.h
@@ -178,11 +178,11 @@ DECLARE_EVENT_CLASS(dev_simple_evt,
 );
 
 TRACE_EVENT(mt76x0_rx,
-	TP_PROTO(struct mt76_dev *dev, struct mt76x0_rxwi *rxwi, u32 f),
+	TP_PROTO(struct mt76_dev *dev, struct mt76x02_rxwi *rxwi, u32 f),
 	TP_ARGS(dev, rxwi, f),
 	TP_STRUCT__entry(
 		DEV_ENTRY
-		__field_struct(struct mt76x0_rxwi, rxwi)
+		__field_struct(struct mt76x02_rxwi, rxwi)
 		__field(u32, fce_info)
 	),
 	TP_fast_assign(
@@ -197,11 +197,11 @@ TRACE_EVENT(mt76x0_rx,
 
 TRACE_EVENT(mt76x0_tx,
 	TP_PROTO(struct mt76_dev *dev, struct sk_buff *skb,
-		 struct mt76x02_sta *sta, struct mt76_txwi *h),
+		 struct mt76x02_sta *sta, struct mt76x02_txwi *h),
 	TP_ARGS(dev, skb, sta, h),
 	TP_STRUCT__entry(
 		DEV_ENTRY
-		__field_struct(struct mt76_txwi, h)
+		__field_struct(struct mt76x02_txwi, h)
 		__field(struct sk_buff *, skb)
 		__field(struct mt76x02_sta *, sta)
 	),
@@ -211,11 +211,11 @@ TRACE_EVENT(mt76x0_tx,
 		__entry->skb = skb;
 		__entry->sta = sta;
 	),
-	TP_printk(DEV_PR_FMT "skb:%p sta:%p  flg:%04hx rate_ctl:%04hx "
+	TP_printk(DEV_PR_FMT "skb:%p sta:%p  flg:%04hx rate:%04hx "
 		  "ack:%02hhx wcid:%02hhx len_ctl:%05hx", DEV_PR_ARG,
 		  __entry->skb, __entry->sta,
 		  le16_to_cpu(__entry->h.flags),
-		  le16_to_cpu(__entry->h.rate_ctl),
+		  le16_to_cpu(__entry->h.rate),
 		  __entry->h.ack_ctl, __entry->h.wcid,
 		  le16_to_cpu(__entry->h.len_ctl))
 );
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
index eeb298719329..c94b9cf4231d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
@@ -33,7 +33,7 @@ static void mt76x0_tx_skb_remove_dma_overhead(struct sk_buff *skb,
 {
 	int pkt_len = (unsigned long)info->status.status_driver_data[0];
 
-	skb_pull(skb, sizeof(struct mt76_txwi) + 4);
+	skb_pull(skb, sizeof(struct mt76x02_txwi) + 4);
 	if (ieee80211_get_hdrlen_from_skb(skb) % 4)
 		mt76x0_remove_hdr_pad(skb);
 
@@ -60,28 +60,28 @@ static int mt76x0_skb_rooms(struct mt76x0_dev *dev, struct sk_buff *skb)
 	int hdr_len = ieee80211_get_hdrlen_from_skb(skb);
 	u32 need_head;
 
-	need_head = sizeof(struct mt76_txwi) + 4;
+	need_head = sizeof(struct mt76x02_txwi) + 4;
 	if (hdr_len % 4)
 		need_head += 2;
 
 	return skb_cow(skb, need_head);
 }
 
-static struct mt76_txwi *
+static struct mt76x02_txwi *
 mt76x0_push_txwi(struct mt76x0_dev *dev, struct sk_buff *skb,
 		  struct ieee80211_sta *sta, struct mt76_wcid *wcid,
 		  int pkt_len)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_tx_rate *rate = &info->control.rates[0];
-	struct mt76_txwi *txwi;
+	struct mt76x02_txwi *txwi;
 	unsigned long flags;
 	u16 txwi_flags = 0;
 	u32 pkt_id;
 	u16 rate_ctl;
 	u8 nss;
 
-	txwi = (struct mt76_txwi *)skb_push(skb, sizeof(struct mt76_txwi));
+	txwi = (struct mt76x02_txwi *)skb_push(skb, sizeof(struct mt76x02_txwi));
 	memset(txwi, 0, sizeof(*txwi));
 
 	if (!wcid->tx_rate_set)
@@ -97,12 +97,12 @@ mt76x0_push_txwi(struct mt76x0_dev *dev, struct sk_buff *skb,
 	}
 	spin_unlock_irqrestore(&dev->mt76.lock, flags);
 
-	txwi->rate_ctl = cpu_to_le16(rate_ctl);
+	txwi->rate = cpu_to_le16(rate_ctl);
 
 	if (info->flags & IEEE80211_TX_CTL_LDPC)
-		txwi->rate_ctl |= cpu_to_le16(MT_RXWI_RATE_LDPC);
+		txwi->rate |= cpu_to_le16(MT_RXWI_RATE_LDPC);
 	if ((info->flags & IEEE80211_TX_CTL_STBC) && nss == 1)
-		txwi->rate_ctl |= cpu_to_le16(MT_RXWI_RATE_STBC);
+		txwi->rate |= cpu_to_le16(MT_RXWI_RATE_STBC);
 	if (nss > 1 && sta && sta->smps_mode == IEEE80211_SMPS_DYNAMIC)
 		txwi_flags |= MT_TXWI_FLAGS_MMPS;
 
@@ -151,7 +151,7 @@ void mt76x0_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 	struct ieee80211_sta *sta = control->sta;
 	struct mt76x02_sta *msta = NULL;
 	struct mt76_wcid *wcid = &dev->mt76.global_wcid;
-	struct mt76_txwi *txwi;
+	struct mt76x02_txwi *txwi;
 	int pkt_len = skb->len;
 	int hw_q = skb2q(skb);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index fc880ffe3d8b..498b2b293d20 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -104,6 +104,60 @@ struct mt76x02_sta {
 #define MT_RATE_INDEX_VHT_IDX		GENMASK(3, 0)
 #define MT_RATE_INDEX_VHT_NSS		GENMASK(5, 4)
 
+struct mt76x02_rxwi {
+	__le32 rxinfo;
+
+	__le32 ctl;
+
+	__le16 tid_sn;
+	__le16 rate;
+
+	u8 rssi[4];
+
+	__le32 bbp_rxinfo[4];
+};
+
+#define MT_TX_PWR_ADJ			GENMASK(3, 0)
+
+enum mt76x2_phy_bandwidth {
+	MT_PHY_BW_20,
+	MT_PHY_BW_40,
+	MT_PHY_BW_80,
+};
+
+#define MT_TXWI_FLAGS_FRAG		BIT(0)
+#define MT_TXWI_FLAGS_MMPS		BIT(1)
+#define MT_TXWI_FLAGS_CFACK		BIT(2)
+#define MT_TXWI_FLAGS_TS		BIT(3)
+#define MT_TXWI_FLAGS_AMPDU		BIT(4)
+#define MT_TXWI_FLAGS_MPDU_DENSITY	GENMASK(7, 5)
+#define MT_TXWI_FLAGS_TXOP		GENMASK(9, 8)
+#define MT_TXWI_FLAGS_NDPS		BIT(10)
+#define MT_TXWI_FLAGS_RTSBWSIG		BIT(11)
+#define MT_TXWI_FLAGS_NDP_BW		GENMASK(13, 12)
+#define MT_TXWI_FLAGS_SOUND		BIT(14)
+#define MT_TXWI_FLAGS_TX_RATE_LUT	BIT(15)
+
+#define MT_TXWI_ACK_CTL_REQ		BIT(0)
+#define MT_TXWI_ACK_CTL_NSEQ		BIT(1)
+#define MT_TXWI_ACK_CTL_BA_WINDOW	GENMASK(7, 2)
+
+#define MT_TXWI_PKTID_PROBE		BIT(7)
+
+struct mt76x02_txwi {
+	__le16 flags;
+	__le16 rate;
+	u8 ack_ctl;
+	u8 wcid;
+	__le16 len_ctl;
+	__le32 iv;
+	__le32 eiv;
+	u8 aid;
+	u8 txstream;
+	u8 ctl2;
+	u8 pktid;
+} __packed __aligned(4);
+
 static inline bool mt76x02_wait_for_mac(struct mt76_dev *dev)
 {
 	const u32 MAC_CSR0 = 0x1000;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
index 2db67f7a4bec..0f7f731ab285 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
@@ -30,7 +30,7 @@ void mt76x2_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 		return;
 	}
 
-	skb_pull(skb, sizeof(struct mt76x2_rxwi));
+	skb_pull(skb, sizeof(struct mt76x02_rxwi));
 	if (mt76x2_mac_process_rx(dev, skb, rxwi)) {
 		dev_kfree_skb(skb);
 		return;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c b/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
index 919dc3f36255..98ecc8b68723 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
@@ -106,8 +106,8 @@ int mt76x2_dma_init(struct mt76x2_dev *dev)
 	struct mt76_txwi_cache __maybe_unused *t;
 	struct mt76_queue *q;
 
-	BUILD_BUG_ON(sizeof(t->txwi) < sizeof(struct mt76x2_txwi));
-	BUILD_BUG_ON(sizeof(struct mt76x2_rxwi) > MT_RX_HEADROOM);
+	BUILD_BUG_ON(sizeof(t->txwi) < sizeof(struct mt76x02_txwi));
+	BUILD_BUG_ON(sizeof(struct mt76x02_rxwi) > MT_RX_HEADROOM);
 
 	mt76_dma_attach(&dev->mt76);
 
@@ -141,7 +141,7 @@ int mt76x2_dma_init(struct mt76x2_dev *dev)
 		return ret;
 
 	q = &dev->mt76.q_rx[MT_RXQ_MAIN];
-	q->buf_offset = MT_RX_HEADROOM - sizeof(struct mt76x2_rxwi);
+	q->buf_offset = MT_RX_HEADROOM - sizeof(struct mt76x02_rxwi);
 	ret = mt76x2_init_rx_queue(dev, q, 0, MT76x2_RX_RING_SIZE, MT_RX_BUF_SIZE);
 	if (ret)
 		return ret;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index e59af314712c..c6d5e7db6edb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -417,7 +417,7 @@ void mt76x2_cleanup(struct mt76x2_dev *dev)
 struct mt76x2_dev *mt76x2_alloc_device(struct device *pdev)
 {
 	static const struct mt76_driver_ops drv_ops = {
-		.txwi_size = sizeof(struct mt76x2_txwi),
+		.txwi_size = sizeof(struct mt76x02_txwi),
 		.update_survey = mt76x2_update_channel,
 		.tx_prepare_skb = mt76x2_tx_prepare_skb,
 		.tx_complete_skb = mt76x2_tx_complete_skb,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
index 71ab06050e23..0d37d0de0b84 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
@@ -64,7 +64,7 @@ mt76x2_mac_queue_txdone(struct mt76x2_dev *dev, struct sk_buff *skb,
 			void *txwi_ptr)
 {
 	struct mt76x2_tx_info *txi = mt76x2_skb_tx_info(skb);
-	struct mt76x2_txwi *txwi = txwi_ptr;
+	struct mt76x02_txwi *txwi = txwi_ptr;
 
 	mt76x2_mac_poll_tx_status(dev, false);
 
@@ -100,9 +100,9 @@ static int
 mt76_write_beacon(struct mt76x2_dev *dev, int offset, struct sk_buff *skb)
 {
 	int beacon_len = dev->beacon_offsets[1] - dev->beacon_offsets[0];
-	struct mt76x2_txwi txwi;
+	struct mt76x02_txwi txwi;
 
-	if (WARN_ON_ONCE(beacon_len < skb->len + sizeof(struct mt76x2_txwi)))
+	if (WARN_ON_ONCE(beacon_len < skb->len + sizeof(struct mt76x02_txwi)))
 		return -ENOSPC;
 
 	mt76x2_mac_write_txwi(dev, &txwi, skb, NULL, NULL, skb->len);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
index 62cb34f4f362..66a57294fcfc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
@@ -23,7 +23,6 @@
 struct mt76x2_dev;
 struct mt76x2_sta;
 struct mt76x02_vif;
-struct mt76x2_txwi;
 
 struct mt76x2_tx_info {
 	unsigned long jiffies;
@@ -34,60 +33,6 @@ struct mt76x2_tx_info {
 	u8 retry;
 };
 
-struct mt76x2_rxwi {
-	__le32 rxinfo;
-
-	__le32 ctl;
-
-	__le16 tid_sn;
-	__le16 rate;
-
-	u8 rssi[4];
-
-	__le32 bbp_rxinfo[4];
-};
-
-#define MT_TX_PWR_ADJ			GENMASK(3, 0)
-
-enum mt76x2_phy_bandwidth {
-	MT_PHY_BW_20,
-	MT_PHY_BW_40,
-	MT_PHY_BW_80,
-};
-
-#define MT_TXWI_FLAGS_FRAG		BIT(0)
-#define MT_TXWI_FLAGS_MMPS		BIT(1)
-#define MT_TXWI_FLAGS_CFACK		BIT(2)
-#define MT_TXWI_FLAGS_TS		BIT(3)
-#define MT_TXWI_FLAGS_AMPDU		BIT(4)
-#define MT_TXWI_FLAGS_MPDU_DENSITY	GENMASK(7, 5)
-#define MT_TXWI_FLAGS_TXOP		GENMASK(9, 8)
-#define MT_TXWI_FLAGS_NDPS		BIT(10)
-#define MT_TXWI_FLAGS_RTSBWSIG		BIT(11)
-#define MT_TXWI_FLAGS_NDP_BW		GENMASK(13, 12)
-#define MT_TXWI_FLAGS_SOUND		BIT(14)
-#define MT_TXWI_FLAGS_TX_RATE_LUT	BIT(15)
-
-#define MT_TXWI_ACK_CTL_REQ		BIT(0)
-#define MT_TXWI_ACK_CTL_NSEQ		BIT(1)
-#define MT_TXWI_ACK_CTL_BA_WINDOW	GENMASK(7, 2)
-
-#define MT_TXWI_PKTID_PROBE		BIT(7)
-
-struct mt76x2_txwi {
-	__le16 flags;
-	__le16 rate;
-	u8 ack_ctl;
-	u8 wcid;
-	__le16 len_ctl;
-	__le32 iv;
-	__le32 eiv;
-	u8 aid;
-	u8 txstream;
-	u8 ctl2;
-	u8 pktid;
-} __packed __aligned(4);
-
 static inline struct mt76x2_tx_info *
 mt76x2_skb_tx_info(struct sk_buff *skb)
 {
@@ -103,7 +48,7 @@ void mt76x2_mac_set_bssid(struct mt76x2_dev *dev, u8 idx, const u8 *addr);
 
 int mt76x2_mac_process_rx(struct mt76x2_dev *dev, struct sk_buff *skb,
 			  void *rxi);
-void mt76x2_mac_write_txwi(struct mt76x2_dev *dev, struct mt76x2_txwi *txwi,
+void mt76x2_mac_write_txwi(struct mt76x2_dev *dev, struct mt76x02_txwi *txwi,
 			   struct sk_buff *skb, struct mt76_wcid *wcid,
 			   struct ieee80211_sta *sta, int len);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
index 85671244fdf9..3cd99d4debb8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
@@ -229,7 +229,7 @@ void mt76x2_send_tx_status(struct mt76x2_dev *dev,
 }
 EXPORT_SYMBOL_GPL(mt76x2_send_tx_status);
 
-void mt76x2_mac_write_txwi(struct mt76x2_dev *dev, struct mt76x2_txwi *txwi,
+void mt76x2_mac_write_txwi(struct mt76x2_dev *dev, struct mt76x02_txwi *txwi,
 			   struct sk_buff *skb, struct mt76_wcid *wcid,
 			   struct ieee80211_sta *sta, int len)
 {
@@ -443,7 +443,7 @@ int mt76x2_mac_process_rx(struct mt76x2_dev *dev, struct sk_buff *skb,
 			  void *rxi)
 {
 	struct mt76_rx_status *status = (struct mt76_rx_status *) skb->cb;
-	struct mt76x2_rxwi *rxwi = rxi;
+	struct mt76x02_rxwi *rxwi = rxi;
 	struct mt76x02_sta *sta;
 	u32 rxinfo = le32_to_cpu(rxwi->rxinfo);
 	u32 ctl = le32_to_cpu(rxwi->ctl);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c
index d5dc4eb15818..d983b3e1a4e4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c
@@ -21,7 +21,7 @@ static void mt76x2u_remove_dma_hdr(struct sk_buff *skb)
 {
 	int hdr_len;
 
-	skb_pull(skb, sizeof(struct mt76x2_txwi) + MT_DMA_HDR_LEN);
+	skb_pull(skb, sizeof(struct mt76x02_txwi) + MT_DMA_HDR_LEN);
 	hdr_len = ieee80211_get_hdrlen_from_skb(skb);
 	if (hdr_len % 4) {
 		memmove(skb->data + 2, skb->data, hdr_len);
@@ -35,7 +35,7 @@ mt76x2u_check_skb_rooms(struct sk_buff *skb)
 	int hdr_len = ieee80211_get_hdrlen_from_skb(skb);
 	u32 need_head;
 
-	need_head = sizeof(struct mt76x2_txwi) + MT_DMA_HDR_LEN;
+	need_head = sizeof(struct mt76x02_txwi) + MT_DMA_HDR_LEN;
 	if (hdr_len % 4)
 		need_head += 2;
 	return skb_cow(skb, need_head);
@@ -82,7 +82,7 @@ int mt76x2u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 			   u32 *tx_info)
 {
 	struct mt76x2_dev *dev = container_of(mdev, struct mt76x2_dev, mt76);
-	struct mt76x2_txwi *txwi;
+	struct mt76x02_txwi *txwi;
 	int err, len = skb->len;
 	int *hwq_ptr = (int *) data;
 
@@ -92,7 +92,7 @@ int mt76x2u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 
 	mt76x2_insert_hdr_pad(skb);
 
-	txwi = skb_push(skb, sizeof(struct mt76x2_txwi));
+	txwi = skb_push(skb, sizeof(struct mt76x02_txwi));
 	mt76x2_mac_write_txwi(dev, txwi, skb, wcid, sta, len);
 
 	return mt76x2u_set_txinfo(skb, wcid, q2ep(*hwq_ptr));
-- 
2.7.5
