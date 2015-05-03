Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:1907 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbbECTch (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:32:37 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/42] iwlwifi: mvm: some clean ups in fw-api-scan.h
Date: Sun,  3 May 2015 22:31:26 +0300
Message-Id: <1430681513-7838-15-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213418_668183_E38441C9)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Remove unused struct iwl_scan_offload_req and enum
iwl_scan_offload_flags which are not used anymore.  Rename
iwl_scan_offload_schedule to iwl_scan_schedule_lmac to make it clear
that this is for LMAC only.  And fix a small typo.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h | 42 +++-----------------------
 1 file changed, 5 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
index d74615f..be1a0a1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
@@ -274,50 +274,18 @@ struct iwl_scan_offload_profile_cfg {
 } __packed;
 
 /**
- * iwl_scan_offload_schedule - schedule of scan offload
+ * iwl_scan_schedule_lmac - schedule of scan offload
  * @delay:		delay between iterations, in seconds.
  * @iterations:		num of scan iterations
  * @full_scan_mul:	number of partial scans before each full scan
  */
-struct iwl_scan_offload_schedule {
+struct iwl_scan_schedule_lmac {
 	__le16 delay;
 	u8 iterations;
 	u8 full_scan_mul;
-} __packed;
-
-/*
- * iwl_scan_offload_flags
- *
- * IWL_SCAN_OFFLOAD_FLAG_PASS_ALL: pass all results - no filtering.
- * IWL_SCAN_OFFLOAD_FLAG_CACHED_CHANNEL: add cached channels to partial scan.
- * IWL_SCAN_OFFLOAD_FLAG_EBS_QUICK_MODE: EBS duration is 100mSec - typical
- *	beacon period. Finding channel activity in this mode is not guaranteed.
- * IWL_SCAN_OFFLOAD_FLAG_EBS_ACCURATE_MODE: EBS duration is 200mSec.
- *	Assuming beacon period is 100ms finding channel activity is guaranteed.
- */
-enum iwl_scan_offload_flags {
-	IWL_SCAN_OFFLOAD_FLAG_PASS_ALL		= BIT(0),
-	IWL_SCAN_OFFLOAD_FLAG_CACHED_CHANNEL	= BIT(2),
-	IWL_SCAN_OFFLOAD_FLAG_EBS_QUICK_MODE	= BIT(5),
-	IWL_SCAN_OFFLOAD_FLAG_EBS_ACCURATE_MODE	= BIT(6),
-};
-
-/**
- * iwl_scan_offload_req - scan offload request command
- * @flags:		bitmap - enum iwl_scan_offload_flags.
- * @watchdog:		maximum scan duration in TU.
- * @delay:		delay in seconds before first iteration.
- * @schedule_line:	scan offload schedule, for fast and regular scan.
- */
-struct iwl_scan_offload_req {
-	__le16 flags;
-	__le16 watchdog;
-	__le16 delay;
-	__le16 reserved;
-	struct iwl_scan_offload_schedule schedule_line[2];
-} __packed;
+} __packed; /* SCAN_SCHEDULE_API_S */
 
-enum iwl_scan_offload_compleate_status {
+enum iwl_scan_offload_complete_status {
 	IWL_SCAN_OFFLOAD_COMPLETED	= 1,
 	IWL_SCAN_OFFLOAD_ABORTED	= 2,
 };
@@ -508,7 +476,7 @@ struct iwl_scan_req_lmac {
 	/* SCAN_REQ_PERIODIC_PARAMS_API_S */
 	__le32 iter_num;
 	__le32 delay;
-	struct iwl_scan_offload_schedule schedule[2];
+	struct iwl_scan_schedule_lmac schedule[2];
 	struct iwl_scan_channel_opt channel_opt[2];
 	u8 data[];
 } __packed;
-- 
2.1.0

