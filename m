Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:49315 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932685Ab0EMVuV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 17:50:21 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 09/17] iwlwifi: fix and add missing sta_lock usage
Date: Thu, 13 May 2010 14:49:51 -0700
Message-Id: <1273787399-9280-10-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273787399-9280-1-git-send-email-reinette.chatre@intel.com>
References: <1273787399-9280-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

There are a few places where sta_lock is used, but the
station information protected by it is accessed outside
of the lock. Address this in two ways, if the access
won't sleep then just move the access into the lock, if
the access can sleep then copy the needed station
information to the stack to be accessed without risk of
it changing while access in progress.

Additionally, a number of other places access station
station information without holding the sta_lock, fix
those as well.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    9 +---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    5 ++-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    7 +++-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c   |   41 ++++++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    4 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c      |   56 +++++++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    5 +-
 7 files changed, 85 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 0eb0faa..5ffbce8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -946,8 +946,7 @@ void iwl3945_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 		       tx_cmd->supp_rates[1], tx_cmd->supp_rates[0]);
 }
 
-static u8 iwl3945_sync_sta(struct iwl_priv *priv, int sta_id,
-			   u16 tx_rate, u8 flags)
+static u8 iwl3945_sync_sta(struct iwl_priv *priv, int sta_id, u16 tx_rate)
 {
 	unsigned long flags_spin;
 	struct iwl_station_entry *station;
@@ -961,10 +960,9 @@ static u8 iwl3945_sync_sta(struct iwl_priv *priv, int sta_id,
 	station->sta.sta.modify_mask = STA_MODIFY_TX_RATE_MSK;
 	station->sta.rate_n_flags = cpu_to_le16(tx_rate);
 	station->sta.mode = STA_CONTROL_MODIFY_MSK;
-
+	iwl_send_add_sta(priv, &station->sta, CMD_ASYNC);
 	spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
 
-	iwl_send_add_sta(priv, &station->sta, flags);
 	IWL_DEBUG_RATE(priv, "SCALE sync station %d to rate %d\n",
 			sta_id, tx_rate);
 	return sta_id;
@@ -2472,8 +2470,7 @@ static int iwl3945_manage_ibss_station(struct iwl_priv *priv,
 
 		iwl3945_sync_sta(priv, vif_priv->ibss_bssid_sta_id,
 				 (priv->band == IEEE80211_BAND_5GHZ) ?
-				 IWL_RATE_6M_PLCP : IWL_RATE_1M_PLCP,
-				 CMD_ASYNC);
+				 IWL_RATE_6M_PLCP : IWL_RATE_1M_PLCP);
 		iwl3945_rate_scale_init(priv->hw, vif_priv->ibss_bssid_sta_id);
 
 		return 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 03b066c..ad4d7d1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2026,6 +2026,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 	int sta_id;
 	int freed;
 	u8 *qc = NULL;
+	unsigned long flags;
 
 	if ((index >= txq->q.n_bd) || (iwl_queue_used(&txq->q, index) == 0)) {
 		IWL_ERR(priv, "Read index for DMA queue txq_id (%d) index %d "
@@ -2050,10 +2051,10 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 		return;
 	}
 
+	spin_lock_irqsave(&priv->sta_lock, flags);
 	if (txq->sched_retry) {
 		const u32 scd_ssn = iwl4965_get_scd_ssn(tx_resp);
 		struct iwl_ht_agg *agg = NULL;
-
 		WARN_ON(!qc);
 
 		agg = &priv->stations[sta_id].tid[tid].agg;
@@ -2110,6 +2111,8 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 		iwlagn_txq_check_empty(priv, sta_id, tid, txq_id);
 
 	iwl_check_abort_status(priv, tx_resp->frame_count, status);
+
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
 }
 
 static int iwl4965_calc_rssi(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 5f07bc2..4857b5f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -184,6 +184,7 @@ static void iwlagn_rx_reply_tx(struct iwl_priv *priv,
 	int tid;
 	int sta_id;
 	int freed;
+	unsigned long flags;
 
 	if ((index >= txq->q.n_bd) || (iwl_queue_used(&txq->q, index) == 0)) {
 		IWL_ERR(priv, "Read index for DMA queue txq_id (%d) index %d "
@@ -199,9 +200,10 @@ static void iwlagn_rx_reply_tx(struct iwl_priv *priv,
 	tid = (tx_resp->ra_tid & IWL50_TX_RES_TID_MSK) >> IWL50_TX_RES_TID_POS;
 	sta_id = (tx_resp->ra_tid & IWL50_TX_RES_RA_MSK) >> IWL50_TX_RES_RA_POS;
 
+	spin_lock_irqsave(&priv->sta_lock, flags);
 	if (txq->sched_retry) {
 		const u32 scd_ssn = iwlagn_get_scd_ssn(tx_resp);
-		struct iwl_ht_agg *agg = NULL;
+		struct iwl_ht_agg *agg;
 
 		agg = &priv->stations[sta_id].tid[tid].agg;
 
@@ -256,6 +258,7 @@ static void iwlagn_rx_reply_tx(struct iwl_priv *priv,
 	iwlagn_txq_check_empty(priv, sta_id, tid, txq_id);
 
 	iwl_check_abort_status(priv, tx_resp->frame_count, status);
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
 }
 
 void iwlagn_rx_handler_setup(struct iwl_priv *priv)
@@ -1533,6 +1536,8 @@ int iwlagn_manage_ibss_station(struct iwl_priv *priv,
 void iwl_free_tfds_in_queue(struct iwl_priv *priv,
 			    int sta_id, int tid, int freed)
 {
+	WARN_ON(!spin_is_locked(&priv->sta_lock));
+
 	if (priv->stations[sta_id].tid[tid].tfds_in_queue >= freed)
 		priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
 	else {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 18b1546..52bec10 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -595,11 +595,17 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	}
 
 	txq_id = get_queue_from_ac(skb_get_queue_mapping(skb));
+
+	/* irqs already disabled/saved above when locking priv->lock */
+	spin_lock(&priv->sta_lock);
+
 	if (ieee80211_is_data_qos(fc)) {
 		qc = ieee80211_get_qos_ctl(hdr);
 		tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
-		if (unlikely(tid >= MAX_TID_COUNT))
+		if (WARN_ON_ONCE(tid >= MAX_TID_COUNT)) {
+			spin_unlock(&priv->sta_lock);
 			goto drop_unlock;
+		}
 		seq_number = priv->stations[sta_id].tid[tid].seq_number;
 		seq_number &= IEEE80211_SCTL_SEQ;
 		hdr->seq_ctrl = hdr->seq_ctrl &
@@ -617,11 +623,18 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	swq_id = txq->swq_id;
 	q = &txq->q;
 
-	if (unlikely(iwl_queue_space(q) < q->high_mark))
+	if (unlikely(iwl_queue_space(q) < q->high_mark)) {
+		spin_unlock(&priv->sta_lock);
 		goto drop_unlock;
+	}
 
-	if (ieee80211_is_data_qos(fc))
+	if (ieee80211_is_data_qos(fc)) {
 		priv->stations[sta_id].tid[tid].tfds_in_queue++;
+		if (!ieee80211_has_morefrags(fc))
+			priv->stations[sta_id].tid[tid].seq_number = seq_number;
+	}
+
+	spin_unlock(&priv->sta_lock);
 
 	/* Set up driver data for this TFD */
 	memset(&(txq->txb[q->write_ptr]), 0, sizeof(struct iwl_tx_info));
@@ -700,8 +713,6 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	if (!ieee80211_has_morefrags(hdr->frame_control)) {
 		txq->need_update = 1;
-		if (qc)
-			priv->stations[sta_id].tid[tid].seq_number = seq_number;
 	} else {
 		wait_write_ptr = 1;
 		txq->need_update = 0;
@@ -1006,6 +1017,8 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	if (ret)
 		return ret;
 
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	tid_data = &priv->stations[sta_id].tid[tid];
 	if (tid_data->tfds_in_queue == 0) {
 		IWL_DEBUG_HT(priv, "HW queue is empty\n");
 		tid_data->agg.state = IWL_AGG_ON;
@@ -1015,6 +1028,7 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 			     tid_data->tfds_in_queue);
 		tid_data->agg.state = IWL_EMPTYING_HW_QUEUE_ADDBA;
 	}
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
 	return ret;
 }
 
@@ -1037,11 +1051,14 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 		return -ENXIO;
 	}
 
+	spin_lock_irqsave(&priv->sta_lock, flags);
+
 	if (priv->stations[sta_id].tid[tid].agg.state ==
 				IWL_EMPTYING_HW_QUEUE_ADDBA) {
 		IWL_DEBUG_HT(priv, "AGG stop before setup done\n");
 		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		priv->stations[sta_id].tid[tid].agg.state = IWL_AGG_OFF;
+		spin_unlock_irqrestore(&priv->sta_lock, flags);
 		return 0;
 	}
 
@@ -1059,13 +1076,17 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 		IWL_DEBUG_HT(priv, "Stopping a non empty AGG HW QUEUE\n");
 		priv->stations[sta_id].tid[tid].agg.state =
 				IWL_EMPTYING_HW_QUEUE_DELBA;
+		spin_unlock_irqrestore(&priv->sta_lock, flags);
 		return 0;
 	}
 
 	IWL_DEBUG_HT(priv, "HW queue is empty\n");
 	priv->stations[sta_id].tid[tid].agg.state = IWL_AGG_OFF;
 
-	spin_lock_irqsave(&priv->lock, flags);
+	/* do not restore/save irqs */
+	spin_unlock(&priv->sta_lock);
+	spin_lock(&priv->lock);
+
 	/*
 	 * the only reason this call can fail is queue number out of range,
 	 * which can happen if uCode is reloaded and all the station
@@ -1089,6 +1110,8 @@ int iwlagn_txq_check_empty(struct iwl_priv *priv,
 	u8 *addr = priv->stations[sta_id].sta.sta.addr;
 	struct iwl_tid_data *tid_data = &priv->stations[sta_id].tid[tid];
 
+	WARN_ON(!spin_is_locked(&priv->sta_lock));
+
 	switch (priv->stations[sta_id].tid[tid].agg.state) {
 	case IWL_EMPTYING_HW_QUEUE_DELBA:
 		/* We are reclaiming the last packet of the */
@@ -1113,6 +1136,7 @@ int iwlagn_txq_check_empty(struct iwl_priv *priv,
 		}
 		break;
 	}
+
 	return 0;
 }
 
@@ -1276,6 +1300,7 @@ void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 	int index;
 	int sta_id;
 	int tid;
+	unsigned long flags;
 
 	/* "flow" corresponds to Tx queue */
 	u16 scd_flow = le16_to_cpu(ba_resp->scd_flow);
@@ -1298,7 +1323,7 @@ void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 	/* Find index just before block-ack window */
 	index = iwl_queue_dec_wrap(ba_resp_scd_ssn & 0xff, txq->q.n_bd);
 
-	/* TODO: Need to get this copy more safely - now good for debug */
+	spin_lock_irqsave(&priv->sta_lock, flags);
 
 	IWL_DEBUG_TX_REPLY(priv, "REPLY_COMPRESSED_BA [%d] Received from %pM, "
 			   "sta_id = %d\n",
@@ -1334,4 +1359,6 @@ void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 
 		iwlagn_txq_check_empty(priv, sta_id, tid, scd_flow);
 	}
+
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 8538af7..5ac03f5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1224,7 +1224,9 @@ struct iwl_priv {
 	u8 bssid[ETH_ALEN]; /* used only on 3945 but filled by core */
 	u8 mac_addr[ETH_ALEN];
 
-	/*station table variables */
+	/* station table variables */
+
+	/* Note: if lock and sta_lock are needed, lock must be acquired first */
 	spinlock_t sta_lock;
 	int num_stations;
 	struct iwl_station_entry stations[IWL_STATION_COUNT];
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 2eafba6..4d878d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -311,10 +311,10 @@ int iwl_add_station_common(struct iwl_priv *priv, const u8 *addr,
 				  struct ieee80211_sta_ht_cap *ht_info,
 				  u8 *sta_id_r)
 {
-	struct iwl_station_entry *station;
 	unsigned long flags_spin;
 	int ret = 0;
 	u8 sta_id;
+	struct iwl_addsta_cmd sta_cmd;
 
 	*sta_id_r = 0;
 	spin_lock_irqsave(&priv->sta_lock, flags_spin);
@@ -347,14 +347,15 @@ int iwl_add_station_common(struct iwl_priv *priv, const u8 *addr,
 	}
 
 	priv->stations[sta_id].used |= IWL_STA_UCODE_INPROGRESS;
-	station = &priv->stations[sta_id];
+	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(struct iwl_addsta_cmd));
 	spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
 
 	/* Add station to device's station table */
-	ret = iwl_send_add_sta(priv, &station->sta, CMD_SYNC);
+	ret = iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
 	if (ret) {
-		IWL_ERR(priv, "Adding station %pM failed.\n", station->sta.sta.addr);
 		spin_lock_irqsave(&priv->sta_lock, flags_spin);
+		IWL_ERR(priv, "Adding station %pM failed.\n",
+			priv->stations[sta_id].sta.sta.addr);
 		priv->stations[sta_id].used &= ~IWL_STA_DRIVER_ACTIVE;
 		priv->stations[sta_id].used &= ~IWL_STA_UCODE_INPROGRESS;
 		spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
@@ -488,7 +489,7 @@ static void iwl_sta_ucode_deactivate(struct iwl_priv *priv, u8 sta_id)
 }
 
 static int iwl_send_remove_station(struct iwl_priv *priv,
-				   struct iwl_station_entry *station)
+				   const u8 *addr, int sta_id)
 {
 	struct iwl_rx_packet *pkt;
 	int ret;
@@ -505,7 +506,7 @@ static int iwl_send_remove_station(struct iwl_priv *priv,
 
 	memset(&rm_sta_cmd, 0, sizeof(rm_sta_cmd));
 	rm_sta_cmd.num_sta = 1;
-	memcpy(&rm_sta_cmd.addr, &station->sta.sta.addr , ETH_ALEN);
+	memcpy(&rm_sta_cmd.addr, addr, ETH_ALEN);
 
 	cmd.flags |= CMD_WANT_SKB;
 
@@ -525,7 +526,7 @@ static int iwl_send_remove_station(struct iwl_priv *priv,
 		switch (pkt->u.rem_sta.status) {
 		case REM_STA_SUCCESS_MSK:
 			spin_lock_irqsave(&priv->sta_lock, flags_spin);
-			iwl_sta_ucode_deactivate(priv, station->sta.sta.sta_id);
+			iwl_sta_ucode_deactivate(priv, sta_id);
 			spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
 			IWL_DEBUG_ASSOC(priv, "REPLY_REMOVE_STA PASSED\n");
 			break;
@@ -546,7 +547,6 @@ static int iwl_send_remove_station(struct iwl_priv *priv,
 int iwl_remove_station(struct iwl_priv *priv, const u8 sta_id,
 		       const u8 *addr)
 {
-	struct iwl_station_entry *station;
 	unsigned long flags;
 
 	if (!iwl_is_ready(priv)) {
@@ -592,10 +592,9 @@ int iwl_remove_station(struct iwl_priv *priv, const u8 sta_id,
 
 	BUG_ON(priv->num_stations < 0);
 
-	station = &priv->stations[sta_id];
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
-	return iwl_send_remove_station(priv, station);
+	return iwl_send_remove_station(priv, addr, sta_id);
 out_err:
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 	return -EINVAL;
@@ -643,11 +642,13 @@ EXPORT_SYMBOL(iwl_clear_ucode_stations);
  */
 void iwl_restore_stations(struct iwl_priv *priv)
 {
-	struct iwl_station_entry *station;
+	struct iwl_addsta_cmd sta_cmd;
+	struct iwl_link_quality_cmd lq;
 	unsigned long flags_spin;
 	int i;
 	bool found = false;
 	int ret;
+	bool send_lq;
 
 	if (!iwl_is_ready(priv)) {
 		IWL_DEBUG_INFO(priv, "Not ready yet, not restoring any stations.\n");
@@ -669,13 +670,20 @@ void iwl_restore_stations(struct iwl_priv *priv)
 
 	for (i = 0; i < priv->hw_params.max_stations; i++) {
 		if ((priv->stations[i].used & IWL_STA_UCODE_INPROGRESS)) {
+			memcpy(&sta_cmd, &priv->stations[i].sta,
+			       sizeof(struct iwl_addsta_cmd));
+			send_lq = false;
+			if (priv->stations[i].lq) {
+				memcpy(&lq, priv->stations[i].lq,
+				       sizeof(struct iwl_link_quality_cmd));
+				send_lq = true;
+			}
 			spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
-			station = &priv->stations[i];
-			ret = iwl_send_add_sta(priv, &priv->stations[i].sta, CMD_SYNC);
+			ret = iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
 			if (ret) {
-				IWL_ERR(priv, "Adding station %pM failed.\n",
-					station->sta.sta.addr);
 				spin_lock_irqsave(&priv->sta_lock, flags_spin);
+				IWL_ERR(priv, "Adding station %pM failed.\n",
+					priv->stations[i].sta.sta.addr);
 				priv->stations[i].used &= ~IWL_STA_DRIVER_ACTIVE;
 				priv->stations[i].used &= ~IWL_STA_UCODE_INPROGRESS;
 				spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
@@ -684,8 +692,8 @@ void iwl_restore_stations(struct iwl_priv *priv)
 			 * Rate scaling has already been initialized, send
 			 * current LQ command
 			 */
-			if (station->lq)
-				iwl_send_lq_cmd(priv, station->lq, CMD_SYNC, true);
+			if (send_lq)
+				iwl_send_lq_cmd(priv, &lq, CMD_SYNC, true);
 			spin_lock_irqsave(&priv->sta_lock, flags_spin);
 			priv->stations[i].used &= ~IWL_STA_UCODE_INPROGRESS;
 		}
@@ -1269,9 +1277,8 @@ void iwl_sta_tx_modify_enable_tid(struct iwl_priv *priv, int sta_id, int tid)
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_TID_DISABLE_TX;
 	priv->stations[sta_id].sta.tid_disable_tx &= cpu_to_le16(~(1 << tid));
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-
 	iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
 }
 EXPORT_SYMBOL(iwl_sta_tx_modify_enable_tid);
 
@@ -1302,7 +1309,7 @@ int iwl_sta_rx_agg_stop(struct iwl_priv *priv, struct ieee80211_sta *sta,
 			int tid)
 {
 	unsigned long flags;
-	int sta_id;
+	int sta_id, ret;
 
 	sta_id = iwl_sta_id(sta);
 	if (sta_id == IWL_INVALID_STATION) {
@@ -1315,10 +1322,11 @@ int iwl_sta_rx_agg_stop(struct iwl_priv *priv, struct ieee80211_sta *sta,
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_DELBA_TID_MSK;
 	priv->stations[sta_id].sta.remove_immediate_ba_tid = (u8)tid;
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
+	ret = iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
-	return iwl_send_add_sta(priv, &priv->stations[sta_id].sta,
-					CMD_ASYNC);
+	return ret;
+
 }
 EXPORT_SYMBOL(iwl_sta_rx_agg_stop);
 
@@ -1332,9 +1340,9 @@ void iwl_sta_modify_ps_wake(struct iwl_priv *priv, int sta_id)
 	priv->stations[sta_id].sta.sta.modify_mask = 0;
 	priv->stations[sta_id].sta.sleep_tx_count = 0;
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
+	iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
-	iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
 }
 EXPORT_SYMBOL(iwl_sta_modify_ps_wake);
 
@@ -1349,9 +1357,9 @@ void iwl_sta_modify_sleep_tx_count(struct iwl_priv *priv, int sta_id, int cnt)
 					STA_MODIFY_SLEEP_TX_COUNT_MSK;
 	priv->stations[sta_id].sta.sleep_tx_count = cpu_to_le16(cnt);
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
+	iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
-	iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
 }
 EXPORT_SYMBOL(iwl_sta_modify_sleep_tx_count);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 4454064..82beeb5 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -196,6 +196,7 @@ static int iwl3945_set_wep_dynamic_key_info(struct iwl_priv *priv,
 static int iwl3945_clear_sta_key_info(struct iwl_priv *priv, u8 sta_id)
 {
 	unsigned long flags;
+	struct iwl_addsta_cmd sta_cmd;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
 	memset(&priv->stations[sta_id].keyinfo, 0, sizeof(struct iwl_hw_key));
@@ -204,11 +205,11 @@ static int iwl3945_clear_sta_key_info(struct iwl_priv *priv, u8 sta_id)
 	priv->stations[sta_id].sta.key.key_flags = STA_KEY_FLG_NO_ENC;
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
+	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(struct iwl_addsta_cmd));
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
 	IWL_DEBUG_INFO(priv, "hwcrypto: clear ucode station key info\n");
-	iwl_send_add_sta(priv, &priv->stations[sta_id].sta, 0);
-	return 0;
+	return iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
 }
 
 static int iwl3945_set_dynamic_key(struct iwl_priv *priv,
-- 
1.6.3.3

