Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:43749 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506Ab0AQTzI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2010 14:55:08 -0500
Message-ID: <4B536B05.6070301@openwrt.org>
Date: Sun, 17 Jan 2010 20:54:45 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/2] cfg80211: add a callback for querying the operating frequency
 and export it through nl80211
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -954,6 +954,8 @@ struct cfg80211_pmksa {
  *
  * @set_txq_params: Set TX queue parameters
  *
+ * @get_channel: Get operating channel
+ *
  * @set_channel: Set channel
  *
  * @scan: Request to do a scan. If returning zero, the scan request is given
@@ -1079,6 +1081,10 @@ struct cfg80211_ops {
 	int	(*set_txq_params)(struct wiphy *wiphy,
 				  struct ieee80211_txq_params *params);
 
+	int	(*get_channel)(struct wiphy *wiphy,
+			       struct ieee80211_channel **chan,
+			       enum nl80211_channel_type *channel_type);
+
 	int	(*set_channel)(struct wiphy *wiphy,
 			       struct ieee80211_channel *chan,
 			       enum nl80211_channel_type channel_type);
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -427,7 +427,8 @@ static int nl80211_send_wiphy(struct sk_
 	struct nlattr *nl_modes;
 	struct nlattr *nl_cmds;
 	enum ieee80211_band band;
-	struct ieee80211_channel *chan;
+	struct ieee80211_channel *chan = NULL;
+	enum nl80211_channel_type chan_type;
 	struct ieee80211_rate *rate;
 	int i;
 	u16 ifmodes = dev->wiphy.interface_modes;
@@ -465,6 +466,12 @@ static int nl80211_send_wiphy(struct sk_
 	NLA_PUT_U8(msg, NL80211_ATTR_MAX_NUM_PMKIDS,
 		   dev->wiphy.max_num_pmkids);
 
+	if (dev->ops->get_channel &&
+	    dev->ops->get_channel(&dev->wiphy, &chan, &chan_type) == 0) {
+		NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_FREQ, chan->center_freq);
+		NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_CHANNEL_TYPE, chan_type);
+	}
+
 	nl_modes = nla_nest_start(msg, NL80211_ATTR_SUPPORTED_IFTYPES);
 	if (!nl_modes)
 		goto nla_put_failure;
