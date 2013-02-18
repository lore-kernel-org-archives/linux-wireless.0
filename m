Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44486 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757544Ab3BRW4b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 17:56:31 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: simon.wunderlich@s2003.tu-chemnitz.de,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nl80211: conditionally add back per-channel radar information
Date: Mon, 18 Feb 2013 23:56:26 +0100
Message-Id: <1361228186-11861-1-git-send-email-johannes@sipsolutions.net> (sfid-20130218_235633_078140_52376F38)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If userspace is updated to deal with large split wiphy
information dumps, add back the radar information to
each channel that previously pushed the data over the
limit of a single netlink message.

Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index fff4160..945ca2b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -540,7 +540,8 @@ static inline void *nl80211hdr_put(struct sk_buff *skb, u32 portid, u32 seq,
 }
 
 static int nl80211_msg_put_channel(struct sk_buff *msg,
-				   struct ieee80211_channel *chan)
+				   struct ieee80211_channel *chan,
+				   bool large)
 {
 	if (nla_put_u32(msg, NL80211_FREQUENCY_ATTR_FREQ,
 			chan->center_freq))
@@ -555,9 +556,22 @@ static int nl80211_msg_put_channel(struct sk_buff *msg,
 	if ((chan->flags & IEEE80211_CHAN_NO_IBSS) &&
 	    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_IBSS))
 		goto nla_put_failure;
-	if ((chan->flags & IEEE80211_CHAN_RADAR) &&
-	    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_RADAR))
-		goto nla_put_failure;
+	if (chan->flags & IEEE80211_CHAN_RADAR) {
+		if (nla_put_flag(msg, NL80211_FREQUENCY_ATTR_RADAR))
+			goto nla_put_failure;
+		if (large) {
+			u32 time;
+
+			time = elapsed_jiffies_msecs(chan->dfs_state_entered);
+
+			if (nla_put_u32(msg, NL80211_FREQUENCY_ATTR_DFS_STATE,
+					chan->dfs_state))
+				goto nla_put_failure;
+			if (nla_put_u32(msg, NL80211_FREQUENCY_ATTR_DFS_TIME,
+					time))
+				goto nla_put_failure;
+		}
+	}
 	if ((chan->flags & IEEE80211_CHAN_NO_HT40MINUS) &&
 	    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_HT40_MINUS))
 		goto nla_put_failure;
@@ -1289,7 +1303,8 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 
 					chan = &sband->channels[i];
 
-					if (nl80211_msg_put_channel(msg, chan))
+					if (nl80211_msg_put_channel(msg, chan,
+								    split))
 						goto nla_put_failure;
 
 					nla_nest_end(msg, nl_freq);
@@ -9405,7 +9420,7 @@ void nl80211_send_beacon_hint_event(struct wiphy *wiphy,
 	nl_freq = nla_nest_start(msg, NL80211_ATTR_FREQ_BEFORE);
 	if (!nl_freq)
 		goto nla_put_failure;
-	if (nl80211_msg_put_channel(msg, channel_before))
+	if (nl80211_msg_put_channel(msg, channel_before, false))
 		goto nla_put_failure;
 	nla_nest_end(msg, nl_freq);
 
@@ -9413,7 +9428,7 @@ void nl80211_send_beacon_hint_event(struct wiphy *wiphy,
 	nl_freq = nla_nest_start(msg, NL80211_ATTR_FREQ_AFTER);
 	if (!nl_freq)
 		goto nla_put_failure;
-	if (nl80211_msg_put_channel(msg, channel_after))
+	if (nl80211_msg_put_channel(msg, channel_after, false))
 		goto nla_put_failure;
 	nla_nest_end(msg, nl_freq);
 
-- 
1.8.0

