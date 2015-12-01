Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:8579 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755997AbbLAJ73 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 04:59:29 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Golan Ben-Ami <golan.ben.ami@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 14/41] iwlwifi: mvm: add trigger for firmware dump upon TDLS events
Date: Tue,  1 Dec 2015 11:58:40 +0200
Message-Id: <1448963947-24302-14-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151201_110348_143715_E9FE7EBE)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Golan Ben-Ami <golan.ben.ami@intel.com>

This will allow to catch different TDLS events and get the
firmware data when they occur.
Add empty TX_LATENCY trigger on the way to avoid mismatch
with trees in which this trigger is implemented.

Signed-off-by: Golan Ben-Ami <golan.ben.ami@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  2 ++
 .../net/wireless/intel/iwlwifi/iwl-fw-error-dump.h |  5 +++
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h   | 13 +++++++
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 42 ++++++++++++++++++++--
 4 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index eedd0d8..ce65665 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1323,6 +1323,8 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 		sizeof(struct iwl_fw_dbg_trigger_time_event);
 	trigger_tlv_sz[FW_DBG_TRIGGER_BA] =
 		sizeof(struct iwl_fw_dbg_trigger_ba);
+	trigger_tlv_sz[FW_DBG_TRIGGER_TDLS] =
+		sizeof(struct iwl_fw_dbg_trigger_tdls);
 
 	for (i = 0; i < ARRAY_SIZE(drv->fw.dbg_trigger_tlv); i++) {
 		if (pieces->dbg_trigger_tlv[i]) {
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw-error-dump.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw-error-dump.h
index 9dbe19c..73bcf29 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw-error-dump.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw-error-dump.h
@@ -288,6 +288,9 @@ iwl_fw_error_next_data(struct iwl_fw_error_dump_data *data)
  * @FW_DBG_TRIGGER_TIME_EVENT: trigger log collection upon time events related
  *	events.
  * @FW_DBG_TRIGGER_BA: trigger log collection upon BlockAck related events.
+ * @FW_DBG_TX_LATENCY: trigger log collection when the tx latency goes above a
+ *	threshold.
+ * @FW_DBG_TDLS: trigger log collection upon TDLS related events.
  */
 enum iwl_fw_dbg_trigger {
 	FW_DBG_TRIGGER_INVALID = 0,
@@ -302,6 +305,8 @@ enum iwl_fw_dbg_trigger {
 	FW_DBG_TRIGGER_TXQ_TIMERS,
 	FW_DBG_TRIGGER_TIME_EVENT,
 	FW_DBG_TRIGGER_BA,
+	FW_DBG_TRIGGER_TX_LATENCY,
+	FW_DBG_TRIGGER_TDLS,
 
 	/* must be last */
 	FW_DBG_TRIGGER_MAX,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
index 6aeeceb..e08319a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
@@ -725,6 +725,19 @@ struct iwl_fw_dbg_trigger_ba {
 } __packed;
 
 /**
+ * struct iwl_fw_dbg_trigger_tdls - configures trigger for TDLS events.
+ * @action_bitmap: the TDLS action to trigger the collection upon
+ * @peer_mode: trigger on specific peer or all
+ * @peer: the TDLS peer to trigger the collection on
+ */
+struct iwl_fw_dbg_trigger_tdls {
+	u8 action_bitmap;
+	u8 peer_mode;
+	u8 peer[ETH_ALEN];
+	u8 reserved[4];
+} __packed;
+
+/**
  * struct iwl_fw_dbg_conf_tlv - a TLV that describes a debug configuration.
  * @id: conf id
  * @usniffer: should the uSniffer image be used
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index e88afac..f570c71 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2699,6 +2699,34 @@ static void iwl_mvm_check_uapsd(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	vif->driver_flags |= IEEE80211_VIF_SUPPORTS_UAPSD;
 }
 
+static void
+iwl_mvm_tdls_check_trigger(struct iwl_mvm *mvm,
+			   struct ieee80211_vif *vif, u8 *peer_addr,
+			   enum nl80211_tdls_operation action)
+{
+	struct iwl_fw_dbg_trigger_tlv *trig;
+	struct iwl_fw_dbg_trigger_tdls *tdls_trig;
+
+	if (!iwl_fw_dbg_trigger_enabled(mvm->fw, FW_DBG_TRIGGER_TDLS))
+		return;
+
+	trig = iwl_fw_dbg_get_trigger(mvm->fw, FW_DBG_TRIGGER_TDLS);
+	tdls_trig = (void *)trig->data;
+	if (!iwl_fw_dbg_trigger_check_stop(mvm, vif, trig))
+		return;
+
+	if (!(tdls_trig->action_bitmap & BIT(action)))
+		return;
+
+	if (tdls_trig->peer_mode &&
+	    memcmp(tdls_trig->peer, peer_addr, ETH_ALEN) != 0)
+		return;
+
+	iwl_mvm_fw_dbg_collect_trig(mvm, trig,
+				    "TDLS event occurred, peer %pM, action %d",
+				    peer_addr, action);
+}
+
 static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 				 struct ieee80211_vif *vif,
 				 struct ieee80211_sta *sta,
@@ -2749,8 +2777,11 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 		}
 
 		ret = iwl_mvm_add_sta(mvm, vif, sta);
-		if (sta->tdls && ret == 0)
+		if (sta->tdls && ret == 0) {
 			iwl_mvm_recalc_tdls_state(mvm, vif, true);
+			iwl_mvm_tdls_check_trigger(mvm, vif, sta->addr,
+						   NL80211_TDLS_SETUP);
+		}
 	} else if (old_state == IEEE80211_STA_NONE &&
 		   new_state == IEEE80211_STA_AUTH) {
 		/*
@@ -2774,6 +2805,10 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 		if (iwl_mvm_phy_ctx_count(mvm) > 1)
 			iwl_mvm_teardown_tdls_peers(mvm);
 
+		if (sta->tdls)
+			iwl_mvm_tdls_check_trigger(mvm, vif, sta->addr,
+						   NL80211_TDLS_ENABLE_LINK);
+
 		/* enable beacon filtering */
 		WARN_ON(iwl_mvm_enable_beacon_filter(mvm, vif, 0));
 		ret = 0;
@@ -2791,8 +2826,11 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 	} else if (old_state == IEEE80211_STA_NONE &&
 		   new_state == IEEE80211_STA_NOTEXIST) {
 		ret = iwl_mvm_rm_sta(mvm, vif, sta);
-		if (sta->tdls)
+		if (sta->tdls) {
 			iwl_mvm_recalc_tdls_state(mvm, vif, false);
+			iwl_mvm_tdls_check_trigger(mvm, vif, sta->addr,
+						   NL80211_TDLS_DISABLE_LINK);
+		}
 	} else {
 		ret = -EIO;
 	}
-- 
2.5.0

