Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47696 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758579Ab3BLQCO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 11:02:14 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH 03/15] iwlwifi: mvm: Update quota settings for all bindings
Date: Tue, 12 Feb 2013 17:01:55 +0100
Message-Id: <1360684927-1367-3-git-send-email-johannes@sipsolutions.net> (sfid-20130212_170228_740985_02BA6B84)
In-Reply-To: <1360684927-1367-1-git-send-email-johannes@sipsolutions.net>
References: <1360684891.29913.4.camel@jlt4.sipsolutions.net>
 <1360684927-1367-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

The FW scheduler, schedules the bindings over a session of 128
fragments (each is 4 TU long). The quota command should allocate
all the session fragments between all the bindings that require quota
allocation. Currently, use static allocation, where the fragments
are equally distributed between all data bindings.

Note, that not allocating all the session's fragments might cause
the FW scheduler to leave the medium unused.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api.h |  3 +++
 drivers/net/wireless/iwlwifi/mvm/quota.c  | 29 ++++++++++++++++++++++++-----
 2 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 9fd49db..23eebda 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -633,6 +633,9 @@ struct iwl_binding_cmd {
 	__le32 phy;
 } __packed; /* BINDING_CMD_API_S_VER_1 */
 
+/* The maximal number of fragments in the FW's schedule session */
+#define IWL_MVM_MAX_QUOTA 128
+
 /**
  * struct iwl_time_quota_data - configuration of time quota per binding
  * @id_and_color: ID and color of the relevant Binding
diff --git a/drivers/net/wireless/iwlwifi/mvm/quota.c b/drivers/net/wireless/iwlwifi/mvm/quota.c
index 2d4611a..9256284 100644
--- a/drivers/net/wireless/iwlwifi/mvm/quota.c
+++ b/drivers/net/wireless/iwlwifi/mvm/quota.c
@@ -131,7 +131,7 @@ static void iwl_mvm_quota_iterator(void *_data, u8 *mac,
 int iwl_mvm_update_quotas(struct iwl_mvm *mvm, struct ieee80211_vif *newvif)
 {
 	struct iwl_time_quota_cmd cmd;
-	int i, idx, ret;
+	int i, idx, ret, num_active_bindings, quota, quota_rem;
 	struct iwl_mvm_quota_iterator_data data = {
 		.n_interfaces = {},
 		.colors = { -1, -1, -1, -1 },
@@ -156,20 +156,39 @@ int iwl_mvm_update_quotas(struct iwl_mvm *mvm, struct ieee80211_vif *newvif)
 		iwl_mvm_quota_iterator(&data, newvif->addr, newvif);
 	}
 
+	/*
+	 * The FW's scheduling session consists of
+	 * IWL_MVM_MAX_QUOTA fragments. Divide these fragments
+	 * equally between all the bindings that require quota
+	 */
+	num_active_bindings = 0;
+	for (i = 0; i < MAX_BINDINGS; i++) {
+		cmd.quotas[i].id_and_color = cpu_to_le32(FW_CTXT_INVALID);
+		if (data.n_interfaces[i] > 0)
+			num_active_bindings++;
+	}
+
+	if (!num_active_bindings)
+		goto send_cmd;
+
+	quota = IWL_MVM_MAX_QUOTA / num_active_bindings;
+	quota_rem = IWL_MVM_MAX_QUOTA % num_active_bindings;
+
 	for (idx = 0, i = 0; i < MAX_BINDINGS; i++) {
 		if (data.n_interfaces[i] <= 0)
 			continue;
 
 		cmd.quotas[idx].id_and_color =
 			cpu_to_le32(FW_CMD_ID_AND_COLOR(i, data.colors[i]));
-		cmd.quotas[idx].quota = cpu_to_le32(100);
-		cmd.quotas[idx].max_duration = cpu_to_le32(1000);
+		cmd.quotas[idx].quota = cpu_to_le32(quota);
+		cmd.quotas[idx].max_duration = cpu_to_le32(IWL_MVM_MAX_QUOTA);
 		idx++;
 	}
 
-	for (i = idx; i < MAX_BINDINGS; i++)
-		cmd.quotas[i].id_and_color = cpu_to_le32(FW_CTXT_INVALID);
+	/* Give the remainder of the session to the first binding */
+	le32_add_cpu(&cmd.quotas[0].quota, quota_rem);
 
+send_cmd:
 	ret = iwl_mvm_send_cmd_pdu(mvm, TIME_QUOTA_CMD, CMD_SYNC,
 				   sizeof(cmd), &cmd);
 	if (ret)
-- 
1.8.0

