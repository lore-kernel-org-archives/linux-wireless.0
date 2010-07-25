Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:55624 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750919Ab0GYRTi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jul 2010 13:19:38 -0400
From: Andy Lutomirski <luto@MIT.EDU>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>, ilw@linux.intel.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: Andy Lutomirski <luto@mit.edu>
Subject: [PATCH 2.6.35] iwlagn: Improve aggregation failure error messages
Date: Sun, 25 Jul 2010 13:14:29 -0400
Message-Id: <4f999350050decc0901e6f23ae3f06d35bc3fbc0.1280077759.git.luto@mit.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

82ca9341763107615a15da6e59b9535d49eb91c3 added scary looking
but harmless error messages.  Make them clearer and make the
actual failure message show up with the same severity as the
harmless one.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---

This is probably 2.6.35 material.  There is no functional regression
here, but 2.6.34 worked pretty well and 2.6.35 *looks* like it's not
working if you read the logs.

There is no functional change in this patch.

Thanks,
Andy

 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index cf4a95b..f38ee24 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -300,8 +300,9 @@ static int rs_tl_turn_on_agg_for_tid(struct iwl_priv *priv,
 				      struct ieee80211_sta *sta)
 {
 	int ret = -EAGAIN;
+	u32 load = rs_tl_get_load(lq_data, tid);
 
-	if (rs_tl_get_load(lq_data, tid) > IWL_AGG_LOAD_THRESHOLD) {
+	if (load > IWL_AGG_LOAD_THRESHOLD) {
 		IWL_DEBUG_HT(priv, "Starting Tx agg: STA: %pM tid: %d\n",
 				sta->addr, tid);
 		ret = ieee80211_start_tx_ba_session(sta, tid);
@@ -311,13 +312,15 @@ static int rs_tl_turn_on_agg_for_tid(struct iwl_priv *priv,
 			 * this might be cause by reloading firmware
 			 * stop the tx ba session here
 			 */
-			IWL_DEBUG_HT(priv, "Fail start Tx agg on tid: %d\n",
+			IWL_ERR(priv, "Fail start Tx agg on tid: %d\n",
 				tid);
 			ieee80211_stop_tx_ba_session(sta, tid,
 						WLAN_BACK_INITIATOR);
 		}
-	} else
-		IWL_ERR(priv, "Fail finding valid aggregation tid: %d\n", tid);
+	} else {
+		IWL_ERR(priv, "Aggregation not enabled for tid %d "
+			"because load = %u\n", tid, load);
+	}
 	return ret;
 }
 
-- 
1.7.1.1

