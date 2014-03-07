Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:48986 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbaCGCUf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2014 21:20:35 -0500
Received: by mail-pd0-f169.google.com with SMTP id fp1so3378870pdb.14
        for <linux-wireless@vger.kernel.org>; Thu, 06 Mar 2014 18:20:34 -0800 (PST)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 2/4] mac80211: refactor recalculate channel context functions (2)
Date: Fri,  7 Mar 2014 10:17:28 +0800
Message-Id: <b55f154b70e9386ceaa5e8c71c722474c5241766.1394158459.git.gamerh2o@gmail.com> (sfid-20140307_032038_120318_223A0B47)
In-Reply-To: <8966cabb0cf4c83da8fd37e4a5ec1df8727e9dbe.1394158459.git.gamerh2o@gmail.com>
References: <8966cabb0cf4c83da8fd37e4a5ec1df8727e9dbe.1394158459.git.gamerh2o@gmail.com>
In-Reply-To: <8966cabb0cf4c83da8fd37e4a5ec1df8727e9dbe.1394158459.git.gamerh2o@gmail.com>
References: <8966cabb0cf4c83da8fd37e4a5ec1df8727e9dbe.1394158459.git.gamerh2o@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change function ieee80211_recalc_chanctx_chantype's position in the
file, if the change is included in next patch, the next patch's diff
will be a mess...

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 net/mac80211/chan.c | 66 ++++++++++++++++++++++++++---------------------------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 49fa37e..543beba 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -171,6 +171,39 @@ _ieee80211_recalc_chanctx_chantype(struct ieee80211_local *local,
 	ieee80211_recalc_chanctx_min_def(local, ctx);
 }
 
+static void ieee80211_recalc_chanctx_chantype(struct ieee80211_local *local,
+					      struct ieee80211_chanctx *ctx)
+{
+	struct ieee80211_chanctx_conf *conf = &ctx->conf;
+	struct ieee80211_sub_if_data *sdata;
+	const struct cfg80211_chan_def *compat = NULL;
+
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+
+		if (!ieee80211_sdata_running(sdata))
+			continue;
+		if (rcu_access_pointer(sdata->vif.chanctx_conf) != conf)
+			continue;
+
+		if (!compat)
+			compat = &sdata->vif.bss_conf.chandef;
+
+		compat = cfg80211_chandef_compatible(
+				&sdata->vif.bss_conf.chandef, compat);
+		if (!compat)
+			break;
+	}
+	rcu_read_unlock();
+
+	if (WARN_ON_ONCE(!compat))
+		return;
+
+	_ieee80211_recalc_chanctx_chantype(local, ctx, compat);
+}
+
 static struct ieee80211_chanctx *
 ieee80211_find_chanctx(struct ieee80211_local *local,
 		       const struct cfg80211_chan_def *chandef,
@@ -329,39 +362,6 @@ static int ieee80211_assign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-static void ieee80211_recalc_chanctx_chantype(struct ieee80211_local *local,
-					      struct ieee80211_chanctx *ctx)
-{
-	struct ieee80211_chanctx_conf *conf = &ctx->conf;
-	struct ieee80211_sub_if_data *sdata;
-	const struct cfg80211_chan_def *compat = NULL;
-
-	lockdep_assert_held(&local->chanctx_mtx);
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-
-		if (!ieee80211_sdata_running(sdata))
-			continue;
-		if (rcu_access_pointer(sdata->vif.chanctx_conf) != conf)
-			continue;
-
-		if (!compat)
-			compat = &sdata->vif.bss_conf.chandef;
-
-		compat = cfg80211_chandef_compatible(
-				&sdata->vif.bss_conf.chandef, compat);
-		if (!compat)
-			break;
-	}
-	rcu_read_unlock();
-
-	if (WARN_ON_ONCE(!compat))
-		return;
-
-	_ieee80211_recalc_chanctx_chantype(local, ctx, compat);
-}
-
 static void ieee80211_recalc_radar_chanctx(struct ieee80211_local *local,
 					   struct ieee80211_chanctx *chanctx)
 {
-- 
1.8.5.3

