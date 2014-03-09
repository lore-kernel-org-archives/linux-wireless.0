Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:27293 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbaCIOkq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2014 10:40:46 -0400
From: Luciano Coelho <luciano.coelho@intel.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, michal.kazior@tieto.com,
	sw@simonwunderlich.de, andrei.otcheretianski@intel.com
Subject: [PATCH v6 1/3] mac80211: split ieee80211_vif_change_channel in two
Date: Sun,  9 Mar 2014 16:40:37 +0200
Message-Id: <1394376039-9644-2-git-send-email-luciano.coelho@intel.com> (sfid-20140309_154049_481047_D0FEE96D)
In-Reply-To: <1394376039-9644-1-git-send-email-luciano.coelho@intel.com>
References: <1394376039-9644-1-git-send-email-luciano.coelho@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_vif_change_channel() locks chanctx_mtx.  When implementing
channel reservation for CS, we will need to call the function to
change channel when the lock is already held, so split the part that
requires the lock out and leave the locking in the original function.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/mac80211/chan.c | 58 ++++++++++++++++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 25 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 42c6592..a27c6ec 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -547,39 +547,20 @@ int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 	return ret;
 }
 
-int ieee80211_vif_change_channel(struct ieee80211_sub_if_data *sdata,
-				 u32 *changed)
+static int __ieee80211_vif_change_channel(struct ieee80211_sub_if_data *sdata,
+					  struct ieee80211_chanctx *ctx,
+					  u32 *changed)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_chanctx_conf *conf;
-	struct ieee80211_chanctx *ctx;
 	const struct cfg80211_chan_def *chandef = &sdata->csa_chandef;
-	int ret;
 	u32 chanctx_changed = 0;
 
-	lockdep_assert_held(&local->mtx);
-
-	/* should never be called if not performing a channel switch. */
-	if (WARN_ON(!sdata->vif.csa_active))
-		return -EINVAL;
-
 	if (!cfg80211_chandef_usable(sdata->local->hw.wiphy, chandef,
 				     IEEE80211_CHAN_DISABLED))
 		return -EINVAL;
 
-	mutex_lock(&local->chanctx_mtx);
-	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
-					 lockdep_is_held(&local->chanctx_mtx));
-	if (!conf) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	ctx = container_of(conf, struct ieee80211_chanctx, conf);
-	if (ctx->refcount != 1) {
-		ret = -EINVAL;
-		goto out;
-	}
+	if (ctx->refcount != 1)
+		return -EINVAL;
 
 	if (sdata->vif.bss_conf.chandef.width != chandef->width) {
 		chanctx_changed = IEEE80211_CHANCTX_CHANGE_WIDTH;
@@ -597,7 +578,34 @@ int ieee80211_vif_change_channel(struct ieee80211_sub_if_data *sdata,
 	ieee80211_recalc_radar_chanctx(local, ctx);
 	ieee80211_recalc_chanctx_min_def(local, ctx);
 
-	ret = 0;
+	return 0;
+}
+
+int ieee80211_vif_change_channel(struct ieee80211_sub_if_data *sdata,
+				 u32 *changed)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_chanctx_conf *conf;
+	struct ieee80211_chanctx *ctx;
+	int ret;
+
+	lockdep_assert_held(&local->mtx);
+
+	/* should never be called if not performing a channel switch. */
+	if (WARN_ON(!sdata->vif.csa_active))
+		return -EINVAL;
+
+	mutex_lock(&local->chanctx_mtx);
+	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
+					 lockdep_is_held(&local->chanctx_mtx));
+	if (!conf) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ctx = container_of(conf, struct ieee80211_chanctx, conf);
+
+	ret = __ieee80211_vif_change_channel(sdata, ctx, changed);
  out:
 	mutex_unlock(&local->chanctx_mtx);
 	return ret;
-- 
1.9.0

