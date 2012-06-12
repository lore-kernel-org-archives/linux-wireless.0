Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:55612 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750711Ab2FLLGj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 07:06:39 -0400
Received: by lahd3 with SMTP id d3so3407476lah.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jun 2012 04:06:38 -0700 (PDT)
From: Pontus Fuchs <pontus.fuchs@gmail.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Pontus Fuchs <pontus.fuchs@gmail.com>
Subject: [PATCH] mac80211: Disallow changing chan type on monitor when CHAN_MODE_FIXED
Date: Tue, 12 Jun 2012 13:06:07 +0200
Message-Id: <1339499167-26225-1-git-send-email-pontus.fuchs@gmail.com> (sfid-20120612_130643_380290_CB631933)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If you add a monitor interface in paralell to a normal interface
mac80211 will let you to change the channel type on the monitor
interface even if you are connected. Add an explicit check to
disallow this.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
---
 net/mac80211/cfg.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 498c94e..9f673bf 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -677,7 +677,8 @@ static int ieee80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 static int ieee80211_set_channel(struct wiphy *wiphy,
 				 struct net_device *netdev,
 				 struct ieee80211_channel *chan,
-				 enum nl80211_channel_type channel_type)
+				 enum nl80211_channel_type channel_type,
+				 bool is_monitor)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata = NULL;
@@ -689,7 +690,8 @@ static int ieee80211_set_channel(struct wiphy *wiphy,
 	case CHAN_MODE_HOPPING:
 		return -EBUSY;
 	case CHAN_MODE_FIXED:
-		if (local->oper_channel != chan)
+		if (local->oper_channel != chan ||
+		    (is_monitor && local->_oper_channel_type != channel_type))
 			return -EBUSY;
 		if (!sdata && local->_oper_channel_type == channel_type)
 			return 0;
@@ -713,7 +715,7 @@ static int ieee80211_set_monitor_channel(struct wiphy *wiphy,
 					 struct ieee80211_channel *chan,
 					 enum nl80211_channel_type channel_type)
 {
-	return ieee80211_set_channel(wiphy, NULL, chan, channel_type);
+	return ieee80211_set_channel(wiphy, NULL, chan, channel_type, true);
 }
 
 static int ieee80211_set_probe_resp(struct ieee80211_sub_if_data *sdata,
@@ -831,7 +833,7 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 		return -EALREADY;
 
 	err = ieee80211_set_channel(wiphy, dev, params->channel,
-				    params->channel_type);
+				    params->channel_type, false);
 	if (err)
 		return err;
 
@@ -1607,7 +1609,7 @@ static int ieee80211_join_mesh(struct wiphy *wiphy, struct net_device *dev,
 		return err;
 
 	err = ieee80211_set_channel(wiphy, dev, setup->channel,
-				    setup->channel_type);
+				    setup->channel_type, false);
 	if (err)
 		return err;
 
-- 
1.7.5.4

