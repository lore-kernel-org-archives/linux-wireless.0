Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44023 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab2EKRYf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 13:24:35 -0400
Message-ID: <1336757074.12801.18.camel@jlt3.sipsolutions.net> (sfid-20120511_192437_913347_937E840E)
Subject: [PATCH] mwifiex: remove set_channel cfg80211 hook
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Bing Zhao <bzhao@marvell.com>
Date: Fri, 11 May 2012 19:24:34 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since mwifiex only supports managed and IBSS
modes, it doesn't need a set_channel call. The
callback might be called, but it won't matter
as nothing can use the channel.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |   27 ---------------------------
 1 file changed, 27 deletions(-)

--- a/drivers/net/wireless/mwifiex/cfg80211.c	2012-05-11 18:02:41.000000000 +0200
+++ b/drivers/net/wireless/mwifiex/cfg80211.c	2012-05-11 18:36:38.000000000 +0200
@@ -365,32 +365,6 @@ mwifiex_set_rf_channel(struct mwifiex_pr
 }
 
 /*
- * CFG802.11 operation handler to set channel.
- *
- * This function can only be used when station is not connected.
- */
-static int
-mwifiex_cfg80211_set_channel(struct wiphy *wiphy, struct net_device *dev,
-			     struct ieee80211_channel *chan,
-			     enum nl80211_channel_type channel_type)
-{
-	struct mwifiex_private *priv;
-
-	if (dev)
-		priv = mwifiex_netdev_get_priv(dev);
-	else
-		priv = mwifiex_cfg80211_get_priv(wiphy);
-
-	if (priv->media_connected) {
-		wiphy_err(wiphy, "This setting is valid only when station "
-				"is not connected\n");
-		return -EINVAL;
-	}
-
-	return mwifiex_set_rf_channel(priv, chan, channel_type);
-}
-
-/*
  * This function sets the fragmentation threshold.
  *
  * The fragmentation threshold value must lie between MWIFIEX_FRAG_MIN_VALUE
@@ -1417,7 +1391,6 @@ static struct cfg80211_ops mwifiex_cfg80
 	.get_station = mwifiex_cfg80211_get_station,
 	.dump_station = mwifiex_cfg80211_dump_station,
 	.set_wiphy_params = mwifiex_cfg80211_set_wiphy_params,
-	.set_channel = mwifiex_cfg80211_set_channel,
 	.join_ibss = mwifiex_cfg80211_join_ibss,
 	.leave_ibss = mwifiex_cfg80211_leave_ibss,
 	.add_key = mwifiex_cfg80211_add_key,


