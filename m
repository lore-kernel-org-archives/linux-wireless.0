Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B695172C2
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 13:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790168597; cv=none; b=bRkb5nHgtIYk3/ZZp+vzR7qazvUo4DyIOQgTHjzkrisYMIpU9zq6XQo4GTtmVehK3jj44Muk8jeiPdaUAYXEbCURyk4+9jET0C/0IVMs2PEsOQnc/9Y0GTT/dMKP+AkP+Z2hv6/eowu8eDtFRRqoG9DCUkefClephDN1OUULdL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790168597; c=relaxed/simple;
	bh=xpcswk6pa3DpeTCW+3fOd2tyQipAtfwk/iTT+S5tGxI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Sa03G9Jrz13fao+lf3SJAu97Kp/azgt6MVu+Tf8tdtmFZC0n2gB2wX+Mhqwtm1bm2Qhs8Kvges+Gq+KYMz/vtW6LiXP0UQ3WgINOIpGJYXHJmT/St+Ykea651v1WmwY6Qco3J8gB18M19uF05DAMwOVSAObOUcmNu7r6v2Va3Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hg37aF78; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hg37aF78"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790168594; x=1821704594;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xpcswk6pa3DpeTCW+3fOd2tyQipAtfwk/iTT+S5tGxI=;
  b=Hg37aF78jGMR22QIubEBu1kChQKM2GR+3Bzkdnw+gNme/FQ28wzAi6Ha
   4Escv4fzOa0u8UkoKFhvP81sXpG+Ve1ur8jmc2q3/fLDSgOdrStRp7VBS
   oThv3TSMBmCkgTAtJG+H8aGJ8M/6R+B4LXAMh0TrUgAUMkN/WbDh0Lf3x
   mt7Mndwd87PadnngqO6NSMqdyLcy1ymUfSxxfPzFId3Z57F5jw01PNaCa
   IYBBQocxYOumMw2XpIQOGXFiR6nRDHy1V2obkgSVVnpZBV7LD3TNb0eR7
   319vAuoWoxPi1pNyN5QgYXgKsDbhhCp8Q6HtOXWl/gCnpOdrHXocNylcs
   w==;
X-CSE-ConnectionGUID: 5W8CiPyMSYydKWUMs4V9/g==
X-CSE-MsgGUID: aqocRQdUQLuxksXKKnlS9A==
X-IronPort-AV: E=McAfee;i="6800,10657,11913"; a="89781331"
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="89781331"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 06:03:10 -0700
X-CSE-ConnectionGUID: bLvEqg4/Qy+pHEBQLRwMsg==
X-CSE-MsgGUID: U3btrcjfTpamh8neG7aaCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="4697054"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 06:03:09 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH iwlwifi-next 07/15] wifi: iwlwifi: support net detect match info version 3
Date: Wed, 23 Sep 2026 16:04:50 +0300
Message-Id: <20260923160318.07738ca44b54.I58162891250af9f46220fd01db667460e6dd621b@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260923130458.164968-1-miriam.rachel.korenblit@intel.com>
References: <20260923130458.164968-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

Since API 77, firmware reports scan offload profile matches using
SCAN_OFFLOAD_PROFILE_MATCH_RESULTS_S_VER_3, which has more channels (16
byte instead of 7).
Somehow we missed this change, and the driver only handles the 5- and
7-byte layouts, so on such firmware it misparsed the match (reading band
as energy) and could not recover matches beyond the first 56 channels.

Add the version 3 match structure and select it based on the
SCAN_OFFLOAD_PROFILES_QUERY_CMD notification version (in MVM, in MLD,
this is the only version supported).

In MVM, while walking the matched-channels bitmap, bound the channel
index with IWL_FW_CHECK so firmware that sets a bit beyond n_nd_channels
can no longer trigger an out-of-bounds read of nd_channels[].

Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 .../net/wireless/intel/iwlwifi/fw/api/scan.h  | 28 +++++-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c   | 89 ++++++++++++++-----
 2 files changed, 93 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h b/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
index cb6217763bd1..8994a7b840ef 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
@@ -1234,7 +1234,8 @@ struct iwl_umac_scan_complete {
 } __packed; /* SCAN_COMPLETE_NTF_UMAC_API_S_VER_1 */
 
 #define SCAN_OFFLOAD_MATCHING_CHANNELS_LEN_V1 5
-#define SCAN_OFFLOAD_MATCHING_CHANNELS_LEN    7
+#define SCAN_OFFLOAD_MATCHING_CHANNELS_LEN_V2 7
+#define SCAN_OFFLOAD_MATCHING_CHANNELS_LEN    16
 
 /**
  * struct iwl_scan_offload_profile_match_v1 - match information
@@ -1280,11 +1281,31 @@ struct iwl_scan_offload_profiles_query_v1 {
 	struct iwl_scan_offload_profile_match_v1 matches[];
 } __packed; /* SCAN_OFFLOAD_PROFILES_QUERY_RSP_S_VER_2 */
 
+/**
+ * struct iwl_scan_offload_profile_match_v2 - match information
+ * @bssid: matched bssid
+ * @reserved: reserved
+ * @channel: channel where the match occurred
+ * @energy: energy
+ * @matching_feature: feature matches
+ * @matching_channels: bitmap of channels that matched, referencing
+ *	the channels passed in the scan offload request.
+ */
+struct iwl_scan_offload_profile_match_v2 {
+	u8 bssid[ETH_ALEN];
+	__le16 reserved;
+	u8 channel;
+	u8 energy;
+	u8 matching_feature;
+	u8 matching_channels[SCAN_OFFLOAD_MATCHING_CHANNELS_LEN_V2];
+} __packed; /* SCAN_OFFLOAD_PROFILE_MATCH_RESULTS_S_VER_2 */
+
 /**
  * struct iwl_scan_offload_profile_match - match information
  * @bssid: matched bssid
  * @reserved: reserved
  * @channel: channel where the match occurred
+ * @band: band where the match occurred
  * @energy: energy
  * @matching_feature: feature matches
  * @matching_channels: bitmap of channels that matched, referencing
@@ -1294,10 +1315,11 @@ struct iwl_scan_offload_profile_match {
 	u8 bssid[ETH_ALEN];
 	__le16 reserved;
 	u8 channel;
+	u8 band;
 	u8 energy;
 	u8 matching_feature;
 	u8 matching_channels[SCAN_OFFLOAD_MATCHING_CHANNELS_LEN];
-} __packed; /* SCAN_OFFLOAD_PROFILE_MATCH_RESULTS_S_VER_2 */
+} __packed; /* SCAN_OFFLOAD_PROFILE_MATCH_RESULTS_S_VER_3 */
 
 /**
  * struct iwl_scan_offload_match_info - match results information
@@ -1322,7 +1344,7 @@ struct iwl_scan_offload_match_info {
 	u8 self_recovery;
 	__le16 reserved;
 	struct iwl_scan_offload_profile_match matches[IWL_SCAN_MAX_PROFILES_V2];
-} __packed; /* SCAN_OFFLOAD_PROFILES_QUERY_RSP_S_VER_3 and
+} __packed; /* SCAN_OFFLOAD_PROFILES_QUERY_RSP_S_VER_5 and
 	     * SCAN_OFFLOAD_MATCH_INFO_NOTIFICATION_S_VER_1
 	     */
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 6b11fa32ea5c..c27265926ca4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -2438,6 +2438,12 @@ struct iwl_mvm_nd_results {
 	u8 matches[ND_QUERY_BUF_LEN];
 };
 
+static bool iwl_mvm_nd_match_info_v3(struct iwl_mvm *mvm)
+{
+	return iwl_fw_lookup_notif_ver(mvm->fw, LEGACY_GROUP,
+				       SCAN_OFFLOAD_PROFILES_QUERY_CMD, 0) >= 4;
+}
+
 static int
 iwl_mvm_netdetect_query_results(struct iwl_mvm *mvm,
 				struct iwl_mvm_nd_results *results)
@@ -2457,12 +2463,17 @@ iwl_mvm_netdetect_query_results(struct iwl_mvm *mvm,
 		return ret;
 	}
 
-	if (fw_has_api(&mvm->fw->ucode_capa,
-		       IWL_UCODE_TLV_API_SCAN_OFFLOAD_CHANS)) {
+	if (iwl_mvm_nd_match_info_v3(mvm)) {
 		matches_len = sizeof(struct iwl_scan_offload_profile_match) *
 			max_profiles;
 		query_len = offsetof(struct iwl_scan_offload_match_info,
 				     matches) + matches_len;
+	} else if (fw_has_api(&mvm->fw->ucode_capa,
+			      IWL_UCODE_TLV_API_SCAN_OFFLOAD_CHANS)) {
+		matches_len = sizeof(struct iwl_scan_offload_profile_match_v2) *
+			max_profiles;
+		query_len = offsetof(struct iwl_scan_offload_match_info,
+				     matches) + matches_len;
 	} else {
 		matches_len = sizeof(struct iwl_scan_offload_profile_match_v1) *
 			max_profiles;
@@ -2497,13 +2508,19 @@ static int iwl_mvm_query_num_match_chans(struct iwl_mvm *mvm,
 {
 	int n_chans = 0, i;
 
-	if (fw_has_api(&mvm->fw->ucode_capa,
-		       IWL_UCODE_TLV_API_SCAN_OFFLOAD_CHANS)) {
+	if (iwl_mvm_nd_match_info_v3(mvm)) {
 		struct iwl_scan_offload_profile_match *matches =
 			(void *)results->matches;
 
 		for (i = 0; i < SCAN_OFFLOAD_MATCHING_CHANNELS_LEN; i++)
 			n_chans += hweight8(matches[idx].matching_channels[i]);
+	} else if (fw_has_api(&mvm->fw->ucode_capa,
+			      IWL_UCODE_TLV_API_SCAN_OFFLOAD_CHANS)) {
+		struct iwl_scan_offload_profile_match_v2 *matches =
+			(void *)results->matches;
+
+		for (i = 0; i < SCAN_OFFLOAD_MATCHING_CHANNELS_LEN_V2; i++)
+			n_chans += hweight8(matches[idx].matching_channels[i]);
 	} else {
 		struct iwl_scan_offload_profile_match_v1 *matches =
 			(void *)results->matches;
@@ -2515,34 +2532,58 @@ static int iwl_mvm_query_num_match_chans(struct iwl_mvm *mvm,
 	return n_chans;
 }
 
+static void iwl_mvm_set_matching_freqs(struct iwl_mvm *mvm,
+				       const u8 *matching_channels,
+				       size_t num_bytes,
+				       struct cfg80211_wowlan_nd_match *match)
+{
+	int n_channels = 0;
+
+	for (int i = 0; i < num_bytes * 8; i++) {
+		if (!(matching_channels[i / 8] & BIT(i % 8)))
+			continue;
+		if (IWL_FW_CHECK(mvm, i >= mvm->n_nd_channels,
+				 "FW matched channel bit %d beyond n_nd_channels %d\n",
+				 i, mvm->n_nd_channels))
+			break;
+		match->channels[n_channels++] =
+			mvm->nd_channels[i]->center_freq;
+	}
+	/* We may have ended up with fewer channels than we allocated. */
+	match->n_channels = n_channels;
+}
+
 static void iwl_mvm_query_set_freqs(struct iwl_mvm *mvm,
 				    struct iwl_mvm_nd_results *results,
 				    struct cfg80211_wowlan_nd_match *match,
 				    int idx)
 {
-	int i;
-	int n_channels = 0;
-
-	if (fw_has_api(&mvm->fw->ucode_capa,
-		       IWL_UCODE_TLV_API_SCAN_OFFLOAD_CHANS)) {
+	if (iwl_mvm_nd_match_info_v3(mvm)) {
 		struct iwl_scan_offload_profile_match *matches =
 			 (void *)results->matches;
 
-		for (i = 0; i < SCAN_OFFLOAD_MATCHING_CHANNELS_LEN * 8; i++)
-			if (matches[idx].matching_channels[i / 8] & (BIT(i % 8)))
-				match->channels[n_channels++] =
-					mvm->nd_channels[i]->center_freq;
+		iwl_mvm_set_matching_freqs(mvm,
+					   matches[idx].matching_channels,
+					   sizeof(matches[idx].matching_channels),
+					   match);
+	} else if (fw_has_api(&mvm->fw->ucode_capa,
+			      IWL_UCODE_TLV_API_SCAN_OFFLOAD_CHANS)) {
+		struct iwl_scan_offload_profile_match_v2 *matches =
+			 (void *)results->matches;
+
+		iwl_mvm_set_matching_freqs(mvm,
+					   matches[idx].matching_channels,
+					   sizeof(matches[idx].matching_channels),
+					   match);
 	} else {
 		struct iwl_scan_offload_profile_match_v1 *matches =
 			 (void *)results->matches;
 
-		for (i = 0; i < SCAN_OFFLOAD_MATCHING_CHANNELS_LEN_V1 * 8; i++)
-			if (matches[idx].matching_channels[i / 8] & (BIT(i % 8)))
-				match->channels[n_channels++] =
-					mvm->nd_channels[i]->center_freq;
+		iwl_mvm_set_matching_freqs(mvm,
+					   matches[idx].matching_channels,
+					   sizeof(matches[idx].matching_channels),
+					   match);
 	}
-	/* We may have ended up with fewer channels than we allocated. */
-	match->n_channels = n_channels;
 }
 
 /**
@@ -2815,8 +2856,14 @@ static void iwl_mvm_nd_match_info_handler(struct iwl_mvm *mvm,
 	struct iwl_wowlan_status_data *status = d3_data->status;
 	struct ieee80211_vif *vif = iwl_mvm_get_bss_vif(mvm);
 	struct iwl_mvm_nd_results *results = d3_data->nd_results;
-	size_t i, matches_len = sizeof(struct iwl_scan_offload_profile_match) *
-		iwl_umac_scan_get_max_profiles(mvm->fw);
+	size_t i, matches_len;
+
+	if (iwl_mvm_nd_match_info_v3(mvm))
+		matches_len = sizeof(struct iwl_scan_offload_profile_match) *
+			iwl_umac_scan_get_max_profiles(mvm->fw);
+	else
+		matches_len = sizeof(struct iwl_scan_offload_profile_match_v2) *
+			iwl_umac_scan_get_max_profiles(mvm->fw);
 
 	if (IS_ERR_OR_NULL(vif))
 		return;
-- 
2.34.1

