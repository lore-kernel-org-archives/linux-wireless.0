Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:48767 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbaATOOH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 09:14:07 -0500
Received: by mail-ee0-f42.google.com with SMTP id e49so3501495eek.29
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jan 2014 06:14:06 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/3] nl80211: make chandef parser take nlattr arg
Date: Mon, 20 Jan 2014 15:09:26 +0100
Message-Id: <1390226968-18928-2-git-send-email-michal.kazior@tieto.com> (sfid-20140120_151414_427989_0C0A62F4)
In-Reply-To: <1390226968-18928-1-git-send-email-michal.kazior@tieto.com>
References: <1390226968-18928-1-git-send-email-michal.kazior@tieto.com>
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
index 6e78c62..8742ed9 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1840,15 +1840,15 @@ static bool nl80211_can_set_dev_channel(struct wireless_dev *wdev)
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
@@ -1859,11 +1859,10 @@ static int nl80211_parse_chandef(struct cfg80211_registered_device *rdev,
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
@@ -1876,17 +1875,15 @@ static int nl80211_parse_chandef(struct cfg80211_registered_device *rdev,
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
@@ -1918,7 +1915,7 @@ static int __nl80211_set_channel(struct cfg80211_registered_device *rdev,
 	if (!nl80211_can_set_dev_channel(wdev))
 		return -EOPNOTSUPP;
 
-	result = nl80211_parse_chandef(rdev, info, &chandef);
+	result = nl80211_parse_chandef(rdev, info->attrs, &chandef);
 	if (result)
 		return result;
 
@@ -3270,7 +3267,7 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	if (info->attrs[NL80211_ATTR_WIPHY_FREQ]) {
-		err = nl80211_parse_chandef(rdev, info, &params.chandef);
+		err = nl80211_parse_chandef(rdev, info->attrs, &params.chandef);
 		if (err)
 			return err;
 	} else if (wdev->preset_chandef.chan) {
@@ -5736,7 +5733,7 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	if (dfs_region == NL80211_DFS_UNSET)
 		return -EINVAL;
 
-	err = nl80211_parse_chandef(rdev, info, &chandef);
+	err = nl80211_parse_chandef(rdev, info->attrs, &chandef);
 	if (err)
 		return err;
 
@@ -5863,7 +5860,7 @@ static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
 	}
 
 skip_beacons:
-	err = nl80211_parse_chandef(rdev, info, &params.chandef);
+	err = nl80211_parse_chandef(rdev, info->attrs, &params.chandef);
 	if (err)
 		return err;
 
@@ -6634,7 +6631,7 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 		ibss.ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
 	}
 
-	err = nl80211_parse_chandef(rdev, info, &ibss.chandef);
+	err = nl80211_parse_chandef(rdev, info->attrs, &ibss.chandef);
 	if (err)
 		return err;
 
@@ -7304,7 +7301,7 @@ static int nl80211_remain_on_channel(struct sk_buff *skb,
 	    duration > rdev->wiphy.max_remain_on_channel_duration)
 		return -EINVAL;
 
-	err = nl80211_parse_chandef(rdev, info, &chandef);
+	err = nl80211_parse_chandef(rdev, info->attrs, &chandef);
 	if (err)
 		return err;
 
@@ -7686,7 +7683,7 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 	 */
 	chandef.chan = NULL;
 	if (info->attrs[NL80211_ATTR_WIPHY_FREQ]) {
-		err = nl80211_parse_chandef(rdev, info, &chandef);
+		err = nl80211_parse_chandef(rdev, info->attrs, &chandef);
 		if (err)
 			return err;
 	}
@@ -7985,7 +7982,7 @@ static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
 		cfg.auto_open_plinks = false;
 
 	if (info->attrs[NL80211_ATTR_WIPHY_FREQ]) {
-		err = nl80211_parse_chandef(rdev, info, &setup.chandef);
+		err = nl80211_parse_chandef(rdev, info->attrs, &setup.chandef);
 		if (err)
 			return err;
 	} else {
-- 
1.8.4.rc3

