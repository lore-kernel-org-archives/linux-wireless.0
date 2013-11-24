Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:47866 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab3KXUHR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 15:07:17 -0500
Received: by mail-we0-f181.google.com with SMTP id x55so2948893wes.26
        for <linux-wireless@vger.kernel.org>; Sun, 24 Nov 2013 12:07:16 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 21/29] iwlwifi: mvm: add iwl_mvm_sta_from_mac80211
Date: Sun, 24 Nov 2013 22:06:38 +0200
Message-Id: <1385323606-3603-21-git-send-email-egrumbach@gmail.com> (sfid-20131124_210809_106975_5ECC4DC0)
In-Reply-To: <52925BE7.4050406@gmail.com>
References: <52925BE7.4050406@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is just a helper function to go from the mac80211
station struct to our internal one, to later allow us
to avoid temporary 'mvmsta' variables.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c  |    8 ++++----
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |    2 +-
 drivers/net/wireless/iwlwifi/mvm/sta.c      |   12 ++++++------
 drivers/net/wireless/iwlwifi/mvm/sta.h      |    6 ++++++
 drivers/net/wireless/iwlwifi/mvm/tt.c       |    2 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c       |   10 +++++-----
 6 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
index 7dbb058..f0eed69 100644
--- a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
@@ -515,7 +515,7 @@ static int iwl_mvm_bt_coex_reduced_txp(struct iwl_mvm *mvm, u8 sta_id,
 	if (IS_ERR_OR_NULL(sta))
 		return 0;
 
-	mvmsta = (void *)sta->drv_priv;
+	mvmsta = iwl_mvm_sta_from_mac80211(sta);
 
 	/* nothing to do */
 	if (mvmsta->bt_reduced_txpower == enable)
@@ -842,7 +842,7 @@ static void iwl_mvm_bt_rssi_iterator(void *_data, u8 *mac,
 
 	sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[mvmvif->ap_sta_id],
 					lockdep_is_held(&mvm->mutex));
-	mvmsta = (void *)sta->drv_priv;
+	mvmsta = iwl_mvm_sta_from_mac80211(sta);
 
 	data->num_bss_ifaces++;
 
@@ -913,7 +913,7 @@ void iwl_mvm_bt_rssi_event(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 u16 iwl_mvm_bt_coex_agg_time_limit(struct iwl_mvm *mvm,
 				   struct ieee80211_sta *sta)
 {
-	struct iwl_mvm_sta *mvmsta = (void *)sta->drv_priv;
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	enum iwl_bt_coex_lut_type lut_type;
 
 	if (le32_to_cpu(mvm->last_bt_notif.bt_activity_grading) <
@@ -932,7 +932,7 @@ u16 iwl_mvm_bt_coex_agg_time_limit(struct iwl_mvm *mvm,
 bool iwl_mvm_bt_coex_is_mimo_allowed(struct iwl_mvm *mvm,
 				     struct ieee80211_sta *sta)
 {
-	struct iwl_mvm_sta *mvmsta = (void *)sta->drv_priv;
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 
 	if (le32_to_cpu(mvm->last_bt_notif.bt_activity_grading) <
 	    BT_HIGH_TRAFFIC)
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index f892f58..e25aa23 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1091,7 +1091,7 @@ static void iwl_mvm_mac_sta_notify(struct ieee80211_hw *hw,
 				   struct ieee80211_sta *sta)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
-	struct iwl_mvm_sta *mvmsta = (void *)sta->drv_priv;
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 
 	switch (cmd) {
 	case STA_NOTIFY_SLEEP:
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index c89232c..7a5b747 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -840,7 +840,7 @@ static const u8 tid_to_ac[] = {
 int iwl_mvm_sta_tx_agg_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			     struct ieee80211_sta *sta, u16 tid, u16 *ssn)
 {
-	struct iwl_mvm_sta *mvmsta = (void *)sta->drv_priv;
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_mvm_tid_data *tid_data;
 	int txq_id;
 
@@ -895,7 +895,7 @@ int iwl_mvm_sta_tx_agg_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			    struct ieee80211_sta *sta, u16 tid, u8 buf_size)
 {
-	struct iwl_mvm_sta *mvmsta = (void *)sta->drv_priv;
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_mvm_tid_data *tid_data = &mvmsta->tid_data[tid];
 	int queue, fifo, ret;
 	u16 ssn;
@@ -951,7 +951,7 @@ int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 int iwl_mvm_sta_tx_agg_stop(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			    struct ieee80211_sta *sta, u16 tid)
 {
-	struct iwl_mvm_sta *mvmsta = (void *)sta->drv_priv;
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_mvm_tid_data *tid_data = &mvmsta->tid_data[tid];
 	u16 txq_id;
 	int err;
@@ -1023,7 +1023,7 @@ int iwl_mvm_sta_tx_agg_stop(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 int iwl_mvm_sta_tx_agg_flush(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			    struct ieee80211_sta *sta, u16 tid)
 {
-	struct iwl_mvm_sta *mvmsta = (void *)sta->drv_priv;
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_mvm_tid_data *tid_data = &mvmsta->tid_data[tid];
 	u16 txq_id;
 	enum iwl_mvm_agg_state old_state;
@@ -1416,7 +1416,7 @@ void iwl_mvm_update_tkip_key(struct iwl_mvm *mvm,
 void iwl_mvm_sta_modify_ps_wake(struct iwl_mvm *mvm,
 				struct ieee80211_sta *sta)
 {
-	struct iwl_mvm_sta *mvmsta = (void *)sta->drv_priv;
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_mvm_add_sta_cmd_v6 cmd = {
 		.add_modify = STA_MODE_MODIFY,
 		.sta_id = mvmsta->sta_id,
@@ -1438,7 +1438,7 @@ void iwl_mvm_sta_modify_sleep_tx_count(struct iwl_mvm *mvm,
 	u16 sleep_state_flags =
 		(reason == IEEE80211_FRAME_RELEASE_UAPSD) ?
 			STA_SLEEP_STATE_UAPSD : STA_SLEEP_STATE_PS_POLL;
-	struct iwl_mvm_sta *mvmsta = (void *)sta->drv_priv;
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_mvm_add_sta_cmd_v6 cmd = {
 		.add_modify = STA_MODE_MODIFY,
 		.sta_id = mvmsta->sta_id,
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.h b/drivers/net/wireless/iwlwifi/mvm/sta.h
index 4dfc359..b349411 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.h
@@ -298,6 +298,12 @@ struct iwl_mvm_sta {
 	bool tt_tx_protection;
 };
 
+static inline struct iwl_mvm_sta *
+iwl_mvm_sta_from_mac80211(struct ieee80211_sta *sta)
+{
+	return (void *)sta->drv_priv;
+}
+
 /**
  * struct iwl_mvm_int_sta - representation of an internal station (auxiliary or
  * broadcast)
diff --git a/drivers/net/wireless/iwlwifi/mvm/tt.c b/drivers/net/wireless/iwlwifi/mvm/tt.c
index 1f3282d..18be04d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tt.c
@@ -388,7 +388,7 @@ static void iwl_mvm_tt_tx_protection(struct iwl_mvm *mvm, bool enable)
 						lockdep_is_held(&mvm->mutex));
 		if (IS_ERR_OR_NULL(sta))
 			continue;
-		mvmsta = (void *)sta->drv_priv;
+		mvmsta = iwl_mvm_sta_from_mac80211(sta);
 		if (enable == mvmsta->tt_tx_protection)
 			continue;
 		err = iwl_mvm_tx_protection(mvm, mvmsta, enable);
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index 1f19458..d87649a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -362,7 +362,7 @@ int iwl_mvm_tx_skb(struct iwl_mvm *mvm, struct sk_buff *skb,
 	u8 txq_id = info->hw_queue;
 	bool is_data_qos = false, is_ampdu = false;
 
-	mvmsta = (void *)sta->drv_priv;
+	mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	fc = hdr->frame_control;
 
 	if (WARN_ON_ONCE(!mvmsta))
@@ -433,7 +433,7 @@ drop:
 static void iwl_mvm_check_ratid_empty(struct iwl_mvm *mvm,
 				      struct ieee80211_sta *sta, u8 tid)
 {
-	struct iwl_mvm_sta *mvmsta = (void *)sta->drv_priv;
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_mvm_tid_data *tid_data = &mvmsta->tid_data[tid];
 	struct ieee80211_vif *vif = mvmsta->vif;
 
@@ -663,7 +663,7 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 	sta = rcu_dereference(mvm->fw_id_to_mac_id[sta_id]);
 
 	if (!IS_ERR_OR_NULL(sta)) {
-		mvmsta = (void *)sta->drv_priv;
+		mvmsta = iwl_mvm_sta_from_mac80211(sta);
 
 		if (tid != IWL_TID_NON_QOS) {
 			struct iwl_mvm_tid_data *tid_data =
@@ -794,7 +794,7 @@ static void iwl_mvm_rx_tx_cmd_agg(struct iwl_mvm *mvm,
 	sta = rcu_dereference(mvm->fw_id_to_mac_id[sta_id]);
 
 	if (!WARN_ON_ONCE(IS_ERR_OR_NULL(sta))) {
-		struct iwl_mvm_sta *mvmsta = (void *)sta->drv_priv;
+		struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 		mvmsta->tid_data[tid].rate_n_flags =
 			le32_to_cpu(tx_resp->initial_rate);
 	}
@@ -850,7 +850,7 @@ int iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 		return 0;
 	}
 
-	mvmsta = (void *)sta->drv_priv;
+	mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	tid_data = &mvmsta->tid_data[tid];
 
 	if (WARN_ONCE(tid_data->txq_id != scd_flow, "Q %d, tid %d, flow %d",
-- 
1.7.9.5

