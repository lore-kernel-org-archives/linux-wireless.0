Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48588 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752365AbdLBQ3L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Dec 2017 11:29:11 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Gregory Greenman <gregory.greenman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  2 Dec 2017 18:28:51 +0200
Message-Id: <20171202162858.4167-9-luca@coelho.fi> (sfid-20171202_172918_941070_5D9254C4)
In-Reply-To: <20171202162858.4167-1-luca@coelho.fi>
References: <20171202162858.4167-1-luca@coelho.fi>
Subject: [PATCH 08/15] iwlwifi: mvm: rs: new rate scale API - add FW notifications
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gregory Greenman <gregory.greenman@intel.com>

This patch sends to the FW notification configuration command and
handles the update responses.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/fw/api/datapath.h   | 10 ++++++
 drivers/net/wireless/intel/iwlwifi/fw/api/rs.h     | 34 ++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     | 42 ++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h        |  1 +
 5 files changed, 89 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h b/drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h
index 8ec1a7fe62ea..a57c7223df0f 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h
@@ -87,6 +87,16 @@ enum iwl_data_path_subcmd_ids {
 	 */
 	TLC_MNG_CONFIG_CMD = 0xF,
 
+	/**
+	 * @TLC_MNG_NOTIF_REQ_CMD: &struct iwl_tlc_notif_req_config_cmd
+	 */
+	TLC_MNG_NOTIF_REQ_CMD = 0x10,
+
+	/**
+	 * @TLC_MNG_UPDATE_NOTIF: &struct iwl_tlc_update_notif
+	 */
+	TLC_MNG_UPDATE_NOTIF = 0xF7,
+
 	/**
 	 * @STA_PM_NOTIF: &struct iwl_mvm_pm_state_notification
 	 */
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/rs.h b/drivers/net/wireless/intel/iwlwifi/fw/api/rs.h
index ba88b0ea9a60..71707e1c78a1 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/rs.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/rs.h
@@ -229,6 +229,40 @@ struct iwl_tlc_config_cmd {
 	__le32 max_ampdu_cnt;
 } __packed; /* TLC_MNG_CONFIG_CMD_API_S_VER_1 */
 
+#define IWL_TLC_NOTIF_INIT_RATE_POS 0
+#define IWL_TLC_NOTIF_INIT_RATE_MSK BIT(IWL_TLC_NOTIF_INIT_RATE_POS)
+#define IWL_TLC_NOTIF_REQ_INTERVAL (500)
+
+/**
+ * struct iwl_tlc_notif_req_config_cmd - request notif on specific changes
+ * @sta_id: relevant station
+ * @reserved1: reserved
+ * @flags: bitmap of requested notifications %IWL_TLC_NOTIF_INIT_\*
+ * @interval: minimum time between notifications from TLC to the driver (msec)
+ * @reserved2: reserved
+ */
+struct iwl_tlc_notif_req_config_cmd {
+	u8 sta_id;
+	u8 reserved1;
+	__le16 flags;
+	__le16 interval;
+	__le16 reserved2;
+} __packed; /* TLC_MNG_NOTIF_REQ_CMD_API_S_VER_1 */
+
+/**
+ * struct iwl_tlc_update_notif - TLC notification from FW
+ * @sta_id: station id
+ * @reserved: reserved
+ * @flags: bitmap of notifications reported
+ * @values: field per flag in struct iwl_tlc_notif_req_config_cmd
+ */
+struct iwl_tlc_update_notif {
+	u8 sta_id;
+	u8 reserved;
+	__le16 flags;
+	__le32 values[16];
+} __packed; /* TLC_MNG_UPDATE_NTFY_API_S_VER_1 */
+
 /*
  * These serve as indexes into
  * struct iwl_rate_info fw_rate_idx_to_plcp[IWL_RATE_COUNT];
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index a38a55327bcb..477395059877 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1017,6 +1017,8 @@ static void iwl_mvm_rx_mq(struct iwl_op_mode *op_mode,
 		iwl_mvm_rx_queue_notif(mvm, rxb, 0);
 	else if (cmd == WIDE_ID(LEGACY_GROUP, FRAME_RELEASE))
 		iwl_mvm_rx_frame_release(mvm, napi, rxb, 0);
+	else if (cmd == WIDE_ID(DATA_PATH_GROUP, TLC_MNG_UPDATE_NOTIF))
+		iwl_mvm_tlc_update_notif(mvm, pkt);
 	else
 		iwl_mvm_rx_common(mvm, rxb, pkt);
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
index e11788253803..0d879003d322 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
@@ -213,6 +213,46 @@ static void rs_fw_set_supp_rates(struct ieee80211_sta *sta,
 	}
 }
 
+static void rs_fw_tlc_mng_notif_req_config(struct iwl_mvm *mvm, u8 sta_id)
+{
+	u32 cmd_id = iwl_cmd_id(TLC_MNG_NOTIF_REQ_CMD, DATA_PATH_GROUP, 0);
+	struct iwl_tlc_notif_req_config_cmd cfg_cmd = {
+		.sta_id = sta_id,
+		.flags = cpu_to_le16(IWL_TLC_NOTIF_INIT_RATE_MSK),
+		.interval = cpu_to_le16(IWL_TLC_NOTIF_REQ_INTERVAL),
+	};
+	int ret;
+
+	ret = iwl_mvm_send_cmd_pdu(mvm, cmd_id, 0, sizeof(cfg_cmd), &cfg_cmd);
+	if (ret)
+		IWL_ERR(mvm, "Failed to send TLC notif request (%d)\n", ret);
+}
+
+void iwl_mvm_tlc_update_notif(struct iwl_mvm *mvm, struct iwl_rx_packet *pkt)
+{
+	struct iwl_tlc_update_notif *notif;
+	struct iwl_mvm_sta *mvmsta;
+	struct iwl_lq_sta_rs_fw *lq_sta;
+
+	notif = (void *)pkt->data;
+	mvmsta = iwl_mvm_sta_from_staid_rcu(mvm, notif->sta_id);
+
+	if (!mvmsta) {
+		IWL_ERR(mvm, "Invalid sta id (%d) in FW TLC notification\n",
+			notif->sta_id);
+		return;
+	}
+
+	lq_sta = &mvmsta->lq_sta.rs_fw;
+
+	if (le16_to_cpu(notif->flags) & IWL_TLC_NOTIF_INIT_RATE_MSK) {
+		lq_sta->last_rate_n_flags =
+			le32_to_cpu(notif->values[IWL_TLC_NOTIF_INIT_RATE_POS]);
+		IWL_DEBUG_RATE(mvm, "new rate_n_flags: 0x%X\n",
+			       lq_sta->last_rate_n_flags);
+	}
+}
+
 void rs_fw_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		     enum nl80211_band band)
 {
@@ -243,6 +283,8 @@ void rs_fw_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	ret = iwl_mvm_send_cmd_pdu(mvm, cmd_id, 0, sizeof(cfg_cmd), &cfg_cmd);
 	if (ret)
 		IWL_ERR(mvm, "Failed to send rate scale config (%d)\n", ret);
+
+	rs_fw_tlc_mng_notif_req_config(mvm, cfg_cmd.sta_id);
 }
 
 int rs_fw_tx_protection(struct iwl_mvm *mvm, struct iwl_mvm_sta *mvmsta,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.h b/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
index 5b58e2d9bfbc..fb18cb8c233d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
@@ -454,4 +454,5 @@ void rs_fw_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		     enum nl80211_band band);
 int rs_fw_tx_protection(struct iwl_mvm *mvm, struct iwl_mvm_sta *mvmsta,
 			bool enable);
+void iwl_mvm_tlc_update_notif(struct iwl_mvm *mvm, struct iwl_rx_packet *pkt);
 #endif /* __rs__ */
-- 
2.15.0
