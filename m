Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42574 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933042Ab1CWPKQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2011 11:10:16 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.74)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Q2PhP-0002KT-K9
	for linux-wireless@vger.kernel.org; Wed, 23 Mar 2011 16:10:15 +0100
Subject: [RFC] mac80211: clean up station cleanup timer
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Mar 2011 16:10:15 +0100
Message-ID: <1300893015.3790.40.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We currently run this timer exactly once when
a new mac80211 device is registered, but that
is completely pointless since it will have no
work to do at all. Therefore, remove that and
also simplify some code using the timer.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/main.c     |    5 -----
 net/mac80211/sta_info.c |   13 ++-----------
 net/mac80211/sta_info.h |    1 -
 net/mac80211/util.c     |    2 +-
 4 files changed, 3 insertions(+), 18 deletions(-)

--- a/net/mac80211/main.c	2011-03-23 15:58:48.000000000 +0100
+++ b/net/mac80211/main.c	2011-03-23 15:59:03.000000000 +0100
@@ -879,10 +879,6 @@ int ieee80211_register_hw(struct ieee802
 
 	local->dynamic_ps_forced_timeout = -1;
 
-	result = sta_info_start(local);
-	if (result < 0)
-		goto fail_sta_info;
-
 	result = ieee80211_wep_init(local);
 	if (result < 0)
 		wiphy_debug(local->hw.wiphy, "Failed to initialize wep: %d\n",
@@ -945,7 +941,6 @@ int ieee80211_register_hw(struct ieee802
 	rtnl_unlock();
 	ieee80211_wep_free(local);
 	sta_info_stop(local);
- fail_sta_info:
 	destroy_workqueue(local->workqueue);
  fail_workqueue:
 	wiphy_unregister(local->hw.wiphy);
--- a/net/mac80211/sta_info.c	2011-03-23 15:57:54.000000000 +0100
+++ b/net/mac80211/sta_info.c	2011-03-23 16:01:18.000000000 +0100
@@ -765,9 +765,8 @@ static void sta_info_cleanup(unsigned lo
 	if (!timer_needed)
 		return;
 
-	local->sta_cleanup.expires =
-		round_jiffies(jiffies + STA_INFO_CLEANUP_INTERVAL);
-	add_timer(&local->sta_cleanup);
+	mod_timer(&local->sta_cleanup,
+		  round_jiffies(jiffies + STA_INFO_CLEANUP_INTERVAL));
 }
 
 void sta_info_init(struct ieee80211_local *local)
@@ -780,14 +779,6 @@ void sta_info_init(struct ieee80211_loca
 
 	setup_timer(&local->sta_cleanup, sta_info_cleanup,
 		    (unsigned long)local);
-	local->sta_cleanup.expires =
-		round_jiffies(jiffies + STA_INFO_CLEANUP_INTERVAL);
-}
-
-int sta_info_start(struct ieee80211_local *local)
-{
-	add_timer(&local->sta_cleanup);
-	return 0;
 }
 
 void sta_info_stop(struct ieee80211_local *local)
--- a/net/mac80211/sta_info.h	2011-03-23 15:58:48.000000000 +0100
+++ b/net/mac80211/sta_info.h	2011-03-23 15:58:53.000000000 +0100
@@ -497,7 +497,6 @@ void sta_info_set_tim_bit(struct sta_inf
 void sta_info_clear_tim_bit(struct sta_info *sta);
 
 void sta_info_init(struct ieee80211_local *local);
-int sta_info_start(struct ieee80211_local *local);
 void sta_info_stop(struct ieee80211_local *local);
 int sta_info_flush(struct ieee80211_local *local,
 		   struct ieee80211_sub_if_data *sdata);
--- a/net/mac80211/util.c	2011-03-23 15:59:31.000000000 +0100
+++ b/net/mac80211/util.c	2011-03-23 16:07:01.000000000 +0100
@@ -1290,7 +1290,7 @@ int ieee80211_reconfig(struct ieee80211_
 		}
 	}
 
-	add_timer(&local->sta_cleanup);
+	mod_timer(&local->sta_cleanup, jiffies + 1);
 
 	mutex_lock(&local->sta_mtx);
 	list_for_each_entry(sta, &local->sta_list, list)


