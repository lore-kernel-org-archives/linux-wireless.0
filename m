Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:61272 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932748AbaDINf6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 09:35:58 -0400
Received: by mail-ee0-f45.google.com with SMTP id d17so1885104eek.18
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 06:35:57 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, luca@coelho.fi,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v4 06/13] mac80211: track reserved vifs in chanctx
Date: Wed,  9 Apr 2014 15:29:27 +0200
Message-Id: <1397050174-26121-7-git-send-email-michal.kazior@tieto.com> (sfid-20140409_153603_684615_59EB8616)
In-Reply-To: <1397050174-26121-1-git-send-email-michal.kazior@tieto.com>
References: <1396262371-6466-1-git-send-email-michal.kazior@tieto.com>
 <1397050174-26121-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This can be useful. Provides a more straghtforward
way to iterate over interfaces taking part in
chanctx reservation and allows tracking chanctx
usage explicitly.

The structure is protected by local->chanctx_mtx.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
v3:
 * update commit message [Johannes]
 * add locking information [Johannes]

 net/mac80211/chan.c        | 14 ++++++++++----
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/iface.c       |  1 +
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 504526c..79eac96 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -277,6 +277,7 @@ ieee80211_new_chanctx(struct ieee80211_local *local,
 		return ERR_PTR(-ENOMEM);
 
 	INIT_LIST_HEAD(&ctx->assigned_vifs);
+	INIT_LIST_HEAD(&ctx->reserved_vifs);
 	ctx->conf.def = *chandef;
 	ctx->conf.rx_chains_static = 1;
 	ctx->conf.rx_chains_dynamic = 1;
@@ -731,16 +732,19 @@ void ieee80211_vif_copy_chanctx_to_vlans(struct ieee80211_sub_if_data *sdata,
 
 int ieee80211_vif_unreserve_chanctx(struct ieee80211_sub_if_data *sdata)
 {
+	struct ieee80211_chanctx *ctx = sdata->reserved_chanctx;
+
 	lockdep_assert_held(&sdata->local->chanctx_mtx);
 
-	if (WARN_ON(!sdata->reserved_chanctx))
+	if (WARN_ON(!ctx))
 		return -EINVAL;
 
-	if (--sdata->reserved_chanctx->refcount == 0)
-		ieee80211_free_chanctx(sdata->local, sdata->reserved_chanctx);
-
+	list_del(&sdata->reserved_chanctx_list);
 	sdata->reserved_chanctx = NULL;
 
+	if (--ctx->refcount == 0)
+		ieee80211_free_chanctx(sdata->local, ctx);
+
 	return 0;
 }
 
@@ -788,6 +792,7 @@ int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
+	list_add(&sdata->reserved_chanctx_list, &new_ctx->reserved_vifs);
 	new_ctx->refcount++;
 	sdata->reserved_chanctx = new_ctx;
 	sdata->reserved_chandef = *chandef;
@@ -837,6 +842,7 @@ int ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata,
 	ctx->refcount--;
 	sdata->reserved_chanctx = NULL;
 	sdata->radar_required = sdata->reserved_radar_required;
+	list_del(&sdata->reserved_chanctx_list);
 
 	if (old_ctx == ctx) {
 		/* This is our own context, just change it */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 57fed5e..7a60142 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -692,6 +692,7 @@ struct ieee80211_chanctx {
 	struct rcu_head rcu_head;
 
 	struct list_head assigned_vifs;
+	struct list_head reserved_vifs;
 
 	enum ieee80211_chanctx_mode mode;
 	int refcount;
@@ -760,6 +761,7 @@ struct ieee80211_sub_if_data {
 	struct cfg80211_chan_def csa_chandef;
 
 	struct list_head assigned_chanctx_list; /* protected by chanctx_mtx */
+	struct list_head reserved_chanctx_list; /* protected by chanctx_mtx */
 
 	/* context reservation -- protected with chanctx_mtx */
 	struct ieee80211_chanctx *reserved_chanctx;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 1479e9f..13ff2a9 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1299,6 +1299,7 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 	INIT_WORK(&sdata->recalc_smps, ieee80211_recalc_smps_work);
 	INIT_WORK(&sdata->csa_finalize_work, ieee80211_csa_finalize_work);
 	INIT_LIST_HEAD(&sdata->assigned_chanctx_list);
+	INIT_LIST_HEAD(&sdata->reserved_chanctx_list);
 
 	switch (type) {
 	case NL80211_IFTYPE_P2P_GO:
-- 
1.8.5.3

