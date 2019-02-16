Return-Path: <SRS0=K8Xh=QX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EDEBC43381
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Feb 2019 17:48:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F9C62192B
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Feb 2019 17:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550339290;
	bh=v5GeSLIEb40DFTlxdGNF//pop3J4VUWcr+VVJuPdjwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=YpR18opdhh8NdbaKTiQAz/Wx1O2nejGD0N4B0bl4D0HvhSd57otL1uosbQfhPZBOO
	 fpzC3HCMf7OZbVkCUYZgKle2kT2cqlMP6qGqW/CM6Y1+OmohbU5phLPZjimH5pFwDA
	 TvDZDU//6hyKeoNHDMnExGcBA/3UR687tyucWz40=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732203AbfBPRsJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Feb 2019 12:48:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:43526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726391AbfBPRsJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Feb 2019 12:48:09 -0500
Received: from lore-desk.lan (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1264B2192B;
        Sat, 16 Feb 2019 17:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550339288;
        bh=v5GeSLIEb40DFTlxdGNF//pop3J4VUWcr+VVJuPdjwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=foEEB3kEVqfXj2LSyzBciRT3lV747dm+Ju+FWwrr6Slv29NpHBd2zkDpr440CoSVf
         0T+lnrZeL/LBjLCf7R+aHQfvHnR1nSbrpcaD3QNvic0IRYCt+2XZ1t9F2uUrXF08Pv
         t/c1wryVMOYdTdrWICG8pAAz3HX+InoQSjmTKsXI=
From:   lorenzo@kernel.org
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        ryder.lee@mediatek.com, roychl666@gmail.com,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: [PATCH 1/2] mt76: add qid parameter to mt76_tx signature
Date:   Sat, 16 Feb 2019 18:47:33 +0100
Message-Id: <124102c4120155ec22f2db161b4ba07937970880.1550336347.git.lorenzo@kernel.org>
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

Add queue id parameter to mt76_tx signature since new chipsets
rely on a different hw queue enumeration

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76.h         |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c |  8 +++++++-
 drivers/net/wireless/mediatek/mt76/tx.c           | 12 +++---------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 13f6febc9b0f..53b85042b793 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -645,7 +645,7 @@ int mt76_dma_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 
 void mt76_rx(struct mt76_dev *dev, enum mt76_rxq_id q, struct sk_buff *skb);
 void mt76_tx(struct mt76_dev *dev, struct ieee80211_sta *sta,
-	     struct mt76_wcid *wcid, struct sk_buff *skb);
+	     struct mt76_wcid *wcid, struct sk_buff *skb, int qid);
 void mt76_txq_init(struct mt76_dev *dev, struct ieee80211_txq *txq);
 void mt76_txq_remove(struct mt76_dev *dev, struct ieee80211_txq *txq);
 void mt76_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *txq);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
index 94f47248c59f..fcabbd9c25f2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
@@ -26,6 +26,7 @@ void mt76x02_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 	struct mt76x02_dev *dev = hw->priv;
 	struct ieee80211_vif *vif = info->control.vif;
 	struct mt76_wcid *wcid = &dev->mt76.global_wcid;
+	int qid = skb_get_queue_mapping(skb);
 
 	if (control->sta) {
 		struct mt76x02_sta *msta;
@@ -39,7 +40,12 @@ void mt76x02_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 		wcid = &mvif->group_wcid;
 	}
 
-	mt76_tx(&dev->mt76, control->sta, wcid, skb);
+	if (WARN_ON(qid >= MT_TXQ_PSD)) {
+		qid = MT_TXQ_BE;
+		skb_set_queue_mapping(skb, qid);
+	}
+
+	mt76_tx(&dev->mt76, control->sta, wcid, skb, qid);
 }
 EXPORT_SYMBOL_GPL(mt76x02_tx);
 
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index ef38e8626da9..3617de2c1325 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -255,19 +255,13 @@ void mt76_tx_complete_skb(struct mt76_dev *dev, struct sk_buff *skb)
 }
 EXPORT_SYMBOL_GPL(mt76_tx_complete_skb);
 
-void
-mt76_tx(struct mt76_dev *dev, struct ieee80211_sta *sta,
-	struct mt76_wcid *wcid, struct sk_buff *skb)
+void mt76_tx(struct mt76_dev *dev, struct ieee80211_sta *sta,
+	     struct mt76_wcid *wcid, struct sk_buff *skb,
+	     int qid)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct mt76_queue *q;
-	int qid = skb_get_queue_mapping(skb);
-
-	if (WARN_ON(qid >= MT_TXQ_PSD)) {
-		qid = MT_TXQ_BE;
-		skb_set_queue_mapping(skb, qid);
-	}
 
 	if (!wcid->tx_rate_set)
 		ieee80211_get_tx_rates(info->control.vif, sta, skb,
-- 
2.20.1

