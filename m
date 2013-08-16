Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38897 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341Ab3HPLJK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 07:09:10 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>
Subject: [PATCH 20/20] iwlwifi: mvm: Add PBW snoozing enablement
Date: Fri, 16 Aug 2013 13:07:10 +0200
Message-Id: <1376651230-1060-20-git-send-email-johannes@sipsolutions.net> (sfid-20130816_130916_469304_BBFA0FEB)
In-Reply-To: <1376651230-1060-1-git-send-email-johannes@sipsolutions.net>
References: <1376651161.15299.24.camel@jlt4.sipsolutions.net>
 <1376651230-1060-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

The Performance Based Window snooze mechanism is based on uAPSD and is
used in low-medium traffic scenarios, in order to provide better power
performance while insuring low latency and jitter for the incoming traffic.
This patch enables PBW snoozing in case uAPSD is enabled and all ACs are
uAPSD trigger and delivery enabled.

Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/constants.h    |  3 +++
 drivers/net/wireless/iwlwifi/mvm/debugfs.c      |  8 ++++++
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h |  8 ++++--
 drivers/net/wireless/iwlwifi/mvm/mvm.h          |  2 ++
 drivers/net/wireless/iwlwifi/mvm/power.c        | 35 +++++++++++++++++++++++++
 5 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/constants.h b/drivers/net/wireless/iwlwifi/mvm/constants.h
index 33f98fc..2bf29f7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/iwlwifi/mvm/constants.h
@@ -73,5 +73,8 @@
 #define IWL_MVM_PS_HEAVY_RX_THLD_PACKETS	20
 #define IWL_MVM_PS_HEAVY_TX_THLD_PERCENT	50
 #define IWL_MVM_PS_HEAVY_RX_THLD_PERCENT	50
+#define IWL_MVM_PS_SNOOZE_INTERVAL		25
+#define IWL_MVM_PS_SNOOZE_WINDOW		50
+#define IWL_MVM_WOWLAN_PS_SNOOZE_WINDOW		25
 
 #endif /* __MVM_CONSTANTS_H */
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index c67b17a..2e60be2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -352,6 +352,10 @@ static void iwl_dbgfs_update_pm(struct iwl_mvm *mvm,
 		IWL_DEBUG_POWER(mvm, "lprx_rssi_threshold=%d\n", val);
 		dbgfs_pm->lprx_rssi_threshold = val;
 		break;
+	case MVM_DEBUGFS_PM_SNOOZE_ENABLE:
+		IWL_DEBUG_POWER(mvm, "snooze_enable=%d\n", val);
+		dbgfs_pm->snooze_ena = val;
+		break;
 	}
 }
 
@@ -405,6 +409,10 @@ static ssize_t iwl_dbgfs_pm_params_write(struct file *file,
 		    POWER_LPRX_RSSI_THRESHOLD_MIN)
 			return -EINVAL;
 		param = MVM_DEBUGFS_PM_LPRX_RSSI_THRESHOLD;
+	} else if (!strncmp("snooze_enable=", buf, 14)) {
+		if (sscanf(buf + 14, "%d", &val) != 1)
+			return -EINVAL;
+		param = MVM_DEBUGFS_PM_SNOOZE_ENABLE;
 	} else {
 		return -EINVAL;
 	}
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
index bb010b3..8e7ab41 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
@@ -155,8 +155,12 @@ struct iwl_powertable_cmd {
  * @lprx_rssi_threshold: Signal strength up to which LP RX can be enabled.
  *			Default: 80dbm
  * @num_skip_dtim:	Number of DTIMs to skip if Skip over DTIM flag is set
- * @snooze_interval:	TBD
- * @snooze_window:	TBD
+ * @snooze_interval:	Maximum time between attempts to retrieve buffered data
+ *			from the AP [msec]
+ * @snooze_window:	A window of time in which PBW snoozing insures that all
+ *			packets received. It is also the minimum time from last
+ *			received unicast RX packet, before client stops snoozing
+ *			for data. [msec]
  * @snooze_step:	TBD
  * @qndp_tid:		TID client shall use for uAPSD QNDP triggers
  * @uapsd_ac_flags:	Set trigger-enabled and delivery-enabled indication for
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index ee46dea..0f33d7f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -180,6 +180,7 @@ enum iwl_dbgfs_pm_mask {
 	MVM_DEBUGFS_PM_DISABLE_POWER_OFF = BIT(5),
 	MVM_DEBUGFS_PM_LPRX_ENA = BIT(6),
 	MVM_DEBUGFS_PM_LPRX_RSSI_THRESHOLD = BIT(7),
+	MVM_DEBUGFS_PM_SNOOZE_ENABLE = BIT(8),
 };
 
 struct iwl_dbgfs_pm {
@@ -191,6 +192,7 @@ struct iwl_dbgfs_pm {
 	bool disable_power_off;
 	bool lprx_ena;
 	u32 lprx_rssi_threshold;
+	bool snooze_ena;
 	int mask;
 };
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index a5529b8..21407a3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -301,6 +301,20 @@ static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 			cpu_to_le32(IWL_MVM_UAPSD_RX_DATA_TIMEOUT);
 		cmd->tx_data_timeout_uapsd =
 			cpu_to_le32(IWL_MVM_UAPSD_TX_DATA_TIMEOUT);
+
+		if (cmd->uapsd_ac_flags == (BIT(IEEE80211_AC_VO) |
+					    BIT(IEEE80211_AC_VI) |
+					    BIT(IEEE80211_AC_BE) |
+					    BIT(IEEE80211_AC_BK))) {
+			cmd->flags |= cpu_to_le16(POWER_FLAGS_SNOOZE_ENA_MSK);
+			cmd->snooze_interval =
+				cpu_to_le16(IWL_MVM_PS_SNOOZE_INTERVAL);
+			cmd->snooze_window =
+				(mvm->cur_ucode == IWL_UCODE_WOWLAN) ?
+				cpu_to_le16(IWL_MVM_WOWLAN_PS_SNOOZE_WINDOW) :
+				cpu_to_le16(IWL_MVM_PS_SNOOZE_WINDOW);
+		}
+
 		cmd->uapsd_max_sp = IWL_UAPSD_MAX_SP;
 		cmd->heavy_tx_thld_packets =
 			IWL_MVM_PS_HEAVY_TX_THLD_PACKETS;
@@ -340,6 +354,14 @@ static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 	}
 	if (mvmvif->dbgfs_pm.mask & MVM_DEBUGFS_PM_LPRX_RSSI_THRESHOLD)
 		cmd->lprx_rssi_threshold = mvmvif->dbgfs_pm.lprx_rssi_threshold;
+	if (mvmvif->dbgfs_pm.mask & MVM_DEBUGFS_PM_SNOOZE_ENABLE) {
+		if (mvmvif->dbgfs_pm.snooze_ena)
+			cmd->flags |=
+				cpu_to_le16(POWER_FLAGS_SNOOZE_ENA_MSK);
+		else
+			cmd->flags &=
+				cpu_to_le16(~POWER_FLAGS_SNOOZE_ENA_MSK);
+	}
 #endif /* CONFIG_IWLWIFI_DEBUGFS */
 }
 
@@ -475,6 +497,19 @@ static int iwl_mvm_power_mac_dbgfs_read(struct iwl_mvm *mvm,
 			pos += scnprintf(buf+pos, bufsz-pos,
 					 "heavy_rx_thld_percentage = %d\n",
 					 cmd.heavy_rx_thld_percentage);
+			pos +=
+			scnprintf(buf+pos, bufsz-pos, "snooze_enable = %d\n",
+				  (cmd.flags &
+				   cpu_to_le16(POWER_FLAGS_SNOOZE_ENA_MSK)) ?
+				  1 : 0);
+		}
+		if (cmd.flags & cpu_to_le16(POWER_FLAGS_SNOOZE_ENA_MSK)) {
+			pos += scnprintf(buf+pos, bufsz-pos,
+					 "snooze_interval = %d\n",
+					 cmd.snooze_interval);
+			pos += scnprintf(buf+pos, bufsz-pos,
+					 "snooze_window = %d\n",
+					 cmd.snooze_window);
 		}
 	}
 	return pos;
-- 
1.8.4.rc2

