Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43730 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083Ab2K1NKm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 08:10:42 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: simplify loop in minstrel_ht
Date: Wed, 28 Nov 2012 14:11:07 +0100
Message-Id: <1354108267-11261-1-git-send-email-johannes@sipsolutions.net> (sfid-20121128_141045_824725_FF122453)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rc80211_minstrel_ht.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index fb1d4aa6..9f9c453 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -389,9 +389,9 @@ minstrel_ht_tx_status(void *priv, struct ieee80211_supported_band *sband,
 	struct ieee80211_tx_rate *ar = info->status.rates;
 	struct minstrel_rate_stats *rate, *rate2;
 	struct minstrel_priv *mp = priv;
-	bool last = false;
+	bool last;
 	int group;
-	int i = 0;
+	int i;
 
 	if (!msp->is_ht)
 		return mac80211_minstrel.tx_status(priv, sband, sta, &msp->legacy, skb);
@@ -419,13 +419,11 @@ minstrel_ht_tx_status(void *priv, struct ieee80211_supported_band *sband,
 	if (info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE)
 		mi->sample_packets += info->status.ampdu_len;
 
+	last = !minstrel_ht_txstat_valid(&ar[0]);
 	for (i = 0; !last; i++) {
 		last = (i == IEEE80211_TX_MAX_RATES - 1) ||
 		       !minstrel_ht_txstat_valid(&ar[i + 1]);
 
-		if (!minstrel_ht_txstat_valid(&ar[i]))
-			break;
-
 		group = minstrel_ht_get_group_idx(&ar[i]);
 		rate = &mi->groups[group].rates[ar[i].idx % 8];
 
-- 
1.8.0

