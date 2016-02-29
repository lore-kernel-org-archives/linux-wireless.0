Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:41124 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbcB2NZq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 08:25:46 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, QH <qiumin.hu@gmail.com>,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Etan Cohen <etancohen@google.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/12] iwlwifi: mvm: Add support for NAN interface type
Date: Mon, 29 Feb 2016 15:25:12 +0200
Message-Id: <1456752313-5792-12-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160229_142949_537464_14E028A5)
In-Reply-To: <1456752313-5792-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1456752313-5792-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Declare support NL80211_IFTYPE_NAN and add dummy nan_start/stop
functions to the driver. NAN interface is a virtual interface, which
doesn't have a MAC context. Currently no TX/RX is required, so no
queues are allocated for NAN device.
NAN interface type is supported only when the FW has
IWL_UCODE_TLV_CAPA_NAN_SUPPORT. Like P2P device interface, it
is allowed to have only one NAN interface and it can co-exist
with other interface types.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h   |  4 ++
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   |  6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  | 22 +++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 80 ++++++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/power.c     |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/quota.c     |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/sf.c        |  6 +-
 7 files changed, 111 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
index 84f8aeb..e57c0f6 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
@@ -308,6 +308,7 @@ typedef unsigned int __bitwise__ iwl_ucode_tlv_capa_t;
  *	is supported.
  * @IWL_UCODE_TLV_CAPA_BT_COEX_RRC: supports BT Coex RRC
  * @IWL_UCODE_TLV_CAPA_GSCAN_SUPPORT: supports gscan
+ * @IWL_UCODE_TLV_CAPA_NAN_SUPPORT: supports NAN
  * @IWL_UCODE_TLV_CAPA_EXTENDED_DTS_MEASURE: extended DTS measurement
  * @IWL_UCODE_TLV_CAPA_SHORT_PM_TIMEOUTS: supports short PM timeouts
  * @IWL_UCODE_TLV_CAPA_BT_MPLUT_SUPPORT: supports bt-coex Multi-priority LUT
@@ -338,6 +339,7 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_LAR_MULTI_MCC		= (__force iwl_ucode_tlv_capa_t)29,
 	IWL_UCODE_TLV_CAPA_BT_COEX_RRC			= (__force iwl_ucode_tlv_capa_t)30,
 	IWL_UCODE_TLV_CAPA_GSCAN_SUPPORT		= (__force iwl_ucode_tlv_capa_t)31,
+	IWL_UCODE_TLV_CAPA_NAN_SUPPORT			= (__force iwl_ucode_tlv_capa_t)34,
 	IWL_UCODE_TLV_CAPA_EXTENDED_DTS_MEASURE		= (__force iwl_ucode_tlv_capa_t)64,
 	IWL_UCODE_TLV_CAPA_SHORT_PM_TIMEOUTS		= (__force iwl_ucode_tlv_capa_t)65,
 	IWL_UCODE_TLV_CAPA_BT_MPLUT_SUPPORT		= (__force iwl_ucode_tlv_capa_t)67,
@@ -532,6 +534,7 @@ enum iwl_fw_dbg_trigger_mode {
  * @IWL_FW_DBG_CONF_VIF_P2P_CLIENT: P2P Client mode
  * @IWL_FW_DBG_CONF_VIF_P2P_GO: P2P GO mode
  * @IWL_FW_DBG_CONF_VIF_P2P_DEVICE: P2P device
+ * @IWL_FW_DBG_CONF_VIF_NAN: NAN device
  */
 enum iwl_fw_dbg_trigger_vif_type {
 	IWL_FW_DBG_CONF_VIF_ANY = NL80211_IFTYPE_UNSPECIFIED,
@@ -541,6 +544,7 @@ enum iwl_fw_dbg_trigger_vif_type {
 	IWL_FW_DBG_CONF_VIF_P2P_CLIENT = NL80211_IFTYPE_P2P_CLIENT,
 	IWL_FW_DBG_CONF_VIF_P2P_GO = NL80211_IFTYPE_P2P_GO,
 	IWL_FW_DBG_CONF_VIF_P2P_DEVICE = NL80211_IFTYPE_P2P_DEVICE,
+	IWL_FW_DBG_CONF_VIF_NAN = NL80211_IFTYPE_NAN,
 };
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
index 9e0d463..7ae631e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
@@ -259,6 +259,9 @@ static ssize_t iwl_dbgfs_mac_params_read(struct file *file,
 	case NL80211_IFTYPE_P2P_DEVICE:
 		pos += scnprintf(buf+pos, bufsz-pos, "type: p2p dev\n");
 		break;
+	case NL80211_IFTYPE_NAN:
+		pos += scnprintf(buf+pos, bufsz-pos, "type: NAN\n");
+		break;
 	default:
 		break;
 	}
@@ -1430,7 +1433,8 @@ void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 					 S_IRUSR | S_IWUSR);
 
 	if (fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_TOF_SUPPORT) &&
-	    !vif->p2p && (vif->type != NL80211_IFTYPE_P2P_DEVICE)) {
+	    !vif->p2p && (vif->type != NL80211_IFTYPE_P2P_DEVICE) &&
+	    (vif->type != NL80211_IFTYPE_NAN)) {
 		if (IWL_MVM_TOF_IS_RESPONDER && vif->type == NL80211_IFTYPE_AP)
 			MVM_DEBUGFS_ADD_FILE_VIF(tof_responder_params,
 						 mvmvif->dbgfs_dir,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index bf1e5eb..8d3522e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -211,6 +211,10 @@ u32 iwl_mvm_mac_get_queues_mask(struct ieee80211_vif *vif)
 	if (vif->type == NL80211_IFTYPE_P2P_DEVICE)
 		return BIT(IWL_MVM_OFFCHANNEL_QUEUE);
 
+	/* Currently NAN doesn't use queues */
+	if (vif->type == NL80211_IFTYPE_NAN)
+		return 0;
+
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
 		if (vif->hw_queue[ac] != IEEE80211_INVAL_HW_QUEUE)
 			qmask |= BIT(vif->hw_queue[ac]);
@@ -417,8 +421,9 @@ static int iwl_mvm_mac_ctxt_allocate_resources(struct iwl_mvm *mvm,
 	INIT_LIST_HEAD(&mvmvif->time_event_data.list);
 	mvmvif->time_event_data.id = TE_MAX;
 
-	/* No need to allocate data queues to P2P Device MAC.*/
-	if (vif->type == NL80211_IFTYPE_P2P_DEVICE) {
+	/* No need to allocate data queues to P2P Device MAC and NAN.*/
+	if (vif->type == NL80211_IFTYPE_P2P_DEVICE ||
+	    vif->type == NL80211_IFTYPE_NAN) {
 		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
 			vif->hw_queue[ac] = IEEE80211_INVAL_HW_QUEUE;
 
@@ -490,6 +495,8 @@ int iwl_mvm_mac_ctxt_init(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 				      IWL_MVM_OFFCHANNEL_QUEUE,
 				      IWL_MVM_TX_FIFO_VO, 0, wdg_timeout);
 		break;
+	case NL80211_IFTYPE_NAN:
+		break;
 	case NL80211_IFTYPE_AP:
 		iwl_mvm_enable_ac_txq(mvm, vif->cab_queue, vif->cab_queue,
 				      IWL_MVM_TX_FIFO_MCAST, 0, wdg_timeout);
@@ -518,6 +525,8 @@ void iwl_mvm_mac_ctxt_release(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 				    IWL_MVM_OFFCHANNEL_QUEUE, IWL_MAX_TID_COUNT,
 				    0);
 		break;
+	case NL80211_IFTYPE_NAN:
+		break;
 	case NL80211_IFTYPE_AP:
 		iwl_mvm_disable_txq(mvm, vif->cab_queue, vif->cab_queue,
 				    IWL_MAX_TID_COUNT, 0);
@@ -1244,6 +1253,9 @@ int iwl_mvm_mac_ctxt_add(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	int ret;
 
+	if (WARN_ON_ONCE(vif->type == NL80211_IFTYPE_NAN))
+		return -EOPNOTSUPP;
+
 	if (WARN_ONCE(mvmvif->uploaded, "Adding active MAC %pM/%d\n",
 		      vif->addr, ieee80211_vif_type_p2p(vif)))
 		return -EIO;
@@ -1265,6 +1277,9 @@ int iwl_mvm_mac_ctxt_changed(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 
+	if (WARN_ON_ONCE(vif->type == NL80211_IFTYPE_NAN))
+		return -EOPNOTSUPP;
+
 	if (WARN_ONCE(!mvmvif->uploaded, "Changing inactive MAC %pM/%d\n",
 		      vif->addr, ieee80211_vif_type_p2p(vif)))
 		return -EIO;
@@ -1279,6 +1294,9 @@ int iwl_mvm_mac_ctxt_remove(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	struct iwl_mac_ctx_cmd cmd;
 	int ret;
 
+	if (WARN_ON_ONCE(vif->type == NL80211_IFTYPE_NAN))
+		return -EOPNOTSUPP;
+
 	if (WARN_ONCE(!mvmvif->uploaded, "Removing inactive MAC %pM/%d\n",
 		      vif->addr, ieee80211_vif_type_p2p(vif)))
 		return -EIO;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 2b53292..dde74ad 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -115,6 +115,37 @@ static const struct ieee80211_iface_combination iwl_mvm_iface_combinations[] = {
 	},
 };
 
+static const struct ieee80211_iface_limit iwl_mvm_limits_nan[] = {
+	{
+		.max = 1,
+		.types = BIT(NL80211_IFTYPE_STATION),
+	},
+	{
+		.max = 1,
+		.types = BIT(NL80211_IFTYPE_AP) |
+			BIT(NL80211_IFTYPE_P2P_CLIENT) |
+			BIT(NL80211_IFTYPE_P2P_GO),
+	},
+	{
+		.max = 1,
+		.types = BIT(NL80211_IFTYPE_P2P_DEVICE),
+	},
+	{
+		.max = 1,
+		.types = BIT(NL80211_IFTYPE_NAN),
+	},
+};
+
+static const struct ieee80211_iface_combination
+iwl_mvm_iface_combinations_nan[] = {
+	{
+		.num_different_channels = 2,
+		.max_interfaces = 4,
+		.limits = iwl_mvm_limits_nan,
+		.n_limits = ARRAY_SIZE(iwl_mvm_limits_nan),
+	},
+};
+
 #ifdef CONFIG_PM_SLEEP
 static const struct nl80211_wowlan_tcp_data_token_feature
 iwl_mvm_wowlan_tcp_token_feature = {
@@ -511,9 +542,17 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 
 	hw->wiphy->flags |= WIPHY_FLAG_HAS_CHANNEL_SWITCH;
 
-	hw->wiphy->iface_combinations = iwl_mvm_iface_combinations;
-	hw->wiphy->n_iface_combinations =
-		ARRAY_SIZE(iwl_mvm_iface_combinations);
+	if (fw_has_capa(&mvm->fw->ucode_capa,
+			IWL_UCODE_TLV_CAPA_NAN_SUPPORT)) {
+		hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_NAN);
+		hw->wiphy->iface_combinations = iwl_mvm_iface_combinations_nan;
+		hw->wiphy->n_iface_combinations =
+			ARRAY_SIZE(iwl_mvm_iface_combinations_nan);
+	} else {
+		hw->wiphy->iface_combinations = iwl_mvm_iface_combinations;
+		hw->wiphy->n_iface_combinations =
+			ARRAY_SIZE(iwl_mvm_iface_combinations);
+	}
 
 	hw->wiphy->max_remain_on_channel_duration = 10000;
 	hw->max_listen_interval = IWL_CONN_MAX_LISTEN_INTERVAL;
@@ -1263,6 +1302,10 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 	if (ret)
 		goto out_unlock;
 
+	/* Currently not much to do for NAN */
+	if (vif->type == NL80211_IFTYPE_NAN)
+		goto out_unlock;
+
 	/* Counting number of interfaces is needed for legacy PM */
 	if (vif->type != NL80211_IFTYPE_P2P_DEVICE)
 		mvm->vif_count++;
@@ -1410,7 +1453,7 @@ static void iwl_mvm_prepare_mac_removal(struct iwl_mvm *mvm,
 		 * queue are sent in ROC session.
 		 */
 		flush_work(&mvm->roc_done_wk);
-	} else {
+	} else if (vif->type != NL80211_IFTYPE_NAN) {
 		/*
 		 * By now, all the AC queues are empty. The AGG queues are
 		 * empty too. We already got all the Tx responses for all the
@@ -1421,6 +1464,14 @@ static void iwl_mvm_prepare_mac_removal(struct iwl_mvm *mvm,
 	}
 }
 
+static int iwl_mvm_stop_nan(struct ieee80211_hw *hw,
+			    struct ieee80211_vif *vif)
+{
+	IWL_DEBUG_MAC80211(IWL_MAC80211_GET_MVM(hw), "Stop NAN\n");
+
+	return 0;
+}
+
 static void iwl_mvm_mac_remove_interface(struct ieee80211_hw *hw,
 					 struct ieee80211_vif *vif)
 {
@@ -1429,6 +1480,15 @@ static void iwl_mvm_mac_remove_interface(struct ieee80211_hw *hw,
 
 	iwl_mvm_prepare_mac_removal(mvm, vif);
 
+	if (vif->type == NL80211_IFTYPE_NAN) {
+		struct wireless_dev *wdev = ieee80211_vif_to_wdev(vif);
+		/* cfg80211 should stop nan before interface removal */
+		if (wdev && WARN_ON(wdev->nan_started))
+			iwl_mvm_stop_nan(hw, vif);
+
+		return;
+	}
+
 	mutex_lock(&mvm->mutex);
 
 	if (mvm->bf_allowed_vif == mvmvif) {
@@ -3908,6 +3968,15 @@ static void iwl_mvm_mac_event_callback(struct ieee80211_hw *hw,
 	}
 }
 
+static int iwl_mvm_start_nan(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif,
+			     struct cfg80211_nan_conf *conf)
+{
+	IWL_DEBUG_MAC80211(IWL_MAC80211_GET_MVM(hw), "Start NAN\n");
+
+	return 0;
+}
+
 const struct ieee80211_ops iwl_mvm_hw_ops = {
 	.tx = iwl_mvm_mac_tx,
 	.ampdu_action = iwl_mvm_mac_ampdu_action,
@@ -3979,4 +4048,7 @@ const struct ieee80211_ops iwl_mvm_hw_ops = {
 #endif
 	.get_survey = iwl_mvm_mac_get_survey,
 	.sta_statistics = iwl_mvm_mac_sta_statistics,
+
+	.start_nan = iwl_mvm_start_nan,
+	.stop_nan = iwl_mvm_stop_nan,
 };
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/power.c b/drivers/net/wireless/intel/iwlwifi/mvm/power.c
index 9de159f..58dda1d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/power.c
@@ -582,6 +582,7 @@ static void iwl_mvm_power_get_vifs_iterator(void *_data, u8 *mac,
 
 	switch (ieee80211_vif_type_p2p(vif)) {
 	case NL80211_IFTYPE_P2P_DEVICE:
+	case NL80211_IFTYPE_NAN:
 		break;
 
 	case NL80211_IFTYPE_P2P_GO:
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/quota.c b/drivers/net/wireless/intel/iwlwifi/mvm/quota.c
index 0b762b4..48a103f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/quota.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/quota.c
@@ -116,6 +116,7 @@ static void iwl_mvm_quota_iterator(void *_data, u8 *mac,
 			break;
 		return;
 	case NL80211_IFTYPE_P2P_DEVICE:
+	case NL80211_IFTYPE_NAN:
 		return;
 	default:
 		WARN_ON_ONCE(1);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sf.c b/drivers/net/wireless/intel/iwlwifi/mvm/sf.c
index c2def12..c4f9f44 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sf.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sf.c
@@ -83,7 +83,8 @@ static void iwl_mvm_bound_iface_iterator(void *_data, u8 *mac,
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 
 	if (vif == data->ignore_vif || !mvmvif->phy_ctxt ||
-	    vif->type == NL80211_IFTYPE_P2P_DEVICE)
+	    vif->type == NL80211_IFTYPE_P2P_DEVICE ||
+	    vif->type == NL80211_IFTYPE_NAN)
 		return;
 
 	data->num_active_macs++;
@@ -293,7 +294,8 @@ int iwl_mvm_sf_update(struct iwl_mvm *mvm, struct ieee80211_vif *changed_vif,
 	 * vif is a p2p device.
 	 */
 	if (test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status) ||
-	    (changed_vif && changed_vif->type == NL80211_IFTYPE_P2P_DEVICE))
+	    (changed_vif && (changed_vif->type == NL80211_IFTYPE_P2P_DEVICE ||
+			     changed_vif->type == NL80211_IFTYPE_NAN)))
 		return 0;
 
 	ieee80211_iterate_active_interfaces_atomic(mvm->hw,
-- 
2.5.0

