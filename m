Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:43506 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516AbaDMTUw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:20:52 -0400
Received: by mail-we0-f170.google.com with SMTP id w61so7356256wes.29
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:20:51 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 28/47] iwlwifi: mvm: Fix scan parameters units
Date: Sun, 13 Apr 2014 22:19:43 +0300
Message-Id: <1397416802-32403-28-git-send-email-egrumbach@gmail.com> (sfid-20140413_213515_272961_795FF559)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

Change max_out_time and suspend_time units from usec to TUs as expected
by FW API.

Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h |  8 ++++----
 drivers/net/wireless/iwlwifi/mvm/scan.c        | 11 +++++------
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
index 02856e0..0373f44 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
@@ -187,9 +187,9 @@ enum iwl_scan_type {
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
@@ -387,8 +387,8 @@ enum scan_framework_client {
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
index 5481e09..ea17745 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -295,12 +295,12 @@ static void iwl_mvm_scan_calc_params(struct iwl_mvm *mvm,
 	 */
 
 	if (iwl_mvm_low_latency(mvm)) {
-		params->suspend_time = ieee80211_tu_to_usec(105);
-		params->max_out_time = ieee80211_tu_to_usec(70);
+		params->suspend_time = 105;
+		params->max_out_time = 70;
 		frag_passive_dwell = 20;
 	} else {
-		params->suspend_time = ieee80211_tu_to_usec(100);
-		params->max_out_time = ieee80211_tu_to_usec(600);
+		params->suspend_time = 100;
+		params->max_out_time = 600;
 	}
 
 	if (frag_passive_dwell) {
@@ -313,8 +313,7 @@ static void iwl_mvm_scan_calc_params(struct iwl_mvm *mvm,
 		if (vif->type == NL80211_IFTYPE_P2P_DEVICE) {
 			u32 passive_dwell =
 				iwl_mvm_get_passive_dwell(IEEE80211_BAND_2GHZ);
-			params->max_out_time =
-					ieee80211_tu_to_usec(passive_dwell);
+			params->max_out_time = passive_dwell;
 		} else {
 			params->passive_fragmented = true;
 		}
-- 
1.8.3.2

