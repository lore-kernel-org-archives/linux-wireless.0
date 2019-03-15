Return-Path: <SRS0=bI0Y=RS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A7BAC10F00
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 16:36:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35E972077B
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 16:36:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729561AbfCOQgu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Mar 2019 12:36:50 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:44256 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729492AbfCOQgs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Mar 2019 12:36:48 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h4pp6-0004qp-LG; Fri, 15 Mar 2019 18:36:45 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 15 Mar 2019 18:36:23 +0200
Message-Id: <20190315163634.17315-6-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190315163634.17315-1-luca@coelho.fi>
References: <20190315163634.17315-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 05/16] iwlwifi: mvm: Support new format of SCAN_OFFLOAD_PROFILES_QUERY_RSP
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

Newer FWs use a new format of the SCAN_OFFLOAD_PROFILES_QUERY_RSP,
which now supports indicating match on an higher number of channels.

Modify the code to support both the old format and the newer one,
based on a FW TLV.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/fw/api/scan.h  | 54 ++++++++++-
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |  4 +
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c   | 89 +++++++++++++++----
 3 files changed, 128 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h b/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
index 890a939c463d..1a67a2a439ab 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
@@ -788,7 +788,53 @@ struct iwl_umac_scan_complete {
 	__le32 reserved;
 } __packed; /* SCAN_COMPLETE_NTF_UMAC_API_S_VER_1 */
 
-#define SCAN_OFFLOAD_MATCHING_CHANNELS_LEN 5
+#define SCAN_OFFLOAD_MATCHING_CHANNELS_LEN_V1 5
+#define SCAN_OFFLOAD_MATCHING_CHANNELS_LEN    7
+
+/**
+ * struct iwl_scan_offload_profile_match_v1 - match information
+ * @bssid: matched bssid
+ * @reserved: reserved
+ * @channel: channel where the match occurred
+ * @energy: energy
+ * @matching_feature: feature matches
+ * @matching_channels: bitmap of channels that matched, referencing
+ *	the channels passed in the scan offload request.
+ */
+struct iwl_scan_offload_profile_match_v1 {
+	u8 bssid[ETH_ALEN];
+	__le16 reserved;
+	u8 channel;
+	u8 energy;
+	u8 matching_feature;
+	u8 matching_channels[SCAN_OFFLOAD_MATCHING_CHANNELS_LEN_V1];
+} __packed; /* SCAN_OFFLOAD_PROFILE_MATCH_RESULTS_S_VER_1 */
+
+/**
+ * struct iwl_scan_offload_profiles_query_v1 - match results query response
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
+struct iwl_scan_offload_profiles_query_v1 {
+	__le32 matched_profiles;
+	__le32 last_scan_age;
+	__le32 n_scans_done;
+	__le32 gp2_d0u;
+	__le32 gp2_invoked;
+	u8 resume_while_scanning;
+	u8 self_recovery;
+	__le16 reserved;
+	struct iwl_scan_offload_profile_match_v1 matches[IWL_SCAN_MAX_PROFILES];
+} __packed; /* SCAN_OFFLOAD_PROFILES_QUERY_RSP_S_VER_2 */
+
 /**
  * struct iwl_scan_offload_profile_match - match information
  * @bssid: matched bssid
@@ -797,7 +843,7 @@ struct iwl_umac_scan_complete {
  * @energy: energy
  * @matching_feature: feature matches
  * @matching_channels: bitmap of channels that matched, referencing
- *	the channels passed in tue scan offload request
+ *	the channels passed in the scan offload request.
  */
 struct iwl_scan_offload_profile_match {
 	u8 bssid[ETH_ALEN];
@@ -806,7 +852,7 @@ struct iwl_scan_offload_profile_match {
 	u8 energy;
 	u8 matching_feature;
 	u8 matching_channels[SCAN_OFFLOAD_MATCHING_CHANNELS_LEN];
-} __packed; /* SCAN_OFFLOAD_PROFILE_MATCH_RESULTS_S_VER_1 */
+} __packed; /* SCAN_OFFLOAD_PROFILE_MATCH_RESULTS_S_VER_2 */
 
 /**
  * struct iwl_scan_offload_profiles_query - match results query response
@@ -831,7 +877,7 @@ struct iwl_scan_offload_profiles_query {
 	u8 self_recovery;
 	__le16 reserved;
 	struct iwl_scan_offload_profile_match matches[IWL_SCAN_MAX_PROFILES];
-} __packed; /* SCAN_OFFLOAD_PROFILES_QUERY_RSP_S_VER_2 */
+} __packed; /* SCAN_OFFLOAD_PROFILES_QUERY_RSP_S_VER_3 */
 
 /**
  * struct iwl_umac_scan_iter_complete_notif - notifies end of scanning iteration
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index 3f26dee1b29c..b7328861c725 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -276,6 +276,9 @@ typedef unsigned int __bitwise iwl_ucode_tlv_api_t;
  *	REGULATORY_NVM_GET_INFO_RSP_API_S.
  * @IWL_UCODE_TLV_API_FTM_NEW_RANGE_REQ: This ucode supports v7 of
  *	LOCATION_RANGE_REQ_CMD_API_S and v6 of LOCATION_RANGE_RESP_NTFY_API_S.
+ * @IWL_UCODE_TLV_API_SCAN_OFFLOAD_CHANS: This ucode supports v2 of
+ *	SCAN_OFFLOAD_PROFILE_MATCH_RESULTS_S and v3 of
+ *	SCAN_OFFLOAD_PROFILES_QUERY_RSP_S.
  *
  * @NUM_IWL_UCODE_TLV_API: number of bits used
  */
@@ -304,6 +307,7 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_BEACON_FILTER_V4      = (__force iwl_ucode_tlv_api_t)47,
 	IWL_UCODE_TLV_API_REGULATORY_NVM_INFO   = (__force iwl_ucode_tlv_api_t)48,
 	IWL_UCODE_TLV_API_FTM_NEW_RANGE_REQ     = (__force iwl_ucode_tlv_api_t)49,
+	IWL_UCODE_TLV_API_SCAN_OFFLOAD_CHANS    = (__force iwl_ucode_tlv_api_t)50,
 
 	NUM_IWL_UCODE_TLV_API
 #ifdef __CHECKER__
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 808bc6f363d0..f4288232d06c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -8,7 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018        Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,7 +31,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018        Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -1728,9 +1728,12 @@ void iwl_mvm_d0i3_update_keys(struct iwl_mvm *mvm,
 	iwl_mvm_iter_d0i3_ap_keys(mvm, vif, iwl_mvm_d3_update_keys, &gtkdata);
 }
 
+#define ND_QUERY_BUF_LEN (sizeof(struct iwl_scan_offload_profile_match) * \
+			  IWL_SCAN_MAX_PROFILES)
+
 struct iwl_mvm_nd_query_results {
 	u32 matched_profiles;
-	struct iwl_scan_offload_profile_match matches[IWL_SCAN_MAX_PROFILES];
+	u8 matches[ND_QUERY_BUF_LEN];
 };
 
 static int
@@ -1743,6 +1746,7 @@ iwl_mvm_netdetect_query_results(struct iwl_mvm *mvm,
 		.flags = CMD_WANT_SKB,
 	};
 	int ret, len;
+	size_t query_len, matches_len;
 
 	ret = iwl_mvm_send_cmd(mvm, &cmd);
 	if (ret) {
@@ -1750,8 +1754,19 @@ iwl_mvm_netdetect_query_results(struct iwl_mvm *mvm,
 		return ret;
 	}
 
+	if (fw_has_api(&mvm->fw->ucode_capa,
+		       IWL_UCODE_TLV_API_SCAN_OFFLOAD_CHANS)) {
+		query_len = sizeof(struct iwl_scan_offload_profiles_query);
+		matches_len = sizeof(struct iwl_scan_offload_profile_match) *
+			IWL_SCAN_MAX_PROFILES;
+	} else {
+		query_len = sizeof(struct iwl_scan_offload_profiles_query_v1);
+		matches_len = sizeof(struct iwl_scan_offload_profile_match_v1) *
+			IWL_SCAN_MAX_PROFILES;
+	}
+
 	len = iwl_rx_packet_payload_len(cmd.resp_pkt);
-	if (len < sizeof(*query)) {
+	if (len < query_len) {
 		IWL_ERR(mvm, "Invalid scan offload profiles query response!\n");
 		ret = -EIO;
 		goto out_free_resp;
@@ -1760,7 +1775,7 @@ iwl_mvm_netdetect_query_results(struct iwl_mvm *mvm,
 	query = (void *)cmd.resp_pkt->data;
 
 	results->matched_profiles = le32_to_cpu(query->matched_profiles);
-	memcpy(results->matches, query->matches, sizeof(results->matches));
+	memcpy(results->matches, query->matches, matches_len);
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	mvm->last_netdetect_scans = le32_to_cpu(query->n_scans_done);
@@ -1771,6 +1786,57 @@ iwl_mvm_netdetect_query_results(struct iwl_mvm *mvm,
 	return ret;
 }
 
+static int iwl_mvm_query_num_match_chans(struct iwl_mvm *mvm,
+					 struct iwl_mvm_nd_query_results *query,
+					 int idx)
+{
+	int n_chans = 0, i;
+
+	if (fw_has_api(&mvm->fw->ucode_capa,
+		       IWL_UCODE_TLV_API_SCAN_OFFLOAD_CHANS)) {
+		struct iwl_scan_offload_profile_match *matches =
+			(struct iwl_scan_offload_profile_match *)query->matches;
+
+		for (i = 0; i < SCAN_OFFLOAD_MATCHING_CHANNELS_LEN; i++)
+			n_chans += hweight8(matches[idx].matching_channels[i]);
+	} else {
+		struct iwl_scan_offload_profile_match_v1 *matches =
+			(struct iwl_scan_offload_profile_match_v1 *)query->matches;
+
+		for (i = 0; i < SCAN_OFFLOAD_MATCHING_CHANNELS_LEN_V1; i++)
+			n_chans += hweight8(matches[idx].matching_channels[i]);
+	}
+
+	return n_chans;
+}
+
+static void iwl_mvm_query_set_freqs(struct iwl_mvm *mvm,
+				    struct iwl_mvm_nd_query_results *query,
+				    struct cfg80211_wowlan_nd_match *match,
+				    int idx)
+{
+	int i;
+
+	if (fw_has_api(&mvm->fw->ucode_capa,
+		       IWL_UCODE_TLV_API_SCAN_OFFLOAD_CHANS)) {
+		struct iwl_scan_offload_profile_match *matches =
+			(struct iwl_scan_offload_profile_match *)query->matches;
+
+		for (i = 0; i < SCAN_OFFLOAD_MATCHING_CHANNELS_LEN * 8; i++)
+			if (matches[idx].matching_channels[i / 8] & (BIT(i % 8)))
+				match->channels[match->n_channels++] =
+					mvm->nd_channels[i]->center_freq;
+	} else {
+		struct iwl_scan_offload_profile_match_v1 *matches =
+			(struct iwl_scan_offload_profile_match_v1 *)query->matches;
+
+		for (i = 0; i < SCAN_OFFLOAD_MATCHING_CHANNELS_LEN_V1 * 8; i++)
+			if (matches[idx].matching_channels[i / 8] & (BIT(i % 8)))
+				match->channels[match->n_channels++] =
+					mvm->nd_channels[i]->center_freq;
+	}
+}
+
 static void iwl_mvm_query_netdetect_reasons(struct iwl_mvm *mvm,
 					    struct ieee80211_vif *vif)
 {
@@ -1783,7 +1849,7 @@ static void iwl_mvm_query_netdetect_reasons(struct iwl_mvm *mvm,
 	struct iwl_wowlan_status *fw_status;
 	unsigned long matched_profiles;
 	u32 reasons = 0;
-	int i, j, n_matches, ret;
+	int i, n_matches, ret;
 
 	fw_status = iwl_mvm_get_wakeup_status(mvm);
 	if (!IS_ERR_OR_NULL(fw_status)) {
@@ -1817,14 +1883,10 @@ static void iwl_mvm_query_netdetect_reasons(struct iwl_mvm *mvm,
 		goto out_report_nd;
 
 	for_each_set_bit(i, &matched_profiles, mvm->n_nd_match_sets) {
-		struct iwl_scan_offload_profile_match *fw_match;
 		struct cfg80211_wowlan_nd_match *match;
 		int idx, n_channels = 0;
 
-		fw_match = &query.matches[i];
-
-		for (j = 0; j < SCAN_OFFLOAD_MATCHING_CHANNELS_LEN; j++)
-			n_channels += hweight8(fw_match->matching_channels[j]);
+		n_channels = iwl_mvm_query_num_match_chans(mvm, &query, i);
 
 		match = kzalloc(struct_size(match, channels, n_channels),
 				GFP_KERNEL);
@@ -1844,10 +1906,7 @@ static void iwl_mvm_query_netdetect_reasons(struct iwl_mvm *mvm,
 		if (mvm->n_nd_channels < n_channels)
 			continue;
 
-		for (j = 0; j < SCAN_OFFLOAD_MATCHING_CHANNELS_LEN * 8; j++)
-			if (fw_match->matching_channels[j / 8] & (BIT(j % 8)))
-				match->channels[match->n_channels++] =
-					mvm->nd_channels[j]->center_freq;
+		iwl_mvm_query_set_freqs(mvm, &query, match, i);
 	}
 
 out_report_nd:
-- 
2.20.1

