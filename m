Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51042 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933751AbdLRMij (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Dec 2017 07:38:39 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 18 Dec 2017 14:38:14 +0200
Message-Id: <20171218123815.3968-11-luca@coelho.fi> (sfid-20171218_133845_243820_CEA0D420)
In-Reply-To: <20171218123815.3968-1-luca@coelho.fi>
References: <20171218123815.3968-1-luca@coelho.fi>
Subject: [PATCH 10/11] iwlwifi: mvm: send the low latency command
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shaul Triebitz <shaul.triebitz@intel.com>

Recently a new command was added to the firmware
for setting a MAC's low-latency mode.  Use it.

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/fw/api/mac-cfg.h    | 19 +++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     | 24 +++++++++++++++++++++-
 2 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h b/drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h
index ec42c84e5df2..17c7ef1662a9 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h
@@ -67,6 +67,10 @@
  * enum iwl_mac_conf_subcmd_ids - mac configuration command IDs
  */
 enum iwl_mac_conf_subcmd_ids {
+	/**
+	 * @LOW_LATENCY_CMD: &struct iwl_mac_low_latency_cmd
+	 */
+	LOW_LATENCY_CMD = 0x3,
 	/**
 	 * @CHANNEL_SWITCH_NOA_NOTIF: &struct iwl_channel_switch_noa_notif
 	 */
@@ -82,4 +86,19 @@ struct iwl_channel_switch_noa_notif {
 	__le32 id_and_color;
 } __packed; /* CHANNEL_SWITCH_START_NTFY_API_S_VER_1 */
 
+/**
+ * struct iwl_mac_low_latency_cmd - set/clear mac to 'low-latency mode'
+ *
+ * @mac_id: MAC ID to whom to apply the low-latency configurations
+ * @low_latency_rx: 1/0 to set/clear Rx low latency direction
+ * @low_latency_tx: 1/0 to set/clear Tx low latency direction
+ * @reserved: reserved for alignment purposes
+ */
+struct iwl_mac_low_latency_cmd {
+	__le32 mac_id;
+	u8 low_latency_rx;
+	u8 low_latency_tx;
+	__le16 reserved;
+} __packed; /* MAC_LOW_LATENCY_API_S_VER_1 */
+
 #endif /* __iwl_fw_api_mac_cfg_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index b2410eb68123..e94fcf16c513 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -1032,12 +1032,34 @@ int iwl_mvm_update_low_latency(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	int res;
+	bool low_latency;
 
 	lockdep_assert_held(&mvm->mutex);
 
-	if (iwl_mvm_vif_low_latency(mvmvif) == prev)
+	low_latency = iwl_mvm_vif_low_latency(mvmvif);
+
+	if (low_latency == prev)
 		return 0;
 
+	if (fw_has_capa(&mvm->fw->ucode_capa,
+			IWL_UCODE_TLV_CAPA_DYNAMIC_QUOTA)) {
+		struct iwl_mac_low_latency_cmd cmd = {
+			.mac_id = cpu_to_le32(mvmvif->id)
+		};
+
+		if (low_latency) {
+			/* currently we don't care about the direction */
+			cmd.low_latency_rx = 1;
+			cmd.low_latency_tx = 1;
+		}
+		res = iwl_mvm_send_cmd_pdu(mvm,
+					   iwl_cmd_id(LOW_LATENCY_CMD,
+						      MAC_CONF_GROUP, 0),
+					   0, sizeof(cmd), &cmd);
+		if (res)
+			IWL_ERR(mvm, "Failed to send low latency command\n");
+	}
+
 	res = iwl_mvm_update_quotas(mvm, false, NULL);
 	if (res)
 		return res;
-- 
2.15.1
