Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36096 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751247AbeDYJL1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 05:11:27 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 4/4] mt76: check for pending reset before attempting to schedule tx
Date: Wed, 25 Apr 2018 11:11:24 +0200
Message-Id: <20180425091124.909-4-nbd@nbd.name> (sfid-20180425_111131_811760_B85FF3B2)
In-Reply-To: <20180425091124.909-1-nbd@nbd.name>
References: <20180425091124.909-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The check within mt76_txq_send_burst is not enough, as it happens after
a first frame has already been queued up

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 6aca794cf998..7ecd2d7c5db4 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -385,6 +385,10 @@ mt76_txq_schedule_list(struct mt76_dev *dev, struct mt76_queue *hwq)
 		bool empty = false;
 		int cur;
 
+		if (test_bit(MT76_SCANNING, &dev->state) ||
+		    test_bit(MT76_RESET, &dev->state))
+			return -EBUSY;
+
 		mtxq = list_first_entry(&hwq->swq, struct mt76_txq, list);
 		if (mtxq->send_bar && mtxq->aggr) {
 			struct ieee80211_txq *txq = mtxq_to_txq(mtxq);
-- 
2.14.2
