Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55891 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbYLHNBX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 08:01:23 -0500
Subject: [PATCH] cfg80211: fix nl80211 frequency handling
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 08 Dec 2008 12:39:04 +0100
Message-Id: <1228736344.22164.76.camel@johannes.berg> (sfid-20081208_140126_023286_1FCBCC4C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix two small bugs with HT frequency setting:
 * HT is accepted even when the driver is incapable
 * HT40 is accepted when the driver cannot do 40 MHz
 (both on the selected band)

Also simplify the code a little.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/nl80211.c |   40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

--- everything.orig/net/wireless/nl80211.c	2008-12-08 12:20:26.000000000 +0100
+++ everything/net/wireless/nl80211.c	2008-12-08 12:38:11.000000000 +0100
@@ -365,6 +365,7 @@ static int nl80211_set_wiphy(struct sk_b
 		enum nl80211_sec_chan_offset sec_chan_offset =
 			NL80211_SEC_CHAN_NO_HT;
 		struct ieee80211_channel *chan;
+		struct ieee80211_sta_ht_cap *ht_cap;
 		u32 freq, sec_freq;
 
 		if (!rdev->ops->set_channel) {
@@ -372,26 +373,25 @@ static int nl80211_set_wiphy(struct sk_b
 			goto bad_res;
 		}
 
+		result = -EINVAL;
+
 		if (info->attrs[NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET]) {
-			sec_chan_offset = nla_get_u32(
-				info->attrs[
+			sec_chan_offset = nla_get_u32(info->attrs[
 					NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET]);
 			if (sec_chan_offset != NL80211_SEC_CHAN_NO_HT &&
 			    sec_chan_offset != NL80211_SEC_CHAN_DISABLED &&
 			    sec_chan_offset != NL80211_SEC_CHAN_BELOW &&
-			    sec_chan_offset != NL80211_SEC_CHAN_ABOVE) {
-				result = -EINVAL;
+			    sec_chan_offset != NL80211_SEC_CHAN_ABOVE)
 				goto bad_res;
-			}
 		}
 
 		freq = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]);
 		chan = ieee80211_get_channel(&rdev->wiphy, freq);
-		if (!chan || chan->flags & IEEE80211_CHAN_DISABLED) {
-			/* Primary channel not allowed */
-			result = -EINVAL;
+
+		/* Primary channel not allowed */
+		if (!chan || chan->flags & IEEE80211_CHAN_DISABLED)
 			goto bad_res;
-		}
+
 		if (sec_chan_offset == NL80211_SEC_CHAN_BELOW)
 			sec_freq = freq - 20;
 		else if (sec_chan_offset == NL80211_SEC_CHAN_ABOVE)
@@ -399,14 +399,26 @@ static int nl80211_set_wiphy(struct sk_b
 		else
 			sec_freq = 0;
 
+		ht_cap = &rdev->wiphy.bands[chan->band]->ht_cap;
+
+		/* no HT capabilities */
+		if (sec_chan_offset != NL80211_SEC_CHAN_NO_HT &&
+		    !ht_cap->ht_supported)
+			goto bad_res;
+
 		if (sec_freq) {
 			struct ieee80211_channel *schan;
+
+			/* no 40 MHz capabilities */
+			if (!(ht_cap->cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) ||
+			    (ht_cap->cap & IEEE80211_HT_CAP_40MHZ_INTOLERANT))
+				goto bad_res;
+
 			schan = ieee80211_get_channel(&rdev->wiphy, sec_freq);
-			if (!schan || schan->flags & IEEE80211_CHAN_DISABLED) {
-				/* Secondary channel not allowed */
-				result = -EINVAL;
+
+			/* Secondary channel not allowed */
+			if (!schan || schan->flags & IEEE80211_CHAN_DISABLED)
 				goto bad_res;
-			}
 		}
 
 		result = rdev->ops->set_channel(&rdev->wiphy, chan,
@@ -416,7 +428,7 @@ static int nl80211_set_wiphy(struct sk_b
 	}
 
 
-bad_res:
+ bad_res:
 	cfg80211_put_dev(rdev);
 	return result;
 }


