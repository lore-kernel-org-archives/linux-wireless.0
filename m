Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42471 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411AbbAVUeC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:34:02 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 14/38] iwlwifi: mvm: add debugfs file for misbehaving U-APSD AP
Date: Thu, 22 Jan 2015 22:33:05 +0200
Message-Id: <1421958809-3371-14-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_213413_080227_37AB6978)
In-Reply-To: <1421958313.6424.2.camel@egrumbacBox>
References: <1421958313.6424.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

As this functionality relies on getting a firmware notification
it is difficult to test. Allow accessing the data for it from
debugfs to be able to trigger all kinds of scenarios to test.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c | 31 ++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
index 8dc3ca9..5fe1459 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
@@ -517,6 +517,34 @@ static ssize_t iwl_dbgfs_low_latency_read(struct file *file,
 	return simple_read_from_buffer(user_buf, count, ppos, buf, sizeof(buf));
 }
 
+static ssize_t iwl_dbgfs_uapsd_misbehaving_read(struct file *file,
+						char __user *user_buf,
+						size_t count, loff_t *ppos)
+{
+	struct ieee80211_vif *vif = file->private_data;
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	char buf[20];
+	int len;
+
+	len = sprintf(buf, "%pM\n", mvmvif->uapsd_misbehaving_bssid);
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t iwl_dbgfs_uapsd_misbehaving_write(struct ieee80211_vif *vif,
+						 char *buf, size_t count,
+						 loff_t *ppos)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_mvm *mvm = mvmvif->mvm;
+	bool ret;
+
+	mutex_lock(&mvm->mutex);
+	ret = mac_pton(buf, mvmvif->uapsd_misbehaving_bssid);
+	mutex_unlock(&mvm->mutex);
+
+	return ret ? count : -EINVAL;
+}
+
 #define MVM_DEBUGFS_WRITE_FILE_OPS(name, bufsz) \
 	_MVM_DEBUGFS_WRITE_FILE_OPS(name, bufsz, struct ieee80211_vif)
 #define MVM_DEBUGFS_READ_WRITE_FILE_OPS(name, bufsz) \
@@ -531,6 +559,7 @@ MVM_DEBUGFS_READ_FILE_OPS(mac_params);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(pm_params, 32);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(bf_params, 256);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(low_latency, 10);
+MVM_DEBUGFS_READ_WRITE_FILE_OPS(uapsd_misbehaving, 20);
 
 void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 {
@@ -564,6 +593,8 @@ void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	MVM_DEBUGFS_ADD_FILE_VIF(mac_params, mvmvif->dbgfs_dir, S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE_VIF(low_latency, mvmvif->dbgfs_dir,
 				 S_IRUSR | S_IWUSR);
+	MVM_DEBUGFS_ADD_FILE_VIF(uapsd_misbehaving, mvmvif->dbgfs_dir,
+				 S_IRUSR | S_IWUSR);
 
 	if (vif->type == NL80211_IFTYPE_STATION && !vif->p2p &&
 	    mvmvif == mvm->bf_allowed_vif)
-- 
1.9.1

