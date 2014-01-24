Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:49924 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbaAXNPA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 08:15:00 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nl80211: send event when AP interface is stopped by kernel
Date: Fri, 24 Jan 2014 14:14:56 +0100
Message-Id: <1390569296-23030-1-git-send-email-johannes@sipsolutions.net> (sfid-20140124_141505_968865_65374E31)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There are a few cases, e.g. suspend, where an AP interface is
stopped by the kernel rather than by userspace request, most
commonly when suspending. To let userspace know about this,
send the NL80211_CMD_STOP_AP command as an event every time
an AP interface is stopped. This also happens when userspace
did in fact request the AP stop, but that's not a problem.

For full-MAC drivers this may need to be extended to also
cover cases where the device stopped the AP operation for
some reason, this a bit more complicated because then all
cfg80211 state also needs to be reset; such API is not part
of this patch.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/ap.c      |  1 +
 net/wireless/nl80211.c | 29 +++++++++++++++++++++++++++++
 net/wireless/nl80211.h |  2 ++
 3 files changed, 32 insertions(+)

diff --git a/net/wireless/ap.c b/net/wireless/ap.c
index 11ee4ed..4760d655 100644
--- a/net/wireless/ap.c
+++ b/net/wireless/ap.c
@@ -30,6 +30,7 @@ static int __cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
 		wdev->channel = NULL;
 		wdev->ssid_len = 0;
 		rdev_set_qos_map(rdev, dev, NULL);
+		nl80211_send_ap_stopped(wdev);
 	}
 
 	return err;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 36fb595..6753203 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -11757,6 +11757,35 @@ void cfg80211_crit_proto_stopped(struct wireless_dev *wdev, gfp_t gfp)
 }
 EXPORT_SYMBOL(cfg80211_crit_proto_stopped);
 
+void nl80211_send_ap_stopped(struct wireless_dev *wdev)
+{
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_STOP_AP);
+	if (!hdr)
+		goto out;
+
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
+	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, wdev->netdev->ifindex) ||
+	    nla_put_u64(msg, NL80211_ATTR_WDEV, wdev_id(wdev)))
+		goto out;
+
+	genlmsg_end(msg, hdr);
+
+	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(wiphy), msg, 0,
+				NL80211_MCGRP_MLME, GFP_KERNEL);
+	return;
+ out:
+	nlmsg_free(msg);
+}
+
 /* initialisation/exit functions */
 
 int nl80211_init(void)
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index b1b2313..cb0216e 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -74,6 +74,8 @@ nl80211_radar_notify(struct cfg80211_registered_device *rdev,
 		     enum nl80211_radar_event event,
 		     struct net_device *netdev, gfp_t gfp);
 
+void nl80211_send_ap_stopped(struct wireless_dev *wdev);
+
 void cfg80211_rdev_free_coalesce(struct cfg80211_registered_device *rdev);
 
 #endif /* __NET_WIRELESS_NL80211_H */
-- 
1.8.5.2

