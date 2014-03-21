Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:35170 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933833AbaCUNxj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 09:53:39 -0400
Received: by mail-ee0-f42.google.com with SMTP id d17so1857803eek.1
        for <linux-wireless@vger.kernel.org>; Fri, 21 Mar 2014 06:53:38 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 06/13] mac80211: track reserved vifs in chanctx
Date: Fri, 21 Mar 2014 14:47:24 +0100
Message-Id: <1395409651-26120-7-git-send-email-michal.kazior@tieto.com> (sfid-20140321_145350_735980_DF1AE5F3)
In-Reply-To: <1395409651-26120-1-git-send-email-michal.kazior@tieto.com>
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
 <1395409651-26120-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This can be useful.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/chan.c        | 14 ++++++++++----
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/iface.c       |  1 +
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 38d3010..99df19c 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -271,6 +271,7 @@ ieee80211_new_chanctx(struct ieee80211_local *local,
 		return ERR_PTR(-ENOMEM);
 
 	INIT_LIST_HEAD(&ctx->assigned_vifs);
+	INIT_LIST_HEAD(&ctx->reserved_vifs);
 	ctx->conf.def = *chandef;
 	ctx->conf.rx_chains_static = 1;
 	ctx->conf.rx_chains_dynamic = 1;
@@ -725,16 +726,19 @@ void ieee80211_vif_copy_chanctx_to_vlans(struct ieee80211_sub_if_data *sdata,
 
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
 
@@ -782,6 +786,7 @@ int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
+	list_add(&sdata->reserved_chanctx_list, &new_ctx->reserved_vifs);
 	new_ctx->refcount++;
 	sdata->reserved_chanctx = new_ctx;
 	sdata->reserved_chandef = *chandef;
@@ -831,6 +836,7 @@ int ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata,
 	ctx->refcount--;
 	sdata->reserved_chanctx = NULL;
 	sdata->radar_required = sdata->reserved_radar_required;
+	list_del(&sdata->reserved_chanctx_list);
 
 	if (old_ctx == ctx) {
 		/* This is our own context, just change it */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index cd776c1..6c5969b 100644
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
 
 	struct list_head assigned_chanctx_list;
+	struct list_head reserved_chanctx_list;
 
 	/* context reservation -- protected with chanctx_mtx */
 	struct ieee80211_chanctx *reserved_chanctx;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index b130be3..75a852d 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1297,6 +1297,7 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 	INIT_WORK(&sdata->recalc_smps, ieee80211_recalc_smps_work);
 	INIT_WORK(&sdata->csa_finalize_work, ieee80211_csa_finalize_work);
 	INIT_LIST_HEAD(&sdata->assigned_chanctx_list);
+	INIT_LIST_HEAD(&sdata->reserved_chanctx_list);
 
 	switch (type) {
 	case NL80211_IFTYPE_P2P_GO:
-- 
1.8.5.3

