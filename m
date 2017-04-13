Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51264 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751803AbdDMPZV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 11:25:21 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 13 Apr 2017 18:24:45 +0300
Message-Id: <20170413152507.9648-5-luca@coelho.fi> (sfid-20170413_172527_209579_03F00270)
In-Reply-To: <20170413152507.9648-1-luca@coelho.fi>
References: <20170413152507.9648-1-luca@coelho.fi>
Subject: [PATCH 04/26] iwlwifi: mvm: prepare for station count change
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

In a000 devices we will support up to 32 stations.
The max station define is used also for invalid station marking
which makes finding usages of actual maximum station pretty hard
to sort through - change it to be a different define in order
to make future changes easier.
Use also ARRAY_SIZE intead of define when possible.
Do not move yet to 32 stations until firmware do it though.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c      |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |  2 +-
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |  2 +-
 .../net/wireless/intel/iwlwifi/mvm/fw-api-mac.h    |  4 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  6 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |  6 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 16 ++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       | 12 ++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |  4 +--
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sf.c        |  6 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       | 30 +++++++++++-----------
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c      | 22 ++++++++--------
 drivers/net/wireless/intel/iwlwifi/mvm/tof.c       |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c        |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  6 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |  2 +-
 18 files changed, 66 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/coex.c b/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
index 5bdb6c2c8390..49b4418e6c35 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
@@ -756,7 +756,7 @@ void iwl_mvm_bt_rssi_event(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	 * Rssi update while not associated - can happen since the statistics
 	 * are handled asynchronously
 	 */
-	if (mvmvif->ap_sta_id == IWL_MVM_STATION_COUNT)
+	if (mvmvif->ap_sta_id == IWL_MVM_INVALID_STA)
 		return;
 
 	/* No BT - reports should be disabled */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index d65acfa3b89b..d74ae15b2d85 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1208,7 +1208,7 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 
 	mvmvif = iwl_mvm_vif_from_mac80211(vif);
 
-	if (mvmvif->ap_sta_id == IWL_MVM_STATION_COUNT) {
+	if (mvmvif->ap_sta_id == IWL_MVM_INVALID_STA) {
 		/* if we're not associated, this must be netdetect */
 		if (!wowlan->nd_config) {
 			ret = 1;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
index f4d75ffe3d8a..5d475b4850ae 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
@@ -280,7 +280,7 @@ static ssize_t iwl_dbgfs_mac_params_read(struct file *file,
 				 mvmvif->queue_params[i].uapsd);
 
 	if (vif->type == NL80211_IFTYPE_STATION &&
-	    ap_sta_id != IWL_MVM_STATION_COUNT) {
+	    ap_sta_id != IWL_MVM_INVALID_STA) {
 		struct iwl_mvm_sta *mvm_sta;
 
 		mvm_sta = iwl_mvm_sta_from_staid_protected(mvm, ap_sta_id);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index a260cd503200..7b33ff398332 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -330,7 +330,7 @@ static ssize_t iwl_dbgfs_stations_read(struct file *file, char __user *user_buf,
 
 	mutex_lock(&mvm->mutex);
 
-	for (i = 0; i < IWL_MVM_STATION_COUNT; i++) {
+	for (i = 0; i < ARRAY_SIZE(mvm->fw_id_to_mac_id); i++) {
 		pos += scnprintf(buf + pos, bufsz - pos, "%.2d: ", i);
 		sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[i],
 						lockdep_is_held(&mvm->mutex));
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-mac.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-mac.h
index 480a54af4534..d3cdd889c85c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-mac.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-mac.h
@@ -73,7 +73,9 @@
 #define NUM_MAC_INDEX		(NUM_MAC_INDEX_DRIVER + 1)
 #define NUM_MAC_INDEX_CDB	(NUM_MAC_INDEX_DRIVER + 2)
 
-#define IWL_MVM_STATION_COUNT	16
+#define IWL_MVM_STATION_COUNT		16
+#define IWL_MVM_INVALID_STA		0xFF
+
 #define IWL_MVM_TDLS_STA_COUNT	4
 
 enum iwl_ac {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 6adbd4bcb40a..61cafb541554 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1250,10 +1250,10 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	}
 
 	/* init the fw <-> mac80211 STA mapping */
-	for (i = 0; i < IWL_MVM_STATION_COUNT; i++)
+	for (i = 0; i < ARRAY_SIZE(mvm->fw_id_to_mac_id); i++)
 		RCU_INIT_POINTER(mvm->fw_id_to_mac_id[i], NULL);
 
-	mvm->tdls_cs.peer.sta_id = IWL_MVM_STATION_COUNT;
+	mvm->tdls_cs.peer.sta_id = IWL_MVM_INVALID_STA;
 
 	/* reset quota debouncing buffer - 0xff will yield invalid data */
 	memset(&mvm->last_quota_cmd, 0xff, sizeof(mvm->last_quota_cmd));
@@ -1383,7 +1383,7 @@ int iwl_mvm_load_d3_fw(struct iwl_mvm *mvm)
 		goto error;
 
 	/* init the fw <-> mac80211 STA mapping */
-	for (i = 0; i < IWL_MVM_STATION_COUNT; i++)
+	for (i = 0; i < ARRAY_SIZE(mvm->fw_id_to_mac_id); i++)
 		RCU_INIT_POINTER(mvm->fw_id_to_mac_id[i], NULL);
 
 	/* Add auxiliary station for scanning */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index e7c8567cafff..2473f4bd6238 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -471,9 +471,9 @@ static int iwl_mvm_mac_ctxt_allocate_resources(struct iwl_mvm *mvm,
 		vif->cab_queue = IEEE80211_INVAL_HW_QUEUE;
 	}
 
-	mvmvif->bcast_sta.sta_id = IWL_MVM_STATION_COUNT;
-	mvmvif->mcast_sta.sta_id = IWL_MVM_STATION_COUNT;
-	mvmvif->ap_sta_id = IWL_MVM_STATION_COUNT;
+	mvmvif->bcast_sta.sta_id = IWL_MVM_INVALID_STA;
+	mvmvif->mcast_sta.sta_id = IWL_MVM_INVALID_STA;
+	mvmvif->ap_sta_id = IWL_MVM_INVALID_STA;
 
 	for (i = 0; i < NUM_IWL_MVM_SMPS_REQ; i++)
 		mvmvif->smps_requests[i] = IEEE80211_SMPS_AUTOMATIC;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 72a056a80516..5f9d5339fc3d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -767,7 +767,7 @@ static bool iwl_mvm_defer_tx(struct iwl_mvm *mvm,
 		goto out;
 
 	mvmsta = iwl_mvm_sta_from_mac80211(sta);
-	if (mvmsta->sta_id == IWL_MVM_STATION_COUNT ||
+	if (mvmsta->sta_id == IWL_MVM_INVALID_STA ||
 	    mvmsta->sta_id != mvm->d0i3_ap_sta_id)
 		goto out;
 
@@ -1011,7 +1011,7 @@ static void iwl_mvm_cleanup_iterator(void *data, u8 *mac,
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 
 	mvmvif->uploaded = false;
-	mvmvif->ap_sta_id = IWL_MVM_STATION_COUNT;
+	mvmvif->ap_sta_id = IWL_MVM_INVALID_STA;
 
 	spin_lock_bh(&mvm->time_event_lock);
 	iwl_mvm_te_clear_data(mvm, &mvmvif->time_event_data);
@@ -1054,7 +1054,7 @@ static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 	ieee80211_iterate_interfaces(mvm->hw, 0, iwl_mvm_cleanup_iterator, mvm);
 
 	mvm->p2p_device_vif = NULL;
-	mvm->d0i3_ap_sta_id = IWL_MVM_STATION_COUNT;
+	mvm->d0i3_ap_sta_id = IWL_MVM_INVALID_STA;
 
 	iwl_mvm_reset_phy_ctxts(mvm);
 	memset(mvm->fw_key_table, 0, sizeof(mvm->fw_key_table));
@@ -1965,7 +1965,7 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 						    IWL_MVM_SMPS_REQ_PROT,
 						    IEEE80211_SMPS_DYNAMIC);
 			}
-		} else if (mvmvif->ap_sta_id != IWL_MVM_STATION_COUNT) {
+		} else if (mvmvif->ap_sta_id != IWL_MVM_INVALID_STA) {
 			/*
 			 * If update fails - SF might be running in associated
 			 * mode while disassociated - which is forbidden.
@@ -1979,8 +1979,8 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 				IWL_ERR(mvm, "failed to remove AP station\n");
 
 			if (mvm->d0i3_ap_sta_id == mvmvif->ap_sta_id)
-				mvm->d0i3_ap_sta_id = IWL_MVM_STATION_COUNT;
-			mvmvif->ap_sta_id = IWL_MVM_STATION_COUNT;
+				mvm->d0i3_ap_sta_id = IWL_MVM_INVALID_STA;
+			mvmvif->ap_sta_id = IWL_MVM_INVALID_STA;
 			/* remove quota for this interface */
 			ret = iwl_mvm_update_quotas(mvm, false, NULL);
 			if (ret)
@@ -2391,7 +2391,7 @@ static void __iwl_mvm_mac_sta_notify(struct ieee80211_hw *hw,
 		 */
 		break;
 	case STA_NOTIFY_AWAKE:
-		if (WARN_ON(mvmsta->sta_id == IWL_MVM_STATION_COUNT))
+		if (WARN_ON(mvmsta->sta_id == IWL_MVM_INVALID_STA))
 			break;
 
 		if (txqs)
@@ -3961,7 +3961,7 @@ static void iwl_mvm_mac_flush(struct ieee80211_hw *hw,
 	mvmvif = iwl_mvm_vif_from_mac80211(vif);
 
 	/* flush the AP-station and all TDLS peers */
-	for (i = 0; i < IWL_MVM_STATION_COUNT; i++) {
+	for (i = 0; i < ARRAY_SIZE(mvm->fw_id_to_mac_id); i++) {
 		sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[i],
 						lockdep_is_held(&mvm->mutex));
 		if (IS_ERR_OR_NULL(sta))
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 72afccfe4282..d313941ffc9d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1268,7 +1268,7 @@ static bool iwl_mvm_disallow_offloading(struct iwl_mvm *mvm,
 	u8 tid;
 
 	if (WARN_ON(vif->type != NL80211_IFTYPE_STATION ||
-		    mvmvif->ap_sta_id == IWL_MVM_STATION_COUNT))
+		    mvmvif->ap_sta_id == IWL_MVM_INVALID_STA))
 		return false;
 
 	mvmsta = iwl_mvm_sta_from_staid_rcu(mvm, mvmvif->ap_sta_id);
@@ -1356,7 +1356,7 @@ static void iwl_mvm_set_wowlan_data(struct iwl_mvm *mvm,
 	struct ieee80211_sta *ap_sta;
 	struct iwl_mvm_sta *mvm_ap_sta;
 
-	if (iter_data->ap_sta_id == IWL_MVM_STATION_COUNT)
+	if (iter_data->ap_sta_id == IWL_MVM_INVALID_STA)
 		return;
 
 	rcu_read_lock();
@@ -1426,7 +1426,7 @@ int iwl_mvm_enter_d0i3(struct iwl_op_mode *op_mode)
 		mvm->d0i3_offloading = !d0i3_iter_data.disable_offloading;
 	} else {
 		WARN_ON_ONCE(d0i3_iter_data.vif_count > 1);
-		mvm->d0i3_ap_sta_id = IWL_MVM_STATION_COUNT;
+		mvm->d0i3_ap_sta_id = IWL_MVM_INVALID_STA;
 		mvm->d0i3_offloading = false;
 	}
 
@@ -1439,7 +1439,7 @@ int iwl_mvm_enter_d0i3(struct iwl_op_mode *op_mode)
 		return ret;
 
 	/* configure wowlan configuration only if needed */
-	if (mvm->d0i3_ap_sta_id != IWL_MVM_STATION_COUNT) {
+	if (mvm->d0i3_ap_sta_id != IWL_MVM_INVALID_STA) {
 		/* wake on beacons only if beacon storing isn't supported */
 		if (!fw_has_capa(&mvm->fw->ucode_capa,
 				 IWL_UCODE_TLV_CAPA_BEACON_STORING))
@@ -1516,7 +1516,7 @@ void iwl_mvm_d0i3_enable_tx(struct iwl_mvm *mvm, __le16 *qos_seq)
 
 	spin_lock_bh(&mvm->d0i3_tx_lock);
 
-	if (mvm->d0i3_ap_sta_id == IWL_MVM_STATION_COUNT)
+	if (mvm->d0i3_ap_sta_id == IWL_MVM_INVALID_STA)
 		goto out;
 
 	IWL_DEBUG_RPM(mvm, "re-enqueue packets\n");
@@ -1554,7 +1554,7 @@ void iwl_mvm_d0i3_enable_tx(struct iwl_mvm *mvm, __le16 *qos_seq)
 	}
 	clear_bit(IWL_MVM_STATUS_IN_D0I3, &mvm->status);
 	wake_up(&mvm->d0i3_exit_waitq);
-	mvm->d0i3_ap_sta_id = IWL_MVM_STATION_COUNT;
+	mvm->d0i3_ap_sta_id = IWL_MVM_INVALID_STA;
 	if (wake_queues)
 		ieee80211_wake_queues(mvm->hw);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index c1bf67f04cf6..861d54641d1e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -351,7 +351,7 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 
 		id >>= RX_MDPU_RES_STATUS_STA_ID_SHIFT;
 
-		if (!WARN_ON_ONCE(id >= IWL_MVM_STATION_COUNT)) {
+		if (!WARN_ON_ONCE(id >= ARRAY_SIZE(mvm->fw_id_to_mac_id))) {
 			sta = rcu_dereference(mvm->fw_id_to_mac_id[id]);
 			if (IS_ERR(sta))
 				sta = NULL;
@@ -693,7 +693,7 @@ void iwl_mvm_handle_rx_statistics(struct iwl_mvm *mvm,
 		}
 
 		rcu_read_lock();
-		for (i = 0; i < IWL_MVM_STATION_COUNT; i++) {
+		for (i = 0; i < ARRAY_SIZE(mvm->fw_id_to_mac_id); i++) {
 			struct iwl_mvm_sta *sta;
 
 			if (!energy[i])
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 85f7c83995b9..29c9c56ed3fa 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -841,7 +841,7 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 	if (le16_to_cpu(desc->status) & IWL_RX_MPDU_STATUS_SRC_STA_FOUND) {
 		u8 id = desc->sta_id_flags & IWL_RX_MPDU_SIF_STA_ID_MASK;
 
-		if (!WARN_ON_ONCE(id >= IWL_MVM_STATION_COUNT)) {
+		if (!WARN_ON_ONCE(id >= ARRAY_SIZE(mvm->fw_id_to_mac_id))) {
 			sta = rcu_dereference(mvm->fw_id_to_mac_id[id]);
 			if (IS_ERR(sta))
 				sta = NULL;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sf.c b/drivers/net/wireless/intel/iwlwifi/mvm/sf.c
index 101fb04a8573..539b06bf0803 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sf.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sf.c
@@ -235,7 +235,7 @@ static int iwl_mvm_sf_config(struct iwl_mvm *mvm, u8 sta_id,
 		iwl_mvm_fill_sf_command(mvm, &sf_cmd, NULL);
 		break;
 	case SF_FULL_ON:
-		if (sta_id == IWL_MVM_STATION_COUNT) {
+		if (sta_id == IWL_MVM_INVALID_STA) {
 			IWL_ERR(mvm,
 				"No station: Cannot switch SF to FULL_ON\n");
 			return -EINVAL;
@@ -276,12 +276,12 @@ int iwl_mvm_sf_update(struct iwl_mvm *mvm, struct ieee80211_vif *changed_vif,
 		      bool remove_vif)
 {
 	enum iwl_sf_state new_state;
-	u8 sta_id = IWL_MVM_STATION_COUNT;
+	u8 sta_id = IWL_MVM_INVALID_STA;
 	struct iwl_mvm_vif *mvmvif = NULL;
 	struct iwl_mvm_active_iface_iterator_data data = {
 		.ignore_vif = changed_vif,
 		.sta_vif_state = SF_UNINIT,
-		.sta_vif_ap_sta_id = IWL_MVM_STATION_COUNT,
+		.sta_vif_ap_sta_id = IWL_MVM_INVALID_STA,
 	};
 
 	/*
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 7d6a5dbb50ca..d538ef0cfd4e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -98,7 +98,7 @@ static int iwl_mvm_find_free_sta_id(struct iwl_mvm *mvm,
 		reserved_ids = BIT(0);
 
 	/* Don't take rcu_read_lock() since we are protected by mvm->mutex */
-	for (sta_id = 0; sta_id < IWL_MVM_STATION_COUNT; sta_id++) {
+	for (sta_id = 0; sta_id < ARRAY_SIZE(mvm->fw_id_to_mac_id); sta_id++) {
 		if (BIT(sta_id) & reserved_ids)
 			continue;
 
@@ -106,7 +106,7 @@ static int iwl_mvm_find_free_sta_id(struct iwl_mvm *mvm,
 					       lockdep_is_held(&mvm->mutex)))
 			return sta_id;
 	}
-	return IWL_MVM_STATION_COUNT;
+	return IWL_MVM_INVALID_STA;
 }
 
 /* send station add/update command to firmware */
@@ -1235,7 +1235,7 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 	else
 		sta_id = mvm_sta->sta_id;
 
-	if (sta_id == IWL_MVM_STATION_COUNT)
+	if (sta_id == IWL_MVM_INVALID_STA)
 		return -ENOSPC;
 
 	spin_lock_init(&mvm_sta->lock);
@@ -1317,10 +1317,10 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 
 	if (vif->type == NL80211_IFTYPE_STATION) {
 		if (!sta->tdls) {
-			WARN_ON(mvmvif->ap_sta_id != IWL_MVM_STATION_COUNT);
+			WARN_ON(mvmvif->ap_sta_id != IWL_MVM_INVALID_STA);
 			mvmvif->ap_sta_id = sta_id;
 		} else {
-			WARN_ON(mvmvif->ap_sta_id == IWL_MVM_STATION_COUNT);
+			WARN_ON(mvmvif->ap_sta_id == IWL_MVM_INVALID_STA);
 		}
 	}
 
@@ -1571,11 +1571,11 @@ int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
 				return ret;
 
 			/* unassoc - go ahead - remove the AP STA now */
-			mvmvif->ap_sta_id = IWL_MVM_STATION_COUNT;
+			mvmvif->ap_sta_id = IWL_MVM_INVALID_STA;
 
 			/* clear d0i3_ap_sta_id if no longer relevant */
 			if (mvm->d0i3_ap_sta_id == sta_id)
-				mvm->d0i3_ap_sta_id = IWL_MVM_STATION_COUNT;
+				mvm->d0i3_ap_sta_id = IWL_MVM_INVALID_STA;
 		}
 	}
 
@@ -1584,7 +1584,7 @@ int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
 	 * before the STA is removed.
 	 */
 	if (WARN_ON_ONCE(mvm->tdls_cs.peer.sta_id == sta_id)) {
-		mvm->tdls_cs.peer.sta_id = IWL_MVM_STATION_COUNT;
+		mvm->tdls_cs.peer.sta_id = IWL_MVM_INVALID_STA;
 		cancel_delayed_work(&mvm->tdls_cs.dwork);
 	}
 
@@ -1641,7 +1641,7 @@ int iwl_mvm_allocate_int_sta(struct iwl_mvm *mvm,
 {
 	if (!test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status)) {
 		sta->sta_id = iwl_mvm_find_free_sta_id(mvm, iftype);
-		if (WARN_ON_ONCE(sta->sta_id == IWL_MVM_STATION_COUNT))
+		if (WARN_ON_ONCE(sta->sta_id == IWL_MVM_INVALID_STA))
 			return -ENOSPC;
 	}
 
@@ -1656,7 +1656,7 @@ void iwl_mvm_dealloc_int_sta(struct iwl_mvm *mvm, struct iwl_mvm_int_sta *sta)
 {
 	RCU_INIT_POINTER(mvm->fw_id_to_mac_id[sta->sta_id], NULL);
 	memset(sta, 0, sizeof(struct iwl_mvm_int_sta));
-	sta->sta_id = IWL_MVM_STATION_COUNT;
+	sta->sta_id = IWL_MVM_INVALID_STA;
 }
 
 static int iwl_mvm_add_int_sta_common(struct iwl_mvm *mvm,
@@ -1836,7 +1836,7 @@ int iwl_mvm_send_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	if (vif->type == NL80211_IFTYPE_ADHOC)
 		baddr = vif->bss_conf.bssid;
 
-	if (WARN_ON_ONCE(bsta->sta_id == IWL_MVM_STATION_COUNT))
+	if (WARN_ON_ONCE(bsta->sta_id == IWL_MVM_INVALID_STA))
 		return -ENOSPC;
 
 	ret = iwl_mvm_add_int_sta_common(mvm, bsta, baddr,
@@ -2736,7 +2736,7 @@ static struct iwl_mvm_sta *iwl_mvm_get_key_sta(struct iwl_mvm *mvm,
 	 * station ID, then use AP's station ID.
 	 */
 	if (vif->type == NL80211_IFTYPE_STATION &&
-	    mvmvif->ap_sta_id != IWL_MVM_STATION_COUNT) {
+	    mvmvif->ap_sta_id != IWL_MVM_INVALID_STA) {
 		u8 sta_id = mvmvif->ap_sta_id;
 
 		sta = rcu_dereference_check(mvm->fw_id_to_mac_id[sta_id],
@@ -2948,7 +2948,7 @@ static inline u8 *iwl_mvm_get_mac_addr(struct iwl_mvm *mvm,
 		return sta->addr;
 
 	if (vif->type == NL80211_IFTYPE_STATION &&
-	    mvmvif->ap_sta_id != IWL_MVM_STATION_COUNT) {
+	    mvmvif->ap_sta_id != IWL_MVM_INVALID_STA) {
 		u8 sta_id = mvmvif->ap_sta_id;
 		sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[sta_id],
 						lockdep_is_held(&mvm->mutex));
@@ -3145,7 +3145,7 @@ int iwl_mvm_remove_sta_key(struct iwl_mvm *mvm,
 {
 	bool mcast = !(keyconf->flags & IEEE80211_KEY_FLAG_PAIRWISE);
 	struct iwl_mvm_sta *mvm_sta;
-	u8 sta_id = IWL_MVM_STATION_COUNT;
+	u8 sta_id = IWL_MVM_INVALID_STA;
 	int ret, i;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -3402,7 +3402,7 @@ void iwl_mvm_modify_all_sta_disable_tx(struct iwl_mvm *mvm,
 	lockdep_assert_held(&mvm->mutex);
 
 	/* Block/unblock all the stations of the given mvmvif */
-	for (i = 0; i < IWL_MVM_STATION_COUNT; i++) {
+	for (i = 0; i < ARRAY_SIZE(mvm->fw_id_to_mac_id); i++) {
 		sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[i],
 						lockdep_is_held(&mvm->mutex));
 		if (IS_ERR_OR_NULL(sta))
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tdls.c b/drivers/net/wireless/intel/iwlwifi/mvm/tdls.c
index 9f160fc58cd0..df7cd87199ea 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tdls.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tdls.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2017 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -78,7 +80,7 @@ void iwl_mvm_teardown_tdls_peers(struct iwl_mvm *mvm)
 
 	lockdep_assert_held(&mvm->mutex);
 
-	for (i = 0; i < IWL_MVM_STATION_COUNT; i++) {
+	for (i = 0; i < ARRAY_SIZE(mvm->fw_id_to_mac_id); i++) {
 		sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[i],
 						lockdep_is_held(&mvm->mutex));
 		if (!sta || IS_ERR(sta) || !sta->tdls)
@@ -101,7 +103,7 @@ int iwl_mvm_tdls_sta_count(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 	lockdep_assert_held(&mvm->mutex);
 
-	for (i = 0; i < IWL_MVM_STATION_COUNT; i++) {
+	for (i = 0; i < ARRAY_SIZE(mvm->fw_id_to_mac_id); i++) {
 		sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[i],
 						lockdep_is_held(&mvm->mutex));
 		if (!sta || IS_ERR(sta) || !sta->tdls)
@@ -145,7 +147,7 @@ static void iwl_mvm_tdls_config(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 	/* populate TDLS peer data */
 	cnt = 0;
-	for (i = 0; i < IWL_MVM_STATION_COUNT; i++) {
+	for (i = 0; i < ARRAY_SIZE(mvm->fw_id_to_mac_id); i++) {
 		sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[i],
 						lockdep_is_held(&mvm->mutex));
 		if (IS_ERR_OR_NULL(sta) || !sta->tdls)
@@ -251,7 +253,7 @@ static void iwl_mvm_tdls_update_cs_state(struct iwl_mvm *mvm,
 			iwl_read_prph(mvm->trans, DEVICE_SYSTEM_TIME_REG);
 
 	if (state == IWL_MVM_TDLS_SW_IDLE)
-		mvm->tdls_cs.cur_sta_id = IWL_MVM_STATION_COUNT;
+		mvm->tdls_cs.cur_sta_id = IWL_MVM_INVALID_STA;
 }
 
 void iwl_mvm_rx_tdls_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
@@ -305,7 +307,7 @@ iwl_mvm_tdls_check_action(struct iwl_mvm *mvm,
 
 	/* get the existing peer if it's there */
 	if (mvm->tdls_cs.state != IWL_MVM_TDLS_SW_IDLE &&
-	    mvm->tdls_cs.cur_sta_id != IWL_MVM_STATION_COUNT) {
+	    mvm->tdls_cs.cur_sta_id != IWL_MVM_INVALID_STA) {
 		struct ieee80211_sta *sta = rcu_dereference_protected(
 				mvm->fw_id_to_mac_id[mvm->tdls_cs.cur_sta_id],
 				lockdep_is_held(&mvm->mutex));
@@ -523,7 +525,7 @@ void iwl_mvm_tdls_ch_switch_work(struct work_struct *work)
 	iwl_mvm_tdls_update_cs_state(mvm, IWL_MVM_TDLS_SW_IDLE);
 
 	/* station might be gone, in that case do nothing */
-	if (mvm->tdls_cs.peer.sta_id == IWL_MVM_STATION_COUNT)
+	if (mvm->tdls_cs.peer.sta_id == IWL_MVM_INVALID_STA)
 		goto out;
 
 	sta = rcu_dereference_protected(
@@ -573,7 +575,7 @@ iwl_mvm_tdls_channel_switch(struct ieee80211_hw *hw,
 		       sta->addr, chandef->chan->center_freq, chandef->width);
 
 	/* we only support a single peer for channel switching */
-	if (mvm->tdls_cs.peer.sta_id != IWL_MVM_STATION_COUNT) {
+	if (mvm->tdls_cs.peer.sta_id != IWL_MVM_INVALID_STA) {
 		IWL_DEBUG_TDLS(mvm,
 			       "Existing peer. Can't start switch with %pM\n",
 			       sta->addr);
@@ -633,7 +635,7 @@ void iwl_mvm_tdls_cancel_channel_switch(struct ieee80211_hw *hw,
 	IWL_DEBUG_TDLS(mvm, "TDLS cancel channel switch with %pM\n", sta->addr);
 
 	/* we only support a single peer for channel switching */
-	if (mvm->tdls_cs.peer.sta_id == IWL_MVM_STATION_COUNT) {
+	if (mvm->tdls_cs.peer.sta_id == IWL_MVM_INVALID_STA) {
 		IWL_DEBUG_TDLS(mvm, "No ch switch peer - %pM\n", sta->addr);
 		goto out;
 	}
@@ -654,7 +656,7 @@ void iwl_mvm_tdls_cancel_channel_switch(struct ieee80211_hw *hw,
 	    mvm->tdls_cs.state != IWL_MVM_TDLS_SW_IDLE)
 		wait_for_phy = true;
 
-	mvm->tdls_cs.peer.sta_id = IWL_MVM_STATION_COUNT;
+	mvm->tdls_cs.peer.sta_id = IWL_MVM_INVALID_STA;
 	dev_kfree_skb(mvm->tdls_cs.peer.skb);
 	mvm->tdls_cs.peer.skb = NULL;
 
@@ -697,7 +699,7 @@ iwl_mvm_tdls_recv_channel_switch(struct ieee80211_hw *hw,
 	if (params->action_code == WLAN_TDLS_CHANNEL_SWITCH_RESPONSE &&
 	    params->status != 0 &&
 	    mvm->tdls_cs.state == IWL_MVM_TDLS_SW_REQ_SENT &&
-	    mvm->tdls_cs.cur_sta_id != IWL_MVM_STATION_COUNT) {
+	    mvm->tdls_cs.cur_sta_id != IWL_MVM_INVALID_STA) {
 		struct ieee80211_sta *cur_sta;
 
 		/* make sure it's the same peer */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tof.c b/drivers/net/wireless/intel/iwlwifi/mvm/tof.c
index a1947d6f3a2c..16ce8a56b5b9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tof.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tof.c
@@ -80,7 +80,7 @@ void iwl_mvm_tof_init(struct iwl_mvm *mvm)
 	if (IWL_MVM_TOF_IS_RESPONDER) {
 		tof_data->responder_cfg.sub_grp_cmd_id =
 			cpu_to_le32(TOF_RESPONDER_CONFIG_CMD);
-		tof_data->responder_cfg.sta_id = IWL_MVM_STATION_COUNT;
+		tof_data->responder_cfg.sta_id = IWL_MVM_INVALID_STA;
 	}
 #endif
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
index bec7d9c46087..f9cbd197246f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
@@ -356,7 +356,7 @@ static void iwl_mvm_tt_tx_protection(struct iwl_mvm *mvm, bool enable)
 	struct iwl_mvm_sta *mvmsta;
 	int i, err;
 
-	for (i = 0; i < IWL_MVM_STATION_COUNT; i++) {
+	for (i = 0; i < ARRAY_SIZE(mvm->fw_id_to_mac_id); i++) {
 		mvmsta = iwl_mvm_sta_from_staid_protected(mvm, i);
 		if (!mvmsta)
 			continue;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 568b0793e84e..d76cc422b040 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -595,7 +595,7 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 			   is_multicast_ether_addr(hdr->addr1)) {
 			u8 ap_sta_id = ACCESS_ONCE(mvmvif->ap_sta_id);
 
-			if (ap_sta_id != IWL_MVM_STATION_COUNT)
+			if (ap_sta_id != IWL_MVM_INVALID_STA)
 				sta_id = ap_sta_id;
 		} else if (iwl_mvm_is_dqa_supported(mvm) &&
 			   info.control.vif->type == NL80211_IFTYPE_STATION &&
@@ -893,7 +893,7 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 	if (WARN_ON_ONCE(!mvmsta))
 		return -1;
 
-	if (WARN_ON_ONCE(mvmsta->sta_id == IWL_MVM_STATION_COUNT))
+	if (WARN_ON_ONCE(mvmsta->sta_id == IWL_MVM_INVALID_STA))
 		return -1;
 
 	dev_cmd = iwl_mvm_set_tx_params(mvm, skb, info, hdrlen,
@@ -1033,7 +1033,7 @@ int iwl_mvm_tx_skb(struct iwl_mvm *mvm, struct sk_buff *skb,
 	if (WARN_ON_ONCE(!mvmsta))
 		return -1;
 
-	if (WARN_ON_ONCE(mvmsta->sta_id == IWL_MVM_STATION_COUNT))
+	if (WARN_ON_ONCE(mvmsta->sta_id == IWL_MVM_INVALID_STA))
 		return -1;
 
 	memcpy(&info, skb->cb, sizeof(info));
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 8f199ff9be87..3054945b949a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -824,7 +824,7 @@ int iwl_mvm_send_lq_cmd(struct iwl_mvm *mvm, struct iwl_lq_cmd *lq, bool init)
 		.data = { lq, },
 	};
 
-	if (WARN_ON(lq->sta_id == IWL_MVM_STATION_COUNT))
+	if (WARN_ON(lq->sta_id == IWL_MVM_INVALID_STA))
 		return -EINVAL;
 
 	return iwl_mvm_send_cmd(mvm, &cmd);
-- 
2.11.0
