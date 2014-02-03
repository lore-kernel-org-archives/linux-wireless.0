Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:43471 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467AbaBCU7R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:59:17 -0500
Received: by mail-ee0-f45.google.com with SMTP id b15so3813467eek.18
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:59:16 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 38/62] iwlwifi: mvm: add D0i3 power configurations
Date: Mon,  3 Feb 2014 22:57:44 +0200
Message-Id: <1391461088-8082-38-git-send-email-egrumbach@gmail.com> (sfid-20140203_220007_884869_9C3C8502)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Configure skip-over-dtim and beacon filtering on D0i3
enter/exit.

Since the D0i3 entry/exit commands require different
command flags (e.g. CMD_HIGH_PRIORITY), add a new parameter
to the functions being called, and make the current users
pass CMD_SYNC.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c  |    4 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h |   33 ++++---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c     |   13 +--
 drivers/net/wireless/iwlwifi/mvm/mvm.h          |   16 +++-
 drivers/net/wireless/iwlwifi/mvm/power.c        |  114 +++++++++++++++++++----
 5 files changed, 139 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
index f6bed07..a46895e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
@@ -457,9 +457,9 @@ static ssize_t iwl_dbgfs_bf_params_write(struct ieee80211_vif *vif, char *buf,
 	mutex_lock(&mvm->mutex);
 	iwl_dbgfs_update_bf(vif, param, value);
 	if (param == MVM_DEBUGFS_BF_ENABLE_BEACON_FILTER && !value)
-		ret = iwl_mvm_disable_beacon_filter(mvm, vif);
+		ret = iwl_mvm_disable_beacon_filter(mvm, vif, CMD_SYNC);
 	else
-		ret = iwl_mvm_enable_beacon_filter(mvm, vif);
+		ret = iwl_mvm_enable_beacon_filter(mvm, vif, CMD_SYNC);
 	mutex_unlock(&mvm->mutex);
 
 	return ret ?: count;
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
index 884c087..cbbcd8e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
@@ -301,54 +301,65 @@ struct iwl_beacon_filter_cmd {
 
 /* Beacon filtering and beacon abort */
 #define IWL_BF_ENERGY_DELTA_DEFAULT 5
+#define IWL_BF_ENERGY_DELTA_D0I3 20
 #define IWL_BF_ENERGY_DELTA_MAX 255
 #define IWL_BF_ENERGY_DELTA_MIN 0
 
 #define IWL_BF_ROAMING_ENERGY_DELTA_DEFAULT 1
+#define IWL_BF_ROAMING_ENERGY_DELTA_D0I3 20
 #define IWL_BF_ROAMING_ENERGY_DELTA_MAX 255
 #define IWL_BF_ROAMING_ENERGY_DELTA_MIN 0
 
 #define IWL_BF_ROAMING_STATE_DEFAULT 72
+#define IWL_BF_ROAMING_STATE_D0I3 72
 #define IWL_BF_ROAMING_STATE_MAX 255
 #define IWL_BF_ROAMING_STATE_MIN 0
 
 #define IWL_BF_TEMP_THRESHOLD_DEFAULT 112
+#define IWL_BF_TEMP_THRESHOLD_D0I3 112
 #define IWL_BF_TEMP_THRESHOLD_MAX 255
 #define IWL_BF_TEMP_THRESHOLD_MIN 0
 
 #define IWL_BF_TEMP_FAST_FILTER_DEFAULT 1
+#define IWL_BF_TEMP_FAST_FILTER_D0I3 1
 #define IWL_BF_TEMP_FAST_FILTER_MAX 255
 #define IWL_BF_TEMP_FAST_FILTER_MIN 0
 
 #define IWL_BF_TEMP_SLOW_FILTER_DEFAULT 5
+#define IWL_BF_TEMP_SLOW_FILTER_D0I3 5
 #define IWL_BF_TEMP_SLOW_FILTER_MAX 255
 #define IWL_BF_TEMP_SLOW_FILTER_MIN 0
 
 #define IWL_BF_ENABLE_BEACON_FILTER_DEFAULT 1
 
 #define IWL_BF_DEBUG_FLAG_DEFAULT 0
+#define IWL_BF_DEBUG_FLAG_D0I3 0
 
 #define IWL_BF_ESCAPE_TIMER_DEFAULT 50
+#define IWL_BF_ESCAPE_TIMER_D0I3 1024
 #define IWL_BF_ESCAPE_TIMER_MAX 1024
 #define IWL_BF_ESCAPE_TIMER_MIN 0
 
 #define IWL_BA_ESCAPE_TIMER_DEFAULT 6
+#define IWL_BA_ESCAPE_TIMER_D0I3 6
 #define IWL_BA_ESCAPE_TIMER_D3 9
 #define IWL_BA_ESCAPE_TIMER_MAX 1024
 #define IWL_BA_ESCAPE_TIMER_MIN 0
 
 #define IWL_BA_ENABLE_BEACON_ABORT_DEFAULT 1
 
-#define IWL_BF_CMD_CONFIG_DEFAULTS					     \
-	.bf_energy_delta = cpu_to_le32(IWL_BF_ENERGY_DELTA_DEFAULT),	     \
-	.bf_roaming_energy_delta =					     \
-		cpu_to_le32(IWL_BF_ROAMING_ENERGY_DELTA_DEFAULT),	     \
-	.bf_roaming_state = cpu_to_le32(IWL_BF_ROAMING_STATE_DEFAULT),	     \
-	.bf_temp_threshold = cpu_to_le32(IWL_BF_TEMP_THRESHOLD_DEFAULT),     \
-	.bf_temp_fast_filter = cpu_to_le32(IWL_BF_TEMP_FAST_FILTER_DEFAULT), \
-	.bf_temp_slow_filter = cpu_to_le32(IWL_BF_TEMP_SLOW_FILTER_DEFAULT), \
-	.bf_debug_flag = cpu_to_le32(IWL_BF_DEBUG_FLAG_DEFAULT),	     \
-	.bf_escape_timer = cpu_to_le32(IWL_BF_ESCAPE_TIMER_DEFAULT),	     \
-	.ba_escape_timer = cpu_to_le32(IWL_BA_ESCAPE_TIMER_DEFAULT)
+#define IWL_BF_CMD_CONFIG(mode)					     \
+	.bf_energy_delta = cpu_to_le32(IWL_BF_ENERGY_DELTA ## mode),	      \
+	.bf_roaming_energy_delta =					      \
+		cpu_to_le32(IWL_BF_ROAMING_ENERGY_DELTA ## mode),	      \
+	.bf_roaming_state = cpu_to_le32(IWL_BF_ROAMING_STATE ## mode),	      \
+	.bf_temp_threshold = cpu_to_le32(IWL_BF_TEMP_THRESHOLD ## mode),      \
+	.bf_temp_fast_filter = cpu_to_le32(IWL_BF_TEMP_FAST_FILTER ## mode),  \
+	.bf_temp_slow_filter = cpu_to_le32(IWL_BF_TEMP_SLOW_FILTER ## mode),  \
+	.bf_debug_flag = cpu_to_le32(IWL_BF_DEBUG_FLAG ## mode),	      \
+	.bf_escape_timer = cpu_to_le32(IWL_BF_ESCAPE_TIMER ## mode),	      \
+	.ba_escape_timer = cpu_to_le32(IWL_BA_ESCAPE_TIMER ## mode)
 
+#define IWL_BF_CMD_CONFIG_DEFAULTS IWL_BF_CMD_CONFIG(_DEFAULT)
+#define IWL_BF_CMD_CONFIG_D0I3 IWL_BF_CMD_CONFIG(_D0I3)
 #endif
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 67c0dfc..de38deb 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -677,7 +677,7 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 	iwl_mvm_power_disable(mvm, vif);
 
 	/* beacon filtering */
-	ret = iwl_mvm_disable_beacon_filter(mvm, vif);
+	ret = iwl_mvm_disable_beacon_filter(mvm, vif, CMD_SYNC);
 	if (ret)
 		goto out_remove_mac;
 
@@ -1213,7 +1213,7 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 		IWL_DEBUG_MAC80211(mvm, "cqm info_changed");
 		/* reset cqm events tracking */
 		mvmvif->bf_data.last_cqm_event = 0;
-		ret = iwl_mvm_update_beacon_filter(mvm, vif);
+		ret = iwl_mvm_update_beacon_filter(mvm, vif, false, CMD_SYNC);
 		if (ret)
 			IWL_ERR(mvm, "failed to update CQM thresholds\n");
 	}
@@ -1561,12 +1561,12 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 	} else if (old_state == IEEE80211_STA_ASSOC &&
 		   new_state == IEEE80211_STA_AUTHORIZED) {
 		/* enable beacon filtering */
-		WARN_ON(iwl_mvm_enable_beacon_filter(mvm, vif));
+		WARN_ON(iwl_mvm_enable_beacon_filter(mvm, vif, CMD_SYNC));
 		ret = 0;
 	} else if (old_state == IEEE80211_STA_AUTHORIZED &&
 		   new_state == IEEE80211_STA_ASSOC) {
 		/* disable beacon filtering */
-		WARN_ON(iwl_mvm_disable_beacon_filter(mvm, vif));
+		WARN_ON(iwl_mvm_disable_beacon_filter(mvm, vif, CMD_SYNC));
 		ret = 0;
 	} else if (old_state == IEEE80211_STA_ASSOC &&
 		   new_state == IEEE80211_STA_AUTH) {
@@ -2149,8 +2149,9 @@ static int __iwl_mvm_mac_testmode_cmd(struct iwl_mvm *mvm,
 			return -EINVAL;
 
 		if (nla_get_u32(tb[IWL_MVM_TM_ATTR_BEACON_FILTER_STATE]))
-			return iwl_mvm_enable_beacon_filter(mvm, vif);
-		return iwl_mvm_disable_beacon_filter(mvm, vif);
+			return iwl_mvm_enable_beacon_filter(mvm, vif,
+							    CMD_SYNC);
+		return iwl_mvm_disable_beacon_filter(mvm, vif, CMD_SYNC);
 	}
 
 	return -EOPNOTSUPP;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 3202a6e..0a8c65b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -912,16 +912,24 @@ iwl_mvm_beacon_filter_debugfs_parameters(struct ieee80211_vif *vif,
 					 struct iwl_beacon_filter_cmd *cmd)
 {}
 #endif
+int iwl_mvm_update_d0i3_power_mode(struct iwl_mvm *mvm,
+				   struct ieee80211_vif *vif,
+				   bool enable, u32 flags);
 int iwl_mvm_enable_beacon_filter(struct iwl_mvm *mvm,
-				 struct ieee80211_vif *vif);
+				 struct ieee80211_vif *vif,
+				 u32 flags);
 int iwl_mvm_disable_beacon_filter(struct iwl_mvm *mvm,
-				  struct ieee80211_vif *vif);
+				  struct ieee80211_vif *vif,
+				  u32 flags);
 int iwl_mvm_beacon_filter_send_cmd(struct iwl_mvm *mvm,
-				   struct iwl_beacon_filter_cmd *cmd);
+				   struct iwl_beacon_filter_cmd *cmd,
+				   u32 flags);
 int iwl_mvm_update_beacon_abort(struct iwl_mvm *mvm,
 				struct ieee80211_vif *vif, bool enable);
 int iwl_mvm_update_beacon_filter(struct iwl_mvm *mvm,
-				  struct ieee80211_vif *vif);
+				 struct ieee80211_vif *vif,
+				 bool force,
+				 u32 flags);
 
 /* SMPS */
 void iwl_mvm_update_smps(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index 436c7e0..b20771c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -75,11 +75,12 @@
 #define POWER_KEEP_ALIVE_PERIOD_SEC    25
 
 int iwl_mvm_beacon_filter_send_cmd(struct iwl_mvm *mvm,
-				   struct iwl_beacon_filter_cmd *cmd)
+				   struct iwl_beacon_filter_cmd *cmd,
+				   u32 flags)
 {
 	int ret;
 
-	ret = iwl_mvm_send_cmd_pdu(mvm, REPLY_BEACON_FILTERING_CMD, CMD_SYNC,
+	ret = iwl_mvm_send_cmd_pdu(mvm, REPLY_BEACON_FILTERING_CMD, flags,
 				   sizeof(struct iwl_beacon_filter_cmd), cmd);
 
 	if (!ret) {
@@ -145,7 +146,7 @@ int iwl_mvm_update_beacon_abort(struct iwl_mvm *mvm,
 	mvmvif->bf_data.ba_enabled = enable;
 	iwl_mvm_beacon_filter_set_cqm_params(mvm, vif, &cmd);
 	iwl_mvm_beacon_filter_debugfs_parameters(vif, &cmd);
-	return iwl_mvm_beacon_filter_send_cmd(mvm, &cmd);
+	return iwl_mvm_beacon_filter_send_cmd(mvm, &cmd, CMD_SYNC);
 }
 
 static void iwl_mvm_power_log(struct iwl_mvm *mvm,
@@ -686,32 +687,46 @@ iwl_mvm_beacon_filter_debugfs_parameters(struct ieee80211_vif *vif,
 }
 #endif
 
-int iwl_mvm_enable_beacon_filter(struct iwl_mvm *mvm,
-				 struct ieee80211_vif *vif)
+static int _iwl_mvm_enable_beacon_filter(struct iwl_mvm *mvm,
+					 struct ieee80211_vif *vif,
+					 struct iwl_beacon_filter_cmd *cmd,
+					 u32 cmd_flags,
+					 bool d0i3)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	struct iwl_beacon_filter_cmd cmd = {
-		IWL_BF_CMD_CONFIG_DEFAULTS,
-		.bf_enable_beacon_filter = cpu_to_le32(1),
-	};
 	int ret;
 
 	if (mvmvif != mvm->bf_allowed_vif ||
 	    vif->type != NL80211_IFTYPE_STATION || vif->p2p)
 		return 0;
 
-	iwl_mvm_beacon_filter_set_cqm_params(mvm, vif, &cmd);
-	iwl_mvm_beacon_filter_debugfs_parameters(vif, &cmd);
-	ret = iwl_mvm_beacon_filter_send_cmd(mvm, &cmd);
+	iwl_mvm_beacon_filter_set_cqm_params(mvm, vif, cmd);
+	if (!d0i3)
+		iwl_mvm_beacon_filter_debugfs_parameters(vif, cmd);
+	ret = iwl_mvm_beacon_filter_send_cmd(mvm, cmd, cmd_flags);
 
-	if (!ret)
+	/* don't change bf_enabled in case of temporary d0i3 configuration */
+	if (!ret && !d0i3)
 		mvmvif->bf_data.bf_enabled = true;
 
 	return ret;
 }
 
+int iwl_mvm_enable_beacon_filter(struct iwl_mvm *mvm,
+				 struct ieee80211_vif *vif,
+				 u32 flags)
+{
+	struct iwl_beacon_filter_cmd cmd = {
+		IWL_BF_CMD_CONFIG_DEFAULTS,
+		.bf_enable_beacon_filter = cpu_to_le32(1),
+	};
+
+	return _iwl_mvm_enable_beacon_filter(mvm, vif, &cmd, flags, false);
+}
+
 int iwl_mvm_disable_beacon_filter(struct iwl_mvm *mvm,
-				  struct ieee80211_vif *vif)
+				  struct ieee80211_vif *vif,
+				  u32 flags)
 {
 	struct iwl_beacon_filter_cmd cmd = {};
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
@@ -721,7 +736,7 @@ int iwl_mvm_disable_beacon_filter(struct iwl_mvm *mvm,
 	    vif->type != NL80211_IFTYPE_STATION || vif->p2p)
 		return 0;
 
-	ret = iwl_mvm_beacon_filter_send_cmd(mvm, &cmd);
+	ret = iwl_mvm_beacon_filter_send_cmd(mvm, &cmd, flags);
 
 	if (!ret)
 		mvmvif->bf_data.bf_enabled = false;
@@ -729,15 +744,78 @@ int iwl_mvm_disable_beacon_filter(struct iwl_mvm *mvm,
 	return ret;
 }
 
+int iwl_mvm_update_d0i3_power_mode(struct iwl_mvm *mvm,
+				   struct ieee80211_vif *vif,
+				   bool enable, u32 flags)
+{
+	int ret;
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_mac_power_cmd cmd = {};
+
+	if (vif->type != NL80211_IFTYPE_STATION || vif->p2p)
+		return 0;
+
+	if (!vif->bss_conf.assoc)
+		return 0;
+
+	iwl_mvm_power_build_cmd(mvm, vif, &cmd);
+	if (enable) {
+		/* configure skip over dtim up to 300 msec */
+		int dtimper = mvm->hw->conf.ps_dtim_period ?: 1;
+		int dtimper_msec = dtimper * vif->bss_conf.beacon_int;
+
+		if (WARN_ON(!dtimper_msec))
+			return 0;
+
+		cmd.flags |=
+			cpu_to_le16(POWER_FLAGS_SKIP_OVER_DTIM_MSK);
+		cmd.skip_dtim_periods = 300 / dtimper_msec;
+	}
+	iwl_mvm_power_log(mvm, &cmd);
+	ret = iwl_mvm_send_cmd_pdu(mvm, MAC_PM_POWER_TABLE, flags,
+				   sizeof(cmd), &cmd);
+	if (ret)
+		return ret;
+
+	/* configure beacon filtering */
+	if (mvmvif != mvm->bf_allowed_vif)
+		return 0;
+
+	if (enable) {
+		struct iwl_beacon_filter_cmd cmd_bf = {
+			IWL_BF_CMD_CONFIG_D0I3,
+			.bf_enable_beacon_filter = cpu_to_le32(1),
+		};
+		ret = _iwl_mvm_enable_beacon_filter(mvm, vif, &cmd_bf,
+						    flags, true);
+	} else {
+		if (mvmvif->bf_data.bf_enabled)
+			ret = iwl_mvm_enable_beacon_filter(mvm, vif, flags);
+		else
+			ret = iwl_mvm_disable_beacon_filter(mvm, vif, flags);
+	}
+
+	return ret;
+}
+
 int iwl_mvm_update_beacon_filter(struct iwl_mvm *mvm,
-				 struct ieee80211_vif *vif)
+				 struct ieee80211_vif *vif,
+				 bool force,
+				 u32 flags)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 
-	if (!mvmvif->bf_data.bf_enabled)
+	if (mvmvif != mvm->bf_allowed_vif)
 		return 0;
 
-	return iwl_mvm_enable_beacon_filter(mvm, vif);
+	if (!mvmvif->bf_data.bf_enabled) {
+		/* disable beacon filtering explicitly if force is true */
+		if (force)
+			return iwl_mvm_disable_beacon_filter(mvm, vif, flags);
+		return 0;
+	}
+
+	return iwl_mvm_enable_beacon_filter(mvm, vif, flags);
 }
 
 const struct iwl_mvm_power_ops pm_mac_ops = {
-- 
1.7.9.5

