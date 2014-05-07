Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:55089 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbaEGUBe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 16:01:34 -0400
Received: by mail-wg0-f42.google.com with SMTP id y10so1490227wgg.1
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 13:01:33 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/5] iwlwifi: mvm: several fixes in scan
Date: Wed,  7 May 2014 23:01:20 +0300
Message-Id: <1399492884-13508-1-git-send-email-egrumbach@gmail.com> (sfid-20140507_220137_917910_2B064860)
In-Reply-To: <536A90BD.8010204@gmail.com>
References: <536A90BD.8010204@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

The firmware doesn't handle properly the fragmented scan.
Stop using it.
While at it change max_out_time and suspend_time units from
usec to TUs as expected by firmware API.

Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h |  8 ++--
 drivers/net/wireless/iwlwifi/mvm/scan.c        | 53 ++++++--------------------
 2 files changed, 16 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
index 9426905..d73a89e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
@@ -183,9 +183,9 @@ enum iwl_scan_type {
  *	this number of packets were received (typically 1)
  * @passive2active: is auto switching from passive to active during scan allowed
  * @rxchain_sel_flags: RXON_RX_CHAIN_*
- * @max_out_time: in usecs, max out of serving channel time
+ * @max_out_time: in TUs, max out of serving channel time
  * @suspend_time: how long to pause scan when returning to service channel:
- *	bits 0-19: beacon interal in usecs (suspend before executing)
+ *	bits 0-19: beacon interal in TUs (suspend before executing)
  *	bits 20-23: reserved
  *	bits 24-31: number of beacons (suspend between channels)
  * @rxon_flags: RXON_FLG_*
@@ -383,8 +383,8 @@ enum scan_framework_client {
  * @quiet_plcp_th:	quiet channel num of packets threshold
  * @good_CRC_th:	passive to active promotion threshold
  * @rx_chain:		RXON rx chain.
- * @max_out_time:	max uSec to be out of assoceated channel
- * @suspend_time:	pause scan this long when returning to service channel
+ * @max_out_time:	max TUs to be out of assoceated channel
+ * @suspend_time:	pause scan this TUs when returning to service channel
  * @flags:		RXON flags
  * @filter_flags:	RXONfilter
  * @tx_cmd:		tx command for active scan; for 2GHz and for 5GHz.
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index c91dc84..cba88a3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -277,51 +277,22 @@ static void iwl_mvm_scan_calc_params(struct iwl_mvm *mvm,
 					    IEEE80211_IFACE_ITER_NORMAL,
 					    iwl_mvm_scan_condition_iterator,
 					    &global_bound);
-	/*
-	 * Under low latency traffic passive scan is fragmented meaning
-	 * that dwell on a particular channel will be fragmented. Each fragment
-	 * dwell time is 20ms and fragments period is 105ms. Skipping to next
-	 * channel will be delayed by the same period - 105ms. So suspend_time
-	 * parameter describing both fragments and channels skipping periods is
-	 * set to 105ms. This value is chosen so that overall passive scan
-	 * duration will not be too long. Max_out_time in this case is set to
-	 * 70ms, so for active scanning operating channel will be left for 70ms
-	 * while for passive still for 20ms (fragment dwell).
-	 */
-	if (global_bound) {
-		if (!iwl_mvm_low_latency(mvm)) {
-			params->suspend_time = ieee80211_tu_to_usec(100);
-			params->max_out_time = ieee80211_tu_to_usec(600);
-		} else {
-			params->suspend_time = ieee80211_tu_to_usec(105);
-			/* P2P doesn't support fragmented passive scan, so
-			 * configure max_out_time to be at least longest dwell
-			 * time for passive scan.
-			 */
-			if (vif->type == NL80211_IFTYPE_STATION && !vif->p2p) {
-				params->max_out_time = ieee80211_tu_to_usec(70);
-				params->passive_fragmented = true;
-			} else {
-				u32 passive_dwell;
 
-				/*
-				 * Use band G so that passive channel dwell time
-				 * will be assigned with maximum value.
-				 */
-				band = IEEE80211_BAND_2GHZ;
-				passive_dwell = iwl_mvm_get_passive_dwell(band);
-				params->max_out_time =
-					ieee80211_tu_to_usec(passive_dwell);
-			}
-		}
+	if (!global_bound)
+		goto not_bound;
+
+	params->suspend_time = 100;
+	params->max_out_time = 600;
+
+	if (iwl_mvm_low_latency(mvm)) {
+		params->suspend_time = 250;
+		params->max_out_time = 250;
 	}
 
+not_bound:
+
 	for (band = IEEE80211_BAND_2GHZ; band < IEEE80211_NUM_BANDS; band++) {
-		if (params->passive_fragmented)
-			params->dwell[band].passive = 20;
-		else
-			params->dwell[band].passive =
-				iwl_mvm_get_passive_dwell(band);
+		params->dwell[band].passive = iwl_mvm_get_passive_dwell(band);
 		params->dwell[band].active = iwl_mvm_get_active_dwell(band,
 								      n_ssids);
 	}
-- 
1.8.3.2

