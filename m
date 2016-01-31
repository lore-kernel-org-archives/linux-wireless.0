Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:28518 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757307AbcAaLGr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 06:06:47 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 18/31] iwlwifi: mvm: support setting minimum quota from debugfs
Date: Sun, 31 Jan 2016 13:06:13 +0200
Message-Id: <1454238386-27032-18-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160131_120653_770066_5530F210)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For debug purposes, allow setting minimum quota (for a single
virtual interface) from debugfs. This is an absolute minimum,
so it can only be set up to 95%.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   | 56 ++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/quota.c     | 16 +++++++
 3 files changed, 73 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
index c286a5f..1400445 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
@@ -1372,6 +1372,59 @@ static ssize_t iwl_dbgfs_rx_phyinfo_read(struct file *file,
 	return simple_read_from_buffer(user_buf, count, ppos, buf, sizeof(buf));
 }
 
+static void iwl_dbgfs_quota_check(void *data, u8 *mac,
+				  struct ieee80211_vif *vif)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	int *ret = data;
+
+	if (mvmvif->dbgfs_quota_min)
+		*ret = -EINVAL;
+}
+
+static ssize_t iwl_dbgfs_quota_min_write(struct ieee80211_vif *vif, char *buf,
+					 size_t count, loff_t *ppos)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_mvm *mvm = mvmvif->mvm;
+	u16 value;
+	int ret;
+
+	ret = kstrtou16(buf, 0, &value);
+	if (ret)
+		return ret;
+
+	if (value > 95)
+		return -EINVAL;
+
+	mutex_lock(&mvm->mutex);
+
+	mvmvif->dbgfs_quota_min = 0;
+	ieee80211_iterate_interfaces(mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
+				     iwl_dbgfs_quota_check, &ret);
+	if (ret == 0) {
+		mvmvif->dbgfs_quota_min = value;
+		iwl_mvm_update_quotas(mvm, false, NULL);
+	}
+	mutex_unlock(&mvm->mutex);
+
+	return ret ?: count;
+}
+
+static ssize_t iwl_dbgfs_quota_min_read(struct file *file,
+					char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	struct ieee80211_vif *vif = file->private_data;
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	char buf[10];
+	int len;
+
+	len = snprintf(buf, sizeof(buf), "%d\n", mvmvif->dbgfs_quota_min);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
 #define MVM_DEBUGFS_WRITE_FILE_OPS(name, bufsz) \
 	_MVM_DEBUGFS_WRITE_FILE_OPS(name, bufsz, struct ieee80211_vif)
 #define MVM_DEBUGFS_READ_WRITE_FILE_OPS(name, bufsz) \
@@ -1395,6 +1448,7 @@ MVM_DEBUGFS_READ_WRITE_FILE_OPS(tof_range_req_ext, 32);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(tof_range_abort, 32);
 MVM_DEBUGFS_READ_FILE_OPS(tof_range_response);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(tof_responder_params, 32);
+MVM_DEBUGFS_READ_WRITE_FILE_OPS(quota_min, 32);
 
 void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 {
@@ -1432,6 +1486,8 @@ void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 				 S_IRUSR | S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE_VIF(rx_phyinfo, mvmvif->dbgfs_dir,
 				 S_IRUSR | S_IWUSR);
+	MVM_DEBUGFS_ADD_FILE_VIF(quota_min, mvmvif->dbgfs_dir,
+				 S_IRUSR | S_IWUSR);
 
 	if (vif->type == NL80211_IFTYPE_STATION && !vif->p2p &&
 	    mvmvif == mvm->bf_allowed_vif)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 418aeff..5a34808 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -433,6 +433,7 @@ struct iwl_mvm_vif {
 	struct iwl_dbgfs_pm dbgfs_pm;
 	struct iwl_dbgfs_bf dbgfs_bf;
 	struct iwl_mac_power_cmd mac_pwr_cmd;
+	int dbgfs_quota_min;
 #endif
 
 	enum ieee80211_smps_mode smps_requests[NUM_IWL_MVM_SMPS_REQ];
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/quota.c b/drivers/net/wireless/intel/iwlwifi/mvm/quota.c
index 0b762b4..2141db5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/quota.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/quota.c
@@ -7,6 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2016        Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -33,6 +34,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2016        Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -74,6 +76,9 @@ struct iwl_mvm_quota_iterator_data {
 	int n_interfaces[MAX_BINDINGS];
 	int colors[MAX_BINDINGS];
 	int low_latency[MAX_BINDINGS];
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	int dbgfs_min[MAX_BINDINGS];
+#endif
 	int n_low_latency_bindings;
 	struct ieee80211_vif *disabled_vif;
 };
@@ -129,6 +134,12 @@ static void iwl_mvm_quota_iterator(void *_data, u8 *mac,
 
 	data->n_interfaces[id]++;
 
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	if (mvmvif->dbgfs_quota_min)
+		data->dbgfs_min[id] = max(data->dbgfs_min[id],
+					  mvmvif->dbgfs_quota_min);
+#endif
+
 	if (iwl_mvm_vif_low_latency(mvmvif) && !data->low_latency[id]) {
 		data->n_low_latency_bindings++;
 		data->low_latency[id] = true;
@@ -259,6 +270,11 @@ int iwl_mvm_update_quotas(struct iwl_mvm *mvm,
 
 		if (data.n_interfaces[i] <= 0)
 			cmd.quotas[idx].quota = cpu_to_le32(0);
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+		else if (data.dbgfs_min[i])
+			cmd.quotas[idx].quota =
+				cpu_to_le32(data.dbgfs_min[i] * QUOTA_100 / 100);
+#endif
 		else if (data.n_low_latency_bindings == 1 && n_non_lowlat &&
 			 data.low_latency[i])
 			/*
-- 
2.5.0

