Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755057Ab3CLKcP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 06:32:15 -0400
Date: Tue, 12 Mar 2013 11:32:44 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2 v2] mac80211: fixes for virtual monitor add/remove on
 suspend
Message-ID: <20130312103244.GC1383@redhat.com> (sfid-20130312_113219_006599_D3EE1341)
References: <1363021279-9809-1-git-send-email-sgruszka@redhat.com>
 <1363021279-9809-2-git-send-email-sgruszka@redhat.com>
 <20130311170712.GB1430@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130311170712.GB1430@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change suspend/resume and add/remove virtual monitor code (called at
ieee80211_do_stop) to avoid calling drv callback while we are suspended.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
v1->v2: on HW reset just assign chanctx to monitor sdata

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index c136050..7893913 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -373,28 +373,30 @@ static int ieee80211_add_virtual_monitor(struct ieee80211_local *local)
 
 	ieee80211_set_default_queues(sdata);
 
-	ret = drv_add_interface(local, sdata);
-	if (WARN_ON(ret)) {
-		/* ok .. stupid driver, it asked for this! */
-		kfree(sdata);
-		goto out_unlock;
-	}
+	if (!local->suspended) {
+		ret = drv_add_interface(local, sdata);
+		if (WARN_ON(ret)) {
+			/* ok .. stupid driver, it asked for this! */
+			goto out_free;
+		}
 
-	ret = ieee80211_check_queues(sdata);
-	if (ret) {
-		kfree(sdata);
-		goto out_unlock;
-	}
+			ret = ieee80211_check_queues(sdata);
+		if (ret)
+			goto out_remove;
 
-	ret = ieee80211_vif_use_channel(sdata, &local->monitor_chandef,
-					IEEE80211_CHANCTX_EXCLUSIVE);
-	if (ret) {
-		drv_remove_interface(local, sdata);
-		kfree(sdata);
-		goto out_unlock;
+		ret = ieee80211_vif_use_channel(sdata, &local->monitor_chandef,
+						IEEE80211_CHANCTX_EXCLUSIVE);
+		if (ret)
+			goto out_remove;
 	}
 
 	rcu_assign_pointer(local->monitor_sdata, sdata);
+	goto out_unlock;
+
+ out_remove:
+	drv_remove_interface(local, sdata);
+ out_free:
+	kfree(sdata);
  out_unlock:
 	mutex_unlock(&local->iflist_mtx);
 	return ret;
@@ -417,9 +419,10 @@ static void ieee80211_del_virtual_monitor(struct ieee80211_local *local)
 	rcu_assign_pointer(local->monitor_sdata, NULL);
 	synchronize_net();
 
-	ieee80211_vif_release_channel(sdata);
-
-	drv_remove_interface(local, sdata);
+	if (!local->suspended) {
+		ieee80211_vif_release_channel(sdata);
+		drv_remove_interface(local, sdata);
+	}
 
 	kfree(sdata);
  out_unlock:
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index b471a67..dbe42ea 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -100,8 +100,10 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 	}
 
 	sdata = rtnl_dereference(local->monitor_sdata);
-	if (sdata)
+	if (sdata) {
+		ieee80211_vif_release_channel(sdata);
 		drv_remove_interface(local, sdata);
+	}
 
 	/*
 	 * We disconnected on all interfaces before suspend, all channel
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index b7a856e..20e0d0e 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1470,8 +1470,21 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	}
 
 	sdata = rtnl_dereference(local->monitor_sdata);
-	if (sdata && ieee80211_sdata_running(sdata))
-		ieee80211_assign_chanctx(local, sdata);
+	if (sdata) {
+		if (local->suspended) {
+			res = ieee80211_vif_use_channel(sdata,
+						&local->monitor_chandef,
+						IEEE80211_CHANCTX_EXCLUSIVE);
+			if (WARN_ON(res)) {
+				drv_remove_interface(local, sdata);
+				rcu_assign_pointer(local->monitor_sdata, NULL);
+				synchronize_net();
+				kfree(sdata);
+			}
+		} else {
+			ieee80211_assign_chanctx(local, sdata);
+		}
+	}
 
 	/* add STAs back */
 	mutex_lock(&local->sta_mtx);
