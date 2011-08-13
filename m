Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32836 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932Ab1HMSSk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:18:40 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 15/60] iwlagn: priv->sta_lock moves to iwl_shared
Date: Sat, 13 Aug 2011 10:37:51 -0700
Message-Id: <1313257116-2697-16-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_201958_527641_E3DCC49A)
In-Reply-To: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since it is used by all the layers, it needs to move to iwl_shared.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c       |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c       |   50 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c        |   26 ++++----
 drivers/net/wireless/iwlwifi/iwl-agn.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h           |    3 -
 drivers/net/wireless/iwlwifi/iwl-shared.h        |    3 +
 drivers/net/wireless/iwlwifi/iwl-sta.c           |   77 ++++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-sta.h           |    4 +-
 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c |    4 +-
 9 files changed, 90 insertions(+), 85 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index a604baa..bf2ba98 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -427,7 +427,7 @@ void iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	sta_id = (tx_resp->ra_tid & IWLAGN_TX_RES_RA_MSK) >>
 		IWLAGN_TX_RES_RA_POS;
 
-	spin_lock_irqsave(&priv->sta_lock, flags);
+	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
 
 	hdr = (void *)txb->skb->data;
 	if (!ieee80211_is_data_qos(hdr->frame_control))
@@ -482,7 +482,7 @@ void iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	iwlagn_txq_check_empty(priv, sta_id, tid, txq_id);
 
 	iwl_check_abort_status(priv, tx_resp->frame_count, status);
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 }
 
 int iwlagn_hw_valid_rtc_data_addr(u32 addr)
@@ -1079,7 +1079,7 @@ int iwlagn_manage_ibss_station(struct iwl_priv *priv,
 void iwl_free_tfds_in_queue(struct iwl_priv *priv,
 			    int sta_id, int tid, int freed)
 {
-	lockdep_assert_held(&priv->sta_lock);
+	lockdep_assert_held(&priv->shrd->sta_lock);
 
 	if (priv->stations[sta_id].tid[tid].tfds_in_queue >= freed)
 		priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index c99e6cc..4b13bb9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -116,9 +116,9 @@ int iwlagn_add_bssid_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx
 	if (sta_id_r)
 		*sta_id_r = sta_id;
 
-	spin_lock_irqsave(&priv->sta_lock, flags);
+	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
 	priv->stations[sta_id].used |= IWL_STA_LOCAL;
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 
 	/* Set up default rate scaling table in device's station table */
 	link_cmd = iwl_sta_alloc_lq(priv, ctx, sta_id);
@@ -132,9 +132,9 @@ int iwlagn_add_bssid_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx
 	if (ret)
 		IWL_ERR(priv, "Link quality command failed (%d)\n", ret);
 
-	spin_lock_irqsave(&priv->sta_lock, flags);
+	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
 	priv->stations[sta_id].lq = link_cmd;
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 
 	return 0;
 }
@@ -311,9 +311,9 @@ static int iwlagn_send_sta_key(struct iwl_priv *priv,
 	struct iwl_addsta_cmd sta_cmd;
 	int i;
 
-	spin_lock_irqsave(&priv->sta_lock, flags);
+	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
 	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(sta_cmd));
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 
 	key_flags = cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
 	key_flags |= STA_KEY_FLG_MAP_KEY_MSK;
@@ -388,11 +388,11 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
 	if (sta_id == IWL_INVALID_STATION)
 		return -ENOENT;
 
-	spin_lock_irqsave(&priv->sta_lock, flags);
+	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
 	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(sta_cmd));
 	if (!(priv->stations[sta_id].used & IWL_STA_UCODE_ACTIVE))
 		sta_id = IWL_INVALID_STATION;
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 
 	if (sta_id == IWL_INVALID_STATION)
 		return 0;
@@ -493,18 +493,18 @@ int iwlagn_alloc_bcast_station(struct iwl_priv *priv,
 	unsigned long flags;
 	u8 sta_id;
 
-	spin_lock_irqsave(&priv->sta_lock, flags);
+	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
 	sta_id = iwl_prep_station(priv, ctx, iwl_bcast_addr, false, NULL);
 	if (sta_id == IWL_INVALID_STATION) {
 		IWL_ERR(priv, "Unable to prepare broadcast station\n");
-		spin_unlock_irqrestore(&priv->sta_lock, flags);
+		spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 
 		return -EINVAL;
 	}
 
 	priv->stations[sta_id].used |= IWL_STA_DRIVER_ACTIVE;
 	priv->stations[sta_id].used |= IWL_STA_BCAST;
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 
 	link_cmd = iwl_sta_alloc_lq(priv, ctx, sta_id);
 	if (!link_cmd) {
@@ -513,9 +513,9 @@ int iwlagn_alloc_bcast_station(struct iwl_priv *priv,
 		return -ENOMEM;
 	}
 
-	spin_lock_irqsave(&priv->sta_lock, flags);
+	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
 	priv->stations[sta_id].lq = link_cmd;
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 
 	return 0;
 }
@@ -539,13 +539,13 @@ int iwl_update_bcast_station(struct iwl_priv *priv,
 		return -ENOMEM;
 	}
 
-	spin_lock_irqsave(&priv->sta_lock, flags);
+	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
 	if (priv->stations[sta_id].lq)
 		kfree(priv->stations[sta_id].lq);
 	else
 		IWL_DEBUG_INFO(priv, "Bcast station rate scaling has not been initialized yet.\n");
 	priv->stations[sta_id].lq = link_cmd;
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 
 	return 0;
 }
@@ -575,12 +575,12 @@ int iwl_sta_tx_modify_enable_tid(struct iwl_priv *priv, int sta_id, int tid)
 	lockdep_assert_held(&priv->shrd->mutex);
 
 	/* Remove "disable" flag, to enable Tx for this TID */
-	spin_lock_irqsave(&priv->sta_lock, flags);
+	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_TID_DISABLE_TX;
 	priv->stations[sta_id].sta.tid_disable_tx &= cpu_to_le16(~(1 << tid));
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(struct iwl_addsta_cmd));
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 
 	return iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
 }
@@ -598,14 +598,14 @@ int iwl_sta_rx_agg_start(struct iwl_priv *priv, struct ieee80211_sta *sta,
 	if (sta_id == IWL_INVALID_STATION)
 		return -ENXIO;
 
-	spin_lock_irqsave(&priv->sta_lock, flags);
+	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
 	priv->stations[sta_id].sta.station_flags_msk = 0;
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_ADDBA_TID_MSK;
 	priv->stations[sta_id].sta.add_immediate_ba_tid = (u8)tid;
 	priv->stations[sta_id].sta.add_immediate_ba_ssn = cpu_to_le16(ssn);
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(struct iwl_addsta_cmd));
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 
 	return iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
 }
@@ -625,13 +625,13 @@ int iwl_sta_rx_agg_stop(struct iwl_priv *priv, struct ieee80211_sta *sta,
 		return -ENXIO;
 	}
 
-	spin_lock_irqsave(&priv->sta_lock, flags);
+	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
 	priv->stations[sta_id].sta.station_flags_msk = 0;
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_DELBA_TID_MSK;
 	priv->stations[sta_id].sta.remove_immediate_ba_tid = (u8)tid;
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(struct iwl_addsta_cmd));
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 
 	return iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
 }
@@ -640,14 +640,14 @@ static void iwl_sta_modify_ps_wake(struct iwl_priv *priv, int sta_id)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&priv->sta_lock, flags);
+	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
 	priv->stations[sta_id].sta.station_flags &= ~STA_FLG_PWR_SAVE_MSK;
 	priv->stations[sta_id].sta.station_flags_msk = STA_FLG_PWR_SAVE_MSK;
 	priv->stations[sta_id].sta.sta.modify_mask = 0;
 	priv->stations[sta_id].sta.sleep_tx_count = 0;
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 	iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 
 }
 
@@ -655,7 +655,7 @@ void iwl_sta_modify_sleep_tx_count(struct iwl_priv *priv, int sta_id, int cnt)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&priv->sta_lock, flags);
+	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
 	priv->stations[sta_id].sta.station_flags |= STA_FLG_PWR_SAVE_MSK;
 	priv->stations[sta_id].sta.station_flags_msk = STA_FLG_PWR_SAVE_MSK;
 	priv->stations[sta_id].sta.sta.modify_mask =
@@ -663,7 +663,7 @@ void iwl_sta_modify_sleep_tx_count(struct iwl_priv *priv, int sta_id, int cnt)
 	priv->stations[sta_id].sta.sleep_tx_count = cpu_to_le16(cnt);
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 	iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 89d7b30..d0d7710 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -405,7 +405,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		txq_id = ctx->ac_to_queue[skb_get_queue_mapping(skb)];
 
 	/* irqs already disabled/saved above when locking priv->shrd->lock */
-	spin_lock(&priv->sta_lock);
+	spin_lock(&priv->shrd->sta_lock);
 
 	if (ieee80211_is_data_qos(fc)) {
 		u8 *qc = NULL;
@@ -460,7 +460,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 			priv->stations[sta_id].tid[tid].seq_number = seq_number;
 	}
 
-	spin_unlock(&priv->sta_lock);
+	spin_unlock(&priv->shrd->sta_lock);
 	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 
 	/*
@@ -476,7 +476,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	return 0;
 
 drop_unlock_sta:
-	spin_unlock(&priv->sta_lock);
+	spin_unlock(&priv->shrd->sta_lock);
 drop_unlock_priv:
 	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 	return -1;
@@ -534,19 +534,19 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 		return -ENXIO;
 	}
 
-	spin_lock_irqsave(&priv->sta_lock, flags);
+	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
 	tid_data = &priv->stations[sta_id].tid[tid];
 	*ssn = SEQ_TO_SN(tid_data->seq_number);
 	tid_data->agg.txq_id = txq_id;
 	tid_data->agg.tx_fifo = tx_fifo;
 	iwl_set_swq_id(&priv->txq[txq_id], get_ac_from_tid(tid), txq_id);
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 
 	ret = iwlagn_txq_agg_enable(priv, txq_id, sta_id, tid);
 	if (ret)
 		return ret;
 
-	spin_lock_irqsave(&priv->sta_lock, flags);
+	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
 	tid_data = &priv->stations[sta_id].tid[tid];
 	if (tid_data->tfds_in_queue == 0) {
 		IWL_DEBUG_HT(priv, "HW queue is empty\n");
@@ -557,7 +557,7 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 			     tid_data->tfds_in_queue);
 		tid_data->agg.state = IWL_EMPTYING_HW_QUEUE_ADDBA;
 	}
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 	return ret;
 }
 
@@ -580,7 +580,7 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 		return -ENXIO;
 	}
 
-	spin_lock_irqsave(&priv->sta_lock, flags);
+	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
 
 	tid_data = &priv->stations[sta_id].tid[tid];
 	ssn = (tid_data->seq_number & IEEE80211_SCTL_SEQ) >> 4;
@@ -610,7 +610,7 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 		IWL_DEBUG_HT(priv, "Stopping a non empty AGG HW QUEUE\n");
 		priv->stations[sta_id].tid[tid].agg.state =
 				IWL_EMPTYING_HW_QUEUE_DELBA;
-		spin_unlock_irqrestore(&priv->sta_lock, flags);
+		spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 		return 0;
 	}
 
@@ -619,7 +619,7 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	priv->stations[sta_id].tid[tid].agg.state = IWL_AGG_OFF;
 
 	/* do not restore/save irqs */
-	spin_unlock(&priv->sta_lock);
+	spin_unlock(&priv->shrd->sta_lock);
 	spin_lock(&priv->shrd->lock);
 
 	/*
@@ -647,7 +647,7 @@ int iwlagn_txq_check_empty(struct iwl_priv *priv,
 
 	ctx = &priv->contexts[priv->stations[sta_id].ctxid];
 
-	lockdep_assert_held(&priv->sta_lock);
+	lockdep_assert_held(&priv->shrd->sta_lock);
 
 	switch (priv->stations[sta_id].tid[tid].agg.state) {
 	case IWL_EMPTYING_HW_QUEUE_DELBA:
@@ -890,7 +890,7 @@ void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 	/* Find index just before block-ack window */
 	index = iwl_queue_dec_wrap(ba_resp_scd_ssn & 0xff, txq->q.n_bd);
 
-	spin_lock_irqsave(&priv->sta_lock, flags);
+	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
 
 	IWL_DEBUG_TX_REPLY(priv, "REPLY_COMPRESSED_BA [%d] Received from %pM, "
 			   "sta_id = %d\n",
@@ -927,7 +927,7 @@ void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 		iwlagn_txq_check_empty(priv, sta_id, tid, scd_flow);
 	}
 
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 }
 
 #ifdef CONFIG_IWLWIFI_DEBUG
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index be42d0d..1911ac6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3480,7 +3480,7 @@ static int iwl_init_drv(struct iwl_priv *priv)
 {
 	int ret;
 
-	spin_lock_init(&priv->sta_lock);
+	spin_lock_init(&priv->shrd->sta_lock);
 	spin_lock_init(&priv->hcmd_lock);
 
 	mutex_init(&priv->shrd->mutex);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index e92b11f..22e87b2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1309,9 +1309,6 @@ struct iwl_priv {
 	struct iwl_tt_mgmt thermal_throttle;
 
 	/* station table variables */
-
-	/* Note: if lock and sta_lock are needed, lock must be acquired first */
-	spinlock_t sta_lock;
 	int num_stations;
 	struct iwl_station_entry stations[IWLAGN_STATION_COUNT];
 	unsigned long ucode_key_table;
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 3395319..71496bf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -150,6 +150,8 @@ struct iwl_hw_params {
  * @hw_params: see struct iwl_hw_params
  * @workqueue: the workqueue used by all the layers of the driver
  * @lock: protect general shared data
+ * @sta_lock: protects the station table.
+ *	If lock and sta_lock are needed, lock must be acquired first.
  * @mutex:
  */
 struct iwl_shared {
@@ -166,6 +168,7 @@ struct iwl_shared {
 
 	struct workqueue_struct *workqueue;
 	spinlock_t lock;
+	spinlock_t sta_lock;
 	struct mutex mutex;
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 63b434b..9424d79 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -38,7 +38,7 @@
 #include "iwl-trans.h"
 #include "iwl-agn.h"
 
-/* priv->sta_lock must be held */
+/* priv->shrd->sta_lock must be held */
 static void iwl_sta_ucode_activate(struct iwl_priv *priv, u8 sta_id)
 {
 
@@ -75,7 +75,7 @@ static int iwl_process_add_sta_resp(struct iwl_priv *priv,
 	IWL_DEBUG_INFO(priv, "Processing response for adding station %u\n",
 		       sta_id);
 
-	spin_lock_irqsave(&priv->sta_lock, flags);
+	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
 
 	switch (pkt->u.add_sta.status) {
 	case ADD_STA_SUCCESS_MSK:
@@ -118,7 +118,7 @@ static int iwl_process_add_sta_resp(struct iwl_priv *priv,
 		       priv->stations[sta_id].sta.mode ==
 		       STA_CONTROL_MODIFY_MSK ? "Modified" : "Added",
 		       addsta->sta.addr);
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 
 	return ret;
 }
@@ -337,12 +337,12 @@ int iwl_add_station_common(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 	struct iwl_addsta_cmd sta_cmd;
 
 	*sta_id_r = 0;
-	spin_lock_irqsave(&priv->sta_lock, flags_spin);
+	spin_lock_irqsave(&priv->shrd->sta_lock, flags_spin);
 	sta_id = iwl_prep_station(priv, ctx, addr, is_ap, sta);
 	if (sta_id == IWL_INVALID_STATION) {
 		IWL_ERR(priv, "Unable to prepare station %pM for addition\n",
 			addr);
-		spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
+		spin_unlock_irqrestore(&priv->shrd->sta_lock, flags_spin);
 		return -EINVAL;
 	}
 
@@ -354,7 +354,7 @@ int iwl_add_station_common(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 	if (priv->stations[sta_id].used & IWL_STA_UCODE_INPROGRESS) {
 		IWL_DEBUG_INFO(priv, "STA %d already in process of being added.\n",
 			       sta_id);
-		spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
+		spin_unlock_irqrestore(&priv->shrd->sta_lock, flags_spin);
 		return -EEXIST;
 	}
 
@@ -362,23 +362,23 @@ int iwl_add_station_common(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 	    (priv->stations[sta_id].used & IWL_STA_UCODE_ACTIVE)) {
 		IWL_DEBUG_ASSOC(priv, "STA %d (%pM) already added, not adding again.\n",
 				sta_id, addr);
-		spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
+		spin_unlock_irqrestore(&priv->shrd->sta_lock, flags_spin);
 		return -EEXIST;
 	}
 
 	priv->stations[sta_id].used |= IWL_STA_UCODE_INPROGRESS;
 	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(struct iwl_addsta_cmd));
-	spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
+	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags_spin);
 
 	/* Add station to device's station table */
 	ret = iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
 	if (ret) {
-		spin_lock_irqsave(&priv->sta_lock, flags_spin);
+		spin_lock_irqsave(&priv->shrd->sta_lock, flags_spin);
 		IWL_ERR(priv, "Adding station %pM failed.\n",
 			priv->stations[sta_id].sta.sta.addr);
 		priv->stations[sta_id].used &= ~IWL_STA_DRIVER_ACTIVE;
 		priv->stations[sta_id].used &= ~IWL_STA_UCODE_INPROGRESS;
-		spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
+		spin_unlock_irqrestore(&priv->shrd->sta_lock, flags_spin);
 	}
 	*sta_id_r = sta_id;
 	return ret;
@@ -387,7 +387,7 @@ int iwl_add_station_common(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 /**
  * iwl_sta_ucode_deactivate - deactivate ucode status for a station
  *
- * priv->sta_lock must be held
+ * priv->shrd->sta_lock must be held
  */
 static void iwl_sta_ucode_deactivate(struct iwl_priv *priv, u8 sta_id)
 {
@@ -441,9 +441,11 @@ static int iwl_send_remove_station(struct iwl_priv *priv,
 		switch (pkt->u.rem_sta.status) {
 		case REM_STA_SUCCESS_MSK:
 			if (!temporary) {
-				spin_lock_irqsave(&priv->sta_lock, flags_spin);
+				spin_lock_irqsave(&priv->shrd->sta_lock,
+					flags_spin);
 				iwl_sta_ucode_deactivate(priv, sta_id);
-				spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
+				spin_unlock_irqrestore(&priv->shrd->sta_lock,
+					flags_spin);
 			}
 			IWL_DEBUG_ASSOC(priv, "REPLY_REMOVE_STA PASSED\n");
 			break;
@@ -484,7 +486,7 @@ int iwl_remove_station(struct iwl_priv *priv, const u8 sta_id,
 	if (WARN_ON(sta_id == IWL_INVALID_STATION))
 		return -EINVAL;
 
-	spin_lock_irqsave(&priv->sta_lock, flags);
+	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
 
 	if (!(priv->stations[sta_id].used & IWL_STA_DRIVER_ACTIVE)) {
 		IWL_DEBUG_INFO(priv, "Removing %pM but non DRIVER active\n",
@@ -510,11 +512,11 @@ int iwl_remove_station(struct iwl_priv *priv, const u8 sta_id,
 	if (WARN_ON(priv->num_stations < 0))
 		priv->num_stations = 0;
 
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 
 	return iwl_send_remove_station(priv, addr, sta_id, false);
 out_err:
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 	return -EINVAL;
 }
 
@@ -535,7 +537,7 @@ void iwl_clear_ucode_stations(struct iwl_priv *priv,
 
 	IWL_DEBUG_INFO(priv, "Clearing ucode stations in driver\n");
 
-	spin_lock_irqsave(&priv->sta_lock, flags_spin);
+	spin_lock_irqsave(&priv->shrd->sta_lock, flags_spin);
 	for (i = 0; i < hw_params(priv).max_stations; i++) {
 		if (ctx && ctx->ctxid != priv->stations[i].ctxid)
 			continue;
@@ -546,7 +548,7 @@ void iwl_clear_ucode_stations(struct iwl_priv *priv,
 			cleared = true;
 		}
 	}
-	spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
+	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags_spin);
 
 	if (!cleared)
 		IWL_DEBUG_INFO(priv, "No active stations found to be cleared\n");
@@ -576,7 +578,7 @@ void iwl_restore_stations(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	}
 
 	IWL_DEBUG_ASSOC(priv, "Restoring all known stations ... start.\n");
-	spin_lock_irqsave(&priv->sta_lock, flags_spin);
+	spin_lock_irqsave(&priv->shrd->sta_lock, flags_spin);
 	for (i = 0; i < hw_params(priv).max_stations; i++) {
 		if (ctx->ctxid != priv->stations[i].ctxid)
 			continue;
@@ -600,15 +602,18 @@ void iwl_restore_stations(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 				       sizeof(struct iwl_link_quality_cmd));
 				send_lq = true;
 			}
-			spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
+			spin_unlock_irqrestore(&priv->shrd->sta_lock,
+					       flags_spin);
 			ret = iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
 			if (ret) {
-				spin_lock_irqsave(&priv->sta_lock, flags_spin);
+				spin_lock_irqsave(&priv->shrd->sta_lock,
+						  flags_spin);
 				IWL_ERR(priv, "Adding station %pM failed.\n",
 					priv->stations[i].sta.sta.addr);
 				priv->stations[i].used &= ~IWL_STA_DRIVER_ACTIVE;
 				priv->stations[i].used &= ~IWL_STA_UCODE_INPROGRESS;
-				spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
+				spin_unlock_irqrestore(&priv->shrd->sta_lock,
+						       flags_spin);
 			}
 			/*
 			 * Rate scaling has already been initialized, send
@@ -616,12 +621,12 @@ void iwl_restore_stations(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 			 */
 			if (send_lq)
 				iwl_send_lq_cmd(priv, ctx, &lq, CMD_SYNC, true);
-			spin_lock_irqsave(&priv->sta_lock, flags_spin);
+			spin_lock_irqsave(&priv->shrd->sta_lock, flags_spin);
 			priv->stations[i].used &= ~IWL_STA_UCODE_INPROGRESS;
 		}
 	}
 
-	spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
+	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags_spin);
 	if (!found)
 		IWL_DEBUG_INFO(priv, "Restoring all known stations .... no stations to be restored.\n");
 	else
@@ -637,9 +642,9 @@ void iwl_reprogram_ap_sta(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	struct iwl_link_quality_cmd lq;
 	bool active;
 
-	spin_lock_irqsave(&priv->sta_lock, flags);
+	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
 	if (!(priv->stations[sta_id].used & IWL_STA_DRIVER_ACTIVE)) {
-		spin_unlock_irqrestore(&priv->sta_lock, flags);
+		spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 		return;
 	}
 
@@ -649,7 +654,7 @@ void iwl_reprogram_ap_sta(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 
 	active = priv->stations[sta_id].used & IWL_STA_UCODE_ACTIVE;
 	priv->stations[sta_id].used &= ~IWL_STA_DRIVER_ACTIVE;
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 
 	if (active) {
 		ret = iwl_send_remove_station(
@@ -659,9 +664,9 @@ void iwl_reprogram_ap_sta(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 			IWL_ERR(priv, "failed to remove STA %pM (%d)\n",
 				priv->stations[sta_id].sta.sta.addr, ret);
 	}
-	spin_lock_irqsave(&priv->sta_lock, flags);
+	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
 	priv->stations[sta_id].used |= IWL_STA_DRIVER_ACTIVE;
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 
 	ret = iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
 	if (ret)
@@ -686,7 +691,7 @@ void iwl_dealloc_bcast_stations(struct iwl_priv *priv)
 	unsigned long flags;
 	int i;
 
-	spin_lock_irqsave(&priv->sta_lock, flags);
+	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
 	for (i = 0; i < hw_params(priv).max_stations; i++) {
 		if (!(priv->stations[i].used & IWL_STA_BCAST))
 			continue;
@@ -698,7 +703,7 @@ void iwl_dealloc_bcast_stations(struct iwl_priv *priv)
 		kfree(priv->stations[i].lq);
 		priv->stations[i].lq = NULL;
 	}
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 }
 
 #ifdef CONFIG_IWLWIFI_DEBUG
@@ -782,12 +787,12 @@ int iwl_send_lq_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 		return -EINVAL;
 
 
-	spin_lock_irqsave(&priv->sta_lock, flags_spin);
+	spin_lock_irqsave(&priv->shrd->sta_lock, flags_spin);
 	if (!(priv->stations[lq->sta_id].used & IWL_STA_DRIVER_ACTIVE)) {
-		spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
+		spin_unlock_irqrestore(&priv->shrd->sta_lock, flags_spin);
 		return -EINVAL;
 	}
-	spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
+	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags_spin);
 
 	iwl_dump_lq_cmd(priv, lq);
 	if (WARN_ON(init && (cmd.flags & CMD_ASYNC)))
@@ -804,9 +809,9 @@ int iwl_send_lq_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 	if (init) {
 		IWL_DEBUG_INFO(priv, "init LQ command complete, clearing sta addition status for sta %d\n",
 			       lq->sta_id);
-		spin_lock_irqsave(&priv->sta_lock, flags_spin);
+		spin_lock_irqsave(&priv->shrd->sta_lock, flags_spin);
 		priv->stations[lq->sta_id].used &= ~IWL_STA_UCODE_INPROGRESS;
-		spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
+		spin_unlock_irqrestore(&priv->shrd->sta_lock, flags_spin);
 	}
 	return ret;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 9a6768d..9641eb6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -76,7 +76,7 @@ static inline void iwl_clear_driver_stations(struct iwl_priv *priv)
 	unsigned long flags;
 	struct iwl_rxon_context *ctx;
 
-	spin_lock_irqsave(&priv->sta_lock, flags);
+	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
 	memset(priv->stations, 0, sizeof(priv->stations));
 	priv->num_stations = 0;
 
@@ -94,7 +94,7 @@ static inline void iwl_clear_driver_stations(struct iwl_priv *priv)
 		ctx->key_mapping_keys = 0;
 	}
 
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 }
 
 static inline int iwl_sta_id(struct ieee80211_sta *sta)
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
index e1130a7..b0ad127 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
@@ -435,12 +435,12 @@ void iwl_trans_txq_agg_setup(struct iwl_priv *priv, int sta_id, int tid,
 	if (WARN_ON(tid >= MAX_TID_COUNT))
 		return;
 
-	spin_lock_irqsave(&priv->sta_lock, flags);
+	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
 	tid_data = &priv->stations[sta_id].tid[tid];
 	ssn_idx = SEQ_TO_SN(tid_data->seq_number);
 	txq_id = tid_data->agg.txq_id;
 	tx_fifo = tid_data->agg.tx_fifo;
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 
 	ra_tid = BUILD_RAxTID(sta_id, tid);
 
-- 
1.7.0.4

