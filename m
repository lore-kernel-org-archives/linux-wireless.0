Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:22835 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965572AbbD1MnW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2015 08:43:22 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Avraham Stern <avraham.stern@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3/8] iwlwifi: mvm: fix scan iteration complete notification handling
Date: Tue, 28 Apr 2015 15:43:07 +0300
Message-Id: <1430224992-20327-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150428_144335_247189_AB6BE904)
In-Reply-To: <1430224907.4748.3.camel@intel.com>
References: <1430224907.4748.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

Scan iteration complete notification handling uses the wrong FW API
version (version 2 instead of version 3).
Fix that by removing version 2 API which is no longer used, and using
only the updated version.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Reviewed-by: David Spinadel <david.spinadel@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h | 44 ++------------------------
 drivers/net/wireless/iwlwifi/mvm/scan.c        |  2 +-
 2 files changed, 3 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
index 4f81dcf..d6cced4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
@@ -122,46 +122,6 @@ enum iwl_scan_complete_status {
 	SCAN_COMP_STATUS_ERR_ALLOC_TE = 0x0C,
 };
 
-/**
- * struct iwl_scan_results_notif - scan results for one channel
- * ( SCAN_RESULTS_NOTIFICATION = 0x83 )
- * @channel: which channel the results are from
- * @band: 0 for 5.2 GHz, 1 for 2.4 GHz
- * @probe_status: SCAN_PROBE_STATUS_*, indicates success of probe request
- * @num_probe_not_sent: # of request that weren't sent due to not enough time
- * @duration: duration spent in channel, in usecs
- * @statistics: statistics gathered for this channel
- */
-struct iwl_scan_results_notif {
-	u8 channel;
-	u8 band;
-	u8 probe_status;
-	u8 num_probe_not_sent;
-	__le32 duration;
-	__le32 statistics[SCAN_RESULTS_STATISTICS];
-} __packed; /* SCAN_RESULT_NTF_API_S_VER_2 */
-
-/**
- * struct iwl_scan_complete_notif - notifies end of scanning (all channels)
- * ( SCAN_COMPLETE_NOTIFICATION = 0x84 )
- * @scanned_channels: number of channels scanned (and number of valid results)
- * @status: one of SCAN_COMP_STATUS_*
- * @bt_status: BT on/off status
- * @last_channel: last channel that was scanned
- * @tsf_low: TSF timer (lower half) in usecs
- * @tsf_high: TSF timer (higher half) in usecs
- * @results: array of scan results, only "scanned_channels" of them are valid
- */
-struct iwl_scan_complete_notif {
-	u8 scanned_channels;
-	u8 status;
-	u8 bt_status;
-	u8 last_channel;
-	__le32 tsf_low;
-	__le32 tsf_high;
-	struct iwl_scan_results_notif results[];
-} __packed; /* SCAN_COMPLETE_NTF_API_S_VER_2 */
-
 /* scan offload */
 #define IWL_SCAN_MAX_BLACKLIST_LEN	64
 #define IWL_SCAN_SHORT_BLACKLIST_LEN	16
@@ -554,7 +514,7 @@ struct iwl_scan_req_unified_lmac {
 } __packed;
 
 /**
- * struct iwl_lmac_scan_results_notif - scan results for one channel -
+ * struct iwl_scan_results_notif - scan results for one channel -
  *	SCAN_RESULT_NTF_API_S_VER_3
  * @channel: which channel the results are from
  * @band: 0 for 5.2 GHz, 1 for 2.4 GHz
@@ -562,7 +522,7 @@ struct iwl_scan_req_unified_lmac {
  * @num_probe_not_sent: # of request that weren't sent due to not enough time
  * @duration: duration spent in channel, in usecs
  */
-struct iwl_lmac_scan_results_notif {
+struct iwl_scan_results_notif {
 	u8 channel;
 	u8 band;
 	u8 probe_status;
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 74e1c86..1075a21 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -319,7 +319,7 @@ int iwl_mvm_rx_scan_offload_iter_complete_notif(struct iwl_mvm *mvm,
 						struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_scan_complete_notif *notif = (void *)pkt->data;
+	struct iwl_lmac_scan_complete_notif *notif = (void *)pkt->data;
 
 	IWL_DEBUG_SCAN(mvm,
 		       "Scan offload iteration complete: status=0x%x scanned channels=%d\n",
-- 
2.1.0

