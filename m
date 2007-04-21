Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51749 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbXDUJSr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Apr 2007 05:18:47 -0400
Subject: [PATCH] mac80211: update for cfg80211 rtnl locking
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>
Content-Type: text/plain
Date: Sat, 21 Apr 2007 11:21:32 +0200
Message-Id: <1177147293.5941.2.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cfg80211 was changed to hold the rtnl lock over calls to stack specific
operations. This patch changes mac80211 to account for that.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/ieee80211_cfg.c |   27 ++++++---------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211_cfg.c	2007-04-21 11:15:09.063578277 +0200
+++ wireless-dev/net/mac80211/ieee80211_cfg.c	2007-04-21 11:19:34.483578277 +0200
@@ -12,18 +12,6 @@
 #include "ieee80211_i.h"
 #include "ieee80211_cfg.h"
 
-/* copied from ieee80211_sysfs.c for now ... */
-static inline int rtnl_lock_local(struct ieee80211_local *local)
-{
-	rtnl_lock();
-	if (unlikely(local->reg_state != IEEE80211_DEV_REGISTERED)) {
-		rtnl_unlock();
-		return -ENODEV;
-	}
-	return 0;
-}
-
-
 static int ieee80211_add_iface(struct wiphy *wiphy, char *name,
 			       unsigned int type)
 {
@@ -31,6 +19,9 @@ static int ieee80211_add_iface(struct wi
 	struct net_device *new_dev;
 	int res, itype;
 
+	if (unlikely(local->reg_state != IEEE80211_DEV_REGISTERED))
+		return -ENODEV;
+
 	switch (type) {
 	case NL80211_IFTYPE_UNSPECIFIED:
 		itype = IEEE80211_IF_TYPE_STA;
@@ -54,14 +45,9 @@ static int ieee80211_add_iface(struct wi
 		return -EINVAL;
 	}
 
-	res = rtnl_lock_local(local);
-	if (res)
-		return res;
-
 	res = ieee80211_if_add(local->mdev, name, 0, &new_dev);
 	if (res == 0)
 		ieee80211_if_set_type(new_dev, itype);
-	rtnl_unlock();
 	return res;
 }
 
@@ -72,15 +58,14 @@ static int ieee80211_del_iface(struct wi
 	struct net_device *dev;
 	char *name;
 
-	res = rtnl_lock_local(local);
-	if (res)
-		return res;
+	if (unlikely(local->reg_state != IEEE80211_DEV_REGISTERED))
+		return -ENODEV;
+
 	dev = dev_get_by_index(ifindex);
 	name = dev->name;
 	dev_put(dev);
 
 	res = ieee80211_if_remove(local->mdev, name, -1);
-	rtnl_unlock();
 	return res;
 }
 


