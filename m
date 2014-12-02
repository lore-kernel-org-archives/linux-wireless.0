Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:61682 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbaLBSRs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 13:17:48 -0500
Received: by mail-wg0-f47.google.com with SMTP id n12so17691569wgh.6
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2014 10:17:47 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/26] iwlwifi: mvm: check and report if wake up was due to net detect
Date: Tue,  2 Dec 2014 20:10:53 +0200
Message-Id: <1417543877-24193-2-git-send-email-egrumbach@gmail.com> (sfid-20141202_191751_932663_41DBC46F)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Query the firmware for scan offload matches when waking up in order to
report net detect as the reason for the wake up.

This requires a new command API to be implemented.  Additionally,
remove some net detect command entries that are not valid anymore.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c          | 46 ++++++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h | 44 ++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/fw-api.h      |  8 ++---
 drivers/net/wireless/iwlwifi/mvm/ops.c         |  8 ++---
 4 files changed, 94 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 60748bd..8970386 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -1626,14 +1626,50 @@ out_unlock:
 	return false;
 }
 
+static u32 iwl_mvm_netdetect_query_results(struct iwl_mvm *mvm)
+{
+	struct iwl_scan_offload_profiles_query *query;
+	struct iwl_host_cmd cmd = {
+		.id = SCAN_OFFLOAD_PROFILES_QUERY_CMD,
+		.flags = CMD_WANT_SKB,
+	};
+	int ret, len;
+
+	ret = iwl_mvm_send_cmd(mvm, &cmd);
+	if (ret) {
+		IWL_ERR(mvm, "failed to query matched profiles (%d)\n", ret);
+		return 0;
+	}
+
+	/* RF-kill already asserted again... */
+	if (!cmd.resp_pkt)
+		goto out_free_resp;
+
+	len = iwl_rx_packet_payload_len(cmd.resp_pkt);
+	if (len < sizeof(*query)) {
+		IWL_ERR(mvm, "Invalid scan offload profiles query response!\n");
+		goto out_free_resp;
+	}
+
+	query = (void *)cmd.resp_pkt->data;
+
+	ret = le32_to_cpu(query->matched_profiles);
+
+out_free_resp:
+	iwl_free_resp(&cmd);
+	return ret;
+}
+
 static void iwl_mvm_query_netdetect_reasons(struct iwl_mvm *mvm,
 					    struct ieee80211_vif *vif)
 {
+	struct cfg80211_wowlan_nd_info net_detect = {};
 	struct cfg80211_wowlan_wakeup wakeup = {
 		.pattern_idx = -1,
 	};
 	struct cfg80211_wowlan_wakeup *wakeup_report = &wakeup;
 	struct iwl_wowlan_status *fw_status;
+	u32 matched_profiles;
 	u32 reasons = 0;
 
 	fw_status = iwl_mvm_get_wakeup_status(mvm, vif);
@@ -1643,11 +1679,17 @@ static void iwl_mvm_query_netdetect_reasons(struct iwl_mvm *mvm,
 	if (reasons & IWL_WOWLAN_WAKEUP_BY_RFKILL_DEASSERTED)
 		wakeup.rfkill_release = true;
 
-	if (reasons == IWL_WOWLAN_WAKEUP_BY_NON_WIRELESS) {
-		/* TODO: read and check if it was netdetect */
+	if (reasons != IWL_WOWLAN_WAKEUP_BY_NON_WIRELESS)
+		goto out;
+
+	matched_profiles = iwl_mvm_netdetect_query_results(mvm);
+	if (!matched_profiles) {
 		wakeup_report = NULL;
+		goto out;
 	}
 
+	wakeup.net_detect = &net_detect;
+out:
 	mutex_unlock(&mvm->mutex);
 	ieee80211_report_wowlan_wakeup(vif, wakeup_report, GFP_KERNEL);
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
index 7163eb3..1f2acf4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
@@ -1047,4 +1047,48 @@ struct iwl_umac_scan_complete {
 	__le32 reserved;
 } __packed; /* SCAN_COMPLETE_NTF_UMAC_API_S_VER_1 */
 
+#define SCAN_OFFLOAD_MATCHING_CHANNELS_LEN 5
+/**
+ * struct iwl_scan_offload_profile_match - match information
+ * @bssid: matched bssid
+ * @channel: channel where the match occurred
+ * @energy:
+ * @matching_feature:
+ * @matching_channels: bitmap of channels that matched, referencing
+ *	the channels passed in tue scan offload request
+ */
+struct iwl_scan_offload_profile_match {
+	u8 bssid[ETH_ALEN];
+	__le16 reserved;
+	u8 channel;
+	u8 energy;
+	u8 matching_feature;
+	u8 matching_channels[SCAN_OFFLOAD_MATCHING_CHANNELS_LEN];
+} __packed; /* SCAN_OFFLOAD_PROFILE_MATCH_RESULTS_S_VER_1 */
+
+/**
+ * struct iwl_scan_offload_profiles_query - match results query response
+ * @matched_profiles: bitmap of matched profiles, referencing the
+ *	matches passed in the scan offload request
+ * @last_scan_age: age of the last offloaded scan
+ * @n_scans_done: number of offloaded scans done
+ * @gp2_d0u: GP2 when D0U occurred
+ * @gp2_invoked: GP2 when scan offload was invoked
+ * @resume_while_scanning: not used
+ * @self_recovery: obsolete
+ * @reserved: reserved
+ * @matches: array of match information, one for each match
+ */
+struct iwl_scan_offload_profiles_query {
+	__le32 matched_profiles;
+	__le32 last_scan_age;
+	__le32 n_scans_done;
+	__le32 gp2_d0u;
+	__le32 gp2_invoked;
+	u8 resume_while_scanning;
+	u8 self_recovery;
+	__le16 reserved;
+	struct iwl_scan_offload_profile_match matches[IWL_SCAN_MAX_PROFILES];
+} __packed; /* SCAN_OFFLOAD_PROFILES_QUERY_RSP_S_VER_2 */
+
 #endif
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 2ff4f41..01d6f9e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -249,11 +249,9 @@ enum {
 	WOWLAN_TX_POWER_PER_DB = 0xe6,
 
 	/* and for NetDetect */
-	NET_DETECT_CONFIG_CMD = 0x54,
-	NET_DETECT_PROFILES_QUERY_CMD = 0x56,
-	NET_DETECT_PROFILES_CMD = 0x57,
-	NET_DETECT_HOTSPOTS_CMD = 0x58,
-	NET_DETECT_HOTSPOTS_QUERY_CMD = 0x59,
+	SCAN_OFFLOAD_PROFILES_QUERY_CMD = 0x56,
+	SCAN_OFFLOAD_HOTSPOTS_CONFIG_CMD = 0x58,
+	SCAN_OFFLOAD_HOTSPOTS_QUERY_CMD = 0x59,
 
 	REPLY_MAX = 0xff,
 };
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index b3ae094..b952e79 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -325,11 +325,9 @@ static const char *const iwl_mvm_cmd_strings[REPLY_MAX] = {
 	CMD(WOWLAN_KEK_KCK_MATERIAL),
 	CMD(WOWLAN_GET_STATUSES),
 	CMD(WOWLAN_TX_POWER_PER_DB),
-	CMD(NET_DETECT_CONFIG_CMD),
-	CMD(NET_DETECT_PROFILES_QUERY_CMD),
-	CMD(NET_DETECT_PROFILES_CMD),
-	CMD(NET_DETECT_HOTSPOTS_CMD),
-	CMD(NET_DETECT_HOTSPOTS_QUERY_CMD),
+	CMD(SCAN_OFFLOAD_PROFILES_QUERY_CMD),
+	CMD(SCAN_OFFLOAD_HOTSPOTS_CONFIG_CMD),
+	CMD(SCAN_OFFLOAD_HOTSPOTS_QUERY_CMD),
 	CMD(CARD_STATE_NOTIFICATION),
 	CMD(MISSED_BEACONS_NOTIFICATION),
 	CMD(BT_COEX_PRIO_TABLE),
-- 
1.9.1

