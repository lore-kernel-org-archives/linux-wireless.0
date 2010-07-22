Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55832 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab0GVL6z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 07:58:55 -0400
Subject: [PATCH] mac80211: remove bogus rcu_read_lock()
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 13:58:51 +0200
Message-ID: <1279799931.12439.14.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Another remnant of the previous key locking scheme
needs to be removed -- this causes a warning
otherwise as ieee80211_set_default_mgmt_key will
acquire a mutex.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- wireless-testing.orig/net/mac80211/cfg.c	2010-07-22 12:24:38.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2010-07-22 13:56:19.000000000 +0200
@@ -324,15 +324,10 @@ static int ieee80211_config_default_mgmt
 					     struct net_device *dev,
 					     u8 key_idx)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	rcu_read_lock();
-
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	ieee80211_set_default_mgmt_key(sdata, key_idx);
 
-	rcu_read_unlock();
-
 	return 0;
 }
 


