Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:44400 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab1K1R4Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 12:56:25 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Alexander Simon <an.alexsimon@googlemail.com>,
	Marek Lindner <lindner_marek@yahoo.de>,
	Felix Fietkau <nbd@openwrt.org>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH 2/4] nl80211: Parse channel type attribute in an ibss join request
Date: Mon, 28 Nov 2011 18:55:14 +0100
Message-Id: <1322502917-28205-3-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20111128_185631_268455_74DB7DBA)
In-Reply-To: <1322502917-28205-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1322502917-28205-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prepare cfg80211 for IBSS HT:
 * extend cfg80211 ibss struct with channel_type
 * Check if extension channel can be used
 * Export can_beacon_sec_chan for use in mac80211 (will be called
   from ibss.c later).

Signed-off-by: Alexander Simon <an.alexsimon@googlemail.com>
[siwu@hrz.tu-chemnitz.de: Updates]
* fix cfg80211_can_beacon_ext_chan comment
* remove implicit channel_type enum assumptions
* remove radar channel flags check
* reword commit message

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 include/net/cfg80211.h |   11 +++++++++++
 net/wireless/chan.c    |   12 +++++++-----
 net/wireless/nl80211.c |   27 +++++++++++++++++++++++++--
 3 files changed, 43 insertions(+), 7 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d5e1891..d77c6ad 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1146,6 +1146,7 @@ struct cfg80211_ibss_params {
 	u8 *ssid;
 	u8 *bssid;
 	struct ieee80211_channel *channel;
+	enum nl80211_channel_type channel_type;
 	u8 *ie;
 	u8 ssid_len, ie_len;
 	u16 beacon_interval;
@@ -3257,6 +3258,16 @@ void cfg80211_report_obss_beacon(struct wiphy *wiphy,
 				 const u8 *frame, size_t len,
 				 int freq, gfp_t gfp);
 
+/*
+ * cfg80211_can_beacon_sec_chan - test if ht40 on extension channel can be used
+ * @wiphy: the wiphy
+ * @chan: main channel
+ * @channel_type: HT mode
+ */
+int cfg80211_can_beacon_sec_chan(struct wiphy *wiphy,
+				 struct ieee80211_channel *chan,
+				 enum nl80211_channel_type channel_type);
+
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 17cd0c0..2fcfe09 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -6,6 +6,7 @@
  * Copyright 2009	Johannes Berg <johannes@sipsolutions.net>
  */
 
+#include <linux/export.h>
 #include <net/cfg80211.h>
 #include "core.h"
 
@@ -44,9 +45,9 @@ rdev_freq_to_chan(struct cfg80211_registered_device *rdev,
 	return chan;
 }
 
-static bool can_beacon_sec_chan(struct wiphy *wiphy,
-				struct ieee80211_channel *chan,
-				enum nl80211_channel_type channel_type)
+int cfg80211_can_beacon_sec_chan(struct wiphy *wiphy,
+				  struct ieee80211_channel *chan,
+				  enum nl80211_channel_type channel_type)
 {
 	struct ieee80211_channel *sec_chan;
 	int diff;
@@ -75,6 +76,7 @@ static bool can_beacon_sec_chan(struct wiphy *wiphy,
 
 	return true;
 }
+EXPORT_SYMBOL(cfg80211_can_beacon_sec_chan);
 
 int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
 		      struct wireless_dev *wdev, int freq,
@@ -109,8 +111,8 @@ int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
 		switch (channel_type) {
 		case NL80211_CHAN_HT40PLUS:
 		case NL80211_CHAN_HT40MINUS:
-			if (!can_beacon_sec_chan(&rdev->wiphy, chan,
-						 channel_type)) {
+			if (!cfg80211_can_beacon_sec_chan(&rdev->wiphy, chan,
+							  channel_type)) {
 				printk(KERN_DEBUG
 				       "cfg80211: Secondary channel not "
 				       "allowed to initiate communication\n");
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a1cabde..d675398 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4657,13 +4657,36 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 		ibss.ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
 	}
 
-	ibss.channel = ieee80211_get_channel(wiphy,
-		nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]));
+	if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]) {
+		enum nl80211_channel_type channel_type;
+
+		channel_type = nla_get_u32(
+				info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]);
+		if (channel_type != NL80211_CHAN_NO_HT &&
+		    channel_type != NL80211_CHAN_HT20 &&
+		    channel_type != NL80211_CHAN_HT40MINUS &&
+		    channel_type != NL80211_CHAN_HT40PLUS)
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
 	    ibss.channel->flags & IEEE80211_CHAN_NO_IBSS ||
 	    ibss.channel->flags & IEEE80211_CHAN_DISABLED)
 		return -EINVAL;
 
+	/* Both channels should be able to initiate communication */
+	if ((ibss.channel_type == NL80211_CHAN_HT40PLUS ||
+	     ibss.channel_type == NL80211_CHAN_HT40MINUS) &&
+	    !cfg80211_can_beacon_sec_chan(&rdev->wiphy, ibss.channel,
+					  ibss.channel_type))
+		return -EINVAL;
+
 	ibss.channel_fixed = !!info->attrs[NL80211_ATTR_FREQ_FIXED];
 	ibss.privacy = !!info->attrs[NL80211_ATTR_PRIVACY];
 
-- 
1.7.7.3

