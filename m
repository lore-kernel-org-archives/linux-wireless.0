Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58063 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab3GZITd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:19:33 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/7] iwlwifi: mvm: use only a single GTK in D3
Date: Fri, 26 Jul 2013 10:19:23 +0200
Message-Id: <1374826768-2440-2-git-send-email-johannes@sipsolutions.net> (sfid-20130726_101941_018952_6D5B1842)
In-Reply-To: <1374826768-2440-1-git-send-email-johannes@sipsolutions.net>
References: <1374826675.8248.11.camel@jlt4.sipsolutions.net>
 <1374826768-2440-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Unfortunately, the firmware only supports replay counters for
a single GTK in D3, so that we should only upload the last
key and use its replay counters. Since mac80211 key iteration
will walk through the keys in order of their addition, simply
use the same HW key index (1) for all GTKs, thus overwriting
previous ones with newer ones. The replay counters for it are
already used.

Reviewed-by: Yaron Vaknin <Yaron.Vaknin@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 7e5e5c2..83da884 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -134,7 +134,7 @@ struct wowlan_key_data {
 	struct iwl_wowlan_rsc_tsc_params_cmd *rsc_tsc;
 	struct iwl_wowlan_tkip_params_cmd *tkip;
 	bool error, use_rsc_tsc, use_tkip;
-	int gtk_key_idx;
+	int wep_key_idx;
 };
 
 static void iwl_mvm_wowlan_program_keys(struct ieee80211_hw *hw,
@@ -188,8 +188,8 @@ static void iwl_mvm_wowlan_program_keys(struct ieee80211_hw *hw,
 			wkc.wep_key.key_offset = 0;
 		} else {
 			/* others start at 1 */
-			data->gtk_key_idx++;
-			wkc.wep_key.key_offset = data->gtk_key_idx;
+			data->wep_key_idx++;
+			wkc.wep_key.key_offset = data->wep_key_idx;
 		}
 
 		ret = iwl_mvm_send_cmd_pdu(mvm, WEP_KEY, CMD_SYNC,
@@ -316,8 +316,13 @@ static void iwl_mvm_wowlan_program_keys(struct ieee80211_hw *hw,
 		mvm->ptk_ivlen = key->iv_len;
 		mvm->ptk_icvlen = key->icv_len;
 	} else {
-		data->gtk_key_idx++;
-		key->hw_key_idx = data->gtk_key_idx;
+		/*
+		 * firmware only supports TSC/RSC for a single key,
+		 * so if there are multiple keep overwriting them
+		 * with new ones -- this relies on mac80211 doing
+		 * list_add_tail().
+		 */
+		key->hw_key_idx = 1;
 		mvm->gtk_ivlen = key->iv_len;
 		mvm->gtk_icvlen = key->icv_len;
 	}
-- 
1.8.0

