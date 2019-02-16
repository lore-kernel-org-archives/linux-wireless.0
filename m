Return-Path: <SRS0=K8Xh=QX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3206C43381
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Feb 2019 17:48:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9696D2192B
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Feb 2019 17:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550339295;
	bh=XgBP/9tKZRDouhd+BwIkaqQ16dzxg8PrNNpkAe8QGFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=IN0mUUjaDmlNcBC2B4InniVFjs/K0mJSCUye6hH7K3tQIea5i9T87XNqUQVK4+KzY
	 OqlDnCsTzqh27SNU/tNupVxafde2CCZ6CPHZZX80Pg6u5fykRqpwdj4cwaoG3zMayG
	 h2RnzVpCDZhEL3ZmpRLpoL8KCazrr5x/QZS/JFig=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732252AbfBPRsN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Feb 2019 12:48:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:43556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726391AbfBPRsN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Feb 2019 12:48:13 -0500
Received: from lore-desk.lan (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA5CB2192B;
        Sat, 16 Feb 2019 17:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550339292;
        bh=XgBP/9tKZRDouhd+BwIkaqQ16dzxg8PrNNpkAe8QGFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iJReyGcYdR2fRudUJWL0w2uRdcVlUz+dR9lf1JOBpRu8u6JKF3j9/FbE8/Y6rbO9s
         tbnNYyf3qefoeYCp0cxzkoJz8LNf1I5uP2fD+3zlkxyMEzV82Hki1sWD7G88MHNAxH
         PhXLDwKeMU4fkTutBKamyq2EcvLdHHVXXGO2ZDgQ=
From:   lorenzo@kernel.org
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        ryder.lee@mediatek.com, roychl666@gmail.com,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: [PATCH 2/2] mt76: move txq qid dependency in driver specific code
Date:   Sat, 16 Feb 2019 18:47:34 +0100
Message-Id: <43e762876cc1d2e3ecca565ec382b1d74772d4cb.1550336347.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1550336347.git.lorenzo@kernel.org>
References: <cover.1550336347.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

Move queue id dependency in driver specific tx queue initialization code
since new chipsets rely on a different tx queue enumeration scheme
Introduce mt76_sta_init_tx_queue utility routine

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 27 ++++++++++++-------
 drivers/net/wireless/mediatek/mt76/mt76.h     | 12 ++++++++-
 .../net/wireless/mediatek/mt76/mt76x02_util.c |  2 ++
 drivers/net/wireless/mediatek/mt76/tx.c       | 16 +++--------
 4 files changed, 34 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index c7abf4f54867..3d25b625b8cc 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -644,20 +644,12 @@ void mt76_rx_poll_complete(struct mt76_dev *dev, enum mt76_rxq_id q,
 }
 EXPORT_SYMBOL_GPL(mt76_rx_poll_complete);
 
-static int
-mt76_sta_add(struct mt76_dev *dev, struct ieee80211_vif *vif,
-	     struct ieee80211_sta *sta)
+void mt76_sta_init_tx_queue(struct mt76_dev *dev,
+			    struct ieee80211_sta *sta)
 {
 	struct mt76_wcid *wcid = (struct mt76_wcid *)sta->drv_priv;
-	int ret;
 	int i;
 
-	mutex_lock(&dev->mutex);
-
-	ret = dev->drv->sta_add(dev, vif, sta);
-	if (ret)
-		goto out;
-
 	for (i = 0; i < ARRAY_SIZE(sta->txq); i++) {
 		struct mt76_txq *mtxq;
 
@@ -669,6 +661,21 @@ mt76_sta_add(struct mt76_dev *dev, struct ieee80211_vif *vif,
 
 		mt76_txq_init(dev, sta->txq[i]);
 	}
+}
+EXPORT_SYMBOL_GPL(mt76_sta_init_tx_queue);
+
+static int
+mt76_sta_add(struct mt76_dev *dev, struct ieee80211_vif *vif,
+	     struct ieee80211_sta *sta)
+{
+	struct mt76_wcid *wcid = (struct mt76_wcid *)sta->drv_priv;
+	int ret;
+
+	mutex_lock(&dev->mutex);
+
+	ret = dev->drv->sta_add(dev, vif, sta);
+	if (ret)
+		goto out;
 
 	ewma_signal_init(&wcid->rssi);
 	rcu_assign_pointer(dev->wcid[wcid->idx], wcid);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 53b85042b793..f6aab5ee782b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -639,6 +639,17 @@ static inline struct mt76_tx_cb *mt76_tx_skb_cb(struct sk_buff *skb)
 	return ((void *) IEEE80211_SKB_CB(skb)->status.status_driver_data);
 }
 
+void mt76_sta_init_tx_queue(struct mt76_dev *dev,
+			    struct ieee80211_sta *sta);
+void __mt76_txq_init(struct mt76_dev *dev, struct ieee80211_txq *txq, int qid);
+static inline void
+mt76_txq_init(struct mt76_dev *dev, struct ieee80211_txq *txq)
+{
+	int qid = txq->sta ? txq->ac : MT_TXQ_BE;
+
+	return __mt76_txq_init(dev, txq, qid);
+}
+
 int mt76_dma_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 			  struct sk_buff *skb, struct mt76_wcid *wcid,
 			  struct ieee80211_sta *sta);
@@ -646,7 +657,6 @@ int mt76_dma_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 void mt76_rx(struct mt76_dev *dev, enum mt76_rxq_id q, struct sk_buff *skb);
 void mt76_tx(struct mt76_dev *dev, struct ieee80211_sta *sta,
 	     struct mt76_wcid *wcid, struct sk_buff *skb, int qid);
-void mt76_txq_init(struct mt76_dev *dev, struct ieee80211_txq *txq);
 void mt76_txq_remove(struct mt76_dev *dev, struct ieee80211_txq *txq);
 void mt76_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *txq);
 void mt76_stop_tx_queues(struct mt76_dev *dev, struct ieee80211_sta *sta,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 87ed00768bc7..c3a36519a942 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -251,6 +251,8 @@ int mt76x02_sta_add(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 	if (vif->type == NL80211_IFTYPE_AP)
 		set_bit(MT_WCID_FLAG_CHECK_PS, &msta->wcid.flags);
 
+	mt76_sta_init_tx_queue(mdev, sta);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mt76x02_sta_add);
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 3617de2c1325..142b12877a34 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -82,15 +82,6 @@ void mt76_tx_free(struct mt76_dev *dev)
 				 DMA_TO_DEVICE);
 }
 
-static int
-mt76_txq_get_qid(struct ieee80211_txq *txq)
-{
-	if (!txq->sta)
-		return MT_TXQ_BE;
-
-	return txq->ac;
-}
-
 static void
 mt76_check_agg_ssn(struct mt76_txq *mtxq, struct sk_buff *skb)
 {
@@ -604,16 +595,17 @@ void mt76_txq_remove(struct mt76_dev *dev, struct ieee80211_txq *txq)
 }
 EXPORT_SYMBOL_GPL(mt76_txq_remove);
 
-void mt76_txq_init(struct mt76_dev *dev, struct ieee80211_txq *txq)
+void __mt76_txq_init(struct mt76_dev *dev, struct ieee80211_txq *txq,
+		     int qid)
 {
 	struct mt76_txq *mtxq = (struct mt76_txq *) txq->drv_priv;
 
 	INIT_LIST_HEAD(&mtxq->list);
 	skb_queue_head_init(&mtxq->retry_q);
 
-	mtxq->hwq = &dev->q_tx[mt76_txq_get_qid(txq)];
+	mtxq->hwq = &dev->q_tx[qid];
 }
-EXPORT_SYMBOL_GPL(mt76_txq_init);
+EXPORT_SYMBOL_GPL(__mt76_txq_init);
 
 u8 mt76_ac_to_hwq(u8 ac)
 {
-- 
2.20.1

