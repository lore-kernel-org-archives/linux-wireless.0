Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53137 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744Ab1BMR52 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Feb 2011 12:57:28 -0500
Received: by mail-iw0-f174.google.com with SMTP id 9so4086972iwn.19
        for <linux-wireless@vger.kernel.org>; Sun, 13 Feb 2011 09:57:28 -0800 (PST)
From: "Nathaniel J. Smith" <njs@pobox.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wey-yi.w.guy@intel.com,
	ilw@linux.intel.com, "Nathaniel J. Smith" <njs@pobox.com>
Subject: [PATCH 2/5] iwlwifi: Convert the tx queue high_mark to an atomic_t
Date: Sun, 13 Feb 2011 09:56:39 -0800
Message-Id: <1297619803-2832-3-git-send-email-njs@pobox.com>
In-Reply-To: <1297619803-2832-1-git-send-email-njs@pobox.com>
References: <1297619803-2832-1-git-send-email-njs@pobox.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch should cause no behavioral change whatsoever.

Signed-off-by: Nathaniel J. Smith <njs@pobox.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c   |    8 +++++---
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    5 +++--
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    7 ++++---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    5 +++--
 7 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 6d2fb06..63999ae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -294,7 +294,7 @@ static void iwl3945_tx_queue_reclaim(struct iwl_priv *priv,
 		priv->cfg->ops->lib->txq_free_tfd(priv, txq);
 	}
 
-	if (iwl_queue_space(q) > q->high_mark && (txq_id >= 0) &&
+	if (iwl_queue_space(q) > atomic_read(&q->high_mark) && (txq_id >= 0) &&
 			(txq_id != IWL39_CMD_QUEUE_NUM) &&
 			priv->mac80211_registered)
 		iwl_wake_queue(priv, txq);
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index b8955d7..548cbe9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2230,7 +2230,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 						       tid, freed);
 
 			if (priv->mac80211_registered &&
-			    (iwl_queue_space(&txq->q) > txq->q.high_mark) &&
+			    (iwl_queue_space(&txq->q) > atomic_read(&txq->q.high_mark)) &&
 			    (agg->state != IWL_EMPTYING_HW_QUEUE_DELBA))
 				iwl_wake_queue(priv, txq);
 		}
@@ -2255,7 +2255,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 			IWL_DEBUG_TX_REPLY(priv, "Station not known\n");
 
 		if (priv->mac80211_registered &&
-		    (iwl_queue_space(&txq->q) > txq->q.high_mark))
+		    (iwl_queue_space(&txq->q) > atomic_read(&txq->q.high_mark)))
 			iwl_wake_queue(priv, txq);
 	}
 	if (qc && likely(sta_id != IWL_INVALID_STATION))
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index f229543..b2b841f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -445,7 +445,7 @@ static void iwlagn_rx_reply_tx(struct iwl_priv *priv,
 			iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
 
 			if (priv->mac80211_registered &&
-			    (iwl_queue_space(&txq->q) > txq->q.high_mark) &&
+			    (iwl_queue_space(&txq->q) > atomic_read(&txq->q.high_mark)) &&
 			    (agg->state != IWL_EMPTYING_HW_QUEUE_DELBA))
 				iwl_wake_queue(priv, txq);
 		}
@@ -455,7 +455,7 @@ static void iwlagn_rx_reply_tx(struct iwl_priv *priv,
 		iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
 
 		if (priv->mac80211_registered &&
-		    (iwl_queue_space(&txq->q) > txq->q.high_mark))
+		    (iwl_queue_space(&txq->q) > atomic_read(&txq->q.high_mark)))
 			iwl_wake_queue(priv, txq);
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index bffba7e..0c808f0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -31,6 +31,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/sched.h>
+#include <linux/time.h>
 
 #include "iwl-dev.h"
 #include "iwl-core.h"
@@ -637,7 +638,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	txq = &priv->txq[txq_id];
 	q = &txq->q;
 
-	if (unlikely(iwl_queue_space(q) <= q->high_mark)) {
+	if (unlikely(iwl_queue_space(q) <= atomic_read(&q->high_mark))) {
 		spin_unlock(&priv->sta_lock);
 		goto drop_unlock;
 	}
@@ -788,7 +789,8 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	if (sta_priv && sta_priv->client && !is_agg)
 		atomic_inc(&sta_priv->pending_frames);
 
-	if ((iwl_queue_space(q) <= q->high_mark) && priv->mac80211_registered) {
+	if ((iwl_queue_space(q) <= atomic_read(&q->high_mark))
+	     && priv->mac80211_registered) {
 		if (wait_write_ptr) {
 			spin_lock_irqsave(&priv->lock, flags);
 			txq->need_update = 1;
@@ -1431,7 +1433,7 @@ void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 		int freed = iwlagn_tx_queue_reclaim(priv, scd_flow, index);
 		iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
 
-		if ((iwl_queue_space(&txq->q) > txq->q.high_mark) &&
+		if ((iwl_queue_space(&txq->q) > atomic_read(&txq->q.high_mark)) &&
 		    priv->mac80211_registered &&
 		    (agg->state != IWL_EMPTYING_HW_QUEUE_DELBA))
 			iwl_wake_queue(priv, txq);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index eb6586d..cf9807c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -37,6 +37,7 @@
 #include <linux/wait.h>
 #include <linux/leds.h>
 #include <net/ieee80211_radiotap.h>
+#include <linux/time.h>
 
 #include "iwl-eeprom.h"
 #include "iwl-csr.h"
@@ -134,8 +135,8 @@ struct iwl_queue {
 	dma_addr_t dma_addr;   /* physical addr for BD's */
 	int n_window;	       /* safe queue window */
 	u32 id;
-	int high_mark;         /* high watermark, stop queue if free
-				* space less than this */
+	atomic_t high_mark;    /* high watermark, stop queue if free
+				* space less than or equal to this */
 };
 
 /* One for each TFD */
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 78a9896..1867f99 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -30,6 +30,7 @@
 #include <linux/etherdevice.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/time.h>
 #include <net/mac80211.h>
 #include "iwl-eeprom.h"
 #include "iwl-dev.h"
@@ -254,9 +255,9 @@ static int iwl_queue_init(struct iwl_priv *priv, struct iwl_queue *q,
 	 * get_cmd_index is broken. */
 	BUG_ON(!is_power_of_2(slots_num));
 
-	q->high_mark = q->n_window / 8;
-	if (q->high_mark < 2)
-		q->high_mark = 2;
+	atomic_set(&q->high_mark, q->n_window / 8);
+	if (atomic_read(&q->high_mark) < 2)
+		atomic_set(&q->high_mark, 2);
 
 	q->write_ptr = q->read_ptr = 0;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index e0d4c83..b3f8f3e 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -44,6 +44,7 @@
 #include <linux/firmware.h>
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
+#include <linux/time.h>
 
 #include <net/ieee80211_radiotap.h>
 #include <net/mac80211.h>
@@ -536,7 +537,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	txq = &priv->txq[txq_id];
 	q = &txq->q;
 
-	if ((iwl_queue_space(q) <= q->high_mark))
+	if ((iwl_queue_space(q) <= atomic_read(&q->high_mark)))
 		goto drop;
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -646,7 +647,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	iwl_txq_update_write_ptr(priv, txq);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if ((iwl_queue_space(q) <= q->high_mark)
+	if ((iwl_queue_space(q) <= atomic_read(&q->high_mark))
 	    && priv->mac80211_registered) {
 		if (wait_write_ptr) {
 			spin_lock_irqsave(&priv->lock, flags);
-- 
1.7.1

