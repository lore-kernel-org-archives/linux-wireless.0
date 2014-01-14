Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:45776 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751812AbaANWBq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 17:01:46 -0500
Date: Wed, 15 Jan 2014 00:01:44 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] cfg80211: Clean up connect params and channel fetching
Message-ID: <20140114220144.GA19710@w1.fi> (sfid-20140114_230149_814265_7E277A74)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Addition of the frequency hints showed up couple of places in cfg80211
where pointers could be marked const and a shared function could be used
to fetch a valid channel.

Signed-off-by: Jouni Malinen <j@w1.fi>
---
 include/net/cfg80211.h |    6 +++---
 net/wireless/nl80211.c |   42 +++++++++++++++++++++++++-----------------
 2 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 27dd032..9237b26 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1732,9 +1732,9 @@ struct cfg80211_ibss_params {
 struct cfg80211_connect_params {
 	struct ieee80211_channel *channel;
 	struct ieee80211_channel *channel_hint;
-	u8 *bssid;
-	u8 *bssid_hint;
-	u8 *ssid;
+	const u8 *bssid;
+	const u8 *bssid_hint;
+	const u8 *ssid;
 	size_t ssid_len;
 	enum nl80211_auth_type auth_type;
 	u8 *ie;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 901cd37..1cb7736 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -859,6 +859,19 @@ static int nl80211_key_allowed(struct wireless_dev *wdev)
 	return 0;
 }
 
+static struct ieee80211_channel *nl80211_get_valid_chan(struct wiphy *wiphy,
+							struct nlattr *tb)
+{
+	struct ieee80211_channel *chan;
+
+	if (tb == NULL)
+		return NULL;
+	chan = ieee80211_get_channel(wiphy, nla_get_u32(tb));
+	if (!chan || chan->flags & IEEE80211_CHAN_DISABLED)
+		return NULL;
+	return chan;
+}
+
 static int nl80211_put_iftypes(struct sk_buff *msg, u32 attr, u16 ifmodes)
 {
 	struct nlattr *nl_modes = nla_nest_start(msg, attr);
@@ -6227,9 +6240,9 @@ static int nl80211_authenticate(struct sk_buff *skb, struct genl_info *info)
 		return -EOPNOTSUPP;
 
 	bssid = nla_data(info->attrs[NL80211_ATTR_MAC]);
-	chan = ieee80211_get_channel(&rdev->wiphy,
-		nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]));
-	if (!chan || (chan->flags & IEEE80211_CHAN_DISABLED))
+	chan = nl80211_get_valid_chan(&rdev->wiphy,
+				      info->attrs[NL80211_ATTR_WIPHY_FREQ]);
+	if (!chan)
 		return -EINVAL;
 
 	ssid = nla_data(info->attrs[NL80211_ATTR_SSID]);
@@ -6382,9 +6395,9 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 
 	bssid = nla_data(info->attrs[NL80211_ATTR_MAC]);
 
-	chan = ieee80211_get_channel(&rdev->wiphy,
-		nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]));
-	if (!chan || (chan->flags & IEEE80211_CHAN_DISABLED))
+	chan = nl80211_get_valid_chan(&rdev->wiphy,
+				      info->attrs[NL80211_ATTR_WIPHY_FREQ]);
+	if (!chan)
 		return -EINVAL;
 
 	ssid = nla_data(info->attrs[NL80211_ATTR_SSID]);
@@ -7041,19 +7054,14 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	if (info->attrs[NL80211_ATTR_WIPHY_FREQ]) {
-		connect.channel =
-			ieee80211_get_channel(wiphy,
-			    nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]));
-		if (!connect.channel ||
-		    connect.channel->flags & IEEE80211_CHAN_DISABLED)
+		connect.channel = nl80211_get_valid_chan(
+			wiphy, info->attrs[NL80211_ATTR_WIPHY_FREQ]);
+		if (!connect.channel)
 			return -EINVAL;
 	} else if (info->attrs[NL80211_ATTR_WIPHY_FREQ_HINT]) {
-		connect.channel_hint =
-			ieee80211_get_channel(wiphy,
-			    nla_get_u32(
-				    info->attrs[NL80211_ATTR_WIPHY_FREQ_HINT]));
-		if (!connect.channel_hint ||
-		    connect.channel_hint->flags & IEEE80211_CHAN_DISABLED)
+		connect.channel_hint = nl80211_get_valid_chan(
+			wiphy, info->attrs[NL80211_ATTR_WIPHY_FREQ_HINT]);
+		if (!connect.channel_hint)
 			return -EINVAL;
 	}
 
-- 
1.7.9.5


-- 
Jouni Malinen                                            PGP id EFC895FA
