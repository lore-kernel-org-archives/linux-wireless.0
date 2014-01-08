Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:45304 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713AbaAHPbQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jan 2014 10:31:16 -0500
Received: by mail-ea0-f182.google.com with SMTP id a15so907109eae.13
        for <linux-wireless@vger.kernel.org>; Wed, 08 Jan 2014 07:31:14 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 1/4] nl80211: make chandef parser take nlattr arg
Date: Wed,  8 Jan 2014 16:26:55 +0100
Message-Id: <1389194818-7864-2-git-send-email-michal.kazior@tieto.com> (sfid-20140108_163129_097264_04315563)
In-Reply-To: <1389194818-7864-1-git-send-email-michal.kazior@tieto.com>
References: <1389194818-7864-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The chandef parsing function doesn't need to
access genl_info. It just needs the attrs field.

This makes it easier for further reuse.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/wireless/nl80211.c | 41 +++++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 22 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a693f86..33962ef 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1775,15 +1775,15 @@ static bool nl80211_can_set_dev_channel(struct wireless_dev *wdev)
 }
 
 static int nl80211_parse_chandef(struct cfg80211_registered_device *rdev,
-				 struct genl_info *info,
+				 struct nlattr **attrs,
 				 struct cfg80211_chan_def *chandef)
 {
 	u32 control_freq;
 
-	if (!info->attrs[NL80211_ATTR_WIPHY_FREQ])
+	if (!attrs[NL80211_ATTR_WIPHY_FREQ])
 		return -EINVAL;
 
-	control_freq = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]);
+	control_freq = nla_get_u32(attrs[NL80211_ATTR_WIPHY_FREQ]);
 
 	chandef->chan = ieee80211_get_channel(&rdev->wiphy, control_freq);
 	chandef->width = NL80211_CHAN_WIDTH_20_NOHT;
@@ -1794,11 +1794,10 @@ static int nl80211_parse_chandef(struct cfg80211_registered_device *rdev,
 	if (!chandef->chan || chandef->chan->flags & IEEE80211_CHAN_DISABLED)
 		return -EINVAL;
 
-	if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]) {
+	if (attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]) {
 		enum nl80211_channel_type chantype;
 
-		chantype = nla_get_u32(
-				info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]);
+		chantype = nla_get_u32(attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]);
 
 		switch (chantype) {
 		case NL80211_CHAN_NO_HT:
@@ -1811,17 +1810,15 @@ static int nl80211_parse_chandef(struct cfg80211_registered_device *rdev,
 		default:
 			return -EINVAL;
 		}
-	} else if (info->attrs[NL80211_ATTR_CHANNEL_WIDTH]) {
+	} else if (attrs[NL80211_ATTR_CHANNEL_WIDTH]) {
 		chandef->width =
-			nla_get_u32(info->attrs[NL80211_ATTR_CHANNEL_WIDTH]);
-		if (info->attrs[NL80211_ATTR_CENTER_FREQ1])
+			nla_get_u32(attrs[NL80211_ATTR_CHANNEL_WIDTH]);
+		if (attrs[NL80211_ATTR_CENTER_FREQ1])
 			chandef->center_freq1 =
-				nla_get_u32(
-					info->attrs[NL80211_ATTR_CENTER_FREQ1]);
-		if (info->attrs[NL80211_ATTR_CENTER_FREQ2])
+				nla_get_u32(attrs[NL80211_ATTR_CENTER_FREQ1]);
+		if (attrs[NL80211_ATTR_CENTER_FREQ2])
 			chandef->center_freq2 =
-				nla_get_u32(
-					info->attrs[NL80211_ATTR_CENTER_FREQ2]);
+				nla_get_u32(attrs[NL80211_ATTR_CENTER_FREQ2]);
 	}
 
 	if (!cfg80211_chandef_valid(chandef))
@@ -1853,7 +1850,7 @@ static int __nl80211_set_channel(struct cfg80211_registered_device *rdev,
 	if (!nl80211_can_set_dev_channel(wdev))
 		return -EOPNOTSUPP;
 
-	result = nl80211_parse_chandef(rdev, info, &chandef);
+	result = nl80211_parse_chandef(rdev, info->attrs, &chandef);
 	if (result)
 		return result;
 
@@ -3205,7 +3202,7 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	if (info->attrs[NL80211_ATTR_WIPHY_FREQ]) {
-		err = nl80211_parse_chandef(rdev, info, &params.chandef);
+		err = nl80211_parse_chandef(rdev, info->attrs, &params.chandef);
 		if (err)
 			return err;
 	} else if (wdev->preset_chandef.chan) {
@@ -5669,7 +5666,7 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	struct cfg80211_chan_def chandef;
 	int err;
 
-	err = nl80211_parse_chandef(rdev, info, &chandef);
+	err = nl80211_parse_chandef(rdev, info->attrs, &chandef);
 	if (err)
 		return err;
 
@@ -5796,7 +5793,7 @@ static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
 	}
 
 skip_beacons:
-	err = nl80211_parse_chandef(rdev, info, &params.chandef);
+	err = nl80211_parse_chandef(rdev, info->attrs, &params.chandef);
 	if (err)
 		return err;
 
@@ -6567,7 +6564,7 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 		ibss.ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
 	}
 
-	err = nl80211_parse_chandef(rdev, info, &ibss.chandef);
+	err = nl80211_parse_chandef(rdev, info->attrs, &ibss.chandef);
 	if (err)
 		return err;
 
@@ -7223,7 +7220,7 @@ static int nl80211_remain_on_channel(struct sk_buff *skb,
 	    duration > rdev->wiphy.max_remain_on_channel_duration)
 		return -EINVAL;
 
-	err = nl80211_parse_chandef(rdev, info, &chandef);
+	err = nl80211_parse_chandef(rdev, info->attrs, &chandef);
 	if (err)
 		return err;
 
@@ -7517,7 +7514,7 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 	 */
 	chandef.chan = NULL;
 	if (info->attrs[NL80211_ATTR_WIPHY_FREQ]) {
-		err = nl80211_parse_chandef(rdev, info, &chandef);
+		err = nl80211_parse_chandef(rdev, info->attrs, &chandef);
 		if (err)
 			return err;
 	}
@@ -7816,7 +7813,7 @@ static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
 		cfg.auto_open_plinks = false;
 
 	if (info->attrs[NL80211_ATTR_WIPHY_FREQ]) {
-		err = nl80211_parse_chandef(rdev, info, &setup.chandef);
+		err = nl80211_parse_chandef(rdev, info->attrs, &setup.chandef);
 		if (err)
 			return err;
 	} else {
-- 
1.8.4.rc3

