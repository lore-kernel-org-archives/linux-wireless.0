Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059AbbEZTSb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:18:31 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Avraham Stern <avraham.stern@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 18/39] iwlwifi: mvm: print scanned channel list on scan iteration complete notification
Date: Tue, 26 May 2015 22:17:31 +0300
Message-Id: <1432667872-18092-18-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150526_213349_427107_4C6B2EA4)
In-Reply-To: <1432667798.26624.3.camel@intel.com>
References: <1432667798.26624.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

When receiving scan iteration complete notification, print a list of
the channels that have been scanned in this iteration.
This is useful for debugging.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 7777d56..e859584 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -312,16 +312,35 @@ int iwl_mvm_max_scan_ie_len(struct iwl_mvm *mvm)
 	return max_ie_len;
 }
 
+static u8 *iwl_mvm_dump_channel_list(struct iwl_scan_results_notif *res,
+				     int num_res, u8 *buf, size_t buf_size)
+{
+	int i;
+	u8 *pos = buf, *end = buf + buf_size;
+
+	for (i = 0; pos < end && i < num_res; i++)
+		pos += snprintf(pos, end - pos, " %u", res[i].channel);
+
+	/* terminate the string in case the buffer was too short */
+	*(buf + buf_size - 1) = '\0';
+
+	return buf;
+}
+
 int iwl_mvm_rx_scan_offload_iter_complete_notif(struct iwl_mvm *mvm,
 						struct iwl_rx_cmd_buffer *rxb,
 						struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_lmac_scan_complete_notif *notif = (void *)pkt->data;
+	u8 buf[256];
 
 	IWL_DEBUG_SCAN(mvm,
-		       "Scan offload iteration complete: status=0x%x scanned channels=%d\n",
-		       notif->status, notif->scanned_channels);
+		       "Scan offload iteration complete: status=0x%x scanned channels=%d channels list: %s\n",
+		       notif->status, notif->scanned_channels,
+		       iwl_mvm_dump_channel_list(notif->results,
+						 notif->scanned_channels, buf,
+						 sizeof(buf)));
 	return 0;
 }
 
-- 
2.1.4

