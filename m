Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:54805 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbbCEMuB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2015 07:50:01 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/7] iwlwifi: mvm: call ieee80211_scan_completed() even if scan abort fails
Date: Thu,  5 Mar 2015 14:49:47 +0200
Message-Id: <1425559793-25131-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150305_135006_035911_F20AF6DA)
In-Reply-To: <1425558068.22928.3.camel@egrumbacBox>
References: <1425558068.22928.3.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

A scan abort command failure is not that unusual, since we may try to
send it after the scan has actually completed but before we received
the completed notification from the firmware.  The scan abort can also
fail for other reasons, such as a timeout.  In such cases, we should
clear things up so the next scans will work again.  To do so, don't
return immediately in case of failures, but call
ieee80211_scan_completed() and clear the scan_status flags.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 7e9aa3c..c47c8051 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -1128,8 +1128,10 @@ int iwl_mvm_scan_offload_stop(struct iwl_mvm *mvm, bool notify)
 	if (mvm->scan_status == IWL_MVM_SCAN_NONE)
 		return 0;
 
-	if (iwl_mvm_is_radio_killed(mvm))
+	if (iwl_mvm_is_radio_killed(mvm)) {
+		ret = 0;
 		goto out;
+	}
 
 	if (mvm->scan_status != IWL_MVM_SCAN_SCHED &&
 	    (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN) ||
@@ -1148,16 +1150,14 @@ int iwl_mvm_scan_offload_stop(struct iwl_mvm *mvm, bool notify)
 		IWL_DEBUG_SCAN(mvm, "Send stop %sscan failed %d\n",
 			       sched ? "offloaded " : "", ret);
 		iwl_remove_notification(&mvm->notif_wait, &wait_scan_done);
-		return ret;
+		goto out;
 	}
 
 	IWL_DEBUG_SCAN(mvm, "Successfully sent stop %sscan\n",
 		       sched ? "offloaded " : "");
 
 	ret = iwl_wait_notification(&mvm->notif_wait, &wait_scan_done, 1 * HZ);
-	if (ret)
-		return ret;
-
+out:
 	/*
 	 * Clear the scan status so the next scan requests will succeed. This
 	 * also ensures the Rx handler doesn't do anything, as the scan was
@@ -1167,7 +1167,6 @@ int iwl_mvm_scan_offload_stop(struct iwl_mvm *mvm, bool notify)
 	if (mvm->scan_status == IWL_MVM_SCAN_OS)
 		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
 
-out:
 	mvm->scan_status = IWL_MVM_SCAN_NONE;
 
 	if (notify) {
@@ -1177,7 +1176,7 @@ out:
 			ieee80211_scan_completed(mvm->hw, true);
 	}
 
-	return 0;
+	return ret;
 }
 
 static void iwl_mvm_unified_scan_fill_tx_cmd(struct iwl_mvm *mvm,
-- 
1.9.1

