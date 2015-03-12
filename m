Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4406 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754580AbbCLNGQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:06:16 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 39/49] iwlwifi: mvm: rs: update Tx statistics when using fixed rate
Date: Thu, 12 Mar 2015 15:04:24 +0200
Message-Id: <1426165474-25586-39-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_143418_096518_95BC1F10)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

The Tx statistics weren't updated when using fixed rate for
debugging. Fix this as Tx statistics are useful in this use case.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 70 +++++++++++++++++++++++++++++++----
 1 file changed, 63 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 98edb18..dd457df 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -1065,6 +1065,37 @@ static inline bool rs_rate_column_match(struct rs_rate *a,
 		&& ant_match;
 }
 
+static inline enum rs_column rs_get_column_from_rate(struct rs_rate *rate)
+{
+	if (is_legacy(rate)) {
+		if (rate->ant == ANT_A)
+			return RS_COLUMN_LEGACY_ANT_A;
+
+		if (rate->ant == ANT_B)
+			return RS_COLUMN_LEGACY_ANT_B;
+
+		goto err;
+	}
+
+	if (is_siso(rate)) {
+		if (rate->ant == ANT_A || rate->stbc || rate->bfer)
+			return rate->sgi ? RS_COLUMN_SISO_ANT_A_SGI :
+				RS_COLUMN_SISO_ANT_A;
+
+		if (rate->ant == ANT_B)
+			return rate->sgi ? RS_COLUMN_SISO_ANT_B_SGI :
+				RS_COLUMN_SISO_ANT_B;
+
+		goto err;
+	}
+
+	if (is_mimo(rate))
+		return rate->sgi ? RS_COLUMN_MIMO2_SGI : RS_COLUMN_MIMO2;
+
+err:
+	return RS_COLUMN_INVALID;
+}
+
 static u8 rs_get_tid(struct ieee80211_hdr *hdr)
 {
 	u8 tid = IWL_MAX_TID_COUNT;
@@ -1106,17 +1137,43 @@ void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		return;
 	}
 
+	/* This packet was aggregated but doesn't carry status info */
+	if ((info->flags & IEEE80211_TX_CTL_AMPDU) &&
+	    !(info->flags & IEEE80211_TX_STAT_AMPDU))
+		return;
+
+	rs_rate_from_ucode_rate(tx_resp_hwrate, info->band, &tx_resp_rate);
+
 #ifdef CONFIG_MAC80211_DEBUGFS
-	/* Disable last tx check if we are debugging with fixed rate */
+	/* Disable last tx check if we are debugging with fixed rate but
+	 * update tx stats */
 	if (lq_sta->pers.dbg_fixed_rate) {
-		IWL_DEBUG_RATE(mvm, "Fixed rate. avoid rate scaling\n");
+		int index = tx_resp_rate.index;
+		enum rs_column column;
+		int attempts, success;
+
+		column = rs_get_column_from_rate(&tx_resp_rate);
+		if (WARN_ONCE(column == RS_COLUMN_INVALID,
+			      "Can't map rate 0x%x to column",
+			      tx_resp_hwrate))
+			return;
+
+		if (info->flags & IEEE80211_TX_STAT_AMPDU) {
+			attempts = info->status.ampdu_len;
+			success = info->status.ampdu_ack_len;
+		} else {
+			attempts = info->status.rates[0].count;
+			success = !!(info->flags & IEEE80211_TX_STAT_ACK);
+		}
+
+		lq_sta->pers.tx_stats[column][index].total += attempts;
+		lq_sta->pers.tx_stats[column][index].success += success;
+
+		IWL_DEBUG_RATE(mvm, "Fixed rate 0x%x success %d attempts %d\n",
+			       tx_resp_hwrate, success, attempts);
 		return;
 	}
 #endif
-	/* This packet was aggregated but doesn't carry status info */
-	if ((info->flags & IEEE80211_TX_CTL_AMPDU) &&
-	    !(info->flags & IEEE80211_TX_STAT_AMPDU))
-		return;
 
 	if (time_after(jiffies,
 		       (unsigned long)(lq_sta->last_tx +
@@ -1142,7 +1199,6 @@ void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	table = &lq_sta->lq;
 	lq_hwrate = le32_to_cpu(table->rs_table[0]);
 	rs_rate_from_ucode_rate(lq_hwrate, info->band, &lq_rate);
-	rs_rate_from_ucode_rate(tx_resp_hwrate, info->band, &tx_resp_rate);
 
 	/* Here we actually compare this rate to the latest LQ command */
 	if (!rs_rate_equal(&tx_resp_rate, &lq_rate, allow_ant_mismatch)) {
-- 
1.9.1

