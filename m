Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:43481 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754768Ab0EEWgf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 May 2010 18:36:35 -0400
From: Benoit Papillault <benoit.papillault@free.fr>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Benoit Papillault <benoit.papillault@free.fr>
Subject: [PATCH v2] cfg80211: Parse channel_type in NL80211_CMD_JOIN_IBSS
Date: Thu,  6 May 2010 00:36:25 +0200
Message-Id: <1273098986-19330-1-git-send-email-benoit.papillault@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The channel_type field is filled by iw and parse by cfg80211 before
being sent to mac80211 for instance (we also check if the specified
channel is capable of ht40+, ht40- or ht20). This information is needed
to properly configure an HT IBSS.

It requires a patch to iw to fill this field.

Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
---
 include/net/cfg80211.h |    1 +
 net/wireless/nl80211.c |   20 ++++++++++++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7d10c01..93e5558 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -806,6 +806,7 @@ struct cfg80211_ibss_params {
 	u8 *ssid;
 	u8 *bssid;
 	struct ieee80211_channel *channel;
+	enum nl80211_channel_type channel_type;
 	u8 *ie;
 	u8 ssid_len, ie_len;
 	u16 beacon_interval;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 01da83d..0a82623 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3792,6 +3792,7 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 	struct cfg80211_ibss_params ibss;
 	struct wiphy *wiphy;
 	struct cfg80211_cached_keys *connkeys = NULL;
+	enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
 	int err;
 
 	memset(&ibss, 0, sizeof(ibss));
@@ -3813,6 +3814,17 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 	}
 
+	if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]) {
+		channel_type = nla_get_u32(
+			info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]);
+		if (channel_type != NL80211_CHAN_NO_HT &&
+		    channel_type != NL80211_CHAN_HT20 &&
+		    channel_type != NL80211_CHAN_HT40PLUS &&
+		    channel_type != NL80211_CHAN_HT40MINUS)
+			return -EINVAL;
+	}
+	ibss.channel_type = channel_type;
+
 	rtnl_lock();
 
 	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
@@ -3846,11 +3858,11 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 		ibss.ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
 	}
 
-	ibss.channel = ieee80211_get_channel(wiphy,
-		nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]));
+	ibss.channel = rdev_freq_to_chan(rdev,
+		nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]),
+		channel_type);
 	if (!ibss.channel ||
-	    ibss.channel->flags & IEEE80211_CHAN_NO_IBSS ||
-	    ibss.channel->flags & IEEE80211_CHAN_DISABLED) {
+	    ibss.channel->flags & IEEE80211_CHAN_NO_IBSS) {
 		err = -EINVAL;
 		goto out;
 	}
-- 
1.5.6.5

