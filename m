Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:49584 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169Ab3CDW3N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 17:29:13 -0500
Received: by mail-we0-f174.google.com with SMTP id r6so5139105wey.5
        for <linux-wireless@vger.kernel.org>; Mon, 04 Mar 2013 14:29:12 -0800 (PST)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: [PATCH v3 1/2] mac80211: get the rates masks from the txrc in rate_control_get_rate
Date: Mon,  4 Mar 2013 23:28:32 +0100
Message-Id: <1362436113-24775-1-git-send-email-karl.beldan@gmail.com> (sfid-20130304_232917_224016_5E2DA689)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

Currently we get it from the sdata. This uses the ad-hoc masks of the
ieee80211_tx_rate_control txrc and lets the mcs mask get overwritten to
spare an IEEE80211_HT_MCS_MASK_LEN bytes memcpy since it is not used
afterwards.

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 net/mac80211/rate.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index dd88381..cedc2ef 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -436,7 +436,7 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(txrc->skb);
 	int i;
 	u32 mask;
-	u8 mcs_mask[IEEE80211_HT_MCS_MASK_LEN];
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
+	mask = txrc->rate_idx_mask;
+	mcs_mask = txrc->rate_idx_mcs_mask;
 	if (mask != (1 << txrc->sband->n_bitrates) - 1) {
 		if (sta) {
 			/* Filter out rates that the STA does not support */
 			mask &= sta->sta.supp_rates[info->band];
-			for (i = 0; i < sizeof(mcs_mask); i++)
+			for (i = 0; i < sizeof(txrc->rate_idx_mcs_mask); i++)
 				mcs_mask[i] &= sta->sta.ht_cap.mcs.rx_mask[i];
 		}
 		/*
-- 
1.7.9.dirty

