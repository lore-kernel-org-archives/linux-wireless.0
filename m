Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58146 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab3GZI3z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:29:55 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>
Subject: [PATCH 12/30] iwlwifi: mvm: enable pre-scan passive to active
Date: Fri, 26 Jul 2013 10:28:29 +0200
Message-Id: <1374827327-3464-13-git-send-email-johannes@sipsolutions.net> (sfid-20130726_103017_793981_4EDCF5F8)
In-Reply-To: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
References: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Enable passive to active scan feature, on channels that was
active in the past hour.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h | 5 ++++-
 drivers/net/wireless/iwlwifi/mvm/scan.c        | 2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
index b60d141..c33ff8e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
@@ -138,6 +138,8 @@ struct iwl_ssid_ie {
  *@SCAN_FLAGS_DELAYED_SCAN_LOWBAND:
  *@SCAN_FLAGS_DELAYED_SCAN_HIGHBAND:
  *@SCAN_FLAGS_FRAGMENTED_SCAN:
+ *@SCAN_FLAGS_PASSIVE2ACTIVE: use active scan on channels that was active
+ *	in the past hour, even if they are marked as passive.
  */
 enum iwl_scan_flags {
 	SCAN_FLAGS_PERIODIC_SCAN		= BIT(0),
@@ -145,6 +147,7 @@ enum iwl_scan_flags {
 	SCAN_FLAGS_DELAYED_SCAN_LOWBAND		= BIT(2),
 	SCAN_FLAGS_DELAYED_SCAN_HIGHBAND	= BIT(3),
 	SCAN_FLAGS_FRAGMENTED_SCAN		= BIT(4),
+	SCAN_FLAGS_PASSIVE2ACTIVE		= BIT(5),
 };
 
 /**
@@ -179,7 +182,7 @@ enum iwl_scan_type {
  * @quiet_time: in msecs, dwell this time for active scan on quiet channels
  * @quiet_plcp_th: quiet PLCP threshold (channel is quiet if less than
  *	this number of packets were received (typically 1)
- * @passive2active: is auto switching from passive to active allowed (0 or 1)
+ * @passive2active: is auto switching from passive to active during scan allowed
  * @rxchain_sel_flags: RXON_RX_CHAIN_*
  * @max_out_time: in usecs, max out of serving channel time
  * @suspend_time: how long to pause scan when returning to service channel:
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 2157b0f..dc63579 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -306,10 +306,12 @@ int iwl_mvm_scan_request(struct iwl_mvm *mvm,
 	 */
 	if (req->n_ssids > 0) {
 		cmd->passive2active = cpu_to_le16(1);
+		cmd->scan_flags |= SCAN_FLAGS_PASSIVE2ACTIVE;
 		ssid = req->ssids[0].ssid;
 		ssid_len = req->ssids[0].ssid_len;
 	} else {
 		cmd->passive2active = 0;
+		cmd->scan_flags &= ~SCAN_FLAGS_PASSIVE2ACTIVE;
 	}
 
 	iwl_mvm_scan_fill_ssids(cmd, req);
-- 
1.8.0

