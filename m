Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:53771 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbaCGLZ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 06:25:27 -0500
Received: by mail-ee0-f47.google.com with SMTP id b15so1658610eek.6
        for <linux-wireless@vger.kernel.org>; Fri, 07 Mar 2014 03:25:25 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/3] mac80211: compute chanctx refcount dynamically
Date: Fri,  7 Mar 2014 12:19:56 +0100
Message-Id: <1394191196-6425-3-git-send-email-michal.kazior@tieto.com> (sfid-20140307_122532_789476_71C0C158)
In-Reply-To: <1394191196-6425-1-git-send-email-michal.kazior@tieto.com>
References: <1394191196-6425-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It doesn't make much sense to have a manually
managed chanctx refcount. It isn't performance
critical and it can't be even used outside the
protection of chanctx_mtx.

With future enhancements to channel contenxt
(namely reservations) refcount accounting will
become more complex and having manually managed
refcount is going to be error-prone and confusing.

The refcount is now equal to the number of vifs it
is assigned to. However in the future this will
change so keep the refcount/num_assigned_vifs
functions split now.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/cfg.c         |  2 +-
 net/mac80211/chan.c        | 62 +++++++++++++++++++++++++++++++++++++---------
 net/mac80211/ieee80211_i.h |  5 +++-
 net/mac80211/mlme.c        |  2 +-
 4 files changed, 56 insertions(+), 15 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a79875c..b5c9a77 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3242,7 +3242,7 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 
 	/* don't handle for multi-VIF cases */
 	chanctx = container_of(chanctx_conf, struct ieee80211_chanctx, conf);
-	if (chanctx->refcount > 1) {
+	if (ieee80211_chanctx_refcount(chanctx) > 1) {
 		mutex_unlock(&local->chanctx_mtx);
 		return -EBUSY;
 	}
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 5b946e8..a320dfd 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -9,6 +9,45 @@
 #include "ieee80211_i.h"
 #include "driver-ops.h"
 
+struct ieee80211_chanctx *
+ieee80211_vif_assigned_chanctx(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_chanctx_conf *conf;
+
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
+					 lockdep_is_held(&local->chanctx_mtx));
+	if (!conf)
+		return NULL;
+
+	return container_of(conf, struct ieee80211_chanctx, conf);
+}
+
+int ieee80211_chanctx_num_assigned_vifs(struct ieee80211_chanctx *ctx)
+{
+	struct ieee80211_local *local = ctx->local;
+	struct ieee80211_sub_if_data *sdata;
+	int num = 0;
+
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sdata, &local->interfaces, list)
+		if (ieee80211_vif_assigned_chanctx(sdata) == ctx)
+			num++;
+	rcu_read_unlock();
+
+	return num;
+}
+
+int ieee80211_chanctx_refcount(struct ieee80211_chanctx *ctx)
+{
+	lockdep_assert_held(&ctx->local->chanctx_mtx);
+	return ieee80211_chanctx_num_assigned_vifs(ctx);
+}
+
 static enum nl80211_chan_width ieee80211_get_sta_bw(struct ieee80211_sta *sta)
 {
 	switch (sta->bandwidth) {
@@ -266,7 +305,7 @@ static void ieee80211_free_chanctx(struct ieee80211_local *local,
 	bool check_single_channel = false;
 	lockdep_assert_held(&local->chanctx_mtx);
 
-	WARN_ON_ONCE(ctx->refcount != 0);
+	WARN_ON_ONCE(ieee80211_chanctx_refcount(ctx) != 0);
 
 	if (!local->use_chanctx) {
 		struct cfg80211_chan_def *chandef = &local->_oper_chandef;
@@ -308,7 +347,6 @@ static int ieee80211_assign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 		return ret;
 
 	rcu_assign_pointer(sdata->vif.chanctx_conf, &ctx->conf);
-	ctx->refcount++;
 
 	ieee80211_recalc_txpower(sdata);
 	ieee80211_recalc_chanctx_min_def(local, ctx);
@@ -386,7 +424,6 @@ static void ieee80211_unassign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 
 	lockdep_assert_held(&local->chanctx_mtx);
 
-	ctx->refcount--;
 	rcu_assign_pointer(sdata->vif.chanctx_conf, NULL);
 
 	sdata->vif.bss_conf.idle = true;
@@ -397,12 +434,13 @@ static void ieee80211_unassign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 
 	drv_unassign_vif_chanctx(local, sdata, ctx);
 
-	if (ctx->refcount > 0) {
-		ieee80211_recalc_chanctx_chantype(sdata->local, ctx);
-		ieee80211_recalc_smps_chanctx(local, ctx);
-		ieee80211_recalc_radar_chanctx(local, ctx);
-		ieee80211_recalc_chanctx_min_def(local, ctx);
-	}
+	if (ieee80211_chanctx_num_assigned_vifs(ctx) == 0)
+		return;
+
+	ieee80211_recalc_chanctx_chantype(sdata->local, ctx);
+	ieee80211_recalc_smps_chanctx(local, ctx);
+	ieee80211_recalc_radar_chanctx(local, ctx);
+	ieee80211_recalc_chanctx_min_def(local, ctx);
 }
 
 static void __ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
@@ -421,7 +459,7 @@ static void __ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
 	ctx = container_of(conf, struct ieee80211_chanctx, conf);
 
 	ieee80211_unassign_vif_chanctx(sdata, ctx);
-	if (ctx->refcount == 0)
+	if (ieee80211_chanctx_refcount(ctx) == 0)
 		ieee80211_free_chanctx(local, ctx);
 }
 
@@ -536,7 +574,7 @@ int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 	ret = ieee80211_assign_vif_chanctx(sdata, ctx);
 	if (ret) {
 		/* if assign fails refcount stays the same */
-		if (ctx->refcount == 0)
+		if (ieee80211_chanctx_refcount(ctx) == 0)
 			ieee80211_free_chanctx(local, ctx);
 		goto out;
 	}
@@ -577,7 +615,7 @@ int ieee80211_vif_change_channel(struct ieee80211_sub_if_data *sdata,
 	}
 
 	ctx = container_of(conf, struct ieee80211_chanctx, conf);
-	if (ctx->refcount != 1) {
+	if (ieee80211_chanctx_refcount(ctx) != 1) {
 		ret = -EINVAL;
 		goto out;
 	}
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c21b0c3..11d70b5 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -693,7 +693,6 @@ struct ieee80211_chanctx {
 
 	struct ieee80211_local *local;
 	enum ieee80211_chanctx_mode mode;
-	int refcount;
 	bool driver_present;
 
 	struct ieee80211_chanctx_conf conf;
@@ -1788,6 +1787,10 @@ void ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata);
 void ieee80211_vif_vlan_copy_chanctx(struct ieee80211_sub_if_data *sdata);
 void ieee80211_vif_copy_chanctx_to_vlans(struct ieee80211_sub_if_data *sdata,
 					 bool clear);
+struct ieee80211_chanctx *
+ieee80211_vif_assigned_chanctx(struct ieee80211_sub_if_data *sdata);
+int ieee80211_chanctx_num_assigned_vifs(struct ieee80211_chanctx *ctx);
+int ieee80211_chanctx_refcount(struct ieee80211_chanctx *ctx);
 
 void ieee80211_recalc_smps_chanctx(struct ieee80211_local *local,
 				   struct ieee80211_chanctx *chanctx);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 46b62bb..c0b2fb0 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1066,7 +1066,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	}
 	chanctx = container_of(rcu_access_pointer(sdata->vif.chanctx_conf),
 			       struct ieee80211_chanctx, conf);
-	if (chanctx->refcount > 1) {
+	if (ieee80211_chanctx_refcount(chanctx) > 1) {
 		sdata_info(sdata,
 			   "channel switch with multiple interfaces on the same channel, disconnecting\n");
 		ieee80211_queue_work(&local->hw,
-- 
1.8.5.3

