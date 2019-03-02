Return-Path: <SRS0=UNZO=RF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DCA7C43381
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 13:48:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5012C20879
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 13:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551534480;
	bh=iqGEt3M9mO0PygzkDgp9Ot8bwDCcbYROZgAfdnFOIog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=BaAh5izg5zAkt6u1TDOHRZGJv7QkHKClPCI5APbQXy4PBnbyBLd80rpCc7MWy2tC0
	 fP33hmL0PkLp+1rk1lRBDT0KQLq8eYzQ7vCgKKlqr/kQMa0xyKSv0W+IvTjsNiGzJl
	 bA51+5Zbp16NeWVB4lX9DrKtrCuVqtONZLy3Ei7k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726886AbfCBNr5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 2 Mar 2019 08:47:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:58274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726430AbfCBNrz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Mar 2019 08:47:55 -0500
Received: from lore-desk.lan (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D79FA20863;
        Sat,  2 Mar 2019 13:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551534474;
        bh=iqGEt3M9mO0PygzkDgp9Ot8bwDCcbYROZgAfdnFOIog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xas3lOScZmSlI2pxrflqLquvxTl02Z3Xbx/KPaFqDY95hVHbGj/5fsSCGIBWVlcMT
         zXLMF1JwLM71FJdSU6wcfxY2pyd4eTPBLbKDKwlR1jEUgFVsE9biDIw3Qbi/tOiGd1
         QNlLsb8QXwmKkkG50gI/MlT+ku9pLy7shIEn9kWo=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com, roychl666@gmail.com,
        ryder.lee@mediatek.com
Subject: [PATCH 1/5] mt76: remove mt76_queue dependency from tx_queue_skb function pointer
Date:   Sat,  2 Mar 2019 14:47:38 +0100
Message-Id: <5596c95d53765ff10c1c1d1dd3f6d81bebb47f69.1551533068.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1551533068.git.lorenzo@kernel.org>
References: <cover.1551533068.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove mt76_queue dependency from tx_queue_skb function pointer and
rely on mt76_tx_qid instead. This is a preliminary patch to introduce
mt76_sw_queue support

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c           |  3 ++-
 drivers/net/wireless/mediatek/mt76/mt76.h          |  4 ++--
 drivers/net/wireless/mediatek/mt76/mt7603/beacon.c |  6 +++---
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  |  4 ++--
 drivers/net/wireless/mediatek/mt76/tx.c            | 10 +++++-----
 drivers/net/wireless/mediatek/mt76/usb.c           |  3 ++-
 6 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 4e2dfb0f20c3..b9a43183d5d9 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -278,10 +278,11 @@ mt76_dma_tx_queue_skb_raw(struct mt76_dev *dev, enum mt76_txq_id qid,
 	return 0;
 }
 
-int mt76_dma_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
+int mt76_dma_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
 			  struct sk_buff *skb, struct mt76_wcid *wcid,
 			  struct ieee80211_sta *sta)
 {
+	struct mt76_queue *q = &dev->q_tx[qid];
 	struct mt76_queue_entry e;
 	struct mt76_txwi_cache *t;
 	struct mt76_queue_buf buf[32];
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 477027bb9aaf..0eaa05007f6d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -158,7 +158,7 @@ struct mt76_queue_ops {
 		       struct mt76_queue_buf *buf, int nbufs, u32 info,
 		       struct sk_buff *skb, void *txwi);
 
-	int (*tx_queue_skb)(struct mt76_dev *dev, struct mt76_queue *q,
+	int (*tx_queue_skb)(struct mt76_dev *dev, enum mt76_txq_id qid,
 			    struct sk_buff *skb, struct mt76_wcid *wcid,
 			    struct ieee80211_sta *sta);
 
@@ -647,7 +647,7 @@ static inline struct mt76_tx_cb *mt76_tx_skb_cb(struct sk_buff *skb)
 	return ((void *) IEEE80211_SKB_CB(skb)->status.status_driver_data);
 }
 
-int mt76_dma_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
+int mt76_dma_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
 			  struct sk_buff *skb, struct mt76_wcid *wcid,
 			  struct ieee80211_sta *sta);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c b/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
index afcd86f735b4..ae41c1ba6e9b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
@@ -23,7 +23,7 @@ mt7603_update_beacon_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
 	if (!skb)
 		return;
 
-	mt76_dma_tx_queue_skb(&dev->mt76, &dev->mt76.q_tx[MT_TXQ_BEACON], skb,
+	mt76_dma_tx_queue_skb(&dev->mt76, MT_TXQ_BEACON, skb,
 			      &mvif->sta.wcid, NULL);
 
 	spin_lock_bh(&dev->ps_lock);
@@ -118,8 +118,8 @@ void mt7603_pre_tbtt_tasklet(unsigned long arg)
 		struct ieee80211_vif *vif = info->control.vif;
 		struct mt7603_vif *mvif = (struct mt7603_vif *)vif->drv_priv;
 
-		mt76_dma_tx_queue_skb(&dev->mt76, q, skb, &mvif->sta.wcid,
-				      NULL);
+		mt76_dma_tx_queue_skb(&dev->mt76, MT_TXQ_CAB, skb,
+				      &mvif->sta.wcid, NULL);
 	}
 	mt76_queue_kick(dev, q);
 	spin_unlock_bh(&q->lock);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index 6a34a6afcfe4..910277e55480 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -146,8 +146,8 @@ static void mt76x02_pre_tbtt_tasklet(unsigned long arg)
 		struct ieee80211_vif *vif = info->control.vif;
 		struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
 
-		mt76_dma_tx_queue_skb(&dev->mt76, q, skb, &mvif->group_wcid,
-				      NULL);
+		mt76_dma_tx_queue_skb(&dev->mt76, MT_TXQ_PSD, skb,
+				      &mvif->group_wcid, NULL);
 	}
 	spin_unlock_bh(&q->lock);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index fc7dffe066be..5c94cffb53b7 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -286,7 +286,7 @@ mt76_tx(struct mt76_dev *dev, struct ieee80211_sta *sta,
 	q = &dev->q_tx[qid];
 
 	spin_lock_bh(&q->lock);
-	dev->queue_ops->tx_queue_skb(dev, q, skb, wcid, sta);
+	dev->queue_ops->tx_queue_skb(dev, qid, skb, wcid, sta);
 	dev->queue_ops->kick(dev, q);
 
 	if (q->queued > q->ndesc - 8 && !q->stopped) {
@@ -327,7 +327,6 @@ mt76_queue_ps_skb(struct mt76_dev *dev, struct ieee80211_sta *sta,
 {
 	struct mt76_wcid *wcid = (struct mt76_wcid *) sta->drv_priv;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct mt76_queue *hwq = &dev->q_tx[MT_TXQ_PSD];
 
 	info->control.flags |= IEEE80211_TX_CTRL_PS_RESPONSE;
 	if (last)
@@ -335,7 +334,7 @@ mt76_queue_ps_skb(struct mt76_dev *dev, struct ieee80211_sta *sta,
 			       IEEE80211_TX_CTL_REQ_TX_STATUS;
 
 	mt76_skb_set_moredata(skb, !last);
-	dev->queue_ops->tx_queue_skb(dev, hwq, skb, wcid, sta);
+	dev->queue_ops->tx_queue_skb(dev, MT_TXQ_PSD, skb, wcid, sta);
 }
 
 void
@@ -387,6 +386,7 @@ mt76_txq_send_burst(struct mt76_dev *dev, struct mt76_queue *hwq,
 		    struct mt76_txq *mtxq, bool *empty)
 {
 	struct ieee80211_txq *txq = mtxq_to_txq(mtxq);
+	enum mt76_txq_id qid = mt76_txq_get_qid(txq);
 	struct ieee80211_tx_info *info;
 	struct mt76_wcid *wcid = mtxq->wcid;
 	struct sk_buff *skb;
@@ -420,7 +420,7 @@ mt76_txq_send_burst(struct mt76_dev *dev, struct mt76_queue *hwq,
 	if (ampdu)
 		mt76_check_agg_ssn(mtxq, skb);
 
-	idx = dev->queue_ops->tx_queue_skb(dev, hwq, skb, wcid, txq->sta);
+	idx = dev->queue_ops->tx_queue_skb(dev, qid, skb, wcid, txq->sta);
 
 	if (idx < 0)
 		return idx;
@@ -455,7 +455,7 @@ mt76_txq_send_burst(struct mt76_dev *dev, struct mt76_queue *hwq,
 		if (cur_ampdu)
 			mt76_check_agg_ssn(mtxq, skb);
 
-		idx = dev->queue_ops->tx_queue_skb(dev, hwq, skb, wcid,
+		idx = dev->queue_ops->tx_queue_skb(dev, qid, skb, wcid,
 						   txq->sta);
 		if (idx < 0)
 			return idx;
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index c30878d2dc5c..47ca79ef1db4 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -726,10 +726,11 @@ mt76u_tx_build_sg(struct mt76_dev *dev, struct sk_buff *skb,
 }
 
 static int
-mt76u_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
+mt76u_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
 		   struct sk_buff *skb, struct mt76_wcid *wcid,
 		   struct ieee80211_sta *sta)
 {
+	struct mt76_queue *q = &dev->q_tx[qid];
 	struct mt76u_buf *buf;
 	u16 idx = q->tail;
 	int err;
-- 
2.20.1

