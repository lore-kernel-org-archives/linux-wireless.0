Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50567 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbaL3OUa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 09:20:30 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Haim Dreyfuss <haim.dreyfuss@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 30/33] iwlwifi: mvm: Configure EBS scan ratio
Date: Tue, 30 Dec 2014 16:19:05 +0200
Message-Id: <1419949148-24046-30-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141230_154350_127631_5B27DF01)
In-Reply-To: <1419948357.21410.4.camel@egrumbacBox>
References: <1419948357.21410.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

This configuration defines the ratio between number of scan iterations
where EBS is involved to those where it is not.
This configuration was left unconfigured due to inaccurate documentation.
Fix documentation as well.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h | 7 +++++--
 drivers/net/wireless/iwlwifi/mvm/scan.c        | 6 ++++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
index 1f2acf4..2d1a81c 100644
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
index 2433676..ed229a8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -72,6 +72,8 @@
 
 #define IWL_PLCP_QUIET_THRESH 1
 #define IWL_ACTIVE_QUIET_TIME 10
+#define IWL_DENSE_EBS_SCAN_RATIO 5
+#define IWL_SPARSE_EBS_SCAN_RATIO 1
 
 struct iwl_mvm_scan_params {
 	u32 max_out_time;
@@ -1296,10 +1298,14 @@ iwl_mvm_build_generic_unified_scan_cmd(struct iwl_mvm *mvm,
 			cpu_to_le16(IWL_SCAN_CHANNEL_FLAG_EBS |
 				    IWL_SCAN_CHANNEL_FLAG_EBS_ACCURATE |
 				    IWL_SCAN_CHANNEL_FLAG_CACHE_ADD);
+		cmd->channel_opt[0].non_ebs_ratio =
+			cpu_to_le16(IWL_DENSE_EBS_SCAN_RATIO);
 		cmd->channel_opt[1].flags =
 			cpu_to_le16(IWL_SCAN_CHANNEL_FLAG_EBS |
 				    IWL_SCAN_CHANNEL_FLAG_EBS_ACCURATE |
 				    IWL_SCAN_CHANNEL_FLAG_CACHE_ADD);
+		cmd->channel_opt[1].non_ebs_ratio =
+			cpu_to_le16(IWL_SPARSE_EBS_SCAN_RATIO);
 	}
 
 	if (iwl_mvm_rrm_scan_needed(mvm))
-- 
1.9.1

