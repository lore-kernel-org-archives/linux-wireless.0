Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59928 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934852Ab3DJMns (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 08:43:48 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/8] mac80211: use second center_freq segment only in 80+80
Date: Wed, 10 Apr 2013 14:43:35 +0200
Message-Id: <1365597822-27660-2-git-send-email-johannes@sipsolutions.net> (sfid-20130410_144353_020576_C53B6AA5)
In-Reply-To: <1365597822-27660-1-git-send-email-johannes@sipsolutions.net>
References: <1365597822-27660-1-git-send-email-johannes@sipsolutions.net>
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
index a7cf4f7..9979742 100644
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

