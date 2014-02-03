Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:34653 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391AbaBCU6l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:58:41 -0500
Received: by mail-ee0-f52.google.com with SMTP id e53so3885907eek.39
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:58:39 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 16/62] iwlwifi: mvm: add low-latency framework
Date: Mon,  3 Feb 2014 22:57:22 +0200
Message-Id: <1391461088-8082-16-git-send-email-egrumbach@gmail.com> (sfid-20140203_220008_553370_7A154955)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For various traffic use cases, we want to be able to treat multi-
channel scenarios differently. Introduce a low-latency framework
that currently only has a debugfs file to enable low-latency mode,
but can later be extended.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c |   38 ++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h         |   25 +++++++++++++++-
 drivers/net/wireless/iwlwifi/mvm/utils.c       |   12 ++++++++
 3 files changed, 74 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
index 0e29cd8..19ecade 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
@@ -460,6 +460,41 @@ static ssize_t iwl_dbgfs_bf_params_read(struct file *file,
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
+static ssize_t iwl_dbgfs_low_latency_write(struct ieee80211_vif *vif, char *buf,
+					   size_t count, loff_t *ppos)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_mvm *mvm = mvmvif->mvm;
+	u8 value;
+	int ret;
+
+	ret = kstrtou8(buf, 0, &value);
+	if (ret)
+		return ret;
+	if (value > 1)
+		return -EINVAL;
+
+	mutex_lock(&mvm->mutex);
+	iwl_mvm_update_low_latency(mvm, vif, value);
+	mutex_unlock(&mvm->mutex);
+
+	return count;
+}
+
+static ssize_t iwl_dbgfs_low_latency_read(struct file *file,
+					  char __user *user_buf,
+					  size_t count, loff_t *ppos)
+{
+	struct ieee80211_vif *vif = file->private_data;
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	char buf[3];
+
+	buf[0] = mvmvif->low_latency ? '1' : '0';
+	buf[1] = '\n';
+	buf[2] = '\0';
+	return simple_read_from_buffer(user_buf, count, ppos, buf, sizeof(buf));
+}
+
 #define MVM_DEBUGFS_WRITE_FILE_OPS(name, bufsz) \
 	_MVM_DEBUGFS_WRITE_FILE_OPS(name, bufsz, struct ieee80211_vif)
 #define MVM_DEBUGFS_READ_WRITE_FILE_OPS(name, bufsz) \
@@ -473,6 +508,7 @@ static ssize_t iwl_dbgfs_bf_params_read(struct file *file,
 MVM_DEBUGFS_READ_FILE_OPS(mac_params);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(pm_params, 32);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(bf_params, 256);
+MVM_DEBUGFS_READ_WRITE_FILE_OPS(low_latency, 10);
 
 void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 {
@@ -505,6 +541,8 @@ void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 	MVM_DEBUGFS_ADD_FILE_VIF(mac_params, mvmvif->dbgfs_dir,
 				 S_IRUSR);
+	MVM_DEBUGFS_ADD_FILE_VIF(low_latency, mvmvif->dbgfs_dir,
+				 S_IRUSR | S_IWUSR);
 
 	if (vif->type == NL80211_IFTYPE_STATION && !vif->p2p &&
 	    mvmvif == mvm->bf_allowed_vif)
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 02e4bdc..00bc4ce 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -269,7 +269,9 @@ struct iwl_mvm_vif_bf_data {
  * @ap_ibss_active: indicates that AP/IBSS is configured and that the interface
  *	should get quota etc.
  * @monitor_active: indicates that monitor context is configured, and that the
- * interface should get quota etc.
+ *	interface should get quota etc.
+ * @low_latency: indicates that this interface is in low-latency mode
+ *	(VMACLowLatencyMode)
  * @queue_params: QoS params for this MAC
  * @bcast_sta: station used for broadcast packets. Used by the following
  *  vifs: P2P_DEVICE, GO and AP.
@@ -285,6 +287,7 @@ struct iwl_mvm_vif {
 	bool uploaded;
 	bool ap_ibss_active;
 	bool monitor_active;
+	bool low_latency;
 	struct iwl_mvm_vif_bf_data bf_data;
 
 	u32 ap_beacon_time;
@@ -909,6 +912,26 @@ void iwl_mvm_update_smps(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 				enum iwl_mvm_smps_type_request req_type,
 				enum ieee80211_smps_mode smps_request);
 
+/* Low latency */
+int iwl_mvm_update_low_latency(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+			       bool value);
+/* get VMACLowLatencyMode */
+static inline bool iwl_mvm_vif_low_latency(struct iwl_mvm_vif *mvmvif)
+{
+	/*
+	 * should this consider associated/active/... state?
+	 *
+	 * Normally low-latency should only be active on interfaces
+	 * that are active, but at least with debugfs it can also be
+	 * enabled on interfaces that aren't active. However, when
+	 * interface aren't active then they aren't added into the
+	 * binding, so this has no real impact. For now, just return
+	 * the current desired low-latency state.
+	 */
+
+	return mvmvif->low_latency;
+}
+
 /* Thermal management and CT-kill */
 void iwl_mvm_tt_handler(struct iwl_mvm *mvm);
 void iwl_mvm_tt_initialize(struct iwl_mvm *mvm);
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index a4a5e25..e2cc876 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -536,3 +536,15 @@ void iwl_mvm_update_smps(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	ieee80211_request_smps(vif, smps_mode);
 }
+
+int iwl_mvm_update_low_latency(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+			       bool value)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+
+	lockdep_assert_held(&mvm->mutex);
+
+	mvmvif->low_latency = value;
+
+	return iwl_mvm_update_quotas(mvm, NULL);
+}
-- 
1.7.9.5

