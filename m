Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50102 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758703Ab3BTIkk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 03:40:40 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.9 1/2] nl80211: remove radar information
Date: Wed, 20 Feb 2013 09:40:33 +0100
Message-Id: <1361349634-9669-2-git-send-email-johannes@sipsolutions.net> (sfid-20130220_094045_024267_39DE37B4)
In-Reply-To: <1361349634-9669-1-git-send-email-johannes@sipsolutions.net>
References: <1361349634-9669-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The wiphy information is getting very close to being too
much for a typical netlink dump message and adding the
radar attributes to channels and interface combinations
can push it over the limit, which means userspace gets no
information whatsoever. Therefore, remove these again for
now, no driver actually supports radar detection anyway
and a modified userspace is required as well.

We're working on a solution that will allow userspace to
request splitting the information across multiple netlink
messages, which will allow us to add this back.

Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 1bfa144..f4785a0 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -554,16 +554,9 @@ static int nl80211_msg_put_channel(struct sk_buff *msg,
 	if ((chan->flags & IEEE80211_CHAN_NO_IBSS) &&
 	    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_IBSS))
 		goto nla_put_failure;
-	if (chan->flags & IEEE80211_CHAN_RADAR) {
-		u32 time = elapsed_jiffies_msecs(chan->dfs_state_entered);
-		if (nla_put_flag(msg, NL80211_FREQUENCY_ATTR_RADAR))
-			goto nla_put_failure;
-		if (nla_put_u32(msg, NL80211_FREQUENCY_ATTR_DFS_STATE,
-				chan->dfs_state))
-			goto nla_put_failure;
-		if (nla_put_u32(msg, NL80211_FREQUENCY_ATTR_DFS_TIME, time))
-			goto nla_put_failure;
-	}
+	if ((chan->flags & IEEE80211_CHAN_RADAR) &&
+	    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_RADAR))
+		goto nla_put_failure;
 	if ((chan->flags & IEEE80211_CHAN_NO_HT40MINUS) &&
 	    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_HT40_MINUS))
 		goto nla_put_failure;
@@ -900,9 +893,6 @@ static int nl80211_put_iface_combinations(struct wiphy *wiphy,
 		    nla_put_u32(msg, NL80211_IFACE_COMB_MAXNUM,
 				c->max_interfaces))
 			goto nla_put_failure;
-		if (nla_put_u32(msg, NL80211_IFACE_COMB_RADAR_DETECT_WIDTHS,
-				c->radar_detect_widths))
-			goto nla_put_failure;
 
 		nla_nest_end(msg, nl_combi);
 	}
-- 
1.8.0

