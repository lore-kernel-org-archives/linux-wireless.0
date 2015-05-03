Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:9552 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895AbbECTdE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:33:04 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 31/42] iwlwifi: mvm: trim sched scan delay down to 16-bit for LMAC as well
Date: Sun,  3 May 2015 22:31:42 +0300
Message-Id: <1430681513-7838-31-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213318_722587_E6486B5B)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

In theory, LMAC scans can handle a 32-bit delay, but since waiting for
over 18 hours to start the scan is a bit silly and to keep it aligned
with UMAC scans (which only support 16-bit delays), trim it down to
16-bits.

This makes the LMAC vs. UMAC and the UMAC reg scan vs. UMAC sched scan
code more similar.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index f4d38f5..1abbc66 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -80,7 +80,7 @@ struct iwl_mvm_scan_params {
 	u32 suspend_time;
 	bool passive_fragmented;
 	u32 n_channels;
-	u32 delay;
+	u16 delay;
 	int n_ssids;
 	struct cfg80211_ssid *ssids;
 	struct ieee80211_channel **channels;
@@ -1279,14 +1279,7 @@ static int iwl_mvm_sched_scan_umac(struct iwl_mvm *mvm,
 	/* With UMAC we use only one schedule, so take the final one only */
 	sec_part->schedule[0].iter_count = params->schedule[1].iterations;
 
-	if (params->delay > U16_MAX) {
-		IWL_DEBUG_SCAN(mvm,
-			       "delay value is > 16-bits, set to max possible\n");
-		sec_part->delay = cpu_to_le16(U16_MAX);
-	} else {
-		sec_part->delay = cpu_to_le16(params->delay);
-	}
-
+	sec_part->delay = cpu_to_le16(params->delay);
 	sec_part->preq = params->preq;
 
 	return 0;
@@ -1458,7 +1451,6 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 	params.n_ssids = req->n_ssids;
 	params.flags = req->flags;
 	params.n_channels = req->n_channels;
-	params.delay = req->delay;
 	params.ssids = req->ssids;
 	params.channels = req->channels;
 	params.mac_addr = req->mac_addr;
@@ -1481,6 +1473,19 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 		params.interval = req->interval / MSEC_PER_SEC;
 	}
 
+	/* In theory, LMAC scans can handle a 32-bit delay, but since
+	 * waiting for over 18 hours to start the scan is a bit silly
+	 * and to keep it aligned with UMAC scans (which only support
+	 * 16-bit delays), trim it down to 16-bits.
+	 */
+	if (req->delay > U16_MAX) {
+		IWL_DEBUG_SCAN(mvm,
+			       "delay value is > 16-bits, set to max possible\n");
+		params.delay = U16_MAX;
+	} else {
+		params.delay = req->delay;
+	}
+
 	iwl_mvm_scan_calc_dwell(mvm, vif, &params);
 
 	ret = iwl_mvm_config_sched_scan_profiles(mvm, req);
-- 
2.1.0

