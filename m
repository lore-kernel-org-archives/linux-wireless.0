Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-da01.nokia.com ([147.243.128.24]:26092 "EHLO
	mgw-da01.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab0KAMZ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 08:25:59 -0400
Received: from localhost.localdomain (chilepepper.research.nokia.com [172.21.50.167])
	by mgw-da01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oA1BqGcM020116
	for <linux-wireless@vger.kernel.org>; Mon, 1 Nov 2010 13:52:26 +0200
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC 10/15] nl80211: add channel support to the periodic scan
Date: Mon,  1 Nov 2010 13:52:11 +0200
Message-Id: <1288612336-2830-11-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
References: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Parse and add channel information to the periodic scan request.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 net/wireless/nl80211.c |   73 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 71 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e1d7ab2..d5b9047 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3004,7 +3004,11 @@ static int nl80211_start_periodic(struct sk_buff *skb,
 	struct cfg80211_periodic_request *request;
 	struct cfg80211_registered_device *rdev;
 	struct net_device *dev;
-	int err;
+	struct ieee80211_channel *channel;
+	struct nlattr *attr;
+	struct wiphy *wiphy;
+	int err, tmp, n_channels, i;
+	enum ieee80211_band band;
 
 	printk("nl80211_start_periodic\n");
 
@@ -3029,7 +3033,24 @@ static int nl80211_start_periodic(struct sk_buff *skb,
 		goto out;
 	}
 
-	request = kzalloc(sizeof(*request), GFP_KERNEL);
+	wiphy = &rdev->wiphy;
+
+	if (info->attrs[NL80211_ATTR_SCAN_FREQUENCIES]) {
+		n_channels = validate_scan_freqs(
+				info->attrs[NL80211_ATTR_SCAN_FREQUENCIES]);
+		if (!n_channels)
+			return -EINVAL;
+	} else {
+		n_channels = 0;
+
+		for (band = 0; band < IEEE80211_NUM_BANDS; band++)
+			if (wiphy->bands[band])
+				n_channels += wiphy->bands[band]->n_channels;
+	}
+
+	request = kzalloc(sizeof(*request)
+			  + sizeof(channel) * n_channels,
+			  GFP_KERNEL);
 	if (!request) {
 		err = -ENOMEM;
 		goto out;
@@ -3040,8 +3061,56 @@ static int nl80211_start_periodic(struct sk_buff *skb,
 
 	rdev->periodic_req = request;
 
+	i = 0;
+	if (info->attrs[NL80211_ATTR_SCAN_FREQUENCIES]) {
+		/* user specified, bail out if channel not found */
+		nla_for_each_nested(attr, info->attrs[NL80211_ATTR_SCAN_FREQUENCIES], tmp) {
+			struct ieee80211_channel *chan;
+
+			chan = ieee80211_get_channel(wiphy, nla_get_u32(attr));
+
+			if (!chan) {
+				err = -EINVAL;
+				goto out_free;
+			}
+
+			/* ignore disabled channels */
+			if (chan->flags & IEEE80211_CHAN_DISABLED)
+				continue;
+
+			request->channels[i] = chan;
+			i++;
+		}
+	} else {
+		/* all channels */
+		for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+			int j;
+			if (!wiphy->bands[band])
+				continue;
+			for (j = 0; j < wiphy->bands[band]->n_channels; j++) {
+				struct ieee80211_channel *chan;
+
+				chan = &wiphy->bands[band]->channels[j];
+
+				if (chan->flags & IEEE80211_CHAN_DISABLED)
+					continue;
+
+				request->channels[i] = chan;
+				i++;
+			}
+		}
+	}
+
+	if (!i) {
+		err = -EINVAL;
+		goto out_free;
+	}
+
+	request->n_channels = i;
+
 	err = rdev->ops->periodic_start(&rdev->wiphy, dev, request);
 	if (err) {
+out_free:
 		kfree(request);
 		rdev->periodic_req = NULL;
 		goto out;
-- 
1.7.0.4

