Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42449 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756679Ab3C1JtL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Mar 2013 05:49:11 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 1/9] mac80211: use second center_freq segment only in 80+80
Date: Thu, 28 Mar 2013 10:48:57 +0100
Message-Id: <1364464145-14446-2-git-send-email-johannes@sipsolutions.net> (sfid-20130328_104917_497713_3BE89D78)
In-Reply-To: <1364464145-14446-1-git-send-email-johannes@sipsolutions.net>
References: <1364464145-14446-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The field is otherwise reserved, so we shouldn't read
and reject it, though any sane system will probably
have to set it to 0 anyway.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index a19c550..ce5adcf 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -303,12 +303,6 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 					       channel->band);
 	vht_chandef.center_freq2 = 0;
 
-	if (vht_oper->center_freq_seg2_idx)
-		vht_chandef.center_freq2 =
-			ieee80211_channel_to_frequency(
-				vht_oper->center_freq_seg2_idx,
-				channel->band);
-
 	switch (vht_oper->chan_width) {
 	case IEEE80211_VHT_CHANWIDTH_USE_HT:
 		vht_chandef.width = chandef->width;
@@ -321,6 +315,10 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 		break;
 	case IEEE80211_VHT_CHANWIDTH_80P80MHZ:
 		vht_chandef.width = NL80211_CHAN_WIDTH_80P80;
+		vht_chandef.center_freq2 =
+			ieee80211_channel_to_frequency(
+				vht_oper->center_freq_seg2_idx,
+				channel->band);
 		break;
 	default:
 		if (verbose)
-- 
1.8.0

