Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:54317 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756104Ab2EJGpL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 02:45:11 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 5/7] cfg80211: extend get_channel to take wdev argument
Date: Thu, 10 May 2012 08:44:40 +0200
Message-ID: <1336632282-2278-6-git-send-email-michal.kazior@tieto.com> (sfid-20120510_084533_041076_3FC41C6D)
In-Reply-To: <1336632282-2278-1-git-send-email-michal.kazior@tieto.com>
References: <1336632282-2278-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prepares for moving oper_channel to sdata.

Change-Id: I1d66c4506a463c6b673457127a4bd595fa6018ce
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 include/net/cfg80211.h     |    3 ++-
 net/mac80211/cfg.c         |    1 +
 net/wireless/nl80211.c     |    7 ++++++-
 net/wireless/wext-compat.c |    2 +-
 4 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d17ad5f..55b3c4b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1711,7 +1711,8 @@ struct cfg80211_ops {
 				  u16 noack_map);
 
 	struct ieee80211_channel *(*get_channel)(struct wiphy *wiphy,
-					       enum nl80211_channel_type *type);
+						 struct wireless_dev *wdev,
+						 enum nl80211_channel_type *type);
 };
 
 /*
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 9fa5044..8b71e90 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2693,6 +2693,7 @@ static int ieee80211_probe_client(struct wiphy *wiphy, struct net_device *dev,
 
 static struct ieee80211_channel *
 ieee80211_wiphy_get_channel(struct wiphy *wiphy,
+			    struct wireless_dev *wdev,
 			    enum nl80211_channel_type *type)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index bcf6f70..2854a4f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1502,10 +1502,15 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 			(cfg80211_rdev_list_generation << 2));
 
 	if (rdev->ops->get_channel) {
+		struct wireless_dev *wdev = dev->ieee80211_ptr;
 		struct ieee80211_channel *chan;
 		enum nl80211_channel_type channel_type;
 
-		chan = rdev->ops->get_channel(&rdev->wiphy, &channel_type);
+		wdev_lock(wdev);
+		chan = rdev->ops->get_channel(&rdev->wiphy, wdev,
+					      &channel_type);
+		wdev_unlock(wdev);
+
 		if (chan) {
 			NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_FREQ,
 				    chan->center_freq);
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 6a6181a..d545afe 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -832,7 +832,7 @@ static int cfg80211_wext_giwfreq(struct net_device *dev,
 		if (!rdev->ops->get_channel)
 			return -EINVAL;
 
-		chan = rdev->ops->get_channel(wdev->wiphy, &channel_type);
+		chan = rdev->ops->get_channel(wdev->wiphy, wdev, &channel_type);
 		if (!chan)
 			return -EINVAL;
 		freq->m = chan->center_freq;
-- 
1.7.0.4

