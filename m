Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:1907 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbbECTc1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:32:27 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/42] iwlwifi: mvm: don't wait for scan stopped work when cancelling scans
Date: Sun,  3 May 2015 22:31:18 +0300
Message-Id: <1430681513-7838-7-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213229_955165_D31EC736)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Now that we have separate flags for stopping scans, we don't need to
wait for the scan stopped work to complete before starting the new
scan.  Previously we needed it because we had no way of distinguishing
the scan that was being stopped from the scan that was currently
running.  With the new flags there won't be any confusions and we are
able to handle the stop for the correct type of scan.

Thus we can remove the iwl_mvm_cancel_scan_wait_notif() function.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 65 ++++++-----------------------
 1 file changed, 12 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index aff7de7..15dc4a4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2373,49 +2373,6 @@ static void iwl_mvm_bss_info_changed(struct ieee80211_hw *hw,
 	iwl_mvm_unref(mvm, IWL_MVM_REF_BSS_CHANGED);
 }
 
-static int iwl_mvm_cancel_scan_wait_notif(struct iwl_mvm *mvm,
-					  unsigned int scan_type)
-{
-	int ret;
-	bool wait_for_handlers = false;
-
-	mutex_lock(&mvm->mutex);
-
-	if (!(mvm->scan_status & scan_type)) {
-		ret = 0;
-		/* make sure there are no pending notifications */
-		wait_for_handlers = true;
-		goto out;
-	}
-
-	/* It's okay to switch on bitmask values here, because we can
-	 * only stop one scan type at a time.
-	 */
-	switch (scan_type) {
-	case IWL_MVM_SCAN_SCHED:
-		ret = iwl_mvm_scan_offload_stop(mvm, true);
-		break;
-	case IWL_MVM_SCAN_REGULAR:
-		ret = iwl_mvm_cancel_scan(mvm);
-		break;
-	default:
-		WARN_ON_ONCE(1);
-		ret = -EINVAL;
-		break;
-	}
-	if (ret)
-		goto out;
-
-	wait_for_handlers = true;
-out:
-	mutex_unlock(&mvm->mutex);
-
-	/* make sure we consume the completion notification */
-	if (wait_for_handlers)
-		iwl_mvm_wait_for_async_handlers(mvm);
-
-	return ret;
-}
 static int iwl_mvm_mac_hw_scan(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif,
 			       struct ieee80211_scan_request *hw_req)
@@ -2428,14 +2385,15 @@ static int iwl_mvm_mac_hw_scan(struct ieee80211_hw *hw,
 	    req->n_channels > mvm->fw->ucode_capa.n_scan_channels)
 		return -EINVAL;
 
-	if (!(mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)) {
-		ret = iwl_mvm_cancel_scan_wait_notif(mvm, IWL_MVM_SCAN_SCHED);
+	mutex_lock(&mvm->mutex);
+
+	if (!(mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) &&
+	    (mvm->scan_status & IWL_MVM_SCAN_SCHED)) {
+		ret = iwl_mvm_scan_offload_stop(mvm, true);
 		if (ret)
-			return ret;
+			goto out;
 	}
 
-	mutex_lock(&mvm->mutex);
-
 	if (iwl_mvm_is_lar_supported(mvm) && !mvm->lar_regdom_set) {
 		IWL_ERR(mvm, "scan while LAR regdomain is not set\n");
 		ret = -EBUSY;
@@ -2798,14 +2756,15 @@ static int iwl_mvm_mac_sched_scan_start(struct ieee80211_hw *hw,
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	int ret;
 
-	if (!(mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)) {
-		ret = iwl_mvm_cancel_scan_wait_notif(mvm, IWL_MVM_SCAN_REGULAR);
+	mutex_lock(&mvm->mutex);
+
+	if (!(mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) &&
+	    (mvm->scan_status & IWL_MVM_SCAN_REGULAR)) {
+		ret = iwl_mvm_cancel_scan(mvm);
 		if (ret)
-			return ret;
+			goto out;
 	}
 
-	mutex_lock(&mvm->mutex);
-
 	if (iwl_mvm_is_lar_supported(mvm) && !mvm->lar_regdom_set) {
 		IWL_ERR(mvm, "sched-scan while LAR regdomain is not set\n");
 		ret = -EBUSY;
-- 
2.1.0

