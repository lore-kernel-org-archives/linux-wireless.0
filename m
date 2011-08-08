Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34933 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab1HHMDD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 08:03:03 -0400
Received: by fxh19 with SMTP id 19so5303498fxh.19
        for <linux-wireless@vger.kernel.org>; Mon, 08 Aug 2011 05:03:02 -0700 (PDT)
From: Alexander Simon <alexander.simon@saxnet.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/4] nl80211: Parse channel type attribute in an IBSS join request
Date: Mon, 08 Aug 2011 14:02:58 +0200
Message-ID: <1888623.Vt5VZUN2cU@alex-1> (sfid-20110808_140308_710112_10A3AC18)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check if the requested HT mode can be used.
Extend cfg80211 IBSS struct for HT mode.

Signed-off-by: Alexander Simon <alexander.simon@saxnet.de>
---

As there were no replies for my RFC post, i am resending this as PATCH.

 include/net/cfg80211.h |    1 +
 net/wireless/chan.c    |    2 +-
 net/wireless/core.h    |    3 +++
 net/wireless/nl80211.c |   34 +++++++++++++++++++++++++++++++---
 4 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d17f47f..738db17 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1040,6 +1040,7 @@ struct cfg80211_ibss_params {
 	u8 *ssid;
 	u8 *bssid;
 	struct ieee80211_channel *channel;
+	enum nl80211_channel_type channel_type;
 	u8 *ie;
 	u8 ssid_len, ie_len;
 	u16 beacon_interval;
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 17cd0c0..cd630e1 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -44,7 +44,7 @@ rdev_freq_to_chan(struct cfg80211_registered_device *rdev,
 	return chan;
 }
 
-static bool can_beacon_sec_chan(struct wiphy *wiphy,
+bool can_beacon_sec_chan(struct wiphy *wiphy,
 				struct ieee80211_channel *chan,
 				enum nl80211_channel_type channel_type)
 {
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 8672e02..a7d8e59 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -441,6 +441,9 @@ cfg80211_can_add_interface(struct cfg80211_registered_device *rdev,
 struct ieee80211_channel *
 rdev_freq_to_chan(struct cfg80211_registered_device *rdev,
 		  int freq, enum nl80211_channel_type channel_type);
+bool can_beacon_sec_chan(struct wiphy *wiphy,
+				struct ieee80211_channel *chan,
+				enum nl80211_channel_type channel_type);
 int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
 		      struct wireless_dev *wdev, int freq,
 		      enum nl80211_channel_type channel_type);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 28d2aa1..7f3f46c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4346,12 +4346,40 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 		ibss.ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
 	}
 
-	ibss.channel = ieee80211_get_channel(wiphy,
-		nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]));
+	if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]) {
+		enum nl80211_channel_type channel_type;
+
+		channel_type = nla_get_u32(
+			info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]);
+		if (channel_type != NL80211_CHAN_NO_HT &&
+		    channel_type != NL80211_CHAN_HT20 &&
+		    channel_type != NL80211_CHAN_HT40PLUS &&
+		    channel_type != NL80211_CHAN_HT40MINUS)
+			return -EINVAL;
+		ibss.channel_type = channel_type;
+	} else {
+		ibss.channel_type = NL80211_CHAN_NO_HT;
+	}
+
+	ibss.channel = rdev_freq_to_chan(rdev,
+		nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]),
+		ibss.channel_type);
 	if (!ibss.channel ||
+	    ibss.channel->flags & IEEE80211_CHAN_PASSIVE_SCAN ||
 	    ibss.channel->flags & IEEE80211_CHAN_NO_IBSS ||
-	    ibss.channel->flags & IEEE80211_CHAN_DISABLED)
+	    ibss.channel->flags & IEEE80211_CHAN_RADAR)
+		return -EINVAL;
+
+	/* Both channels should be able to initiate communication */
+	if ((ibss.channel_type == NL80211_CHAN_HT40PLUS ||
+	     ibss.channel_type == NL80211_CHAN_HT40MINUS) &&
+	    !can_beacon_sec_chan(&rdev->wiphy, ibss.channel,
+				 ibss.channel_type)) {
+		printk(KERN_DEBUG
+		       "cfg80211: Secondary channel not "
+		       "allowed to initiate communication\n");
 		return -EINVAL;
+	}
 
 	ibss.channel_fixed = !!info->attrs[NL80211_ATTR_FREQ_FIXED];
 	ibss.privacy = !!info->attrs[NL80211_ATTR_PRIVACY];
-- 
1.7.3.4
