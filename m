Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59271 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758176Ab1COSZv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 14:25:51 -0400
Received: by gyf1 with SMTP id 1so343136gyf.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Mar 2011 11:25:51 -0700 (PDT)
From: Daniel Halperin <dhalperi@cs.washington.edu>
Content-Type: text/plain; charset=us-ascii
Subject: [PATCH 2/2] iwlwifi: setup agg queues with correct aggregation parameters 
Date: Tue, 15 Mar 2011 11:25:49 -0700
Message-Id: <365ABD23-2A8B-4024-A039-879BAB879031@cs.washington.edu>
To: linux-wireless <linux-wireless@vger.kernel.org>
Mime-Version: 1.0 (Apple Message framework v1082)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

See this thread for more information:
http://comments.gmane.org/gmane.linux.kernel.wireless.general/66236

> the window size and frame limit should
> both match the information about the aggregation session, and be limited
> to what we and the peer would like to see.
>
> The bad thing is that we set up the queue when we get
> IEEE80211_AMPDU_TX_START, but we only know the window size when we get
> IEEE80211_AMPDU_TX_OPERATIONAL. However, I think we can change this
> since the first TX to the queue will only happen after _OPERATIONAL. We
> just need to refactor iwlagn_tx_agg_start() into the parts that can
> fail, and the parts that don't.

From: Johannes Berg <johannes@sipsolutions.net>
Tested-by: Daniel Halperin <dhalperi@cs.washington.edu>
Signed-off-by: Daniel Halperin <dhalperi@cs.washington.edu>
---
Dan says: ditto from previous patch.
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   46 +++++++++++++++++++---------
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    4 ++
 drivers/net/wireless/iwlwifi/iwl-agn.h    |    3 ++
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    1 +
 4 files changed, 39 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 23e5667..b1869cc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -223,12 +223,8 @@ void iwlagn_tx_queue_set_status(struct iwl_priv *priv,
 }
 
 static int iwlagn_txq_agg_enable(struct iwl_priv *priv, int txq_id,
-				 int tx_fifo, int sta_id, int tid, u16 ssn_idx)
+				 int sta_id, int tid)
 {
-	unsigned long flags;
-	u16 ra_tid;
-	int ret;
-
 	if ((IWLAGN_FIRST_AMPDU_QUEUE > txq_id) ||
 	    (IWLAGN_FIRST_AMPDU_QUEUE +
 		priv->cfg->base_params->num_of_ampdu_queues <= txq_id)) {
@@ -240,12 +236,33 @@ static int iwlagn_txq_agg_enable(struct iwl_priv *priv, int txq_id,
 		return -EINVAL;
 	}
 
-	ra_tid = BUILD_RAxTID(sta_id, tid);
-
 	/* Modify device's station table to Tx this TID */
-	ret = iwl_sta_tx_modify_enable_tid(priv, sta_id, tid);
-	if (ret)
-		return ret;
+	return iwl_sta_tx_modify_enable_tid(priv, sta_id, tid);
+}
+
+void iwlagn_txq_agg_queue_setup(struct iwl_priv *priv,
+				struct ieee80211_sta *sta,
+				int tid, int frame_limit)
+{
+	int sta_id, tx_fifo, txq_id, ssn_idx;
+	u16 ra_tid;
+	unsigned long flags;
+	struct iwl_tid_data *tid_data;
+
+	sta_id = iwl_sta_id(sta);
+	if (WARN_ON(sta_id == IWL_INVALID_STATION))
+		return;
+	if (WARN_ON(tid >= MAX_TID_COUNT))
+		return;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	tid_data = &priv->stations[sta_id].tid[tid];
+	ssn_idx = SEQ_TO_SN(tid_data->seq_number);
+	txq_id = tid_data->agg.txq_id;
+	tx_fifo = tid_data->agg.tx_fifo;
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	ra_tid = BUILD_RAxTID(sta_id, tid);
 
 	spin_lock_irqsave(&priv->lock, flags);
 
@@ -271,10 +288,10 @@ static int iwlagn_txq_agg_enable(struct iwl_priv *priv, int txq_id,
 	iwl_write_targ_mem(priv, priv->scd_base_addr +
 			IWLAGN_SCD_CONTEXT_QUEUE_OFFSET(txq_id) +
 			sizeof(u32),
-			((SCD_WIN_SIZE <<
+			((frame_limit <<
 			IWLAGN_SCD_QUEUE_CTX_REG2_WIN_SIZE_POS) &
 			IWLAGN_SCD_QUEUE_CTX_REG2_WIN_SIZE_MSK) |
-			((SCD_FRAME_LIMIT <<
+			((frame_limit <<
 			IWLAGN_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS) &
 			IWLAGN_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK));
 
@@ -284,8 +301,6 @@ static int iwlagn_txq_agg_enable(struct iwl_priv *priv, int txq_id,
 	iwlagn_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 1);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
-
-	return 0;
 }
 
 static int iwlagn_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
@@ -1034,10 +1049,11 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	tid_data = &priv->stations[sta_id].tid[tid];
 	*ssn = SEQ_TO_SN(tid_data->seq_number);
 	tid_data->agg.txq_id = txq_id;
+	tid_data->agg.tx_fifo = tx_fifo;
 	iwl_set_swq_id(&priv->txq[txq_id], get_ac_from_tid(tid), txq_id);
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
-	ret = iwlagn_txq_agg_enable(priv, txq_id, tx_fifo, sta_id, tid, *ssn);
+	ret = iwlagn_txq_agg_enable(priv, txq_id, sta_id, tid);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index b57fbbf..8fdd174 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3345,6 +3345,10 @@ int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 		}
 		break;
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
+		buf_size = min_t(int, buf_size, LINK_QUAL_AGG_FRAME_LIMIT_DEF);
+
+		iwlagn_txq_agg_queue_setup(priv, sta, tid, buf_size);
+
 		/*
 		 * If the limit is 0, then it wasn't initialised yet,
 		 * use the default. We can do that since we take the
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 8d918ea..4f7c9ce 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -202,6 +202,9 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 			struct ieee80211_sta *sta, u16 tid, u16 *ssn);
 int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta, u16 tid);
+void iwlagn_txq_agg_queue_setup(struct iwl_priv *priv,
+				struct ieee80211_sta *sta,
+				int tid, int frame_limit);
 int iwlagn_txq_check_empty(struct iwl_priv *priv,
 			   int sta_id, u8 tid, int txq_id);
 void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 68b953f..a5d438d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -416,6 +416,7 @@ struct iwl_ht_agg {
 #define IWL_EMPTYING_HW_QUEUE_ADDBA 2
 #define IWL_EMPTYING_HW_QUEUE_DELBA 3
 	u8 state;
+	u8 tx_fifo;
 };
 
 
-- 
1.7.0.4


