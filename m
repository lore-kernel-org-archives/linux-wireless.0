Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:57957 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302AbaCRN7M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 09:59:12 -0400
Received: by mail-ee0-f50.google.com with SMTP id c13so5498955eek.9
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 06:59:11 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 05/21] mac80211: track assigned vifs in chanctx
Date: Tue, 18 Mar 2014 14:53:08 +0100
Message-Id: <1395150804-24090-6-git-send-email-michal.kazior@tieto.com> (sfid-20140318_150215_565236_EA347FFE)
In-Reply-To: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This can be useful.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/chan.c        | 4 ++++
 net/mac80211/ieee80211_i.h | 4 ++++
 net/mac80211/iface.c       | 1 +
 3 files changed, 9 insertions(+)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index c1284f2..aca70a6 100644
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
index d4b3fe4..6e3d137 100644
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
@@ -756,6 +758,8 @@ struct ieee80211_sub_if_data {
 	bool csa_radar_required;
 	struct cfg80211_chan_def csa_chandef;
 
+	struct list_head assigned_chanctx_list;
+
 	/* context reservation -- protected with chanctx_mtx */
 	struct ieee80211_chanctx *reserved_chanctx;
 	struct cfg80211_chan_def reserved_chandef;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 384f663..3b5b6d3 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1291,6 +1291,7 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 	INIT_WORK(&sdata->work, ieee80211_iface_work);
 	INIT_WORK(&sdata->recalc_smps, ieee80211_recalc_smps_work);
 	INIT_WORK(&sdata->csa_finalize_work, ieee80211_csa_finalize_work);
+	INIT_LIST_HEAD(&sdata->assigned_chanctx_list);
 
 	switch (type) {
 	case NL80211_IFTYPE_P2P_GO:
-- 
1.8.5.3

