Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58105 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757712Ab3GZI2z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:28:55 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>
Subject: [PATCH 07/30] iwlwifi: mvm: Upgrade to a new power management uAPSD API
Date: Fri, 26 Jul 2013 10:28:24 +0200
Message-Id: <1374827327-3464-8-git-send-email-johannes@sipsolutions.net> (sfid-20130726_102917_765115_50E4EE9C)
In-Reply-To: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
References: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

Change power management implementation to support new host-device API
containing uAPSD parameters. Verify FW support for this new API.
Use the new power table command (0xA9) to configure power management.
Use the legacy command (0x77) if FW does not support the new API.
New file power_legacy.c is introduced for legacy implementation.

Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h           |   2 +
 drivers/net/wireless/iwlwifi/mvm/Makefile       |   2 +-
 drivers/net/wireless/iwlwifi/mvm/debugfs.c      |  33 +--
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h |  75 +++++-
 drivers/net/wireless/iwlwifi/mvm/fw-api.h       |   5 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c     |  11 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h          |  46 +++-
 drivers/net/wireless/iwlwifi/mvm/ops.c          |   6 +
 drivers/net/wireless/iwlwifi/mvm/power.c        | 128 +++++++---
 drivers/net/wireless/iwlwifi/mvm/power_legacy.c | 319 ++++++++++++++++++++++++
 10 files changed, 546 insertions(+), 81 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/power_legacy.c

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index f844d5c..f26f126 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -74,6 +74,7 @@
  * @IWL_UCODE_TLV_FLAGS_MFP: This uCode image supports MFP (802.11w).
  * @IWL_UCODE_TLV_FLAGS_P2P: This uCode image supports P2P.
  * @IWL_UCODE_TLV_FLAGS_DW_BC_TABLE: The SCD byte count table is in DWORDS
+ * @IWL_UCODE_TLV_FLAGS_UAPSD: This uCode image supports uAPSD
  */
 enum iwl_ucode_tlv_flag {
 	IWL_UCODE_TLV_FLAGS_PAN		= BIT(0),
@@ -81,6 +82,7 @@ enum iwl_ucode_tlv_flag {
 	IWL_UCODE_TLV_FLAGS_MFP		= BIT(2),
 	IWL_UCODE_TLV_FLAGS_P2P		= BIT(3),
 	IWL_UCODE_TLV_FLAGS_DW_BC_TABLE	= BIT(4),
+	IWL_UCODE_TLV_FLAGS_UAPSD	= BIT(6),
 };
 
 /* The default calibrate table size if not specified by firmware file */
diff --git a/drivers/net/wireless/iwlwifi/mvm/Makefile b/drivers/net/wireless/iwlwifi/mvm/Makefile
index ff856e5..6d73817 100644
--- a/drivers/net/wireless/iwlwifi/mvm/Makefile
+++ b/drivers/net/wireless/iwlwifi/mvm/Makefile
@@ -2,7 +2,7 @@ obj-$(CONFIG_IWLMVM)   += iwlmvm.o
 iwlmvm-y += fw.o mac80211.o nvm.o ops.o phy-ctxt.o mac-ctxt.o
 iwlmvm-y += utils.o rx.o tx.o binding.o quota.o sta.o
 iwlmvm-y += scan.o time-event.o rs.o
-iwlmvm-y += power.o bt-coex.o
+iwlmvm-y += power.o power_legacy.o bt-coex.o
 iwlmvm-y += led.o tt.o
 iwlmvm-$(CONFIG_IWLWIFI_DEBUGFS) += debugfs.o
 iwlmvm-$(CONFIG_PM_SLEEP) += d3.o
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index e56ed2a..5d669da 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -424,40 +424,11 @@ static ssize_t iwl_dbgfs_pm_params_read(struct file *file,
 	struct ieee80211_vif *vif = file->private_data;
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mvm *mvm = mvmvif->dbgfs_data;
-	struct iwl_powertable_cmd cmd = {};
 	char buf[256];
 	int bufsz = sizeof(buf);
-	int pos = 0;
+	int pos;
 
-	iwl_mvm_power_build_cmd(mvm, vif, &cmd);
-
-	pos += scnprintf(buf+pos, bufsz-pos, "disable_power_off = %d\n",
-			 (cmd.flags &
-			 cpu_to_le16(POWER_FLAGS_POWER_SAVE_ENA_MSK)) ?
-			 0 : 1);
-	pos += scnprintf(buf+pos, bufsz-pos, "skip_dtim_periods = %d\n",
-			 le32_to_cpu(cmd.skip_dtim_periods));
-	pos += scnprintf(buf+pos, bufsz-pos, "power_scheme = %d\n",
-			 iwlmvm_mod_params.power_scheme);
-	pos += scnprintf(buf+pos, bufsz-pos, "flags = 0x%x\n",
-			 le16_to_cpu(cmd.flags));
-	pos += scnprintf(buf+pos, bufsz-pos, "keep_alive = %d\n",
-			 cmd.keep_alive_seconds);
-
-	if (cmd.flags & cpu_to_le16(POWER_FLAGS_POWER_MANAGEMENT_ENA_MSK)) {
-		pos += scnprintf(buf+pos, bufsz-pos, "skip_over_dtim = %d\n",
-				 (cmd.flags &
-				 cpu_to_le16(POWER_FLAGS_SKIP_OVER_DTIM_MSK)) ?
-				 1 : 0);
-		pos += scnprintf(buf+pos, bufsz-pos, "rx_data_timeout = %d\n",
-				 le32_to_cpu(cmd.rx_data_timeout));
-		pos += scnprintf(buf+pos, bufsz-pos, "tx_data_timeout = %d\n",
-				 le32_to_cpu(cmd.tx_data_timeout));
-		if (cmd.flags & cpu_to_le16(POWER_FLAGS_LPRX_ENA_MSK))
-			pos += scnprintf(buf+pos, bufsz-pos,
-					 "lprx_rssi_threshold = %d\n",
-					 le32_to_cpu(cmd.lprx_rssi_threshold));
-	}
+	pos = iwl_mvm_power_dbgfs_read(mvm, vif, buf, bufsz);
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
index a6da359..300211d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
@@ -79,6 +79,10 @@
  *		'1' Driver enables PM (use rest of parameters)
  * @POWER_FLAGS_SKIP_OVER_DTIM_MSK: '0' PM have to walk up every DTIM,
  *		'1' PM could sleep over DTIM till listen Interval.
+ * @POWER_FLAGS_SNOOZE_ENA_MSK: Enable snoozing only if uAPSD is enabled and all
+ *		access categories are both delivery and trigger enabled.
+ * @POWER_FLAGS_BT_SCO_ENA: Enable BT SCO coex only if uAPSD and
+ *		PBW Snoozing enabled
  * @POWER_FLAGS_ADVANCE_PM_ENA_MSK: Advanced PM (uAPSD) enable mask
  * @POWER_FLAGS_LPRX_ENA_MSK: Low Power RX enable.
 */
@@ -86,6 +90,8 @@ enum iwl_power_flags {
 	POWER_FLAGS_POWER_SAVE_ENA_MSK		= BIT(0),
 	POWER_FLAGS_POWER_MANAGEMENT_ENA_MSK	= BIT(1),
 	POWER_FLAGS_SKIP_OVER_DTIM_MSK		= BIT(2),
+	POWER_FLAGS_SNOOZE_ENA_MSK		= BIT(5),
+	POWER_FLAGS_BT_SCO_ENA			= BIT(8),
 	POWER_FLAGS_ADVANCE_PM_ENA_MSK		= BIT(9),
 	POWER_FLAGS_LPRX_ENA_MSK		= BIT(11),
 };
@@ -93,7 +99,8 @@ enum iwl_power_flags {
 #define IWL_POWER_VEC_SIZE 5
 
 /**
- * struct iwl_powertable_cmd - Power Table Command
+ * struct iwl_powertable_cmd - legacy power command. Beside old API support this
+ *	is used also with a new	power API for device wide power settings.
  * POWER_TABLE_CMD = 0x77 (command, has simple generic response)
  *
  * @flags:		Power table command flags from POWER_FLAGS_*
@@ -125,6 +132,72 @@ struct iwl_powertable_cmd {
 } __packed;
 
 /**
+ * struct iwl_mac_power_cmd - New power command containing uAPSD support
+ * MAC_PM_POWER_TABLE = 0xA9 (command, has simple generic response)
+ * @id_and_color:	MAC contex identifier
+ * @flags:		Power table command flags from POWER_FLAGS_*
+ * @keep_alive_seconds:	Keep alive period in seconds. Default - 25 sec.
+ *			Minimum allowed:- 3 * DTIM. Keep alive period must be
+ *			set regardless of power scheme or current power state.
+ *			FW use this value also when PM is disabled.
+ * @rx_data_timeout:    Minimum time (usec) from last Rx packet for AM to
+ *			PSM transition - legacy PM
+ * @tx_data_timeout:    Minimum time (usec) from last Tx packet for AM to
+ *			PSM transition - legacy PM
+ * @sleep_interval:	not in use
+ * @skip_dtim_periods:	Number of DTIM periods to skip if Skip over DTIM flag
+ *			is set. For example, if it is required to skip over
+ *			one DTIM, this value need to be set to 2 (DTIM periods).
+ * @rx_data_timeout_uapsd: Minimum time (usec) from last Rx packet for AM to
+ *			PSM transition - uAPSD
+ * @tx_data_timeout_uapsd: Minimum time (usec) from last Tx packet for AM to
+ *			PSM transition - uAPSD
+ * @lprx_rssi_threshold: Signal strength up to which LP RX can be enabled.
+ *			Default: 80dbm
+ * @num_skip_dtim:	Number of DTIMs to skip if Skip over DTIM flag is set
+ * @snooze_interval:	TBD
+ * @snooze_window:	TBD
+ * @snooze_step:	TBD
+ * @qndp_tid:		TID client shall use for uAPSD QNDP triggers
+ * @uapsd_ac_flags:	Set trigger-enabled and delivery-enabled indication for
+ *			each corresponding AC.
+ *			Use IEEE80211_WMM_IE_STA_QOSINFO_AC* for correct values.
+ * @uapsd_max_sp:	Use IEEE80211_WMM_IE_STA_QOSINFO_SP_* for correct
+ *			values.
+ * @heavy_traffic_thr_tx_pkts:	TX threshold measured in number of packets
+ * @heavy_traffic_thr_rx_pkts:	RX threshold measured in number of packets
+ * @heavy_traffic_thr_tx_load:	TX threshold measured in load's percentage
+ * @heavy_traffic_thr_rx_load:	RX threshold measured in load's percentage
+ * @limited_ps_threshold:
+*/
+struct iwl_mac_power_cmd {
+	/* CONTEXT_DESC_API_T_VER_1 */
+	__le32 id_and_color;
+
+	/* CLIENT_PM_POWER_TABLE_S_VER_1 */
+	__le16 flags;
+	__le16 keep_alive_seconds;
+	__le32 rx_data_timeout;
+	__le32 tx_data_timeout;
+	__le32 rx_data_timeout_uapsd;
+	__le32 tx_data_timeout_uapsd;
+	u8 lprx_rssi_threshold;
+	u8 skip_dtim_periods;
+	__le16 snooze_interval;
+	__le16 snooze_window;
+	u8 snooze_step;
+	u8 qndp_tid;
+	u8 uapsd_ac_flags;
+	u8 uapsd_max_sp;
+	u8 heavy_traffic_threshold_tx_packets;
+	u8 heavy_traffic_threshold_rx_packets;
+	u8 heavy_traffic_threshold_tx_percentage;
+	u8 heavy_traffic_threshold_rx_percentage;
+	u8 limited_ps_threshold;
+	u8 reserved;
+} __packed;
+
+/**
  * struct iwl_beacon_filter_cmd
  * REPLY_BEACON_FILTERING_CMD = 0xd2 (command)
  * @id_and_color: MAC contex identifier
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index cbfb3be..44614f5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -136,7 +136,7 @@ enum {
 	CALIB_RES_NOTIF_PHY_DB = 0x6b,
 	/* PHY_DB_CMD = 0x6c, */
 
-	/* Power */
+	/* Power - legacy power table command */
 	POWER_TABLE_CMD = 0x77,
 
 	/* Thermal Throttling*/
@@ -166,6 +166,9 @@ enum {
 
 	MISSED_BEACONS_NOTIFICATION = 0xa2,
 
+	/* Power - new power table command */
+	MAC_PM_POWER_TABLE = 0xa9,
+
 	REPLY_RX_PHY_CMD = 0xc0,
 	REPLY_RX_MPDU_CMD = 0xc1,
 	BA_NOTIF = 0xc5,
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index e08683b..2d07605 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -774,9 +774,14 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 			if (ret)
 				IWL_ERR(mvm, "failed to update quotas\n");
 		}
-		ret = iwl_mvm_power_update_mode(mvm, vif);
-		if (ret)
-			IWL_ERR(mvm, "failed to update power mode\n");
+		if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_UAPSD)) {
+			/* Workaround for FW bug, otherwise FW disables device
+			 * power save upon disassociation
+			 */
+			ret = iwl_mvm_power_update_mode(mvm, vif);
+			if (ret)
+				IWL_ERR(mvm, "failed to update power mode\n");
+		}
 	} else if (changes & BSS_CHANGED_BEACON_INFO) {
 		/*
 		 * We received a beacon _after_ association so
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 3aaecbc..caa6a175 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -91,6 +91,9 @@ enum iwl_mvm_tx_fifo {
 };
 
 extern struct ieee80211_ops iwl_mvm_hw_ops;
+extern const struct iwl_mvm_power_ops pm_legacy_ops;
+extern const struct iwl_mvm_power_ops pm_mac_ops;
+
 /**
  * struct iwl_mvm_mod_params - module parameters for iwlmvm
  * @init_dbg: if true, then the NIC won't be stopped if the INIT fw asserted.
@@ -150,6 +153,17 @@ enum iwl_power_scheme {
 
 #define IWL_CONN_MAX_LISTEN_INTERVAL	70
 
+struct iwl_mvm_power_ops {
+	int (*power_update_mode)(struct iwl_mvm *mvm,
+				 struct ieee80211_vif *vif);
+	int (*power_disable)(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	int (*power_dbgfs_read)(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+				char *buf, int bufsz);
+#endif
+};
+
+
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 enum iwl_dbgfs_pm_mask {
 	MVM_DEBUGFS_PM_KEEP_ALIVE = BIT(0),
@@ -163,7 +177,7 @@ enum iwl_dbgfs_pm_mask {
 };
 
 struct iwl_dbgfs_pm {
-	u8 keep_alive_seconds;
+	u16 keep_alive_seconds;
 	u32 rx_data_timeout;
 	u32 tx_data_timeout;
 	bool skip_over_dtim;
@@ -481,6 +495,8 @@ struct iwl_mvm {
 	/* Thermal Throttling and CTkill */
 	struct iwl_mvm_tt_mgmt thermal_throttle;
 	s32 temperature;	/* Celsius */
+
+	const struct iwl_mvm_power_ops *pm_ops;
 };
 
 /* Extract MVM priv from op_mode and _hw */
@@ -660,10 +676,26 @@ int iwl_mvm_send_lq_cmd(struct iwl_mvm *mvm, struct iwl_lq_cmd *lq,
 			u8 flags, bool init);
 
 /* power managment */
-int iwl_mvm_power_update_mode(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
-int iwl_mvm_power_disable(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
-void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-			     struct iwl_powertable_cmd *cmd);
+static inline int iwl_mvm_power_update_mode(struct iwl_mvm *mvm,
+					    struct ieee80211_vif *vif)
+{
+	return mvm->pm_ops->power_update_mode(mvm, vif);
+}
+
+static inline int iwl_mvm_power_disable(struct iwl_mvm *mvm,
+					struct ieee80211_vif *vif)
+{
+	return mvm->pm_ops->power_disable(mvm, vif);
+}
+
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+static inline int iwl_mvm_power_dbgfs_read(struct iwl_mvm *mvm,
+					    struct ieee80211_vif *vif,
+					    char *buf, int bufsz)
+{
+	return mvm->pm_ops->power_dbgfs_read(mvm, vif, buf, bufsz);
+}
+#endif
 
 int iwl_mvm_leds_init(struct iwl_mvm *mvm);
 void iwl_mvm_leds_exit(struct iwl_mvm *mvm);
@@ -707,6 +739,10 @@ int iwl_mvm_enable_beacon_filter(struct iwl_mvm *mvm,
 				 struct ieee80211_vif *vif);
 int iwl_mvm_disable_beacon_filter(struct iwl_mvm *mvm,
 				  struct ieee80211_vif *vif);
+int iwl_mvm_beacon_filter_send_cmd(struct iwl_mvm *mvm,
+				   struct iwl_beacon_filter_cmd *cmd);
+int iwl_mvm_update_beacon_abort(struct iwl_mvm *mvm,
+				struct ieee80211_vif *vif, bool enable);
 
 /* SMPS */
 void iwl_mvm_update_smps(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 0a4eb27..fa1e1ce 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -301,6 +301,7 @@ static const char *iwl_mvm_cmd_strings[REPLY_MAX] = {
 	CMD(MCAST_FILTER_CMD),
 	CMD(REPLY_BEACON_FILTERING_CMD),
 	CMD(REPLY_THERMAL_MNG_BACKOFF),
+	CMD(MAC_PM_POWER_TABLE),
 };
 #undef CMD
 
@@ -431,6 +432,11 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	if (err)
 		goto out_unregister;
 
+	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_UAPSD)
+		mvm->pm_ops = &pm_mac_ops;
+	else
+		mvm->pm_ops = &pm_legacy_ops;
+
 	return op_mode;
 
  out_unregister:
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index e7ca965..644bf47 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -75,8 +75,8 @@
 
 #define POWER_KEEP_ALIVE_PERIOD_SEC    25
 
-static int iwl_mvm_beacon_filter_send_cmd(struct iwl_mvm *mvm,
-					  struct iwl_beacon_filter_cmd *cmd)
+int iwl_mvm_beacon_filter_send_cmd(struct iwl_mvm *mvm,
+				   struct iwl_beacon_filter_cmd *cmd)
 {
 	int ret;
 
@@ -106,8 +106,8 @@ static int iwl_mvm_beacon_filter_send_cmd(struct iwl_mvm *mvm,
 	return ret;
 }
 
-static int iwl_mvm_update_beacon_abort(struct iwl_mvm *mvm,
-				       struct ieee80211_vif *vif, bool enable)
+int iwl_mvm_update_beacon_abort(struct iwl_mvm *mvm,
+				struct ieee80211_vif *vif, bool enable)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_beacon_filter_cmd cmd = {
@@ -124,13 +124,14 @@ static int iwl_mvm_update_beacon_abort(struct iwl_mvm *mvm,
 }
 
 static void iwl_mvm_power_log(struct iwl_mvm *mvm,
-			      struct iwl_powertable_cmd *cmd)
+			      struct iwl_mac_power_cmd *cmd)
 {
 	IWL_DEBUG_POWER(mvm,
-			"Sending power table command for power level %d, flags = 0x%X\n",
-			iwlmvm_mod_params.power_scheme,
+			"Sending power table command on mac id 0x%X for power level %d, flags = 0x%X\n",
+			cmd->id_and_color, iwlmvm_mod_params.power_scheme,
 			le16_to_cpu(cmd->flags));
-	IWL_DEBUG_POWER(mvm, "Keep alive = %u sec\n", cmd->keep_alive_seconds);
+	IWL_DEBUG_POWER(mvm, "Keep alive = %u sec\n",
+			le16_to_cpu(cmd->keep_alive_seconds));
 
 	if (cmd->flags & cpu_to_le16(POWER_FLAGS_POWER_MANAGEMENT_ENA_MSK)) {
 		IWL_DEBUG_POWER(mvm, "Rx timeout = %u usec\n",
@@ -139,15 +140,16 @@ static void iwl_mvm_power_log(struct iwl_mvm *mvm,
 				le32_to_cpu(cmd->tx_data_timeout));
 		if (cmd->flags & cpu_to_le16(POWER_FLAGS_SKIP_OVER_DTIM_MSK))
 			IWL_DEBUG_POWER(mvm, "DTIM periods to skip = %u\n",
-					le32_to_cpu(cmd->skip_dtim_periods));
+					cmd->skip_dtim_periods);
 		if (cmd->flags & cpu_to_le16(POWER_FLAGS_LPRX_ENA_MSK))
 			IWL_DEBUG_POWER(mvm, "LP RX RSSI threshold = %u\n",
-					le32_to_cpu(cmd->lprx_rssi_threshold));
+					cmd->lprx_rssi_threshold);
 	}
 }
 
-void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-			     struct iwl_powertable_cmd *cmd)
+static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
+				    struct ieee80211_vif *vif,
+				    struct iwl_mac_power_cmd *cmd)
 {
 	struct ieee80211_hw *hw = mvm->hw;
 	struct ieee80211_chanctx_conf *chanctx_conf;
@@ -158,19 +160,26 @@ void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	struct iwl_mvm_vif *mvmvif __maybe_unused =
 		iwl_mvm_vif_from_mac80211(vif);
 
+	cmd->id_and_color = cpu_to_le32(FW_CMD_ID_AND_COLOR(mvmvif->id,
+							    mvmvif->color));
+	dtimper = hw->conf.ps_dtim_period ?: 1;
+
 	/*
 	 * Regardless of power management state the driver must set
 	 * keep alive period. FW will use it for sending keep alive NDPs
-	 * immediately after association.
+	 * immediately after association. Check that keep alive period
+	 * is at least 3 * DTIM
 	 */
-	cmd->keep_alive_seconds = POWER_KEEP_ALIVE_PERIOD_SEC;
+	dtimper_msec = dtimper * vif->bss_conf.beacon_int;
+	keep_alive = max_t(int, 3 * dtimper_msec,
+			   MSEC_PER_SEC * POWER_KEEP_ALIVE_PERIOD_SEC);
+	keep_alive = DIV_ROUND_UP(keep_alive, MSEC_PER_SEC);
+	cmd->keep_alive_seconds = cpu_to_le16(keep_alive);
 
 	if (iwlmvm_mod_params.power_scheme == IWL_POWER_SCHEME_CAM)
 		return;
 
 	cmd->flags |= cpu_to_le16(POWER_FLAGS_POWER_SAVE_ENA_MSK);
-	if (!vif->bss_conf.assoc)
-		cmd->flags |= cpu_to_le16(POWER_FLAGS_POWER_MANAGEMENT_ENA_MSK);
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	if (mvmvif->dbgfs_pm.mask & MVM_DEBUGFS_PM_DISABLE_POWER_OFF &&
@@ -186,12 +195,9 @@ void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	    (vif->bss_conf.beacon_rate->bitrate == 10 ||
 	     vif->bss_conf.beacon_rate->bitrate == 60)) {
 		cmd->flags |= cpu_to_le16(POWER_FLAGS_LPRX_ENA_MSK);
-		cmd->lprx_rssi_threshold =
-			cpu_to_le32(POWER_LPRX_RSSI_THRESHOLD);
+		cmd->lprx_rssi_threshold = POWER_LPRX_RSSI_THRESHOLD;
 	}
 
-	dtimper = hw->conf.ps_dtim_period ?: 1;
-
 	/* Check if radar detection is required on current channel */
 	rcu_read_lock();
 	chanctx_conf = rcu_dereference(vif->chanctx_conf);
@@ -207,16 +213,9 @@ void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	    (iwlmvm_mod_params.power_scheme == IWL_POWER_SCHEME_LP ||
 	     mvm->cur_ucode == IWL_UCODE_WOWLAN)) {
 		cmd->flags |= cpu_to_le16(POWER_FLAGS_SKIP_OVER_DTIM_MSK);
-		cmd->skip_dtim_periods = cpu_to_le32(3);
+		cmd->skip_dtim_periods = 3;
 	}
 
-	/* Check that keep alive period is at least 3 * DTIM */
-	dtimper_msec = dtimper * vif->bss_conf.beacon_int;
-	keep_alive = max_t(int, 3 * dtimper_msec,
-			   MSEC_PER_SEC * cmd->keep_alive_seconds);
-	keep_alive = DIV_ROUND_UP(keep_alive, MSEC_PER_SEC);
-	cmd->keep_alive_seconds = keep_alive;
-
 	if (mvm->cur_ucode != IWL_UCODE_WOWLAN) {
 		cmd->rx_data_timeout = cpu_to_le32(100 * USEC_PER_MSEC);
 		cmd->tx_data_timeout = cpu_to_le32(100 * USEC_PER_MSEC);
@@ -227,7 +226,8 @@ void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	if (mvmvif->dbgfs_pm.mask & MVM_DEBUGFS_PM_KEEP_ALIVE)
-		cmd->keep_alive_seconds = mvmvif->dbgfs_pm.keep_alive_seconds;
+		cmd->keep_alive_seconds =
+			cpu_to_le16(mvmvif->dbgfs_pm.keep_alive_seconds);
 	if (mvmvif->dbgfs_pm.mask & MVM_DEBUGFS_PM_SKIP_OVER_DTIM) {
 		if (mvmvif->dbgfs_pm.skip_over_dtim)
 			cmd->flags |=
@@ -243,8 +243,7 @@ void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		cmd->tx_data_timeout =
 			cpu_to_le32(mvmvif->dbgfs_pm.tx_data_timeout);
 	if (mvmvif->dbgfs_pm.mask & MVM_DEBUGFS_PM_SKIP_DTIM_PERIODS)
-		cmd->skip_dtim_periods =
-			cpu_to_le32(mvmvif->dbgfs_pm.skip_dtim_periods);
+		cmd->skip_dtim_periods = mvmvif->dbgfs_pm.skip_dtim_periods;
 	if (mvmvif->dbgfs_pm.mask & MVM_DEBUGFS_PM_LPRX_ENA) {
 		if (mvmvif->dbgfs_pm.lprx_ena)
 			cmd->flags |= cpu_to_le16(POWER_FLAGS_LPRX_ENA_MSK);
@@ -252,16 +251,16 @@ void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			cmd->flags &= cpu_to_le16(~POWER_FLAGS_LPRX_ENA_MSK);
 	}
 	if (mvmvif->dbgfs_pm.mask & MVM_DEBUGFS_PM_LPRX_RSSI_THRESHOLD)
-		cmd->lprx_rssi_threshold =
-			cpu_to_le32(mvmvif->dbgfs_pm.lprx_rssi_threshold);
+		cmd->lprx_rssi_threshold = mvmvif->dbgfs_pm.lprx_rssi_threshold;
 #endif /* CONFIG_IWLWIFI_DEBUGFS */
 }
 
-int iwl_mvm_power_update_mode(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
+static int iwl_mvm_power_mac_update_mode(struct iwl_mvm *mvm,
+					 struct ieee80211_vif *vif)
 {
 	int ret;
 	bool ba_enable;
-	struct iwl_powertable_cmd cmd = {};
+	struct iwl_mac_power_cmd cmd = {};
 
 	if (vif->type != NL80211_IFTYPE_STATION || vif->p2p)
 		return 0;
@@ -280,7 +279,7 @@ int iwl_mvm_power_update_mode(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	iwl_mvm_power_build_cmd(mvm, vif, &cmd);
 	iwl_mvm_power_log(mvm, &cmd);
 
-	ret = iwl_mvm_send_cmd_pdu(mvm, POWER_TABLE_CMD, CMD_SYNC,
+	ret = iwl_mvm_send_cmd_pdu(mvm, MAC_PM_POWER_TABLE, CMD_SYNC,
 				   sizeof(cmd), &cmd);
 	if (ret)
 		return ret;
@@ -291,15 +290,19 @@ int iwl_mvm_power_update_mode(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	return iwl_mvm_update_beacon_abort(mvm, vif, ba_enable);
 }
 
-int iwl_mvm_power_disable(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
+static int iwl_mvm_power_mac_disable(struct iwl_mvm *mvm,
+				     struct ieee80211_vif *vif)
 {
-	struct iwl_powertable_cmd cmd = {};
+	struct iwl_mac_power_cmd cmd = {};
 	struct iwl_mvm_vif *mvmvif __maybe_unused =
 		iwl_mvm_vif_from_mac80211(vif);
 
 	if (vif->type != NL80211_IFTYPE_STATION || vif->p2p)
 		return 0;
 
+	cmd.id_and_color = cpu_to_le32(FW_CMD_ID_AND_COLOR(mvmvif->id,
+							   mvmvif->color));
+
 	if (iwlmvm_mod_params.power_scheme != IWL_POWER_SCHEME_CAM)
 		cmd.flags |= cpu_to_le16(POWER_FLAGS_POWER_SAVE_ENA_MSK);
 
@@ -310,11 +313,50 @@ int iwl_mvm_power_disable(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 #endif
 	iwl_mvm_power_log(mvm, &cmd);
 
-	return iwl_mvm_send_cmd_pdu(mvm, POWER_TABLE_CMD, CMD_ASYNC,
+	return iwl_mvm_send_cmd_pdu(mvm, MAC_PM_POWER_TABLE, CMD_ASYNC,
 				    sizeof(cmd), &cmd);
 }
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
+static int iwl_mvm_power_mac_dbgfs_read(struct iwl_mvm *mvm,
+					struct ieee80211_vif *vif, char *buf,
+					int bufsz)
+{
+	struct iwl_mac_power_cmd cmd = {};
+	int pos = 0;
+
+	iwl_mvm_power_build_cmd(mvm, vif, &cmd);
+
+	pos += scnprintf(buf+pos, bufsz-pos, "disable_power_off = %d\n",
+			 (cmd.flags &
+			 cpu_to_le16(POWER_FLAGS_POWER_SAVE_ENA_MSK)) ?
+			 0 : 1);
+	pos += scnprintf(buf+pos, bufsz-pos, "skip_dtim_periods = %d\n",
+			 cmd.skip_dtim_periods);
+	pos += scnprintf(buf+pos, bufsz-pos, "power_scheme = %d\n",
+			 iwlmvm_mod_params.power_scheme);
+	pos += scnprintf(buf+pos, bufsz-pos, "flags = 0x%x\n",
+			 le16_to_cpu(cmd.flags));
+	pos += scnprintf(buf+pos, bufsz-pos, "keep_alive = %d\n",
+			 le16_to_cpu(cmd.keep_alive_seconds));
+
+	if (cmd.flags & cpu_to_le16(POWER_FLAGS_POWER_MANAGEMENT_ENA_MSK)) {
+		pos += scnprintf(buf+pos, bufsz-pos, "skip_over_dtim = %d\n",
+				 (cmd.flags &
+				 cpu_to_le16(POWER_FLAGS_SKIP_OVER_DTIM_MSK)) ?
+				 1 : 0);
+		pos += scnprintf(buf+pos, bufsz-pos, "rx_data_timeout = %d\n",
+				 le32_to_cpu(cmd.rx_data_timeout));
+		pos += scnprintf(buf+pos, bufsz-pos, "tx_data_timeout = %d\n",
+				 le32_to_cpu(cmd.tx_data_timeout));
+		if (cmd.flags & cpu_to_le16(POWER_FLAGS_LPRX_ENA_MSK))
+			pos += scnprintf(buf+pos, bufsz-pos,
+					 "lprx_rssi_threshold = %d\n",
+					 cmd.lprx_rssi_threshold);
+	}
+	return pos;
+}
+
 void
 iwl_mvm_beacon_filter_debugfs_parameters(struct ieee80211_vif *vif,
 					 struct iwl_beacon_filter_cmd *cmd)
@@ -382,3 +424,11 @@ int iwl_mvm_disable_beacon_filter(struct iwl_mvm *mvm,
 
 	return ret;
 }
+
+const struct iwl_mvm_power_ops pm_mac_ops = {
+	.power_update_mode = iwl_mvm_power_mac_update_mode,
+	.power_disable = iwl_mvm_power_mac_disable,
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	.power_dbgfs_read = iwl_mvm_power_mac_dbgfs_read,
+#endif
+};
diff --git a/drivers/net/wireless/iwlwifi/mvm/power_legacy.c b/drivers/net/wireless/iwlwifi/mvm/power_legacy.c
new file mode 100644
index 0000000..2ce79ba
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/mvm/power_legacy.c
@@ -0,0 +1,319 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called COPYING.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *****************************************************************************/
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+
+#include <net/mac80211.h>
+
+#include "iwl-debug.h"
+#include "mvm.h"
+#include "iwl-modparams.h"
+#include "fw-api-power.h"
+
+#define POWER_KEEP_ALIVE_PERIOD_SEC    25
+
+static void iwl_mvm_power_log(struct iwl_mvm *mvm,
+			      struct iwl_powertable_cmd *cmd)
+{
+	IWL_DEBUG_POWER(mvm,
+			"Sending power table command for power level %d, flags = 0x%X\n",
+			iwlmvm_mod_params.power_scheme,
+			le16_to_cpu(cmd->flags));
+	IWL_DEBUG_POWER(mvm, "Keep alive = %u sec\n", cmd->keep_alive_seconds);
+
+	if (cmd->flags & cpu_to_le16(POWER_FLAGS_POWER_MANAGEMENT_ENA_MSK)) {
+		IWL_DEBUG_POWER(mvm, "Rx timeout = %u usec\n",
+				le32_to_cpu(cmd->rx_data_timeout));
+		IWL_DEBUG_POWER(mvm, "Tx timeout = %u usec\n",
+				le32_to_cpu(cmd->tx_data_timeout));
+		if (cmd->flags & cpu_to_le16(POWER_FLAGS_SKIP_OVER_DTIM_MSK))
+			IWL_DEBUG_POWER(mvm, "DTIM periods to skip = %u\n",
+					le32_to_cpu(cmd->skip_dtim_periods));
+		if (cmd->flags & cpu_to_le16(POWER_FLAGS_LPRX_ENA_MSK))
+			IWL_DEBUG_POWER(mvm, "LP RX RSSI threshold = %u\n",
+					le32_to_cpu(cmd->lprx_rssi_threshold));
+	}
+}
+
+static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
+				    struct ieee80211_vif *vif,
+				    struct iwl_powertable_cmd *cmd)
+{
+	struct ieee80211_hw *hw = mvm->hw;
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	struct ieee80211_channel *chan;
+	int dtimper, dtimper_msec;
+	int keep_alive;
+	bool radar_detect = false;
+	struct iwl_mvm_vif *mvmvif __maybe_unused =
+		iwl_mvm_vif_from_mac80211(vif);
+
+	/*
+	 * Regardless of power management state the driver must set
+	 * keep alive period. FW will use it for sending keep alive NDPs
+	 * immediately after association.
+	 */
+	cmd->keep_alive_seconds = POWER_KEEP_ALIVE_PERIOD_SEC;
+
+	if (iwlmvm_mod_params.power_scheme == IWL_POWER_SCHEME_CAM)
+		return;
+
+	cmd->flags |= cpu_to_le16(POWER_FLAGS_POWER_SAVE_ENA_MSK);
+	if (!vif->bss_conf.assoc)
+		cmd->flags |= cpu_to_le16(POWER_FLAGS_POWER_MANAGEMENT_ENA_MSK);
+
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	if (mvmvif->dbgfs_pm.mask & MVM_DEBUGFS_PM_DISABLE_POWER_OFF &&
+	    mvmvif->dbgfs_pm.disable_power_off)
+		cmd->flags &= cpu_to_le16(~POWER_FLAGS_POWER_SAVE_ENA_MSK);
+#endif
+	if (!vif->bss_conf.ps)
+		return;
+
+	cmd->flags |= cpu_to_le16(POWER_FLAGS_POWER_MANAGEMENT_ENA_MSK);
+
+	if (vif->bss_conf.beacon_rate &&
+	    (vif->bss_conf.beacon_rate->bitrate == 10 ||
+	     vif->bss_conf.beacon_rate->bitrate == 60)) {
+		cmd->flags |= cpu_to_le16(POWER_FLAGS_LPRX_ENA_MSK);
+		cmd->lprx_rssi_threshold =
+			cpu_to_le32(POWER_LPRX_RSSI_THRESHOLD);
+	}
+
+	dtimper = hw->conf.ps_dtim_period ?: 1;
+
+	/* Check if radar detection is required on current channel */
+	rcu_read_lock();
+	chanctx_conf = rcu_dereference(vif->chanctx_conf);
+	WARN_ON(!chanctx_conf);
+	if (chanctx_conf) {
+		chan = chanctx_conf->def.chan;
+		radar_detect = chan->flags & IEEE80211_CHAN_RADAR;
+	}
+	rcu_read_unlock();
+
+	/* Check skip over DTIM conditions */
+	if (!radar_detect && (dtimper <= 10) &&
+	    (iwlmvm_mod_params.power_scheme == IWL_POWER_SCHEME_LP ||
+	     mvm->cur_ucode == IWL_UCODE_WOWLAN)) {
+		cmd->flags |= cpu_to_le16(POWER_FLAGS_SKIP_OVER_DTIM_MSK);
+		cmd->skip_dtim_periods = cpu_to_le32(3);
+	}
+
+	/* Check that keep alive period is at least 3 * DTIM */
+	dtimper_msec = dtimper * vif->bss_conf.beacon_int;
+	keep_alive = max_t(int, 3 * dtimper_msec,
+			   MSEC_PER_SEC * cmd->keep_alive_seconds);
+	keep_alive = DIV_ROUND_UP(keep_alive, MSEC_PER_SEC);
+	cmd->keep_alive_seconds = keep_alive;
+
+	if (mvm->cur_ucode != IWL_UCODE_WOWLAN) {
+		cmd->rx_data_timeout = cpu_to_le32(100 * USEC_PER_MSEC);
+		cmd->tx_data_timeout = cpu_to_le32(100 * USEC_PER_MSEC);
+	} else {
+		cmd->rx_data_timeout = cpu_to_le32(10 * USEC_PER_MSEC);
+		cmd->tx_data_timeout = cpu_to_le32(10 * USEC_PER_MSEC);
+	}
+
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	if (mvmvif->dbgfs_pm.mask & MVM_DEBUGFS_PM_KEEP_ALIVE)
+		cmd->keep_alive_seconds = mvmvif->dbgfs_pm.keep_alive_seconds;
+	if (mvmvif->dbgfs_pm.mask & MVM_DEBUGFS_PM_SKIP_OVER_DTIM) {
+		if (mvmvif->dbgfs_pm.skip_over_dtim)
+			cmd->flags |=
+				cpu_to_le16(POWER_FLAGS_SKIP_OVER_DTIM_MSK);
+		else
+			cmd->flags &=
+				cpu_to_le16(~POWER_FLAGS_SKIP_OVER_DTIM_MSK);
+	}
+	if (mvmvif->dbgfs_pm.mask & MVM_DEBUGFS_PM_RX_DATA_TIMEOUT)
+		cmd->rx_data_timeout =
+			cpu_to_le32(mvmvif->dbgfs_pm.rx_data_timeout);
+	if (mvmvif->dbgfs_pm.mask & MVM_DEBUGFS_PM_TX_DATA_TIMEOUT)
+		cmd->tx_data_timeout =
+			cpu_to_le32(mvmvif->dbgfs_pm.tx_data_timeout);
+	if (mvmvif->dbgfs_pm.mask & MVM_DEBUGFS_PM_SKIP_DTIM_PERIODS)
+		cmd->skip_dtim_periods =
+			cpu_to_le32(mvmvif->dbgfs_pm.skip_dtim_periods);
+	if (mvmvif->dbgfs_pm.mask & MVM_DEBUGFS_PM_LPRX_ENA) {
+		if (mvmvif->dbgfs_pm.lprx_ena)
+			cmd->flags |= cpu_to_le16(POWER_FLAGS_LPRX_ENA_MSK);
+		else
+			cmd->flags &= cpu_to_le16(~POWER_FLAGS_LPRX_ENA_MSK);
+	}
+	if (mvmvif->dbgfs_pm.mask & MVM_DEBUGFS_PM_LPRX_RSSI_THRESHOLD)
+		cmd->lprx_rssi_threshold =
+			cpu_to_le32(mvmvif->dbgfs_pm.lprx_rssi_threshold);
+#endif /* CONFIG_IWLWIFI_DEBUGFS */
+}
+
+static int iwl_mvm_power_legacy_update_mode(struct iwl_mvm *mvm,
+					    struct ieee80211_vif *vif)
+{
+	int ret;
+	bool ba_enable;
+	struct iwl_powertable_cmd cmd = {};
+
+	if (vif->type != NL80211_IFTYPE_STATION || vif->p2p)
+		return 0;
+
+	/*
+	 * TODO: The following vif_count verification is temporary condition.
+	 * Avoid power mode update if more than one interface is currently
+	 * active. Remove this condition when FW will support power management
+	 * on multiple MACs.
+	 */
+	IWL_DEBUG_POWER(mvm, "Currently %d interfaces active\n",
+			mvm->vif_count);
+	if (mvm->vif_count > 1)
+		return 0;
+
+	iwl_mvm_power_build_cmd(mvm, vif, &cmd);
+	iwl_mvm_power_log(mvm, &cmd);
+
+	ret = iwl_mvm_send_cmd_pdu(mvm, POWER_TABLE_CMD, CMD_SYNC,
+				   sizeof(cmd), &cmd);
+	if (ret)
+		return ret;
+
+	ba_enable = !!(cmd.flags &
+		       cpu_to_le16(POWER_FLAGS_POWER_MANAGEMENT_ENA_MSK));
+
+	return iwl_mvm_update_beacon_abort(mvm, vif, ba_enable);
+}
+
+static int iwl_mvm_power_legacy_disable(struct iwl_mvm *mvm,
+					struct ieee80211_vif *vif)
+{
+	struct iwl_powertable_cmd cmd = {};
+	struct iwl_mvm_vif *mvmvif __maybe_unused =
+		iwl_mvm_vif_from_mac80211(vif);
+
+	if (vif->type != NL80211_IFTYPE_STATION || vif->p2p)
+		return 0;
+
+	if (iwlmvm_mod_params.power_scheme != IWL_POWER_SCHEME_CAM)
+		cmd.flags |= cpu_to_le16(POWER_FLAGS_POWER_SAVE_ENA_MSK);
+
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	if (mvmvif->dbgfs_pm.mask & MVM_DEBUGFS_PM_DISABLE_POWER_OFF &&
+	    mvmvif->dbgfs_pm.disable_power_off)
+		cmd.flags &= cpu_to_le16(~POWER_FLAGS_POWER_SAVE_ENA_MSK);
+#endif
+	iwl_mvm_power_log(mvm, &cmd);
+
+	return iwl_mvm_send_cmd_pdu(mvm, POWER_TABLE_CMD, CMD_ASYNC,
+				    sizeof(cmd), &cmd);
+}
+
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+static int iwl_mvm_power_legacy_dbgfs_read(struct iwl_mvm *mvm,
+					   struct ieee80211_vif *vif, char *buf,
+					   int bufsz)
+{
+	struct iwl_powertable_cmd cmd = {};
+	int pos = 0;
+
+	iwl_mvm_power_build_cmd(mvm, vif, &cmd);
+
+	pos += scnprintf(buf+pos, bufsz-pos, "disable_power_off = %d\n",
+			 (cmd.flags &
+			 cpu_to_le16(POWER_FLAGS_POWER_SAVE_ENA_MSK)) ?
+			 0 : 1);
+	pos += scnprintf(buf+pos, bufsz-pos, "skip_dtim_periods = %d\n",
+			 le32_to_cpu(cmd.skip_dtim_periods));
+	pos += scnprintf(buf+pos, bufsz-pos, "power_scheme = %d\n",
+			 iwlmvm_mod_params.power_scheme);
+	pos += scnprintf(buf+pos, bufsz-pos, "flags = 0x%x\n",
+			 le16_to_cpu(cmd.flags));
+	pos += scnprintf(buf+pos, bufsz-pos, "keep_alive = %d\n",
+			 cmd.keep_alive_seconds);
+
+	if (cmd.flags & cpu_to_le16(POWER_FLAGS_POWER_MANAGEMENT_ENA_MSK)) {
+		pos += scnprintf(buf+pos, bufsz-pos, "skip_over_dtim = %d\n",
+				 (cmd.flags &
+				 cpu_to_le16(POWER_FLAGS_SKIP_OVER_DTIM_MSK)) ?
+				 1 : 0);
+		pos += scnprintf(buf+pos, bufsz-pos, "rx_data_timeout = %d\n",
+				 le32_to_cpu(cmd.rx_data_timeout));
+		pos += scnprintf(buf+pos, bufsz-pos, "tx_data_timeout = %d\n",
+				 le32_to_cpu(cmd.tx_data_timeout));
+		if (cmd.flags & cpu_to_le16(POWER_FLAGS_LPRX_ENA_MSK))
+			pos += scnprintf(buf+pos, bufsz-pos,
+					 "lprx_rssi_threshold = %d\n",
+					 le32_to_cpu(cmd.lprx_rssi_threshold));
+	}
+	return pos;
+}
+#endif
+
+const struct iwl_mvm_power_ops pm_legacy_ops = {
+	.power_update_mode = iwl_mvm_power_legacy_update_mode,
+	.power_disable = iwl_mvm_power_legacy_disable,
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	.power_dbgfs_read = iwl_mvm_power_legacy_dbgfs_read,
+#endif
+};
-- 
1.8.0

