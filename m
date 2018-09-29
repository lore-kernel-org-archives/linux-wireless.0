Return-Path: <SRS0=h0Fo=ML=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56FB9C64E93
	for <linux-wireless@archiver.kernel.org>; Sat, 29 Sep 2018 13:11:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B27F20880
	for <linux-wireless@archiver.kernel.org>; Sat, 29 Sep 2018 13:11:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="cI1hl8fd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1B27F20880
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbeI2TeS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 29 Sep 2018 15:34:18 -0400
Received: from nbd.name ([46.4.11.11]:48620 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728066AbeI2TeS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 29 Sep 2018 15:34:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=A4qcW/+tOfdJD1G8T/zzQscORg6OEB1Kj72e8IVcFS8=; b=cI1hl8fdSAaMycwROKsLP7A0RZ
        AdhETlscBz+VAoUIYhv6X5tU/Y1lwo2VlMDt5FifXglK80REf0oXRWjVgFSLf72Co+xeWFzqxvkiD
        drWN9QbugPElami3zyPDDSbwY6GPkTmNO021SE6U1nKW6fYPDZN/eODuaJoWst6+olKw=;
Received: by maeck.local (Postfix, from userid 501)
        id 4BA583B53454; Sat, 29 Sep 2018 15:05:50 +0200 (CEST)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] mt76: check aggregation sequence number for frames sent via drv_tx
Date:   Sat, 29 Sep 2018 15:05:50 +0200
Message-Id: <20180929130550.86187-2-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20180929130550.86187-1-nbd@nbd.name>
References: <20180929130550.86187-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

ps-poll response frames can be sent via drv_tx. Store the frame sequence number
for such frames, in case a BlockAckReq needs to be sent

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 36 +++++++++++++++++--------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index cf79b8c67b52..bf0e9e666bc4 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -91,11 +91,23 @@ mt76_txq_get_qid(struct ieee80211_txq *txq)
 	return txq->ac;
 }
 
+static void
+mt76_check_agg_ssn(struct mt76_txq *mtxq, struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+
+	if (!ieee80211_is_data_qos(hdr->frame_control))
+		return;
+
+	mtxq->agg_ssn = le16_to_cpu(hdr->seq_ctrl) + 0x10;
+}
+
 void
 mt76_tx(struct mt76_dev *dev, struct ieee80211_sta *sta,
 	struct mt76_wcid *wcid, struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct mt76_queue *q;
 	int qid = skb_get_queue_mapping(skb);
 
@@ -108,6 +120,19 @@ mt76_tx(struct mt76_dev *dev, struct ieee80211_sta *sta,
 		ieee80211_get_tx_rates(info->control.vif, sta, skb,
 				       info->control.rates, 1);
 
+	if (sta && ieee80211_is_data_qos(hdr->frame_control)) {
+		struct ieee80211_txq *txq;
+		struct mt76_txq *mtxq;
+		u8 tid;
+
+		tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
+		txq = sta->txq[tid];
+		mtxq = (struct mt76_txq *) txq->drv_priv;
+
+		if (mtxq->aggr)
+			mt76_check_agg_ssn(mtxq, skb);
+	}
+
 	q = &dev->q_tx[qid];
 
 	spin_lock_bh(&q->lock);
@@ -143,17 +168,6 @@ mt76_txq_dequeue(struct mt76_dev *dev, struct mt76_txq *mtxq, bool ps)
 	return skb;
 }
 
-static void
-mt76_check_agg_ssn(struct mt76_txq *mtxq, struct sk_buff *skb)
-{
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-
-	if (!ieee80211_is_data_qos(hdr->frame_control))
-		return;
-
-	mtxq->agg_ssn = le16_to_cpu(hdr->seq_ctrl) + 0x10;
-}
-
 static void
 mt76_queue_ps_skb(struct mt76_dev *dev, struct ieee80211_sta *sta,
 		  struct sk_buff *skb, bool last)
-- 
2.17.0

