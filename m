Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:59280 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbaGFJgj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:36:39 -0400
Received: by mail-wg0-f46.google.com with SMTP id y10so3119174wgg.17
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:36:37 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/40] iwlwifi: mvm: BT Coex - new API
Date: Sun,  6 Jul 2014 12:35:47 +0300
Message-Id: <1404639376-3792-11-git-send-email-egrumbach@gmail.com> (sfid-20140706_115953_012398_1D11B79D)
In-Reply-To: <53B917DC.5050902@gmail.com>
References: <53B917DC.5050902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Start the new BT Coex implementation.
Don't react to notifications for now - only the initial
configuration is implemented. The rest will happen in next
patches.
Since coex.c now uses the new the new structures in all
functions, we need to adapt the code to compile, even if it
doesn't run yet.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c        | 178 +++++++----------------
 drivers/net/wireless/iwlwifi/mvm/debugfs.c     |  22 +--
 drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h | 193 +++++++++++++++++++++----
 drivers/net/wireless/iwlwifi/mvm/fw-api.h      |   5 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h         |   4 +-
 drivers/net/wireless/iwlwifi/mvm/ops.c         |   3 +
 6 files changed, 233 insertions(+), 172 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index 3aa3d61..23f639a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -70,48 +70,8 @@
 #include "mvm.h"
 #include "iwl-debug.h"
 
-#define EVENT_PRIO_ANT(_evt, _prio, _shrd_ant)			\
-	[(_evt)] = (((_prio) << BT_COEX_PRIO_TBL_PRIO_POS) |	\
-		   ((_shrd_ant) << BT_COEX_PRIO_TBL_SHRD_ANT_POS))
-
-static const u8 iwl_bt_prio_tbl[BT_COEX_PRIO_TBL_EVT_MAX] = {
-	EVENT_PRIO_ANT(BT_COEX_PRIO_TBL_EVT_INIT_CALIB1,
-		       BT_COEX_PRIO_TBL_PRIO_BYPASS, 0),
-	EVENT_PRIO_ANT(BT_COEX_PRIO_TBL_EVT_INIT_CALIB2,
-		       BT_COEX_PRIO_TBL_PRIO_BYPASS, 1),
-	EVENT_PRIO_ANT(BT_COEX_PRIO_TBL_EVT_PERIODIC_CALIB_LOW1,
-		       BT_COEX_PRIO_TBL_PRIO_LOW, 0),
-	EVENT_PRIO_ANT(BT_COEX_PRIO_TBL_EVT_PERIODIC_CALIB_LOW2,
-		       BT_COEX_PRIO_TBL_PRIO_LOW, 1),
-	EVENT_PRIO_ANT(BT_COEX_PRIO_TBL_EVT_PERIODIC_CALIB_HIGH1,
-		       BT_COEX_PRIO_TBL_PRIO_HIGH, 0),
-	EVENT_PRIO_ANT(BT_COEX_PRIO_TBL_EVT_PERIODIC_CALIB_HIGH2,
-		       BT_COEX_PRIO_TBL_PRIO_HIGH, 1),
-	EVENT_PRIO_ANT(BT_COEX_PRIO_TBL_EVT_DTIM,
-		       BT_COEX_PRIO_TBL_DISABLED, 0),
-	EVENT_PRIO_ANT(BT_COEX_PRIO_TBL_EVT_SCAN52,
-		       BT_COEX_PRIO_TBL_PRIO_COEX_OFF, 0),
-	EVENT_PRIO_ANT(BT_COEX_PRIO_TBL_EVT_SCAN24,
-		       BT_COEX_PRIO_TBL_PRIO_COEX_ON, 0),
-	EVENT_PRIO_ANT(BT_COEX_PRIO_TBL_EVT_IDLE,
-		       BT_COEX_PRIO_TBL_PRIO_COEX_IDLE, 0),
-	0, 0, 0, 0, 0, 0,
-};
-
-#undef EVENT_PRIO_ANT
-
 #define BT_ANTENNA_COUPLING_THRESHOLD		(30)
 
-static int iwl_send_bt_prio_tbl(struct iwl_mvm *mvm)
-{
-	if (unlikely(mvm->bt_force_ant_mode != BT_FORCE_ANT_DIS))
-		return 0;
-
-	return iwl_mvm_send_cmd_pdu(mvm, BT_COEX_PRIO_TABLE, 0,
-				    sizeof(struct iwl_bt_coex_prio_tbl_cmd),
-				    &iwl_bt_prio_tbl);
-}
-
 const u32 iwl_bt_ack_kill_msk[BT_KILL_MSK_MAX] = {
 	[BT_KILL_MSK_DEFAULT] = 0xffff0000,
 	[BT_KILL_MSK_SCO_HID_A2DP] = 0xffffffff,
@@ -520,6 +480,7 @@ iwl_get_coex_type(struct iwl_mvm *mvm, const struct ieee80211_vif *vif)
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	enum iwl_bt_coex_lut_type ret;
 	u16 phy_ctx_id;
+	u32 primary_ch_phy_id, secondary_ch_phy_id;
 
 	/*
 	 * Checking that we hold mvm->mutex is a good idea, but the rate
@@ -547,10 +508,13 @@ iwl_get_coex_type(struct iwl_mvm *mvm, const struct ieee80211_vif *vif)
 	}
 
 	phy_ctx_id = *((u16 *)chanctx_conf->drv_priv);
+	primary_ch_phy_id = le32_to_cpu(mvm->last_bt_ci_cmd.primary_ch_phy_id);
+	secondary_ch_phy_id =
+		le32_to_cpu(mvm->last_bt_ci_cmd.secondary_ch_phy_id);
 
-	if (mvm->last_bt_ci_cmd.primary_ch_phy_id == phy_ctx_id)
+	if (primary_ch_phy_id == phy_ctx_id)
 		ret = le32_to_cpu(mvm->last_bt_notif.primary_ch_lut);
-	else if (mvm->last_bt_ci_cmd.secondary_ch_phy_id == phy_ctx_id)
+	else if (secondary_ch_phy_id == phy_ctx_id)
 		ret = le32_to_cpu(mvm->last_bt_notif.secondary_ch_lut);
 	/* else - default = TX TX disallowed */
 
@@ -561,25 +525,18 @@ iwl_get_coex_type(struct iwl_mvm *mvm, const struct ieee80211_vif *vif)
 
 int iwl_send_bt_init_conf(struct iwl_mvm *mvm)
 {
-	struct iwl_bt_coex_cmd_old *bt_cmd;
+	struct iwl_bt_coex_cmd *bt_cmd;
 	struct iwl_host_cmd cmd = {
 		.id = BT_CONFIG,
 		.len = { sizeof(*bt_cmd), },
 		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
 	};
 	int ret;
-	u32 flags;
+	u32 mode;
 
 	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_BT_COEX_SPLIT))
 		return iwl_send_bt_init_conf_old(mvm);
 
-	/* TODO */
-	return 0;
-
-	ret = iwl_send_bt_prio_tbl(mvm);
-	if (ret)
-		return ret;
-
 	bt_cmd = kzalloc(sizeof(*bt_cmd), GFP_KERNEL);
 	if (!bt_cmd)
 		return -ENOMEM;
@@ -588,66 +545,46 @@ int iwl_send_bt_init_conf(struct iwl_mvm *mvm)
 	lockdep_assert_held(&mvm->mutex);
 
 	if (unlikely(mvm->bt_force_ant_mode != BT_FORCE_ANT_DIS)) {
+		u32 mode;
+
 		switch (mvm->bt_force_ant_mode) {
-		case BT_FORCE_ANT_AUTO:
-			flags = BT_COEX_AUTO_OLD;
-			break;
 		case BT_FORCE_ANT_BT:
-			flags = BT_COEX_BT_OLD;
+			mode = BT_COEX_BT;
 			break;
 		case BT_FORCE_ANT_WIFI:
-			flags = BT_COEX_WIFI_OLD;
+			mode = BT_COEX_WIFI;
 			break;
 		default:
 			WARN_ON(1);
-			flags = 0;
+			mode = 0;
 		}
 
-		bt_cmd->flags = cpu_to_le32(flags);
-		bt_cmd->valid_bit_msk = cpu_to_le32(BT_VALID_ENABLE);
+		bt_cmd->mode = cpu_to_le32(mode);
 		goto send_cmd;
 	}
 
-	bt_cmd->max_kill = 5;
-	bt_cmd->bt4_antenna_isolation_thr = BT_ANTENNA_COUPLING_THRESHOLD;
-	bt_cmd->bt4_antenna_isolation = iwlwifi_mod_params.ant_coupling;
-	bt_cmd->bt4_tx_tx_delta_freq_thr = 15;
-	bt_cmd->bt4_tx_rx_max_freq0 = 15;
-	bt_cmd->override_primary_lut = BT_COEX_INVALID_LUT;
-	bt_cmd->override_secondary_lut = BT_COEX_INVALID_LUT;
-
-	flags = iwlwifi_mod_params.bt_coex_active ?
-			BT_COEX_NW_OLD : BT_COEX_DISABLE_OLD;
-	bt_cmd->flags = cpu_to_le32(flags);
-
-	bt_cmd->valid_bit_msk = cpu_to_le32(BT_VALID_ENABLE |
-					    BT_VALID_BT_PRIO_BOOST |
-					    BT_VALID_MAX_KILL |
-					    BT_VALID_3W_TMRS |
-					    BT_VALID_KILL_ACK |
-					    BT_VALID_KILL_CTS |
-					    BT_VALID_REDUCED_TX_POWER |
-					    BT_VALID_LUT |
-					    BT_VALID_WIFI_RX_SW_PRIO_BOOST |
-					    BT_VALID_WIFI_TX_SW_PRIO_BOOST |
-					    BT_VALID_ANT_ISOLATION |
-					    BT_VALID_ANT_ISOLATION_THRS |
-					    BT_VALID_TXTX_DELTA_FREQ_THRS |
-					    BT_VALID_TXRX_MAX_FREQ_0 |
-					    BT_VALID_SYNC_TO_SCO);
+	bt_cmd->max_kill = cpu_to_le32(5);
+	bt_cmd->bt4_antenna_isolation_thr =
+				cpu_to_le32(BT_ANTENNA_COUPLING_THRESHOLD);
+	bt_cmd->bt4_tx_tx_delta_freq_thr = cpu_to_le32(15);
+	bt_cmd->bt4_tx_rx_max_freq0 = cpu_to_le32(15);
+	bt_cmd->override_primary_lut = cpu_to_le32(BT_COEX_INVALID_LUT);
+	bt_cmd->override_secondary_lut = cpu_to_le32(BT_COEX_INVALID_LUT);
+
+	mode = iwlwifi_mod_params.bt_coex_active ? BT_COEX_NW : BT_COEX_DISABLE;
+	bt_cmd->mode = cpu_to_le32(mode);
 
 	if (IWL_MVM_BT_COEX_SYNC2SCO)
-		bt_cmd->flags |= cpu_to_le32(BT_COEX_SYNC2SCO);
+		bt_cmd->enabled_modules |=
+			cpu_to_le32(BT_COEX_SYNC2SCO_ENABLED);
 
-	if (IWL_MVM_BT_COEX_CORUNNING) {
-		bt_cmd->valid_bit_msk |= cpu_to_le32(BT_VALID_CORUN_LUT_20 |
-						     BT_VALID_CORUN_LUT_40);
-		bt_cmd->flags |= cpu_to_le32(BT_COEX_CORUNNING);
-	}
+	if (IWL_MVM_BT_COEX_CORUNNING)
+		bt_cmd->enabled_modules |= cpu_to_le32(BT_COEX_CORUN_ENABLED);
 
 	if (IWL_MVM_BT_COEX_MPLUT) {
-		bt_cmd->flags |= cpu_to_le32(BT_COEX_MPLUT);
-		bt_cmd->valid_bit_msk |= cpu_to_le32(BT_VALID_MULTI_PRIO_LUT);
+		bt_cmd->enabled_modules |= cpu_to_le32(BT_COEX_MPLUT_ENABLED);
+		bt_cmd->enabled_modules |=
+			cpu_to_le32(BT_COEX_MPLUT_BOOST_ENABLED);
 	}
 
 	if (mvm->cfg->bt_shared_single_ant)
@@ -657,20 +594,10 @@ int iwl_send_bt_init_conf(struct iwl_mvm *mvm)
 		memcpy(&bt_cmd->decision_lut, iwl_combined_lookup,
 		       sizeof(iwl_combined_lookup));
 
-	/* Take first Co-running block LUT to get started */
-	memcpy(bt_cmd->bt4_corun_lut20, antenna_coupling_ranges[0].lut20,
-	       sizeof(bt_cmd->bt4_corun_lut20));
-	memcpy(bt_cmd->bt4_corun_lut40, antenna_coupling_ranges[0].lut20,
-	       sizeof(bt_cmd->bt4_corun_lut40));
-
-	memcpy(&bt_cmd->bt_prio_boost, iwl_bt_prio_boost,
+	memcpy(&bt_cmd->mplut_prio_boost, iwl_bt_prio_boost,
 	       sizeof(iwl_bt_prio_boost));
-	memcpy(&bt_cmd->bt4_multiprio_lut, iwl_bt_mprio_lut,
+	memcpy(&bt_cmd->multiprio_lut, iwl_bt_mprio_lut,
 	       sizeof(iwl_bt_mprio_lut));
-	bt_cmd->kill_ack_msk =
-		cpu_to_le32(iwl_bt_ack_kill_msk[BT_KILL_MSK_DEFAULT]);
-	bt_cmd->kill_cts_msk =
-		cpu_to_le32(iwl_bt_cts_kill_msk[BT_KILL_MSK_DEFAULT]);
 
 send_cmd:
 	memset(&mvm->last_bt_notif, 0, sizeof(mvm->last_bt_notif));
@@ -687,7 +614,7 @@ static int iwl_mvm_bt_udpate_ctrl_kill_msk(struct iwl_mvm *mvm,
 {
 	enum iwl_bt_kill_msk bt_kill_msk;
 	struct iwl_bt_coex_cmd_old *bt_cmd;
-	struct iwl_bt_coex_profile_notif_old *notif = &mvm->last_bt_notif;
+	struct iwl_bt_coex_profile_notif *notif = &mvm->last_bt_notif;
 	struct iwl_host_cmd cmd = {
 		.id = BT_CONFIG,
 		.data[0] = &bt_cmd,
@@ -760,6 +687,8 @@ static int iwl_mvm_bt_coex_reduced_txp(struct iwl_mvm *mvm, u8 sta_id,
 	struct iwl_mvm_sta *mvmsta;
 	int ret;
 
+	return 0;
+
 	mvmsta = iwl_mvm_sta_from_staid_protected(mvm, sta_id);
 	if (!mvmsta)
 		return 0;
@@ -793,7 +722,7 @@ static int iwl_mvm_bt_coex_reduced_txp(struct iwl_mvm *mvm, u8 sta_id,
 }
 
 struct iwl_bt_iterator_data {
-	struct iwl_bt_coex_profile_notif_old *notif;
+	struct iwl_bt_coex_profile_notif *notif;
 	struct iwl_mvm *mvm;
 	u32 num_bss_ifaces;
 	bool reduced_tx_power;
@@ -883,9 +812,8 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 		smps_mode = IEEE80211_SMPS_AUTOMATIC;
 
 	IWL_DEBUG_COEX(data->mvm,
-		       "mac %d: bt_status %d bt_activity_grading %d smps_req %d\n",
-		       mvmvif->id, data->notif->bt_status, bt_activity_grading,
-		       smps_mode);
+		       "mac %d: bt_activity_grading %d smps_req %d\n",
+		       mvmvif->id, bt_activity_grading, smps_mode);
 
 	iwl_mvm_update_smps(mvm, vif, IWL_MVM_SMPS_REQ_BT_COEX, smps_mode);
 
@@ -937,7 +865,7 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 	 */
 	if (iwl_get_coex_type(mvm, vif) == BT_COEX_LOOSE_LUT ||
 	    mvm->cfg->bt_shared_single_ant || !vif->bss_conf.assoc ||
-	    !data->notif->bt_status) {
+	    le32_to_cpu(mvm->last_bt_notif.bt_activity_grading) == BT_OFF) {
 		data->reduced_tx_power = false;
 		iwl_mvm_bt_coex_reduced_txp(mvm, mvmvif->ap_sta_id, false);
 		iwl_mvm_bt_coex_enable_rssi_event(mvm, vif, false, 0);
@@ -983,7 +911,7 @@ static void iwl_mvm_bt_coex_notif_handle(struct iwl_mvm *mvm)
 		.notif = &mvm->last_bt_notif,
 		.reduced_tx_power = true,
 	};
-	struct iwl_bt_coex_ci_cmd_old cmd = {};
+	struct iwl_bt_coex_ci_cmd cmd = {};
 	u8 ci_bw_idx;
 
 	/* Ignore updates if we are in force mode */
@@ -1004,9 +932,7 @@ static void iwl_mvm_bt_coex_notif_handle(struct iwl_mvm *mvm)
 
 		if (chan->def.width < NL80211_CHAN_WIDTH_40) {
 			ci_bw_idx = 0;
-			cmd.co_run_bw_primary = 0;
 		} else {
-			cmd.co_run_bw_primary = 1;
 			if (chan->def.center_freq1 >
 			    chan->def.chan->center_freq)
 				ci_bw_idx = 2;
@@ -1016,7 +942,8 @@ static void iwl_mvm_bt_coex_notif_handle(struct iwl_mvm *mvm)
 
 		cmd.bt_primary_ci =
 			iwl_ci_mask[chan->def.chan->hw_value][ci_bw_idx];
-		cmd.primary_ch_phy_id = *((u16 *)data.primary->drv_priv);
+		cmd.primary_ch_phy_id =
+			cpu_to_le32(*((u16 *)data.primary->drv_priv));
 	}
 
 	if (data.secondary) {
@@ -1028,9 +955,7 @@ static void iwl_mvm_bt_coex_notif_handle(struct iwl_mvm *mvm)
 
 		if (chan->def.width < NL80211_CHAN_WIDTH_40) {
 			ci_bw_idx = 0;
-			cmd.co_run_bw_secondary = 0;
 		} else {
-			cmd.co_run_bw_secondary = 1;
 			if (chan->def.center_freq1 >
 			    chan->def.chan->center_freq)
 				ci_bw_idx = 2;
@@ -1040,7 +965,8 @@ static void iwl_mvm_bt_coex_notif_handle(struct iwl_mvm *mvm)
 
 		cmd.bt_secondary_ci =
 			iwl_ci_mask[chan->def.chan->hw_value][ci_bw_idx];
-		cmd.secondary_ch_phy_id = *((u16 *)data.secondary->drv_priv);
+		cmd.secondary_ch_phy_id =
+			cpu_to_le32(*((u16 *)data.secondary->drv_priv));
 	}
 
 	rcu_read_unlock();
@@ -1078,9 +1004,6 @@ int iwl_mvm_rx_bt_coex_notif(struct iwl_mvm *mvm,
 	return 0;
 
 	IWL_DEBUG_COEX(mvm, "BT Coex Notification received\n");
-	IWL_DEBUG_COEX(mvm, "\tBT status: %s\n",
-		       notif->bt_status ? "ON" : "OFF");
-	IWL_DEBUG_COEX(mvm, "\tBT open conn %d\n", notif->bt_open_conn);
 	IWL_DEBUG_COEX(mvm, "\tBT ci compliance %d\n", notif->bt_ci_compliance);
 	IWL_DEBUG_COEX(mvm, "\tBT primary_ch_lut %d\n",
 		       le32_to_cpu(notif->primary_ch_lut));
@@ -1088,8 +1011,6 @@ int iwl_mvm_rx_bt_coex_notif(struct iwl_mvm *mvm,
 		       le32_to_cpu(notif->secondary_ch_lut));
 	IWL_DEBUG_COEX(mvm, "\tBT activity grading %d\n",
 		       le32_to_cpu(notif->bt_activity_grading));
-	IWL_DEBUG_COEX(mvm, "\tBT agg traffic load %d\n",
-		       notif->bt_agg_traffic_load);
 
 	/* remember this notification for future use: rssi fluctuations */
 	memcpy(&mvm->last_bt_notif, notif, sizeof(mvm->last_bt_notif));
@@ -1181,7 +1102,7 @@ void iwl_mvm_bt_rssi_event(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		return;
 
 	/* No BT - reports should be disabled */
-	if (!mvm->last_bt_notif.bt_status)
+	if (le32_to_cpu(mvm->last_bt_notif.bt_activity_grading) == BT_OFF)
 		return;
 
 	IWL_DEBUG_COEX(mvm, "RSSI for %pM is now %s\n", vif->bss_conf.bssid,
@@ -1234,9 +1155,11 @@ u16 iwl_mvm_coex_agg_time_limit(struct iwl_mvm *mvm,
 	if (le32_to_cpu(mvm->last_bt_notif.bt_activity_grading) <
 	    BT_HIGH_TRAFFIC)
 		return LINK_QUAL_AGG_TIME_LIMIT_DEF;
-
+/*
+	TODO
 	if (mvm->last_bt_notif.ttc_enabled)
 		return LINK_QUAL_AGG_TIME_LIMIT_DEF;
+*/
 
 	lut_type = iwl_get_coex_type(mvm, mvmsta->vif);
 
@@ -1253,8 +1176,11 @@ bool iwl_mvm_bt_coex_is_mimo_allowed(struct iwl_mvm *mvm,
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	enum iwl_bt_coex_lut_type lut_type;
 
+/*
+	TODO
 	if (mvm->last_bt_notif.ttc_enabled)
 		return true;
+*/
 
 	if (le32_to_cpu(mvm->last_bt_notif.bt_activity_grading) <
 	    BT_HIGH_TRAFFIC)
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index b2c751e..e66c659 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -316,7 +316,7 @@ static ssize_t iwl_dbgfs_bt_notif_read(struct file *file, char __user *user_buf,
 				       size_t count, loff_t *ppos)
 {
 	struct iwl_mvm *mvm = file->private_data;
-	struct iwl_bt_coex_profile_notif_old *notif = &mvm->last_bt_notif;
+	struct iwl_bt_coex_profile_notif *notif = &mvm->last_bt_notif;
 	char *buf;
 	int ret, pos = 0, bufsz = sizeof(char) * 1024;
 
@@ -378,14 +378,6 @@ static ssize_t iwl_dbgfs_bt_notif_read(struct file *file, char __user *user_buf,
 	BT_MBOX_PRINT(3, SSN_2, false);
 	BT_MBOX_PRINT(3, UPDATE_REQUEST, true);
 
-	pos += scnprintf(buf+pos, bufsz-pos, "bt_status = %d\n",
-			 notif->bt_status);
-	pos += scnprintf(buf+pos, bufsz-pos, "bt_open_conn = %d\n",
-			 notif->bt_open_conn);
-	pos += scnprintf(buf+pos, bufsz-pos, "bt_traffic_load = %d\n",
-			 notif->bt_traffic_load);
-	pos += scnprintf(buf+pos, bufsz-pos, "bt_agg_traffic_load = %d\n",
-			 notif->bt_agg_traffic_load);
 	pos += scnprintf(buf+pos, bufsz-pos, "bt_ci_compliance = %d\n",
 			 notif->bt_ci_compliance);
 	pos += scnprintf(buf+pos, bufsz-pos, "primary_ch_lut = %d\n",
@@ -411,7 +403,7 @@ static ssize_t iwl_dbgfs_bt_cmd_read(struct file *file, char __user *user_buf,
 				     size_t count, loff_t *ppos)
 {
 	struct iwl_mvm *mvm = file->private_data;
-	struct iwl_bt_coex_ci_cmd_old *cmd = &mvm->last_bt_ci_cmd;
+	struct iwl_bt_coex_ci_cmd *cmd = &mvm->last_bt_ci_cmd;
 	char buf[256];
 	int bufsz = sizeof(buf);
 	int pos = 0;
@@ -420,13 +412,11 @@ static ssize_t iwl_dbgfs_bt_cmd_read(struct file *file, char __user *user_buf,
 
 	pos += scnprintf(buf+pos, bufsz-pos, "Channel inhibition CMD\n");
 	pos += scnprintf(buf+pos, bufsz-pos,
-		       "\tPrimary Channel Bitmap 0x%016llx Fat: %d\n",
-		       le64_to_cpu(cmd->bt_primary_ci),
-		       !!cmd->co_run_bw_primary);
+		       "\tPrimary Channel Bitmap 0x%016llx\n",
+		       le64_to_cpu(cmd->bt_primary_ci));
 	pos += scnprintf(buf+pos, bufsz-pos,
-		       "\tSecondary Channel Bitmap 0x%016llx Fat: %d\n",
-		       le64_to_cpu(cmd->bt_secondary_ci),
-		       !!cmd->co_run_bw_secondary);
+		       "\tSecondary Channel Bitmap 0x%016llx\n",
+		       le64_to_cpu(cmd->bt_secondary_ci));
 
 	pos += scnprintf(buf+pos, bufsz-pos, "BT Configuration CMD\n");
 	pos += scnprintf(buf+pos, bufsz-pos, "\tACK Kill Mask 0x%08x\n",
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h
index b3626cc..98becb9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h
@@ -208,26 +208,116 @@ struct iwl_bt_coex_cmd_old {
 	__le32 valid_bit_msk;
 } __packed; /* BT_COEX_CMD_API_S_VER_5 */
 
+enum iwl_bt_coex_mode {
+	BT_COEX_DISABLE			= 0x0,
+	BT_COEX_NW			= 0x1,
+	BT_COEX_BT			= 0x2,
+	BT_COEX_WIFI			= 0x3,
+}; /* BT_COEX_MODES_E */
+
+enum iwl_bt_coex_enabled_modules {
+	BT_COEX_MPLUT_ENABLED		= BIT(0),
+	BT_COEX_MPLUT_BOOST_ENABLED	= BIT(1),
+	BT_COEX_SYNC2SCO_ENABLED	= BIT(2),
+	BT_COEX_CORUN_ENABLED		= BIT(3),
+}; /* BT_COEX_MODULES_ENABLE_E_VER_1 */
+
+/**
+ * struct iwl_bt_coex_cmd - bt coex configuration command
+ * @mode: enum %iwl_bt_coex_mode
+ * @enabled_modules: enum %iwl_bt_coex_enabled_modules
+ * @max_kill: max count of Tx retries due to kill from PTA
+ * @override_primary_lut: enum %iwl_bt_coex_lut_type: BT_COEX_INVALID_LUT
+ *	should be set by default
+ * @override_secondary_lut: enum %iwl_bt_coex_lut_type: BT_COEX_INVALID_LUT
+ *	should be set by default
+ * @bt4_antenna_isolation_thr: antenna threshold value
+ * @bt4_tx_tx_delta_freq_thr: TxTx delta frequency
+ * @bt4_tx_rx_max_freq0: TxRx max frequency
+ * @multiprio_lut: multi priority LUT configuration
+ * @mplut_prio_boost: BT priority boost registers
+ * @decision_lut: PTA decision LUT, per Prio-Ch
+ *
+ * The structure is used for the BT_COEX command.
+ */
+struct iwl_bt_coex_cmd {
+	__le32 mode;
+	__le32 enabled_modules;
+
+	__le32 max_kill;
+	__le32 override_primary_lut;
+	__le32 override_secondary_lut;
+	__le32 bt4_antenna_isolation_thr;
+
+	__le32 bt4_tx_tx_delta_freq_thr;
+	__le32 bt4_tx_rx_max_freq0;
+
+	__le32 multiprio_lut[BT_COEX_MULTI_PRIO_LUT_SIZE];
+	__le32 mplut_prio_boost[BT_COEX_BOOST_SIZE];
+
+	__le32 decision_lut[BT_COEX_MAX_LUT][BT_COEX_LUT_SIZE];
+} __packed; /* BT_COEX_CMD_API_S_VER_6 */
+
+/**
+ * struct iwl_bt_coex_corun_lut_update - bt coex update the corun lut
+ * @corun_lut20: co-running 20 MHz LUT configuration
+ * @corun_lut40: co-running 40 MHz LUT configuration
+ *
+ * The structure is used for the BT_COEX_UPDATE_CORUN_LUT command.
+ */
+struct iwl_bt_coex_corun_lut_update_cmd {
+	__le32 corun_lut20[BT_COEX_CORUN_LUT_SIZE];
+	__le32 corun_lut40[BT_COEX_CORUN_LUT_SIZE];
+} __packed; /* BT_COEX_UPDATE_CORUN_LUT_API_S_VER_1 */
+
+/**
+ * struct iwl_bt_coex_sw_boost - SW boost values
+ * @wifi_tx_prio_boost: SW boost of wifi tx priority
+ * @wifi_rx_prio_boost: SW boost of wifi rx priority
+ * @kill_ack_msk: kill ACK mask. 1 - Tx ACK, 0 - kill Tx of ACK.
+ * @kill_cts_msk: kill CTS mask. 1 - Tx CTS, 0 - kill Tx of CTS.
+ */
+struct iwl_bt_coex_sw_boost {
+	__le32 wifi_tx_prio_boost;
+	__le32 wifi_rx_prio_boost;
+	__le32 kill_ack_msk;
+	__le32 kill_cts_msk;
+};
+
+/**
+ * struct iwl_bt_coex_sw_boost_update_cmd - command to update the SW boost
+ * @boost_values: check struct  %iwl_bt_coex_sw_boost - one for each channel
+ *	primary / secondary / low priority
+ */
+struct iwl_bt_coex_sw_boost_update_cmd {
+	struct iwl_bt_coex_sw_boost boost_values[3];
+} __packed; /* BT_COEX_UPDATE_SW_BOOST_S_VER_1 */
+
+/**
+ * struct iwl_bt_coex_reduced_txp_update_cmd
+ * @reduced_txp: bit BT_REDUCED_TX_POWER_BIT to enable / disable, rest of the
+ *	bits are the sta_id (value)
+ */
+struct iwl_bt_coex_reduced_txp_update_cmd {
+	__le32 reduced_txp;
+} __packed; /* BT_COEX_UPDATE_REDUCED_TX_POWER_API_S_VER_1 */
+
 /**
  * struct iwl_bt_coex_ci_cmd - bt coex channel inhibition command
  * @bt_primary_ci:
- * @bt_secondary_ci:
- * @co_run_bw_primary:
- * @co_run_bw_secondary:
  * @primary_ch_phy_id:
+ * @bt_secondary_ci:
  * @secondary_ch_phy_id:
  *
  * Used for BT_COEX_CI command
  */
-struct iwl_bt_coex_ci_cmd_old {
+struct iwl_bt_coex_ci_cmd {
 	__le64 bt_primary_ci;
-	__le64 bt_secondary_ci;
+	__le32 primary_ch_phy_id;
 
-	u8 co_run_bw_primary;
-	u8 co_run_bw_secondary;
-	u8 primary_ch_phy_id;
-	u8 secondary_ch_phy_id;
-} __packed; /* BT_CI_MSG_API_S_VER_1 */
+	__le64 bt_secondary_ci;
+	__le32 secondary_ch_phy_id;
+} __packed; /* BT_CI_MSG_API_S_VER_2 */
 
 #define BT_MBOX(n_dw, _msg, _pos, _nbits)	\
 	BT_MBOX##n_dw##_##_msg##_POS = (_pos),	\
@@ -296,35 +386,34 @@ enum iwl_bt_activity_grading {
 	BT_HIGH_TRAFFIC		= 3,
 }; /* BT_COEX_BT_ACTIVITY_GRADING_API_E_VER_1 */
 
+enum iwl_bt_ci_compliance {
+	BT_CI_COMPLIANCE_NONE		= 0,
+	BT_CI_COMPLIANCE_PRIMARY	= 1,
+	BT_CI_COMPLIANCE_SECONDARY	= 2,
+	BT_CI_COMPLIANCE_BOTH		= 3,
+}; /* BT_COEX_CI_COMPLIENCE_E_VER_1 */
+
 /**
  * struct iwl_bt_coex_profile_notif - notification about BT coex
  * @mbox_msg: message from BT to WiFi
  * @msg_idx: the index of the message
- * @bt_status: 0 - off, 1 - on
- * @bt_open_conn: number of BT connections open
- * @bt_traffic_load: load of BT traffic
- * @bt_agg_traffic_load: aggregated load of BT traffic
- * @bt_ci_compliance: 0 - no CI compliance, 1 - CI compliant
- * @ttc_enabled: true if ttc has been enabled by the firmware
- * @primary_ch_lut: LUT used for primary channel
- * @secondary_ch_lut: LUT used for secondary channel
+ * @bt_ci_compliance: enum %iwl_bt_ci_compliance
+ * @primary_ch_lut: LUT used for primary channel enum %iwl_bt_coex_lut_type
+ * @secondary_ch_lut: LUT used for secondary channel enume %iwl_bt_coex_lut_type
  * @bt_activity_grading: the activity of BT enum %iwl_bt_activity_grading
+ * @ttc_rrc_status: is TTC or RRC enabled - one bit per PHY
  */
-struct iwl_bt_coex_profile_notif_old {
+struct iwl_bt_coex_profile_notif {
 	__le32 mbox_msg[4];
 	__le32 msg_idx;
-	u8 bt_status;
-	u8 bt_open_conn;
-	u8 bt_traffic_load;
-	u8 bt_agg_traffic_load;
-	u8 bt_ci_compliance;
-	u8 ttc_enabled;
-	__le16 reserved;
+	__le32 bt_ci_compliance;
 
 	__le32 primary_ch_lut;
 	__le32 secondary_ch_lut;
 	__le32 bt_activity_grading;
-} __packed; /* BT_COEX_PROFILE_NTFY_API_S_VER_3 */
+	u8 ttc_rrc_status;
+	u8 reserved[3];
+} __packed; /* BT_COEX_PROFILE_NTFY_API_S_VER_4 */
 
 enum iwl_bt_coex_prio_table_event {
 	BT_COEX_PRIO_TBL_EVT_INIT_CALIB1		= 0,
@@ -363,4 +452,54 @@ struct iwl_bt_coex_prio_tbl_cmd {
 	u8 prio_tbl[BT_COEX_PRIO_TBL_EVT_MAX];
 } __packed;
 
+/**
+ * struct iwl_bt_coex_ci_cmd_old - bt coex channel inhibition command
+ * @bt_primary_ci:
+ * @bt_secondary_ci:
+ * @co_run_bw_primary:
+ * @co_run_bw_secondary:
+ * @primary_ch_phy_id:
+ * @secondary_ch_phy_id:
+ *
+ * Used for BT_COEX_CI command
+ */
+struct iwl_bt_coex_ci_cmd_old {
+	__le64 bt_primary_ci;
+	__le64 bt_secondary_ci;
+
+	u8 co_run_bw_primary;
+	u8 co_run_bw_secondary;
+	u8 primary_ch_phy_id;
+	u8 secondary_ch_phy_id;
+} __packed; /* BT_CI_MSG_API_S_VER_1 */
+
+/**
+ * struct iwl_bt_coex_profile_notif_old - notification about BT coex
+ * @mbox_msg: message from BT to WiFi
+ * @msg_idx: the index of the message
+ * @bt_status: 0 - off, 1 - on
+ * @bt_open_conn: number of BT connections open
+ * @bt_traffic_load: load of BT traffic
+ * @bt_agg_traffic_load: aggregated load of BT traffic
+ * @bt_ci_compliance: 0 - no CI compliance, 1 - CI compliant
+ * @primary_ch_lut: LUT used for primary channel
+ * @secondary_ch_lut: LUT used for secondary channel
+ * @bt_activity_grading: the activity of BT enum %iwl_bt_activity_grading
+ */
+struct iwl_bt_coex_profile_notif_old {
+	__le32 mbox_msg[4];
+	__le32 msg_idx;
+	u8 bt_status;
+	u8 bt_open_conn;
+	u8 bt_traffic_load;
+	u8 bt_agg_traffic_load;
+	u8 bt_ci_compliance;
+	u8 ttc_enabled;
+	__le16 reserved;
+
+	__le32 primary_ch_lut;
+	__le32 secondary_ch_lut;
+	__le32 bt_activity_grading;
+} __packed; /* BT_COEX_PROFILE_NTFY_API_S_VER_3 */
+
 #endif /* __fw_api_bt_coex_h__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 309a9b9..3983a2b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -163,7 +163,6 @@ enum {
 	BEACON_NOTIFICATION = 0x90,
 	BEACON_TEMPLATE_CMD = 0x91,
 	TX_ANT_CONFIGURATION_CMD = 0x98,
-	BT_CONFIG = 0x9b,
 	STATISTICS_NOTIFICATION = 0x9d,
 	EOSP_NOTIFICATION = 0x9e,
 	REDUCE_TX_POWER_CMD = 0x9f,
@@ -185,6 +184,10 @@ enum {
 	BT_COEX_PRIO_TABLE = 0xcc,
 	BT_COEX_PROT_ENV = 0xcd,
 	BT_PROFILE_NOTIFICATION = 0xce,
+	BT_CONFIG = 0x9b,
+	BT_COEX_UPDATE_SW_BOOST = 0x5a,
+	BT_COEX_UPDATE_CORUN_LUT = 0x5b,
+	BT_COEX_UPDATE_REDUCED_TXP = 0x5c,
 	BT_COEX_CI = 0x5d,
 
 	REPLY_SF_CFG_CMD = 0xd1,
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 0b52d0a..fbe93a1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -633,8 +633,8 @@ struct iwl_mvm {
 
 	struct iwl_bt_coex_profile_notif_old last_bt_notif_old;
 	struct iwl_bt_coex_ci_cmd_old last_bt_ci_cmd_old;
-	struct iwl_bt_coex_profile_notif_old last_bt_notif;
-	struct iwl_bt_coex_ci_cmd_old last_bt_ci_cmd;
+	struct iwl_bt_coex_profile_notif last_bt_notif;
+	struct iwl_bt_coex_ci_cmd last_bt_ci_cmd;
 
 	u32 last_ant_isol;
 	u8 last_corun_lut;
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 15c13a7..b843870 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -324,6 +324,9 @@ static const char *const iwl_mvm_cmd_strings[REPLY_MAX] = {
 	CMD(REPLY_THERMAL_MNG_BACKOFF),
 	CMD(MAC_PM_POWER_TABLE),
 	CMD(BT_COEX_CI),
+	CMD(BT_COEX_UPDATE_SW_BOOST),
+	CMD(BT_COEX_UPDATE_CORUN_LUT),
+	CMD(BT_COEX_UPDATE_REDUCED_TXP),
 	CMD(PSM_UAPSD_AP_MISBEHAVING_NOTIFICATION),
 	CMD(ANTENNA_COUPLING_NOTIFICATION),
 };
-- 
1.8.3.2

