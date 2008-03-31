Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45251 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083AbYDALtB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 07:49:01 -0400
Message-Id: <20080331172435.414575000@sipsolutions.net> (sfid-20080401_124933_217926_CE2C85DF)
References: <20080331172258.541914000@sipsolutions.net>
Date: Mon, 31 Mar 2008 19:23:02 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/6] mac80211: clean up sta_info_destroy() users wrt.
	RCU/locking
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Calling sta_info_destroy() doesn't require RCU-synchronisation
before-hand because it does that internally. However, it does
require rtnl-locking so insert that where necessary.

Also clean up the code doing it internally to be a bit clearer and
not synchronize twice if keys are configured.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/cfg.c           |    6 +-----
 net/mac80211/ieee80211_sta.c |    1 -
 net/mac80211/sta_info.c      |   33 +++++++++++++++++++--------------
 3 files changed, 20 insertions(+), 20 deletions(-)

--- everything.orig/net/mac80211/cfg.c	2008-03-31 18:22:24.000000000 +0200
+++ everything/net/mac80211/cfg.c	2008-03-31 18:22:25.000000000 +0200
@@ -700,11 +700,7 @@ static int ieee80211_del_station(struct 
 			return -ENOENT;
 
 		sta_info_unlink(&sta);
-
-		if (sta) {
-			synchronize_rcu();
-			sta_info_destroy(sta);
-		}
+		sta_info_destroy(sta);
 	} else
 		sta_info_flush(local, sdata);
 
--- everything.orig/net/mac80211/sta_info.c	2008-03-31 18:22:24.000000000 +0200
+++ everything/net/mac80211/sta_info.c	2008-03-31 18:22:25.000000000 +0200
@@ -180,13 +180,22 @@ void sta_info_destroy(struct sta_info *s
 		mesh_plink_deactivate(sta);
 #endif
 
-	/*
-	 * NOTE: This will call synchronize_rcu() internally to
-	 * make sure no key references can be in use. We rely on
-	 * that here for the mesh code!
-	 */
-	ieee80211_key_free(sta->key);
-	WARN_ON(sta->key);
+	if (sta->key) {
+		/*
+		 * NOTE: This will call synchronize_rcu() internally to
+		 * make sure no key references can be in use. We rely on
+		 * that when we take this branch to make sure nobody can
+		 * reference this STA struct any longer!
+		 */
+		ieee80211_key_free(sta->key);
+		WARN_ON(sta->key);
+	} else {
+		/*
+		 * Make sure that nobody can reference this STA struct
+		 * any longer.
+		 */
+		synchronize_rcu();
+	}
 
 #ifdef CONFIG_MAC80211_MESH
 	if (ieee80211_vif_is_mesh(&sta->sdata->vif))
@@ -627,11 +636,9 @@ static void sta_info_debugfs_add_work(st
 		rate_control_add_sta_debugfs(sta);
 
 		sta = __sta_info_unpin(sta);
-
-		if (sta) {
-			synchronize_rcu();
-			sta_info_destroy(sta);
-		}
+		rtnl_lock();
+		sta_info_destroy(sta);
+		rtnl_unlock();
 	}
 }
 #endif
@@ -693,8 +700,6 @@ int sta_info_flush(struct ieee80211_loca
 	}
 	spin_unlock_irqrestore(&local->sta_lock, flags);
 
-	synchronize_rcu();
-
 	list_for_each_entry_safe(sta, tmp, &tmp_list, list)
 		sta_info_destroy(sta);
 
--- everything.orig/net/mac80211/ieee80211_sta.c	2008-03-31 18:22:24.000000000 +0200
+++ everything/net/mac80211/ieee80211_sta.c	2008-03-31 18:22:25.000000000 +0200
@@ -939,7 +939,6 @@ static void ieee80211_associated(struct 
 	rcu_read_unlock();
 
 	if (disassoc && sta) {
-		synchronize_rcu();
 		rtnl_lock();
 		sta_info_destroy(sta);
 		rtnl_unlock();

-- 

