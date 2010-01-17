Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:51677 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754670Ab0AQUoJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2010 15:44:09 -0500
Message-ID: <4B537697.2080604@openwrt.org>
Date: Sun, 17 Jan 2010 21:44:07 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v2] cfg80211: allow user space to query the operating frequency
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -75,6 +75,7 @@ struct cfg80211_registered_device {
 
 	/* current channel */
 	struct ieee80211_channel *channel;
+	enum nl80211_channel_type channel_type;
 
 	/* must be last because of the way we do wiphy_priv(),
 	 * and it should at least be aligned to NETDEV_ALIGN */
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -97,6 +97,7 @@ int rdev_set_freq(struct cfg80211_regist
 		return result;
 
 	rdev->channel = chan;
+	rdev->channel_type = channel_type;
 
 	return 0;
 }
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -881,6 +881,11 @@ static int nl80211_send_iface(struct sk_
 	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
 	NLA_PUT_STRING(msg, NL80211_ATTR_IFNAME, dev->name);
 	NLA_PUT_U32(msg, NL80211_ATTR_IFTYPE, dev->ieee80211_ptr->iftype);
+	if (rdev->channel) {
+		NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_FREQ, rdev->channel->center_freq);
+		NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_CHANNEL_TYPE, rdev->channel_type);
+	}
+
 
 	NLA_PUT_U32(msg, NL80211_ATTR_GENERATION,
 		    rdev->devlist_generation ^
