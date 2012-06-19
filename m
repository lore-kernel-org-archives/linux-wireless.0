Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41945 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459Ab2FSAvD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 20:51:03 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH] cfg80211: fix regression in multi-vif AP start
Date: Tue, 19 Jun 2012 02:50:57 +0200
Message-Id: <1340067057-56601-1-git-send-email-nbd@openwrt.org> (sfid-20120619_025107_599430_882A16FC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit "cfg80211: provide channel to start_ap function" assumes that the
channel is always passed to the NL80211_CMD_START_AP command, however
in case of multi-BSSID, hostapd only passes the channel for the first vif.
This makes starting beaconing on secondary vifs fail with -EINVAL.

Fix this by storing the channel provided to .start_ap in wdev->preset_chan
and picking the first AP vif's channel for secondary vifs if not provided.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/wireless/nl80211.c |   34 ++++++++++++++++++++++++++++++++--
 1 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7ae54b8..6f7d645 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2246,6 +2246,33 @@ static int nl80211_parse_beacon(struct genl_info *info,
 	return 0;
 }
 
+static bool nl80211_get_ap_channel(struct cfg80211_registered_device *rdev,
+				   struct cfg80211_ap_settings *params)
+{
+	struct wireless_dev *wdev;
+	bool ret = false;
+
+	mutex_lock(&rdev->devlist_mtx);
+
+	list_for_each_entry(wdev, &rdev->netdev_list, list) {
+		if (wdev->iftype != NL80211_IFTYPE_AP &&
+		    wdev->iftype != NL80211_IFTYPE_P2P_GO)
+			continue;
+
+		if (!wdev->preset_chan)
+			continue;
+
+		params->channel = wdev->preset_chan;
+		params->channel_type = wdev->preset_chantype;
+		ret = true;
+		break;
+	}
+
+	mutex_unlock(&rdev->devlist_mtx);
+
+	return ret;
+}
+
 static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -2348,7 +2375,7 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	} else if (wdev->preset_chan) {
 		params.channel = wdev->preset_chan;
 		params.channel_type = wdev->preset_chantype;
-	} else
+	} else if (!nl80211_get_ap_channel(rdev, &params))
 		return -EINVAL;
 
 	if (!cfg80211_can_beacon_sec_chan(&rdev->wiphy, params.channel,
@@ -2356,8 +2383,11 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 
 	err = rdev->ops->start_ap(&rdev->wiphy, dev, &params);
-	if (!err)
+	if (!err) {
+		wdev->preset_chan = params.channel;
+		wdev->preset_chantype = params.channel_type;
 		wdev->beacon_interval = params.beacon_interval;
+	}
 	return err;
 }
 
-- 
1.7.3.2

