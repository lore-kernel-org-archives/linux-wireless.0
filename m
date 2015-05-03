Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:1907 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbbECTce (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:32:34 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/42] iwlwifi: mvm: differentiate net-detect from sched scan
Date: Sun,  3 May 2015 22:31:23 +0300
Message-Id: <1430681513-7838-12-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213418_542230_29A110DB)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Net-detect scans were using the same type as sched scan, which was
causing the driver to return -EBUSY and prevent the system from
suspending if there was an ongoing scheduled scan.  To avoid this, add
a new type for net-detect and don't stop anything when it is
requested, so that the existing scheduled scan will be resumed when
the system wakes up.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c       |  3 ++-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  2 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  7 ++++++-
 drivers/net/wireless/iwlwifi/mvm/scan.c     | 12 ++++++++++--
 4 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index e82a47b..36bf6a8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -981,7 +981,8 @@ iwl_mvm_netdetect_config(struct iwl_mvm *mvm,
 	if (ret)
 		return ret;
 
-	ret = iwl_mvm_sched_scan_start(mvm, vif, nd_config, &mvm->nd_ies);
+	ret = iwl_mvm_sched_scan_start(mvm, vif, nd_config, &mvm->nd_ies,
+				       IWL_MVM_SCAN_NETDETECT);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index ff3273a..c136fe0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2743,7 +2743,7 @@ static int iwl_mvm_mac_sched_scan_start(struct ieee80211_hw *hw,
 		goto out;
 	}
 
-	ret = iwl_mvm_sched_scan_start(mvm, vif, req, ies);
+	ret = iwl_mvm_sched_scan_start(mvm, vif, req, ies, IWL_MVM_SCAN_SCHED);
 
 out:
 	mutex_unlock(&mvm->mutex);
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index bbe4d98..a8f51a8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -448,14 +448,18 @@ extern const u8 tid_to_mac80211_ac[];
 enum iwl_scan_status {
 	IWL_MVM_SCAN_REGULAR		= BIT(0),
 	IWL_MVM_SCAN_SCHED		= BIT(1),
+	IWL_MVM_SCAN_NETDETECT		= BIT(2),
 
 	IWL_MVM_SCAN_STOPPING_REGULAR	= BIT(8),
 	IWL_MVM_SCAN_STOPPING_SCHED	= BIT(9),
+	IWL_MVM_SCAN_STOPPING_NETDETECT	= BIT(10),
 
 	IWL_MVM_SCAN_REGULAR_MASK	= IWL_MVM_SCAN_REGULAR |
 					  IWL_MVM_SCAN_STOPPING_REGULAR,
 	IWL_MVM_SCAN_SCHED_MASK		= IWL_MVM_SCAN_SCHED |
 					  IWL_MVM_SCAN_STOPPING_SCHED,
+	IWL_MVM_SCAN_NETDETECT_MASK	= IWL_MVM_SCAN_NETDETECT |
+					  IWL_MVM_SCAN_STOPPING_NETDETECT,
 
 	IWL_MVM_SCAN_STOPPING_MASK	= 0xff00,
 	IWL_MVM_SCAN_MASK		= 0x00ff,
@@ -1179,7 +1183,8 @@ int iwl_mvm_config_sched_scan_profiles(struct iwl_mvm *mvm,
 int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 			     struct ieee80211_vif *vif,
 			     struct cfg80211_sched_scan_request *req,
-			     struct ieee80211_scan_ies *ies);
+			     struct ieee80211_scan_ies *ies,
+			     int type);
 int iwl_mvm_scan_offload_stop(struct iwl_mvm *mvm, bool notify);
 int iwl_mvm_rx_scan_offload_results(struct iwl_mvm *mvm,
 				    struct iwl_rx_cmd_buffer *rxb,
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 3fe398e..e39f2d1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -1533,6 +1533,13 @@ static int iwl_mvm_check_running_scans(struct iwl_mvm *mvm, int type)
 		if (mvm->scan_status & IWL_MVM_SCAN_SCHED_MASK)
 			return -EBUSY;
 		return iwl_mvm_cancel_scan(mvm);
+	case IWL_MVM_SCAN_NETDETECT:
+		/* No need to stop anything for net-detect since the
+		 * firmware is restarted anyway.  This way, any sched
+		 * scans that were running will be restarted when we
+		 * resume.
+		*/
+		return 0;
 	default:
 		WARN_ON(1);
 		break;
@@ -1574,7 +1581,8 @@ int iwl_mvm_reg_scan_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 			     struct ieee80211_vif *vif,
 			     struct cfg80211_sched_scan_request *req,
-			     struct ieee80211_scan_ies *ies)
+			     struct ieee80211_scan_ies *ies,
+			     int type)
 {
 	int ret;
 
@@ -1585,7 +1593,7 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 		return -EBUSY;
 	}
 
-	ret = iwl_mvm_check_running_scans(mvm, IWL_MVM_SCAN_SCHED);
+	ret = iwl_mvm_check_running_scans(mvm, type);
 	if (ret)
 		return ret;
 
-- 
2.1.0

