Return-Path: <SRS0=HoYG=RC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1D9BC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 21:40:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DB6721850
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 21:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551303658;
	bh=0My3DrALWIusCRD4+BR3kQmYP+h6hyatHEzSS0in6lA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=jE25cFFP0rY9yGgX3fe4UiLHNGQ+lEAGosQ4STQdD8ERbHBDefYRQj90c6NfTFbyd
	 HjEt1iBt42zPFaFXBuXDpdI2FI9DSCnHINQ4/VM1tLqcFfqMEdG3lHjl0Wq3Zf8Z2k
	 m26zQe25gDRfmtp0TpGHuFWNCj8YiH0okD4xFmpc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730363AbfB0Vk5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Feb 2019 16:40:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:36808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727488AbfB0Vk5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Feb 2019 16:40:57 -0500
Received: from lore-desk.lan (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA74720863;
        Wed, 27 Feb 2019 21:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551303656;
        bh=0My3DrALWIusCRD4+BR3kQmYP+h6hyatHEzSS0in6lA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TLBrfbxcrUxYpi2+JUzrQlWtRSd9vb7CpCDqpxXlbAoqoTsPrUvOdNdVtYsoBj5Kn
         1NNUlhWE1+F9d3VTmXxTC7YBoHb0pQiSHh56yy3un5U89sZH0a+1xKnfSaCq0d1UQl
         sDSe8yKpX4wpG4wCPmwhPKzledfAek6bHZn6DEbE=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com
Subject: [PATCH] mt76: introduce q->stopped parameter
Date:   Wed, 27 Feb 2019 22:40:41 +0100
Message-Id: <ec189b4ec030646d4dbfd0b7c41944ab383edc4e.1551301983.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1551301983.git.lorenzo@kernel.org>
References: <cover.1551301983.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce mt76_queue stopped parameter in order to run
ieee80211_wake_queue only when mac80211 queues have been
previously stopped and avoid to disable interrupts when it is
not necessary.
Move ieee80211_stop_queue out of q->lock critical section

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c  |  5 ++++-
 drivers/net/wireless/mediatek/mt76/mt76.h |  1 +
 drivers/net/wireless/mediatek/mt76/tx.c   | 12 +++++++++---
 drivers/net/wireless/mediatek/mt76/usb.c  |  6 +++++-
 4 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 6eedc0ec7661..99e341cb1f92 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -180,7 +180,10 @@ mt76_dma_tx_cleanup(struct mt76_dev *dev, enum mt76_txq_id qid, bool flush)
 	else
 		mt76_dma_sync_idx(dev, q);
 
-	wake = wake && qid < IEEE80211_NUM_ACS && q->queued < q->ndesc - 8;
+	wake = wake && q->stopped &&
+	       qid < IEEE80211_NUM_ACS && q->queued < q->ndesc - 8;
+	if (wake)
+		q->stopped = false;
 
 	if (!q->queued)
 		wake_up(&dev->tx_wait);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 5dfb0601f101..3152b8c73c4a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -126,6 +126,7 @@ struct mt76_queue {
 	int ndesc;
 	int queued;
 	int buf_size;
+	bool stopped;
 
 	u8 buf_offset;
 	u8 hw_idx;
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 5a349fe3e576..97215c3a30d1 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -258,8 +258,9 @@ mt76_tx(struct mt76_dev *dev, struct ieee80211_sta *sta,
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	struct mt76_queue *q;
 	int qid = skb_get_queue_mapping(skb);
+	struct mt76_queue *q;
+	bool stop;
 
 	if (WARN_ON(qid >= MT_TXQ_PSD)) {
 		qid = MT_TXQ_BE;
@@ -289,9 +290,14 @@ mt76_tx(struct mt76_dev *dev, struct ieee80211_sta *sta,
 	dev->queue_ops->tx_queue_skb(dev, q, skb, wcid, sta);
 	dev->queue_ops->kick(dev, q);
 
-	if (q->queued > q->ndesc - 8)
-		ieee80211_stop_queue(dev->hw, skb_get_queue_mapping(skb));
+	stop = q->queued > q->ndesc - 8 && !q->stopped;
+	if (stop)
+		q->stopped = true;
+
 	spin_unlock_bh(&q->lock);
+
+	if (stop)
+		ieee80211_stop_queue(dev->hw, skb_get_queue_mapping(skb));
 }
 EXPORT_SYMBOL_GPL(mt76_tx);
 
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index ae6ada370597..4c1abd492405 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -655,7 +655,11 @@ static void mt76u_tx_tasklet(unsigned long data)
 			spin_lock_bh(&q->lock);
 		}
 		mt76_txq_schedule(dev, q);
-		wake = i < IEEE80211_NUM_ACS && q->queued < q->ndesc - 8;
+
+		wake = q->stopped && q->queued < q->ndesc - 8;
+		if (wake)
+			q->stopped = false;
+
 		if (!q->queued)
 			wake_up(&dev->tx_wait);
 
-- 
2.20.1

