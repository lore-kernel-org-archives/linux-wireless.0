Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:38980 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbbAGOVt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 09:21:49 -0500
Received: by mail-we0-f171.google.com with SMTP id u56so1241165wes.30
        for <linux-wireless@vger.kernel.org>; Wed, 07 Jan 2015 06:21:48 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2] mac80211: add TDLS supported channels correctly
Date: Wed,  7 Jan 2015 16:21:45 +0200
Message-Id: <1420640505-16838-1-git-send-email-arik@wizery.com> (sfid-20150107_152152_381899_29FE9C4E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function adding the supported channels IE during a TDLS connection had
several issues:
1. If the entire subband is usable, the function exitted the loop without
   adding it
2. The function only checked chandef_usable, ignoring flags like RADAR
   which would prevent TDLS off-channel communcation.
3. HT20 was explicitly required in the chandef, while not a requirement
   for TDLS off-channel.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/tdls.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 55ddd77..c5c4342 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -68,17 +68,24 @@ ieee80211_tdls_add_subband(struct ieee80211_sub_if_data *sdata,
 		ch = ieee80211_get_channel(sdata->local->hw.wiphy, i);
 		if (ch) {
 			/* we will be active on the channel */
-			u32 flags = IEEE80211_CHAN_DISABLED |
-				    IEEE80211_CHAN_NO_IR;
 			cfg80211_chandef_create(&chandef, ch,
-						NL80211_CHAN_HT20);
-			if (cfg80211_chandef_usable(sdata->local->hw.wiphy,
-						    &chandef, flags)) {
+						NL80211_CHAN_NO_HT);
+			if (cfg80211_reg_can_beacon(sdata->local->hw.wiphy,
+						    &chandef,
+						    sdata->wdev.iftype)) {
 				ch_cnt++;
+				/*
+				 * check if the next channel is also part of
+				 * this allowed range */
+				 *
 				continue;
 			}
 		}
 
+		/*
+		 * we've reached the end of a range, with allowed channels
+		 * found
+		 */
 		if (ch_cnt) {
 			u8 *pos = skb_put(skb, 2);
 			*pos++ = ieee80211_frequency_to_channel(subband_start);
@@ -89,6 +96,15 @@ ieee80211_tdls_add_subband(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
+	/* all channels in the requested range are allowed - add them here */
+	if (ch_cnt) {
+		u8 *pos = skb_put(skb, 2);
+		*pos++ = ieee80211_frequency_to_channel(subband_start);
+		*pos++ = ch_cnt;
+
+		subband_cnt++;
+	}
+
 	return subband_cnt;
 }
 
-- 
2.1.0

