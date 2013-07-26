Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58118 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757558Ab3GZI30 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:29:26 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Hila Gonen <hila.gonen@intel.com>
Subject: [PATCH 23/30] iwlwifi: mvm: Change beacon filtering command
Date: Fri, 26 Jul 2013 10:28:40 +0200
Message-Id: <1374827327-3464-24-git-send-email-johannes@sipsolutions.net> (sfid-20130726_103018_659252_60D521B1)
In-Reply-To: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
References: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hila Gonen <hila.gonen@intel.com>

Change beacon filtering command due to a change in the API.

In case the FW supports the old API, we do not send the
BF HCMD and assume that since the corresponding struct in
the FW is zeroed by default then we don't need to disable
it in the FW actively.

Signed-off-by: Hila Gonen <hila.gonen@intel.com>
Signed-off-by: Dor Shaish <dor.shaish@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h           |  2 +
 drivers/net/wireless/iwlwifi/mvm/debugfs.c      | 74 ++++++++++++++++---------
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h | 65 ++++++++++++++--------
 drivers/net/wireless/iwlwifi/mvm/mac80211.c     |  3 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h          | 30 +++++-----
 drivers/net/wireless/iwlwifi/mvm/power.c        | 55 +++++++++++-------
 6 files changed, 145 insertions(+), 84 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index b766ee9..bd335f0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -78,6 +78,7 @@
  * @IWL_UCODE_TLV_FLAGS_RX_ENERGY_API: supports rx signal strength api
  * @IWL_UCODE_TLV_FLAGS_D3_6_IPV6_ADDRS: D3 image supports up to six
  *	(rather than two) IPv6 addresses
+ * @IWL_UCODE_TLV_FLAGS_BF_UPDATED: new beacon filtering API
  */
 enum iwl_ucode_tlv_flag {
 	IWL_UCODE_TLV_FLAGS_PAN			= BIT(0),
@@ -88,6 +89,7 @@ enum iwl_ucode_tlv_flag {
 	IWL_UCODE_TLV_FLAGS_UAPSD		= BIT(6),
 	IWL_UCODE_TLV_FLAGS_RX_ENERGY_API	= BIT(8),
 	IWL_UCODE_TLV_FLAGS_D3_6_IPV6_ADDRS	= BIT(10),
+	IWL_UCODE_TLV_FLAGS_BF_UPDATED		= BIT(11),
 };
 
 /* The default calibrate table size if not specified by firmware file */
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 5d669da..347aa1c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -632,8 +632,14 @@ static void iwl_dbgfs_update_bf(struct ieee80211_vif *vif,
 	case MVM_DEBUGFS_BF_ROAMING_STATE:
 		dbgfs_bf->bf_roaming_state = value;
 		break;
-	case MVM_DEBUGFS_BF_TEMPERATURE_DELTA:
-		dbgfs_bf->bf_temperature_delta = value;
+	case MVM_DEBUGFS_BF_TEMP_THRESHOLD:
+		dbgfs_bf->bf_temp_threshold = value;
+		break;
+	case MVM_DEBUGFS_BF_TEMP_FAST_FILTER:
+		dbgfs_bf->bf_temp_fast_filter = value;
+		break;
+	case MVM_DEBUGFS_BF_TEMP_SLOW_FILTER:
+		dbgfs_bf->bf_temp_slow_filter = value;
 		break;
 	case MVM_DEBUGFS_BF_ENABLE_BEACON_FILTER:
 		dbgfs_bf->bf_enable_beacon_filter = value;
@@ -692,13 +698,27 @@ static ssize_t iwl_dbgfs_bf_params_write(struct file *file,
 		    value > IWL_BF_ROAMING_STATE_MAX)
 			return -EINVAL;
 		param = MVM_DEBUGFS_BF_ROAMING_STATE;
-	} else if (!strncmp("bf_temperature_delta=", buf, 21)) {
-		if (sscanf(buf+21, "%d", &value) != 1)
+	} else if (!strncmp("bf_temp_threshold=", buf, 18)) {
+		if (sscanf(buf+18, "%d", &value) != 1)
+			return -EINVAL;
+		if (value < IWL_BF_TEMP_THRESHOLD_MIN ||
+		    value > IWL_BF_TEMP_THRESHOLD_MAX)
+			return -EINVAL;
+		param = MVM_DEBUGFS_BF_TEMP_THRESHOLD;
+	} else if (!strncmp("bf_temp_fast_filter=", buf, 20)) {
+		if (sscanf(buf+20, "%d", &value) != 1)
+			return -EINVAL;
+		if (value < IWL_BF_TEMP_FAST_FILTER_MIN ||
+		    value > IWL_BF_TEMP_FAST_FILTER_MAX)
+			return -EINVAL;
+		param = MVM_DEBUGFS_BF_TEMP_FAST_FILTER;
+	} else if (!strncmp("bf_temp_slow_filter=", buf, 20)) {
+		if (sscanf(buf+20, "%d", &value) != 1)
 			return -EINVAL;
-		if (value < IWL_BF_TEMPERATURE_DELTA_MIN ||
-		    value > IWL_BF_TEMPERATURE_DELTA_MAX)
+		if (value < IWL_BF_TEMP_SLOW_FILTER_MIN ||
+		    value > IWL_BF_TEMP_SLOW_FILTER_MAX)
 			return -EINVAL;
-		param = MVM_DEBUGFS_BF_TEMPERATURE_DELTA;
+		param = MVM_DEBUGFS_BF_TEMP_SLOW_FILTER;
 	} else if (!strncmp("bf_enable_beacon_filter=", buf, 24)) {
 		if (sscanf(buf+24, "%d", &value) != 1)
 			return -EINVAL;
@@ -760,41 +780,41 @@ static ssize_t iwl_dbgfs_bf_params_read(struct file *file,
 	int pos = 0;
 	const size_t bufsz = sizeof(buf);
 	struct iwl_beacon_filter_cmd cmd = {
-		.bf_energy_delta = IWL_BF_ENERGY_DELTA_DEFAULT,
-		.bf_roaming_energy_delta = IWL_BF_ROAMING_ENERGY_DELTA_DEFAULT,
-		.bf_roaming_state = IWL_BF_ROAMING_STATE_DEFAULT,
-		.bf_temperature_delta = IWL_BF_TEMPERATURE_DELTA_DEFAULT,
-		.bf_enable_beacon_filter = IWL_BF_ENABLE_BEACON_FILTER_DEFAULT,
-		.bf_debug_flag = IWL_BF_DEBUG_FLAG_DEFAULT,
-		.bf_escape_timer = cpu_to_le32(IWL_BF_ESCAPE_TIMER_DEFAULT),
-		.ba_escape_timer = cpu_to_le32(IWL_BA_ESCAPE_TIMER_DEFAULT),
-		.ba_enable_beacon_abort = IWL_BA_ENABLE_BEACON_ABORT_DEFAULT,
+		IWL_BF_CMD_CONFIG_DEFAULTS,
+		.bf_enable_beacon_filter =
+			cpu_to_le32(IWL_BF_ENABLE_BEACON_FILTER_DEFAULT),
+		.ba_enable_beacon_abort =
+			cpu_to_le32(IWL_BA_ENABLE_BEACON_ABORT_DEFAULT),
 	};
 
 	iwl_mvm_beacon_filter_debugfs_parameters(vif, &cmd);
 	if (mvmvif->bf_enabled)
-		cmd.bf_enable_beacon_filter = 1;
+		cmd.bf_enable_beacon_filter = cpu_to_le32(1);
 	else
 		cmd.bf_enable_beacon_filter = 0;
 
 	pos += scnprintf(buf+pos, bufsz-pos, "bf_energy_delta = %d\n",
-			 cmd.bf_energy_delta);
+			 le32_to_cpu(cmd.bf_energy_delta));
 	pos += scnprintf(buf+pos, bufsz-pos, "bf_roaming_energy_delta = %d\n",
-			 cmd.bf_roaming_energy_delta);
+			 le32_to_cpu(cmd.bf_roaming_energy_delta));
 	pos += scnprintf(buf+pos, bufsz-pos, "bf_roaming_state = %d\n",
-			 cmd.bf_roaming_state);
-	pos += scnprintf(buf+pos, bufsz-pos, "bf_temperature_delta = %d\n",
-			 cmd.bf_temperature_delta);
+			 le32_to_cpu(cmd.bf_roaming_state));
+	pos += scnprintf(buf+pos, bufsz-pos, "bf_temp_threshold = %d\n",
+			 le32_to_cpu(cmd.bf_temp_threshold));
+	pos += scnprintf(buf+pos, bufsz-pos, "bf_temp_fast_filter = %d\n",
+			 le32_to_cpu(cmd.bf_temp_fast_filter));
+	pos += scnprintf(buf+pos, bufsz-pos, "bf_temp_slow_filter = %d\n",
+			 le32_to_cpu(cmd.bf_temp_slow_filter));
 	pos += scnprintf(buf+pos, bufsz-pos, "bf_enable_beacon_filter = %d\n",
-			 cmd.bf_enable_beacon_filter);
+			 le32_to_cpu(cmd.bf_enable_beacon_filter));
 	pos += scnprintf(buf+pos, bufsz-pos, "bf_debug_flag = %d\n",
-			 cmd.bf_debug_flag);
+			 le32_to_cpu(cmd.bf_debug_flag));
 	pos += scnprintf(buf+pos, bufsz-pos, "bf_escape_timer = %d\n",
-			 cmd.bf_escape_timer);
+			 le32_to_cpu(cmd.bf_escape_timer));
 	pos += scnprintf(buf+pos, bufsz-pos, "ba_escape_timer = %d\n",
-			 cmd.ba_escape_timer);
+			 le32_to_cpu(cmd.ba_escape_timer));
 	pos += scnprintf(buf+pos, bufsz-pos, "ba_enable_beacon_abort = %d\n",
-			 cmd.ba_enable_beacon_abort);
+			 le32_to_cpu(cmd.ba_enable_beacon_abort));
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
index 300211d..149347d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
@@ -216,11 +216,21 @@ struct iwl_mac_power_cmd {
  *      calculated for current beacon is less than the threshold, use
  *      Roaming Energy Delta Threshold, otherwise use normal Energy Delta
  *      Threshold. Typical energy threshold is -72dBm.
- * @bf_temperature_delta: Send Beacon to driver if delta in temperature values
- *      calculated for this and the last passed beacon is greater than  this
- *      threshold. Zero value means that the temperature changeis ignored for
+ * @bf_temp_threshold: This threshold determines the type of temperature
+ *	filtering (Slow or Fast) that is selected (Units are in Celsuis):
+ *      If the current temperature is above this threshold - Fast filter
+ *	will be used, If the current temperature is below this threshold -
+ *	Slow filter will be used.
+ * @bf_temp_fast_filter: Send Beacon to driver if delta in temperature values
+ *      calculated for this and the last passed beacon is greater than this
+ *      threshold. Zero value means that the temperature change is ignored for
  *      beacon filtering; beacons will not be  forced to be sent to driver
  *      regardless of whether its temerature has been changed.
+ * @bf_temp_slow_filter: Send Beacon to driver if delta in temperature values
+ *      calculated for this and the last passed beacon is greater than this
+ *      threshold. Zero value means that the temperature change is ignored for
+ *      beacon filtering; beacons will not be forced to be sent to driver
+ *      regardless of whether its temerature has been changed.
  * @bf_enable_beacon_filter: 1, beacon filtering is enabled; 0, disabled.
  * @bf_filter_escape_timer: Send beacons to to driver if no beacons were passed
  *      for a specific period of time. Units: Beacons.
@@ -229,17 +239,17 @@ struct iwl_mac_power_cmd {
  * @ba_enable_beacon_abort: 1, beacon abort is enabled; 0, disabled.
  */
 struct iwl_beacon_filter_cmd {
-	u8 bf_energy_delta;
-	u8 bf_roaming_energy_delta;
-	u8 bf_roaming_state;
-	u8 bf_temperature_delta;
-	u8 bf_enable_beacon_filter;
-	u8 bf_debug_flag;
-	__le16 reserved1;
+	__le32 bf_energy_delta;
+	__le32 bf_roaming_energy_delta;
+	__le32 bf_roaming_state;
+	__le32 bf_temp_threshold;
+	__le32 bf_temp_fast_filter;
+	__le32 bf_temp_slow_filter;
+	__le32 bf_enable_beacon_filter;
+	__le32 bf_debug_flag;
 	__le32 bf_escape_timer;
 	__le32 ba_escape_timer;
-	u8 ba_enable_beacon_abort;
-	u8 reserved2[3];
+	__le32 ba_enable_beacon_abort;
 } __packed;
 
 /* Beacon filtering and beacon abort */
@@ -255,9 +265,17 @@ struct iwl_beacon_filter_cmd {
 #define IWL_BF_ROAMING_STATE_MAX 255
 #define IWL_BF_ROAMING_STATE_MIN 0
 
-#define IWL_BF_TEMPERATURE_DELTA_DEFAULT 5
-#define IWL_BF_TEMPERATURE_DELTA_MAX 255
-#define IWL_BF_TEMPERATURE_DELTA_MIN 0
+#define IWL_BF_TEMP_THRESHOLD_DEFAULT 112
+#define IWL_BF_TEMP_THRESHOLD_MAX 255
+#define IWL_BF_TEMP_THRESHOLD_MIN 0
+
+#define IWL_BF_TEMP_FAST_FILTER_DEFAULT 1
+#define IWL_BF_TEMP_FAST_FILTER_MAX 255
+#define IWL_BF_TEMP_FAST_FILTER_MIN 0
+
+#define IWL_BF_TEMP_SLOW_FILTER_DEFAULT 5
+#define IWL_BF_TEMP_SLOW_FILTER_MAX 255
+#define IWL_BF_TEMP_SLOW_FILTER_MIN 0
 
 #define IWL_BF_ENABLE_BEACON_FILTER_DEFAULT 1
 
@@ -273,13 +291,16 @@ struct iwl_beacon_filter_cmd {
 
 #define IWL_BA_ENABLE_BEACON_ABORT_DEFAULT 1
 
-#define IWL_BF_CMD_CONFIG_DEFAULTS					\
-	.bf_energy_delta = IWL_BF_ENERGY_DELTA_DEFAULT,			\
-	.bf_roaming_energy_delta = IWL_BF_ROAMING_ENERGY_DELTA_DEFAULT,	\
-	.bf_roaming_state = IWL_BF_ROAMING_STATE_DEFAULT,		\
-	.bf_temperature_delta = IWL_BF_TEMPERATURE_DELTA_DEFAULT,	\
-	.bf_debug_flag = IWL_BF_DEBUG_FLAG_DEFAULT,			\
-	.bf_escape_timer = cpu_to_le32(IWL_BF_ESCAPE_TIMER_DEFAULT),	\
+#define IWL_BF_CMD_CONFIG_DEFAULTS					     \
+	.bf_energy_delta = cpu_to_le32(IWL_BF_ENERGY_DELTA_DEFAULT),	     \
+	.bf_roaming_energy_delta =					     \
+		cpu_to_le32(IWL_BF_ROAMING_ENERGY_DELTA_DEFAULT),	     \
+	.bf_roaming_state = cpu_to_le32(IWL_BF_ROAMING_STATE_DEFAULT),	     \
+	.bf_temp_threshold = cpu_to_le32(IWL_BF_TEMP_THRESHOLD_DEFAULT),     \
+	.bf_temp_fast_filter = cpu_to_le32(IWL_BF_TEMP_FAST_FILTER_DEFAULT), \
+	.bf_temp_slow_filter = cpu_to_le32(IWL_BF_TEMP_SLOW_FILTER_DEFAULT), \
+	.bf_debug_flag = cpu_to_le32(IWL_BF_DEBUG_FLAG_DEFAULT),	     \
+	.bf_escape_timer = cpu_to_le32(IWL_BF_ESCAPE_TIMER_DEFAULT),	     \
 	.ba_escape_timer = cpu_to_le32(IWL_BA_ESCAPE_TIMER_DEFAULT)
 
 #endif
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index b5280e1..3728963 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -563,7 +563,8 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 
 	/* beacon filtering */
 	if (!mvm->bf_allowed_vif &&
-	    vif->type == NL80211_IFTYPE_STATION && !vif->p2p){
+	    vif->type == NL80211_IFTYPE_STATION && !vif->p2p &&
+	    mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_BF_UPDATED){
 		mvm->bf_allowed_vif = mvmvif;
 		vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER;
 	}
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 8891c81..dda0cd0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -195,24 +195,28 @@ enum iwl_dbgfs_bf_mask {
 	MVM_DEBUGFS_BF_ENERGY_DELTA = BIT(0),
 	MVM_DEBUGFS_BF_ROAMING_ENERGY_DELTA = BIT(1),
 	MVM_DEBUGFS_BF_ROAMING_STATE = BIT(2),
-	MVM_DEBUGFS_BF_TEMPERATURE_DELTA = BIT(3),
-	MVM_DEBUGFS_BF_ENABLE_BEACON_FILTER = BIT(4),
-	MVM_DEBUGFS_BF_DEBUG_FLAG = BIT(5),
-	MVM_DEBUGFS_BF_ESCAPE_TIMER = BIT(6),
-	MVM_DEBUGFS_BA_ESCAPE_TIMER = BIT(7),
-	MVM_DEBUGFS_BA_ENABLE_BEACON_ABORT = BIT(8),
+	MVM_DEBUGFS_BF_TEMP_THRESHOLD = BIT(3),
+	MVM_DEBUGFS_BF_TEMP_FAST_FILTER = BIT(4),
+	MVM_DEBUGFS_BF_TEMP_SLOW_FILTER = BIT(5),
+	MVM_DEBUGFS_BF_ENABLE_BEACON_FILTER = BIT(6),
+	MVM_DEBUGFS_BF_DEBUG_FLAG = BIT(7),
+	MVM_DEBUGFS_BF_ESCAPE_TIMER = BIT(8),
+	MVM_DEBUGFS_BA_ESCAPE_TIMER = BIT(9),
+	MVM_DEBUGFS_BA_ENABLE_BEACON_ABORT = BIT(10),
 };
 
 struct iwl_dbgfs_bf {
-	u8 bf_energy_delta;
-	u8 bf_roaming_energy_delta;
-	u8 bf_roaming_state;
-	u8 bf_temperature_delta;
-	u8 bf_enable_beacon_filter;
-	u8 bf_debug_flag;
+	u32 bf_energy_delta;
+	u32 bf_roaming_energy_delta;
+	u32 bf_roaming_state;
+	u32 bf_temp_threshold;
+	u32 bf_temp_fast_filter;
+	u32 bf_temp_slow_filter;
+	u32 bf_enable_beacon_filter;
+	u32 bf_debug_flag;
 	u32 bf_escape_timer;
 	u32 ba_escape_timer;
-	u8 ba_enable_beacon_abort;
+	u32 ba_enable_beacon_abort;
 	int mask;
 };
 #endif
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index 8ed0403..30306a9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -85,23 +85,27 @@ int iwl_mvm_beacon_filter_send_cmd(struct iwl_mvm *mvm,
 
 	if (!ret) {
 		IWL_DEBUG_POWER(mvm, "ba_enable_beacon_abort is: %d\n",
-				cmd->ba_enable_beacon_abort);
+				le32_to_cpu(cmd->ba_enable_beacon_abort));
 		IWL_DEBUG_POWER(mvm, "ba_escape_timer is: %d\n",
-				cmd->ba_escape_timer);
+				le32_to_cpu(cmd->ba_escape_timer));
 		IWL_DEBUG_POWER(mvm, "bf_debug_flag is: %d\n",
-				cmd->bf_debug_flag);
+				le32_to_cpu(cmd->bf_debug_flag));
 		IWL_DEBUG_POWER(mvm, "bf_enable_beacon_filter is: %d\n",
-				cmd->bf_enable_beacon_filter);
+				le32_to_cpu(cmd->bf_enable_beacon_filter));
 		IWL_DEBUG_POWER(mvm, "bf_energy_delta is: %d\n",
-				cmd->bf_energy_delta);
+				le32_to_cpu(cmd->bf_energy_delta));
 		IWL_DEBUG_POWER(mvm, "bf_escape_timer is: %d\n",
-				cmd->bf_escape_timer);
+				le32_to_cpu(cmd->bf_escape_timer));
 		IWL_DEBUG_POWER(mvm, "bf_roaming_energy_delta is: %d\n",
-				cmd->bf_roaming_energy_delta);
+				le32_to_cpu(cmd->bf_roaming_energy_delta));
 		IWL_DEBUG_POWER(mvm, "bf_roaming_state is: %d\n",
-				cmd->bf_roaming_state);
-		IWL_DEBUG_POWER(mvm, "bf_temperature_delta is: %d\n",
-				cmd->bf_temperature_delta);
+				le32_to_cpu(cmd->bf_roaming_state));
+		IWL_DEBUG_POWER(mvm, "bf_temp_threshold is: %d\n",
+				le32_to_cpu(cmd->bf_temp_threshold));
+		IWL_DEBUG_POWER(mvm, "bf_temp_fast_filter is: %d\n",
+				le32_to_cpu(cmd->bf_temp_fast_filter));
+		IWL_DEBUG_POWER(mvm, "bf_temp_slow_filter is: %d\n",
+				le32_to_cpu(cmd->bf_temp_slow_filter));
 	}
 	return ret;
 }
@@ -112,8 +116,8 @@ int iwl_mvm_update_beacon_abort(struct iwl_mvm *mvm,
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_beacon_filter_cmd cmd = {
 		IWL_BF_CMD_CONFIG_DEFAULTS,
-		.bf_enable_beacon_filter = 1,
-		.ba_enable_beacon_abort = enable,
+		.bf_enable_beacon_filter = cpu_to_le32(1),
+		.ba_enable_beacon_abort = cpu_to_le32(enable),
 	};
 
 	if (!mvmvif->bf_enabled)
@@ -369,22 +373,30 @@ iwl_mvm_beacon_filter_debugfs_parameters(struct ieee80211_vif *vif,
 	struct iwl_dbgfs_bf *dbgfs_bf = &mvmvif->dbgfs_bf;
 
 	if (dbgfs_bf->mask & MVM_DEBUGFS_BF_ENERGY_DELTA)
-		cmd->bf_energy_delta = dbgfs_bf->bf_energy_delta;
+		cmd->bf_energy_delta = cpu_to_le32(dbgfs_bf->bf_energy_delta);
 	if (dbgfs_bf->mask & MVM_DEBUGFS_BF_ROAMING_ENERGY_DELTA)
 		cmd->bf_roaming_energy_delta =
-				 dbgfs_bf->bf_roaming_energy_delta;
+				cpu_to_le32(dbgfs_bf->bf_roaming_energy_delta);
 	if (dbgfs_bf->mask & MVM_DEBUGFS_BF_ROAMING_STATE)
-		cmd->bf_roaming_state = dbgfs_bf->bf_roaming_state;
-	if (dbgfs_bf->mask & MVM_DEBUGFS_BF_TEMPERATURE_DELTA)
-		cmd->bf_temperature_delta = dbgfs_bf->bf_temperature_delta;
+		cmd->bf_roaming_state = cpu_to_le32(dbgfs_bf->bf_roaming_state);
+	if (dbgfs_bf->mask & MVM_DEBUGFS_BF_TEMP_THRESHOLD)
+		cmd->bf_temp_threshold =
+				cpu_to_le32(dbgfs_bf->bf_temp_threshold);
+	if (dbgfs_bf->mask & MVM_DEBUGFS_BF_TEMP_FAST_FILTER)
+		cmd->bf_temp_fast_filter =
+				cpu_to_le32(dbgfs_bf->bf_temp_fast_filter);
+	if (dbgfs_bf->mask & MVM_DEBUGFS_BF_TEMP_SLOW_FILTER)
+		cmd->bf_temp_slow_filter =
+				cpu_to_le32(dbgfs_bf->bf_temp_slow_filter);
 	if (dbgfs_bf->mask & MVM_DEBUGFS_BF_DEBUG_FLAG)
-		cmd->bf_debug_flag = dbgfs_bf->bf_debug_flag;
+		cmd->bf_debug_flag = cpu_to_le32(dbgfs_bf->bf_debug_flag);
 	if (dbgfs_bf->mask & MVM_DEBUGFS_BF_ESCAPE_TIMER)
 		cmd->bf_escape_timer = cpu_to_le32(dbgfs_bf->bf_escape_timer);
 	if (dbgfs_bf->mask & MVM_DEBUGFS_BA_ESCAPE_TIMER)
 		cmd->ba_escape_timer = cpu_to_le32(dbgfs_bf->ba_escape_timer);
 	if (dbgfs_bf->mask & MVM_DEBUGFS_BA_ENABLE_BEACON_ABORT)
-		cmd->ba_enable_beacon_abort = dbgfs_bf->ba_enable_beacon_abort;
+		cmd->ba_enable_beacon_abort =
+				cpu_to_le32(dbgfs_bf->ba_enable_beacon_abort);
 }
 #endif
 
@@ -394,7 +406,7 @@ int iwl_mvm_enable_beacon_filter(struct iwl_mvm *mvm,
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_beacon_filter_cmd cmd = {
 		IWL_BF_CMD_CONFIG_DEFAULTS,
-		.bf_enable_beacon_filter = 1,
+		.bf_enable_beacon_filter = cpu_to_le32(1),
 	};
 	int ret;
 
@@ -418,7 +430,8 @@ int iwl_mvm_disable_beacon_filter(struct iwl_mvm *mvm,
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	int ret;
 
-	if (vif->type != NL80211_IFTYPE_STATION || vif->p2p)
+	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_BF_UPDATED) ||
+	    vif->type != NL80211_IFTYPE_STATION || vif->p2p)
 		return 0;
 
 	ret = iwl_mvm_beacon_filter_send_cmd(mvm, &cmd);
-- 
1.8.0

