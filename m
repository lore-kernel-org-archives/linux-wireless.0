Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:53777 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbbAMMTu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 07:19:50 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/3] iwlwifi: mvm: fix EBS on single scan
Date: Tue, 13 Jan 2015 14:19:45 +0200
Message-Id: <1421151587-10437-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150113_131953_610464_978A2718)
In-Reply-To: <1421151474.2601.10.camel@egrumbacBox>
References: <1421151474.2601.10.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

EBS error detection isn't supported by all FWs, so turn it on
only if the FW advertises such support.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-file.h     |  2 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h |  7 ++--
 drivers/net/wireless/iwlwifi/mvm/scan.c        | 46 +++++++++++++++++++-------
 3 files changed, 41 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 1bbe4fc..660ddb1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -246,6 +246,7 @@ enum iwl_ucode_tlv_flag {
  * @IWL_UCODE_TLV_API_BASIC_DWELL: use only basic dwell time in scan command,
  *	regardless of the band or the number of the probes. FW will calculate
  *	the actual dwell time.
+ * @IWL_UCODE_TLV_API_SINGLE_SCAN_EBS: EBS is supported for single scans too.
  */
 enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_WOWLAN_CONFIG_TID	= BIT(0),
@@ -257,6 +258,7 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_SF_NO_DUMMY_NOTIF	= BIT(7),
 	IWL_UCODE_TLV_API_FRAGMENTED_SCAN	= BIT(8),
 	IWL_UCODE_TLV_API_BASIC_DWELL		= BIT(13),
+	IWL_UCODE_TLV_API_SINGLE_SCAN_EBS	= BIT(16),
 };
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
index 201846d..cfc0e65 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
@@ -653,8 +653,11 @@ enum iwl_scan_channel_flags {
 };
 
 /* iwl_scan_channel_opt - CHANNEL_OPTIMIZATION_API_S
- * @flags: enum iwl_scan_channel_flgs
- * @non_ebs_ratio: how many regular scan iteration before EBS
+ * @flags: enum iwl_scan_channel_flags
+ * @non_ebs_ratio: defines the ratio of number of scan iterations where EBS is
+ *	involved.
+ *	1 - EBS is disabled.
+ *	2 - every second scan will be full scan(and so on).
  */
 struct iwl_scan_channel_opt {
 	__le16 flags;
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index ec9a8e7..3fbba4b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -72,6 +72,8 @@
 
 #define IWL_PLCP_QUIET_THRESH 1
 #define IWL_ACTIVE_QUIET_TIME 10
+#define IWL_DENSE_EBS_SCAN_RATIO 5
+#define IWL_SPARSE_EBS_SCAN_RATIO 1
 
 struct iwl_mvm_scan_params {
 	u32 max_out_time;
@@ -1297,18 +1299,6 @@ iwl_mvm_build_generic_unified_scan_cmd(struct iwl_mvm *mvm,
 	cmd->scan_prio = cpu_to_le32(IWL_SCAN_PRIORITY_HIGH);
 	cmd->iter_num = cpu_to_le32(1);
 
-	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_EBS_SUPPORT &&
-	    mvm->last_ebs_successful) {
-		cmd->channel_opt[0].flags =
-			cpu_to_le16(IWL_SCAN_CHANNEL_FLAG_EBS |
-				    IWL_SCAN_CHANNEL_FLAG_EBS_ACCURATE |
-				    IWL_SCAN_CHANNEL_FLAG_CACHE_ADD);
-		cmd->channel_opt[1].flags =
-			cpu_to_le16(IWL_SCAN_CHANNEL_FLAG_EBS |
-				    IWL_SCAN_CHANNEL_FLAG_EBS_ACCURATE |
-				    IWL_SCAN_CHANNEL_FLAG_CACHE_ADD);
-	}
-
 	if (iwl_mvm_rrm_scan_needed(mvm))
 		cmd->scan_flags |=
 			cpu_to_le32(IWL_MVM_LMAC_SCAN_FLAGS_RRM_ENABLED);
@@ -1383,6 +1373,22 @@ int iwl_mvm_unified_scan_lmac(struct iwl_mvm *mvm,
 	cmd->schedule[1].iterations = 0;
 	cmd->schedule[1].full_scan_mul = 0;
 
+	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_SINGLE_SCAN_EBS &&
+	    mvm->last_ebs_successful) {
+		cmd->channel_opt[0].flags =
+			cpu_to_le16(IWL_SCAN_CHANNEL_FLAG_EBS |
+				    IWL_SCAN_CHANNEL_FLAG_EBS_ACCURATE |
+				    IWL_SCAN_CHANNEL_FLAG_CACHE_ADD);
+		cmd->channel_opt[0].non_ebs_ratio =
+			cpu_to_le16(IWL_DENSE_EBS_SCAN_RATIO);
+		cmd->channel_opt[1].flags =
+			cpu_to_le16(IWL_SCAN_CHANNEL_FLAG_EBS |
+				    IWL_SCAN_CHANNEL_FLAG_EBS_ACCURATE |
+				    IWL_SCAN_CHANNEL_FLAG_CACHE_ADD);
+		cmd->channel_opt[1].non_ebs_ratio =
+			cpu_to_le16(IWL_SPARSE_EBS_SCAN_RATIO);
+	}
+
 	for (i = 1; i <= req->req.n_ssids; i++)
 		ssid_bitmap |= BIT(i);
 
@@ -1483,6 +1489,22 @@ int iwl_mvm_unified_sched_scan_lmac(struct iwl_mvm *mvm,
 	cmd->schedule[1].iterations = 0xff;
 	cmd->schedule[1].full_scan_mul = IWL_FULL_SCAN_MULTIPLIER;
 
+	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_EBS_SUPPORT &&
+	    mvm->last_ebs_successful) {
+		cmd->channel_opt[0].flags =
+			cpu_to_le16(IWL_SCAN_CHANNEL_FLAG_EBS |
+				    IWL_SCAN_CHANNEL_FLAG_EBS_ACCURATE |
+				    IWL_SCAN_CHANNEL_FLAG_CACHE_ADD);
+		cmd->channel_opt[0].non_ebs_ratio =
+			cpu_to_le16(IWL_DENSE_EBS_SCAN_RATIO);
+		cmd->channel_opt[1].flags =
+			cpu_to_le16(IWL_SCAN_CHANNEL_FLAG_EBS |
+				    IWL_SCAN_CHANNEL_FLAG_EBS_ACCURATE |
+				    IWL_SCAN_CHANNEL_FLAG_CACHE_ADD);
+		cmd->channel_opt[1].non_ebs_ratio =
+			cpu_to_le16(IWL_SPARSE_EBS_SCAN_RATIO);
+	}
+
 	iwl_mvm_lmac_scan_cfg_channels(mvm, req->channels, req->n_channels,
 				       ssid_bitmap, cmd);
 
-- 
1.9.1

