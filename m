Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam01on0049.outbound.protection.outlook.com ([104.47.34.49]:8992
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752902AbdKIJkz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Nov 2017 04:40:55 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [RFC PATCH 2/2] nl80211: implement beacon change notifier
Date: Thu,  9 Nov 2017 12:40:24 +0300
Message-Id: <20171109094024.9085-2-sergey.matyukevich.os@quantenna.com> (sfid-20171109_104133_108446_DE0B0D27)
In-Reply-To: <20171109094024.9085-1-sergey.matyukevich.os@quantenna.com>
References: <20171109094024.9085-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasily Ulyanov <vulyanov@quantenna.com>

Notify user-space listeners about beacon data change.

Signed-off-by: Vasily Ulyanov <vulyanov@quantenna.com>
---
 net/wireless/nl80211.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f03f9989efbc..98e52e5ffc13 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3950,6 +3950,26 @@ static int nl80211_send_beacon(struct sk_buff *msg, u32 portid,
 	return -EMSGSIZE;
 }
 
+static void nl80211_notify_beacon_change(struct net_device *dev,
+					 enum nl80211_commands cmd,
+					 struct cfg80211_beacon_data *bcn)
+{
+	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
+	struct sk_buff *msg;
+
+	msg = nlmsg_new(nl80211_beacon_size(bcn), GFP_KERNEL);
+	if (!msg)
+		return;
+
+	if (nl80211_send_beacon(msg, cmd, 0, 0, 0, bcn) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(wiphy), msg, 0,
+				NL80211_MCGRP_MLME, GFP_KERNEL);
+}
+
 static void nl80211_check_ap_rate_selectors(struct cfg80211_ap_settings *params,
 					    const u8 *rates)
 {
@@ -4250,6 +4270,8 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 		wdev->ssid_len = params.ssid_len;
 		memcpy(wdev->ssid, params.ssid, wdev->ssid_len);
 		nl80211_assign_beacon(&wdev->beacon, &new_bcn);
+		nl80211_notify_beacon_change(dev, NL80211_CMD_START_AP,
+					     &wdev->beacon);
 	}
 	wdev_unlock(wdev);
 
@@ -4317,8 +4339,11 @@ static int nl80211_set_beacon(struct sk_buff *skb, struct genl_info *info)
 
 	wdev_lock(wdev);
 	err = rdev_change_beacon(rdev, dev, &params);
-	if (!err)
+	if (!err) {
 		nl80211_assign_beacon(&wdev->beacon, &merged_bcn);
+		nl80211_notify_beacon_change(dev, NL80211_CMD_SET_BEACON,
+					     &wdev->beacon);
+	}
 	wdev_unlock(wdev);
 
 	if (err)
-- 
2.11.0
