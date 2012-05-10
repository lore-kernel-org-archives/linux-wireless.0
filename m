Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46413 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760688Ab2EJT1R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 15:27:17 -0400
Message-ID: <1336678038.4334.33.camel@jlt3.sipsolutions.net> (sfid-20120510_212720_029796_2C27710C)
Subject: [PATCH] nl80211: refactor valid channel type check
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 10 May 2012 21:27:18 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There are four instances in nl80211 of getting the
channel type from the attribute and validating it,
refactor those.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
For some reason that makes the .text size larger? But
it doesn't matter, we can't keep adding duplicates...

 net/wireless/nl80211.c |   59 ++++++++++++++++++++++++-------------------------
 1 file changed, 29 insertions(+), 30 deletions(-)

--- a/net/wireless/nl80211.c	2012-05-10 21:03:13.000000000 +0200
+++ b/net/wireless/nl80211.c	2012-05-10 21:05:26.000000000 +0200
@@ -1141,6 +1141,27 @@ static bool nl80211_can_set_dev_channel(
 		wdev->iftype == NL80211_IFTYPE_P2P_GO;
 }
 
+static bool nl80211_valid_channel_type(struct genl_info *info,
+				       enum nl80211_channel_type *channel_type)
+{
+	enum nl80211_channel_type tmp;
+
+	if (!info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE])
+		return false;
+
+	tmp = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]);
+	if (tmp != NL80211_CHAN_NO_HT &&
+	    tmp != NL80211_CHAN_HT20 &&
+	    tmp != NL80211_CHAN_HT40PLUS &&
+	    tmp != NL80211_CHAN_HT40MINUS)
+		return false;
+
+	if (channel_type)
+		*channel_type = tmp;
+
+	return true;
+}
+
 static int __nl80211_set_channel(struct cfg80211_registered_device *rdev,
 				 struct wireless_dev *wdev,
 				 struct genl_info *info)
@@ -1155,15 +1176,9 @@ static int __nl80211_set_channel(struct
 	if (!nl80211_can_set_dev_channel(wdev))
 		return -EOPNOTSUPP;
 
-	if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]) {
-		channel_type = nla_get_u32(info->attrs[
-				   NL80211_ATTR_WIPHY_CHANNEL_TYPE]);
-		if (channel_type != NL80211_CHAN_NO_HT &&
-		    channel_type != NL80211_CHAN_HT20 &&
-		    channel_type != NL80211_CHAN_HT40PLUS &&
-		    channel_type != NL80211_CHAN_HT40MINUS)
-			return -EINVAL;
-	}
+	if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE] &&
+	    !nl80211_valid_channel_type(info, &channel_type))
+		return -EINVAL;
 
 	freq = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]);
 
@@ -4841,12 +4856,7 @@ static int nl80211_join_ibss(struct sk_b
 	if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]) {
 		enum nl80211_channel_type channel_type;
 
-		channel_type = nla_get_u32(
-				info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]);
-		if (channel_type != NL80211_CHAN_NO_HT &&
-		    channel_type != NL80211_CHAN_HT20 &&
-		    channel_type != NL80211_CHAN_HT40MINUS &&
-		    channel_type != NL80211_CHAN_HT40PLUS)
+		if (!nl80211_valid_channel_type(info, &channel_type))
 			return -EINVAL;
 
 		if (channel_type != NL80211_CHAN_NO_HT &&
@@ -5413,15 +5423,9 @@ static int nl80211_remain_on_channel(str
 	    !(rdev->wiphy.flags & WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL))
 		return -EOPNOTSUPP;
 
-	if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]) {
-		channel_type = nla_get_u32(
-			info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]);
-		if (channel_type != NL80211_CHAN_NO_HT &&
-		    channel_type != NL80211_CHAN_HT20 &&
-		    channel_type != NL80211_CHAN_HT40PLUS &&
-		    channel_type != NL80211_CHAN_HT40MINUS)
-			return -EINVAL;
-	}
+	if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE] &&
+	    !nl80211_valid_channel_type(info, &channel_type))
+		return -EINVAL;
 
 	freq = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]);
 	chan = rdev_freq_to_chan(rdev, freq, channel_type);
@@ -5691,12 +5695,7 @@ static int nl80211_tx_mgmt(struct sk_buf
 	}
 
 	if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]) {
-		channel_type = nla_get_u32(
-			info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]);
-		if (channel_type != NL80211_CHAN_NO_HT &&
-		    channel_type != NL80211_CHAN_HT20 &&
-		    channel_type != NL80211_CHAN_HT40PLUS &&
-		    channel_type != NL80211_CHAN_HT40MINUS)
+		if (!nl80211_valid_channel_type(info, &channel_type))
 			return -EINVAL;
 		channel_type_valid = true;
 	}


