Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50473 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758854Ab3BTKgc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 05:36:32 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/3] nl80211: conditionally add back radar information
Date: Wed, 20 Feb 2013 11:36:25 +0100
Message-Id: <1361356586-11496-3-git-send-email-johannes@sipsolutions.net> (sfid-20130220_113638_374506_8D0F2DC9)
In-Reply-To: <1361356586-11496-1-git-send-email-johannes@sipsolutions.net>
References: <1361356586-11496-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If userspace is updated to deal with large split wiphy
information dumps, add back the radar information that
could otherwise push the data over the limit of the
netlink dump messages.

Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 38 +++++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 081df7b..fa35b07 100644
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
@@ -845,7 +859,8 @@ nla_put_failure:
 }
 
 static int nl80211_put_iface_combinations(struct wiphy *wiphy,
-					  struct sk_buff *msg)
+					  struct sk_buff *msg,
+					  bool large)
 {
 	struct nlattr *nl_combis;
 	int i, j;
@@ -894,6 +909,10 @@ static int nl80211_put_iface_combinations(struct wiphy *wiphy,
 		    nla_put_u32(msg, NL80211_IFACE_COMB_MAXNUM,
 				c->max_interfaces))
 			goto nla_put_failure;
+		if (large &&
+		    nla_put_u32(msg, NL80211_IFACE_COMB_RADAR_DETECT_WIDTHS,
+				c->radar_detect_widths))
+			goto nla_put_failure;
 
 		nla_nest_end(msg, nl_combi);
 	}
@@ -1243,7 +1262,8 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 
 					chan = &sband->channels[i];
 
-					if (nl80211_msg_put_channel(msg, chan))
+					if (nl80211_msg_put_channel(msg, chan,
+								    split))
 						goto nla_put_failure;
 
 					nla_nest_end(msg, nl_freq);
@@ -1397,7 +1417,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 					dev->wiphy.software_iftypes))
 			goto nla_put_failure;
 
-		if (nl80211_put_iface_combinations(&dev->wiphy, msg))
+		if (nl80211_put_iface_combinations(&dev->wiphy, msg, split))
 			goto nla_put_failure;
 
 		(*split_start)++;
@@ -9376,7 +9396,7 @@ void nl80211_send_beacon_hint_event(struct wiphy *wiphy,
 	nl_freq = nla_nest_start(msg, NL80211_ATTR_FREQ_BEFORE);
 	if (!nl_freq)
 		goto nla_put_failure;
-	if (nl80211_msg_put_channel(msg, channel_before))
+	if (nl80211_msg_put_channel(msg, channel_before, false))
 		goto nla_put_failure;
 	nla_nest_end(msg, nl_freq);
 
@@ -9384,7 +9404,7 @@ void nl80211_send_beacon_hint_event(struct wiphy *wiphy,
 	nl_freq = nla_nest_start(msg, NL80211_ATTR_FREQ_AFTER);
 	if (!nl_freq)
 		goto nla_put_failure;
-	if (nl80211_msg_put_channel(msg, channel_after))
+	if (nl80211_msg_put_channel(msg, channel_after, false))
 		goto nla_put_failure;
 	nla_nest_end(msg, nl_freq);
 
-- 
1.8.0

