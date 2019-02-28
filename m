Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2AD0C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 13:31:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FE512171F
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 13:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551360715;
	bh=4stRft3fyQPpb5FscZSGuqs7JngWycMvFqiF3omDnik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=m765hRqYUUZKoOq1AOt7W/d9JIyhvHXo+BLTXmHuzJcaT7bzpxxAUG3fwKv+Hzl4G
	 UvkKxi9TXs9RAXH9lkvtshuu8HLhxuvntsUNfbNbLlXaIunl2vUbXeLQaGWnOe0vUJ
	 jkADxAHiOmvkupeCS+JUhTrSCns/DuwV/FxYMjuo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbfB1Nby (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 08:31:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:36390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726918AbfB1Nby (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 08:31:54 -0500
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A584420830;
        Thu, 28 Feb 2019 13:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551360713;
        bh=4stRft3fyQPpb5FscZSGuqs7JngWycMvFqiF3omDnik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1SqbA9B1ZNF/2xVZauPaWUwR9mXSPm3gf2NlGfQcS6CaXoWQAzrfPZ8fs4TIeJSTo
         Z+aiJRS/Sa5uingVHI9zVXPWfmjAd6eTYszNI7Gvsf8a/ihby8zy2tg8bB1Ok2a6IN
         7WzNhRjrhCPx6/uzPCh82AQx6Vdpya8oEKxzCGPA=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com
Subject: [PATCH v2] mt76: introduce q->stopped parameter
Date:   Thu, 28 Feb 2019 14:31:31 +0100
Message-Id: <803f9e01a21ef024ce66d1fda96debe278b0a398.1551360035.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1551360035.git.lorenzo@kernel.org>
References: <cover.1551360035.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce mt76_queue stopped parameter in order to run
ieee80211_wake_queue only when mac80211 queues have been
previously stopped and avoid to disable interrupts when
it is not necessary

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
Changes since v1:
- move back ieee80211_stop_queue() inside q->lock critical section
---
 drivers/net/wireless/mediatek/mt76/dma.c  | 5 ++++-
 drivers/net/wireless/mediatek/mt76/mt76.h | 1 +
 drivers/net/wireless/mediatek/mt76/tx.c   | 5 ++++-
 drivers/net/wireless/mediatek/mt76/usb.c  | 6 +++++-
 4 files changed, 14 insertions(+), 3 deletions(-)

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
index 5a349fe3e576..4d38a54014e8 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -289,8 +289,11 @@ mt76_tx(struct mt76_dev *dev, struct ieee80211_sta *sta,
 	dev->queue_ops->tx_queue_skb(dev, q, skb, wcid, sta);
 	dev->queue_ops->kick(dev, q);
 
-	if (q->queued > q->ndesc - 8)
+	if (q->queued > q->ndesc - 8 && !q->stopped) {
 		ieee80211_stop_queue(dev->hw, skb_get_queue_mapping(skb));
+		q->stopped = true;
+	}
+
 	spin_unlock_bh(&q->lock);
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

