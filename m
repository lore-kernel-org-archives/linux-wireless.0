Return-Path: <SRS0=ZGUU=N3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0153C43610
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 11:12:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 704AA2084A
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 11:12:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="ThMhyCNV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 704AA2084A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389561AbeKPVYa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Nov 2018 16:24:30 -0500
Received: from nbd.name ([46.4.11.11]:34388 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727454AbeKPVYa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Nov 2018 16:24:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=mYPvx7azLlciYGjtHNxp8byp4k5zOu3vxA9jtvgzvDE=; b=ThMhyCNVZdP1nvGkA1OuQGmGZr
        kyrDA94IPEuRYjCgEzO/Jg47FGo6xEgpKC6mrLfVjb6WxMk0nqhgx7Sxomz+LjIQzdYKzhUSO+SqA
        KdGaXUVykBtTlFTJZHWIgwCcFAmrGc3/FZS5s4eAYRV67d22K4VqcXwHqtHGWhokQgzI=;
Received: by maeck.local (Postfix, from userid 501)
        id 7012F463F114; Fri, 16 Nov 2018 12:12:35 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH v2 3/7] mt76: fix race condition in station removal
Date:   Fri, 16 Nov 2018 12:12:31 +0100
Message-Id: <20181116111235.86347-3-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20181116111235.86347-1-nbd@nbd.name>
References: <20181116111235.86347-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

If there are still pending packets in the tx queue when removing a station,
it could possibly lead to a call to further attempts to pull packets from
the mac80211 tx queue after it has already been removed from the scheduling
list.
Prevent this from happening by calling synchronize_rcu after deleting the
wcid pointer before further cleaning up the tx queues.
To be extra careful, ensure that mtxq->list is always initialized properly.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
v2: keep the call to mt76x02_mac_wcid_setup in place

 drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 4 +++-
 drivers/net/wireless/mediatek/mt76/tx.c           | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index d2ac1a84668c..1a51193d5d59 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -216,9 +216,11 @@ int mt76x02_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	int idx = msta->wcid.idx;
 	int i;
 
+	rcu_assign_pointer(dev->mt76.wcid[idx], NULL);
+	synchronize_rcu();
+
 	mutex_lock(&dev->mt76.mutex);
 	mt76_tx_status_check(&dev->mt76, &msta->wcid, true);
-	rcu_assign_pointer(dev->mt76.wcid[idx], NULL);
 	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
 		mt76_txq_remove(&dev->mt76, sta->txq[i]);
 	mt76x02_mac_wcid_set_drop(dev, idx, true);
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index e42a24628e4f..f4093dc0e174 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -590,7 +590,7 @@ void mt76_txq_remove(struct mt76_dev *dev, struct ieee80211_txq *txq)
 
 	spin_lock_bh(&hwq->lock);
 	if (!list_empty(&mtxq->list))
-		list_del(&mtxq->list);
+		list_del_init(&mtxq->list);
 	spin_unlock_bh(&hwq->lock);
 
 	while ((skb = skb_dequeue(&mtxq->retry_q)) != NULL)
-- 
2.17.0

