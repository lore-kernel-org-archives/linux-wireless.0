Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64527 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbbDBGln (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2015 02:41:43 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/31] iwlwifi: mvm: inform mac80211 about umac scans that was aborted by restart
Date: Thu,  2 Apr 2015 09:40:58 +0300
Message-Id: <1427956879-11725-10-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150402_084146_752303_EBFF58DC)
In-Reply-To: <1427956656.8122.2.camel@egrumbacBox>
References: <1427956656.8122.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

In nic restart flow we inform mac80211 that scan was aborted, but it was
based only on scan_status which is not set by UMAC scan. Fix that.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mvm.h  |  1 +
 drivers/net/wireless/iwlwifi/mvm/ops.c  | 13 +------------
 drivers/net/wireless/iwlwifi/mvm/scan.c | 32 ++++++++++++++++++++++++++++++++
 3 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 23c6c8a..02c02e2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1149,6 +1149,7 @@ int iwl_mvm_update_quotas(struct iwl_mvm *mvm, bool force_upload,
 int iwl_mvm_scan_size(struct iwl_mvm *mvm);
 int iwl_mvm_cancel_scan(struct iwl_mvm *mvm);
 int iwl_mvm_max_scan_ie_len(struct iwl_mvm *mvm, bool is_sched_scan);
+void iwl_mvm_report_scan_aborted(struct iwl_mvm *mvm);
 
 /* Scheduled scan */
 int iwl_mvm_rx_scan_offload_complete_notif(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 80121e4..a28080e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -894,18 +894,7 @@ void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error)
 	 * the next start() call from mac80211. If restart isn't called
 	 * (no fw restart) scan status will stay busy.
 	 */
-	switch (mvm->scan_status) {
-	case IWL_MVM_SCAN_NONE:
-		break;
-	case IWL_MVM_SCAN_OS:
-		ieee80211_scan_completed(mvm->hw, true);
-		break;
-	case IWL_MVM_SCAN_SCHED:
-		/* Sched scan will be restarted by mac80211 in restart_hw. */
-		if (!mvm->restart_fw)
-			ieee80211_sched_scan_stopped(mvm->hw);
-		break;
-	}
+	iwl_mvm_report_scan_aborted(mvm);
 
 	/*
 	 * If we're restarting already, don't cycle restarts.
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index a75bb15..6352587 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -1613,3 +1613,35 @@ int iwl_mvm_scan_size(struct iwl_mvm *mvm)
 		mvm->fw->ucode_capa.n_scan_channels +
 		sizeof(struct iwl_scan_probe_req);
 }
+
+/*
+ * This function is used in nic restart flow, to inform mac80211 about scans
+ * that was aborted by restart flow or by an assert.
+ */
+void iwl_mvm_report_scan_aborted(struct iwl_mvm *mvm)
+{
+	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) {
+		if (iwl_mvm_find_scan_type(mvm, IWL_UMAC_SCAN_UID_REG_SCAN))
+			ieee80211_scan_completed(mvm->hw, true);
+		if (iwl_mvm_find_scan_type(mvm, IWL_UMAC_SCAN_UID_SCHED_SCAN) &&
+		    !mvm->restart_fw)
+			ieee80211_sched_scan_stopped(mvm->hw);
+	} else {
+		switch (mvm->scan_status) {
+		case IWL_MVM_SCAN_NONE:
+			break;
+		case IWL_MVM_SCAN_OS:
+			ieee80211_scan_completed(mvm->hw, true);
+			break;
+		case IWL_MVM_SCAN_SCHED:
+			/*
+			 * Sched scan will be restarted by mac80211 in
+			 * restart_hw, so do not report if FW is about to be
+			 * restarted.
+			 */
+			if (!mvm->restart_fw)
+				ieee80211_sched_scan_stopped(mvm->hw);
+			break;
+		}
+	}
+}
-- 
1.9.1

