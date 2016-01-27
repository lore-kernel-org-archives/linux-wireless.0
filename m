Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:34871 "EHLO
	mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374AbcA0OZK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 09:25:10 -0500
Received: by mail-lf0-f45.google.com with SMTP id c192so7030166lfe.2
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jan 2016 06:25:08 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2] mac80211: expose txq queue depth and size to drivers
Date: Wed, 27 Jan 2016 15:26:12 +0100
Message-Id: <1453904772-25289-1-git-send-email-michal.kazior@tieto.com> (sfid-20160127_152514_390328_392A884C)
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

Notes:
    v2:
     * export a dedicated API call to get both
       frame/byte counts to reduce redundancy and
       offer possible synchronized reads in the future [Felix]

 include/net/mac80211.h     | 15 +++++++++++++++
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/iface.c       |  1 +
 net/mac80211/sta_info.c    |  1 +
 net/mac80211/tx.c          |  8 +++++++-
 net/mac80211/util.c        | 14 ++++++++++++++
 6 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 31337f81ec03..6617516a276f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -5594,4 +5594,19 @@ void ieee80211_unreserve_tid(struct ieee80211_sta *sta, u8 tid);
  */
 struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 				     struct ieee80211_txq *txq);
+
+/**
+ * ieee80211_txq_get_depth - get pending frame/byte count of given txq
+ *
+ * The values are not guaranteed to be coherent with regard to each other, i.e.
+ * txq state can change half-way of this function and the caller may end up
+ * with "new" frame_cnt and "old" byte_cnt or vice-versa.
+ *
+ * @txq: pointer obtained from station or virtual interface
+ * @frame_cnt: pointer to store frame count
+ * @byte_cnt: pointer to store byte count
+ */
+void ieee80211_txq_get_depth(struct ieee80211_txq *txq,
+			     unsigned long *frame_cnt,
+			     unsigned long *byte_cnt);
 #endif /* MAC80211_H */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a29f61dc9c06..a96f8c0461f6 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -804,6 +804,7 @@ enum txq_info_flags {
 struct txq_info {
 	struct sk_buff_head queue;
 	unsigned long flags;
+	unsigned long byte_cnt;
 
 	/* keep last! */
 	struct ieee80211_txq txq;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 0451f120746e..453b4e741780 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -979,6 +979,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 
 		spin_lock_bh(&txqi->queue.lock);
 		ieee80211_purge_tx_queue(&local->hw, &txqi->queue);
+		txqi->byte_cnt = 0;
 		spin_unlock_bh(&txqi->queue.lock);
 
 		atomic_set(&sdata->txqs_len[txqi->txq.ac], 0);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 7e007cf12cb2..e1d9ccc5d197 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -116,6 +116,7 @@ static void __cleanup_single_sta(struct sta_info *sta)
 
 			ieee80211_purge_tx_queue(&local->hw, &txqi->queue);
 			atomic_sub(n, &sdata->txqs_len[txqi->txq.ac]);
+			txqi->byte_cnt = 0;
 		}
 	}
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 3311ce0f3d6c..af584f7cdd63 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1266,7 +1266,11 @@ static void ieee80211_drv_tx(struct ieee80211_local *local,
 	if (atomic_read(&sdata->txqs_len[ac]) >= local->hw.txq_ac_max_pending)
 		netif_stop_subqueue(sdata->dev, ac);
 
-	skb_queue_tail(&txqi->queue, skb);
+	spin_lock_bh(&txqi->queue.lock);
+	txqi->byte_cnt += skb->len;
+	__skb_queue_tail(&txqi->queue, skb);
+	spin_unlock_bh(&txqi->queue.lock);
+
 	drv_wake_tx_queue(local, txqi);
 
 	return;
@@ -1294,6 +1298,8 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	if (!skb)
 		goto out;
 
+	txqi->byte_cnt -= skb->len;
+
 	atomic_dec(&sdata->txqs_len[ac]);
 	if (__netif_subqueue_stopped(sdata->dev, ac))
 		ieee80211_propagate_queue_wake(local, sdata->vif.hw_queue[ac]);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index fb90d9c5df59..091f3dd62ad1 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -3368,3 +3368,17 @@ void ieee80211_init_tx_queue(struct ieee80211_sub_if_data *sdata,
 		txqi->txq.ac = IEEE80211_AC_BE;
 	}
 }
+
+void ieee80211_txq_get_depth(struct ieee80211_txq *txq,
+			     unsigned long *frame_cnt,
+			     unsigned long *byte_cnt)
+{
+	struct txq_info *txqi = to_txq_info(txq);
+
+	if (frame_cnt)
+		*frame_cnt = txqi->queue.qlen;
+
+	if (byte_cnt)
+		*byte_cnt = txqi->byte_cnt;
+}
+EXPORT_SYMBOL(ieee80211_txq_get_depth);
-- 
2.1.4

