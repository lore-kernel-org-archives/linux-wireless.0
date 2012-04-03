Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49734 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab2DCOkH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2012 10:40:07 -0400
Received: by bkcik5 with SMTP id ik5so3695907bkc.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 Apr 2012 07:40:05 -0700 (PDT)
From: Pontus Fuchs <pontus.fuchs@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] cfg80211: Add channel information to NL80211_CMD_GET_INTERFACE
Date: Tue,  3 Apr 2012 16:39:58 +0200
Message-Id: <1333463998-19329-1-git-send-email-pontus.fuchs@gmail.com> (sfid-20120403_164012_468794_1452235E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the current channel is known, add frequency and channel type to
NL80211_CMD_GET_INTERFACE.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
---
 include/net/cfg80211.h     |    3 ++-
 net/mac80211/cfg.c         |    4 +++-
 net/wireless/nl80211.c     |   13 +++++++++++++
 net/wireless/wext-compat.c |    3 ++-
 4 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 83d800c..a1b202c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1698,7 +1698,8 @@ struct cfg80211_ops {
 				  struct net_device *dev,
 				  u16 noack_map);
 
-	struct ieee80211_channel *(*get_channel)(struct wiphy *wiphy);
+	struct ieee80211_channel *(*get_channel)(struct wiphy *wiphy,
+					       enum nl80211_channel_type *type);
 };
 
 /*
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 677d659..dff41f4 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2666,10 +2666,12 @@ static int ieee80211_probe_client(struct wiphy *wiphy, struct net_device *dev,
 }
 
 static struct ieee80211_channel *
-ieee80211_wiphy_get_channel(struct wiphy *wiphy)
+ieee80211_wiphy_get_channel(struct wiphy *wiphy,
+			    enum nl80211_channel_type *type)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 
+	*type = local->_oper_channel_type;
 	return local->oper_channel;
 }
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e49da27..66c4d27 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1493,6 +1493,19 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 		    rdev->devlist_generation ^
 			(cfg80211_rdev_list_generation << 2));
 
+	if (rdev->ops->get_channel) {
+		struct ieee80211_channel *chan;
+		enum nl80211_channel_type channel_type;
+
+		chan = rdev->ops->get_channel(&rdev->wiphy, &channel_type);
+		if (chan) {
+			NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_FREQ,
+				    chan->center_freq);
+			NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_CHANNEL_TYPE,
+				    channel_type);
+		}
+	}
+
 	return genlmsg_end(msg, hdr);
 
  nla_put_failure:
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 3c24eb9..6a6181a 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -821,6 +821,7 @@ static int cfg80211_wext_giwfreq(struct net_device *dev,
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
 	struct ieee80211_channel *chan;
+	enum nl80211_channel_type channel_type;
 
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_STATION:
@@ -831,7 +832,7 @@ static int cfg80211_wext_giwfreq(struct net_device *dev,
 		if (!rdev->ops->get_channel)
 			return -EINVAL;
 
-		chan = rdev->ops->get_channel(wdev->wiphy);
+		chan = rdev->ops->get_channel(wdev->wiphy, &channel_type);
 		if (!chan)
 			return -EINVAL;
 		freq->m = chan->center_freq;
-- 
1.7.5.4

