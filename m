Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:44367 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757248Ab3CDSaE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 13:30:04 -0500
Received: by mail-we0-f175.google.com with SMTP id x8so4836247wey.6
        for <linux-wireless@vger.kernel.org>; Mon, 04 Mar 2013 10:30:03 -0800 (PST)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@gmail.com>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: [PATCH v2 1/2] mac80211: get the rates masks from the txrc in rate_control_get_rate
Date: Mon,  4 Mar 2013 19:27:14 +0100
Message-Id: <1362421635-28008-1-git-send-email-karl.beldan@gmail.com> (sfid-20130304_193009_661779_FE4E74D1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

Currently it gets it from the sdata. This uses and updates the ad-hoc
masks of the ieee80211_tx_rate_control instead of copying them.

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 net/mac80211/rate.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index dd88381..c1e5f25 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -435,8 +435,8 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_sta *ista = NULL;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(txrc->skb);
 	int i;
-	u32 mask;
-	u8 mcs_mask[IEEE80211_HT_MCS_MASK_LEN];
+	u32 *mask;
+	u8 *mcs_mask;
 
 	if (sta && test_sta_flag(sta, WLAN_STA_RATE_CONTROL)) {
 		ista = &sta->sta;
@@ -459,14 +459,13 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 	 * default mask (allow all rates) is used to save some processing for
 	 * the common case.
 	 */
-	mask = sdata->rc_rateidx_mask[info->band];
-	memcpy(mcs_mask, sdata->rc_rateidx_mcs_mask[info->band],
-	       sizeof(mcs_mask));
-	if (mask != (1 << txrc->sband->n_bitrates) - 1) {
+	mask = &txrc->rate_idx_mask;
+	mcs_mask = txrc->rate_idx_mcs_mask;
+	if (*mask != (1 << txrc->sband->n_bitrates) - 1) {
 		if (sta) {
 			/* Filter out rates that the STA does not support */
-			mask &= sta->sta.supp_rates[info->band];
-			for (i = 0; i < sizeof(mcs_mask); i++)
+			*mask &= sta->sta.supp_rates[info->band];
+			for (i = 0; i < sizeof(txrc->rate_idx_mcs_mask); i++)
 				mcs_mask[i] &= sta->sta.ht_cap.mcs.rx_mask[i];
 		}
 		/*
@@ -479,7 +478,7 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 			if (info->control.rates[i].idx < 0)
 				break;
 			rate_idx_match_mask(&info->control.rates[i], txrc,
-					    mask, mcs_mask);
+					    *mask, mcs_mask);
 		}
 	}
 
-- 
1.7.10.GIT

