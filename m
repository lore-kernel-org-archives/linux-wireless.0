Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:40007 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbbDBGmZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2015 02:42:25 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 18/31] iwlwifi: mvm: Clean up UMAC scan UIDs in the reset and drv_stop flows
Date: Thu,  2 Apr 2015 09:41:06 +0300
Message-Id: <1427956879-11725-18-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150402_090419_798190_132417AF)
In-Reply-To: <1427956656.8122.2.camel@egrumbacBox>
References: <1427956656.8122.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

In the reset flow, the driver cancels ongoing scan and sends scan
complete notification to mac80211. However it does not clean its UID.
Add cleaning scan UID for the ongoing scan. Loop over all other UIDs
to make sure there's nothing left there and warn if any is found.

Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 14 +++++++++++
 drivers/net/wireless/iwlwifi/mvm/scan.c     | 37 ++++++++++++++++++++++++++---
 2 files changed, 48 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 213bd72..07344e11 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1413,6 +1413,20 @@ void __iwl_mvm_mac_stop(struct iwl_mvm *mvm)
 	 */
 	clear_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status);
 
+	/* We shouldn't have any UIDs still set.  Loop over all the UIDs to
+	 * make sure there's nothing left there and warn if any is found.
+	 */
+	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) {
+		int i;
+
+		for (i = 0; i < IWL_MVM_MAX_SIMULTANEOUS_SCANS; i++) {
+			if (WARN_ONCE(mvm->scan_uid[i],
+				      "UMAC scan UID %d was not cleaned\n",
+				      mvm->scan_uid[i]))
+				mvm->scan_uid[i] = 0;
+		}
+	}
+
 	mvm->ucode_loaded = false;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 2997864..74e1c86 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -1179,6 +1179,18 @@ static bool iwl_mvm_find_scan_type(struct iwl_mvm *mvm,
 	return false;
 }
 
+static int iwl_mvm_find_first_scan(struct iwl_mvm *mvm,
+				   enum iwl_umac_scan_uid_type type)
+{
+	int i;
+
+	for (i = 0; i < IWL_MVM_MAX_SIMULTANEOUS_SCANS; i++)
+		if (mvm->scan_uid[i] & type)
+			return i;
+
+	return i;
+}
+
 static u32 iwl_generate_scan_uid(struct iwl_mvm *mvm,
 				 enum iwl_umac_scan_uid_type type)
 {
@@ -1629,11 +1641,30 @@ int iwl_mvm_scan_size(struct iwl_mvm *mvm)
 void iwl_mvm_report_scan_aborted(struct iwl_mvm *mvm)
 {
 	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) {
-		if (iwl_mvm_find_scan_type(mvm, IWL_UMAC_SCAN_UID_REG_SCAN))
+		u32 uid, i;
+
+		uid = iwl_mvm_find_first_scan(mvm, IWL_UMAC_SCAN_UID_REG_SCAN);
+		if (uid < IWL_MVM_MAX_SIMULTANEOUS_SCANS) {
 			ieee80211_scan_completed(mvm->hw, true);
-		if (iwl_mvm_find_scan_type(mvm, IWL_UMAC_SCAN_UID_SCHED_SCAN) &&
-		    !mvm->restart_fw)
+			mvm->scan_uid[uid] = 0;
+		}
+		uid = iwl_mvm_find_first_scan(mvm,
+					      IWL_UMAC_SCAN_UID_SCHED_SCAN);
+		if (uid < IWL_MVM_MAX_SIMULTANEOUS_SCANS && !mvm->restart_fw) {
 			ieee80211_sched_scan_stopped(mvm->hw);
+			mvm->scan_uid[uid] = 0;
+		}
+
+		/* We shouldn't have any UIDs still set.  Loop over all the
+		 * UIDs to make sure there's nothing left there and warn if
+		 * any is found.
+		 */
+		for (i = 0; i < IWL_MVM_MAX_SIMULTANEOUS_SCANS; i++) {
+			if (WARN_ONCE(mvm->scan_uid[i],
+				      "UMAC scan UID %d was not cleaned\n",
+				      mvm->scan_uid[i]))
+				mvm->scan_uid[i] = 0;
+		}
 	} else {
 		switch (mvm->scan_status) {
 		case IWL_MVM_SCAN_NONE:
-- 
1.9.1

