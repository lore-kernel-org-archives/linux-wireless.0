Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32677 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762AbbDBGm3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2015 02:42:29 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 26/31] iwlwifi: mvm: add trigger for firmware dump upon MLME failures
Date: Thu,  2 Apr 2015 09:41:14 +0300
Message-Id: <1427956879-11725-26-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150402_090417_387344_690C4FE7)
In-Reply-To: <1427956656.8122.2.camel@egrumbacBox>
References: <1427956656.8122.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will allow to catch failures in MLME and get the
firmware data when this happens.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h |  4 +-
 drivers/net/wireless/iwlwifi/iwl-fw-file.h       | 35 +++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c      | 65 ++++++++++++++++++++++++
 3 files changed, 102 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
index 46cbae8..8b926ec 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
@@ -246,7 +246,7 @@ iwl_fw_error_next_data(struct iwl_fw_error_dump_data *data)
  * @FW_DBG_TRIGGER_CHANNEL_SWITCH: trigger log collection upon channel switch.
  * @FW_DBG_TRIGGER_FW_NOTIF: trigger log collection when the firmware sends a
  *	command response or a notification.
- * @FW_DB_TRIGGER_RESERVED: reserved
+ * @FW_DBG_TRIGGER_MLME: trigger log collection upon MLME event.
  * @FW_DBG_TRIGGER_STATS: trigger log collection upon statistics threshold.
  * @FW_DBG_TRIGGER_RSSI: trigger log collection when the rssi of the beacon
  *	goes below a threshold.
@@ -260,7 +260,7 @@ enum iwl_fw_dbg_trigger {
 	FW_DBG_TRIGGER_MISSED_BEACONS,
 	FW_DBG_TRIGGER_CHANNEL_SWITCH,
 	FW_DBG_TRIGGER_FW_NOTIF,
-	FW_DB_TRIGGER_RESERVED,
+	FW_DBG_TRIGGER_MLME,
 	FW_DBG_TRIGGER_STATS,
 	FW_DBG_TRIGGER_RSSI,
 	FW_DBG_TRIGGER_TXQ_TIMERS,
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 0cfc66d..823938e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -579,6 +579,41 @@ struct iwl_fw_dbg_trigger_low_rssi {
 } __packed;
 
 /**
+ * struct iwl_fw_dbg_trigger_mlme - configures trigger for mlme events
+ * @stop_auth_denied: number of denied authentication to collect
+ * @stop_auth_timeout: number of authentication timeout to collect
+ * @stop_rx_deauth: number of Rx deauth before to collect
+ * @stop_tx_deauth: number of Tx deauth before to collect
+ * @stop_assoc_denied: number of denied association to collect
+ * @stop_assoc_timeout: number of association timeout to collect
+ * @start_auth_denied: number of denied authentication to start recording
+ * @start_auth_timeout: number of authentication timeout to start recording
+ * @start_rx_deauth: number of Rx deauth to start recording
+ * @start_tx_deauth: number of Tx deauth to start recording
+ * @start_assoc_denied: number of denied association to start recording
+ * @start_assoc_timeout: number of association timeout to start recording
+ */
+struct iwl_fw_dbg_trigger_mlme {
+	u8 stop_auth_denied;
+	u8 stop_auth_timeout;
+	u8 stop_rx_deauth;
+	u8 stop_tx_deauth;
+
+	u8 stop_assoc_denied;
+	u8 stop_assoc_timeout;
+	__le16 reserved2;
+
+	u8 start_auth_denied;
+	u8 start_auth_timeout;
+	u8 start_rx_deauth;
+	u8 start_tx_deauth;
+
+	u8 start_assoc_denied;
+	u8 start_assoc_timeout;
+	__le16 reserved4;
+} __packed;
+
+/**
  * struct iwl_fw_dbg_trigger_txq_timer - configures the Tx queue's timer
  * @command_queue: timeout for the command queue in ms
  * @bss: timeout for the queues of a BSS (except for TDLS queues) in ms
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 810b6d3..fc73cc1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -3956,6 +3956,69 @@ static void iwl_mvm_mac_sta_statistics(struct ieee80211_hw *hw,
 	mutex_unlock(&mvm->mutex);
 }
 
+static void iwl_mvm_mac_event_callback(struct ieee80211_hw *hw,
+				       struct ieee80211_vif *vif,
+				       const struct ieee80211_event *event)
+{
+#define CHECK_MLME_TRIGGER(_mvm, _trig, _buf, _cnt, _str...)	\
+	do {							\
+		if ((_cnt) && --(_cnt))				\
+			break;					\
+		snprintf(_buf, sizeof(_buf), ##_str);		\
+		iwl_mvm_fw_dbg_collect_trig(_mvm, _trig, _buf,	\
+					    sizeof(_buf));	\
+	} while (0)
+
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	struct iwl_fw_dbg_trigger_tlv *trig;
+	struct iwl_fw_dbg_trigger_mlme *trig_mlme;
+	char buf[32];
+
+	if (!iwl_fw_dbg_trigger_enabled(mvm->fw, FW_DBG_TRIGGER_MLME))
+		return;
+
+	if (event->u.mlme.status == MLME_SUCCESS)
+		return;
+
+	trig = iwl_fw_dbg_get_trigger(mvm->fw, FW_DBG_TRIGGER_MLME);
+	trig_mlme = (void *)trig->data;
+	if (!iwl_fw_dbg_trigger_check_stop(mvm, vif, trig))
+		return;
+
+	memset(buf, 0, sizeof(buf));
+
+	if (event->u.mlme.data == ASSOC_EVENT) {
+		if (event->u.mlme.status == MLME_DENIED)
+			CHECK_MLME_TRIGGER(mvm, trig, buf,
+					   trig_mlme->stop_assoc_denied,
+					   "DENIED ASSOC: reason %d",
+					    event->u.mlme.reason);
+		else if (event->u.mlme.status == MLME_TIMEOUT)
+			CHECK_MLME_TRIGGER(mvm, trig, buf,
+					   trig_mlme->stop_assoc_timeout,
+					   "ASSOC TIMEOUT");
+	} else if (event->u.mlme.data == AUTH_EVENT) {
+		if (event->u.mlme.status == MLME_DENIED)
+			CHECK_MLME_TRIGGER(mvm, trig, buf,
+					   trig_mlme->stop_auth_denied,
+					   "DENIED AUTH: reason %d",
+					   event->u.mlme.reason);
+		else if (event->u.mlme.status == MLME_TIMEOUT)
+			CHECK_MLME_TRIGGER(mvm, trig, buf,
+					   trig_mlme->stop_auth_timeout,
+					   "AUTH TIMEOUT");
+	} else if (event->u.mlme.data == DEAUTH_RX_EVENT) {
+		CHECK_MLME_TRIGGER(mvm, trig, buf,
+				   trig_mlme->stop_rx_deauth,
+				   "DEAUTH RX %d", event->u.mlme.reason);
+	} else if (event->u.mlme.data == DEAUTH_TX_EVENT) {
+		CHECK_MLME_TRIGGER(mvm, trig, buf,
+				   trig_mlme->stop_tx_deauth,
+				   "DEAUTH TX %d", event->u.mlme.reason);
+	}
+#undef CHECK_MLME_TRIGGER
+}
+
 const struct ieee80211_ops iwl_mvm_hw_ops = {
 	.tx = iwl_mvm_mac_tx,
 	.ampdu_action = iwl_mvm_mac_ampdu_action,
@@ -4009,6 +4072,8 @@ const struct ieee80211_ops iwl_mvm_hw_ops = {
 	.tdls_cancel_channel_switch = iwl_mvm_tdls_cancel_channel_switch,
 	.tdls_recv_channel_switch = iwl_mvm_tdls_recv_channel_switch,
 
+	.event_callback = iwl_mvm_mac_event_callback,
+
 	CFG80211_TESTMODE_CMD(iwl_mvm_mac_testmode_cmd)
 
 #ifdef CONFIG_PM_SLEEP
-- 
1.9.1

