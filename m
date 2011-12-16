Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27087 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759892Ab1LPQhl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 11:37:41 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 12/24] iwlwifi: tid_data logic move to upper layer - seq_number
Date: Fri, 16 Dec 2011 07:37:17 -0800
Message-Id: <1324049849-831-13-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111216_173753_522972_2DF1DFB7)
In-Reply-To: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The tid_data is not related to the transport layer, so move
the logic that depends on it to the upper layer.
This patch deals with the seq_number.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c     |   30 ++++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |   21 +----------------
 drivers/net/wireless/iwlwifi/iwl-trans.h      |    6 ++--
 3 files changed, 31 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index a76799d..8db9144 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -262,8 +262,8 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	__le16 fc;
 	u8 hdr_len;
-	u16 len;
-	u8 sta_id;
+	u16 len, seq_number = 0;
+	u8 sta_id, tid = IWL_MAX_TID_COUNT;
 	unsigned long flags;
 	bool is_agg = false;
 
@@ -368,9 +368,33 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	info->driver_data[0] = ctx;
 	info->driver_data[1] = dev_cmd;
 
-	if (iwl_trans_tx(trans(priv), skb, dev_cmd, ctx->ctxid, sta_id))
+	if (ieee80211_is_data_qos(fc) && !ieee80211_is_qos_nullfunc(fc)) {
+		u8 *qc = NULL;
+		struct iwl_tid_data *tid_data;
+		qc = ieee80211_get_qos_ctl(hdr);
+		tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
+		if (WARN_ON_ONCE(tid >= IWL_MAX_TID_COUNT))
+			goto drop_unlock_sta;
+		tid_data = &priv->shrd->tid_data[sta_id][tid];
+
+		seq_number = tid_data->seq_number;
+		seq_number &= IEEE80211_SCTL_SEQ;
+		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
+		hdr->seq_ctrl |= cpu_to_le16(seq_number);
+		seq_number += 0x10;
+	}
+
+	/* Copy MAC header from skb into command buffer */
+	memcpy(tx_cmd->hdr, hdr, hdr_len);
+
+	if (iwl_trans_tx(trans(priv), skb, dev_cmd, ctx->ctxid, sta_id, tid))
 		goto drop_unlock_sta;
 
+	if (ieee80211_is_data_qos(fc) && !ieee80211_is_qos_nullfunc(fc) &&
+	    !ieee80211_has_morefrags(fc))
+		priv->shrd->tid_data[sta_id][tid].seq_number =
+				seq_number;
+
 	spin_unlock(&priv->shrd->sta_lock);
 	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 801e0c9..06db602 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1044,7 +1044,7 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 
 static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		struct iwl_device_cmd *dev_cmd, enum iwl_rxon_context_id ctx,
-		u8 sta_id)
+		u8 sta_id, u8 tid)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
@@ -1061,7 +1061,6 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	u16 seq_number = 0;
 	u8 wait_write_ptr = 0;
 	u8 txq_id;
-	u8 tid = 0;
 	bool is_agg = false;
 	__le16 fc = hdr->frame_control;
 	u8 hdr_len = ieee80211_hdrlen(fc);
@@ -1086,20 +1085,11 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		    trans_pcie->ac_to_queue[ctx][skb_get_queue_mapping(skb)];
 
 	if (ieee80211_is_data_qos(fc) && !ieee80211_is_qos_nullfunc(fc)) {
-		u8 *qc = NULL;
 		struct iwl_tid_data *tid_data;
-		qc = ieee80211_get_qos_ctl(hdr);
-		tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
 		tid_data = &trans->shrd->tid_data[sta_id][tid];
-
 		if (WARN_ON_ONCE(tid >= IWL_MAX_TID_COUNT))
 			return -1;
 
-		seq_number = tid_data->seq_number;
-		seq_number &= IEEE80211_SCTL_SEQ;
-		hdr->seq_ctrl = hdr->seq_ctrl &
-				cpu_to_le16(IEEE80211_SCTL_FRAG);
-		hdr->seq_ctrl |= cpu_to_le16(seq_number);
 		/* aggregation is on for this <sta,tid> */
 		if (info->flags & IEEE80211_TX_CTL_AMPDU) {
 			if (WARN_ON_ONCE(tid_data->agg.state != IWL_AGG_ON)) {
@@ -1114,12 +1104,8 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 			txq_id = trans_pcie->agg_txq[sta_id][tid];
 			is_agg = true;
 		}
-		seq_number += 0x10;
 	}
 
-	/* Copy MAC header from skb into command buffer */
-	memcpy(tx_cmd->hdr, hdr, hdr_len);
-
 	txq = &trans_pcie->txq[txq_id];
 	q = &txq->q;
 
@@ -1222,11 +1208,6 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
 	iwl_txq_update_write_ptr(trans, txq);
 
-	if (ieee80211_is_data_qos(fc) && !ieee80211_is_qos_nullfunc(fc) &&
-	    !ieee80211_has_morefrags(fc))
-			trans->shrd->tid_data[sta_id][tid].seq_number =
-				seq_number;
-
 	/*
 	 * At this point the frame is "transmitted" successfully
 	 * and we will get a TX status notification eventually,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 8658ce2..e6bf3f5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -178,7 +178,7 @@ struct iwl_trans_ops {
 
 	int (*tx)(struct iwl_trans *trans, struct sk_buff *skb,
 		struct iwl_device_cmd *dev_cmd, enum iwl_rxon_context_id ctx,
-		u8 sta_id);
+		u8 sta_id, u8 tid);
 	int (*reclaim)(struct iwl_trans *trans, int sta_id, int tid,
 			int txq_id, int ssn, u32 status,
 			struct sk_buff_head *skbs);
@@ -303,9 +303,9 @@ int iwl_trans_send_cmd_pdu(struct iwl_trans *trans, u8 id,
 
 static inline int iwl_trans_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		struct iwl_device_cmd *dev_cmd, enum iwl_rxon_context_id ctx,
-		u8 sta_id)
+		u8 sta_id, u8 tid)
 {
-	return trans->ops->tx(trans, skb, dev_cmd, ctx, sta_id);
+	return trans->ops->tx(trans, skb, dev_cmd, ctx, sta_id, tid);
 }
 
 static inline int iwl_trans_reclaim(struct iwl_trans *trans, int sta_id,
-- 
1.7.0.4

