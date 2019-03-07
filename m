Return-Path: <SRS0=M0/e=RK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD081C43381
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Mar 2019 14:45:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8240420835
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Mar 2019 14:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551969954;
	bh=mnJWKxTu7g9Etj29huwmcH/vGKg/4CCa+v8F+N5xAqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=xuU+UxMVJasa1hn3WjvgKCmrxacbNOBnZ9pmA65pq3dZ67pHh5nlZI7UHEky3M4Pf
	 7Q/463Rf6WYvKgddbqtNTSIFIXk7zRf+BvjNa2rQNbXjSgaf4mXuughR3o8leZk/0b
	 mpJf7mTu9H19f5fxjDpxaB96XcnYbYXy2sYQ83og=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbfCGOpx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Mar 2019 09:45:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:38498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbfCGOpx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Mar 2019 09:45:53 -0500
Received: from lore-desk.lan (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D97772081B;
        Thu,  7 Mar 2019 14:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551969951;
        bh=mnJWKxTu7g9Etj29huwmcH/vGKg/4CCa+v8F+N5xAqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f74DTUjFxsq66lUp5eYlGztDx2zsbW9Q/5Ft8LN1IhJOj7xUqvewtNt7/mAqGBHOM
         7W0YxHd077idm3urEhK3UpDz01Wdajmjjhh8XqrsQiegU2o7SmnxQ3sNvdlblUAy9f
         R0XmH7g9QiYQeT/jUd9GuymA84KH5pMRfUOcanac=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com
Subject: [PATCH] mt76: dma: add static qualifier to mt76_dma_tx_queue_skb
Date:   Thu,  7 Mar 2019 15:45:43 +0100
Message-Id: <d7405a02d013b9804de3f69120f23170d570cb19.1551968693.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1551968693.git.lorenzo@kernel.org>
References: <cover.1551968693.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

As already done for mt76_dma_tx_queue_skb_raw, add static qualifier to
mt76_dma_tx_queue_skb and introduce mt76_tx_queue_skb in order to run
mt76_dma_tx_queue_skb in driver code

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
This patch is based on 'introduce mt76_sw_queue data structure'
https://patchwork.kernel.org/cover/10836583/
---
 drivers/net/wireless/mediatek/mt76/dma.c           | 8 ++++----
 drivers/net/wireless/mediatek/mt76/mt76.h          | 5 +----
 drivers/net/wireless/mediatek/mt76/mt7603/beacon.c | 6 ++----
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  | 4 ++--
 4 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 75ea381ff64a..a66832a02281 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -278,9 +278,10 @@ mt76_dma_tx_queue_skb_raw(struct mt76_dev *dev, enum mt76_txq_id qid,
 	return 0;
 }
 
-int mt76_dma_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
-			  struct sk_buff *skb, struct mt76_wcid *wcid,
-			  struct ieee80211_sta *sta)
+static int
+mt76_dma_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
+		      struct sk_buff *skb, struct mt76_wcid *wcid,
+		      struct ieee80211_sta *sta)
 {
 	struct mt76_queue *q = dev->q_tx[qid].q;
 	struct mt76_queue_entry e;
@@ -352,7 +353,6 @@ int mt76_dma_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
 	mt76_put_txwi(dev, t);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(mt76_dma_tx_queue_skb);
 
 static int
 mt76_dma_rx_fill(struct mt76_dev *dev, struct mt76_queue *q)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 51245623b427..57136073e1fa 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -579,6 +579,7 @@ static inline u16 mt76_rev(struct mt76_dev *dev)
 #define mt76_init_queues(dev)		(dev)->mt76.queue_ops->init(&((dev)->mt76))
 #define mt76_queue_alloc(dev, ...)	(dev)->mt76.queue_ops->alloc(&((dev)->mt76), __VA_ARGS__)
 #define mt76_tx_queue_skb_raw(dev, ...)	(dev)->mt76.queue_ops->tx_queue_skb_raw(&((dev)->mt76), __VA_ARGS__)
+#define mt76_tx_queue_skb(dev, ...)	(dev)->mt76.queue_ops->tx_queue_skb(&((dev)->mt76), __VA_ARGS__)
 #define mt76_queue_rx_reset(dev, ...)	(dev)->mt76.queue_ops->rx_reset(&((dev)->mt76), __VA_ARGS__)
 #define mt76_queue_tx_cleanup(dev, ...)	(dev)->mt76.queue_ops->tx_cleanup(&((dev)->mt76), __VA_ARGS__)
 #define mt76_queue_kick(dev, ...)	(dev)->mt76.queue_ops->kick(&((dev)->mt76), __VA_ARGS__)
@@ -652,10 +653,6 @@ static inline struct mt76_tx_cb *mt76_tx_skb_cb(struct sk_buff *skb)
 	return ((void *) IEEE80211_SKB_CB(skb)->status.status_driver_data);
 }
 
-int mt76_dma_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
-			  struct sk_buff *skb, struct mt76_wcid *wcid,
-			  struct ieee80211_sta *sta);
-
 void mt76_rx(struct mt76_dev *dev, enum mt76_rxq_id q, struct sk_buff *skb);
 void mt76_tx(struct mt76_dev *dev, struct ieee80211_sta *sta,
 	     struct mt76_wcid *wcid, struct sk_buff *skb);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c b/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
index addfeec51f60..f1e96da4661a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
@@ -23,8 +23,7 @@ mt7603_update_beacon_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
 	if (!skb)
 		return;
 
-	mt76_dma_tx_queue_skb(&dev->mt76, MT_TXQ_BEACON, skb,
-			      &mvif->sta.wcid, NULL);
+	mt76_tx_queue_skb(dev, MT_TXQ_BEACON, skb, &mvif->sta.wcid, NULL);
 
 	spin_lock_bh(&dev->ps_lock);
 	mt76_wr(dev, MT_DMA_FQCR0, MT_DMA_FQCR0_BUSY |
@@ -118,8 +117,7 @@ void mt7603_pre_tbtt_tasklet(unsigned long arg)
 		struct ieee80211_vif *vif = info->control.vif;
 		struct mt7603_vif *mvif = (struct mt7603_vif *)vif->drv_priv;
 
-		mt76_dma_tx_queue_skb(&dev->mt76, MT_TXQ_CAB, skb,
-				      &mvif->sta.wcid, NULL);
+		mt76_tx_queue_skb(dev, MT_TXQ_CAB, skb, &mvif->sta.wcid, NULL);
 	}
 	mt76_queue_kick(dev, q);
 	spin_unlock_bh(&q->lock);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index c2a2fa353297..ec94d612f53c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -146,8 +146,8 @@ static void mt76x02_pre_tbtt_tasklet(unsigned long arg)
 		struct ieee80211_vif *vif = info->control.vif;
 		struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
 
-		mt76_dma_tx_queue_skb(&dev->mt76, MT_TXQ_PSD, skb,
-				      &mvif->group_wcid, NULL);
+		mt76_tx_queue_skb(dev, MT_TXQ_PSD, skb, &mvif->group_wcid,
+				  NULL);
 	}
 	spin_unlock_bh(&q->lock);
 }
-- 
2.20.1

