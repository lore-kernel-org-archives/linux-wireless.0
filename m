Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:33720 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965064AbcAUNWB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 08:22:01 -0500
Received: by mail-lb0-f176.google.com with SMTP id x4so23400640lbm.0
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2016 05:22:00 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/2] mac80211: expose txq queue depth and size to drivers
Date: Thu, 21 Jan 2016 14:23:08 +0100
Message-Id: <1453382588-27105-2-git-send-email-michal.kazior@tieto.com> (sfid-20160121_142205_565285_DC42DB91)
In-Reply-To: <1453382588-27105-1-git-send-email-michal.kazior@tieto.com>
References: <1453382588-27105-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will allow drivers to make more educated
decisions whether to defer transmission or not.

Relying on wake_tx_queue() call count implicitly
was not possible because it could be called
without queued frame count actually changing on
software tx aggregation start/stop code paths.

It was also not possible to know how long
byte-wise queue was without dequeueing.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 include/net/mac80211.h  |  4 ++++
 net/mac80211/iface.c    |  2 ++
 net/mac80211/sta_info.c |  2 ++
 net/mac80211/tx.c       | 11 ++++++++++-
 4 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 566df20dc957..c29ca8be9ac2 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1781,6 +1781,8 @@ struct ieee80211_tx_control {
  *
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
  * @sta: station table entry, %NULL for per-vif queue
+ * @qdepth: number of pending frames
+ * @qsize: number of pending bytes
  * @tid: the TID for this queue (unused for per-vif queue)
  * @ac: the AC for this queue
  * @drv_priv: driver private area, sized by hw->txq_data_size
@@ -1791,6 +1793,8 @@ struct ieee80211_tx_control {
 struct ieee80211_txq {
 	struct ieee80211_vif *vif;
 	struct ieee80211_sta *sta;
+	int qdepth;
+	int qsize;
 	u8 tid;
 	u8 ac;
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 0451f120746e..dfcb19080eb0 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -979,6 +979,8 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 
 		spin_lock_bh(&txqi->queue.lock);
 		ieee80211_purge_tx_queue(&local->hw, &txqi->queue);
+		txqi->txq.qdepth = 0;
+		txqi->txq.qsize = 0;
 		spin_unlock_bh(&txqi->queue.lock);
 
 		atomic_set(&sdata->txqs_len[txqi->txq.ac], 0);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 7e007cf12cb2..4b93a11f4a0d 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -116,6 +116,8 @@ static void __cleanup_single_sta(struct sta_info *sta)
 
 			ieee80211_purge_tx_queue(&local->hw, &txqi->queue);
 			atomic_sub(n, &sdata->txqs_len[txqi->txq.ac]);
+			txqi->txq.qdepth = 0;
+			txqi->txq.qsize = 0;
 		}
 	}
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 3311ce0f3d6c..6f9a0db3824e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1266,7 +1266,13 @@ static void ieee80211_drv_tx(struct ieee80211_local *local,
 	if (atomic_read(&sdata->txqs_len[ac]) >= local->hw.txq_ac_max_pending)
 		netif_stop_subqueue(sdata->dev, ac);
 
-	skb_queue_tail(&txqi->queue, skb);
+	spin_lock_bh(&txqi->queue.lock);
+	txq->qdepth++;
+	txq->qsize += skb->len;
+
+	__skb_queue_tail(&txqi->queue, skb);
+	spin_unlock_bh(&txqi->queue.lock);
+
 	drv_wake_tx_queue(local, txqi);
 
 	return;
@@ -1294,6 +1300,9 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	if (!skb)
 		goto out;
 
+	txq->qdepth--;
+	txq->qsize -= skb->len;
+
 	atomic_dec(&sdata->txqs_len[ac]);
 	if (__netif_subqueue_stopped(sdata->dev, ac))
 		ieee80211_propagate_queue_wake(local, sdata->vif.hw_queue[ac]);
-- 
2.1.4

