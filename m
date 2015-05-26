Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603AbbEZTSr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:18:47 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 26/39] iwlwifi: mvm: rename umac scan stop function
Date: Tue, 26 May 2015 22:17:39 +0300
Message-Id: <1432667872-18092-26-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150526_213349_200438_1775BCF2)
In-Reply-To: <1432667798.26624.3.camel@intel.com>
References: <1432667798.26624.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

For consistency with the LMAC functions, rename the UMAC scan stop
function to iwl_mvm_umac_scan_stop().  Additionally, move things
around a bit to avoid an unnecessary forward declaration.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 126 ++++++++++++++++----------------
 1 file changed, 62 insertions(+), 64 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index ec8ef56..bee92d7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -101,8 +101,6 @@ struct iwl_mvm_scan_params {
 	} schedule[2];
 };
 
-static int iwl_umac_scan_stop(struct iwl_mvm *mvm, int type);
-
 static u8 iwl_mvm_scan_rx_ant(struct iwl_mvm *mvm)
 {
 	if (mvm->scan_rx_ant != ANT_NONE)
@@ -885,67 +883,6 @@ static int iwl_mvm_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	return 0;
 }
 
-int iwl_mvm_reg_scan_stop(struct iwl_mvm *mvm)
-{
-	int ret;
-
-	if (!(mvm->scan_status & IWL_MVM_SCAN_REGULAR))
-		return 0;
-
-	if (iwl_mvm_is_radio_killed(mvm)) {
-		ret = 0;
-		goto out;
-	}
-
-	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)
-		ret = iwl_umac_scan_stop(mvm, IWL_MVM_SCAN_REGULAR);
-	else
-		ret = iwl_mvm_lmac_scan_stop(mvm, IWL_MVM_SCAN_REGULAR);
-
-	if (!ret)
-		mvm->scan_status |= IWL_MVM_SCAN_STOPPING_REGULAR;
-out:
-	/* Clear the scan status so the next scan requests will
-	 * succeed and mark the scan as stopping, so that the Rx
-	 * handler doesn't do anything, as the scan was stopped from
-	 * above. Since the rx handler won't do anything now, we have
-	 * to release the scan reference here.
-	 */
-	iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
-
-	mvm->scan_status &= ~IWL_MVM_SCAN_REGULAR;
-	ieee80211_scan_completed(mvm->hw, true);
-
-	return ret;
-}
-
-int iwl_mvm_sched_scan_stop(struct iwl_mvm *mvm, bool notify)
-{
-	int ret;
-
-	if (!(mvm->scan_status & IWL_MVM_SCAN_SCHED))
-		return 0;
-
-	if (iwl_mvm_is_radio_killed(mvm)) {
-		ret = 0;
-		goto out;
-	}
-
-	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)
-		ret = iwl_umac_scan_stop(mvm, IWL_MVM_SCAN_SCHED);
-	else
-		ret = iwl_mvm_lmac_scan_stop(mvm, IWL_MVM_SCAN_SCHED);
-
-	if (!ret)
-		mvm->scan_status |= IWL_MVM_SCAN_STOPPING_SCHED;
-out:
-	mvm->scan_status &= ~IWL_MVM_SCAN_SCHED;
-	if (notify)
-		ieee80211_sched_scan_stopped(mvm->hw);
-
-	return ret;
-}
-
 /* UMAC scan API */
 
 struct iwl_umac_scan_done {
@@ -1587,7 +1524,7 @@ static int iwl_umac_scan_abort_one(struct iwl_mvm *mvm, u32 uid)
 	return iwl_mvm_send_cmd_pdu(mvm, SCAN_ABORT_UMAC, 0, sizeof(cmd), &cmd);
 }
 
-static int iwl_umac_scan_stop(struct iwl_mvm *mvm, int type)
+static int iwl_mvm_umac_scan_stop(struct iwl_mvm *mvm, int type)
 {
 	struct iwl_notification_wait wait_scan_done;
 	static const u8 scan_done_notif[] = { SCAN_COMPLETE_UMAC, };
@@ -1681,3 +1618,64 @@ void iwl_mvm_report_scan_aborted(struct iwl_mvm *mvm)
 			ieee80211_sched_scan_stopped(mvm->hw);
 	}
 }
+
+int iwl_mvm_reg_scan_stop(struct iwl_mvm *mvm)
+{
+	int ret;
+
+	if (!(mvm->scan_status & IWL_MVM_SCAN_REGULAR))
+		return 0;
+
+	if (iwl_mvm_is_radio_killed(mvm)) {
+		ret = 0;
+		goto out;
+	}
+
+	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)
+		ret = iwl_mvm_umac_scan_stop(mvm, IWL_MVM_SCAN_REGULAR);
+	else
+		ret = iwl_mvm_lmac_scan_stop(mvm, IWL_MVM_SCAN_REGULAR);
+
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
+	if (!(mvm->scan_status & IWL_MVM_SCAN_SCHED))
+		return 0;
+
+	if (iwl_mvm_is_radio_killed(mvm)) {
+		ret = 0;
+		goto out;
+	}
+
+	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)
+		ret = iwl_mvm_umac_scan_stop(mvm, IWL_MVM_SCAN_SCHED);
+	else
+		ret = iwl_mvm_lmac_scan_stop(mvm, IWL_MVM_SCAN_SCHED);
+
+	if (!ret)
+		mvm->scan_status |= IWL_MVM_SCAN_STOPPING_SCHED;
+out:
+	mvm->scan_status &= ~IWL_MVM_SCAN_SCHED;
+	if (notify)
+		ieee80211_sched_scan_stopped(mvm->hw);
+
+	return ret;
+}
-- 
2.1.4

