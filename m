Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:1907 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbbECTc3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:32:29 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/42] iwlwifi: mvm: check if scan can be started before cancelling other scans
Date: Sun,  3 May 2015 22:31:19 +0300
Message-Id: <1430681513-7838-8-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213234_157556_BF88D6C3)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

If a new scan cannot be run for some reason, we shouldn't cancel other
ongoing scans.  Move the checks to before the code that cancels other
scans.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 15dc4a4..f57d584 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2387,13 +2387,6 @@ static int iwl_mvm_mac_hw_scan(struct ieee80211_hw *hw,
 
 	mutex_lock(&mvm->mutex);
 
-	if (!(mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) &&
-	    (mvm->scan_status & IWL_MVM_SCAN_SCHED)) {
-		ret = iwl_mvm_scan_offload_stop(mvm, true);
-		if (ret)
-			goto out;
-	}
-
 	if (iwl_mvm_is_lar_supported(mvm) && !mvm->lar_regdom_set) {
 		IWL_ERR(mvm, "scan while LAR regdomain is not set\n");
 		ret = -EBUSY;
@@ -2405,6 +2398,13 @@ static int iwl_mvm_mac_hw_scan(struct ieee80211_hw *hw,
 		goto out;
 	}
 
+	if (!(mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) &&
+	    (mvm->scan_status & IWL_MVM_SCAN_SCHED)) {
+		ret = iwl_mvm_scan_offload_stop(mvm, true);
+		if (ret)
+			goto out;
+	}
+
 	iwl_mvm_ref(mvm, IWL_MVM_REF_SCAN);
 
 	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)
@@ -2758,13 +2758,6 @@ static int iwl_mvm_mac_sched_scan_start(struct ieee80211_hw *hw,
 
 	mutex_lock(&mvm->mutex);
 
-	if (!(mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) &&
-	    (mvm->scan_status & IWL_MVM_SCAN_REGULAR)) {
-		ret = iwl_mvm_cancel_scan(mvm);
-		if (ret)
-			goto out;
-	}
-
 	if (iwl_mvm_is_lar_supported(mvm) && !mvm->lar_regdom_set) {
 		IWL_ERR(mvm, "sched-scan while LAR regdomain is not set\n");
 		ret = -EBUSY;
@@ -2781,6 +2774,13 @@ static int iwl_mvm_mac_sched_scan_start(struct ieee80211_hw *hw,
 		goto out;
 	}
 
+	if (!(mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) &&
+	    (mvm->scan_status & IWL_MVM_SCAN_REGULAR)) {
+		ret = iwl_mvm_cancel_scan(mvm);
+		if (ret)
+			goto out;
+	}
+
 	ret = iwl_mvm_scan_offload_start(mvm, vif, req, ies);
 	if (ret)
 		mvm->scan_status &= ~IWL_MVM_SCAN_SCHED;
-- 
2.1.0

