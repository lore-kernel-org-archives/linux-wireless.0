Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:9395 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757312AbcAaLGq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 06:06:46 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 17/31] iwlwifi: mvm: track low-latency sources separately
Date: Sun, 31 Jan 2016 13:06:12 +0200
Message-Id: <1454238386-27032-17-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160131_120653_948974_0151EC51)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

To be able to test low-latency behaviour properly, split the
different low-latency sources so that setting any one of them,
for example from debugfs, is sufficient; this avoids getting
the debug setting overwritten by other sources.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c | 19 ++++++++++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h         | 12 +++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c       |  6 ++----
 3 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
index 9e0d463..c286a5f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
@@ -7,6 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
+ * Copyright(c) 2016        Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -33,6 +34,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
+ * Copyright(c) 2016        Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -1255,6 +1257,7 @@ static ssize_t iwl_dbgfs_low_latency_write(struct ieee80211_vif *vif, char *buf,
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mvm *mvm = mvmvif->mvm;
+	bool prev;
 	u8 value;
 	int ret;
 
@@ -1265,7 +1268,9 @@ static ssize_t iwl_dbgfs_low_latency_write(struct ieee80211_vif *vif, char *buf,
 		return -EINVAL;
 
 	mutex_lock(&mvm->mutex);
-	iwl_mvm_update_low_latency(mvm, vif, value);
+	prev = iwl_mvm_vif_low_latency(mvmvif);
+	mvmvif->low_latency_dbgfs = value;
+	iwl_mvm_update_low_latency(mvm, vif, prev);
 	mutex_unlock(&mvm->mutex);
 
 	return count;
@@ -1277,11 +1282,15 @@ static ssize_t iwl_dbgfs_low_latency_read(struct file *file,
 {
 	struct ieee80211_vif *vif = file->private_data;
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	char buf[2];
+	char buf[30] = {};
+	int len;
 
-	buf[0] = mvmvif->low_latency ? '1' : '0';
-	buf[1] = '\n';
-	return simple_read_from_buffer(user_buf, count, ppos, buf, sizeof(buf));
+	len = snprintf(buf, sizeof(buf) - 1,
+		       "traffic=%d\ndbgfs=%d\nvcmd=%d\n",
+		       mvmvif->low_latency_traffic,
+		       mvmvif->low_latency_dbgfs,
+		       mvmvif->low_latency_vcmd);
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
 static ssize_t iwl_dbgfs_uapsd_misbehaving_read(struct file *file,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index b45cf4f..418aeff 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -346,8 +346,9 @@ struct iwl_mvm_vif_bf_data {
  * @pm_enabled - Indicate if MAC power management is allowed
  * @monitor_active: indicates that monitor context is configured, and that the
  *	interface should get quota etc.
- * @low_latency: indicates that this interface is in low-latency mode
- *	(VMACLowLatencyMode)
+ * @low_latency_traffic: indicates low latency traffic was detected
+ * @low_latency_dbgfs: low latency mode set from debugfs
+ * @low_latency_vcmd: low latency mode set from vendor command
  * @ps_disabled: indicates that this interface requires PS to be disabled
  * @queue_params: QoS params for this MAC
  * @bcast_sta: station used for broadcast packets. Used by the following
@@ -375,7 +376,7 @@ struct iwl_mvm_vif {
 	bool ap_ibss_active;
 	bool pm_enabled;
 	bool monitor_active;
-	bool low_latency;
+	bool low_latency_traffic, low_latency_dbgfs, low_latency_vcmd;
 	bool ps_disabled;
 	struct iwl_mvm_vif_bf_data bf_data;
 
@@ -1427,8 +1428,9 @@ static inline bool iwl_mvm_vif_low_latency(struct iwl_mvm_vif *mvmvif)
 	 * binding, so this has no real impact. For now, just return
 	 * the current desired low-latency state.
 	 */
-
-	return mvmvif->low_latency;
+	return mvmvif->low_latency_dbgfs ||
+	       mvmvif->low_latency_traffic ||
+	       mvmvif->low_latency_vcmd;
 }
 
 /* hw scheduler queue config */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 3a989f5..59453c1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -937,18 +937,16 @@ bool iwl_mvm_rx_diversity_allowed(struct iwl_mvm *mvm)
 }
 
 int iwl_mvm_update_low_latency(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-			       bool value)
+			       bool prev)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	int res;
 
 	lockdep_assert_held(&mvm->mutex);
 
-	if (mvmvif->low_latency == value)
+	if (iwl_mvm_vif_low_latency(mvmvif) == prev)
 		return 0;
 
-	mvmvif->low_latency = value;
-
 	res = iwl_mvm_update_quotas(mvm, false, NULL);
 	if (res)
 		return res;
-- 
2.5.0

