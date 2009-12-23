Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41986 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789AbZLWMXZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 07:23:25 -0500
Message-Id: <20091223121617.798148880@sipsolutions.net>
Date: Wed, 23 Dec 2009 13:15:44 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH next 15/18] mac80211/cfg80211: add station events
References: <20091223121529.289129599@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When, for instance, a new IBSS peer is found, userspace
wants to be notified. Add events for all new stations
that mac80211 learns about.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h  |   12 ++++++++++++
 net/mac80211/sta_info.c |    5 +++++
 net/wireless/mlme.c     |   10 ++++++++++
 net/wireless/nl80211.c  |   21 ++++++++++++++++++++-
 net/wireless/nl80211.h  |    4 ++++
 5 files changed, 51 insertions(+), 1 deletion(-)

--- wireless-testing.orig/net/wireless/mlme.c	2009-12-23 13:11:25.000000000 +0100
+++ wireless-testing/net/wireless/mlme.c	2009-12-23 13:11:27.000000000 +0100
@@ -718,3 +718,13 @@ void cfg80211_remain_on_channel_expired(
 					      channel_type, gfp);
 }
 EXPORT_SYMBOL(cfg80211_remain_on_channel_expired);
+
+void cfg80211_new_sta(struct net_device *dev, const u8 *mac_addr,
+		      struct station_info *sinfo, gfp_t gfp)
+{
+	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	nl80211_send_sta_event(rdev, dev, mac_addr, sinfo, gfp);
+}
+EXPORT_SYMBOL(cfg80211_new_sta);
--- wireless-testing.orig/net/wireless/nl80211.c	2009-12-23 13:11:25.000000000 +0100
+++ wireless-testing/net/wireless/nl80211.c	2009-12-23 13:11:27.000000000 +0100
@@ -1642,7 +1642,7 @@ static int parse_station_flags(struct ge
 
 static int nl80211_send_station(struct sk_buff *msg, u32 pid, u32 seq,
 				int flags, struct net_device *dev,
-				u8 *mac_addr, struct station_info *sinfo)
+				const u8 *mac_addr, struct station_info *sinfo)
 {
 	void *hdr;
 	struct nlattr *sinfoattr, *txrate;
@@ -5356,6 +5356,25 @@ void nl80211_send_remain_on_channel_canc
 					  channel_type, 0, gfp);
 }
 
+void nl80211_send_sta_event(struct cfg80211_registered_device *rdev,
+			    struct net_device *dev, const u8 *mac_addr,
+			    struct station_info *sinfo, gfp_t gfp)
+{
+	struct sk_buff *msg;
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, gfp);
+	if (!msg)
+		return;
+
+	if (nl80211_send_station(msg, 0, 0, 0, dev, mac_addr, sinfo) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_mlme_mcgrp.id, gfp);
+}
+
 /* initialisation/exit functions */
 
 int nl80211_init(void)
--- wireless-testing.orig/net/wireless/nl80211.h	2009-12-23 13:11:25.000000000 +0100
+++ wireless-testing/net/wireless/nl80211.h	2009-12-23 13:11:27.000000000 +0100
@@ -70,4 +70,8 @@ void nl80211_send_remain_on_channel_canc
 	u64 cookie, struct ieee80211_channel *chan,
 	enum nl80211_channel_type channel_type, gfp_t gfp);
 
+void nl80211_send_sta_event(struct cfg80211_registered_device *rdev,
+			    struct net_device *dev, const u8 *mac_addr,
+			    struct station_info *sinfo, gfp_t gfp);
+
 #endif /* __NET_WIRELESS_NL80211_H */
--- wireless-testing.orig/include/net/cfg80211.h	2009-12-23 13:11:25.000000000 +0100
+++ wireless-testing/include/net/cfg80211.h	2009-12-23 13:11:27.000000000 +0100
@@ -2195,4 +2195,16 @@ void cfg80211_remain_on_channel_expired(
 					enum nl80211_channel_type channel_type,
 					gfp_t gfp);
 
+
+/**
+ * cfg80211_new_sta - notify userspace about station
+ *
+ * @dev: the netdev
+ * @mac_addr: the station's address
+ * @sinfo: the station information
+ * @gfp: allocation flags
+ */
+void cfg80211_new_sta(struct net_device *dev, const u8 *mac_addr,
+		      struct station_info *sinfo, gfp_t gfp);
+
 #endif /* __NET_CFG80211_H */
--- wireless-testing.orig/net/mac80211/sta_info.c	2009-12-23 13:11:13.000000000 +0100
+++ wireless-testing/net/mac80211/sta_info.c	2009-12-23 13:11:27.000000000 +0100
@@ -359,6 +359,7 @@ int sta_info_insert(struct sta_info *sta
 {
 	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct station_info sinfo;
 	unsigned long flags;
 	int err = 0;
 
@@ -408,6 +409,10 @@ int sta_info_insert(struct sta_info *sta
 
 	spin_unlock_irqrestore(&local->sta_lock, flags);
 
+	sinfo.filled = 0;
+	sinfo.generation = local->sta_generation;
+	cfg80211_new_sta(sdata->dev, sta->sta.addr, &sinfo, GFP_ATOMIC);
+
 #ifdef CONFIG_MAC80211_DEBUGFS
 	/*
 	 * Debugfs entry adding might sleep, so schedule process


