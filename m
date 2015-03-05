Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:54805 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340AbbCEMuF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2015 07:50:05 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3/7] iwlwifi: mvm: don't try to stop scans that are not running anymore
Date: Thu,  5 Mar 2015 14:49:49 +0200
Message-Id: <1425559793-25131-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150305_135015_629207_C8E8E036)
In-Reply-To: <1425558068.22928.3.camel@egrumbacBox>
References: <1425558068.22928.3.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

In certain conditions, mac80211 may ask us to stop a scan (scheduled
or normal) that is not running anymore.  This can also happen when we
are doing a different type of scan, for instance, mac80211 can ask us
to stop a scheduled scan when we are running a normal scan, due to
some race conditions.  In this case, we would stop the wrong type of
scan and leave everything everything in a wrong state.

To fix this, simply ignore scan stop requests for scans types that are
not running.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 33 +++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 1ff7ec0..35feebf 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2215,7 +2215,19 @@ static void iwl_mvm_mac_cancel_hw_scan(struct ieee80211_hw *hw,
 
 	mutex_lock(&mvm->mutex);
 
-	iwl_mvm_cancel_scan(mvm);
+	/* Due to a race condition, it's possible that mac80211 asks
+	 * us to stop a hw_scan when it's already stopped.  This can
+	 * happen, for instance, if we stopped the scan ourselves,
+	 * called ieee80211_scan_completed() and the userspace called
+	 * cancel scan scan before ieee80211_scan_work() could run.
+	 * To handle that, simply return if the scan is not running.
+	*/
+	/* FIXME: for now, we ignore this race for UMAC scans, since
+	 * they don't set the scan_status.
+	 */
+	if ((mvm->scan_status == IWL_MVM_SCAN_OS) ||
+	    (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN))
+		iwl_mvm_cancel_scan(mvm);
 
 	mutex_unlock(&mvm->mutex);
 }
@@ -2559,12 +2571,29 @@ static int iwl_mvm_mac_sched_scan_stop(struct ieee80211_hw *hw,
 	int ret;
 
 	mutex_lock(&mvm->mutex);
+
+	/* Due to a race condition, it's possible that mac80211 asks
+	 * us to stop a sched_scan when it's already stopped.  This
+	 * can happen, for instance, if we stopped the scan ourselves,
+	 * called ieee80211_sched_scan_stopped() and the userspace called
+	 * stop sched scan scan before ieee80211_sched_scan_stopped_work()
+	 * could run.  To handle this, simply return if the scan is
+	 * not running.
+	*/
+	/* FIXME: for now, we ignore this race for UMAC scans, since
+	 * they don't set the scan_status.
+	 */
+	if (mvm->scan_status != IWL_MVM_SCAN_SCHED &&
+	    !(mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)) {
+		mutex_unlock(&mvm->mutex);
+		return 0;
+	}
+
 	ret = iwl_mvm_scan_offload_stop(mvm, false);
 	mutex_unlock(&mvm->mutex);
 	iwl_mvm_wait_for_async_handlers(mvm);
 
 	return ret;
-
 }
 
 static int iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
-- 
1.9.1

