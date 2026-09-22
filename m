Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE9F47D44F
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 11:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790077706; cv=none; b=HX+O7dBQqtYu0aujpG+DJmrzZoAidtpZVbV8DA8HEbbrArZctj6o16ykvujVR13vg69GSrhFjv/5OMmmE1oDs1A8/99vm3cZSYClEvaZft5cgOzG69CXEKGyfSGJCybD/1Ir5vjKQ9IHjJdSF0Ksnj3NvLEMr9JaM/GpooLZb3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790077706; c=relaxed/simple;
	bh=yYMAViCORmA/Zy/viS+LD+Wilb4inr1ZOqmA8pl8hsg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=J5F5oCYGHzoVs6nmOJ3QR3bAq+jmUsttN2CTRGRelbrqHzcJwowT9S+l7F+MSZ7bzLRfURYhRY3w8vZZsO8R3LEXYaLDyjprVqiwp6WrNpFhuf5HSygaSuZRQJzG4YjRKOG7JFfG9LW9eFwu2LRzig1+vTF41pbHsRhVQEYiDAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DCPwp735; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DCPwp735"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790077704; x=1821613704;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yYMAViCORmA/Zy/viS+LD+Wilb4inr1ZOqmA8pl8hsg=;
  b=DCPwp735pcS6s3+pahZdJ2rfG1M7RksvvyXSxN3jEOdNOMLGCSFJeK9j
   KIgu9XfFLoF0bLnaOiuF6qMNs5rN2dLBzDY/5F/3fz5V4sV69YhLNc3r5
   aHShxsFyb4YPQI6J7AptTlbkij0tylG9Xlq7s2jXSAoILoYdPlO3/QJSg
   koL6QX+oQ294Xrs81C7fby9G8HBgGGZHsfyqr3fibRJ4N+QPtJ+jmq8Kg
   GnA+XyMAvep5KAb3uMleF3l7Tdsw9PxreBhXnSTMuuALjapXU3EY89738
   IcgAW9vxwpXla1ZoYiDvGmZdbs/D9cc0jiyMVwEucSMr9wsNXZjPeMXtl
   g==;
X-CSE-ConnectionGUID: nZycI2GARWCUdpetRGBu/w==
X-CSE-MsgGUID: uate38pQTyaaj2AlEvF3EQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="108170545"
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="108170545"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 04:48:18 -0700
X-CSE-ConnectionGUID: ZdMYuUahTuyGvV2OUeBf6Q==
X-CSE-MsgGUID: OzPLla69Txe7rSo9YcH4ow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="273275412"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 04:48:17 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH iwlwifi-next 10/15] wifi: iwlwifi: mld: Add support for scan iteration complete notification v3
Date: Tue, 22 Sep 2026 14:49:57 +0300
Message-Id: <20260922144819.daf57b66d8a9.I1ff60b070464ea5cc1f402293c2342157d29ea79@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260922115002.934469-1-miriam.rachel.korenblit@intel.com>
References: <20260922115002.934469-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Ilan Peer <ilan.peer@intel.com>

Add support for scan iteration complete notification v3. This
version is a superset of the previous version and adds information
about the EBS corresponding with this scan iteration.

Assisted-by: GitHub-Copilot:claude-opus-5
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 .../net/wireless/intel/iwlwifi/fw/api/scan.h  | 40 ++++++++++++++++++-
 .../net/wireless/intel/iwlwifi/mld/notif.c    |  3 +-
 drivers/net/wireless/intel/iwlwifi/mld/scan.c | 15 ++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c |  2 +-
 5 files changed, 56 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h b/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
index ee78371082b0..cb6217763bd1 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
@@ -987,6 +987,8 @@ struct iwl_scan_probe_params_v4 {
 #define SCAN_MAX_NUM_CHANS_V3 67
 #define SCAN_MAX_NUM_CHANS_V4 68
 
+#define SCAN_MAX_NUM_NOTIF_RESULTS 112
+
 /**
  * struct iwl_scan_channel_params_v4 - channel params
  * @flags: channel flags &enum iwl_scan_channel_flags
@@ -1325,7 +1327,8 @@ struct iwl_scan_offload_match_info {
 	     */
 
 /**
- * struct iwl_umac_scan_iter_complete_notif - notifies end of scanning iteration
+ * struct iwl_umac_scan_iter_complete_notif_v2 - notifies end of scanning
+ *	iteration
  * @uid: scan id, &enum iwl_umac_scan_uid_offsets
  * @scanned_channels: number of channels scanned and number of valid elements in
  *	results array
@@ -1336,7 +1339,7 @@ struct iwl_scan_offload_match_info {
  *	in &struct iwl_scan_req_umac.
  * @results: array of scan results, length in @scanned_channels
  */
-struct iwl_umac_scan_iter_complete_notif {
+struct iwl_umac_scan_iter_complete_notif_v2 {
 	__le32 uid;
 	u8 scanned_channels;
 	u8 status;
@@ -1346,6 +1349,39 @@ struct iwl_umac_scan_iter_complete_notif {
 	struct iwl_scan_results_notif results[];
 } __packed; /* SCAN_ITER_COMPLETE_NTF_UMAC_API_S_VER_2 */
 
+/**
+ * struct iwl_umac_scan_iter_complete_notif - notifies end of scanning
+ *	iteration
+ * @uid: scan id, &enum iwl_umac_scan_uid_offsets
+ * @scanned_channels: number of channels scanned and number of valid elements in
+ *	results array
+ * @status: one of SCAN_COMP_STATUS_*
+ * @bt_status: BT on/off status
+ * @last_channel: last channel that was scanned
+ * @start_tsf: TSF timer in usecs of the scan start time for the mac specified
+ *	in &struct iwl_scan_req_umac.
+ * @results: array of scan results, only @scanned_channels of them are valid
+ * @ebs_status: EBS completion status, &enum iwl_scan_ebs_status
+ * @reserved: reserved for alignment
+ * @ebs_channel_status: only valid when @ebs_status is %IWL_SCAN_EBS_SUCCESS.
+ *	Bitmap of the 5 GHz channels on which EBS found energy:
+ *	bit i in [0..27]:  channel = 36 + 4 * i   (channels 36 - 144)
+ *	bit i in [28..35]: channel = 37 + 4 * i   (channels 149 - 177)
+ *	bit 36: channel 181 (reserved, not currently covered by EBS)
+ */
+struct iwl_umac_scan_iter_complete_notif {
+	__le32 uid;
+	u8 scanned_channels;
+	u8 status;
+	u8 bt_status;
+	u8 last_channel;
+	__le64 start_tsf;
+	struct iwl_scan_results_notif results[SCAN_MAX_NUM_NOTIF_RESULTS];
+	u8 ebs_status;
+	u8 reserved[3];
+	__le64 ebs_channel_status;
+} __packed; /* SCAN_ITER_COMPLETE_NTF_UMAC_API_S_VER_3 */
+
 /**
  * struct iwl_umac_scan_channel_survey_notif - data for survey
  * @channel: the channel scanned
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/notif.c b/drivers/net/wireless/intel/iwlwifi/mld/notif.c
index d0b85adf7417..570b0011fd9e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/notif.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/notif.c
@@ -292,7 +292,8 @@ CMD_VERSIONS(scan_start_notif,
 CMD_VERSIONS(scan_complete_notif,
 	     CMD_VER_ENTRY(1, iwl_umac_scan_complete))
 CMD_VERSIONS(scan_iter_complete_notif,
-	     CMD_VER_ENTRY(2, iwl_umac_scan_iter_complete_notif))
+	     CMD_VER_ENTRY(2, iwl_umac_scan_iter_complete_notif_v2)
+	     CMD_VER_ENTRY(3, iwl_umac_scan_iter_complete_notif))
 CMD_VERSIONS(channel_survey_notif,
 	     CMD_VER_ENTRY(1, iwl_umac_scan_channel_survey_notif))
 CMD_VERSIONS(mfuart_notif,
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/scan.c b/drivers/net/wireless/intel/iwlwifi/mld/scan.c
index 0faca402bc14..e44b24904c19 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/scan.c
@@ -1992,7 +1992,14 @@ void iwl_mld_int_mlo_scan(struct iwl_mld *mld, struct ieee80211_vif *vif)
 void iwl_mld_handle_scan_iter_complete_notif(struct iwl_mld *mld,
 					     struct iwl_rx_packet *pkt)
 {
-	struct iwl_umac_scan_iter_complete_notif *notif = (void *)pkt->data;
+	/*
+	 * The v3 notification is a superset of v2, so the fields that are
+	 * common to both versions can always be read from the v3 layout.
+	 */
+	const struct iwl_umac_scan_iter_complete_notif *notif =
+		(const void *)pkt->data;
+	u8 notif_ver = iwl_fw_lookup_notif_ver(mld->fw, LEGACY_GROUP,
+					       SCAN_ITERATION_COMPLETE_UMAC, 2);
 	u32 uid = __le32_to_cpu(notif->uid);
 
 	if (IWL_FW_CHECK(mld, uid >= ARRAY_SIZE(mld->scan.uid_status),
@@ -2006,6 +2013,12 @@ void iwl_mld_handle_scan_iter_complete_notif(struct iwl_mld *mld,
 		       "UMAC Scan iteration complete: status=0x%x scanned_channels=%d\n",
 		       notif->status, notif->scanned_channels);
 
+	if (notif_ver >= 3)
+		IWL_DEBUG_SCAN(mld,
+			       "UMAC Scan iteration complete: EBS=%s, EBS channel status=0x%llx\n",
+			       iwl_mld_scan_ebs_status_str(notif->ebs_status),
+			       le64_to_cpu(notif->ebs_channel_status));
+
 	if (mld->scan.pass_all_sched_res == SCHED_SCAN_PASS_ALL_STATE_FOUND) {
 		IWL_DEBUG_SCAN(mld, "Pass all scheduled scan results found\n");
 		ieee80211_sched_scan_results(mld->hw);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 1dd27292af9b..93d5cab87f64 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -374,7 +374,7 @@ static const struct iwl_rx_handlers iwl_mvm_rx_handlers[] = {
 		   struct iwl_umac_scan_complete),
 	RX_HANDLER(SCAN_ITERATION_COMPLETE_UMAC,
 		   iwl_mvm_rx_umac_scan_iter_complete_notif, RX_HANDLER_SYNC,
-		   struct iwl_umac_scan_iter_complete_notif),
+		   struct iwl_umac_scan_iter_complete_notif_v2),
 
 	RX_HANDLER(MISSED_BEACONS_NOTIFICATION,
 		   iwl_mvm_rx_missed_beacons_notif_legacy,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 3831b3c27e0f..817c6dacfacc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -3282,7 +3282,7 @@ void iwl_mvm_rx_umac_scan_iter_complete_notif(struct iwl_mvm *mvm,
 					      struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_umac_scan_iter_complete_notif *notif = (void *)pkt->data;
+	struct iwl_umac_scan_iter_complete_notif_v2 *notif = (void *)pkt->data;
 
 	mvm->scan_start = le64_to_cpu(notif->start_tsf);
 
-- 
2.34.1

