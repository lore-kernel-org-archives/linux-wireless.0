Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49852 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753049AbeDCTxD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 15:53:03 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 5/7] mt76: fix potential sleep in atomic context
Date: Tue,  3 Apr 2018 21:52:52 +0200
Message-Id: <20180403195254.87700-5-nbd@nbd.name> (sfid-20180403_215308_242424_E30AAA39)
In-Reply-To: <20180403195254.87700-1-nbd@nbd.name>
References: <20180403195254.87700-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use cancel_delayed_work instead of cancel_delayed_work_sync

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/agg-rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/agg-rx.c b/drivers/net/wireless/mediatek/mt76/agg-rx.c
index fcb208d1f276..cbac42cb536c 100644
--- a/drivers/net/wireless/mediatek/mt76/agg-rx.c
+++ b/drivers/net/wireless/mediatek/mt76/agg-rx.c
@@ -273,7 +273,7 @@ static void mt76_rx_aggr_shutdown(struct mt76_dev *dev, struct mt76_rx_tid *tid)
 
 	spin_unlock_bh(&tid->lock);
 
-	cancel_delayed_work_sync(&tid->reorder_work);
+	cancel_delayed_work(&tid->reorder_work);
 }
 
 void mt76_rx_aggr_stop(struct mt76_dev *dev, struct mt76_wcid *wcid, u8 tidno)
-- 
2.14.2
