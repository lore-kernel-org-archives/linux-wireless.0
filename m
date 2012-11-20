Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39858 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab2KTJiF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 04:38:05 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: sujith@msujith.org, eliad@wizery.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2] mac80211: fix channel context suspend/reconfig handling
Date: Tue, 20 Nov 2012 10:38:29 +0100
Message-Id: <1353404309-17381-1-git-send-email-johannes@sipsolutions.net> (sfid-20121120_103813_110341_2183B17C)
In-Reply-To: <1353360586-32157-1-git-send-email-johannes@sipsolutions.net>
References: <1353360586-32157-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Sujith reported warnings with suspend/resume due to
channel contexts. When I looked into it, I realised
that the code was completely broken as it unassigned
the channel contexts when suspending, which actually
means they are destroyed.

Eliad Peller then pointed out that we also need to
remove the channel contexts from the driver. When I
looked into this, I also noticed that the code isn't
handling the virtual monitor interface correctly (if
it exists.)

Fix this by calling just the driver methods (if they
are implemented) instead of using the channel context
management code. Also add reconfiguration for the
virtual monitor interface.

Reported-by: Sujith Manoharan <sujith@msujith.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/pm.c   | 44 +++++++++++++++++++++++++++++++++++++++++---
 net/mac80211/util.c | 15 +++++++++++++++
 2 files changed, 56 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 0f1c434..79a48f3 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -33,6 +33,7 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
+	struct ieee80211_chanctx *ctx;
 
 	if (!local->open_count)
 		goto suspend;
@@ -139,14 +140,51 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 		    rcu_access_pointer(sdata->u.ap.beacon))
 			drv_stop_ap(local, sdata);
 
-		/* the interface is leaving the channel and is removed */
-		ieee80211_vif_release_channel(sdata);
+		if (local->use_chanctx) {
+			struct ieee80211_chanctx_conf *conf;
+
+			mutex_lock(&local->chanctx_mtx);
+			conf = rcu_dereference_protected(
+					sdata->vif.chanctx_conf,
+					lockdep_is_held(&local->chanctx_mtx));
+			if (conf) {
+				ctx = container_of(conf,
+						   struct ieee80211_chanctx,
+						   conf);
+				drv_unassign_vif_chanctx(local, sdata, ctx);
+			}
+
+			mutex_unlock(&local->chanctx_mtx);
+		}
 		drv_remove_interface(local, sdata);
 	}
 
 	sdata = rtnl_dereference(local->monitor_sdata);
-	if (sdata)
+	if (sdata) {
+		if (local->use_chanctx) {
+			struct ieee80211_chanctx_conf *conf;
+
+			mutex_lock(&local->chanctx_mtx);
+			conf = rcu_dereference_protected(
+					sdata->vif.chanctx_conf,
+					lockdep_is_held(&local->chanctx_mtx));
+			if (conf) {
+				ctx = container_of(conf,
+						   struct ieee80211_chanctx,
+						   conf);
+				drv_unassign_vif_chanctx(local, sdata, ctx);
+			}
+
+			mutex_unlock(&local->chanctx_mtx);
+		}
+
 		drv_remove_interface(local, sdata);
+	}
+
+	mutex_lock(&local->chanctx_mtx);
+	list_for_each_entry(ctx, &local->chanctx_list, list)
+		drv_remove_chanctx(local, ctx);
+	mutex_unlock(&local->chanctx_mtx);
 
 	/* stop hardware - this must stop RX */
 	if (local->open_count)
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 7fb55bf..2f08a7e 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1441,6 +1441,21 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		mutex_unlock(&local->chanctx_mtx);
 	}
 
+	sdata = rtnl_dereference(local->monitor_sdata);
+	if (sdata && local->use_chanctx && ieee80211_sdata_running(sdata)) {
+		struct ieee80211_chanctx_conf *ctx_conf;
+
+		mutex_lock(&local->chanctx_mtx);
+		ctx_conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
+				lockdep_is_held(&local->chanctx_mtx));
+		if (ctx_conf) {
+			ctx = container_of(ctx_conf, struct ieee80211_chanctx,
+					   conf);
+			drv_assign_vif_chanctx(local, sdata, ctx);
+		}
+		mutex_unlock(&local->chanctx_mtx);
+	}
+
 	/* add STAs back */
 	mutex_lock(&local->sta_mtx);
 	list_for_each_entry(sta, &local->sta_list, list) {
-- 
1.8.0

