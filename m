Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44019 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab2EKRYA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 13:24:00 -0400
Message-ID: <1336757037.12801.17.camel@jlt3.sipsolutions.net> (sfid-20120511_192404_923539_AE43EE56)
Subject: [PATCH] rndis_wlan: remove set_channel cfg80211 hook
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Date: Fri, 11 May 2012 19:23:57 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since rndis_wlan only supports managed and IBSS
modes, it doesn't need a set_channel call. The
callback might be called, but it won't matter
as nothing can use the channel.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/rndis_wlan.c |   14 --------------
 1 file changed, 14 deletions(-)

--- a/drivers/net/wireless/rndis_wlan.c	2012-05-11 18:02:41.000000000 +0200
+++ b/drivers/net/wireless/rndis_wlan.c	2012-05-11 18:04:04.000000000 +0200
@@ -554,9 +554,6 @@ static int rndis_join_ibss(struct wiphy
 
 static int rndis_leave_ibss(struct wiphy *wiphy, struct net_device *dev);
 
-static int rndis_set_channel(struct wiphy *wiphy, struct net_device *dev,
-	struct ieee80211_channel *chan, enum nl80211_channel_type channel_type);
-
 static int rndis_add_key(struct wiphy *wiphy, struct net_device *netdev,
 			 u8 key_index, bool pairwise, const u8 *mac_addr,
 			 struct key_params *params);
@@ -598,7 +595,6 @@ static const struct cfg80211_ops rndis_c
 	.disconnect = rndis_disconnect,
 	.join_ibss = rndis_join_ibss,
 	.leave_ibss = rndis_leave_ibss,
-	.set_channel = rndis_set_channel,
 	.add_key = rndis_add_key,
 	.del_key = rndis_del_key,
 	.set_default_key = rndis_set_default_key,
@@ -2423,16 +2419,6 @@ static int rndis_leave_ibss(struct wiphy
 	return deauthenticate(usbdev);
 }
 
-static int rndis_set_channel(struct wiphy *wiphy, struct net_device *netdev,
-	struct ieee80211_channel *chan, enum nl80211_channel_type channel_type)
-{
-	struct rndis_wlan_private *priv = wiphy_priv(wiphy);
-	struct usbnet *usbdev = priv->usbdev;
-
-	return set_channel(usbdev,
-			ieee80211_frequency_to_channel(chan->center_freq));
-}
-
 static int rndis_add_key(struct wiphy *wiphy, struct net_device *netdev,
 			 u8 key_index, bool pairwise, const u8 *mac_addr,
 			 struct key_params *params)


