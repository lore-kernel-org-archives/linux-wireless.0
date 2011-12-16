Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15336 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760153Ab1LPQhp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 11:37:45 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/24] iwlwifi: tid_data logic move to upper layer - tx AGG setup
Date: Fri, 16 Dec 2011 07:37:14 -0800
Message-Id: <1324049849-831-10-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111216_173805_522603_620F433E)
In-Reply-To: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The tid_data is not related to the transport layer, so move
the logic that depends on it to the upper layer.
This patch deals with tx AGG setup.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |   61 +++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h            |    2 +
 drivers/net/wireless/iwlwifi/iwl-mac80211.c       |   50 +-----------------
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |   17 ++----
 drivers/net/wireless/iwlwifi/iwl-trans.h          |    6 +-
 6 files changed, 74 insertions(+), 64 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 1ec4720..c46d50d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -527,6 +527,67 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	return ret;
 }
 
+int iwlagn_tx_agg_oper(struct iwl_priv *priv, struct ieee80211_vif *vif,
+			struct ieee80211_sta *sta, u16 tid, u8 buf_size)
+{
+	struct iwl_station_priv *sta_priv = (void *) sta->drv_priv;
+	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
+	unsigned long flags;
+	u16 ssn;
+
+	buf_size = min_t(int, buf_size, LINK_QUAL_AGG_FRAME_LIMIT_DEF);
+
+	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
+	ssn = priv->shrd->tid_data[sta_priv->sta_id][tid].agg.ssn;
+	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+
+	iwl_trans_tx_agg_setup(trans(priv), ctx->ctxid, sta_priv->sta_id, tid,
+			       buf_size, ssn);
+
+	/*
+	 * If the limit is 0, then it wasn't initialised yet,
+	 * use the default. We can do that since we take the
+	 * minimum below, and we don't want to go above our
+	 * default due to hardware restrictions.
+	 */
+	if (sta_priv->max_agg_bufsize == 0)
+		sta_priv->max_agg_bufsize =
+			LINK_QUAL_AGG_FRAME_LIMIT_DEF;
+
+	/*
+	 * Even though in theory the peer could have different
+	 * aggregation reorder buffer sizes for different sessions,
+	 * our ucode doesn't allow for that and has a global limit
+	 * for each station. Therefore, use the minimum of all the
+	 * aggregation sessions and our default value.
+	 */
+	sta_priv->max_agg_bufsize =
+		min(sta_priv->max_agg_bufsize, buf_size);
+
+	if (cfg(priv)->ht_params &&
+	    cfg(priv)->ht_params->use_rts_for_aggregation) {
+		/*
+		 * switch to RTS/CTS if it is the prefer protection
+		 * method for HT traffic
+		 */
+
+		sta_priv->lq_sta.lq.general_params.flags |=
+			LINK_QUAL_FLAGS_SET_STA_TLC_RTS_MSK;
+	}
+	priv->agg_tids_count++;
+	IWL_DEBUG_HT(priv, "priv->agg_tids_count = %u\n",
+		     priv->agg_tids_count);
+
+	sta_priv->lq_sta.lq.agg_params.agg_frame_cnt_limit =
+		sta_priv->max_agg_bufsize;
+
+	IWL_INFO(priv, "Tx aggregation enabled on ra = %pM tid = %d\n",
+		 sta->addr, tid);
+
+	return iwl_send_lq_cmd(priv, ctx,
+			&sta_priv->lq_sta.lq, CMD_ASYNC, false);
+}
+
 static void iwlagn_non_agg_tx_status(struct iwl_priv *priv,
 				     struct iwl_rxon_context *ctx,
 				     const u8 *addr1)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index eb453ea..66bcd3e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -137,6 +137,8 @@ void iwl_setup_rx_handlers(struct iwl_priv *priv);
 int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb);
 int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 			struct ieee80211_sta *sta, u16 tid, u16 *ssn);
+int iwlagn_tx_agg_oper(struct iwl_priv *priv, struct ieee80211_vif *vif,
+			struct ieee80211_sta *sta, u16 tid, u8 buf_size);
 int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta, u16 tid);
 int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 4aedd72..8074c6e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -611,7 +611,6 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 	struct iwl_priv *priv = hw->priv;
 	int ret = -EINVAL;
 	struct iwl_station_priv *sta_priv = (void *) sta->drv_priv;
-	struct iwl_rxon_context *ctx =  iwl_rxon_ctx_from_vif(vif);
 
 	IWL_DEBUG_HT(priv, "A-MPDU action on addr %pM tid %d\n",
 		     sta->addr, tid);
@@ -659,54 +658,7 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 		}
 		break;
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
-		buf_size = min_t(int, buf_size, LINK_QUAL_AGG_FRAME_LIMIT_DEF);
-
-		iwl_trans_tx_agg_setup(trans(priv), ctx->ctxid, iwl_sta_id(sta),
-				tid, buf_size);
-
-		/*
-		 * If the limit is 0, then it wasn't initialised yet,
-		 * use the default. We can do that since we take the
-		 * minimum below, and we don't want to go above our
-		 * default due to hardware restrictions.
-		 */
-		if (sta_priv->max_agg_bufsize == 0)
-			sta_priv->max_agg_bufsize =
-				LINK_QUAL_AGG_FRAME_LIMIT_DEF;
-
-		/*
-		 * Even though in theory the peer could have different
-		 * aggregation reorder buffer sizes for different sessions,
-		 * our ucode doesn't allow for that and has a global limit
-		 * for each station. Therefore, use the minimum of all the
-		 * aggregation sessions and our default value.
-		 */
-		sta_priv->max_agg_bufsize =
-			min(sta_priv->max_agg_bufsize, buf_size);
-
-		if (cfg(priv)->ht_params &&
-		    cfg(priv)->ht_params->use_rts_for_aggregation) {
-			/*
-			 * switch to RTS/CTS if it is the prefer protection
-			 * method for HT traffic
-			 */
-
-			sta_priv->lq_sta.lq.general_params.flags |=
-				LINK_QUAL_FLAGS_SET_STA_TLC_RTS_MSK;
-		}
-		priv->agg_tids_count++;
-		IWL_DEBUG_HT(priv, "priv->agg_tids_count = %u\n",
-			     priv->agg_tids_count);
-
-		sta_priv->lq_sta.lq.agg_params.agg_frame_cnt_limit =
-			sta_priv->max_agg_bufsize;
-
-		iwl_send_lq_cmd(priv, iwl_rxon_ctx_from_vif(vif),
-				&sta_priv->lq_sta.lq, CMD_ASYNC, false);
-
-		IWL_INFO(priv, "Tx aggregation enabled on ra = %pM tid = %d\n",
-			 sta->addr, tid);
-		ret = 0;
+		ret = iwlagn_tx_agg_oper(priv, vif, sta, tid, buf_size);
 		break;
 	}
 	mutex_unlock(&priv->shrd->mutex);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index 395c9f4..49ff85f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -289,7 +289,7 @@ void iwl_trans_tx_queue_set_status(struct iwl_trans *trans,
 int iwl_trans_pcie_tx_agg_alloc(struct iwl_trans *trans, int sta_id, int tid);
 void iwl_trans_pcie_tx_agg_setup(struct iwl_trans *trans,
 				 enum iwl_rxon_context_id ctx,
-				 int sta_id, int tid, int frame_limit);
+				 int sta_id, int tid, int frame_limit, u16 ssn);
 void iwlagn_txq_free_tfd(struct iwl_trans *trans, struct iwl_tx_queue *txq,
 	int index, enum dma_data_direction dma_dir);
 int iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index 28be8a6..d9d4221 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -448,12 +448,11 @@ static inline int get_fifo_from_tid(struct iwl_trans_pcie *trans_pcie,
 
 void iwl_trans_pcie_tx_agg_setup(struct iwl_trans *trans,
 				 enum iwl_rxon_context_id ctx, int sta_id,
-				 int tid, int frame_limit)
+				 int tid, int frame_limit, u16 ssn)
 {
-	int tx_fifo, txq_id, ssn_idx;
+	int tx_fifo, txq_id;
 	u16 ra_tid;
 	unsigned long flags;
-	struct iwl_tid_data *tid_data;
 
 	struct iwl_trans_pcie *trans_pcie =
 		IWL_TRANS_GET_PCIE_TRANS(trans);
@@ -469,11 +468,7 @@ void iwl_trans_pcie_tx_agg_setup(struct iwl_trans *trans,
 		return;
 	}
 
-	spin_lock_irqsave(&trans->shrd->sta_lock, flags);
-	tid_data = &trans->shrd->tid_data[sta_id][tid];
-	ssn_idx = SEQ_TO_SN(tid_data->seq_number);
-	txq_id = tid_data->agg.txq_id;
-	spin_unlock_irqrestore(&trans->shrd->sta_lock, flags);
+	txq_id = trans->shrd->tid_data[sta_id][tid].agg.txq_id;
 
 	ra_tid = BUILD_RAxTID(sta_id, tid);
 
@@ -493,9 +488,9 @@ void iwl_trans_pcie_tx_agg_setup(struct iwl_trans *trans,
 
 	/* Place first TFD at index corresponding to start sequence number.
 	 * Assumes that ssn_idx is valid (!= 0xFFF) */
-	trans_pcie->txq[txq_id].q.read_ptr = (ssn_idx & 0xff);
-	trans_pcie->txq[txq_id].q.write_ptr = (ssn_idx & 0xff);
-	iwl_trans_set_wr_ptrs(trans, txq_id, ssn_idx);
+	trans_pcie->txq[txq_id].q.read_ptr = (ssn & 0xff);
+	trans_pcie->txq[txq_id].q.write_ptr = (ssn & 0xff);
+	iwl_trans_set_wr_ptrs(trans, txq_id, ssn);
 
 	/* Set up Tx window size and frame limit for this queue */
 	iwl_write_targ_mem(bus(trans), trans_pcie->scd_base_addr +
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 134d5f2..f8d27a7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -189,7 +189,7 @@ struct iwl_trans_ops {
 			    int sta_id, int tid);
 	void (*tx_agg_setup)(struct iwl_trans *trans,
 			     enum iwl_rxon_context_id ctx, int sta_id, int tid,
-			     int frame_limit);
+			     int frame_limit, u16 ssn);
 
 	void (*kick_nic)(struct iwl_trans *trans);
 
@@ -331,9 +331,9 @@ static inline int iwl_trans_tx_agg_alloc(struct iwl_trans *trans,
 static inline void iwl_trans_tx_agg_setup(struct iwl_trans *trans,
 					   enum iwl_rxon_context_id ctx,
 					   int sta_id, int tid,
-					   int frame_limit)
+					   int frame_limit, u16 ssn)
 {
-	trans->ops->tx_agg_setup(trans, ctx, sta_id, tid, frame_limit);
+	trans->ops->tx_agg_setup(trans, ctx, sta_id, tid, frame_limit, ssn);
 }
 
 static inline void iwl_trans_kick_nic(struct iwl_trans *trans)
-- 
1.7.0.4

