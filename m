Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24060 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123AbbCATcR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 14:32:17 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 13/31] iwlwifi: mvm: support radio statistics as global survey
Date: Sun,  1 Mar 2015 21:31:26 +0200
Message-Id: <1425238304-498-13-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_203417_148633_738F192A)
In-Reply-To: <1425238186.30202.5.camel@egrumbacBox>
References: <1425238186.30202.5.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Export the radio statistics from the statistics v10 API (if the
firmware also has the capability to fill these statistics) using
the global survey data facility.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-file.h      |  2 +
 drivers/net/wireless/iwlwifi/mvm/fw-api-stats.h | 17 ++++----
 drivers/net/wireless/iwlwifi/mvm/fw-api.h       |  1 +
 drivers/net/wireless/iwlwifi/mvm/mac80211.c     | 58 +++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h          | 14 ++++--
 drivers/net/wireless/iwlwifi/mvm/ops.c          |  1 +
 drivers/net/wireless/iwlwifi/mvm/rx.c           | 27 +++++++-----
 drivers/net/wireless/iwlwifi/mvm/utils.c        | 29 +++++++++++++
 8 files changed, 127 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 4602e3c..8b9040ef 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -286,6 +286,7 @@ enum iwl_ucode_tlv_api {
  *	which also implies support for the scheduler configuration command
  * @IWL_UCODE_TLV_CAPA_TDLS_CHANNEL_SWITCH: supports TDLS channel switching
  * @IWL_UCODE_TLV_CAPA_HOTSPOT_SUPPORT: supports Hot Spot Command
+ * @IWL_UCODE_TLV_CAPA_RADIO_BEACON_STATS: support radio and beacon statistics
  */
 enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_D0I3_SUPPORT			= BIT(0),
@@ -300,6 +301,7 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_DQA_SUPPORT			= BIT(12),
 	IWL_UCODE_TLV_CAPA_TDLS_CHANNEL_SWITCH		= BIT(13),
 	IWL_UCODE_TLV_CAPA_HOTSPOT_SUPPORT		= BIT(18),
+	IWL_UCODE_TLV_CAPA_RADIO_BEACON_STATS		= BIT(22),
 };
 
 /* The default calibrate table size if not specified by firmware file */
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-stats.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-stats.h
index 5a9dfe0..709e28d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-stats.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-stats.h
@@ -290,15 +290,7 @@ struct mvm_statistics_rx {
  *
  * By default, uCode issues this notification after receiving a beacon
  * while associated.  To disable this behavior, set DISABLE_NOTIF flag in the
- * REPLY_STATISTICS_CMD 0x9c, above.
- *
- * Statistics counters continue to increment beacon after beacon, but are
- * cleared when changing channels or when driver issues REPLY_STATISTICS_CMD
- * 0x9c with CLEAR_STATS bit set (see above).
- *
- * uCode also issues this notification during scans.  uCode clears statistics
- * appropriately so that each notification contains statistics for only the
- * one channel that has just been scanned.
+ * STATISTICS_CMD (0x9c), below.
  */
 
 struct iwl_notif_statistics_v8 {
@@ -315,4 +307,11 @@ struct iwl_notif_statistics_v10 {
 	struct mvm_statistics_general_v8 general;
 } __packed; /* STATISTICS_NTFY_API_S_VER_10 */
 
+#define IWL_STATISTICS_FLG_CLEAR		0x1
+#define IWL_STATISTICS_FLG_DISABLE_NOTIF	0x2
+
+struct iwl_statistics_cmd {
+	__le32 flags;
+} __packed; /* STATISTICS_CMD_API_S_VER_1 */
+
 #endif /* __fw_api_stats_h__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index b56154f..c43e5c2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -192,6 +192,7 @@ enum {
 	BEACON_NOTIFICATION = 0x90,
 	BEACON_TEMPLATE_CMD = 0x91,
 	TX_ANT_CONFIGURATION_CMD = 0x98,
+	STATISTICS_CMD = 0x9c,
 	STATISTICS_NOTIFICATION = 0x9d,
 	EOSP_NOTIFICATION = 0x9e,
 	REDUCE_TX_POWER_CMD = 0x9f,
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 1ff7ec0..20e1e89 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1091,6 +1091,9 @@ static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 
 	mvm->vif_count = 0;
 	mvm->rx_ba_sessions = 0;
+
+	/* keep statistics ticking */
+	iwl_mvm_accu_radio_stats(mvm);
 }
 
 int __iwl_mvm_mac_start(struct iwl_mvm *mvm)
@@ -1213,6 +1216,11 @@ void __iwl_mvm_mac_stop(struct iwl_mvm *mvm)
 {
 	lockdep_assert_held(&mvm->mutex);
 
+	/* firmware counters are obviously reset now, but we shouldn't
+	 * partially track so also clear the fw_reset_accu counters.
+	 */
+	memset(&mvm->accu_radio_stats, 0, sizeof(mvm->accu_radio_stats));
+
 	/*
 	 * Disallow low power states when the FW is down by taking
 	 * the UCODE_DOWN ref. in case of ongoing hw restart the
@@ -3581,6 +3589,55 @@ static void iwl_mvm_mac_flush(struct ieee80211_hw *hw,
 	}
 }
 
+static int iwl_mvm_mac_get_survey(struct ieee80211_hw *hw, int idx,
+				  struct survey_info *survey)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	int ret;
+
+	memset(survey, 0, sizeof(*survey));
+
+	/* only support global statistics right now */
+	if (idx != 0)
+		return -ENOENT;
+
+	if (!(mvm->fw->ucode_capa.capa[0] &
+			IWL_UCODE_TLV_CAPA_RADIO_BEACON_STATS))
+		return -ENOENT;
+
+	mutex_lock(&mvm->mutex);
+
+	if (mvm->ucode_loaded) {
+		ret = iwl_mvm_request_statistics(mvm);
+		if (ret)
+			goto out;
+	}
+
+	survey->filled = SURVEY_INFO_TIME |
+			 SURVEY_INFO_TIME_RX |
+			 SURVEY_INFO_TIME_TX |
+			 SURVEY_INFO_TIME_SCAN;
+	survey->time = mvm->accu_radio_stats.on_time_rf +
+		       mvm->radio_stats.on_time_rf;
+	do_div(survey->time, USEC_PER_MSEC);
+
+	survey->time_rx = mvm->accu_radio_stats.rx_time +
+			  mvm->radio_stats.rx_time;
+	do_div(survey->time_rx, USEC_PER_MSEC);
+
+	survey->time_tx = mvm->accu_radio_stats.tx_time +
+			  mvm->radio_stats.tx_time;
+	do_div(survey->time_tx, USEC_PER_MSEC);
+
+	survey->time_scan = mvm->accu_radio_stats.on_time_scan +
+			    mvm->radio_stats.on_time_scan;
+	do_div(survey->time_scan, USEC_PER_MSEC);
+
+ out:
+	mutex_unlock(&mvm->mutex);
+	return ret;
+}
+
 const struct ieee80211_ops iwl_mvm_hw_ops = {
 	.tx = iwl_mvm_mac_tx,
 	.ampdu_action = iwl_mvm_mac_ampdu_action,
@@ -3647,4 +3704,5 @@ const struct ieee80211_ops iwl_mvm_hw_ops = {
 #endif
 	.set_default_unicast_key = iwl_mvm_set_default_unicast_key,
 #endif
+	.get_survey = iwl_mvm_mac_get_survey,
 };
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 07b91d6..d4f3b84 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -593,6 +593,13 @@ struct iwl_mvm {
 
 	struct mvm_statistics_rx rx_stats;
 
+	struct {
+		u64 rx_time;
+		u64 tx_time;
+		u64 on_time_rf;
+		u64 on_time_scan;
+	} radio_stats, accu_radio_stats;
+
 	u8 queue_to_mac80211[IWL_MAX_HW_QUEUES];
 	atomic_t mac80211_queue_stop_count[IEEE80211_MAX_QUEUES];
 
@@ -951,12 +958,13 @@ static inline void iwl_mvm_wait_for_async_handlers(struct iwl_mvm *mvm)
 }
 
 /* Statistics */
-int iwl_mvm_rx_reply_statistics(struct iwl_mvm *mvm,
-				struct iwl_rx_cmd_buffer *rxb,
-				struct iwl_device_cmd *cmd);
+void iwl_mvm_handle_rx_statistics(struct iwl_mvm *mvm,
+				  struct iwl_rx_packet *pkt);
 int iwl_mvm_rx_statistics(struct iwl_mvm *mvm,
 			  struct iwl_rx_cmd_buffer *rxb,
 			  struct iwl_device_cmd *cmd);
+int iwl_mvm_request_statistics(struct iwl_mvm *mvm);
+void iwl_mvm_accu_radio_stats(struct iwl_mvm *mvm);
 
 /* NVM */
 int iwl_nvm_init(struct iwl_mvm *mvm, bool read_nvm_from_nic);
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 2dffc36..7a04533 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -311,6 +311,7 @@ static const char *const iwl_mvm_cmd_strings[REPLY_MAX] = {
 	CMD(REPLY_RX_MPDU_CMD),
 	CMD(BEACON_NOTIFICATION),
 	CMD(BEACON_TEMPLATE_CMD),
+	CMD(STATISTICS_CMD),
 	CMD(STATISTICS_NOTIFICATION),
 	CMD(EOSP_NOTIFICATION),
 	CMD(REDUCE_TX_POWER_CMD),
diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index fffd89d..2486931 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -496,16 +496,9 @@ static void iwl_mvm_stat_iterator(void *_data, u8 *mac,
 	}
 }
 
-/*
- * iwl_mvm_rx_statistics - STATISTICS_NOTIFICATION handler
- *
- * TODO: This handler is implemented partially.
- */
-int iwl_mvm_rx_statistics(struct iwl_mvm *mvm,
-			  struct iwl_rx_cmd_buffer *rxb,
-			  struct iwl_device_cmd *cmd)
+void iwl_mvm_handle_rx_statistics(struct iwl_mvm *mvm,
+				  struct iwl_rx_packet *pkt)
 {
-	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	size_t v8_len = sizeof(struct iwl_notif_statistics_v8);
 	size_t v10_len = sizeof(struct iwl_notif_statistics_v10);
 	struct iwl_mvm_stat_data data = {
@@ -525,6 +518,13 @@ int iwl_mvm_rx_statistics(struct iwl_mvm *mvm,
 			stats->general.beacon_filter_average_energy;
 
 		iwl_mvm_update_rx_statistics(mvm, &stats->rx);
+
+		mvm->radio_stats.rx_time = le64_to_cpu(stats->general.rx_time);
+		mvm->radio_stats.tx_time = le64_to_cpu(stats->general.tx_time);
+		mvm->radio_stats.on_time_rf =
+			le64_to_cpu(stats->general.on_time_rf);
+		mvm->radio_stats.on_time_scan =
+			le64_to_cpu(stats->general.on_time_scan);
 	} else {
 		struct iwl_notif_statistics_v8 *stats = (void *)&pkt->data;
 
@@ -549,9 +549,16 @@ int iwl_mvm_rx_statistics(struct iwl_mvm *mvm,
 					    IEEE80211_IFACE_ITER_NORMAL,
 					    iwl_mvm_stat_iterator,
 					    &data);
-	return 0;
+	return;
  invalid:
 	IWL_ERR(mvm, "received invalid statistics size (%d)!\n",
 		iwl_rx_packet_payload_len(pkt));
+}
+
+int iwl_mvm_rx_statistics(struct iwl_mvm *mvm,
+			  struct iwl_rx_cmd_buffer *rxb,
+			  struct iwl_device_cmd *cmd)
+{
+	iwl_mvm_handle_rx_statistics(mvm, rxb_addr(rxb));
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index 8decf99..2b75a0d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -643,6 +643,35 @@ void iwl_mvm_update_smps(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	ieee80211_request_smps(vif, smps_mode);
 }
 
+int iwl_mvm_request_statistics(struct iwl_mvm *mvm)
+{
+	struct iwl_statistics_cmd scmd = {};
+	struct iwl_host_cmd cmd = {
+		.id = STATISTICS_CMD,
+		.len[0] = sizeof(scmd),
+		.data[0] = &scmd,
+		.flags = CMD_WANT_SKB,
+	};
+	int ret;
+
+	ret = iwl_mvm_send_cmd(mvm, &cmd);
+	if (ret)
+		return ret;
+
+	iwl_mvm_handle_rx_statistics(mvm, cmd.resp_pkt);
+	iwl_free_resp(&cmd);
+
+	return 0;
+}
+
+void iwl_mvm_accu_radio_stats(struct iwl_mvm *mvm)
+{
+	mvm->accu_radio_stats.rx_time += mvm->radio_stats.rx_time;
+	mvm->accu_radio_stats.tx_time += mvm->radio_stats.tx_time;
+	mvm->accu_radio_stats.on_time_rf += mvm->radio_stats.on_time_rf;
+	mvm->accu_radio_stats.on_time_scan += mvm->radio_stats.on_time_scan;
+}
+
 static void iwl_mvm_diversity_iter(void *_data, u8 *mac,
 				   struct ieee80211_vif *vif)
 {
-- 
1.9.1

