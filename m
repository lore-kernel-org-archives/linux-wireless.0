Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34128 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752304AbeA0PCI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Jan 2018 10:02:08 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 4.16 3/4] mt76: avoid re-queueing A-MPDU rx reorder work if no frames are pending
Date: Sat, 27 Jan 2018 16:02:05 +0100
Message-Id: <20180127150206.24690-3-nbd@nbd.name> (sfid-20180127_160218_043063_88755524)
In-Reply-To: <20180127150206.24690-1-nbd@nbd.name>
References: <20180127150206.24690-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes: aee5b8cf2477 ("mt76: implement A-MPDU rx reordering in the driver code")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/agg-rx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/agg-rx.c b/drivers/net/wireless/mediatek/mt76/agg-rx.c
index e9784b50e2af..fcb208d1f276 100644
--- a/drivers/net/wireless/mediatek/mt76/agg-rx.c
+++ b/drivers/net/wireless/mediatek/mt76/agg-rx.c
@@ -98,6 +98,7 @@ mt76_rx_aggr_reorder_work(struct work_struct *work)
 					       reorder_work.work);
 	struct mt76_dev *dev = tid->dev;
 	struct sk_buff_head frames;
+	int nframes;
 
 	__skb_queue_head_init(&frames);
 
@@ -105,9 +106,12 @@ mt76_rx_aggr_reorder_work(struct work_struct *work)
 
 	spin_lock(&tid->lock);
 	mt76_rx_aggr_check_release(tid, &frames);
+	nframes = tid->nframes;
 	spin_unlock(&tid->lock);
 
-	ieee80211_queue_delayed_work(tid->dev->hw, &tid->reorder_work, REORDER_TIMEOUT);
+	if (nframes)
+		ieee80211_queue_delayed_work(tid->dev->hw, &tid->reorder_work,
+					     REORDER_TIMEOUT);
 	mt76_rx_complete(dev, &frames, -1);
 
 	local_bh_enable();
-- 
2.14.2
