Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:50444 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756432Ab2FZMha (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 08:37:30 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Kazior Michal <Michal.Kazior@tieto.com>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC v3 7/7] mac80211: reuse channels for channel contexts
Date: Tue, 26 Jun 2012 14:37:22 +0200
Message-ID: <1340714242-20032-8-git-send-email-michal.kazior@tieto.com> (sfid-20120626_143736_111153_DC65E506)
In-Reply-To: <1340714242-20032-1-git-send-email-michal.kazior@tieto.com>
References: <1340714242-20032-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kazior Michal <Michal.Kazior@tieto.com>

Reuse channels with compatible channel types. Some
channel types are compatible and can be used
concurrently.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/chan.c |   56 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index fe1ea01..1a445da 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -167,6 +167,7 @@ ieee80211_find_chanctx(struct ieee80211_local *local,
 		       enum ieee80211_chanctx_mode mode)
 {
 	struct ieee80211_chanctx *ctx;
+	enum nl80211_channel_type compat_type;
 
 	lockdep_assert_held(&local->chanctx_mtx);
 
@@ -176,12 +177,22 @@ ieee80211_find_chanctx(struct ieee80211_local *local,
 		return NULL;
 
 	list_for_each_entry(ctx, &local->chanctx_list, list) {
+		compat_type = ctx->conf.channel_type;
+
 		if (ctx->mode == IEEE80211_CHANCTX_EXCLUSIVE)
 			continue;
 		if (ctx->conf.channel != channel)
 			continue;
 		if (ctx->conf.channel_type != channel_type)
 			continue;
+		if (!ieee80211_channel_types_are_compatible(ctx->conf.channel_type,
+							    channel_type,
+							    &compat_type))
+			continue;
+		if (ctx->conf.channel_type != compat_type) {
+			ctx->conf.channel_type = compat_type;
+			drv_change_chantype(local, ctx);
+		}
 
 		return ctx;
 	}
@@ -240,6 +251,49 @@ ieee80211_assign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 	drv_assign_vif_chanctx(sdata->local, sdata, ctx);
 }
 
+static enum nl80211_channel_type
+ieee80211_calc_chantype(struct ieee80211_local *local,
+			struct ieee80211_chanctx *ctx)
+{
+	struct ieee80211_chanctx_conf *conf = &ctx->conf;
+	struct ieee80211_sub_if_data *sdata;
+	enum nl80211_channel_type chantype = NL80211_CHAN_NO_HT;
+	enum nl80211_channel_type compat;
+
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		if (!ieee80211_sdata_running(sdata))
+			continue;
+		if (sdata->vif.chanctx_conf != conf)
+			continue;
+
+		BUG_ON(!ieee80211_channel_types_are_compatible(
+				conf->channel_type, chantype, &compat));
+
+		chantype = compat;
+	}
+	rcu_read_unlock();
+
+	return chantype;
+}
+
+static void
+ieee80211_recalc_chanctx_chantype(struct ieee80211_local *local,
+				  struct ieee80211_chanctx *ctx)
+{
+	enum nl80211_channel_type chantype;
+
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	chantype = ieee80211_calc_chantype(local, ctx);
+	if (chantype != ctx->conf.channel_type) {
+		ctx->conf.channel_type = chantype;
+		drv_change_chantype(local, ctx);
+	}
+}
+
 static void
 ieee80211_unassign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 			       struct ieee80211_chanctx *ctx)
@@ -248,6 +302,8 @@ ieee80211_unassign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 
 	drv_unassign_vif_chanctx(sdata->local, sdata, ctx);
 
+	ieee80211_recalc_chanctx_chantype(sdata->local, ctx);
+
 	ctx->refcount--;
 	sdata->vif.chanctx_conf = NULL;
 }
-- 
1.7.0.4

