Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:54459 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab3LQUo4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:44:56 -0500
Received: by mail-ee0-f52.google.com with SMTP id d17so3099209eek.25
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 12:44:55 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/36] iwlwifi: mvm: Add uAPSD misbehaving AP notification handling
Date: Tue, 17 Dec 2013 22:44:10 +0200
Message-Id: <1387313079-28123-7-git-send-email-egrumbach@gmail.com> (sfid-20131217_214640_547524_D0C04FED)
In-Reply-To: <52B0B72A.5070704@gmail.com>
References: <52B0B72A.5070704@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

FW implements protective algorithm to identify AP's improper uAPSD
behavior. FW sends misbehaving AP notification in this case.
Add this notification handling. Avoid using uAPSD in next association
to the exactly same AP. Refactor iwl_mvm_power_build_cmd() to move
uAPSD related code to a separate function.

Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h |   16 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api.h       |    1 +
 drivers/net/wireless/iwlwifi/mvm/mac80211.c     |    1 +
 drivers/net/wireless/iwlwifi/mvm/mvm.h          |   10 +
 drivers/net/wireless/iwlwifi/mvm/ops.c          |    3 +
 drivers/net/wireless/iwlwifi/mvm/power.c        |  318 +++++++++++++----------
 6 files changed, 209 insertions(+), 140 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
index 5cb93ae..cb78e55 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
@@ -85,6 +85,8 @@
  *		PBW Snoozing enabled
  * @POWER_FLAGS_ADVANCE_PM_ENA_MSK: Advanced PM (uAPSD) enable mask
  * @POWER_FLAGS_LPRX_ENA_MSK: Low Power RX enable.
+ * @POWER_FLAGS_AP_UAPSD_MISBEHAVING_ENA_MSK: AP/GO's uAPSD misbehaving
+ *		detection enablement
 */
 enum iwl_power_flags {
 	POWER_FLAGS_POWER_SAVE_ENA_MSK		= BIT(0),
@@ -94,6 +96,7 @@ enum iwl_power_flags {
 	POWER_FLAGS_BT_SCO_ENA			= BIT(8),
 	POWER_FLAGS_ADVANCE_PM_ENA_MSK		= BIT(9),
 	POWER_FLAGS_LPRX_ENA_MSK		= BIT(11),
+	POWER_FLAGS_UAPSD_MISBEHAVING_ENA_MSK	= BIT(12),
 };
 
 #define IWL_POWER_VEC_SIZE 5
@@ -228,6 +231,19 @@ struct iwl_mac_power_cmd {
 	u8 reserved;
 } __packed;
 
+/*
+ * struct iwl_uapsd_misbehaving_ap_notif - FW sends this notification when
+ * associated AP is identified as improperly implementing uAPSD protocol.
+ * PSM_UAPSD_AP_MISBEHAVING_NOTIFICATION = 0x78
+ * @sta_id: index of station in uCode's station table - associated AP ID in
+ *	    this context.
+ */
+struct iwl_uapsd_misbehaving_ap_notif {
+	__le32 sta_id;
+	u8 mac_id;
+	u8 reserved[3];
+} __packed;
+
 /**
  * struct iwl_beacon_filter_cmd
  * REPLY_BEACON_FILTERING_CMD = 0xd2 (command)
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index c9cfaad..d0b9399 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -141,6 +141,7 @@ enum {
 
 	/* Power - legacy power table command */
 	POWER_TABLE_CMD = 0x77,
+	PSM_UAPSD_AP_MISBEHAVING_NOTIFICATION = 0x78,
 
 	/* Thermal Throttling*/
 	REPLY_THERMAL_MNG_BACKOFF = 0x7e,
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 8a99ecc..8d80728 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -858,6 +858,7 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 			}
 
 			iwl_mvm_sf_update(mvm, vif, false);
+			iwl_mvm_power_vif_assoc(mvm, vif);
 		} else if (mvmvif->ap_sta_id != IWL_MVM_STATION_COUNT) {
 			/*
 			 * If update fails - SF might be running in associated
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index bd072c7..5da5e2d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -181,6 +181,7 @@ enum iwl_dbgfs_pm_mask {
 	MVM_DEBUGFS_PM_LPRX_ENA = BIT(6),
 	MVM_DEBUGFS_PM_LPRX_RSSI_THRESHOLD = BIT(7),
 	MVM_DEBUGFS_PM_SNOOZE_ENABLE = BIT(8),
+	MVM_DEBUGFS_PM_UAPSD_MISBEHAVING = BIT(9),
 };
 
 struct iwl_dbgfs_pm {
@@ -193,6 +194,7 @@ struct iwl_dbgfs_pm {
 	bool lprx_ena;
 	u32 lprx_rssi_threshold;
 	bool snooze_ena;
+	bool uapsd_misbehaving;
 	int mask;
 };
 
@@ -331,6 +333,9 @@ struct iwl_mvm_vif {
 #endif
 
 	enum ieee80211_smps_mode smps_requests[NUM_IWL_MVM_SMPS_REQ];
+
+	/* FW identified misbehaving AP */
+	u8 uapsd_misbehaving_bssid[ETH_ALEN];
 };
 
 static inline struct iwl_mvm_vif *
@@ -781,6 +786,11 @@ static inline int iwl_mvm_power_update_device_mode(struct iwl_mvm *mvm)
 	return 0;
 }
 
+void iwl_mvm_power_vif_assoc(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
+int iwl_mvm_power_uapsd_misbehaving_ap_notif(struct iwl_mvm *mvm,
+					     struct iwl_rx_cmd_buffer *rxb,
+					     struct iwl_device_cmd *cmd);
+
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 static inline int iwl_mvm_power_dbgfs_read(struct iwl_mvm *mvm,
 					    struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index cae6123..2e9af9f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -236,6 +236,8 @@ static const struct iwl_rx_handlers iwl_mvm_rx_handlers[] = {
 		   false),
 
 	RX_HANDLER(REPLY_ERROR, iwl_mvm_rx_fw_error, false),
+	RX_HANDLER(PSM_UAPSD_AP_MISBEHAVING_NOTIFICATION,
+		   iwl_mvm_power_uapsd_misbehaving_ap_notif, false),
 };
 #undef RX_HANDLER
 #define CMD(x) [x] = #x
@@ -311,6 +313,7 @@ static const char *iwl_mvm_cmd_strings[REPLY_MAX] = {
 	CMD(REPLY_THERMAL_MNG_BACKOFF),
 	CMD(MAC_PM_POWER_TABLE),
 	CMD(BT_COEX_CI),
+	CMD(PSM_UAPSD_AP_MISBEHAVING_NOTIFICATION),
 };
 #undef CMD
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index 550824a..1817b2a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -186,6 +186,92 @@ static void iwl_mvm_power_log(struct iwl_mvm *mvm,
 	}
 }
 
+static void iwl_mvm_power_configure_uapsd(struct iwl_mvm *mvm,
+					  struct ieee80211_vif *vif,
+					  struct iwl_mac_power_cmd *cmd)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	enum ieee80211_ac_numbers ac;
+	bool tid_found = false;
+
+	for (ac = IEEE80211_AC_VO; ac <= IEEE80211_AC_BK; ac++) {
+		if (!mvmvif->queue_params[ac].uapsd)
+			continue;
+
+		if (mvm->cur_ucode != IWL_UCODE_WOWLAN)
+			cmd->flags |=
+				cpu_to_le16(POWER_FLAGS_ADVANCE_PM_ENA_MSK);
+
+		cmd->uapsd_ac_flags |= BIT(ac);
+
+		/* QNDP TID - the highest TID with no admission control */
+		if (!tid_found && !mvmvif->queue_params[ac].acm) {
+			tid_found = true;
+			switch (ac) {
+			case IEEE80211_AC_VO:
+				cmd->qndp_tid = 6;
+				break;
+			case IEEE80211_AC_VI:
+				cmd->qndp_tid = 5;
+				break;
+			case IEEE80211_AC_BE:
+				cmd->qndp_tid = 0;
+				break;
+			case IEEE80211_AC_BK:
+				cmd->qndp_tid = 1;
+				break;
+			}
+		}
+	}
+
+	if (!(cmd->flags & cpu_to_le16(POWER_FLAGS_ADVANCE_PM_ENA_MSK)))
+		return;
+
+	cmd->flags |= cpu_to_le16(POWER_FLAGS_UAPSD_MISBEHAVING_ENA_MSK);
+
+	if (cmd->uapsd_ac_flags == (BIT(IEEE80211_AC_VO) |
+				    BIT(IEEE80211_AC_VI) |
+				    BIT(IEEE80211_AC_BE) |
+				    BIT(IEEE80211_AC_BK))) {
+		cmd->flags |= cpu_to_le16(POWER_FLAGS_SNOOZE_ENA_MSK);
+		cmd->snooze_interval = cpu_to_le16(IWL_MVM_PS_SNOOZE_INTERVAL);
+		cmd->snooze_window = (mvm->cur_ucode == IWL_UCODE_WOWLAN) ?
+			cpu_to_le16(IWL_MVM_WOWLAN_PS_SNOOZE_WINDOW) :
+			cpu_to_le16(IWL_MVM_PS_SNOOZE_WINDOW);
+	}
+
+	cmd->uapsd_max_sp = IWL_UAPSD_MAX_SP;
+
+	if (mvm->cur_ucode == IWL_UCODE_WOWLAN || cmd->flags &
+	    cpu_to_le16(POWER_FLAGS_SNOOZE_ENA_MSK)) {
+		cmd->rx_data_timeout_uapsd =
+			cpu_to_le32(IWL_MVM_WOWLAN_PS_RX_DATA_TIMEOUT);
+		cmd->tx_data_timeout_uapsd =
+			cpu_to_le32(IWL_MVM_WOWLAN_PS_TX_DATA_TIMEOUT);
+	} else {
+		cmd->rx_data_timeout_uapsd =
+			cpu_to_le32(IWL_MVM_UAPSD_RX_DATA_TIMEOUT);
+		cmd->tx_data_timeout_uapsd =
+			cpu_to_le32(IWL_MVM_UAPSD_TX_DATA_TIMEOUT);
+	}
+
+	if (cmd->flags & cpu_to_le16(POWER_FLAGS_SNOOZE_ENA_MSK)) {
+		cmd->heavy_tx_thld_packets =
+			IWL_MVM_PS_SNOOZE_HEAVY_TX_THLD_PACKETS;
+		cmd->heavy_rx_thld_packets =
+			IWL_MVM_PS_SNOOZE_HEAVY_RX_THLD_PACKETS;
+	} else {
+		cmd->heavy_tx_thld_packets =
+			IWL_MVM_PS_HEAVY_TX_THLD_PACKETS;
+		cmd->heavy_rx_thld_packets =
+			IWL_MVM_PS_HEAVY_RX_THLD_PACKETS;
+	}
+	cmd->heavy_tx_thld_percentage =
+		IWL_MVM_PS_HEAVY_TX_THLD_PERCENT;
+	cmd->heavy_rx_thld_percentage =
+		IWL_MVM_PS_HEAVY_RX_THLD_PERCENT;
+}
+
 static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 				    struct ieee80211_vif *vif,
 				    struct iwl_mac_power_cmd *cmd)
@@ -198,8 +284,6 @@ static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 	bool radar_detect = false;
 	struct iwl_mvm_vif *mvmvif __maybe_unused =
 		iwl_mvm_vif_from_mac80211(vif);
-	enum ieee80211_ac_numbers ac;
-	bool tid_found = false;
 
 	cmd->id_and_color = cpu_to_le32(FW_CMD_ID_AND_COLOR(mvmvif->id,
 							    mvmvif->color));
@@ -269,81 +353,9 @@ static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 			cpu_to_le32(IWL_MVM_WOWLAN_PS_TX_DATA_TIMEOUT);
 	}
 
-	for (ac = IEEE80211_AC_VO; ac <= IEEE80211_AC_BK; ac++) {
-		if (!mvmvif->queue_params[ac].uapsd)
-			continue;
-
-		if (mvm->cur_ucode != IWL_UCODE_WOWLAN)
-			cmd->flags |=
-				cpu_to_le16(POWER_FLAGS_ADVANCE_PM_ENA_MSK);
-
-		cmd->uapsd_ac_flags |= BIT(ac);
-
-		/* QNDP TID - the highest TID with no admission control */
-		if (!tid_found && !mvmvif->queue_params[ac].acm) {
-			tid_found = true;
-			switch (ac) {
-			case IEEE80211_AC_VO:
-				cmd->qndp_tid = 6;
-				break;
-			case IEEE80211_AC_VI:
-				cmd->qndp_tid = 5;
-				break;
-			case IEEE80211_AC_BE:
-				cmd->qndp_tid = 0;
-				break;
-			case IEEE80211_AC_BK:
-				cmd->qndp_tid = 1;
-				break;
-			}
-		}
-	}
-
-	if (cmd->flags & cpu_to_le16(POWER_FLAGS_ADVANCE_PM_ENA_MSK)) {
-		if (cmd->uapsd_ac_flags == (BIT(IEEE80211_AC_VO) |
-					    BIT(IEEE80211_AC_VI) |
-					    BIT(IEEE80211_AC_BE) |
-					    BIT(IEEE80211_AC_BK))) {
-			cmd->flags |= cpu_to_le16(POWER_FLAGS_SNOOZE_ENA_MSK);
-			cmd->snooze_interval =
-				cpu_to_le16(IWL_MVM_PS_SNOOZE_INTERVAL);
-			cmd->snooze_window =
-				(mvm->cur_ucode == IWL_UCODE_WOWLAN) ?
-				cpu_to_le16(IWL_MVM_WOWLAN_PS_SNOOZE_WINDOW) :
-				cpu_to_le16(IWL_MVM_PS_SNOOZE_WINDOW);
-		}
-
-		cmd->uapsd_max_sp = IWL_UAPSD_MAX_SP;
-
-		if (mvm->cur_ucode == IWL_UCODE_WOWLAN || cmd->flags &
-		    cpu_to_le16(POWER_FLAGS_SNOOZE_ENA_MSK)) {
-			cmd->rx_data_timeout_uapsd =
-				cpu_to_le32(IWL_MVM_WOWLAN_PS_RX_DATA_TIMEOUT);
-			cmd->tx_data_timeout_uapsd =
-				cpu_to_le32(IWL_MVM_WOWLAN_PS_TX_DATA_TIMEOUT);
-		} else {
-			cmd->rx_data_timeout_uapsd =
-				cpu_to_le32(IWL_MVM_UAPSD_RX_DATA_TIMEOUT);
-			cmd->tx_data_timeout_uapsd =
-				cpu_to_le32(IWL_MVM_UAPSD_TX_DATA_TIMEOUT);
-		}
-
-		if (cmd->flags & cpu_to_le16(POWER_FLAGS_SNOOZE_ENA_MSK)) {
-			cmd->heavy_tx_thld_packets =
-				IWL_MVM_PS_SNOOZE_HEAVY_TX_THLD_PACKETS;
-			cmd->heavy_rx_thld_packets =
-				IWL_MVM_PS_SNOOZE_HEAVY_RX_THLD_PACKETS;
-		} else {
-			cmd->heavy_tx_thld_packets =
-				IWL_MVM_PS_HEAVY_TX_THLD_PACKETS;
-			cmd->heavy_rx_thld_packets =
-				IWL_MVM_PS_HEAVY_RX_THLD_PACKETS;
-		}
-		cmd->heavy_tx_thld_percentage =
-			IWL_MVM_PS_HEAVY_TX_THLD_PERCENT;
-		cmd->heavy_rx_thld_percentage =
-			IWL_MVM_PS_HEAVY_RX_THLD_PERCENT;
-	}
+	if (memcmp(mvmvif->uapsd_misbehaving_bssid, vif->bss_conf.bssid,
+		   ETH_ALEN))
+		iwl_mvm_power_configure_uapsd(mvm, vif, cmd);
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	if (mvmvif->dbgfs_pm.mask & MVM_DEBUGFS_PM_KEEP_ALIVE)
@@ -472,6 +484,44 @@ static int iwl_mvm_power_update_device(struct iwl_mvm *mvm)
 				    &cmd);
 }
 
+void iwl_mvm_power_vif_assoc(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+
+	if (memcmp(vif->bss_conf.bssid, mvmvif->uapsd_misbehaving_bssid,
+		   ETH_ALEN))
+		memset(mvmvif->uapsd_misbehaving_bssid, 0, ETH_ALEN);
+}
+
+static void iwl_mvm_power_uapsd_misbehav_ap_iterator(void *_data, u8 *mac,
+						     struct ieee80211_vif *vif)
+{
+	u8 *ap_sta_id = _data;
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+
+	/* The ap_sta_id is not expected to change during current association
+	 * so no explicit protection is needed
+	 */
+	if (mvmvif->ap_sta_id == *ap_sta_id)
+		memcpy(mvmvif->uapsd_misbehaving_bssid, vif->bss_conf.bssid,
+		       ETH_ALEN);
+}
+
+int iwl_mvm_power_uapsd_misbehaving_ap_notif(struct iwl_mvm *mvm,
+					     struct iwl_rx_cmd_buffer *rxb,
+					     struct iwl_device_cmd *cmd)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_uapsd_misbehaving_ap_notif *notif = (void *)pkt->data;
+	u8 ap_sta_id = le32_to_cpu(notif->sta_id);
+
+	ieee80211_iterate_active_interfaces_atomic(
+		mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
+		iwl_mvm_power_uapsd_misbehav_ap_iterator, &ap_sta_id);
+
+	return 0;
+}
+
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 static int iwl_mvm_power_mac_dbgfs_read(struct iwl_mvm *mvm,
 					struct ieee80211_vif *vif, char *buf,
@@ -494,70 +544,58 @@ static int iwl_mvm_power_mac_dbgfs_read(struct iwl_mvm *mvm,
 	pos += scnprintf(buf+pos, bufsz-pos, "keep_alive = %d\n",
 			 le16_to_cpu(cmd.keep_alive_seconds));
 
-	if (cmd.flags & cpu_to_le16(POWER_FLAGS_POWER_MANAGEMENT_ENA_MSK)) {
-		pos += scnprintf(buf+pos, bufsz-pos, "skip_over_dtim = %d\n",
-				 (cmd.flags &
-				 cpu_to_le16(POWER_FLAGS_SKIP_OVER_DTIM_MSK)) ?
-				 1 : 0);
-		pos += scnprintf(buf+pos, bufsz-pos, "skip_dtim_periods = %d\n",
-				 cmd.skip_dtim_periods);
-		if (!(cmd.flags &
-		      cpu_to_le16(POWER_FLAGS_ADVANCE_PM_ENA_MSK))) {
-			pos += scnprintf(buf+pos, bufsz-pos,
-					 "rx_data_timeout = %d\n",
-					 le32_to_cpu(cmd.rx_data_timeout));
-			pos += scnprintf(buf+pos, bufsz-pos,
-					 "tx_data_timeout = %d\n",
-					 le32_to_cpu(cmd.tx_data_timeout));
-		}
-		if (cmd.flags & cpu_to_le16(POWER_FLAGS_LPRX_ENA_MSK))
-			pos += scnprintf(buf+pos, bufsz-pos,
-					 "lprx_rssi_threshold = %d\n",
-					 cmd.lprx_rssi_threshold);
-		if (cmd.flags & cpu_to_le16(POWER_FLAGS_ADVANCE_PM_ENA_MSK)) {
-			pos +=
-			scnprintf(buf+pos, bufsz-pos,
-				  "rx_data_timeout_uapsd = %d\n",
-				  le32_to_cpu(cmd.rx_data_timeout_uapsd));
-			pos +=
-			scnprintf(buf+pos, bufsz-pos,
-				  "tx_data_timeout_uapsd = %d\n",
-				  le32_to_cpu(cmd.tx_data_timeout_uapsd));
-			pos += scnprintf(buf+pos, bufsz-pos, "qndp_tid = %d\n",
-					 cmd.qndp_tid);
-			pos += scnprintf(buf+pos, bufsz-pos,
-					 "uapsd_ac_flags = 0x%x\n",
-					 cmd.uapsd_ac_flags);
-			pos += scnprintf(buf+pos, bufsz-pos,
-					 "uapsd_max_sp = %d\n",
-					 cmd.uapsd_max_sp);
-			pos += scnprintf(buf+pos, bufsz-pos,
-					 "heavy_tx_thld_packets = %d\n",
-					 cmd.heavy_tx_thld_packets);
-			pos += scnprintf(buf+pos, bufsz-pos,
-					 "heavy_rx_thld_packets = %d\n",
-					 cmd.heavy_rx_thld_packets);
-			pos += scnprintf(buf+pos, bufsz-pos,
-					 "heavy_tx_thld_percentage = %d\n",
-					 cmd.heavy_tx_thld_percentage);
-			pos += scnprintf(buf+pos, bufsz-pos,
-					 "heavy_rx_thld_percentage = %d\n",
-					 cmd.heavy_rx_thld_percentage);
-			pos +=
-			scnprintf(buf+pos, bufsz-pos, "snooze_enable = %d\n",
-				  (cmd.flags &
-				   cpu_to_le16(POWER_FLAGS_SNOOZE_ENA_MSK)) ?
-				  1 : 0);
-		}
-		if (cmd.flags & cpu_to_le16(POWER_FLAGS_SNOOZE_ENA_MSK)) {
-			pos += scnprintf(buf+pos, bufsz-pos,
-					 "snooze_interval = %d\n",
-					 cmd.snooze_interval);
-			pos += scnprintf(buf+pos, bufsz-pos,
-					 "snooze_window = %d\n",
-					 cmd.snooze_window);
-		}
+	if (!(cmd.flags & cpu_to_le16(POWER_FLAGS_POWER_MANAGEMENT_ENA_MSK)))
+		return pos;
+
+	pos += scnprintf(buf+pos, bufsz-pos, "skip_over_dtim = %d\n",
+			 (cmd.flags &
+			 cpu_to_le16(POWER_FLAGS_SKIP_OVER_DTIM_MSK)) ? 1 : 0);
+	pos += scnprintf(buf+pos, bufsz-pos, "skip_dtim_periods = %d\n",
+			 cmd.skip_dtim_periods);
+	if (!(cmd.flags & cpu_to_le16(POWER_FLAGS_ADVANCE_PM_ENA_MSK))) {
+		pos += scnprintf(buf+pos, bufsz-pos, "rx_data_timeout = %d\n",
+				 le32_to_cpu(cmd.rx_data_timeout));
+		pos += scnprintf(buf+pos, bufsz-pos, "tx_data_timeout = %d\n",
+				 le32_to_cpu(cmd.tx_data_timeout));
 	}
+	if (cmd.flags & cpu_to_le16(POWER_FLAGS_LPRX_ENA_MSK))
+		pos += scnprintf(buf+pos, bufsz-pos,
+				 "lprx_rssi_threshold = %d\n",
+				 cmd.lprx_rssi_threshold);
+
+	if (!(cmd.flags & cpu_to_le16(POWER_FLAGS_ADVANCE_PM_ENA_MSK)))
+		return pos;
+
+	pos += scnprintf(buf+pos, bufsz-pos, "rx_data_timeout_uapsd = %d\n",
+			 le32_to_cpu(cmd.rx_data_timeout_uapsd));
+	pos += scnprintf(buf+pos, bufsz-pos, "tx_data_timeout_uapsd = %d\n",
+			 le32_to_cpu(cmd.tx_data_timeout_uapsd));
+	pos += scnprintf(buf+pos, bufsz-pos, "qndp_tid = %d\n", cmd.qndp_tid);
+	pos += scnprintf(buf+pos, bufsz-pos, "uapsd_ac_flags = 0x%x\n",
+			 cmd.uapsd_ac_flags);
+	pos += scnprintf(buf+pos, bufsz-pos, "uapsd_max_sp = %d\n",
+			 cmd.uapsd_max_sp);
+	pos += scnprintf(buf+pos, bufsz-pos, "heavy_tx_thld_packets = %d\n",
+			 cmd.heavy_tx_thld_packets);
+	pos += scnprintf(buf+pos, bufsz-pos, "heavy_rx_thld_packets = %d\n",
+			 cmd.heavy_rx_thld_packets);
+	pos += scnprintf(buf+pos, bufsz-pos, "heavy_tx_thld_percentage = %d\n",
+			 cmd.heavy_tx_thld_percentage);
+	pos += scnprintf(buf+pos, bufsz-pos, "heavy_rx_thld_percentage = %d\n",
+			 cmd.heavy_rx_thld_percentage);
+	pos += scnprintf(buf+pos, bufsz-pos, "uapsd_misbehaving_enable = %d\n",
+			 (cmd.flags &
+			  cpu_to_le16(POWER_FLAGS_UAPSD_MISBEHAVING_ENA_MSK)) ?
+			 1 : 0);
+
+	if (!(cmd.flags & cpu_to_le16(POWER_FLAGS_SNOOZE_ENA_MSK)))
+		return pos;
+
+	pos += scnprintf(buf+pos, bufsz-pos, "snooze_interval = %d\n",
+			 cmd.snooze_interval);
+	pos += scnprintf(buf+pos, bufsz-pos, "snooze_window = %d\n",
+			 cmd.snooze_window);
+
 	return pos;
 }
 
-- 
1.7.9.5

