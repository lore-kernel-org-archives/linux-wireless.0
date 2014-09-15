Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:53624 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbaIOFN1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:13:27 -0400
Received: by mail-wg0-f46.google.com with SMTP id n12so3288080wgh.5
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 22:13:26 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/28] iwlwifi: mvm: don't update quota in firmware too often
Date: Mon, 15 Sep 2014 08:12:47 +0300
Message-Id: <1410757980-2138-15-git-send-email-egrumbach@gmail.com> (sfid-20140915_073113_861374_CC4451B9)
In-Reply-To: <5416742C.3070804@gmail.com>
References: <5416742C.3070804@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When updating quota in the firmware, it has to reset quite a bit
of internal state, which apparently can have an adverse impact on
its operation.

Avoid that by only updating the quota command when there are any
signification changes, i.e. added/removed bindings or changes in
quota that are bigger than 8 TU within a binding.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/constants.h |  1 +
 drivers/net/wireless/iwlwifi/mvm/fw.c        |  3 +++
 drivers/net/wireless/iwlwifi/mvm/mvm.h       |  2 ++
 drivers/net/wireless/iwlwifi/mvm/quota.c     | 33 +++++++++++++++++++++++-----
 4 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/constants.h b/drivers/net/wireless/iwlwifi/mvm/constants.h
index cb48656..1181089 100644
--- a/drivers/net/wireless/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/iwlwifi/mvm/constants.h
@@ -87,5 +87,6 @@
 #define IWL_MVM_BT_COEX_CORUNNING		1
 #define IWL_MVM_BT_COEX_MPLUT			1
 #define IWL_MVM_FW_MCAST_FILTER_PASS_ALL	0
+#define IWL_MVM_QUOTA_THRESHOLD			8
 
 #endif /* __MVM_CONSTANTS_H */
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index 21d60602..23fd711 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -454,6 +454,9 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	for (i = 0; i < IWL_MVM_STATION_COUNT; i++)
 		RCU_INIT_POINTER(mvm->fw_id_to_mac_id[i], NULL);
 
+	/* reset quota debouncing buffer - 0xff will yield invalid data */
+	memset(&mvm->last_quota_cmd, 0xff, sizeof(mvm->last_quota_cmd));
+
 	/* Add auxiliary station for scanning */
 	ret = iwl_mvm_add_aux_sta(mvm);
 	if (ret)
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index e292de9..f05b7d7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -709,6 +709,8 @@ struct iwl_mvm {
 	 */
 	bool temperature_test;  /* Debug test temperature is enabled */
 
+	struct iwl_time_quota_cmd last_quota_cmd;
+
 #ifdef CONFIG_NL80211_TESTMODE
 	u32 noa_duration;
 	struct ieee80211_vif *noa_vif;
diff --git a/drivers/net/wireless/iwlwifi/mvm/quota.c b/drivers/net/wireless/iwlwifi/mvm/quota.c
index 5fd502d..1eab2f2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/quota.c
+++ b/drivers/net/wireless/iwlwifi/mvm/quota.c
@@ -175,12 +175,14 @@ int iwl_mvm_update_quotas(struct iwl_mvm *mvm,
 			  struct ieee80211_vif *disabled_vif)
 {
 	struct iwl_time_quota_cmd cmd = {};
-	int i, idx, ret, num_active_macs, quota, quota_rem, n_non_lowlat;
+	int i, idx, err, num_active_macs, quota, quota_rem, n_non_lowlat;
 	struct iwl_mvm_quota_iterator_data data = {
 		.n_interfaces = {},
 		.colors = { -1, -1, -1, -1 },
 		.disabled_vif = disabled_vif,
 	};
+	struct iwl_time_quota_cmd *last = &mvm->last_quota_cmd;
+	bool send = false;
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -293,15 +295,34 @@ int iwl_mvm_update_quotas(struct iwl_mvm *mvm,
 
 	/* check that we have non-zero quota for all valid bindings */
 	for (i = 0; i < MAX_BINDINGS; i++) {
+		if (cmd.quotas[i].id_and_color != last->quotas[i].id_and_color)
+			send = true;
+		if (cmd.quotas[i].max_duration != last->quotas[i].max_duration)
+			send = true;
+		if (abs((int)le32_to_cpu(cmd.quotas[i].quota) -
+			(int)le32_to_cpu(last->quotas[i].quota))
+						> IWL_MVM_QUOTA_THRESHOLD)
+			send = true;
 		if (cmd.quotas[i].id_and_color == cpu_to_le32(FW_CTXT_INVALID))
 			continue;
 		WARN_ONCE(cmd.quotas[i].quota == 0,
 			  "zero quota on binding %d\n", i);
 	}
 
-	ret = iwl_mvm_send_cmd_pdu(mvm, TIME_QUOTA_CMD, 0,
-				   sizeof(cmd), &cmd);
-	if (ret)
-		IWL_ERR(mvm, "Failed to send quota: %d\n", ret);
-	return ret;
+	if (send) {
+		err = iwl_mvm_send_cmd_pdu(mvm, TIME_QUOTA_CMD, 0,
+					   sizeof(cmd), &cmd);
+	} else {
+		/* don't send a practically unchanged command, the firmware has
+		 * to re-initialize a lot of state and that can have an adverse
+		 * impact on it
+		 */
+		err = 0;
+	}
+
+	if (err)
+		IWL_ERR(mvm, "Failed to send quota: %d\n", err);
+	else
+		mvm->last_quota_cmd = cmd;
+	return err;
 }
-- 
1.9.1

