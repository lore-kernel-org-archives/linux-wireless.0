Return-Path: <SRS0=ZGUU=N3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D1D0C04EBC
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 11:12:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62A682084A
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 11:12:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="dOQSrKQC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62A682084A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389577AbeKPVYa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Nov 2018 16:24:30 -0500
Received: from nbd.name ([46.4.11.11]:34384 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389554AbeKPVYa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Nov 2018 16:24:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=b84gvIuI56wHIELFbZcUrhj/9QskZuPZtD3E2KT+0yg=; b=dOQSrKQCPbnYzJqT3MzcOnSICt
        WTT3H5pBaaBdFEgTD/+u9q7GqKNH6OBPBJ/99c+QnMCLXYhEV49oPj6bo8tOKeNiPydFn9+C1H6aw
        N8wvJ4zeVhoYU7B3DbWKXLMia5Yly+lcPUjXquTOuYz4MVMXmDIfSfSrG66jPvSNZlYk=;
Received: by maeck.local (Postfix, from userid 501)
        id 6FAD6463F113; Fri, 16 Nov 2018 12:12:35 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH v2 6/7] mt76: mt76x02: remove mt76x02_txq_init
Date:   Fri, 16 Nov 2018 12:12:34 +0100
Message-Id: <20181116111235.86347-6-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20181116111235.86347-1-nbd@nbd.name>
References: <20181116111235.86347-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Open-coding it simplifies the code

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 23 -------------------
 .../net/wireless/mediatek/mt76/mt76x02_mac.h  |  2 --
 .../net/wireless/mediatek/mt76/mt76x02_util.c | 15 +++++++++---
 3 files changed, 12 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 4c35d3f7fb15..c08bf371e527 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -126,29 +126,6 @@ void mt76x02_mac_wcid_set_drop(struct mt76x02_dev *dev, u8 idx, bool drop)
 		mt76_wr(dev, MT_WCID_DROP(idx), (val & ~bit) | (bit * drop));
 }
 
-void mt76x02_txq_init(struct mt76x02_dev *dev, struct ieee80211_txq *txq)
-{
-	struct mt76_txq *mtxq;
-
-	if (!txq)
-		return;
-
-	mtxq = (struct mt76_txq *) txq->drv_priv;
-	if (txq->sta) {
-		struct mt76x02_sta *sta;
-
-		sta = (struct mt76x02_sta *) txq->sta->drv_priv;
-		mtxq->wcid = &sta->wcid;
-	} else {
-		struct mt76x02_vif *mvif;
-
-		mvif = (struct mt76x02_vif *) txq->vif->drv_priv;
-		mtxq->wcid = &mvif->group_wcid;
-	}
-
-	mt76_txq_init(&dev->mt76, txq);
-}
-
 static __le16
 mt76x02_mac_tx_rate_val(struct mt76x02_dev *dev,
 			const struct ieee80211_tx_rate *rate, u8 *nss_val)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index cf5c06a0a58a..4e597004c445 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -178,8 +178,6 @@ static inline bool mt76x02_wait_for_mac(struct mt76_dev *dev)
 	return false;
 }
 
-void mt76x02_txq_init(struct mt76x02_dev *dev, struct ieee80211_txq *txq);
-
 void mt76x02_mac_set_short_preamble(struct mt76x02_dev *dev, bool enable);
 int mt76x02_mac_shared_key_setup(struct mt76x02_dev *dev, u8 vif_idx,
 				 u8 key_idx, struct ieee80211_key_conf *key);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 0ea7ab9cf0c6..f5ebed75b939 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -191,8 +191,13 @@ int mt76x02_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	msta->wcid.hw_key_idx = -1;
 	mt76x02_mac_wcid_setup(dev, idx, mvif->idx, sta->addr);
 	mt76x02_mac_wcid_set_drop(dev, idx, false);
-	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
-		mt76x02_txq_init(dev, sta->txq[i]);
+	for (i = 0; i < ARRAY_SIZE(sta->txq); i++) {
+		struct mt76_txq *mtxq;
+
+		mtxq = (struct mt76_txq *) sta->txq[i]->drv_priv;
+		mtxq->wcid = &msta->wcid;
+		mt76_txq_init(&dev->mt76, sta->txq[i]);
+	}
 
 	if (vif->type == NL80211_IFTYPE_AP)
 		set_bit(MT_WCID_FLAG_CHECK_PS, &msta->wcid.flags);
@@ -230,11 +235,15 @@ void mt76x02_vif_init(struct mt76x02_dev *dev, struct ieee80211_vif *vif,
 		      unsigned int idx)
 {
 	struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
+	struct mt76_txq *mtxq;
 
 	mvif->idx = idx;
 	mvif->group_wcid.idx = MT_VIF_WCID(idx);
 	mvif->group_wcid.hw_key_idx = -1;
-	mt76x02_txq_init(dev, vif->txq);
+	mtxq = (struct mt76_txq *) vif->txq->drv_priv;
+	mtxq->wcid = &mvif->group_wcid;
+
+	mt76_txq_init(&dev->mt76, vif->txq);
 }
 EXPORT_SYMBOL_GPL(mt76x02_vif_init);
 
-- 
2.17.0

