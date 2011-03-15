Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54967 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab1COSZk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 14:25:40 -0400
Received: by gwaa18 with SMTP id a18so346623gwa.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Mar 2011 11:25:39 -0700 (PDT)
From: Daniel Halperin <dhalperi@cs.washington.edu>
Content-Type: text/plain; charset=us-ascii
Subject: [PATCH 1/2] iwlwifi: remove aggregation functions from iwlagn lib_ops
Date: Tue, 15 Mar 2011 11:25:36 -0700
Message-Id: <B80E79EB-3856-4A72-985E-ED6C7E841465@cs.washington.edu>
To: linux-wireless <linux-wireless@vger.kernel.org>
Mime-Version: 1.0 (Apple Message framework v1082)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

After the removal of iwlegacy, all iwlagn devices support
these operations.

Signed-off-by: Daniel Halperin <dhalperi@cs.washington.edu>
---
Dan says: is this the right way to do this? Johannes sent
the patch as an addendum to an email, I patchified it. But
he's the author.
---
 drivers/net/wireless/iwlwifi/iwl-1000.c   |    2 --
 drivers/net/wireless/iwlwifi/iwl-2000.c   |    2 --
 drivers/net/wireless/iwlwifi/iwl-5000.c   |    4 ----
 drivers/net/wireless/iwlwifi/iwl-6000.c   |    4 ----
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   17 +++++++----------
 drivers/net/wireless/iwlwifi/iwl-agn.h    |    4 ----
 drivers/net/wireless/iwlwifi/iwl-core.h   |    5 -----
 7 files changed, 7 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 27c5007..2601b55 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -179,8 +179,6 @@ static struct iwl_lib_ops iwl1000_lib = {
 	.txq_update_byte_cnt_tbl = iwlagn_txq_update_byte_cnt_tbl,
 	.txq_inval_byte_cnt_tbl = iwlagn_txq_inval_byte_cnt_tbl,
 	.txq_set_sched = iwlagn_txq_set_sched,
-	.txq_agg_enable = iwlagn_txq_agg_enable,
-	.txq_agg_disable = iwlagn_txq_agg_disable,
 	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = iwl_hw_txq_free_tfd,
 	.txq_init = iwl_hw_tx_queue_init,
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index d7b6126..71bc379 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -259,8 +259,6 @@ static struct iwl_lib_ops iwl2000_lib = {
 	.txq_update_byte_cnt_tbl = iwlagn_txq_update_byte_cnt_tbl,
 	.txq_inval_byte_cnt_tbl = iwlagn_txq_inval_byte_cnt_tbl,
 	.txq_set_sched = iwlagn_txq_set_sched,
-	.txq_agg_enable = iwlagn_txq_agg_enable,
-	.txq_agg_disable = iwlagn_txq_agg_disable,
 	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = iwl_hw_txq_free_tfd,
 	.txq_init = iwl_hw_tx_queue_init,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 3ea31b6..8cab357 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -348,8 +348,6 @@ static struct iwl_lib_ops iwl5000_lib = {
 	.txq_update_byte_cnt_tbl = iwlagn_txq_update_byte_cnt_tbl,
 	.txq_inval_byte_cnt_tbl = iwlagn_txq_inval_byte_cnt_tbl,
 	.txq_set_sched = iwlagn_txq_set_sched,
-	.txq_agg_enable = iwlagn_txq_agg_enable,
-	.txq_agg_disable = iwlagn_txq_agg_disable,
 	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = iwl_hw_txq_free_tfd,
 	.txq_init = iwl_hw_tx_queue_init,
@@ -416,8 +414,6 @@ static struct iwl_lib_ops iwl5150_lib = {
 	.txq_update_byte_cnt_tbl = iwlagn_txq_update_byte_cnt_tbl,
 	.txq_inval_byte_cnt_tbl = iwlagn_txq_inval_byte_cnt_tbl,
 	.txq_set_sched = iwlagn_txq_set_sched,
-	.txq_agg_enable = iwlagn_txq_agg_enable,
-	.txq_agg_disable = iwlagn_txq_agg_disable,
 	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = iwl_hw_txq_free_tfd,
 	.txq_init = iwl_hw_tx_queue_init,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index a745b01..0f0c8e4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -288,8 +288,6 @@ static struct iwl_lib_ops iwl6000_lib = {
 	.txq_update_byte_cnt_tbl = iwlagn_txq_update_byte_cnt_tbl,
 	.txq_inval_byte_cnt_tbl = iwlagn_txq_inval_byte_cnt_tbl,
 	.txq_set_sched = iwlagn_txq_set_sched,
-	.txq_agg_enable = iwlagn_txq_agg_enable,
-	.txq_agg_disable = iwlagn_txq_agg_disable,
 	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = iwl_hw_txq_free_tfd,
 	.txq_init = iwl_hw_tx_queue_init,
@@ -357,8 +355,6 @@ static struct iwl_lib_ops iwl6030_lib = {
 	.txq_update_byte_cnt_tbl = iwlagn_txq_update_byte_cnt_tbl,
 	.txq_inval_byte_cnt_tbl = iwlagn_txq_inval_byte_cnt_tbl,
 	.txq_set_sched = iwlagn_txq_set_sched,
-	.txq_agg_enable = iwlagn_txq_agg_enable,
-	.txq_agg_disable = iwlagn_txq_agg_disable,
 	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = iwl_hw_txq_free_tfd,
 	.txq_init = iwl_hw_tx_queue_init,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index a709d05..23e5667 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -222,8 +222,8 @@ void iwlagn_tx_queue_set_status(struct iwl_priv *priv,
 		       scd_retry ? "BA" : "AC/CMD", txq_id, tx_fifo_id);
 }
 
-int iwlagn_txq_agg_enable(struct iwl_priv *priv, int txq_id,
-			  int tx_fifo, int sta_id, int tid, u16 ssn_idx)
+static int iwlagn_txq_agg_enable(struct iwl_priv *priv, int txq_id,
+				 int tx_fifo, int sta_id, int tid, u16 ssn_idx)
 {
 	unsigned long flags;
 	u16 ra_tid;
@@ -288,8 +288,8 @@ int iwlagn_txq_agg_enable(struct iwl_priv *priv, int txq_id,
 	return 0;
 }
 
-int iwlagn_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
-			   u16 ssn_idx, u8 tx_fifo)
+static int iwlagn_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
+				  u16 ssn_idx, u8 tx_fifo)
 {
 	if ((IWLAGN_FIRST_AMPDU_QUEUE > txq_id) ||
 	    (IWLAGN_FIRST_AMPDU_QUEUE +
@@ -1037,8 +1037,7 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	iwl_set_swq_id(&priv->txq[txq_id], get_ac_from_tid(tid), txq_id);
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
-	ret = priv->cfg->ops->lib->txq_agg_enable(priv, txq_id, tx_fifo,
-						  sta_id, tid, *ssn);
+	ret = iwlagn_txq_agg_enable(priv, txq_id, tx_fifo, sta_id, tid, *ssn);
 	if (ret)
 		return ret;
 
@@ -1125,8 +1124,7 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	 * to deactivate the uCode queue, just return "success" to allow
 	 *  mac80211 to clean up it own data.
 	 */
-	priv->cfg->ops->lib->txq_agg_disable(priv, txq_id, ssn,
-						   tx_fifo_id);
+	iwlagn_txq_agg_disable(priv, txq_id, ssn, tx_fifo_id);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
@@ -1155,8 +1153,7 @@ int iwlagn_txq_check_empty(struct iwl_priv *priv,
 			u16 ssn = SEQ_TO_SN(tid_data->seq_number);
 			int tx_fifo = get_fifo_from_tid(ctx, tid);
 			IWL_DEBUG_HT(priv, "HW queue empty: continue DELBA flow\n");
-			priv->cfg->ops->lib->txq_agg_disable(priv, txq_id,
-							     ssn, tx_fifo);
+			iwlagn_txq_agg_disable(priv, txq_id, ssn, tx_fifo);
 			tid_data->agg.state = IWL_AGG_OFF;
 			ieee80211_stop_tx_ba_cb_irqsafe(ctx->vif, addr, tid);
 		}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 20f8e41..8d918ea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -133,10 +133,6 @@ void iwlagn_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
 				    u16 byte_cnt);
 void iwlagn_txq_inval_byte_cnt_tbl(struct iwl_priv *priv,
 				   struct iwl_tx_queue *txq);
-int iwlagn_txq_agg_enable(struct iwl_priv *priv, int txq_id,
-			  int tx_fifo, int sta_id, int tid, u16 ssn_idx);
-int iwlagn_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
-			   u16 ssn_idx, u8 tx_fifo);
 void iwlagn_txq_set_sched(struct iwl_priv *priv, u32 mask);
 void iwl_free_tfds_in_queue(struct iwl_priv *priv,
 			    int sta_id, int tid, int freed);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index b316d83..1f4f6dd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -171,11 +171,6 @@ struct iwl_lib_ops {
 			     struct iwl_tx_queue *txq);
 	int (*txq_init)(struct iwl_priv *priv,
 			struct iwl_tx_queue *txq);
-	/* aggregations */
-	int (*txq_agg_enable)(struct iwl_priv *priv, int txq_id, int tx_fifo,
-			      int sta_id, int tid, u16 ssn_idx);
-	int (*txq_agg_disable)(struct iwl_priv *priv, u16 txq_id, u16 ssn_idx,
-			       u8 tx_fifo);
 	/* setup Rx handler */
 	void (*rx_handler_setup)(struct iwl_priv *priv);
 	/* setup deferred work */
-- 
1.7.0.4


