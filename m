Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:56104 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811AbZICJuz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Sep 2009 05:50:55 -0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: lrodriguez@atheros.com, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] Staging: stlc45xx: fix usage of mac80211 workqueue
Date: Thu,  3 Sep 2009 13:50:44 +0400
Message-Id: <1251971444-28690-1-git-send-email-a.beregalov@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

See commit 42935ecaf(mac80211: redefine usage of the mac80211
workqueue).
Fix build error.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/staging/stlc45xx/stlc45xx.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/stlc45xx/stlc45xx.c b/drivers/staging/stlc45xx/stlc45xx.c
index 12d414d..9ec8bd1 100644
--- a/drivers/staging/stlc45xx/stlc45xx.c
+++ b/drivers/staging/stlc45xx/stlc45xx.c
@@ -1058,7 +1058,7 @@ static void stlc45xx_reset(struct stlc45xx *stlc)
 	stlc45xx_warning("resetting firmware");
 	stlc->fw_state = FW_STATE_RESET;
 	ieee80211_stop_queues(stlc->hw);
-	queue_work(stlc->hw->workqueue, &stlc->work_reset);
+	ieee80211_queue_work(stlc->hw, &stlc->work_reset);
 }
 
 static void stlc45xx_work_tx_timeout(struct work_struct *work)
@@ -1489,7 +1489,7 @@ static irqreturn_t stlc45xx_interrupt(int irq, void *config)
 
 	stlc45xx_debug(DEBUG_IRQ, "IRQ");
 
-	queue_work(stlc->hw->workqueue, &stlc->work);
+	ieee80211_queue_work(stlc->hw, &stlc->work);
 
 	return IRQ_HANDLED;
 }
@@ -1568,7 +1568,7 @@ static int stlc45xx_wq_tx(struct stlc45xx *stlc)
 		}
 
 		list_add(&entry->tx_list, &stlc->tx_sent);
-		queue_delayed_work(stlc->hw->workqueue,
+		ieee80211_queue_delayed_work(stlc->hw,
 				   &stlc->work_tx_timeout,
 				   msecs_to_jiffies(TX_TIMEOUT));
 	}
@@ -2132,7 +2132,7 @@ static int stlc45xx_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		ieee80211_stop_queues(stlc->hw);
 	}
 
-	queue_work(stlc->hw->workqueue, &stlc->work);
+	ieee80211_queue_work(stlc->hw, &stlc->work);
 
 	spin_unlock_bh(&stlc->tx_lock);
 
-- 
1.6.4.1

