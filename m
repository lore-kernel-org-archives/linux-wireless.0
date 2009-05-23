Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:58971 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbZEWSbV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 May 2009 14:31:21 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/4] ar9170: fix lockdep warning on hibernate
Date: Sat, 23 May 2009 20:31:21 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200905232031.21662.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch takes care of Johannes' deadlock report by moving the
mutex_lock right after cancel_work_sync in ar9170_op_stop.

Besides, the janitor does not need to hold the mutex anymore,
so this extra lines can be removed as well.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index 1657e89..63528f1 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -343,7 +343,6 @@ static void ar9170_tx_status_janitor(struct work_struct *work)
 	if (unlikely(!IS_STARTED(ar)))
 		return ;
 
-	mutex_lock(&ar->mutex);
 	/* recycle the garbage back to mac80211... one by one. */
 	while ((skb = skb_dequeue(&ar->global_tx_status_waste))) {
 #ifdef AR9170_QUEUE_DEBUG
@@ -369,8 +368,6 @@ static void ar9170_tx_status_janitor(struct work_struct *work)
 	if (skb_queue_len(&ar->global_tx_status_waste) > 0)
 		queue_delayed_work(ar->hw->workqueue, &ar->tx_status_janitor,
 				   msecs_to_jiffies(100));
-
-	mutex_unlock(&ar->mutex);
 }
 
 static void ar9170_handle_command_response(struct ar9170 *ar,
@@ -1013,10 +1010,10 @@ static void ar9170_op_stop(struct ieee80211_hw *hw)
 
 	flush_workqueue(ar->hw->workqueue);
 
-	mutex_lock(&ar->mutex);
 	cancel_delayed_work_sync(&ar->tx_status_janitor);
 	cancel_work_sync(&ar->filter_config_work);
 	cancel_work_sync(&ar->beacon_work);
+	mutex_lock(&ar->mutex);
 	skb_queue_purge(&ar->global_tx_status_waste);
 	skb_queue_purge(&ar->global_tx_status);
 
