Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:61725 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689AbaDMNC7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 09:02:59 -0400
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>, <stable@vger.kernel.org>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/13] iwlwifi: mvm: rs: reinit rs if no tx for a long time
Date: Sun, 13 Apr 2014 16:01:59 +0300
Message-Id: <1397394123-25102-9-git-send-email-egrumbach@gmail.com> (sfid-20140413_150309_747960_E775AA97)
In-Reply-To: <1397394123-25102-1-git-send-email-egrumbach@gmail.com>
References: <534A8A49.2030100@gmail.com>
 <1397394123-25102-1-git-send-email-egrumbach@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

After being idle for a long time (>5sec) the rs statistics
will be stale so we prefer to reset rs and start from legacy
rates again. This gives better results when the attenuation
increased signficantly (e.g. we got further from the AP) and
after a while we start Tx
Note that the first Tx after the idle period will still go out
in the old modulation and rate but this seemed a simpler approach
compared to adding a timer or modifying mac80211 for this.
The negative impact is negligble as we'll recover quickly.

Cc: <stable@vger.kernel.org> [3.14]
Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 22 +++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/mvm/rs.h |  1 +
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 97b8fac..0d03dcd 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -59,7 +59,7 @@
 /* max allowed rate miss before sync LQ cmd */
 #define IWL_MISSED_RATE_MAX		15
 #define RS_STAY_IN_COLUMN_TIMEOUT       (5*HZ)
-
+#define RS_IDLE_TIMEOUT                 (5*HZ)
 
 static u8 rs_ht_to_legacy[] = {
 	[IWL_RATE_MCS_0_INDEX] = IWL_RATE_6M_INDEX,
@@ -992,6 +992,13 @@ static void rs_tx_status(void *mvm_r, struct ieee80211_supported_band *sband,
 		return;
 	}
 
+#ifdef CPTCFG_MAC80211_DEBUGFS
+	/* Disable last tx check if we are debugging with fixed rate */
+	if (lq_sta->dbg_fixed_rate) {
+		IWL_DEBUG_RATE(mvm, "Fixed rate. avoid rate scaling\n");
+		return;
+	}
+#endif
 	if (!ieee80211_is_data(hdr->frame_control) ||
 	    info->flags & IEEE80211_TX_CTL_NO_ACK)
 		return;
@@ -1034,6 +1041,18 @@ static void rs_tx_status(void *mvm_r, struct ieee80211_supported_band *sband,
 			mac_index++;
 	}
 
+	if (time_after(jiffies,
+		       (unsigned long)(lq_sta->last_tx + RS_IDLE_TIMEOUT))) {
+		int tid;
+		IWL_DEBUG_RATE(mvm, "Tx idle for too long. reinit rs\n");
+		for (tid = 0; tid < IWL_MAX_TID_COUNT; tid++)
+			ieee80211_stop_tx_ba_session(sta, tid);
+
+		iwl_mvm_rs_rate_init(mvm, sta, sband->band, false);
+		return;
+	}
+	lq_sta->last_tx = jiffies;
+
 	/* Here we actually compare this rate to the latest LQ command */
 	if ((mac_index < 0) ||
 	    (rate.sgi != !!(mac_flags & IEEE80211_TX_RC_SHORT_GI)) ||
@@ -2354,6 +2373,7 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		rs_rate_scale_clear_tbl_windows(&lq_sta->lq_info[j]);
 
 	lq_sta->flush_timer = 0;
+	lq_sta->last_tx = jiffies;
 
 	IWL_DEBUG_RATE(mvm,
 		       "LQ: *** rate scale station global init for station %d ***\n",
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.h b/drivers/net/wireless/iwlwifi/mvm/rs.h
index fbb476a..0acfac9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.h
@@ -311,6 +311,7 @@ struct iwl_lq_sta {
 	u32 visited_columns;    /* Bitmask marking which Tx columns were
 				 * explored during a search cycle
 				 */
+	u64 last_tx;
 	bool is_vht;
 	enum ieee80211_band band;
 
-- 
1.8.3.2

