Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:55824 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935919Ab3DHUna (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 16:43:30 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: zefir.kurtisi@neratec.com, mathias.kretschmer@fokus.fraunhofer.de,
	ordex@autistici.org, Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv4] mac80211: fix recalc_radar hwconf sync problem
Date: Mon,  8 Apr 2013 22:43:16 +0200
Message-Id: <1365453796-17572-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130408_224347_713775_388BD8E8)
In-Reply-To: <20130408175352.GC5938@ritirata.org>
References: <20130408175352.GC5938@ritirata.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

local->hw.conf maybe not be synced when recalcing whether radar is
enabled, sometimes leaving radar enabled even if it's not neccesary
anymore.

Fix this by:
 * setting radar_enabled when creating the chanctx
 * turning radar_enabled off before destroying the last channel context

Reported-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
Changes to PATCHv3:
 * fix typo
 * move whole check into WARN_ON

Changes to PATCHv2:
 * add comment about single context, and check for it
 * rebase on mac80211-next
---
 net/mac80211/chan.c |   43 +++++++++++++++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 8024874..166165e 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -57,6 +57,22 @@ ieee80211_find_chanctx(struct ieee80211_local *local,
 	return NULL;
 }
 
+static bool ieee80211_is_radar_required(struct ieee80211_local *local)
+{
+	struct ieee80211_sub_if_data *sdata;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		if (sdata->radar_required) {
+			rcu_read_unlock();
+			return true;
+		}
+	}
+	rcu_read_unlock();
+
+	return false;
+}
+
 static struct ieee80211_chanctx *
 ieee80211_new_chanctx(struct ieee80211_local *local,
 		      const struct cfg80211_chan_def *chandef,
@@ -75,6 +91,9 @@ ieee80211_new_chanctx(struct ieee80211_local *local,
 	ctx->conf.rx_chains_static = 1;
 	ctx->conf.rx_chains_dynamic = 1;
 	ctx->mode = mode;
+	ctx->conf.radar_enabled = ieee80211_is_radar_required(local);
+	if (!local->use_chanctx)
+		local->hw.conf.radar_enabled = ctx->conf.radar_enabled;
 
 	if (!local->use_chanctx) {
 		local->_oper_chandef = *chandef;
@@ -99,6 +118,7 @@ ieee80211_new_chanctx(struct ieee80211_local *local,
 static void ieee80211_free_chanctx(struct ieee80211_local *local,
 				   struct ieee80211_chanctx *ctx)
 {
+	bool check_single_channel = false;
 	lockdep_assert_held(&local->chanctx_mtx);
 
 	WARN_ON_ONCE(ctx->refcount != 0);
@@ -108,6 +128,14 @@ static void ieee80211_free_chanctx(struct ieee80211_local *local,
 		chandef->width = NL80211_CHAN_WIDTH_20_NOHT;
 		chandef->center_freq1 = chandef->chan->center_freq;
 		chandef->center_freq2 = 0;
+
+		/* NOTE: Disabling radar is only valid here for
+		 * single channel context. To be sure, check it ...
+		 */
+		if (local->hw.conf.radar_enabled)
+			check_single_channel = true;
+		local->hw.conf.radar_enabled = false;
+
 		ieee80211_hw_config(local, 0);
 	} else {
 		drv_remove_chanctx(local, ctx);
@@ -116,6 +144,9 @@ static void ieee80211_free_chanctx(struct ieee80211_local *local,
 	list_del_rcu(&ctx->list);
 	kfree_rcu(ctx, rcu_head);
 
+	/* throw a warning if this wasn't the only channel context. */
+	WARN_ON(check_single_channel && !list_empty(&local->chanctx_list));
+
 	mutex_lock(&local->mtx);
 	ieee80211_recalc_idle(local);
 	mutex_unlock(&local->mtx);
@@ -227,19 +258,11 @@ static void __ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
 void ieee80211_recalc_radar_chanctx(struct ieee80211_local *local,
 				    struct ieee80211_chanctx *chanctx)
 {
-	struct ieee80211_sub_if_data *sdata;
-	bool radar_enabled = false;
+	bool radar_enabled;
 
 	lockdep_assert_held(&local->chanctx_mtx);
 
-	rcu_read_lock();
-	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-		if (sdata->radar_required) {
-			radar_enabled = true;
-			break;
-		}
-	}
-	rcu_read_unlock();
+	radar_enabled = ieee80211_is_radar_required(local);
 
 	if (radar_enabled == chanctx->conf.radar_enabled)
 		return;
-- 
1.7.10.4

