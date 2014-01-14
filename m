Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:45750 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751475AbaANSUI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 13:20:08 -0500
Date: Tue, 14 Jan 2014 20:20:05 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/3] cfg80211: Allow BSS hint to be provided for connect
Message-ID: <20140114182005.GA24850@w1.fi> (sfid-20140114_192011_837637_AC742425)
References: <20140106075102.GA31031@w1.fi>
 <1389110184.4645.23.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1389110184.4645.23.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 07, 2014 at 04:56:24PM +0100, Johannes Berg wrote:
> >  struct cfg80211_connect_params {
> >  	struct ieee80211_channel *channel;
> > +	struct ieee80211_channel *channel_hint;
> >  	u8 *bssid;
> > +	u8 *bssid_hint;
> >  	u8 *ssid;
> 
> Those should probably all be const, but we can do that separately.

These are easy (see below). The "u8 *ie" below would require more work
since brcm80211 uses it in a non-const-friendly-way (in its own IE
parse?!)..

> > +	} else if (info->attrs[NL80211_ATTR_WIPHY_FREQ_HINT]) {
> > +		connect.channel_hint =
> > +			ieee80211_get_channel(wiphy,
> > +					      nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ_HINT]));
> > +		if (!connect.channel_hint ||
> > +		    connect.channel_hint->flags & IEEE80211_CHAN_DISABLED)
> > +			return -EINVAL;
> 
> I'm starting to wonder if this pattern should be abstracted out, but
> again, we can do that separately.

Something like this could work.. Only compile tested, though.


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
index 55f8e83..1385276 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -859,6 +859,19 @@ static int nl80211_key_allowed(struct wireless_dev *wdev)
 	return 0;
 }
 
+static struct ieee80211_channel * nl80211_get_valid_chan(struct wiphy *wiphy,
+							 struct nlattr *tb)
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
@@ -7041,18 +7054,14 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
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
-					      nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ_HINT]));
-		if (!connect.channel_hint ||
-		    connect.channel_hint->flags & IEEE80211_CHAN_DISABLED)
+		connect.channel_hint = nl80211_get_valid_chan(
+			wiphy, info->attrs[NL80211_ATTR_WIPHY_FREQ_HINT]);
+		if (!connect.channel_hint)
 			return -EINVAL;
 	}
 

-- 
Jouni Malinen                                            PGP id EFC895FA
