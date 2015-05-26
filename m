Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603AbbEZTSl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:18:41 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 23/39] iwlwifi: mvm: reorganize scan stopping functions
Date: Tue, 26 May 2015 22:17:36 +0300
Message-Id: <1432667872-18092-23-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150526_213348_565164_F51BCF77)
In-Reply-To: <1432667798.26624.3.camel@intel.com>
References: <1432667798.26624.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

The iwl_mvm_scan_offload_stop() function is used to stop LMAC regular
scan, stop LMAC scheduled scan and stop UMAC scheduled scans (but not
UMAC regular scans), making it very difficult to read.

Reorganize the scan stopping functions by creating separate functions
to stop regular and scheduled scans, separating the LMAC stopping part
of the code from the rest and renaming the offload_stop function to
iwl_mvm_lmac_scan_stop().

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c       |   2 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  10 +--
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |   4 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c     | 101 ++++++++++++++--------------
 4 files changed, 59 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 408b0ce..ceffc78 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -761,7 +761,7 @@ void iwl_mvm_set_last_nonqos_seq(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 static int iwl_mvm_switch_to_d3(struct iwl_mvm *mvm)
 {
-	iwl_mvm_cancel_scan(mvm);
+	iwl_mvm_reg_scan_stop(mvm);
 
 	iwl_trans_stop_device(mvm->trans);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index d13138e..1346931 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2360,8 +2360,10 @@ static void iwl_mvm_bss_info_changed(struct ieee80211_hw *hw,
 
 	mutex_lock(&mvm->mutex);
 
-	if (changes & BSS_CHANGED_IDLE && !bss_conf->idle)
-		iwl_mvm_scan_offload_stop(mvm, true);
+	if (changes & BSS_CHANGED_IDLE && !bss_conf->idle) {
+		iwl_mvm_sched_scan_stop(mvm, true);
+		iwl_mvm_reg_scan_stop(mvm);
+	}
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
@@ -2417,7 +2419,7 @@ static void iwl_mvm_mac_cancel_hw_scan(struct ieee80211_hw *hw,
 	 */
 	if ((mvm->scan_status & IWL_MVM_SCAN_REGULAR) ||
 	    (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN))
-		iwl_mvm_cancel_scan(mvm);
+		iwl_mvm_reg_scan_stop(mvm);
 
 	mutex_unlock(&mvm->mutex);
 }
@@ -2775,7 +2777,7 @@ static int iwl_mvm_mac_sched_scan_stop(struct ieee80211_hw *hw,
 		return 0;
 	}
 
-	ret = iwl_mvm_scan_offload_stop(mvm, false);
+	ret = iwl_mvm_sched_scan_stop(mvm, false);
 	mutex_unlock(&mvm->mutex);
 	iwl_mvm_wait_for_async_handlers(mvm);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 46668ef..71b7763 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1122,7 +1122,7 @@ int iwl_mvm_reg_scan_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			   struct cfg80211_scan_request *req,
 			   struct ieee80211_scan_ies *ies);
 int iwl_mvm_scan_size(struct iwl_mvm *mvm);
-int iwl_mvm_cancel_scan(struct iwl_mvm *mvm);
+int iwl_mvm_reg_scan_stop(struct iwl_mvm *mvm);
 int iwl_mvm_max_scan_ie_len(struct iwl_mvm *mvm);
 void iwl_mvm_report_scan_aborted(struct iwl_mvm *mvm);
 
@@ -1138,7 +1138,7 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 			     struct cfg80211_sched_scan_request *req,
 			     struct ieee80211_scan_ies *ies,
 			     int type);
-int iwl_mvm_scan_offload_stop(struct iwl_mvm *mvm, bool notify);
+int iwl_mvm_sched_scan_stop(struct iwl_mvm *mvm, bool notify);
 int iwl_mvm_rx_scan_offload_results(struct iwl_mvm *mvm,
 				    struct iwl_rx_cmd_buffer *rxb,
 				    struct iwl_device_cmd *cmd);
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 443562c..579b36b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -567,12 +567,6 @@ static int iwl_mvm_send_scan_offload_abort(struct iwl_mvm *mvm)
 	};
 	u32 status;
 
-	/* Exit instantly with error when device is not ready
-	 * to receive scan abort command or it does not perform
-	 * scheduled scan currently */
-	if (!mvm->scan_status)
-		return -EIO;
-
 	ret = iwl_mvm_send_cmd_status(mvm, &cmd, &status);
 	if (ret)
 		return ret;
@@ -592,30 +586,15 @@ static int iwl_mvm_send_scan_offload_abort(struct iwl_mvm *mvm)
 	return ret;
 }
 
-int iwl_mvm_scan_offload_stop(struct iwl_mvm *mvm, bool notify)
+static int iwl_mvm_lmac_scan_stop(struct iwl_mvm *mvm, int type)
 {
 	int ret;
 	struct iwl_notification_wait wait_scan_done;
 	static const u8 scan_done_notif[] = { SCAN_OFFLOAD_COMPLETE, };
-	bool sched = !!(mvm->scan_status & IWL_MVM_SCAN_SCHED);
+	bool sched = type & IWL_MVM_SCAN_SCHED;
 
 	lockdep_assert_held(&mvm->mutex);
 
-	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)
-		return iwl_umac_scan_stop(mvm, IWL_MVM_SCAN_SCHED, notify);
-
-	/* FIXME: For now we only check if no scan is set here, since
-	 * we only support LMAC in this flow and it doesn't support
-	 * multiple scans.
-	 */
-	if (!mvm->scan_status)
-		return 0;
-
-	if (iwl_mvm_is_radio_killed(mvm)) {
-		ret = 0;
-		goto out;
-	}
-
 	iwl_init_notification_wait(&mvm->notif_wait, &wait_scan_done,
 				   scan_done_notif,
 				   ARRAY_SIZE(scan_done_notif),
@@ -634,27 +613,6 @@ int iwl_mvm_scan_offload_stop(struct iwl_mvm *mvm, bool notify)
 
 	ret = iwl_wait_notification(&mvm->notif_wait, &wait_scan_done, 1 * HZ);
 out:
-	/* Clear the scan status so the next scan requests will
-	 * succeed and mark the scan as stopping, so that the Rx
-	 * handler doesn't do anything, as the scan was stopped from
-	 * above. Since the rx handler won't do anything now, we have
-	 * to release the scan reference here.
-	 */
-	if (mvm->scan_status == IWL_MVM_SCAN_REGULAR)
-		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
-
-	if (sched) {
-		mvm->scan_status &= ~IWL_MVM_SCAN_SCHED;
-		mvm->scan_status |= IWL_MVM_SCAN_STOPPING_SCHED;
-		if (notify)
-			ieee80211_sched_scan_stopped(mvm->hw);
-	} else {
-		mvm->scan_status &= ~IWL_MVM_SCAN_REGULAR;
-		mvm->scan_status |= IWL_MVM_SCAN_STOPPING_REGULAR;
-		if (notify)
-			ieee80211_scan_completed(mvm->hw, true);
-	}
-
 	return ret;
 }
 
@@ -927,8 +885,10 @@ static int iwl_mvm_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	return 0;
 }
 
-int iwl_mvm_cancel_scan(struct iwl_mvm *mvm)
+int iwl_mvm_reg_scan_stop(struct iwl_mvm *mvm)
 {
+	int ret;
+
 	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)
 		return iwl_umac_scan_stop(mvm, IWL_MVM_SCAN_REGULAR, true);
 
@@ -936,13 +896,52 @@ int iwl_mvm_cancel_scan(struct iwl_mvm *mvm)
 		return 0;
 
 	if (iwl_mvm_is_radio_killed(mvm)) {
-		ieee80211_scan_completed(mvm->hw, true);
-		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
-		mvm->scan_status &= ~IWL_MVM_SCAN_REGULAR;
+		ret = 0;
+		goto out;
+	}
+
+	ret = iwl_mvm_lmac_scan_stop(mvm, IWL_MVM_SCAN_REGULAR);
+	if (!ret)
+		mvm->scan_status |= IWL_MVM_SCAN_STOPPING_REGULAR;
+out:
+	/* Clear the scan status so the next scan requests will
+	 * succeed and mark the scan as stopping, so that the Rx
+	 * handler doesn't do anything, as the scan was stopped from
+	 * above. Since the rx handler won't do anything now, we have
+	 * to release the scan reference here.
+	 */
+	iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
+
+	mvm->scan_status &= ~IWL_MVM_SCAN_REGULAR;
+	ieee80211_scan_completed(mvm->hw, true);
+
+	return ret;
+}
+
+int iwl_mvm_sched_scan_stop(struct iwl_mvm *mvm, bool notify)
+{
+	int ret;
+
+	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)
+		return iwl_umac_scan_stop(mvm, IWL_MVM_SCAN_SCHED, notify);
+
+	if (!(mvm->scan_status & IWL_MVM_SCAN_SCHED))
 		return 0;
+
+	if (iwl_mvm_is_radio_killed(mvm)) {
+		ret = 0;
+		goto out;
 	}
 
-	return iwl_mvm_scan_offload_stop(mvm, true);
+	ret = iwl_mvm_lmac_scan_stop(mvm, IWL_MVM_SCAN_SCHED);
+	if (!ret)
+		mvm->scan_status |= IWL_MVM_SCAN_STOPPING_SCHED;
+out:
+	mvm->scan_status &= ~IWL_MVM_SCAN_SCHED;
+	if (notify)
+		ieee80211_sched_scan_stopped(mvm->hw);
+
+	return ret;
 }
 
 /* UMAC scan API */
@@ -1275,11 +1274,11 @@ static int iwl_mvm_check_running_scans(struct iwl_mvm *mvm, int type)
 	case IWL_MVM_SCAN_REGULAR:
 		if (mvm->scan_status & IWL_MVM_SCAN_REGULAR_MASK)
 			return -EBUSY;
-		return iwl_mvm_scan_offload_stop(mvm, true);
+		return iwl_mvm_sched_scan_stop(mvm, true);
 	case IWL_MVM_SCAN_SCHED:
 		if (mvm->scan_status & IWL_MVM_SCAN_SCHED_MASK)
 			return -EBUSY;
-		return iwl_mvm_cancel_scan(mvm);
+		return iwl_mvm_reg_scan_stop(mvm);
 	case IWL_MVM_SCAN_NETDETECT:
 		/* No need to stop anything for net-detect since the
 		 * firmware is restarted anyway.  This way, any sched
-- 
2.1.4

