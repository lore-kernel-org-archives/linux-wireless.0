Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-da01.nokia.com ([147.243.128.24]:26094 "EHLO
	mgw-da01.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523Ab0KAMZ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 08:25:59 -0400
Received: from localhost.localdomain (chilepepper.research.nokia.com [172.21.50.167])
	by mgw-da01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oA1BqGcP020116
	for <linux-wireless@vger.kernel.org>; Mon, 1 Nov 2010 13:52:29 +0200
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC 13/15] nl80211: add ssid filtering support to the periodic scan
Date: Mon,  1 Nov 2010 13:52:14 +0200
Message-Id: <1288612336-2830-14-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
References: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Parse and add ssids information to the periodic scan request.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 net/wireless/nl80211.c |   38 +++++++++++++++++++++++++++++++++-----
 1 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d5b9047..5ae5935 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3004,10 +3004,11 @@ static int nl80211_start_periodic(struct sk_buff *skb,
 	struct cfg80211_periodic_request *request;
 	struct cfg80211_registered_device *rdev;
 	struct net_device *dev;
+	struct cfg80211_ssid *ssid;
 	struct ieee80211_channel *channel;
 	struct nlattr *attr;
 	struct wiphy *wiphy;
-	int err, tmp, n_channels, i;
+	int err, tmp, n_ssids = 0, n_channels, i;
 	enum ieee80211_band band;
 
 	printk("nl80211_start_periodic\n");
@@ -3048,7 +3049,17 @@ static int nl80211_start_periodic(struct sk_buff *skb,
 				n_channels += wiphy->bands[band]->n_channels;
 	}
 
+	if (info->attrs[NL80211_ATTR_SCAN_SSIDS])
+		nla_for_each_nested(attr, info->attrs[NL80211_ATTR_SCAN_SSIDS], tmp)
+			n_ssids++;
+
+	if (n_ssids > wiphy->max_periodic_ssids) {
+		err = -EINVAL;
+		goto out ;
+	}
+
 	request = kzalloc(sizeof(*request)
+			  + sizeof(*ssid) * n_ssids
 			  + sizeof(channel) * n_channels,
 			  GFP_KERNEL);
 	if (!request) {
@@ -3056,10 +3067,9 @@ static int nl80211_start_periodic(struct sk_buff *skb,
 		goto out;
 	}
 
-	request->dev = dev;
-	request->wiphy = &rdev->wiphy;
-
-	rdev->periodic_req = request;
+	if (n_ssids)
+		request->ssids = (void *)&request->channels[n_channels];
+	request->n_ssids = n_ssids;
 
 	i = 0;
 	if (info->attrs[NL80211_ATTR_SCAN_FREQUENCIES]) {
@@ -3108,6 +3118,24 @@ static int nl80211_start_periodic(struct sk_buff *skb,
 
 	request->n_channels = i;
 
+	i = 0;
+	if (info->attrs[NL80211_ATTR_SCAN_SSIDS]) {
+		nla_for_each_nested(attr, info->attrs[NL80211_ATTR_SCAN_SSIDS], tmp) {
+			if (request->ssids[i].ssid_len > IEEE80211_MAX_SSID_LEN) {
+				err = -EINVAL;
+				goto out_free;
+			}
+			memcpy(request->ssids[i].ssid, nla_data(attr), nla_len(attr));
+			request->ssids[i].ssid_len = nla_len(attr);
+			i++;
+		}
+	}
+
+	request->dev = dev;
+	request->wiphy = &rdev->wiphy;
+
+	rdev->periodic_req = request;
+
 	err = rdev->ops->periodic_start(&rdev->wiphy, dev, request);
 	if (err) {
 out_free:
-- 
1.7.0.4

