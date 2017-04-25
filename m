Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54122 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1954151AbdDYUXG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 16:23:06 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org,
        Mordechai Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 25 Apr 2017 23:22:22 +0300
Message-Id: <20170425202243.7844-5-luca@coelho.fi> (sfid-20170425_222323_306903_D29805C7)
In-Reply-To: <20170425202243.7844-1-luca@coelho.fi>
References: <20170425202243.7844-1-luca@coelho.fi>
Subject: [PATCH 04/25] iwlwifi: mvm: scan: avoid "big" prints
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mordechai Goodstein <mordechay.goodstein@intel.com>

Delete the scanned channel results.
No need in it we get it any way when logging.
The print only clogs up the ftrace print buffer.

Signed-off-by: Mordechai Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 31 ++++-----------------------
 1 file changed, 4 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 9668f945b4e6..ca6f3a82b277 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -294,34 +294,15 @@ int iwl_mvm_max_scan_ie_len(struct iwl_mvm *mvm)
 	return max_ie_len;
 }
 
-static u8 *iwl_mvm_dump_channel_list(struct iwl_scan_results_notif *res,
-				     int num_res, u8 *buf, size_t buf_size)
-{
-	int i;
-	u8 *pos = buf, *end = buf + buf_size;
-
-	for (i = 0; pos < end && i < num_res; i++)
-		pos += snprintf(pos, end - pos, " %u", res[i].channel);
-
-	/* terminate the string in case the buffer was too short */
-	*(buf + buf_size - 1) = '\0';
-
-	return buf;
-}
-
 void iwl_mvm_rx_lmac_scan_iter_complete_notif(struct iwl_mvm *mvm,
 					      struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_lmac_scan_complete_notif *notif = (void *)pkt->data;
-	u8 buf[256];
 
 	IWL_DEBUG_SCAN(mvm,
-		       "Scan offload iteration complete: status=0x%x scanned channels=%d channels list: %s\n",
-		       notif->status, notif->scanned_channels,
-		       iwl_mvm_dump_channel_list(notif->results,
-						 notif->scanned_channels, buf,
-						 sizeof(buf)));
+		       "Scan offload iteration complete: status=0x%x scanned channels=%d\n",
+		       notif->status, notif->scanned_channels);
 
 	if (mvm->sched_scan_pass_all == SCHED_SCAN_PASS_ALL_FOUND) {
 		IWL_DEBUG_SCAN(mvm, "Pass all scheduled scan results found\n");
@@ -1612,16 +1593,12 @@ void iwl_mvm_rx_umac_scan_iter_complete_notif(struct iwl_mvm *mvm,
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_umac_scan_iter_complete_notif *notif = (void *)pkt->data;
-	u8 buf[256];
 
 	mvm->scan_start = le64_to_cpu(notif->start_tsf);
 
 	IWL_DEBUG_SCAN(mvm,
-		       "UMAC Scan iteration complete: status=0x%x scanned_channels=%d channels list: %s\n",
-		       notif->status, notif->scanned_channels,
-		       iwl_mvm_dump_channel_list(notif->results,
-						 notif->scanned_channels, buf,
-						 sizeof(buf)));
+		       "UMAC Scan iteration complete: status=0x%x scanned_channels=%d\n",
+		       notif->status, notif->scanned_channels);
 
 	if (mvm->sched_scan_pass_all == SCHED_SCAN_PASS_ALL_FOUND) {
 		IWL_DEBUG_SCAN(mvm, "Pass all scheduled scan results found\n");
-- 
2.11.0
