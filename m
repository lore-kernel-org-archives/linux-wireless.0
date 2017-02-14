Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8285 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752959AbdBNMvJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 07:51:09 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 04/10] rt2x00: separte clearing entry from rt2x00lib_txdone
Date: Tue, 14 Feb 2017 13:46:02 +0100
Message-Id: <1487076368-7020-5-git-send-email-sgruszka@redhat.com> (sfid-20170214_135227_693184_893567CD)
In-Reply-To: <1487076368-7020-1-git-send-email-sgruszka@redhat.com>
References: <1487076368-7020-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes rt2x00lib_txdone a bit simpler and will allow to reuse
code in different variant of txdone which I'm preparing.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c | 51 +++++++++++++++-----------
 1 file changed, 29 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
index b5d90fe..03b368a 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -391,6 +391,32 @@ static void rt2x00lib_fill_tx_status(struct rt2x00_dev *rt2x00dev,
 	}
 }
 
+static void rt2x00lib_clear_entry(struct rt2x00_dev *rt2x00dev,
+				  struct queue_entry *entry)
+{
+	/*
+	 * Make this entry available for reuse.
+	 */
+	entry->skb = NULL;
+	entry->flags = 0;
+
+	rt2x00dev->ops->lib->clear_entry(entry);
+
+	rt2x00queue_index_inc(entry, Q_INDEX_DONE);
+
+	/*
+	 * If the data queue was below the threshold before the txdone
+	 * handler we must make sure the packet queue in the mac80211 stack
+	 * is reenabled when the txdone handler has finished. This has to be
+	 * serialized with rt2x00mac_tx(), otherwise we can wake up queue
+	 * before it was stopped.
+	 */
+	spin_lock_bh(&entry->queue->tx_lock);
+	if (!rt2x00queue_threshold(entry->queue))
+		rt2x00queue_unpause_queue(entry->queue);
+	spin_unlock_bh(&entry->queue->tx_lock);
+}
+
 void rt2x00lib_txdone(struct queue_entry *entry,
 		      struct txdone_entry_desc *txdesc)
 {
@@ -471,30 +497,11 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 			ieee80211_tx_status(rt2x00dev->hw, entry->skb);
 		else
 			ieee80211_tx_status_ni(rt2x00dev->hw, entry->skb);
-	} else
+	} else {
 		dev_kfree_skb_any(entry->skb);
+	}
 
-	/*
-	 * Make this entry available for reuse.
-	 */
-	entry->skb = NULL;
-	entry->flags = 0;
-
-	rt2x00dev->ops->lib->clear_entry(entry);
-
-	rt2x00queue_index_inc(entry, Q_INDEX_DONE);
-
-	/*
-	 * If the data queue was below the threshold before the txdone
-	 * handler we must make sure the packet queue in the mac80211 stack
-	 * is reenabled when the txdone handler has finished. This has to be
-	 * serialized with rt2x00mac_tx(), otherwise we can wake up queue
-	 * before it was stopped.
-	 */
-	spin_lock_bh(&entry->queue->tx_lock);
-	if (!rt2x00queue_threshold(entry->queue))
-		rt2x00queue_unpause_queue(entry->queue);
-	spin_unlock_bh(&entry->queue->tx_lock);
+	rt2x00lib_clear_entry(rt2x00dev, entry);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_txdone);
 
-- 
1.8.3.1
