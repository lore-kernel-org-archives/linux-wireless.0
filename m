Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44045 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbZEISGy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 May 2009 14:06:54 -0400
Subject: [PATCH] cfg80211: constify key mac address in ops
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 09 May 2009 20:06:47 +0200
Message-Id: <1241892407.31262.9.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The address pointed to by mac_addr can be marked as const.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h |    6 +++---
 net/mac80211/cfg.c     |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

--- wireless-testing.orig/include/net/cfg80211.h	2009-05-09 19:59:45.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-05-09 19:59:48.000000000 +0200
@@ -858,13 +858,13 @@ struct cfg80211_ops {
 				       struct vif_params *params);
 
 	int	(*add_key)(struct wiphy *wiphy, struct net_device *netdev,
-			   u8 key_index, u8 *mac_addr,
+			   u8 key_index, const u8 *mac_addr,
 			   struct key_params *params);
 	int	(*get_key)(struct wiphy *wiphy, struct net_device *netdev,
-			   u8 key_index, u8 *mac_addr, void *cookie,
+			   u8 key_index, const u8 *mac_addr, void *cookie,
 			   void (*callback)(void *cookie, struct key_params*));
 	int	(*del_key)(struct wiphy *wiphy, struct net_device *netdev,
-			   u8 key_index, u8 *mac_addr);
+			   u8 key_index, const u8 *mac_addr);
 	int	(*set_default_key)(struct wiphy *wiphy,
 				   struct net_device *netdev,
 				   u8 key_index);
--- wireless-testing.orig/net/mac80211/cfg.c	2009-05-09 19:59:45.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2009-05-09 19:59:48.000000000 +0200
@@ -112,7 +112,7 @@ static int ieee80211_change_iface(struct
 }
 
 static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
-			     u8 key_idx, u8 *mac_addr,
+			     u8 key_idx, const u8 *mac_addr,
 			     struct key_params *params)
 {
 	struct ieee80211_sub_if_data *sdata;
@@ -166,7 +166,7 @@ static int ieee80211_add_key(struct wiph
 }
 
 static int ieee80211_del_key(struct wiphy *wiphy, struct net_device *dev,
-			     u8 key_idx, u8 *mac_addr)
+			     u8 key_idx, const u8 *mac_addr)
 {
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
@@ -208,7 +208,7 @@ static int ieee80211_del_key(struct wiph
 }
 
 static int ieee80211_get_key(struct wiphy *wiphy, struct net_device *dev,
-			     u8 key_idx, u8 *mac_addr, void *cookie,
+			     u8 key_idx, const u8 *mac_addr, void *cookie,
 			     void (*callback)(void *cookie,
 					      struct key_params *params))
 {


