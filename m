Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50144 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S943505AbcJSOzH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2016 10:55:07 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Oct 2016 10:27:26 +0300
Message-Id: <20161019072726.22018-8-luca@coelho.fi> (sfid-20161019_165528_753830_CE61D250)
In-Reply-To: <20161019072726.22018-1-luca@coelho.fi>
References: <20161019072726.22018-1-luca@coelho.fi>
Subject: [PATCH 7/7] iwlwifi: mvm: fix netdetect starting/stopping for unified images
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

With unified images, we need to make sure the net-detect scan is
stopped after resuming, since we don't restart the FW.  Also, we need
to make sure we check if there are enough scan slots available to run
it, as we do with other scans.

Fixes: commit 23ae61282b88 ("iwlwifi: mvm: Do not switch to D3 image on suspend")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c   | 19 +++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 33 ++++++++++++++++++++++-----
 2 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 03a8fc5..b88e204 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1087,6 +1087,15 @@ iwl_mvm_netdetect_config(struct iwl_mvm *mvm,
 		ret = iwl_mvm_switch_to_d3(mvm);
 		if (ret)
 			return ret;
+	} else {
+		/* In theory, we wouldn't have to stop a running sched
+		 * scan in order to start another one (for
+		 * net-detect).  But in practice this doesn't seem to
+		 * work properly, so stop any running sched_scan now.
+		 */
+		ret = iwl_mvm_scan_stop(mvm, IWL_MVM_SCAN_SCHED, true);
+		if (ret)
+			return ret;
 	}
 
 	/* rfkill release can be either for wowlan or netdetect */
@@ -2091,6 +2100,16 @@ static int __iwl_mvm_resume(struct iwl_mvm *mvm, bool test)
 	iwl_mvm_update_changed_regdom(mvm);
 
 	if (mvm->net_detect) {
+		/* If this is a non-unified image, we restart the FW,
+		 * so no need to stop the netdetect scan.  If that
+		 * fails, continue and try to get the wake-up reasons,
+		 * but trigger a HW restart by keeping a failure code
+		 * in ret.
+		 */
+		if (unified_image)
+			ret = iwl_mvm_scan_stop(mvm, IWL_MVM_SCAN_NETDETECT,
+						false);
+
 		iwl_mvm_query_netdetect_reasons(mvm, vif);
 		/* has unlocked the mutex, so skip that */
 		goto out;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index f279fdd..fa97432 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1199,6 +1199,9 @@ static int iwl_mvm_num_scans(struct iwl_mvm *mvm)
 
 static int iwl_mvm_check_running_scans(struct iwl_mvm *mvm, int type)
 {
+	bool unified_image = fw_has_capa(&mvm->fw->ucode_capa,
+					 IWL_UCODE_TLV_CAPA_CNSLDTD_D3_D0_IMG);
+
 	/* This looks a bit arbitrary, but the idea is that if we run
 	 * out of possible simultaneous scans and the userspace is
 	 * trying to run a scan type that is already running, we
@@ -1225,12 +1228,30 @@ static int iwl_mvm_check_running_scans(struct iwl_mvm *mvm, int type)
 			return -EBUSY;
 		return iwl_mvm_scan_stop(mvm, IWL_MVM_SCAN_REGULAR, true);
 	case IWL_MVM_SCAN_NETDETECT:
-		/* No need to stop anything for net-detect since the
-		 * firmware is restarted anyway.  This way, any sched
-		 * scans that were running will be restarted when we
-		 * resume.
-		*/
-		return 0;
+		/* For non-unified images, there's no need to stop
+		 * anything for net-detect since the firmware is
+		 * restarted anyway.  This way, any sched scans that
+		 * were running will be restarted when we resume.
+		 */
+		if (!unified_image)
+			return 0;
+
+		/* If this is a unified image and we ran out of scans,
+		 * we need to stop something.  Prefer stopping regular
+		 * scans, because the results are useless at this
+		 * point, and we should be able to keep running
+		 * another scheduled scan while suspended.
+		 */
+		if (mvm->scan_status & IWL_MVM_SCAN_REGULAR_MASK)
+			return iwl_mvm_scan_stop(mvm, IWL_MVM_SCAN_REGULAR,
+						 true);
+		if (mvm->scan_status & IWL_MVM_SCAN_SCHED_MASK)
+			return iwl_mvm_scan_stop(mvm, IWL_MVM_SCAN_SCHED,
+						 true);
+
+		/* fall through, something is wrong if no scan was
+		 * running but we ran out of scans.
+		 */
 	default:
 		WARN_ON(1);
 		break;
-- 
2.9.3
