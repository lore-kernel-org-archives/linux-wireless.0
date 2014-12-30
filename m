Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24108 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683AbaL3OTu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 09:19:50 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/33] iwlwifi: mvm: rs: fix max rate allowed if no rate is allowed
Date: Tue, 30 Dec 2014 16:18:45 +0200
Message-Id: <1419949148-24046-10-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141230_151954_797699_142EDA5C)
In-Reply-To: <1419948357.21410.4.camel@egrumbacBox>
References: <1419948357.21410.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

In case the rate mask for one of the modulations was zero the
max rate idx for that modulation was set to 32 (BITS_PER_LONG).
This is bad as it would later lead to an out of bounds access
to the expected tpt table. In most cases there was no real effect
as the expected tpt was set to 0 and this led to avoiding the
modulation effectively.
Fix the out of bounds access and explicitly skip the modulation
in case there's no rate allowed in it.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index b9682d7..999efc3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -1318,6 +1318,13 @@ static void rs_set_stay_in_table(struct iwl_mvm *mvm, u8 is_legacy,
 	lq_sta->visited_columns = 0;
 }
 
+static inline int rs_get_max_rate_from_mask(unsigned long rate_mask)
+{
+	if (rate_mask)
+		return find_last_bit(&rate_mask, BITS_PER_LONG);
+	return IWL_RATE_INVALID;
+}
+
 static int rs_get_max_allowed_rate(struct iwl_lq_sta *lq_sta,
 				   const struct rs_tx_column *column)
 {
@@ -1613,8 +1620,12 @@ static enum rs_column rs_get_next_column(struct iwl_mvm *mvm,
 			continue;
 
 		max_rate = rs_get_max_allowed_rate(lq_sta, next_col);
-		if (WARN_ON_ONCE(max_rate == IWL_RATE_INVALID))
+		if (max_rate == IWL_RATE_INVALID) {
+			IWL_DEBUG_RATE(mvm,
+				       "Skip column %d: no rate is allowed in this column\n",
+				       next_col_id);
 			continue;
+		}
 
 		max_expected_tpt = expected_tpt_tbl[max_rate];
 		if (tpt >= max_expected_tpt) {
@@ -2765,12 +2776,12 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	if (IWL_MVM_RS_DISABLE_MIMO)
 		lq_sta->active_mimo2_rate = 0;
 
-	lq_sta->max_legacy_rate_idx = find_last_bit(&lq_sta->active_legacy_rate,
-						    BITS_PER_LONG);
-	lq_sta->max_siso_rate_idx = find_last_bit(&lq_sta->active_siso_rate,
-						  BITS_PER_LONG);
-	lq_sta->max_mimo2_rate_idx = find_last_bit(&lq_sta->active_mimo2_rate,
-						   BITS_PER_LONG);
+	lq_sta->max_legacy_rate_idx =
+		rs_get_max_rate_from_mask(lq_sta->active_legacy_rate);
+	lq_sta->max_siso_rate_idx =
+		rs_get_max_rate_from_mask(lq_sta->active_siso_rate);
+	lq_sta->max_mimo2_rate_idx =
+		rs_get_max_rate_from_mask(lq_sta->active_mimo2_rate);
 
 	IWL_DEBUG_RATE(mvm,
 		       "RATE MASK: LEGACY=%lX SISO=%lX MIMO2=%lX VHT=%d LDPC=%d STBC%d\n",
-- 
1.9.1

