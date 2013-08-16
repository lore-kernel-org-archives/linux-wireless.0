Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38900 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400Ab3HPLJO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 07:09:14 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>
Subject: [PATCH 12/20] iwlwifi: mvm: Add basic uAPSD client support
Date: Fri, 16 Aug 2013 13:07:02 +0200
Message-Id: <1376651230-1060-12-git-send-email-johannes@sipsolutions.net> (sfid-20130816_130919_012355_49882F15)
In-Reply-To: <1376651230-1060-1-git-send-email-johannes@sipsolutions.net>
References: <1376651161.15299.24.camel@jlt4.sipsolutions.net>
 <1376651230-1060-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

Implement basic uAPSD client support adding the following:

- Advertise uAPSD support in HW capabilities
- Set all ACs trigger- and delivery-enabled
- Set max SP length to 2 buffered frames
- Assign QNDP with the highest TID with no mandatory admission
  control required
- Set uAPSD related parameters in Power Table command

Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/constants.h    |   6 ++
 drivers/net/wireless/iwlwifi/mvm/debugfs.c      |   2 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h |  16 +--
 drivers/net/wireless/iwlwifi/mvm/mac80211.c     |   7 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h          |   5 +
 drivers/net/wireless/iwlwifi/mvm/power.c        | 127 ++++++++++++++++++++----
 6 files changed, 135 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/constants.h b/drivers/net/wireless/iwlwifi/mvm/constants.h
index 64656e0c..33f98fc 100644
--- a/drivers/net/wireless/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/iwlwifi/mvm/constants.h
@@ -67,5 +67,11 @@
 #define IWL_MVM_DEFAULT_PS_RX_DATA_TIMEOUT	(100 * USEC_PER_MSEC)
 #define IWL_MVM_WOWLAN_PS_TX_DATA_TIMEOUT	(10 * USEC_PER_MSEC)
 #define IWL_MVM_WOWLAN_PS_RX_DATA_TIMEOUT	(10 * USEC_PER_MSEC)
+#define IWL_MVM_UAPSD_RX_DATA_TIMEOUT		(50 * USEC_PER_MSEC)
+#define IWL_MVM_UAPSD_TX_DATA_TIMEOUT		(50 * USEC_PER_MSEC)
+#define IWL_MVM_PS_HEAVY_TX_THLD_PACKETS	20
+#define IWL_MVM_PS_HEAVY_RX_THLD_PACKETS	20
+#define IWL_MVM_PS_HEAVY_TX_THLD_PERCENT	50
+#define IWL_MVM_PS_HEAVY_RX_THLD_PERCENT	50
 
 #endif /* __MVM_CONSTANTS_H */
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 3cdc005..14811a5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -424,7 +424,7 @@ static ssize_t iwl_dbgfs_pm_params_read(struct file *file,
 	struct ieee80211_vif *vif = file->private_data;
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mvm *mvm = mvmvif->dbgfs_data;
-	char buf[256];
+	char buf[512];
 	int bufsz = sizeof(buf);
 	int pos;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
index 060e630..bb010b3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
@@ -164,10 +164,10 @@ struct iwl_powertable_cmd {
  *			Use IEEE80211_WMM_IE_STA_QOSINFO_AC* for correct values.
  * @uapsd_max_sp:	Use IEEE80211_WMM_IE_STA_QOSINFO_SP_* for correct
  *			values.
- * @heavy_traffic_thr_tx_pkts:	TX threshold measured in number of packets
- * @heavy_traffic_thr_rx_pkts:	RX threshold measured in number of packets
- * @heavy_traffic_thr_tx_load:	TX threshold measured in load's percentage
- * @heavy_traffic_thr_rx_load:	RX threshold measured in load's percentage
+ * @heavy_tx_thld_packets:	TX threshold measured in number of packets
+ * @heavy_rx_thld_packets:	RX threshold measured in number of packets
+ * @heavy_tx_thld_percentage:	TX threshold measured in load's percentage
+ * @heavy_rx_thld_percentage:	RX threshold measured in load's percentage
  * @limited_ps_threshold:
 */
 struct iwl_mac_power_cmd {
@@ -189,10 +189,10 @@ struct iwl_mac_power_cmd {
 	u8 qndp_tid;
 	u8 uapsd_ac_flags;
 	u8 uapsd_max_sp;
-	u8 heavy_traffic_threshold_tx_packets;
-	u8 heavy_traffic_threshold_rx_packets;
-	u8 heavy_traffic_threshold_tx_percentage;
-	u8 heavy_traffic_threshold_rx_percentage;
+	u8 heavy_tx_thld_packets;
+	u8 heavy_rx_thld_packets;
+	u8 heavy_tx_thld_percentage;
+	u8 heavy_rx_thld_percentage;
 	u8 limited_ps_threshold;
 	u8 reserved;
 } __packed;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 05daa90..66803b9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -155,7 +155,8 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		    IEEE80211_HW_TIMING_BEACON_ONLY |
 		    IEEE80211_HW_CONNECTION_MONITOR |
 		    IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS |
-		    IEEE80211_HW_SUPPORTS_STATIC_SMPS;
+		    IEEE80211_HW_SUPPORTS_STATIC_SMPS |
+		    IEEE80211_HW_SUPPORTS_UAPSD;
 
 	hw->queues = IWL_MVM_FIRST_AGG_QUEUE;
 	hw->offchannel_tx_hw_queue = IWL_MVM_OFFCHANNEL_QUEUE;
@@ -190,6 +191,8 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 
 	hw->wiphy->max_remain_on_channel_duration = 10000;
 	hw->max_listen_interval = IWL_CONN_MAX_LISTEN_INTERVAL;
+	hw->uapsd_queues = IWL_UAPSD_AC_INFO;
+	hw->uapsd_max_sp_len = IWL_UAPSD_MAX_SP;
 
 	/* Extract MAC address */
 	memcpy(mvm->addresses[0].addr, mvm->nvm_data->hw_addr, ETH_ALEN);
@@ -812,7 +815,7 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 		 */
 		iwl_mvm_remove_time_event(mvm, mvmvif,
 					  &mvmvif->time_event_data);
-	} else if (changes & BSS_CHANGED_PS) {
+	} else if (changes & (BSS_CHANGED_PS | BSS_CHANGED_QOS)) {
 		ret = iwl_mvm_power_update_mode(mvm, vif);
 		if (ret)
 			IWL_ERR(mvm, "failed to update power mode\n");
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 76f6a1f..014d779 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -153,6 +153,11 @@ enum iwl_power_scheme {
 };
 
 #define IWL_CONN_MAX_LISTEN_INTERVAL	70
+#define IWL_UAPSD_AC_INFO		(IEEE80211_WMM_IE_STA_QOSINFO_AC_VO |\
+					 IEEE80211_WMM_IE_STA_QOSINFO_AC_VI |\
+					 IEEE80211_WMM_IE_STA_QOSINFO_AC_BK |\
+					 IEEE80211_WMM_IE_STA_QOSINFO_AC_BE)
+#define IWL_UAPSD_MAX_SP		IEEE80211_WMM_IE_STA_QOSINFO_SP_2
 
 struct iwl_mvm_power_ops {
 	int (*power_update_mode)(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index 4e7c9f2..9c9b5ba 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -140,17 +140,30 @@ static void iwl_mvm_power_log(struct iwl_mvm *mvm,
 	IWL_DEBUG_POWER(mvm, "Keep alive = %u sec\n",
 			le16_to_cpu(cmd->keep_alive_seconds));
 
-	if (cmd->flags & cpu_to_le16(POWER_FLAGS_POWER_MANAGEMENT_ENA_MSK)) {
-		IWL_DEBUG_POWER(mvm, "Rx timeout = %u usec\n",
-				le32_to_cpu(cmd->rx_data_timeout));
-		IWL_DEBUG_POWER(mvm, "Tx timeout = %u usec\n",
-				le32_to_cpu(cmd->tx_data_timeout));
-		if (cmd->flags & cpu_to_le16(POWER_FLAGS_SKIP_OVER_DTIM_MSK))
-			IWL_DEBUG_POWER(mvm, "DTIM periods to skip = %u\n",
-					cmd->skip_dtim_periods);
-		if (cmd->flags & cpu_to_le16(POWER_FLAGS_LPRX_ENA_MSK))
-			IWL_DEBUG_POWER(mvm, "LP RX RSSI threshold = %u\n",
-					cmd->lprx_rssi_threshold);
+	if (!(cmd->flags & cpu_to_le16(POWER_FLAGS_POWER_MANAGEMENT_ENA_MSK))) {
+		IWL_DEBUG_POWER(mvm, "Disable power management\n");
+		return;
+	}
+
+	IWL_DEBUG_POWER(mvm, "Rx timeout = %u usec\n",
+			le32_to_cpu(cmd->rx_data_timeout));
+	IWL_DEBUG_POWER(mvm, "Tx timeout = %u usec\n",
+			le32_to_cpu(cmd->tx_data_timeout));
+	if (cmd->flags & cpu_to_le16(POWER_FLAGS_SKIP_OVER_DTIM_MSK))
+		IWL_DEBUG_POWER(mvm, "DTIM periods to skip = %u\n",
+				cmd->skip_dtim_periods);
+	if (cmd->flags & cpu_to_le16(POWER_FLAGS_LPRX_ENA_MSK))
+		IWL_DEBUG_POWER(mvm, "LP RX RSSI threshold = %u\n",
+				cmd->lprx_rssi_threshold);
+	if (cmd->flags & cpu_to_le16(POWER_FLAGS_ADVANCE_PM_ENA_MSK)) {
+		IWL_DEBUG_POWER(mvm, "uAPSD enabled\n");
+		IWL_DEBUG_POWER(mvm, "Rx timeout (uAPSD) = %u usec\n",
+				le32_to_cpu(cmd->rx_data_timeout_uapsd));
+		IWL_DEBUG_POWER(mvm, "Tx timeout (uAPSD) = %u usec\n",
+				le32_to_cpu(cmd->tx_data_timeout_uapsd));
+		IWL_DEBUG_POWER(mvm, "QNDP TID = %d\n", cmd->qndp_tid);
+		IWL_DEBUG_POWER(mvm, "ACs flags = 0x%x\n", cmd->uapsd_ac_flags);
+		IWL_DEBUG_POWER(mvm, "Max SP = %d\n", cmd->uapsd_max_sp);
 	}
 }
 
@@ -166,6 +179,8 @@ static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 	bool radar_detect = false;
 	struct iwl_mvm_vif *mvmvif __maybe_unused =
 		iwl_mvm_vif_from_mac80211(vif);
+	enum ieee80211_ac_numbers ac;
+	bool tid_found = false;
 
 	cmd->id_and_color = cpu_to_le32(FW_CMD_ID_AND_COLOR(mvmvif->id,
 							    mvmvif->color));
@@ -235,6 +250,49 @@ static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 			cpu_to_le32(IWL_MVM_WOWLAN_PS_TX_DATA_TIMEOUT);
 	}
 
+	for (ac = IEEE80211_AC_VO; ac <= IEEE80211_AC_BK; ac++) {
+		if (!mvmvif->queue_params[ac].uapsd)
+			continue;
+
+		cmd->flags |= cpu_to_le16(POWER_FLAGS_ADVANCE_PM_ENA_MSK);
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
+	if (cmd->flags & cpu_to_le16(POWER_FLAGS_ADVANCE_PM_ENA_MSK)) {
+		cmd->rx_data_timeout_uapsd =
+			cpu_to_le32(IWL_MVM_UAPSD_RX_DATA_TIMEOUT);
+		cmd->tx_data_timeout_uapsd =
+			cpu_to_le32(IWL_MVM_UAPSD_TX_DATA_TIMEOUT);
+		cmd->uapsd_max_sp = IWL_UAPSD_MAX_SP;
+		cmd->heavy_tx_thld_packets =
+			IWL_MVM_PS_HEAVY_TX_THLD_PACKETS;
+		cmd->heavy_rx_thld_packets =
+			IWL_MVM_PS_HEAVY_RX_THLD_PACKETS;
+		cmd->heavy_tx_thld_percentage =
+			IWL_MVM_PS_HEAVY_TX_THLD_PERCENT;
+		cmd->heavy_rx_thld_percentage =
+			IWL_MVM_PS_HEAVY_RX_THLD_PERCENT;
+	}
+
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	if (mvmvif->dbgfs_pm.mask & MVM_DEBUGFS_PM_KEEP_ALIVE)
 		cmd->keep_alive_seconds =
@@ -342,8 +400,6 @@ static int iwl_mvm_power_mac_dbgfs_read(struct iwl_mvm *mvm,
 			 (cmd.flags &
 			 cpu_to_le16(POWER_FLAGS_POWER_SAVE_ENA_MSK)) ?
 			 0 : 1);
-	pos += scnprintf(buf+pos, bufsz-pos, "skip_dtim_periods = %d\n",
-			 cmd.skip_dtim_periods);
 	pos += scnprintf(buf+pos, bufsz-pos, "power_scheme = %d\n",
 			 iwlmvm_mod_params.power_scheme);
 	pos += scnprintf(buf+pos, bufsz-pos, "flags = 0x%x\n",
@@ -356,14 +412,51 @@ static int iwl_mvm_power_mac_dbgfs_read(struct iwl_mvm *mvm,
 				 (cmd.flags &
 				 cpu_to_le16(POWER_FLAGS_SKIP_OVER_DTIM_MSK)) ?
 				 1 : 0);
-		pos += scnprintf(buf+pos, bufsz-pos, "rx_data_timeout = %d\n",
-				 le32_to_cpu(cmd.rx_data_timeout));
-		pos += scnprintf(buf+pos, bufsz-pos, "tx_data_timeout = %d\n",
-				 le32_to_cpu(cmd.tx_data_timeout));
+		pos += scnprintf(buf+pos, bufsz-pos, "skip_dtim_periods = %d\n",
+				 cmd.skip_dtim_periods);
+		if (!(cmd.flags &
+		      cpu_to_le16(POWER_FLAGS_ADVANCE_PM_ENA_MSK))) {
+			pos += scnprintf(buf+pos, bufsz-pos,
+					 "rx_data_timeout = %d\n",
+					 le32_to_cpu(cmd.rx_data_timeout));
+			pos += scnprintf(buf+pos, bufsz-pos,
+					 "tx_data_timeout = %d\n",
+					 le32_to_cpu(cmd.tx_data_timeout));
+		}
 		if (cmd.flags & cpu_to_le16(POWER_FLAGS_LPRX_ENA_MSK))
 			pos += scnprintf(buf+pos, bufsz-pos,
 					 "lprx_rssi_threshold = %d\n",
 					 cmd.lprx_rssi_threshold);
+		if (cmd.flags & cpu_to_le16(POWER_FLAGS_ADVANCE_PM_ENA_MSK)) {
+			pos +=
+			scnprintf(buf+pos, bufsz-pos,
+				  "rx_data_timeout_uapsd = %d\n",
+				  le32_to_cpu(cmd.rx_data_timeout_uapsd));
+			pos +=
+			scnprintf(buf+pos, bufsz-pos,
+				  "tx_data_timeout_uapsd = %d\n",
+				  le32_to_cpu(cmd.tx_data_timeout_uapsd));
+			pos += scnprintf(buf+pos, bufsz-pos, "qndp_tid = %d\n",
+					 cmd.qndp_tid);
+			pos += scnprintf(buf+pos, bufsz-pos,
+					 "uapsd_ac_flags = 0x%x\n",
+					 cmd.uapsd_ac_flags);
+			pos += scnprintf(buf+pos, bufsz-pos,
+					 "uapsd_max_sp = %d\n",
+					 cmd.uapsd_max_sp);
+			pos += scnprintf(buf+pos, bufsz-pos,
+					 "heavy_tx_thld_packets = %d\n",
+					 cmd.heavy_tx_thld_packets);
+			pos += scnprintf(buf+pos, bufsz-pos,
+					 "heavy_rx_thld_packets = %d\n",
+					 cmd.heavy_rx_thld_packets);
+			pos += scnprintf(buf+pos, bufsz-pos,
+					 "heavy_tx_thld_percentage = %d\n",
+					 cmd.heavy_tx_thld_percentage);
+			pos += scnprintf(buf+pos, bufsz-pos,
+					 "heavy_rx_thld_percentage = %d\n",
+					 cmd.heavy_rx_thld_percentage);
+		}
 	}
 	return pos;
 }
-- 
1.8.4.rc2

