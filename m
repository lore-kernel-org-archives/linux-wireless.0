Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:48275 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560AbaBCU7r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:59:47 -0500
Received: by mail-ea0-f182.google.com with SMTP id r15so3966038ead.41
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:59:46 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 56/62] iwlwifi: mvm: clean up in power code
Date: Mon,  3 Feb 2014 22:58:02 +0200
Message-Id: <1391461088-8082-56-git-send-email-egrumbach@gmail.com> (sfid-20140203_220010_961991_59E47A83)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Reduce indentation where it is possible.
Make a function static - it wasn't used outside its file
anyway.
Remove the unneeded pm_prevent state.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mvm.h   |    5 ---
 drivers/net/wireless/iwlwifi/mvm/power.c |   61 +++++++++++++-----------------
 2 files changed, 27 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 1f53ade..93e6c18 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -353,8 +353,6 @@ struct iwl_mvm_vif {
 
 	/* FW identified misbehaving AP */
 	u8 uapsd_misbehaving_bssid[ETH_ALEN];
-
-	bool pm_prevented;
 };
 
 static inline struct iwl_mvm_vif *
@@ -943,9 +941,6 @@ int iwl_mvm_enable_beacon_filter(struct iwl_mvm *mvm,
 int iwl_mvm_disable_beacon_filter(struct iwl_mvm *mvm,
 				  struct ieee80211_vif *vif,
 				  u32 flags);
-int iwl_mvm_beacon_filter_send_cmd(struct iwl_mvm *mvm,
-				   struct iwl_beacon_filter_cmd *cmd,
-				   u32 flags);
 int iwl_mvm_update_beacon_abort(struct iwl_mvm *mvm,
 				struct ieee80211_vif *vif, bool enable);
 int iwl_mvm_update_beacon_filter(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index b20771c..f9ddd79 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -74,40 +74,36 @@
 
 #define POWER_KEEP_ALIVE_PERIOD_SEC    25
 
+static
 int iwl_mvm_beacon_filter_send_cmd(struct iwl_mvm *mvm,
 				   struct iwl_beacon_filter_cmd *cmd,
 				   u32 flags)
 {
-	int ret;
-
-	ret = iwl_mvm_send_cmd_pdu(mvm, REPLY_BEACON_FILTERING_CMD, flags,
-				   sizeof(struct iwl_beacon_filter_cmd), cmd);
-
-	if (!ret) {
-		IWL_DEBUG_POWER(mvm, "ba_enable_beacon_abort is: %d\n",
-				le32_to_cpu(cmd->ba_enable_beacon_abort));
-		IWL_DEBUG_POWER(mvm, "ba_escape_timer is: %d\n",
-				le32_to_cpu(cmd->ba_escape_timer));
-		IWL_DEBUG_POWER(mvm, "bf_debug_flag is: %d\n",
-				le32_to_cpu(cmd->bf_debug_flag));
-		IWL_DEBUG_POWER(mvm, "bf_enable_beacon_filter is: %d\n",
-				le32_to_cpu(cmd->bf_enable_beacon_filter));
-		IWL_DEBUG_POWER(mvm, "bf_energy_delta is: %d\n",
-				le32_to_cpu(cmd->bf_energy_delta));
-		IWL_DEBUG_POWER(mvm, "bf_escape_timer is: %d\n",
-				le32_to_cpu(cmd->bf_escape_timer));
-		IWL_DEBUG_POWER(mvm, "bf_roaming_energy_delta is: %d\n",
-				le32_to_cpu(cmd->bf_roaming_energy_delta));
-		IWL_DEBUG_POWER(mvm, "bf_roaming_state is: %d\n",
-				le32_to_cpu(cmd->bf_roaming_state));
-		IWL_DEBUG_POWER(mvm, "bf_temp_threshold is: %d\n",
-				le32_to_cpu(cmd->bf_temp_threshold));
-		IWL_DEBUG_POWER(mvm, "bf_temp_fast_filter is: %d\n",
-				le32_to_cpu(cmd->bf_temp_fast_filter));
-		IWL_DEBUG_POWER(mvm, "bf_temp_slow_filter is: %d\n",
-				le32_to_cpu(cmd->bf_temp_slow_filter));
-	}
-	return ret;
+	IWL_DEBUG_POWER(mvm, "ba_enable_beacon_abort is: %d\n",
+			le32_to_cpu(cmd->ba_enable_beacon_abort));
+	IWL_DEBUG_POWER(mvm, "ba_escape_timer is: %d\n",
+			le32_to_cpu(cmd->ba_escape_timer));
+	IWL_DEBUG_POWER(mvm, "bf_debug_flag is: %d\n",
+			le32_to_cpu(cmd->bf_debug_flag));
+	IWL_DEBUG_POWER(mvm, "bf_enable_beacon_filter is: %d\n",
+			le32_to_cpu(cmd->bf_enable_beacon_filter));
+	IWL_DEBUG_POWER(mvm, "bf_energy_delta is: %d\n",
+			le32_to_cpu(cmd->bf_energy_delta));
+	IWL_DEBUG_POWER(mvm, "bf_escape_timer is: %d\n",
+			le32_to_cpu(cmd->bf_escape_timer));
+	IWL_DEBUG_POWER(mvm, "bf_roaming_energy_delta is: %d\n",
+			le32_to_cpu(cmd->bf_roaming_energy_delta));
+	IWL_DEBUG_POWER(mvm, "bf_roaming_state is: %d\n",
+			le32_to_cpu(cmd->bf_roaming_state));
+	IWL_DEBUG_POWER(mvm, "bf_temp_threshold is: %d\n",
+			le32_to_cpu(cmd->bf_temp_threshold));
+	IWL_DEBUG_POWER(mvm, "bf_temp_fast_filter is: %d\n",
+			le32_to_cpu(cmd->bf_temp_fast_filter));
+	IWL_DEBUG_POWER(mvm, "bf_temp_slow_filter is: %d\n",
+			le32_to_cpu(cmd->bf_temp_slow_filter));
+
+	return iwl_mvm_send_cmd_pdu(mvm, REPLY_BEACON_FILTERING_CMD, flags,
+				    sizeof(struct iwl_beacon_filter_cmd), cmd);
 }
 
 static
@@ -313,7 +309,7 @@ static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 	    mvmvif->dbgfs_pm.disable_power_off)
 		cmd->flags &= cpu_to_le16(~POWER_FLAGS_POWER_SAVE_ENA_MSK);
 #endif
-	if (!vif->bss_conf.ps || mvmvif->pm_prevented ||
+	if (!vif->bss_conf.ps || mvm->bound_vif_cnt > 1 ||
 	    iwl_mvm_vif_low_latency(mvmvif))
 		return;
 
@@ -549,12 +545,9 @@ int iwl_mvm_power_uapsd_misbehaving_ap_notif(struct iwl_mvm *mvm,
 static void iwl_mvm_power_binding_iterator(void *_data, u8 *mac,
 					   struct ieee80211_vif *vif)
 {
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mvm *mvm = _data;
 	int ret;
 
-	mvmvif->pm_prevented = (mvm->bound_vif_cnt <= 1) ? false : true;
-
 	ret = iwl_mvm_power_mac_update_mode(mvm, vif);
 	WARN_ONCE(ret, "Failed to update power parameters on a specific vif\n");
 }
-- 
1.7.9.5

