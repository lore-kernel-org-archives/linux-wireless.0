Return-Path: <SRS0=dsQx=NY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD363C43610
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Nov 2018 19:41:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F15020818
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Nov 2018 19:41:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="LGyb98Iq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8F15020818
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbeKNFlA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 14 Nov 2018 00:41:00 -0500
Received: from nbd.name ([46.4.11.11]:49574 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726408AbeKNFlA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Nov 2018 00:41:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1bdCCyAEMZ4kxIyEgmZSvqXC61lK81z6JW9+GfDxpw0=; b=LGyb98IqvUJuhQf2XNjnizowdr
        0EzUcU4sMBmzpsot9qRW9RnJAi6TpOa++mbF51MvlaCqdoZWxralgq/lVIfrpQgC1dhsV69Jx9MF4
        NIQHJRjETiNOmqsYxyKKMY5M7laiiywg+6mmSVJHulrz/l6j7XjxoQXF4sRVkkfeNx20=;
Received: by maeck.lan (Postfix, from userid 501)
        id 71500453098F; Tue, 13 Nov 2018 20:41:23 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] mt76: add mt76_sta_remove helper
Date:   Tue, 13 Nov 2018 20:41:23 +0100
Message-Id: <20181113194123.93313-4-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20181113194123.93313-1-nbd@nbd.name>
References: <20181113194123.93313-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This allows station removal code to be used by mt7603 later

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 19 +++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76.h     |  2 ++
 .../net/wireless/mediatek/mt76/mt76x02_util.c | 12 +++---------
 3 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 3be73b021d27..1098919f5498 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -630,3 +630,22 @@ void mt76_rx_poll_complete(struct mt76_dev *dev, enum mt76_rxq_id q,
 	mt76_rx_complete(dev, &frames, napi);
 }
 EXPORT_SYMBOL_GPL(mt76_rx_poll_complete);
+
+void mt76_sta_remove(struct mt76_dev *dev, struct ieee80211_vif *vif,
+		     struct ieee80211_sta *sta)
+{
+	struct mt76_wcid *wcid = (struct mt76_wcid *)sta->drv_priv;
+	int idx = wcid->idx;
+	int i;
+
+	rcu_assign_pointer(dev->wcid[idx], NULL);
+	synchronize_rcu();
+
+	mutex_lock(&dev->mutex);
+	mt76_tx_status_check(dev, wcid, true);
+	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
+		mt76_txq_remove(dev, sta->txq[i]);
+	mt76_wcid_free(dev->wcid_mask, idx);
+	mutex_unlock(&dev->mutex);
+}
+EXPORT_SYMBOL_GPL(mt76_sta_remove);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index ea74ba00aebc..878836fe80d3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -664,6 +664,8 @@ void mt76_tx_status_skb_done(struct mt76_dev *dev, struct sk_buff *skb,
 void mt76_tx_complete_skb(struct mt76_dev *dev, struct sk_buff *skb);
 void mt76_tx_status_check(struct mt76_dev *dev, struct mt76_wcid *wcid,
 			  bool flush);
+void mt76_sta_remove(struct mt76_dev *dev, struct ieee80211_vif *vif,
+		     struct ieee80211_sta *sta);
 
 struct ieee80211_sta *mt76_rx_convert(struct sk_buff *skb);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index cd32ef5864b5..dc25de2d02d5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -210,19 +210,13 @@ int mt76x02_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta)
 {
 	struct mt76x02_dev *dev = hw->priv;
-	struct mt76x02_sta *msta = (struct mt76x02_sta *)sta->drv_priv;
-	int idx = msta->wcid.idx;
-	int i;
+	struct mt76_wcid *wcid = (struct mt76_wcid *)sta->drv_priv;
+	int idx = wcid->idx;
 
-	rcu_assign_pointer(dev->mt76.wcid[idx], NULL);
-	synchronize_rcu();
+	mt76_sta_remove(&dev->mt76, vif, sta);
 
 	mutex_lock(&dev->mt76.mutex);
-	mt76_tx_status_check(&dev->mt76, &msta->wcid, true);
-	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
-		mt76_txq_remove(&dev->mt76, sta->txq[i]);
 	mt76x02_mac_wcid_set_drop(dev, idx, true);
-	mt76_wcid_free(dev->mt76.wcid_mask, idx);
 	mutex_unlock(&dev->mt76.mutex);
 
 	return 0;
-- 
2.17.0

