Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40582 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751625AbcEJUIT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:08:19 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:06:02 +0300
Message-Id: <1462910797-20303-6-git-send-email-luca@coelho.fi> (sfid-20160510_220822_164030_FB739299)
In-Reply-To: <1462910797-20303-1-git-send-email-luca@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
 <1462910797-20303-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 06/41] iwlwifi: mvm: add infrastructure for tracking BA session in driver
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

According to the spec when a BA session is started there
is a timeout set for the session in the ADDBA request.
If there is not activity on the TA/TID then the session
expires and a DELBA is sent.
In order to check for the timeout, data must be shared
among the rx queues.
Add a timer that runs as long as BA session is active
for the station and stops aggregation session if needed.
This patch also lays the infrastructure for the reordering
buffer which will be enabled in the next patches.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/mvm/fw-api-sta.h    |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  25 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  35 ++++++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       | 130 +++++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |   4 +-
 6 files changed, 194 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h
index 90d9113..e896648 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h
@@ -255,8 +255,10 @@ struct iwl_mvm_keyinfo {
 	__le64 hw_tkip_mic_tx_key;
 } __packed;
 
-#define IWL_ADD_STA_STATUS_MASK	0xFF
-#define IWL_ADD_STA_BAID_MASK	0xFF00
+#define IWL_ADD_STA_STATUS_MASK		0xFF
+#define IWL_ADD_STA_BAID_VALID_MASK	0x8000
+#define IWL_ADD_STA_BAID_MASK		0x7F00
+#define IWL_ADD_STA_BAID_SHIFT		8
 
 /**
  * struct iwl_mvm_add_sta_cmd_v7 - Add/modify a station in the fw's sta table.
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index f746ff6..ae441c5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -848,6 +848,7 @@ static int iwl_mvm_mac_ampdu_action(struct ieee80211_hw *hw,
 	u16 *ssn = &params->ssn;
 	u8 buf_size = params->buf_size;
 	bool amsdu = params->amsdu;
+	u16 timeout = params->timeout;
 
 	IWL_DEBUG_HT(mvm, "A-MPDU action on addr %pM tid %d: action %d\n",
 		     sta->addr, tid, action);
@@ -888,10 +889,12 @@ static int iwl_mvm_mac_ampdu_action(struct ieee80211_hw *hw,
 			ret = -EINVAL;
 			break;
 		}
-		ret = iwl_mvm_sta_rx_agg(mvm, sta, tid, *ssn, true, buf_size);
+		ret = iwl_mvm_sta_rx_agg(mvm, sta, tid, *ssn, true, buf_size,
+					 timeout);
 		break;
 	case IEEE80211_AMPDU_RX_STOP:
-		ret = iwl_mvm_sta_rx_agg(mvm, sta, tid, 0, false, buf_size);
+		ret = iwl_mvm_sta_rx_agg(mvm, sta, tid, 0, false, buf_size,
+					 timeout);
 		break;
 	case IEEE80211_AMPDU_TX_START:
 		if (!iwl_enable_tx_ampdu(mvm->cfg)) {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 14b5f6a..ea1817a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -613,6 +613,27 @@ struct iwl_mvm_shared_mem_cfg {
 	u32 internal_txfifo_size[TX_FIFO_INTERNAL_MAX_NUM];
 };
 
+/**
+ * struct iwl_mvm_baid_data - BA session data
+ * @sta_id: station id
+ * @tid: tid of the session
+ * @baid baid of the session
+ * @timeout: the timeout set in the addba request
+ * @last_rx: last rx jiffies, updated only if timeout passed from last update
+ * @session_timer: timer to check if BA session expired, runs at 2 * timeout
+ * @mvm: mvm pointer, needed for timer context
+ */
+struct iwl_mvm_baid_data {
+	struct rcu_head rcu_head;
+	u8 sta_id;
+	u8 tid;
+	u8 baid;
+	u16 timeout;
+	unsigned long last_rx;
+	struct timer_list session_timer;
+	struct iwl_mvm *mvm;
+};
+
 struct iwl_mvm {
 	/* for logger access */
 	struct device *dev;
@@ -922,6 +943,10 @@ struct iwl_mvm {
 	u32 ciphers[6];
 	struct iwl_mvm_tof_data tof_data;
 
+	struct ieee80211_vif *nan_vif;
+#define IWL_MAX_BAID	32
+	struct iwl_mvm_baid_data __rcu *baid_map[IWL_MAX_BAID];
+
 	/*
 	 * Drop beacons from other APs in AP mode when there are no connected
 	 * clients.
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 306dd9b..8d5717b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -424,6 +424,36 @@ void iwl_mvm_rx_queue_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 	}
 }
 
+static void iwl_mvm_agg_rx_received(struct iwl_mvm *mvm, u8 baid)
+{
+	unsigned long now = jiffies;
+	unsigned long timeout;
+	struct iwl_mvm_baid_data *data;
+
+	rcu_read_lock();
+
+	data = rcu_dereference(mvm->baid_map[baid]);
+	if (WARN_ON(!data))
+		goto out;
+
+	if (!data->timeout)
+		goto out;
+
+	timeout = data->timeout;
+	/*
+	 * Do not update last rx all the time to avoid cache bouncing
+	 * between the rx queues.
+	 * Update it every timeout. Worst case is the session will
+	 * expire after ~ 2 * timeout, which doesn't matter that much.
+	 */
+	if (time_before(data->last_rx + TU_TO_JIFFIES(timeout), now))
+		/* Update is atomic */
+		data->last_rx = now;
+
+out:
+	rcu_read_unlock();
+}
+
 void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 			struct iwl_rx_cmd_buffer *rxb, int queue)
 {
@@ -494,6 +524,9 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 
 	if (sta) {
 		struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+		u8 baid = (u8)((le32_to_cpu(desc->reorder_data) &
+			       IWL_RX_MPDU_REORDER_BAID_MASK) >>
+			       IWL_RX_MPDU_REORDER_BAID_SHIFT);
 
 		/*
 		 * We have tx blocked stations (with CS bit). If we heard
@@ -546,6 +579,8 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 
 			*qc &= ~IEEE80211_QOS_CTL_A_MSDU_PRESENT;
 		}
+		if (baid != IWL_RX_REORDER_DATA_INVALID_BAID)
+			iwl_mvm_agg_rx_received(mvm, baid);
 	}
 
 	/*
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 701511d..4fb4c4e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -223,6 +223,39 @@ int iwl_mvm_sta_send_to_fw(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	return ret;
 }
 
+static void iwl_mvm_rx_agg_session_expired(unsigned long data)
+{
+	struct iwl_mvm_baid_data __rcu **rcu_ptr = (void *)data;
+	struct iwl_mvm_baid_data *ba_data;
+	struct ieee80211_sta *sta;
+	struct iwl_mvm_sta *mvm_sta;
+	unsigned long timeout;
+
+	rcu_read_lock();
+
+	ba_data = rcu_dereference(*rcu_ptr);
+
+	if (WARN_ON(!ba_data))
+		goto unlock;
+
+	if (!ba_data->timeout)
+		goto unlock;
+
+	timeout = ba_data->last_rx + TU_TO_JIFFIES(ba_data->timeout * 2);
+	if (time_is_after_jiffies(timeout)) {
+		mod_timer(&ba_data->session_timer, timeout);
+		goto unlock;
+	}
+
+	/* Timer expired */
+	sta = rcu_dereference(ba_data->mvm->fw_id_to_mac_id[ba_data->sta_id]);
+	mvm_sta = iwl_mvm_sta_from_mac80211(sta);
+	ieee80211_stop_rx_ba_session_offl(mvm_sta->vif,
+					  sta->addr, ba_data->tid);
+unlock:
+	rcu_read_unlock();
+}
+
 static int iwl_mvm_tdls_sta_init(struct iwl_mvm *mvm,
 				 struct ieee80211_sta *sta)
 {
@@ -1134,11 +1167,22 @@ int iwl_mvm_rm_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 #define IWL_MAX_RX_BA_SESSIONS 16
 
+static void iwl_mvm_sync_rxq_del_ba(struct iwl_mvm *mvm)
+{
+	struct iwl_mvm_internal_rxq_notif data = {
+		.type = IWL_MVM_RXQ_EMPTY,
+		.sync = 1,
+	};
+
+	iwl_mvm_sync_rx_queues_internal(mvm, &data, sizeof(data));
+}
+
 int iwl_mvm_sta_rx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
-		       int tid, u16 ssn, bool start, u8 buf_size)
+		       int tid, u16 ssn, bool start, u8 buf_size, u16 timeout)
 {
 	struct iwl_mvm_sta *mvm_sta = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_mvm_add_sta_cmd cmd = {};
+	struct iwl_mvm_baid_data *baid_data = NULL;
 	int ret;
 	u32 status;
 
@@ -1149,6 +1193,16 @@ int iwl_mvm_sta_rx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		return -ENOSPC;
 	}
 
+	if (iwl_mvm_has_new_rx_api(mvm) && start) {
+		/*
+		 * Allocate here so if allocation fails we can bail out early
+		 * before starting the BA session in the firmware
+		 */
+		baid_data = kzalloc(sizeof(*baid_data), GFP_KERNEL);
+		if (!baid_data)
+			return -ENOMEM;
+	}
+
 	cmd.mac_id_n_color = cpu_to_le32(mvm_sta->mac_id_n_color);
 	cmd.sta_id = mvm_sta->sta_id;
 	cmd.add_modify = STA_MODE_MODIFY;
@@ -1167,7 +1221,7 @@ int iwl_mvm_sta_rx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 					  iwl_mvm_add_sta_cmd_size(mvm),
 					  &cmd, &status);
 	if (ret)
-		return ret;
+		goto out_free;
 
 	switch (status & IWL_ADD_STA_STATUS_MASK) {
 	case ADD_STA_SUCCESS:
@@ -1185,14 +1239,74 @@ int iwl_mvm_sta_rx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		break;
 	}
 
-	if (!ret) {
-		if (start)
-			mvm->rx_ba_sessions++;
-		else if (mvm->rx_ba_sessions > 0)
-			/* check that restart flow didn't zero the counter */
-			mvm->rx_ba_sessions--;
+	if (ret)
+		goto out_free;
+
+	if (start) {
+		u8 baid;
+
+		mvm->rx_ba_sessions++;
+
+		if (!iwl_mvm_has_new_rx_api(mvm))
+			return 0;
+
+		if (WARN_ON(!(status & IWL_ADD_STA_BAID_VALID_MASK))) {
+			ret = -EINVAL;
+			goto out_free;
+		}
+		baid = (u8)((status & IWL_ADD_STA_BAID_MASK) >>
+			    IWL_ADD_STA_BAID_SHIFT);
+		baid_data->baid = baid;
+		baid_data->timeout = timeout;
+		baid_data->last_rx = jiffies;
+		init_timer(&baid_data->session_timer);
+		baid_data->session_timer.function =
+			iwl_mvm_rx_agg_session_expired;
+		baid_data->session_timer.data =
+			(unsigned long)&mvm->baid_map[baid];
+		baid_data->mvm = mvm;
+		baid_data->tid = tid;
+		baid_data->sta_id = mvm_sta->sta_id;
+
+		mvm_sta->tid_to_baid[tid] = baid;
+		if (timeout)
+			mod_timer(&baid_data->session_timer,
+				  TU_TO_EXP_TIME(timeout * 2));
+
+		/*
+		 * protect the BA data with RCU to cover a case where our
+		 * internal RX sync mechanism will timeout (not that it's
+		 * supposed to happen) and we will free the session data while
+		 * RX is being processed in parallel
+		 */
+		WARN_ON(rcu_access_pointer(mvm->baid_map[baid]));
+		rcu_assign_pointer(mvm->baid_map[baid], baid_data);
+	} else if (mvm->rx_ba_sessions > 0) {
+		u8 baid = mvm_sta->tid_to_baid[tid];
+
+		/* check that restart flow didn't zero the counter */
+		mvm->rx_ba_sessions--;
+		if (!iwl_mvm_has_new_rx_api(mvm))
+			return 0;
+
+		if (WARN_ON(baid == IWL_RX_REORDER_DATA_INVALID_BAID))
+			return -EINVAL;
+
+		baid_data = rcu_access_pointer(mvm->baid_map[baid]);
+		if (WARN_ON(!baid_data))
+			return -EINVAL;
+
+		/* synchronize all rx queues so we can safely delete */
+		iwl_mvm_sync_rxq_del_ba(mvm);
+		del_timer_sync(&baid_data->session_timer);
+
+		RCU_INIT_POINTER(mvm->baid_map[baid], NULL);
+		kfree_rcu(baid_data, rcu_head);
 	}
+	return 0;
 
+out_free:
+	kfree(baid_data);
 	return ret;
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
index e3efdcd..1226318 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -373,6 +373,7 @@ struct iwl_mvm_rxq_dup_data {
  * @lock: lock to protect the whole struct. Since %tid_data is access from Tx
  * and from Tx response flow, it needs a spinlock.
  * @tid_data: per tid data + mgmt. Look at %iwl_mvm_tid_data.
+ * @tid_to_baid: a simple map of TID to baid
  * @reserved_queue: the queue reserved for this STA for DQA purposes
  *	Every STA has is given one reserved queue to allow it to operate. If no
  *	such queue can be guaranteed, the STA addition will fail.
@@ -406,6 +407,7 @@ struct iwl_mvm_sta {
 	bool next_status_eosp;
 	spinlock_t lock;
 	struct iwl_mvm_tid_data tid_data[IWL_MAX_TID_COUNT + 1];
+	u8 tid_to_baid[IWL_MAX_TID_COUNT];
 	struct iwl_lq_sta lq_sta;
 	struct ieee80211_vif *vif;
 	struct iwl_mvm_key_pn __rcu *ptk_pn[4];
@@ -487,7 +489,7 @@ void iwl_mvm_rx_eosp_notif(struct iwl_mvm *mvm,
 
 /* AMPDU */
 int iwl_mvm_sta_rx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
-		       int tid, u16 ssn, bool start, u8 buf_size);
+		       int tid, u16 ssn, bool start, u8 buf_size, u16 timeout);
 int iwl_mvm_sta_tx_agg_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			struct ieee80211_sta *sta, u16 tid, u16 *ssn);
 int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-- 
2.8.1

