Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44465 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757469Ab3BRWtz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 17:49:55 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: simon.wunderlich@s2003.tu-chemnitz.de,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.9] nl80211: remove radar channel information
Date: Mon, 18 Feb 2013 23:49:49 +0100
Message-Id: <1361227789-6892-1-git-send-email-johannes@sipsolutions.net> (sfid-20130218_234958_769230_A363FDE5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The wiphy information is getting very close to being too
much for a typical netlink dump message, and adding the
two radar attributes to a number of channels can push it
over the limit, which means userspace gets no information
at all. Therefore, revert it for now. We're working on a
solution that will allow userspace to request splitting
the information across multiple netlink messages, which
will allow us to add this back.

Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0666ac3..fff4160 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -555,16 +555,9 @@ static int nl80211_msg_put_channel(struct sk_buff *msg,
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
-- 
1.8.0

