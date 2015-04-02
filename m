Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:6058 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825AbbDBGmf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2015 02:42:35 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 31/31] iwlwifi: mvm: capture connection loss as part of MLME trigger
Date: Thu,  2 Apr 2015 09:41:19 +0300
Message-Id: <1427956879-11725-31-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150402_090420_231609_FCF35BEB)
In-Reply-To: <1427956656.8122.2.camel@egrumbacBox>
References: <1427956656.8122.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The only other way to catch these would have been to monitor
the Tx deauth event, but we can send a deauth when we roam.
So it would have been tricky to make sure we capture the
connection losses only.
Define a separate trigger for the connection losses to make
it easier to catch them.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-file.h    |  8 ++++++--
 drivers/net/wireless/iwlwifi/mvm/mvm.h        |  2 ++
 drivers/net/wireless/iwlwifi/mvm/ops.c        |  2 +-
 drivers/net/wireless/iwlwifi/mvm/time-event.c |  6 ++++--
 drivers/net/wireless/iwlwifi/mvm/utils.c      | 24 ++++++++++++++++++++++++
 5 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index ee14948..bfdf3fa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -586,12 +586,14 @@ struct iwl_fw_dbg_trigger_low_rssi {
  * @stop_tx_deauth: number of Tx deauth before to collect
  * @stop_assoc_denied: number of denied association to collect
  * @stop_assoc_timeout: number of association timeout to collect
+ * @stop_connection_loss: number of connection loss to collect
  * @start_auth_denied: number of denied authentication to start recording
  * @start_auth_timeout: number of authentication timeout to start recording
  * @start_rx_deauth: number of Rx deauth to start recording
  * @start_tx_deauth: number of Tx deauth to start recording
  * @start_assoc_denied: number of denied association to start recording
  * @start_assoc_timeout: number of association timeout to start recording
+ * @start_connection_loss: number of connection loss to start recording
  */
 struct iwl_fw_dbg_trigger_mlme {
 	u8 stop_auth_denied;
@@ -601,7 +603,8 @@ struct iwl_fw_dbg_trigger_mlme {
 
 	u8 stop_assoc_denied;
 	u8 stop_assoc_timeout;
-	__le16 reserved2;
+	u8 stop_connection_loss;
+	u8 reserved;
 
 	u8 start_auth_denied;
 	u8 start_auth_timeout;
@@ -610,7 +613,8 @@ struct iwl_fw_dbg_trigger_mlme {
 
 	u8 start_assoc_denied;
 	u8 start_assoc_timeout;
-	__le16 reserved4;
+	u8 start_connection_loss;
+	u8 reserved2;
 } __packed;
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index ef78ebc..d5522a1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1484,6 +1484,8 @@ int iwl_mvm_fw_dbg_collect_trig(struct iwl_mvm *mvm,
 unsigned int iwl_mvm_get_wd_timeout(struct iwl_mvm *mvm,
 				    struct ieee80211_vif *vif,
 				    bool tdls, bool cmd_q);
+void iwl_mvm_connection_loss(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+			     const char *errmsg);
 static inline bool
 iwl_fw_dbg_trigger_vif_match(struct iwl_fw_dbg_trigger_tlv *trig,
 			     struct ieee80211_vif *vif)
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index e656511..a08b03d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -1161,7 +1161,7 @@ static void iwl_mvm_d0i3_disconnect_iter(void *data, u8 *mac,
 
 	if (vif->type == NL80211_IFTYPE_STATION && vif->bss_conf.assoc &&
 	    mvm->d0i3_ap_sta_id == mvmvif->ap_sta_id)
-		ieee80211_connection_loss(vif);
+		iwl_mvm_connection_loss(mvm, vif, "D0i3");
 }
 
 void iwl_mvm_d0i3_enable_tx(struct iwl_mvm *mvm, __le16 *qos_seq)
diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index 6478223..fd7b0d3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -187,7 +187,8 @@ static bool iwl_mvm_te_check_disconnect(struct iwl_mvm *mvm,
 		return false;
 	if (errmsg)
 		IWL_ERR(mvm, "%s\n", errmsg);
-	ieee80211_connection_loss(vif);
+
+	iwl_mvm_connection_loss(mvm, vif, errmsg);
 	return true;
 }
 
@@ -210,7 +211,8 @@ iwl_mvm_te_handle_notify_csa(struct iwl_mvm *mvm,
 		break;
 	case NL80211_IFTYPE_STATION:
 		if (!notif->status) {
-			ieee80211_connection_loss(te_data->vif);
+			iwl_mvm_connection_loss(mvm, vif,
+						"CSA TE failed to start");
 			break;
 		}
 		iwl_mvm_csa_client_absent(mvm, te_data->vif);
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index 54e3556..bc55a8b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -965,3 +965,27 @@ unsigned int iwl_mvm_get_wd_timeout(struct iwl_mvm *mvm,
 		return mvm->cfg->base_params->wd_timeout;
 	}
 }
+
+void iwl_mvm_connection_loss(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+			     const char *errmsg)
+{
+	struct iwl_fw_dbg_trigger_tlv *trig;
+	struct iwl_fw_dbg_trigger_mlme *trig_mlme;
+
+	if (!iwl_fw_dbg_trigger_enabled(mvm->fw, FW_DBG_TRIGGER_MLME))
+		goto out;
+
+	trig = iwl_fw_dbg_get_trigger(mvm->fw, FW_DBG_TRIGGER_MLME);
+	trig_mlme = (void *)trig->data;
+	if (!iwl_fw_dbg_trigger_check_stop(mvm, vif, trig))
+		goto out;
+
+	if (trig_mlme->stop_connection_loss &&
+	    --trig_mlme->stop_connection_loss)
+		goto out;
+
+	iwl_mvm_fw_dbg_collect_trig(mvm, trig, "%s", errmsg);
+
+out:
+	ieee80211_connection_loss(vif);
+}
-- 
1.9.1

