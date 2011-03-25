Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:10700 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459Ab1CYObh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2011 10:31:37 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/12] iwlagn: clean up TX aggregation code
Date: Fri, 25 Mar 2011 07:14:07 -0700
Message-Id: <1301062456-17249-4-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1301062456-17249-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1301062456-17249-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since the driver split, there's no need for
function pointers any more for aggregation
queue setup and teardown as all devices now
share the same code. Simplify this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
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
index e8e1c2d..9631d8f 100644
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
index b1dbe93..55274a1 100644
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
index 90e727b..4064490 100644
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
index 40e0226..7ecfbbc 100644
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

