Return-Path: <SRS0=+bZT=NF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D080FECDE46
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 16:55:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E6C720848
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 16:55:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="d3yTRBIp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E6C720848
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbeJZB3V (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Oct 2018 21:29:21 -0400
Received: from nbd.name ([46.4.11.11]:33218 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727644AbeJZB3U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Oct 2018 21:29:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=A0GgCwYESEs/OroFdpYijrNDN7hzkEFc3Hhs475pTTQ=; b=d3yTRBIpkJI92PzUz7ybCmKw0P
        YaGMzUs8cqW+J6olCpf9iCH0dgiy7jm+/0PzoHzuwXq7lcgQRF4qygj/OH0r+UFCVtkDoYMp/s0x3
        dRjr9VC6AjD1PkCX7NE8FXZHMP9Z76GK76Db3xZNunoFdpbdKa8TlrGrYfC7OTsWHit8=;
Received: by maeck.local (Postfix, from userid 501)
        id 5E5B1410C697; Thu, 25 Oct 2018 18:55:41 +0200 (CEST)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com
Subject: [PATCH 4/4] mt76: add support for reporting tx status with skb
Date:   Thu, 25 Oct 2018 18:55:41 +0200
Message-Id: <20181025165541.84815-4-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20181025165541.84815-1-nbd@nbd.name>
References: <20181025165541.84815-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

MT76x2/MT76x0 has somewhat unreliable tx status reporting, and for that
reason the driver currently does not report per-skb tx ack status at all.
This breaks things like client idle polling, which relies on the tx ack
status of a transmitted nullfunc frame.

This patch adds code to report skb-attached tx status if requested by
mac80211 or the rate control module. Since tx status is polled from a
simple FIFO register, the code needs to account for the possibility of
tx status events getting lost.

The code keeps a list of skbs for which tx status is required and passes
them to mac80211 once tx status has been filled in and the DMA queue is
done with it.
If a tx status event is not received after one second, the status rates
are cleared, and a succesful ACK is indicated to avoid spurious disassoc
during assoc or client polling.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/dma.c      |   1 +
 drivers/net/wireless/mediatek/mt76/mac80211.c |   3 +
 drivers/net/wireless/mediatek/mt76/mt76.h     |  48 ++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |   1 -
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  |  71 +++++------
 .../net/wireless/mediatek/mt76/mt76x02_mac.h  |  19 ---
 .../net/wireless/mediatek/mt76/mt76x02_txrx.c |  25 ++--
 .../wireless/mediatek/mt76/mt76x02_usb_core.c |  42 +++----
 .../net/wireless/mediatek/mt76/mt76x02_util.c |   1 +
 drivers/net/wireless/mediatek/mt76/tx.c       | 111 ++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/usb.c      |   1 +
 11 files changed, 228 insertions(+), 95 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index f7fbd7016403..2d7bd26875c6 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -258,6 +258,7 @@ int mt76_dma_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 		return -ENOMEM;
 	}
 
+	skb->prev = skb->next = NULL;
 	dma_sync_single_for_cpu(dev->dev, t->dma_addr, sizeof(t->txwi),
 				DMA_TO_DEVICE);
 	ret = dev->drv->tx_prepare_skb(dev, &t->txwi, skb, q, wcid, sta,
diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 2a699e8b79bf..85e05a825b5d 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -285,6 +285,7 @@ mt76_alloc_device(unsigned int size, const struct ieee80211_ops *ops)
 	spin_lock_init(&dev->cc_lock);
 	mutex_init(&dev->mutex);
 	init_waitqueue_head(&dev->tx_wait);
+	skb_queue_head_init(&dev->status_list);
 
 	return dev;
 }
@@ -326,6 +327,7 @@ int mt76_register_device(struct mt76_dev *dev, bool vht,
 	ieee80211_hw_set(hw, TX_FRAG_LIST);
 	ieee80211_hw_set(hw, MFP_CAPABLE);
 	ieee80211_hw_set(hw, AP_LINK_PS);
+	ieee80211_hw_set(hw, REPORTS_TX_ACK_STATUS);
 
 	wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 
@@ -357,6 +359,7 @@ void mt76_unregister_device(struct mt76_dev *dev)
 {
 	struct ieee80211_hw *hw = dev->hw;
 
+	mt76_tx_status_flush(dev, NULL);
 	ieee80211_unregister_hw(hw);
 	mt76_tx_free(dev);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 53ddc4fa5884..94ab00b549af 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -195,6 +195,8 @@ struct mt76_wcid {
 	u8 tx_rate_nss;
 	s8 max_txpwr_adj;
 	bool sw_iv;
+
+	u8 packet_id;
 };
 
 struct mt76_txq {
@@ -233,6 +235,22 @@ struct mt76_rx_tid {
 	struct sk_buff *reorder_buf[];
 };
 
+#define MT_TX_CB_DMA_DONE		BIT(0)
+#define MT_TX_CB_TXS_DONE		BIT(1)
+#define MT_TX_CB_TXS_FAILED		BIT(2)
+
+#define MT_PACKET_ID_MASK		GENMASK(7, 0)
+#define MT_PACKET_ID_NO_ACK		MT_PACKET_ID_MASK
+
+#define MT_TX_STATUS_SKB_TIMEOUT	HZ
+
+struct mt76_tx_cb {
+	unsigned long jiffies;
+	u8 wcid;
+	u8 pktid;
+	u8 flags;
+};
+
 enum {
 	MT76_STATE_INITIALIZED,
 	MT76_STATE_RUNNING,
@@ -400,6 +418,7 @@ struct mt76_dev {
 	const struct mt76_queue_ops *queue_ops;
 
 	wait_queue_head_t tx_wait;
+	struct sk_buff_head status_list;
 
 	unsigned long wcid_mask[MT76_N_WCIDS / BITS_PER_LONG];
 
@@ -594,6 +613,13 @@ wcid_to_sta(struct mt76_wcid *wcid)
 	return container_of(ptr, struct ieee80211_sta, drv_priv);
 }
 
+static inline struct mt76_tx_cb *mt76_tx_skb_cb(struct sk_buff *skb)
+{
+	BUILD_BUG_ON(sizeof(struct mt76_tx_cb) >
+		     sizeof(IEEE80211_SKB_CB(skb)->status.status_driver_data));
+	return ((void *) IEEE80211_SKB_CB(skb)->status.status_driver_data);
+}
+
 int mt76_dma_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 			  struct sk_buff *skb, struct mt76_wcid *wcid,
 			  struct ieee80211_sta *sta);
@@ -624,6 +650,28 @@ void mt76_rx_aggr_stop(struct mt76_dev *dev, struct mt76_wcid *wcid, u8 tid);
 
 void mt76_wcid_key_setup(struct mt76_dev *dev, struct mt76_wcid *wcid,
 			 struct ieee80211_key_conf *key);
+int mt76_tx_status_skb_add(struct mt76_dev *dev, struct mt76_wcid *wcid,
+			   struct sk_buff *skb);
+struct sk_buff *mt76_tx_status_skb_get(struct mt76_dev *dev,
+				       struct mt76_wcid *wcid, int pktid);
+void mt76_tx_status_skb_done(struct mt76_dev *dev, struct sk_buff *skb);
+void mt76_tx_complete_skb(struct mt76_dev *dev, struct sk_buff *skb);
+
+static inline void
+mt76_tx_status_check(struct mt76_dev *dev)
+{
+	spin_lock_bh(&dev->status_list.lock);
+	mt76_tx_status_skb_get(dev, NULL, 0);
+	spin_unlock_bh(&dev->status_list.lock);
+}
+
+static inline void
+mt76_tx_status_flush(struct mt76_dev *dev, struct mt76_wcid *wcid)
+{
+	spin_lock_bh(&dev->status_list.lock);
+	mt76_tx_status_skb_get(dev, wcid, -1);
+	spin_unlock_bh(&dev->status_list.lock);
+}
 
 struct ieee80211_sta *mt76_rx_convert(struct sk_buff *skb);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index d599b7dddac7..19489a72fc2b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -139,7 +139,6 @@ void mt76x02_set_coverage_class(struct ieee80211_hw *hw,
 int mt76x02_set_rts_threshold(struct ieee80211_hw *hw, u32 val);
 int mt76x02_insert_hdr_pad(struct sk_buff *skb);
 void mt76x02_remove_hdr_pad(struct sk_buff *skb, int len);
-void mt76x02_tx_complete(struct mt76_dev *dev, struct sk_buff *skb);
 bool mt76x02_tx_status_data(struct mt76_dev *mdev, u8 *update);
 void mt76x02_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 			  struct sk_buff *skb);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index ad8df680c6a5..b78dfecc7956 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -324,8 +324,6 @@ void mt76x02_mac_write_txwi(struct mt76x02_dev *dev, struct mt76x02_txwi *txwi,
 	else
 		txwi->wcid = 0xff;
 
-	txwi->pktid = 1;
-
 	if (wcid && wcid->sw_iv && key) {
 		u64 pn = atomic64_inc_return(&key->tx_pn);
 		ccmp_pn[0] = pn;
@@ -371,8 +369,6 @@ void mt76x02_mac_write_txwi(struct mt76x02_dev *dev, struct mt76x02_txwi *txwi,
 		txwi->ack_ctl |= MT_TXWI_ACK_CTL_REQ;
 	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ)
 		txwi->ack_ctl |= MT_TXWI_ACK_CTL_NSEQ;
-	if (info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE)
-		txwi->pktid |= MT_TXWI_PKTID_PROBE;
 	if ((info->flags & IEEE80211_TX_CTL_AMPDU) && sta) {
 		u8 ba_size = IEEE80211_MIN_AMPDU_BUF;
 
@@ -425,9 +421,6 @@ mt76x02_mac_fill_tx_status(struct mt76x02_dev *dev,
 	info->status.ampdu_len = n_frames;
 	info->status.ampdu_ack_len = st->success ? n_frames : 0;
 
-	if (st->pktid & MT_TXWI_PKTID_PROBE)
-		info->flags |= IEEE80211_TX_CTL_RATE_CTRL_PROBE;
-
 	if (st->aggr)
 		info->flags |= IEEE80211_TX_CTL_AMPDU |
 			       IEEE80211_TX_STAT_AMPDU;
@@ -442,11 +435,19 @@ void mt76x02_send_tx_status(struct mt76x02_dev *dev,
 			    struct mt76x02_tx_status *stat, u8 *update)
 {
 	struct ieee80211_tx_info info = {};
-	struct ieee80211_sta *sta = NULL;
+	struct ieee80211_tx_status status = {
+		.info = &info
+	};
 	struct mt76_wcid *wcid = NULL;
 	struct mt76x02_sta *msta = NULL;
+	struct mt76_dev *mdev = &dev->mt76;
+
+	if (stat->pktid == MT_PACKET_ID_NO_ACK)
+		return;
 
 	rcu_read_lock();
+	spin_lock_bh(&mdev->status_list.lock);
+
 	if (stat->wcid < ARRAY_SIZE(dev->mt76.wcid))
 		wcid = rcu_dereference(dev->mt76.wcid[stat->wcid]);
 
@@ -454,11 +455,16 @@ void mt76x02_send_tx_status(struct mt76x02_dev *dev,
 		void *priv;
 
 		priv = msta = container_of(wcid, struct mt76x02_sta, wcid);
-		sta = container_of(priv, struct ieee80211_sta,
-				   drv_priv);
+		status.sta = container_of(priv, struct ieee80211_sta,
+					  drv_priv);
+		if (stat->pktid)
+			status.skb = mt76_tx_status_skb_get(mdev, wcid,
+							    stat->pktid);
+		if (status.skb)
+			status.info = IEEE80211_SKB_CB(status.skb);
 	}
 
-	if (msta && stat->aggr) {
+	if (msta && stat->aggr && !status.skb) {
 		u32 stat_val, stat_cache;
 
 		stat_val = stat->rate;
@@ -472,20 +478,24 @@ void mt76x02_send_tx_status(struct mt76x02_dev *dev,
 			goto out;
 		}
 
-		mt76x02_mac_fill_tx_status(dev, &info, &msta->status,
+		mt76x02_mac_fill_tx_status(dev, status.info, &msta->status,
 					   msta->n_frames);
 
 		msta->status = *stat;
 		msta->n_frames = 1;
 		*update = 0;
 	} else {
-		mt76x02_mac_fill_tx_status(dev, &info, stat, 1);
+		mt76x02_mac_fill_tx_status(dev, status.info, stat, 1);
 		*update = 1;
 	}
 
-	ieee80211_tx_status_noskb(dev->mt76.hw, sta, &info);
+	if (status.skb)
+		mt76_tx_status_skb_done(mdev, status.skb);
+	else
+		ieee80211_tx_status_ext(mt76_hw(dev), &status);
 
 out:
+	spin_unlock_bh(&mdev->status_list.lock);
 	rcu_read_unlock();
 }
 
@@ -707,32 +717,23 @@ void mt76x02_mac_poll_tx_status(struct mt76x02_dev *dev, bool irq)
 	}
 }
 
-static void
-mt76x02_mac_queue_txdone(struct mt76x02_dev *dev, struct sk_buff *skb,
-			 void *txwi_ptr)
-{
-	struct mt76x02_tx_info *txi = mt76x02_skb_tx_info(skb);
-	struct mt76x02_txwi *txwi = txwi_ptr;
-
-	mt76x02_mac_poll_tx_status(dev, false);
-
-	txi->tries = 0;
-	txi->jiffies = jiffies;
-	txi->wcid = txwi->wcid;
-	txi->pktid = txwi->pktid;
-	trace_mac_txdone_add(dev, txwi->wcid, txwi->pktid);
-	mt76x02_tx_complete(&dev->mt76, skb);
-}
-
 void mt76x02_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
 			     struct mt76_queue_entry *e, bool flush)
 {
 	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
+	struct mt76x02_txwi *txwi;
 
-	if (e->txwi)
-		mt76x02_mac_queue_txdone(dev, e->skb, &e->txwi->txwi);
-	else
+	if (!e->txwi) {
 		dev_kfree_skb_any(e->skb);
+		return;
+	}
+
+	mt76x02_mac_poll_tx_status(dev, false);
+
+	txwi = (struct mt76x02_txwi *) &e->txwi->txwi;
+	trace_mac_txdone_add(dev, txwi->wcid, txwi->pktid);
+
+	mt76_tx_complete_skb(mdev, e->skb);
 }
 EXPORT_SYMBOL_GPL(mt76x02_tx_complete_skb);
 
@@ -817,6 +818,8 @@ void mt76x02_mac_work(struct work_struct *work)
 	if (!dev->beacon_mask)
 		mt76x02_check_mac_err(dev);
 
+	mt76_tx_status_check(&dev->mt76);
+
 	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mac_work,
 				     MT_CALIBRATE_INTERVAL);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index e2c47ca18d85..b076c4305585 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -42,15 +42,6 @@ struct mt76x02_vif {
 	struct mt76_wcid group_wcid;
 };
 
-struct mt76x02_tx_info {
-	unsigned long jiffies;
-	u8 tries;
-
-	u8 wcid;
-	u8 pktid;
-	u8 retry;
-};
-
 DECLARE_EWMA(signal, 10, 8);
 
 struct mt76x02_sta {
@@ -153,8 +144,6 @@ enum mt76x2_phy_bandwidth {
 #define MT_TXWI_ACK_CTL_NSEQ		BIT(1)
 #define MT_TXWI_ACK_CTL_BA_WINDOW	GENMASK(7, 2)
 
-#define MT_TXWI_PKTID_PROBE		BIT(7)
-
 struct mt76x02_txwi {
 	__le16 flags;
 	__le16 rate;
@@ -190,14 +179,6 @@ static inline bool mt76x02_wait_for_mac(struct mt76_dev *dev)
 	return false;
 }
 
-static inline struct mt76x02_tx_info *
-mt76x02_skb_tx_info(struct sk_buff *skb)
-{
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-
-	return (void *)info->status.status_driver_data;
-}
-
 void mt76x02_txq_init(struct mt76x02_dev *dev, struct ieee80211_txq *txq);
 
 void mt76x02_mac_set_short_preamble(struct mt76x02_dev *dev, bool enable);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
index c008e08602f3..4598cb2cc3ff 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
@@ -140,21 +140,6 @@ void mt76x02_tx_set_txpwr_auto(struct mt76x02_dev *dev, s8 txpwr)
 }
 EXPORT_SYMBOL_GPL(mt76x02_tx_set_txpwr_auto);
 
-void mt76x02_tx_complete(struct mt76_dev *dev, struct sk_buff *skb)
-{
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-
-	if (info->flags & IEEE80211_TX_CTL_AMPDU) {
-		ieee80211_free_txskb(dev->hw, skb);
-	} else {
-		ieee80211_tx_info_clear_status(info);
-		info->status.rates[0].idx = -1;
-		info->flags |= IEEE80211_TX_STAT_ACK;
-		ieee80211_tx_status(dev->hw, skb);
-	}
-}
-EXPORT_SYMBOL_GPL(mt76x02_tx_complete);
-
 bool mt76x02_tx_status_data(struct mt76_dev *mdev, u8 *update)
 {
 	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
@@ -169,14 +154,15 @@ bool mt76x02_tx_status_data(struct mt76_dev *mdev, u8 *update)
 }
 EXPORT_SYMBOL_GPL(mt76x02_tx_status_data);
 
-int mt76x02_tx_prepare_skb(struct mt76_dev *mdev, void *txwi,
+int mt76x02_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 			   struct sk_buff *skb, struct mt76_queue *q,
 			   struct mt76_wcid *wcid, struct ieee80211_sta *sta,
 			   u32 *tx_info)
 {
 	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct mt76x02_txwi *txwi = txwi_ptr;
 	int qsel = MT_QSEL_EDCA;
+	int pid;
 	int ret;
 
 	if (q == &dev->mt76.q_tx[MT_TXQ_PSD] && wcid && wcid->idx < 128)
@@ -184,11 +170,14 @@ int mt76x02_tx_prepare_skb(struct mt76_dev *mdev, void *txwi,
 
 	mt76x02_mac_write_txwi(dev, txwi, skb, wcid, sta, skb->len);
 
+	pid = mt76_tx_status_skb_add(mdev, wcid, skb);
+	txwi->pktid = pid;
+
 	ret = mt76x02_insert_hdr_pad(skb);
 	if (ret < 0)
 		return ret;
 
-	if (info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE)
+	if (pid && pid != MT_PACKET_ID_NO_ACK)
 		qsel = MT_QSEL_MGMT;
 
 	*tx_info = FIELD_PREP(MT_TXD_INFO_QSEL, qsel) |
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
index dc2226c722dd..81970cf777c0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
@@ -30,7 +30,7 @@ void mt76x02u_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
 			      struct mt76_queue_entry *e, bool flush)
 {
 	mt76x02u_remove_dma_hdr(e->skb);
-	mt76x02_tx_complete(mdev, e->skb);
+	mt76_tx_complete_skb(mdev, e->skb);
 }
 EXPORT_SYMBOL_GPL(mt76x02u_tx_complete_skb);
 
@@ -67,27 +67,6 @@ int mt76x02u_skb_dma_info(struct sk_buff *skb, int port, u32 flags)
 	return 0;
 }
 
-static int
-mt76x02u_set_txinfo(struct sk_buff *skb, struct mt76_wcid *wcid, u8 ep)
-{
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	enum mt76_qsel qsel;
-	u32 flags;
-
-	if ((info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE) ||
-	    ep == MT_EP_OUT_HCCA)
-		qsel = MT_QSEL_MGMT;
-	else
-		qsel = MT_QSEL_EDCA;
-
-	flags = FIELD_PREP(MT_TXD_INFO_QSEL, qsel) |
-		MT_TXD_INFO_80211;
-	if (!wcid || wcid->hw_key_idx == 0xff || wcid->sw_iv)
-		flags |= MT_TXD_INFO_WIV;
-
-	return mt76x02u_skb_dma_info(skb, WLAN_PORT, flags);
-}
-
 int mt76x02u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 			    struct sk_buff *skb, struct mt76_queue *q,
 			    struct mt76_wcid *wcid, struct ieee80211_sta *sta,
@@ -95,13 +74,30 @@ int mt76x02u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 {
 	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
 	struct mt76x02_txwi *txwi;
+	enum mt76_qsel qsel;
 	int len = skb->len;
+	u32 flags;
+	int pid;
 
 	mt76x02_insert_hdr_pad(skb);
 
 	txwi = skb_push(skb, sizeof(struct mt76x02_txwi));
 	mt76x02_mac_write_txwi(dev, txwi, skb, wcid, sta, len);
 
-	return mt76x02u_set_txinfo(skb, wcid, q2ep(q->hw_idx));
+	pid = mt76_tx_status_skb_add(mdev, wcid, skb);
+	txwi->pktid = pid;
+
+	if ((pid && pid != MT_PACKET_ID_NO_ACK) ||
+	    q2ep(q->hw_idx) == MT_EP_OUT_HCCA)
+		qsel = MT_QSEL_MGMT;
+	else
+		qsel = MT_QSEL_EDCA;
+
+	flags = FIELD_PREP(MT_TXD_INFO_QSEL, qsel) |
+		MT_TXD_INFO_80211;
+	if (!wcid || wcid->hw_key_idx == 0xff || wcid->sw_iv)
+		flags |= MT_TXD_INFO_WIV;
+
+	return mt76x02u_skb_dma_info(skb, WLAN_PORT, flags);
 }
 EXPORT_SYMBOL_GPL(mt76x02u_tx_prepare_skb);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index c0f923942edc..adfc46419b6b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -215,6 +215,7 @@ int mt76x02_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	int i;
 
 	mutex_lock(&dev->mt76.mutex);
+	mt76_tx_status_flush(&dev->mt76, &msta->wcid);
 	rcu_assign_pointer(dev->mt76.wcid[idx], NULL);
 	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
 		mt76_txq_remove(&dev->mt76, sta->txq[i]);
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 7cbce03aa65b..cdd0af35d546 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -103,6 +103,117 @@ mt76_check_agg_ssn(struct mt76_txq *mtxq, struct sk_buff *skb)
 	mtxq->agg_ssn = le16_to_cpu(hdr->seq_ctrl) + 0x10;
 }
 
+static void
+__mt76_tx_status_skb_done(struct mt76_dev *dev, struct sk_buff *skb, u8 flags)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct mt76_tx_cb *cb = mt76_tx_skb_cb(skb);
+	u8 done = MT_TX_CB_DMA_DONE | MT_TX_CB_TXS_DONE;
+
+	flags |= cb->flags;
+	cb->flags = flags;
+
+	if ((flags & done) != done)
+		return;
+
+	__skb_unlink(skb, &dev->status_list);
+
+	/* Tx status can be unreliable. if it fails, mark the frame as ACKed */
+	if (flags & MT_TX_CB_TXS_FAILED) {
+		ieee80211_tx_info_clear_status(info);
+		info->status.rates[0].idx = -1;
+		info->flags |= IEEE80211_TX_STAT_ACK;
+	}
+
+	ieee80211_tx_status(dev->hw, skb);
+}
+
+void
+mt76_tx_status_skb_done(struct mt76_dev *dev, struct sk_buff *skb)
+{
+	__mt76_tx_status_skb_done(dev, skb, MT_TX_CB_TXS_DONE);
+}
+EXPORT_SYMBOL_GPL(mt76_tx_status_skb_done);
+
+int
+mt76_tx_status_skb_add(struct mt76_dev *dev, struct mt76_wcid *wcid,
+		       struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct mt76_tx_cb *cb = mt76_tx_skb_cb(skb);
+	int pid;
+
+	if (!wcid || !wcid->sta)
+		return 0;
+
+	if (info->flags & IEEE80211_TX_CTL_NO_ACK)
+		return MT_PACKET_ID_NO_ACK;
+
+	if (!(info->flags & (IEEE80211_TX_CTL_REQ_TX_STATUS |
+			     IEEE80211_TX_CTL_RATE_CTRL_PROBE)))
+		return 0;
+
+	spin_lock_bh(&dev->status_list.lock);
+
+	memset(cb, 0, sizeof(*cb));
+	wcid->packet_id = (wcid->packet_id + 1) & MT_PACKET_ID_MASK;
+	if (!wcid->packet_id || wcid->packet_id == MT_PACKET_ID_NO_ACK)
+		wcid->packet_id = 1;
+
+	pid = wcid->packet_id;
+	cb->wcid = wcid->idx;
+	cb->pktid = pid;
+	cb->jiffies = jiffies;
+
+	__skb_queue_tail(&dev->status_list, skb);
+	spin_unlock_bh(&dev->status_list.lock);
+
+	return pid;
+}
+EXPORT_SYMBOL_GPL(mt76_tx_status_skb_add);
+
+struct sk_buff *
+mt76_tx_status_skb_get(struct mt76_dev *dev, struct mt76_wcid *wcid, int pktid)
+{
+	struct sk_buff *skb, *tmp;
+
+	if (pktid == MT_PACKET_ID_NO_ACK)
+		return NULL;
+
+	skb_queue_walk_safe(&dev->status_list, skb, tmp) {
+		struct mt76_tx_cb *cb = mt76_tx_skb_cb(skb);
+
+		if (wcid && cb->wcid != wcid->idx)
+			continue;
+
+		if (cb->pktid == pktid)
+			return skb;
+
+		if (!pktid &&
+		    !time_after(jiffies, cb->jiffies + MT_TX_STATUS_SKB_TIMEOUT))
+			continue;
+
+		__mt76_tx_status_skb_done(dev, skb, MT_TX_CB_TXS_FAILED |
+						    MT_TX_CB_TXS_DONE);
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(mt76_tx_status_skb_get);
+
+void mt76_tx_complete_skb(struct mt76_dev *dev, struct sk_buff *skb)
+{
+	if (!skb->prev) {
+		ieee80211_free_txskb(dev->hw, skb);
+		return;
+	}
+
+	spin_lock_bh(&dev->status_list.lock);
+	__mt76_tx_status_skb_done(dev, skb, MT_TX_CB_DMA_DONE);
+	spin_unlock_bh(&dev->status_list.lock);
+}
+EXPORT_SYMBOL_GPL(mt76_tx_complete_skb);
+
 void
 mt76_tx(struct mt76_dev *dev, struct ieee80211_sta *sta,
 	struct mt76_wcid *wcid, struct sk_buff *skb)
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 24d41288ea59..b061263453d4 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -700,6 +700,7 @@ mt76u_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 	if (q->queued == q->ndesc)
 		return -ENOSPC;
 
+	skb->prev = skb->next = NULL;
 	err = dev->drv->tx_prepare_skb(dev, NULL, skb, q, wcid, sta, NULL);
 	if (err < 0)
 		return err;
-- 
2.17.0

