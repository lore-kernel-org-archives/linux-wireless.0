Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:54039 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaIOFNN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:13:13 -0400
Received: by mail-we0-f172.google.com with SMTP id k48so3351063wev.31
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 22:13:12 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/28] iwlwifi: mvm: rs: remove max_rate_idx
Date: Mon, 15 Sep 2014 08:12:37 +0300
Message-Id: <1410757980-2138-5-git-send-email-egrumbach@gmail.com> (sfid-20140915_071319_773869_389059D5)
In-Reply-To: <5416742C.3070804@gmail.com>
References: <5416742C.3070804@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

max_rate_idx constraint is deprecated and it's handling is
faulty as well as it is relevant only for legacy rates but
was considered in HT/VHT. In most cases there was no side effect
as max_rate_idx was set to -1 but in certain cases like P2P
it got set to an actual rate idx which would limit the maximum
rate in HT/VHT by mistake.
max_rate_idx should be replaced by the masks fields but for
now remove it.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 31 +++----------------------------
 drivers/net/wireless/iwlwifi/mvm/rs.h |  1 -
 2 files changed, 3 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 6a13120..94c5299 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -2036,18 +2036,7 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 		return;
 	}
 
-	/* force user max rate if set by user */
-	if ((lq_sta->max_rate_idx != -1) &&
-	    (lq_sta->max_rate_idx < index)) {
-		index = lq_sta->max_rate_idx;
-		update_lq = 1;
-		window = &(tbl->win[index]);
-		IWL_DEBUG_RATE(mvm,
-			       "Forcing user max rate %d\n",
-			       index);
-		goto lq_update;
-	}
-
+	/* TODO: handle rate_idx_mask and rate_idx_mcs_mask */
 	window = &(tbl->win[index]);
 
 	/*
@@ -2135,10 +2124,7 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 	low = high_low & 0xff;
 	high = (high_low >> 8) & 0xff;
 
-	/* If user set max rate, dont allow higher than user constrain */
-	if ((lq_sta->max_rate_idx != -1) &&
-	    (lq_sta->max_rate_idx < high))
-		high = IWL_RATE_INVALID;
+	/* TODO: handle rate_idx_mask and rate_idx_mcs_mask */
 
 	sr = window->success_ratio;
 
@@ -2370,23 +2356,13 @@ static void rs_get_rate(void *mvm_r, struct ieee80211_sta *sta, void *mvm_sta,
 			struct ieee80211_tx_rate_control *txrc)
 {
 	struct sk_buff *skb = txrc->skb;
-	struct ieee80211_supported_band *sband = txrc->sband;
 	struct iwl_op_mode *op_mode __maybe_unused =
 			(struct iwl_op_mode *)mvm_r;
 	struct iwl_mvm *mvm __maybe_unused = IWL_OP_MODE_GET_MVM(op_mode);
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct iwl_lq_sta *lq_sta = mvm_sta;
 
-	/* Get max rate if user set max rate */
-	if (lq_sta) {
-		lq_sta->max_rate_idx = txrc->max_rate_idx;
-		if ((sband->band == IEEE80211_BAND_5GHZ) &&
-		    (lq_sta->max_rate_idx != -1))
-			lq_sta->max_rate_idx += IWL_FIRST_OFDM_RATE;
-		if ((lq_sta->max_rate_idx < 0) ||
-		    (lq_sta->max_rate_idx >= IWL_RATE_COUNT))
-			lq_sta->max_rate_idx = -1;
-	}
+	/* TODO: handle rate_idx_mask and rate_idx_mcs_mask */
 
 	/* Treat uninitialized rate scaling data same as non-existing. */
 	if (lq_sta && !lq_sta->pers.drv) {
@@ -2587,7 +2563,6 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	 * previous packets? Need to have IEEE 802.1X auth succeed immediately
 	 * after assoc.. */
 
-	lq_sta->max_rate_idx = -1;
 	lq_sta->missed_rate_counter = IWL_MISSED_RATE_MAX;
 	lq_sta->band = sband->band;
 	/*
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.h b/drivers/net/wireless/iwlwifi/mvm/rs.h
index 824a750..98bb9b7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.h
@@ -345,7 +345,6 @@ struct iwl_lq_sta {
 	u8 max_siso_rate_idx;
 	u8 max_mimo2_rate_idx;
 
-	s8 max_rate_idx;     /* Max rate set by user */
 	u8 missed_rate_counter;
 
 	struct iwl_lq_cmd lq;
-- 
1.9.1

