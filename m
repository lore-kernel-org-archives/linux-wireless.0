Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58070 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab1FUPw1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 11:52:27 -0400
Received: by fxm17 with SMTP id 17so34677fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jun 2011 08:52:26 -0700 (PDT)
Subject: [RFC v3 2/3] nl80211: channel type attribute for IBSS
From: Alexander Simon <alexander.simon@saxnet.de>
To: linux-wireless@vger.kernel.org
In-Reply-To: <1308671129.2656.4.camel@alex-2>
References: <1308671129.2656.4.camel@alex-2>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Jun 2011 17:52:24 +0200
Message-ID: <1308671544.2656.8.camel@alex-2> (sfid-20110621_175230_715106_4D770237)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow nl80211 to set a ht channel for ibss.

Signed-off-by: Alexander Simon <alexander.simon@saxnet.de>
---
 include/net/cfg80211.h |    1 +
 net/wireless/nl80211.c |   33 +++++++++++++++++++++++++++++----
 2 files changed, 30 insertions(+), 4 deletions(-)

diff -Nrup a/include/net/cfg80211.h b/include/net/cfg80211.h
--- a/include/net/cfg80211.h	2011-06-01 21:04:33.000000000 +0200
+++ b/include/net/cfg80211.h	2011-06-21 13:21:38.000000000 +0200
@@ -1038,6 +1038,7 @@ struct cfg80211_ibss_params {
 	u8 *ssid;
 	u8 *bssid;
 	struct ieee80211_channel *channel;
+	enum nl80211_channel_type channel_type;
 	u8 *ie;
 	u8 ssid_len, ie_len;
 	u16 beacon_interval;
diff -Nrup a/net/wireless/nl80211.c b/net/wireless/nl80211.c
--- a/net/wireless/nl80211.c	2011-06-01 21:04:33.000000000 +0200
+++ b/net/wireless/nl80211.c	2011-06-21 13:21:38.000000000 +0200
@@ -4266,12 +4266,37 @@ static int nl80211_join_ibss(struct sk_b
 		ibss.ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
 	}
 
-	ibss.channel = ieee80211_get_channel(wiphy,
-		nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]));
-	if (!ibss.channel ||
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
+	/*if (!ibss.channel ||
+	    ibss.channel->flags & IEEE80211_CHAN_PASSIVE_SCAN ||
 	    ibss.channel->flags & IEEE80211_CHAN_NO_IBSS ||
-	    ibss.channel->flags & IEEE80211_CHAN_DISABLED)
+	    ibss.channel->flags & IEEE80211_CHAN_RADAR)
+		return -EINVAL;
+	if ((ibss.channel_type == NL80211_CHAN_HT40PLUS ||
+	     ibss.channel_type == NL80211_CHAN_HT40MINUS) &&
+	    !can_beacon_sec_chan(&rdev->wiphy, ibss.chan, ibss.channel_type)) {
+		printk(KERN_DEBUG
+		       "cfg80211: Secondary channel not "
+		       "allowed to initiate communication\n");
 		return -EINVAL;
+	}*/
 
 	ibss.channel_fixed = !!info->attrs[NL80211_ATTR_FREQ_FIXED];
 	ibss.privacy = !!info->attrs[NL80211_ATTR_PRIVACY];



