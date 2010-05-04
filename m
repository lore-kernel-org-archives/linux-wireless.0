Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:40099 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754696Ab0EDGwb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 02:52:31 -0400
From: Benoit Papillault <benoit.papillault@free.fr>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Benoit Papillault <benoit.papillault@free.fr>
Subject: [PATCH] cfg80211: Parse channel_type in NL80211_CMD_JOIN_IBSS
Date: Tue,  4 May 2010 08:47:00 +0200
Message-Id: <1272955622-6987-1-git-send-email-benoit.papillault@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This field is filled by iw and parse by cfg80211 before being sent to
mac80211 for instance. This information is needed to properly configure
an HT IBSS.

It requires a patch to iw to fill this field.

Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
---
 include/net/cfg80211.h |    1 +
 net/wireless/nl80211.c |   12 ++++++++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

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
index 01da83d..8da9823 100644
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
-- 
1.5.6.5

