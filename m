Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:53947 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027AbbLUUwn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 15:52:43 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 42/45] iwlwifi: update key params on d0i3 entrance/exit
Date: Mon, 21 Dec 2015 22:50:43 +0200
Message-Id: <1450731046-2796-42-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151221_220058_784345_24A681F2)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

In order to let the fw do offloading properly, we need
to provide various key data (e.g. PN).

Configure the params on d0i3 entrance, and update them
back on d0i3 exit.

Since d3 code is now called in d0i3 which requires runtime
pm only, make d3.0 depend on CONFIG_PM (rather than
CONFIG_PM_SLEEP), and add required #ifdefs and wrappers
where needed, so both CONFIG_PM=n and CONFIG_PM_RUNTIME=n
configurations will build correctly.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/Makefile |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c     | 84 +++++++++++++++++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h    | 31 ++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c    | 64 +++++++++++--------
 4 files changed, 136 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/Makefile b/drivers/net/wireless/intel/iwlwifi/mvm/Makefile
index 80c2f88..23e7e29 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/Makefile
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/Makefile
@@ -7,6 +7,6 @@ iwlmvm-y += tt.o offloading.o tdls.o
 iwlmvm-$(CONFIG_IWLWIFI_DEBUGFS) += debugfs.o debugfs-vif.o
 iwlmvm-$(CONFIG_IWLWIFI_LEDS) += led.o
 iwlmvm-y += tof.o fw-dbg.o
-iwlmvm-$(CONFIG_PM_SLEEP) += d3.o
+iwlmvm-$(CONFIG_PM) += d3.o
 
 ccflags-y += -D__CHECK_ENDIAN__ -I$(src)/../
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 3e6b6d6..6ac4072 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -855,15 +855,38 @@ iwl_mvm_get_wowlan_config(struct iwl_mvm *mvm,
 	return 0;
 }
 
+static void
+iwl_mvm_iter_d0i3_ap_keys(struct iwl_mvm *mvm,
+			  struct ieee80211_vif *vif,
+			  void (*iter)(struct ieee80211_hw *hw,
+				       struct ieee80211_vif *vif,
+				       struct ieee80211_sta *sta,
+				       struct ieee80211_key_conf *key,
+				       void *data),
+			  void *data)
+{
+	struct ieee80211_sta *ap_sta;
+
+	rcu_read_lock();
+
+	ap_sta = rcu_dereference(mvm->fw_id_to_mac_id[mvm->d0i3_ap_sta_id]);
+	if (IS_ERR_OR_NULL(ap_sta))
+		goto out;
+
+	ieee80211_iter_keys_rcu(mvm->hw, vif, iter, data);
+out:
+	rcu_read_unlock();
+}
+
 int iwl_mvm_wowlan_config_key_params(struct iwl_mvm *mvm,
 				     struct ieee80211_vif *vif,
-				     bool configure_keys,
+				     bool d0i3,
 				     u32 cmd_flags)
 {
 	struct iwl_wowlan_kek_kck_material_cmd kek_kck_cmd = {};
 	struct iwl_wowlan_tkip_params_cmd tkip_cmd = {};
 	struct wowlan_key_data key_data = {
-		.configure_keys = configure_keys,
+		.configure_keys = !d0i3,
 		.use_rsc_tsc = false,
 		.tkip = &tkip_cmd,
 		.use_tkip = false,
@@ -876,15 +899,28 @@ int iwl_mvm_wowlan_config_key_params(struct iwl_mvm *mvm,
 		return -ENOMEM;
 
 	/*
-	 * Note that currently we don't propagate cmd_flags
-	 * to the iterator. In case of key_data.configure_keys,
-	 * all the configured commands are SYNC, and
-	 * iwl_mvm_wowlan_program_keys() will take care of
-	 * locking/unlocking mvm->mutex.
+	 * if we have to configure keys, call ieee80211_iter_keys(),
+	 * as we need non-atomic context in order to take the
+	 * required locks.
+	 * for the d0i3 we can't use ieee80211_iter_keys(), as
+	 * taking (almost) any mutex might result in deadlock.
 	 */
-	ieee80211_iter_keys(mvm->hw, vif,
-			    iwl_mvm_wowlan_program_keys,
-			    &key_data);
+	if (!d0i3) {
+		/*
+		 * Note that currently we don't propagate cmd_flags
+		 * to the iterator. In case of key_data.configure_keys,
+		 * all the configured commands are SYNC, and
+		 * iwl_mvm_wowlan_program_keys() will take care of
+		 * locking/unlocking mvm->mutex.
+		 */
+		ieee80211_iter_keys(mvm->hw, vif,
+				    iwl_mvm_wowlan_program_keys,
+				    &key_data);
+	} else {
+		iwl_mvm_iter_d0i3_ap_keys(mvm, vif,
+					  iwl_mvm_wowlan_program_keys,
+					  &key_data);
+	}
 
 	if (key_data.error) {
 		ret = -EIO;
@@ -909,7 +945,8 @@ int iwl_mvm_wowlan_config_key_params(struct iwl_mvm *mvm,
 			goto out;
 	}
 
-	if (mvmvif->rekey_data.valid) {
+	/* configure rekey data only if offloaded rekey is supported (d3) */
+	if (mvmvif->rekey_data.valid && !d0i3) {
 		memset(&kek_kck_cmd, 0, sizeof(kek_kck_cmd));
 		memcpy(kek_kck_cmd.kck, mvmvif->rekey_data.kck,
 		       NL80211_KCK_LEN);
@@ -956,7 +993,7 @@ iwl_mvm_wowlan_config(struct iwl_mvm *mvm,
 		 * that isn't really a problem though.
 		 */
 		mutex_unlock(&mvm->mutex);
-		ret = iwl_mvm_wowlan_config_key_params(mvm, vif, true,
+		ret = iwl_mvm_wowlan_config_key_params(mvm, vif, false,
 						       CMD_ASYNC);
 		mutex_lock(&mvm->mutex);
 		if (ret)
@@ -1727,6 +1764,29 @@ out_unlock:
 	return false;
 }
 
+void iwl_mvm_d0i3_update_keys(struct iwl_mvm *mvm,
+			      struct ieee80211_vif *vif,
+			      struct iwl_wowlan_status *status)
+{
+	struct iwl_mvm_d3_gtk_iter_data gtkdata = {
+		.status = status,
+	};
+
+	/*
+	 * rekey handling requires taking locks that can't be taken now.
+	 * however, d0i3 doesn't offload rekey, so we're fine.
+	 */
+	if (WARN_ON_ONCE(status->num_of_gtk_rekeys))
+		return;
+
+	/* find last GTK that we used initially, if any */
+	gtkdata.find_phase = true;
+	iwl_mvm_iter_d0i3_ap_keys(mvm, vif, iwl_mvm_d3_update_keys, &gtkdata);
+
+	gtkdata.find_phase = false;
+	iwl_mvm_iter_d0i3_ap_keys(mvm, vif, iwl_mvm_d3_update_keys, &gtkdata);
+}
+
 struct iwl_mvm_nd_query_results {
 	u32 matched_profiles;
 	struct iwl_scan_offload_profile_match matches[IWL_SCAN_MAX_PROFILES];
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 86409c5..287c162 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -405,7 +405,7 @@ struct iwl_mvm_vif {
 	 */
 	struct iwl_mvm_phy_ctxt *phy_ctxt;
 
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_PM
 	/* WoWLAN GTK rekey data */
 	struct {
 		u8 kck[NL80211_KCK_LEN], kek[NL80211_KEK_LEN];
@@ -738,7 +738,7 @@ struct iwl_mvm {
 
 	struct ieee80211_vif *p2p_device_vif;
 
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_PM
 	struct wiphy_wowlan_support wowlan;
 	int gtk_ivlen, gtk_icvlen, ptk_ivlen, ptk_icvlen;
 
@@ -1278,10 +1278,6 @@ static inline void iwl_mvm_leds_exit(struct iwl_mvm *mvm)
 /* D3 (WoWLAN, NetDetect) */
 int iwl_mvm_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan);
 int iwl_mvm_resume(struct ieee80211_hw *hw);
-int iwl_mvm_wowlan_config_key_params(struct iwl_mvm *mvm,
-				     struct ieee80211_vif *vif,
-				     bool configure_keys,
-				     u32 cmd_flags);
 void iwl_mvm_set_wakeup(struct ieee80211_hw *hw, bool enabled);
 void iwl_mvm_set_rekey_data(struct ieee80211_hw *hw,
 			    struct ieee80211_vif *vif,
@@ -1292,10 +1288,31 @@ void iwl_mvm_ipv6_addr_change(struct ieee80211_hw *hw,
 void iwl_mvm_set_default_unicast_key(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif, int idx);
 extern const struct file_operations iwl_dbgfs_d3_test_ops;
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_PM
+int iwl_mvm_wowlan_config_key_params(struct iwl_mvm *mvm,
+				     struct ieee80211_vif *vif,
+				     bool host_awake,
+				     u32 cmd_flags);
+void iwl_mvm_d0i3_update_keys(struct iwl_mvm *mvm,
+			      struct ieee80211_vif *vif,
+			      struct iwl_wowlan_status *status);
 void iwl_mvm_set_last_nonqos_seq(struct iwl_mvm *mvm,
 				 struct ieee80211_vif *vif);
 #else
+static inline int iwl_mvm_wowlan_config_key_params(struct iwl_mvm *mvm,
+						   struct ieee80211_vif *vif,
+						   bool host_awake,
+						   u32 cmd_flags)
+{
+	return 0;
+}
+
+static inline void iwl_mvm_d0i3_update_keys(struct iwl_mvm *mvm,
+					    struct ieee80211_vif *vif,
+					    struct iwl_wowlan_status *status)
+{
+}
+
 static inline void
 iwl_mvm_set_last_nonqos_seq(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 2debce3..89ea70d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1076,6 +1076,7 @@ static void iwl_mvm_cmd_queue_full(struct iwl_op_mode *op_mode)
 
 struct iwl_d0i3_iter_data {
 	struct iwl_mvm *mvm;
+	struct ieee80211_vif *connected_vif;
 	u8 ap_sta_id;
 	u8 vif_count;
 	u8 offloading_tid;
@@ -1167,6 +1168,12 @@ static void iwl_mvm_enter_d0i3_iterator(void *_data, u8 *mac,
 	 */
 	data->ap_sta_id = mvmvif->ap_sta_id;
 	data->vif_count++;
+
+	/*
+	 * no new commands can be sent at this stage, so it's safe
+	 * to save the vif pointer during d0i3 entrance.
+	 */
+	data->connected_vif = vif;
 }
 
 static void iwl_mvm_set_wowlan_data(struct iwl_mvm *mvm,
@@ -1261,6 +1268,10 @@ int iwl_mvm_enter_d0i3(struct iwl_op_mode *op_mode)
 
 	/* configure wowlan configuration only if needed */
 	if (mvm->d0i3_ap_sta_id != IWL_MVM_STATION_COUNT) {
+		iwl_mvm_wowlan_config_key_params(mvm,
+						 d0i3_iter_data.connected_vif,
+						 true, flags);
+
 		iwl_mvm_set_wowlan_data(mvm, &wowlan_config_cmd,
 					&d0i3_iter_data);
 
@@ -1290,25 +1301,30 @@ static void iwl_mvm_exit_d0i3_iterator(void *_data, u8 *mac,
 	iwl_mvm_update_d0i3_power_mode(mvm, vif, false, flags);
 }
 
-struct iwl_mvm_wakeup_reason_iter_data {
+struct iwl_mvm_d0i3_exit_work_iter_data {
 	struct iwl_mvm *mvm;
+	struct iwl_wowlan_status *status;
 	u32 wakeup_reasons;
 };
 
-static void iwl_mvm_d0i3_wakeup_reason_iter(void *_data, u8 *mac,
-					    struct ieee80211_vif *vif)
+static void iwl_mvm_d0i3_exit_work_iter(void *_data, u8 *mac,
+					struct ieee80211_vif *vif)
 {
-	struct iwl_mvm_wakeup_reason_iter_data *data = _data;
+	struct iwl_mvm_d0i3_exit_work_iter_data *data = _data;
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	u32 reasons = data->wakeup_reasons;
 
-	if (vif->type == NL80211_IFTYPE_STATION && vif->bss_conf.assoc &&
-	    data->mvm->d0i3_ap_sta_id == mvmvif->ap_sta_id) {
-		if (data->wakeup_reasons &
-		    IWL_WOWLAN_WAKEUP_BY_DISCONNECTION_ON_DEAUTH)
-			iwl_mvm_connection_loss(data->mvm, vif, "D0i3");
-		else
-			ieee80211_beacon_loss(vif);
-	}
+	/* consider only the relevant station interface */
+	if (vif->type != NL80211_IFTYPE_STATION || !vif->bss_conf.assoc ||
+	    data->mvm->d0i3_ap_sta_id != mvmvif->ap_sta_id)
+		return;
+
+	if (reasons & IWL_WOWLAN_WAKEUP_BY_DISCONNECTION_ON_DEAUTH)
+		iwl_mvm_connection_loss(data->mvm, vif, "D0i3");
+	else if (reasons & IWL_WOWLAN_WAKEUP_BY_DISCONNECTION_ON_MISSED_BEACON)
+		ieee80211_beacon_loss(vif);
+	else
+		iwl_mvm_d0i3_update_keys(data->mvm, vif, data->status);
 }
 
 void iwl_mvm_d0i3_enable_tx(struct iwl_mvm *mvm, __le16 *qos_seq)
@@ -1374,9 +1390,13 @@ static void iwl_mvm_d0i3_exit_work(struct work_struct *wk)
 		.id = WOWLAN_GET_STATUSES,
 		.flags = CMD_HIGH_PRIO | CMD_WANT_SKB,
 	};
+	struct iwl_mvm_d0i3_exit_work_iter_data iter_data = {
+		.mvm = mvm,
+	};
+
 	struct iwl_wowlan_status *status;
 	int ret;
-	u32 handled_reasons, wakeup_reasons = 0;
+	u32 wakeup_reasons = 0;
 	__le16 *qos_seq = NULL;
 
 	mutex_lock(&mvm->mutex);
@@ -1393,18 +1413,12 @@ static void iwl_mvm_d0i3_exit_work(struct work_struct *wk)
 
 	IWL_DEBUG_RPM(mvm, "wakeup reasons: 0x%x\n", wakeup_reasons);
 
-	handled_reasons = IWL_WOWLAN_WAKEUP_BY_DISCONNECTION_ON_MISSED_BEACON |
-				IWL_WOWLAN_WAKEUP_BY_DISCONNECTION_ON_DEAUTH;
-	if (wakeup_reasons & handled_reasons) {
-		struct iwl_mvm_wakeup_reason_iter_data data = {
-			.mvm = mvm,
-			.wakeup_reasons = wakeup_reasons,
-		};
-
-		ieee80211_iterate_active_interfaces(
-			mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
-			iwl_mvm_d0i3_wakeup_reason_iter, &data);
-	}
+	iter_data.wakeup_reasons = wakeup_reasons;
+	iter_data.status = status;
+	ieee80211_iterate_active_interfaces(mvm->hw,
+					    IEEE80211_IFACE_ITER_NORMAL,
+					    iwl_mvm_d0i3_exit_work_iter,
+					    &iter_data);
 out:
 	iwl_mvm_d0i3_enable_tx(mvm, qos_seq);
 
-- 
2.5.0

