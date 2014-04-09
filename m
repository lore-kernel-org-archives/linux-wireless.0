Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:41283 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933344AbaDINf5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 09:35:57 -0400
Received: by mail-ee0-f41.google.com with SMTP id t10so1921146eei.28
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 06:35:55 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, luca@coelho.fi,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v4 05/13] mac80211: track assigned vifs in chanctx
Date: Wed,  9 Apr 2014 15:29:26 +0200
Message-Id: <1397050174-26121-6-git-send-email-michal.kazior@tieto.com> (sfid-20140409_153623_514134_B727FB85)
In-Reply-To: <1397050174-26121-1-git-send-email-michal.kazior@tieto.com>
References: <1396262371-6466-1-git-send-email-michal.kazior@tieto.com>
 <1397050174-26121-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This can be useful. Provides a more straghtforward
way to iterate over interfaces bound to a given
chanctx and allows tracking chanctx usage
explicitly.

The structure is protected by local->chanctx_mtx.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
v3:
 * update commit message [Johannes]
 * add locking information [Johannes]

 net/mac80211/chan.c        | 4 ++++
 net/mac80211/ieee80211_i.h | 4 ++++
 net/mac80211/iface.c       | 1 +
 3 files changed, 9 insertions(+)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 4ed229c..504526c 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -276,6 +276,7 @@ ieee80211_new_chanctx(struct ieee80211_local *local,
 	if (!ctx)
 		return ERR_PTR(-ENOMEM);
 
+	INIT_LIST_HEAD(&ctx->assigned_vifs);
 	ctx->conf.def = *chandef;
 	ctx->conf.rx_chains_static = 1;
 	ctx->conf.rx_chains_dynamic = 1;
@@ -420,6 +421,7 @@ static int ieee80211_assign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 		curr_ctx->refcount--;
 		drv_unassign_vif_chanctx(local, sdata, curr_ctx);
 		conf = NULL;
+		list_del(&sdata->assigned_chanctx_list);
 	}
 
 	if (new_ctx) {
@@ -429,6 +431,8 @@ static int ieee80211_assign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 
 		new_ctx->refcount++;
 		conf = &new_ctx->conf;
+		list_add(&sdata->assigned_chanctx_list,
+			 &new_ctx->assigned_vifs);
 	}
 
 out:
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 0e85cad..57fed5e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -691,6 +691,8 @@ struct ieee80211_chanctx {
 	struct list_head list;
 	struct rcu_head rcu_head;
 
+	struct list_head assigned_vifs;
+
 	enum ieee80211_chanctx_mode mode;
 	int refcount;
 	bool driver_present;
@@ -757,6 +759,8 @@ struct ieee80211_sub_if_data {
 	bool csa_block_tx; /* write-protected by sdata_lock and local->mtx */
 	struct cfg80211_chan_def csa_chandef;
 
+	struct list_head assigned_chanctx_list; /* protected by chanctx_mtx */
+
 	/* context reservation -- protected with chanctx_mtx */
 	struct ieee80211_chanctx *reserved_chanctx;
 	struct cfg80211_chan_def reserved_chandef;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index d6230e2..1479e9f 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1298,6 +1298,7 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 	INIT_WORK(&sdata->work, ieee80211_iface_work);
 	INIT_WORK(&sdata->recalc_smps, ieee80211_recalc_smps_work);
 	INIT_WORK(&sdata->csa_finalize_work, ieee80211_csa_finalize_work);
+	INIT_LIST_HEAD(&sdata->assigned_chanctx_list);
 
 	switch (type) {
 	case NL80211_IFTYPE_P2P_GO:
-- 
1.8.5.3

