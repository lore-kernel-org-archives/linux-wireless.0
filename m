Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52179 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab1H2OPw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 10:15:52 -0400
Received: by ewy4 with SMTP id 4so2369935ewy.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Aug 2011 07:15:50 -0700 (PDT)
From: Alexander Simon <an.alexsimon@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v2 1/4] nl80211: Parse channel type attribute in an IBSS join request
Date: Mon, 29 Aug 2011 16:15:47 +0200
Message-ID: <2053881.ENil2Dy3QM@alex-1> (sfid-20110829_161556_944174_8A64BBCC)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check if the requested HT mode can be used.
Extend cfg80211 IBSS struct for HT mode.

Signed-off-by: Alexander Simon <alexander.simon@saxnet.de>
---
 include/net/cfg80211.h |   11 +++++++++++
 net/wireless/chan.c    |   11 ++++++-----
 net/wireless/nl80211.c |   30 +++++++++++++++++++++++++++---
 3 files changed, 44 insertions(+), 8 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 88112ca..6d6e4b1 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1085,6 +1085,7 @@ struct cfg80211_ibss_params {
 	u8 *ssid;
 	u8 *bssid;
 	struct ieee80211_channel *channel;
+	enum nl80211_channel_type channel_type;
 	u8 *ie;
 	u8 ssid_len, ie_len;
 	u16 beacon_interval;
@@ -3086,6 +3087,16 @@ void cfg80211_cqm_pktloss_notify(struct net_device *dev,
 void cfg80211_gtk_rekey_notify(struct net_device *dev, const u8 *bssid,
 			       const u8 *replay_ctr, gfp_t gfp);
 
+/**
+ * cfg80211_can_use_ext_chan - test if ht40 on extension channel can be used
+ * @wiphy: the wiphy
+ * @chan: main channel
+ * @channel_type: HT mode
+ */
+bool cfg80211_can_use_ext_chan(struct wiphy *wiphy,
+			       struct ieee80211_channel *chan,
+			       enum nl80211_channel_type channel_type);
+
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 17cd0c0..8a9ab99 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -44,9 +44,9 @@ rdev_freq_to_chan(struct cfg80211_registered_device *rdev,
 	return chan;
 }
 
-static bool can_beacon_sec_chan(struct wiphy *wiphy,
-				struct ieee80211_channel *chan,
-				enum nl80211_channel_type channel_type)
+bool cfg80211_can_use_ext_chan(struct wiphy *wiphy,
+			       struct ieee80211_channel *chan,
+			       enum nl80211_channel_type channel_type)
 {
 	struct ieee80211_channel *sec_chan;
 	int diff;
@@ -75,6 +75,7 @@ static bool can_beacon_sec_chan(struct wiphy *wiphy,
 
 	return true;
 }
+EXPORT_SYMBOL(cfg80211_can_use_ext_chan);
 
 int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
 		      struct wireless_dev *wdev, int freq,
@@ -109,8 +110,8 @@ int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
 		switch (channel_type) {
 		case NL80211_CHAN_HT40PLUS:
 		case NL80211_CHAN_HT40MINUS:
-			if (!can_beacon_sec_chan(&rdev->wiphy, chan,
-						 channel_type)) {
+			if (!cfg80211_can_use_ext_chan(&rdev->wiphy, chan,
+						       channel_type)) {
 				printk(KERN_DEBUG
 				       "cfg80211: Secondary channel not "
 				       "allowed to initiate communication\n");
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index bddb559..50589df 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4468,11 +4468,35 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
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
+	    !cfg80211_can_use_ext_chan(&rdev->wiphy, ibss.channel,
+				       ibss.channel_type))
 		return -EINVAL;
 
 	ibss.channel_fixed = !!info->attrs[NL80211_ATTR_FREQ_FIXED];
-- 
1.7.3.4


