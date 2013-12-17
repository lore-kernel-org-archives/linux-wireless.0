Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:64905 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab3LQUpY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:45:24 -0500
Received: by mail-ee0-f52.google.com with SMTP id d17so3142137eek.39
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 12:45:23 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 27/36] iwlwifi: mvm: rs: avoid recalc of supported legacy rate mask
Date: Tue, 17 Dec 2013 22:44:30 +0200
Message-Id: <1387313079-28123-27-git-send-email-egrumbach@gmail.com> (sfid-20131217_214553_442902_9119D24E)
In-Reply-To: <52B0B72A.5070704@gmail.com>
References: <52B0B72A.5070704@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

The supported legacy rate mask is initialized when rs
is initialized based on the remote peer supported rates.
There's no need to re mask it repeatedly with the supported
remote peer rates.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c |   36 ++-------------------------------
 drivers/net/wireless/iwlwifi/mvm/rs.h |    1 -
 2 files changed, 2 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index eee3381..30470d4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -880,16 +880,6 @@ static void rs_get_lower_rate(struct iwl_lq_sta *lq_sta,
 
 	rate_mask = rs_get_supported_rates(lq_sta, rate);
 
-	/* Mask with station rate restriction */
-	if (is_legacy(rate)) {
-		/* supp_rates has no CCK bits in A mode */
-		if (lq_sta->band == IEEE80211_BAND_5GHZ)
-			rate_mask = (u16)(rate_mask &
-			   (lq_sta->supp_rates << IWL_FIRST_OFDM_RATE));
-		else
-			rate_mask = (u16)(rate_mask & lq_sta->supp_rates);
-	}
-
 	/* If we switched from HT to legacy, check current rate */
 	if (switch_to_legacy && (rate_mask & (1 << scale_index))) {
 		low = scale_index;
@@ -1629,7 +1619,6 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 	u16 rate_mask;
 	u8 update_lq = 0;
 	struct iwl_scale_tbl_info *tbl, *tbl1;
-	u16 rate_scale_index_msk = 0;
 	u8 active_tbl = 0;
 	u8 done_search = 0;
 	u16 high_low;
@@ -1646,8 +1635,6 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 	    info->flags & IEEE80211_TX_CTL_NO_ACK)
 		return;
 
-	lq_sta->supp_rates = sta->supp_rates[lq_sta->band];
-
 	tid = rs_get_tid(lq_sta, hdr);
 	if ((tid != IWL_MAX_TID_COUNT) &&
 	    (lq_sta->tx_agg_tid_en & (1 << tid))) {
@@ -1686,24 +1673,7 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 	/* rates available for this association, and for modulation mode */
 	rate_mask = rs_get_supported_rates(lq_sta, rate);
 
-	/* mask with station rate restriction */
-	if (is_legacy(rate)) {
-		if (lq_sta->band == IEEE80211_BAND_5GHZ)
-			/* supp_rates has no CCK bits in A mode */
-			rate_scale_index_msk = (u16) (rate_mask &
-				(lq_sta->supp_rates << IWL_FIRST_OFDM_RATE));
-		else
-			rate_scale_index_msk = (u16) (rate_mask &
-						      lq_sta->supp_rates);
-
-	} else {
-		rate_scale_index_msk = rate_mask;
-	}
-
-	if (!rate_scale_index_msk)
-		rate_scale_index_msk = rate_mask;
-
-	if (!((BIT(index) & rate_scale_index_msk))) {
+	if (!(BIT(index) & rate_mask)) {
 		IWL_ERR(mvm, "Current Rate is not valid\n");
 		if (lq_sta->search_better_tbl) {
 			/* revert to active table if search table is not valid*/
@@ -1816,8 +1786,7 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 
 	/* (Else) not in search of better modulation mode, try for better
 	 * starting rate, while staying in this mode. */
-	high_low = rs_get_adjacent_rate(mvm, index, rate_scale_index_msk,
-					rate->type);
+	high_low = rs_get_adjacent_rate(mvm, index, rate_mask, rate->type);
 	low = high_low & 0xff;
 	high = (high_low >> 8) & 0xff;
 
@@ -2253,7 +2222,6 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 			rs_rate_scale_clear_window(&lq_sta->lq_info[j].win[i]);
 
 	lq_sta->flush_timer = 0;
-	lq_sta->supp_rates = sta->supp_rates[sband->band];
 
 	IWL_DEBUG_RATE(mvm,
 		       "LQ: *** rate scale station global init for station %d ***\n",
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.h b/drivers/net/wireless/iwlwifi/mvm/rs.h
index 7b26e65..c31aa59 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.h
@@ -314,7 +314,6 @@ struct iwl_lq_sta {
 	enum ieee80211_band band;
 
 	/* The following are bitmaps of rates; IWL_RATE_6M_MASK, etc. */
-	u32 supp_rates;
 	u16 active_legacy_rate;
 	u16 active_siso_rate;
 	u16 active_mimo2_rate;
-- 
1.7.9.5

