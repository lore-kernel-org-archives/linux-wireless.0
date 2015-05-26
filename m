Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbbEZTSu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:18:50 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 27/39] iwlwifi: mvm: rename some LMAC-specific scan functions
Date: Tue, 26 May 2015 22:17:40 +0300
Message-Id: <1432667872-18092-27-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150526_211943_902544_6C331DDB)
In-Reply-To: <1432667798.26624.3.camel@intel.com>
References: <1432667798.26624.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Some LMAC specific functions had too generic names
(i.e. *_scan_offload_*) and were hard to distinguish from functions
that are really generic.  Rename these functions to *_lmac_scan_* in
to make it more consistent and easier to read.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mvm.h  | 18 +++++++++---------
 drivers/net/wireless/iwlwifi/mvm/ops.c  |  6 +++---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 22 +++++++++++-----------
 3 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 71b7763..760c626 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1127,21 +1127,21 @@ int iwl_mvm_max_scan_ie_len(struct iwl_mvm *mvm);
 void iwl_mvm_report_scan_aborted(struct iwl_mvm *mvm);
 
 /* Scheduled scan */
-int iwl_mvm_rx_scan_offload_complete_notif(struct iwl_mvm *mvm,
-					   struct iwl_rx_cmd_buffer *rxb,
-					   struct iwl_device_cmd *cmd);
-int iwl_mvm_rx_scan_offload_iter_complete_notif(struct iwl_mvm *mvm,
-						struct iwl_rx_cmd_buffer *rxb,
-						struct iwl_device_cmd *cmd);
+int iwl_mvm_rx_lmac_scan_complete_notif(struct iwl_mvm *mvm,
+					struct iwl_rx_cmd_buffer *rxb,
+					struct iwl_device_cmd *cmd);
+int iwl_mvm_rx_lmac_scan_iter_complete_notif(struct iwl_mvm *mvm,
+					     struct iwl_rx_cmd_buffer *rxb,
+					     struct iwl_device_cmd *cmd);
 int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 			     struct ieee80211_vif *vif,
 			     struct cfg80211_sched_scan_request *req,
 			     struct ieee80211_scan_ies *ies,
 			     int type);
 int iwl_mvm_sched_scan_stop(struct iwl_mvm *mvm, bool notify);
-int iwl_mvm_rx_scan_offload_results(struct iwl_mvm *mvm,
-				    struct iwl_rx_cmd_buffer *rxb,
-				    struct iwl_device_cmd *cmd);
+int iwl_mvm_rx_scan_match_found(struct iwl_mvm *mvm,
+				struct iwl_rx_cmd_buffer *rxb,
+				struct iwl_device_cmd *cmd);
 
 /* UMAC scan */
 int iwl_mvm_config_scan(struct iwl_mvm *mvm);
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 4935caf..690b336 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -238,10 +238,10 @@ static const struct iwl_rx_handlers iwl_mvm_rx_handlers[] = {
 	RX_HANDLER(EOSP_NOTIFICATION, iwl_mvm_rx_eosp_notif, false),
 
 	RX_HANDLER(SCAN_ITERATION_COMPLETE,
-		   iwl_mvm_rx_scan_offload_iter_complete_notif, false),
+		   iwl_mvm_rx_lmac_scan_iter_complete_notif, false),
 	RX_HANDLER(SCAN_OFFLOAD_COMPLETE,
-		   iwl_mvm_rx_scan_offload_complete_notif, true),
-	RX_HANDLER(MATCH_FOUND_NOTIFICATION, iwl_mvm_rx_scan_offload_results,
+		   iwl_mvm_rx_lmac_scan_complete_notif, true),
+	RX_HANDLER(MATCH_FOUND_NOTIFICATION, iwl_mvm_rx_scan_match_found,
 		   false),
 	RX_HANDLER(SCAN_COMPLETE_UMAC, iwl_mvm_rx_umac_scan_complete_notif,
 		   true),
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index bee92d7..9becece 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -325,9 +325,9 @@ static u8 *iwl_mvm_dump_channel_list(struct iwl_scan_results_notif *res,
 	return buf;
 }
 
-int iwl_mvm_rx_scan_offload_iter_complete_notif(struct iwl_mvm *mvm,
-						struct iwl_rx_cmd_buffer *rxb,
-						struct iwl_device_cmd *cmd)
+int iwl_mvm_rx_lmac_scan_iter_complete_notif(struct iwl_mvm *mvm,
+					     struct iwl_rx_cmd_buffer *rxb,
+					     struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_lmac_scan_complete_notif *notif = (void *)pkt->data;
@@ -342,9 +342,9 @@ int iwl_mvm_rx_scan_offload_iter_complete_notif(struct iwl_mvm *mvm,
 	return 0;
 }
 
-int iwl_mvm_rx_scan_offload_results(struct iwl_mvm *mvm,
-				    struct iwl_rx_cmd_buffer *rxb,
-				    struct iwl_device_cmd *cmd)
+int iwl_mvm_rx_scan_match_found(struct iwl_mvm *mvm,
+				struct iwl_rx_cmd_buffer *rxb,
+				struct iwl_device_cmd *cmd)
 {
 	IWL_DEBUG_SCAN(mvm, "Scheduled scan results\n");
 	ieee80211_sched_scan_results(mvm->hw);
@@ -352,9 +352,9 @@ int iwl_mvm_rx_scan_offload_results(struct iwl_mvm *mvm,
 	return 0;
 }
 
-int iwl_mvm_rx_scan_offload_complete_notif(struct iwl_mvm *mvm,
-					   struct iwl_rx_cmd_buffer *rxb,
-					   struct iwl_device_cmd *cmd)
+int iwl_mvm_rx_lmac_scan_complete_notif(struct iwl_mvm *mvm,
+					struct iwl_rx_cmd_buffer *rxb,
+					struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_periodic_scan_complete *scan_notif = (void *)pkt->data;
@@ -557,7 +557,7 @@ static bool iwl_mvm_scan_pass_all(struct iwl_mvm *mvm,
 	return true;
 }
 
-static int iwl_mvm_send_scan_offload_abort(struct iwl_mvm *mvm)
+static int iwl_mvm_send_lmac_scan_abort(struct iwl_mvm *mvm)
 {
 	int ret;
 	struct iwl_host_cmd cmd = {
@@ -598,7 +598,7 @@ static int iwl_mvm_lmac_scan_stop(struct iwl_mvm *mvm, int type)
 				   ARRAY_SIZE(scan_done_notif),
 				   NULL, NULL);
 
-	ret = iwl_mvm_send_scan_offload_abort(mvm);
+	ret = iwl_mvm_send_lmac_scan_abort(mvm);
 	if (ret) {
 		IWL_DEBUG_SCAN(mvm, "Send stop %sscan failed %d\n",
 			       sched ? "offloaded " : "", ret);
-- 
2.1.4

