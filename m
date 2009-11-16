Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40746 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbZKPLIk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 06:08:40 -0500
Message-Id: <20091116110720.266695628@sipsolutions.net>
Date: Mon, 16 Nov 2009 12:00:37 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: [PATCH 1/4] mac80211: let sta_info_get_by_idx get sta by sdata
References: <20091116110036.010062226@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of filtering by device, directly look up by sdata.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/cfg.c      |    4 ++--
 net/mac80211/sta_info.c |    7 ++++---
 net/mac80211/sta_info.h |    4 ++--
 3 files changed, 8 insertions(+), 7 deletions(-)

--- wireless-testing.orig/net/mac80211/cfg.c	2009-11-13 09:33:41.000000000 +0100
+++ wireless-testing/net/mac80211/cfg.c	2009-11-13 09:33:43.000000000 +0100
@@ -398,13 +398,13 @@ static void sta_set_sinfo(struct sta_inf
 static int ieee80211_dump_station(struct wiphy *wiphy, struct net_device *dev,
 				 int idx, u8 *mac, struct station_info *sinfo)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct sta_info *sta;
 	int ret = -ENOENT;
 
 	rcu_read_lock();
 
-	sta = sta_info_get_by_idx(local, idx, dev);
+	sta = sta_info_get_by_idx(sdata, idx);
 	if (sta) {
 		ret = 0;
 		memcpy(mac, sta->sta.addr, ETH_ALEN);
--- wireless-testing.orig/net/mac80211/sta_info.c	2009-11-13 09:33:41.000000000 +0100
+++ wireless-testing/net/mac80211/sta_info.c	2009-11-13 09:33:43.000000000 +0100
@@ -116,14 +116,15 @@ struct sta_info *sta_info_get(struct iee
 	return sta;
 }
 
-struct sta_info *sta_info_get_by_idx(struct ieee80211_local *local, int idx,
-				     struct net_device *dev)
+struct sta_info *sta_info_get_by_idx(struct ieee80211_sub_if_data *sdata,
+				     int idx)
 {
+	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 	int i = 0;
 
 	list_for_each_entry_rcu(sta, &local->sta_list, list) {
-		if (dev && dev != sta->sdata->dev)
+		if (sdata != sta->sdata)
 			continue;
 		if (i < idx) {
 			++i;
--- wireless-testing.orig/net/mac80211/sta_info.h	2009-11-13 09:33:41.000000000 +0100
+++ wireless-testing/net/mac80211/sta_info.h	2009-11-13 09:33:43.000000000 +0100
@@ -409,8 +409,8 @@ struct sta_info *sta_info_get(struct iee
 /*
  * Get STA info by index, BROKEN!
  */
-struct sta_info *sta_info_get_by_idx(struct ieee80211_local *local, int idx,
-				      struct net_device *dev);
+struct sta_info *sta_info_get_by_idx(struct ieee80211_sub_if_data *sdata,
+				     int idx);
 /*
  * Create a new STA info, caller owns returned structure
  * until sta_info_insert().


