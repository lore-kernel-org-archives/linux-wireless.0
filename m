Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36092 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751334AbeDYJL1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 05:11:27 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 2/4] mt76: add rcu locking in tid reorder function
Date: Wed, 25 Apr 2018 11:11:22 +0200
Message-Id: <20180425091124.909-2-nbd@nbd.name> (sfid-20180425_111136_905189_6053F213)
In-Reply-To: <20180425091124.909-1-nbd@nbd.name>
References: <20180425091124.909-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avoids having the tid or station entry disappear prematurely.
Also cancel the reorder work earlier to avoid further processing delayed
by waiting for the lock to be released

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/agg-rx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/agg-rx.c b/drivers/net/wireless/mediatek/mt76/agg-rx.c
index dbf4057d2d3e..b67acc6189bf 100644
--- a/drivers/net/wireless/mediatek/mt76/agg-rx.c
+++ b/drivers/net/wireless/mediatek/mt76/agg-rx.c
@@ -103,6 +103,7 @@ mt76_rx_aggr_reorder_work(struct work_struct *work)
 	__skb_queue_head_init(&frames);
 
 	local_bh_disable();
+	rcu_read_lock();
 
 	spin_lock(&tid->lock);
 	mt76_rx_aggr_check_release(tid, &frames);
@@ -114,6 +115,7 @@ mt76_rx_aggr_reorder_work(struct work_struct *work)
 					     REORDER_TIMEOUT);
 	mt76_rx_complete(dev, &frames, -1);
 
+	rcu_read_unlock();
 	local_bh_enable();
 }
 
@@ -266,6 +268,8 @@ static void mt76_rx_aggr_shutdown(struct mt76_dev *dev, struct mt76_rx_tid *tid)
 	u8 size = tid->size;
 	int i;
 
+	cancel_delayed_work(&tid->reorder_work);
+
 	spin_lock_bh(&tid->lock);
 
 	tid->stopped = true;
@@ -280,8 +284,6 @@ static void mt76_rx_aggr_shutdown(struct mt76_dev *dev, struct mt76_rx_tid *tid)
 	}
 
 	spin_unlock_bh(&tid->lock);
-
-	cancel_delayed_work(&tid->reorder_work);
 }
 
 void mt76_rx_aggr_stop(struct mt76_dev *dev, struct mt76_wcid *wcid, u8 tidno)
-- 
2.14.2
