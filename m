Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23998 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbbJYMBj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 08:01:39 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Avraham Stern <avraham.stern@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/16] iwlwifi: mvm: Add support for two scheduled scan plans
Date: Sun, 25 Oct 2015 14:01:09 +0200
Message-Id: <1445774476-24792-9-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151025_130143_183277_8AF6312A)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8AF6CC@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8AF6CC@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

Add support for two scan plans for scheduled scan. The first plan
will run for a limited number of iterations, then the second plan
will run infinitely.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h |   5 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c    |   8 ++
 drivers/net/wireless/iwlwifi/mvm/scan.c        | 116 ++++++++++++++++---------
 3 files changed, 87 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
index 660cc1c..3a657e4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
@@ -101,6 +101,7 @@ struct iwl_ssid_ie {
 
 #define IWL_FULL_SCAN_MULTIPLIER 5
 #define IWL_FAST_SCHED_SCAN_ITERATIONS 3
+#define IWL_MAX_SCHED_SCAN_PLANS 2
 
 enum scan_framework_client {
 	SCAN_CLIENT_SCHED_SCAN		= BIT(0),
@@ -359,7 +360,7 @@ struct iwl_scan_req_lmac {
 	/* SCAN_REQ_PERIODIC_PARAMS_API_S */
 	__le32 iter_num;
 	__le32 delay;
-	struct iwl_scan_schedule_lmac schedule[2];
+	struct iwl_scan_schedule_lmac schedule[IWL_MAX_SCHED_SCAN_PLANS];
 	struct iwl_scan_channel_opt channel_opt[2];
 	u8 data[];
 } __packed;
@@ -582,7 +583,7 @@ struct iwl_scan_umac_schedule {
  */
 struct iwl_scan_req_umac_tail {
 	/* SCAN_PERIODIC_PARAMS_API_S_VER_1 */
-	struct iwl_scan_umac_schedule schedule[2];
+	struct iwl_scan_umac_schedule schedule[IWL_MAX_SCHED_SCAN_PLANS];
 	__le16 delay;
 	__le16 reserved;
 	/* SCAN_PROBE_PARAMS_API_S_VER_1 */
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index adfcce4..5ce29ff 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -572,6 +572,14 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	/* we create the 802.11 header and zero length SSID IE. */
 	hw->wiphy->max_sched_scan_ie_len =
 		SCAN_OFFLOAD_PROBE_REQ_SIZE - 24 - 2;
+	hw->wiphy->max_sched_scan_plans = IWL_MAX_SCHED_SCAN_PLANS;
+	hw->wiphy->max_sched_scan_plan_interval = U16_MAX;
+
+	/*
+	 * the firmware uses u8 for num of iterations, but 0xff is saved for
+	 * infinite loop, so the maximum number of iterations is actually 254.
+	 */
+	hw->wiphy->max_sched_scan_plan_iterations = 254;
 
 	hw->wiphy->features |= NL80211_FEATURE_P2P_GO_CTWIN |
 			       NL80211_FEATURE_LOW_PRIORITY_SCAN |
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index cee4f26..ed15b50 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -131,7 +131,6 @@ struct iwl_mvm_scan_params {
 	int n_ssids;
 	struct cfg80211_ssid *ssids;
 	struct ieee80211_channel **channels;
-	u16 interval; /* interval between scans (in secs) */
 	u32 flags;
 	u8 *mac_addr;
 	u8 *mac_addr_mask;
@@ -140,7 +139,8 @@ struct iwl_mvm_scan_params {
 	int n_match_sets;
 	struct iwl_scan_probe_req preq;
 	struct cfg80211_match_set *match_sets;
-	u8 iterations[2];
+	int n_scan_plans;
+	struct cfg80211_sched_scan_plan *scan_plans;
 };
 
 static u8 iwl_mvm_scan_rx_ant(struct iwl_mvm *mvm)
@@ -737,8 +737,7 @@ static inline bool iwl_mvm_scan_fits(struct iwl_mvm *mvm, int n_ssids,
 }
 
 static inline bool iwl_mvm_scan_use_ebs(struct iwl_mvm *mvm,
-					struct ieee80211_vif *vif,
-					int n_iterations)
+					struct ieee80211_vif *vif)
 {
 	const struct iwl_ucode_capabilities *capa = &mvm->fw->ucode_capa;
 
@@ -753,11 +752,6 @@ static inline bool iwl_mvm_scan_use_ebs(struct iwl_mvm *mvm,
 		vif->type != NL80211_IFTYPE_P2P_DEVICE);
 }
 
-static int iwl_mvm_scan_total_iterations(struct iwl_mvm_scan_params *params)
-{
-	return params->iterations[0] + params->iterations[1];
-}
-
 static int iwl_mvm_scan_lmac_flags(struct iwl_mvm *mvm,
 				   struct iwl_mvm_scan_params *params)
 {
@@ -796,12 +790,15 @@ static int iwl_mvm_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		(void *)(cmd->data + sizeof(struct iwl_scan_channel_cfg_lmac) *
 			 mvm->fw->ucode_capa.n_scan_channels);
 	u32 ssid_bitmap = 0;
-	int n_iterations = iwl_mvm_scan_total_iterations(params);
+	int i;
 
 	lockdep_assert_held(&mvm->mutex);
 
 	memset(cmd, 0, ksize(cmd));
 
+	if (WARN_ON(params->n_scan_plans > IWL_MAX_SCHED_SCAN_PLANS))
+		return -EINVAL;
+
 	iwl_mvm_scan_lmac_dwell(mvm, cmd, params);
 
 	cmd->rx_chain_select = iwl_mvm_scan_rx_chain(mvm);
@@ -821,14 +818,33 @@ static int iwl_mvm_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	/* this API uses bits 1-20 instead of 0-19 */
 	ssid_bitmap <<= 1;
 
-	cmd->schedule[0].delay = cpu_to_le16(params->interval);
-	cmd->schedule[0].iterations = params->iterations[0];
-	cmd->schedule[0].full_scan_mul = 1;
-	cmd->schedule[1].delay = cpu_to_le16(params->interval);
-	cmd->schedule[1].iterations = params->iterations[1];
-	cmd->schedule[1].full_scan_mul = 1;
+	for (i = 0; i < params->n_scan_plans; i++) {
+		struct wiphy *wiphy = mvm->hw->wiphy;
+		struct cfg80211_sched_scan_plan *scan_plan =
+			&params->scan_plans[i];
+
+		if (WARN_ON(scan_plan->iterations >
+			    wiphy->max_sched_scan_plan_iterations ||
+			    scan_plan->interval >
+			    wiphy->max_sched_scan_plan_interval))
+			return -EINVAL;
+
+		cmd->schedule[i].delay =
+			cpu_to_le16(scan_plan->interval);
+		cmd->schedule[i].iterations = scan_plan->iterations;
+		cmd->schedule[i].full_scan_mul = 1;
+	}
+
+	/*
+	 * If the number of iterations of the last scan plan is set to
+	 * zero, it should run infinitely. However, this is not always the case.
+	 * For example, when regular scan is requested the driver sets one scan
+	 * plan with one iteration.
+	 */
+	if (!cmd->schedule[i - 1].iterations)
+			cmd->schedule[i - 1].iterations = 0xff;
 
-	if (iwl_mvm_scan_use_ebs(mvm, vif, n_iterations)) {
+	if (iwl_mvm_scan_use_ebs(mvm, vif)) {
 		cmd->channel_opt[0].flags =
 			cpu_to_le16(IWL_SCAN_CHANNEL_FLAG_EBS |
 				    IWL_SCAN_CHANNEL_FLAG_EBS_ACCURATE |
@@ -968,6 +984,12 @@ static int iwl_mvm_scan_uid_by_status(struct iwl_mvm *mvm, int status)
 	return -ENOENT;
 }
 
+static inline bool iwl_mvm_is_regular_scan(struct iwl_mvm_scan_params *params)
+{
+	return params->n_scan_plans == 1 &&
+		params->scan_plans[0].iterations == 1;
+}
+
 static void iwl_mvm_scan_umac_dwell(struct iwl_mvm *mvm,
 				    struct iwl_scan_req_umac *cmd,
 				    struct iwl_mvm_scan_params *params)
@@ -980,7 +1002,7 @@ static void iwl_mvm_scan_umac_dwell(struct iwl_mvm *mvm,
 	cmd->scan_priority =
 		iwl_mvm_scan_priority(mvm, IWL_SCAN_PRIORITY_EXT_6);
 
-	if (iwl_mvm_scan_total_iterations(params) == 1)
+	if (iwl_mvm_is_regular_scan(params))
 		cmd->ooc_priority =
 			iwl_mvm_scan_priority(mvm, IWL_SCAN_PRIORITY_EXT_6);
 	else
@@ -1027,7 +1049,7 @@ static u32 iwl_mvm_scan_umac_flags(struct iwl_mvm *mvm,
 	else
 		flags |= IWL_UMAC_SCAN_GEN_FLAGS_MATCH;
 
-	if (iwl_mvm_scan_total_iterations(params) > 1)
+	if (!iwl_mvm_is_regular_scan(params))
 		flags |= IWL_UMAC_SCAN_GEN_FLAGS_PERIODIC;
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
@@ -1045,12 +1067,14 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	struct iwl_scan_req_umac_tail *sec_part = (void *)&cmd->data +
 		sizeof(struct iwl_scan_channel_cfg_umac) *
 			mvm->fw->ucode_capa.n_scan_channels;
-	int uid;
+	int uid, i;
 	u32 ssid_bitmap = 0;
-	int n_iterations = iwl_mvm_scan_total_iterations(params);
 
 	lockdep_assert_held(&mvm->mutex);
 
+	if (WARN_ON(params->n_scan_plans > IWL_MAX_SCHED_SCAN_PLANS))
+		return -EINVAL;
+
 	uid = iwl_mvm_scan_uid_by_status(mvm, 0);
 	if (uid < 0)
 		return uid;
@@ -1067,7 +1091,7 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	if (type == IWL_MVM_SCAN_SCHED)
 		cmd->flags = cpu_to_le32(IWL_UMAC_SCAN_FLAG_PREEMPTIVE);
 
-	if (iwl_mvm_scan_use_ebs(mvm, vif, n_iterations))
+	if (iwl_mvm_scan_use_ebs(mvm, vif))
 		cmd->channel_flags = IWL_SCAN_CHANNEL_FLAG_EBS |
 				     IWL_SCAN_CHANNEL_FLAG_EBS_ACCURATE |
 				     IWL_SCAN_CHANNEL_FLAG_CACHE_ADD;
@@ -1079,12 +1103,30 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	iwl_mvm_umac_scan_cfg_channels(mvm, params->channels,
 				       params->n_channels, ssid_bitmap, cmd);
 
-	/* With UMAC we use only one schedule for now, so use the sum
-	 * of the iterations (with a a maximum of 255).
+	for (i = 0; i < params->n_scan_plans; i++) {
+		struct wiphy *wiphy = mvm->hw->wiphy;
+		struct cfg80211_sched_scan_plan *scan_plan =
+			&params->scan_plans[i];
+
+		if (WARN_ON(scan_plan->iterations >
+			    wiphy->max_sched_scan_plan_iterations ||
+			    scan_plan->interval >
+			    wiphy->max_sched_scan_plan_interval))
+			return -EINVAL;
+
+		sec_part->schedule[i].iter_count = scan_plan->iterations;
+		sec_part->schedule[i].interval =
+			cpu_to_le16(scan_plan->interval);
+	}
+
+	/*
+	 * If the number of iterations of the last scan plan is set to
+	 * zero, it should run infinitely. However, this is not always the case.
+	 * For example, when regular scan is requested the driver sets one scan
+	 * plan with one iteration.
 	 */
-	sec_part->schedule[0].iter_count =
-		(n_iterations > 255) ? 255 : n_iterations;
-	sec_part->schedule[0].interval = cpu_to_le16(params->interval);
+	if (!sec_part->schedule[i - 1].iter_count)
+		sec_part->schedule[i - 1].iter_count = 0xff;
 
 	sec_part->delay = cpu_to_le16(params->delay);
 	sec_part->preq = params->preq;
@@ -1150,6 +1192,7 @@ int iwl_mvm_reg_scan_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	};
 	struct iwl_mvm_scan_params params = {};
 	int ret;
+	struct cfg80211_sched_scan_plan scan_plan = { .iterations = 1 };
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -1175,7 +1218,6 @@ int iwl_mvm_reg_scan_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	params.flags = req->flags;
 	params.n_channels = req->n_channels;
 	params.delay = 0;
-	params.interval = 0;
 	params.ssids = req->ssids;
 	params.channels = req->channels;
 	params.mac_addr = req->mac_addr;
@@ -1185,8 +1227,8 @@ int iwl_mvm_reg_scan_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	params.n_match_sets = 0;
 	params.match_sets = NULL;
 
-	params.iterations[0] = 1;
-	params.iterations[1] = 0;
+	params.scan_plans = &scan_plan;
+	params.n_scan_plans = 1;
 
 	params.type = iwl_mvm_get_scan_type(mvm, vif, &params);
 
@@ -1265,20 +1307,14 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 	params.pass_all =  iwl_mvm_scan_pass_all(mvm, req);
 	params.n_match_sets = req->n_match_sets;
 	params.match_sets = req->match_sets;
+	if (!req->n_scan_plans)
+		return -EINVAL;
 
-	params.iterations[0] = 0;
-	params.iterations[1] = 0xff;
+	params.n_scan_plans = req->n_scan_plans;
+	params.scan_plans = req->scan_plans;
 
 	params.type = iwl_mvm_get_scan_type(mvm, vif, &params);
 
-	if (req->scan_plans[0].interval > U16_MAX) {
-		IWL_DEBUG_SCAN(mvm,
-			       "interval value is > 16-bits, set to max possible\n");
-		params.interval = U16_MAX;
-	} else {
-		params.interval = req->scan_plans[0].interval;
-	}
-
 	/* In theory, LMAC scans can handle a 32-bit delay, but since
 	 * waiting for over 18 hours to start the scan is a bit silly
 	 * and to keep it aligned with UMAC scans (which only support
-- 
2.1.4

