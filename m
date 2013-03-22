Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51218 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423267Ab3CVVeS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Mar 2013 17:34:18 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Corey Richardson <corey@octayn.net>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.9] mac80211: fix idle handling sequence
Date: Fri, 22 Mar 2013 22:34:07 +0100
Message-Id: <1363988047-31613-1-git-send-email-johannes@sipsolutions.net> (sfid-20130322_223428_773605_75397AB1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Corey Richardson reported that my idle handling cleanup
(commit fd0f979a1b, "mac80211: simplify idle handling")
broke ath9k_htc. The reason appears to be that it wants
to go out of idle before switching channels. To fix it,
reimplement that sequence.

Reported-by: Corey Richardson <corey@octayn.net>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Sorry for the delay. Could you also test this patch? I'm pretty
certain it should still fix it, but if you can I'd like to know
for sure as I now coalesce IDLE + CHANNEL changes.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/chan.c        | 19 +++++++++++++++----
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/iface.c       |  2 +-
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 78c0d90..74acd81 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -63,6 +63,7 @@ ieee80211_new_chanctx(struct ieee80211_local *local,
 		      enum ieee80211_chanctx_mode mode)
 {
 	struct ieee80211_chanctx *ctx;
+	u32 changed;
 	int err;
 
 	lockdep_assert_held(&local->chanctx_mtx);
@@ -76,23 +77,33 @@ ieee80211_new_chanctx(struct ieee80211_local *local,
 	ctx->conf.rx_chains_dynamic = 1;
 	ctx->mode = mode;
 
+	/* acquire mutex to prevent idle from changing */
+	mutex_lock(&local->mtx);
+	/* turn idle off *before* setting channel -- some drivers need that */
+	changed = ieee80211_idle_off(local);
+
 	if (!local->use_chanctx) {
 		local->_oper_channel_type =
 			cfg80211_get_chandef_type(chandef);
 		local->_oper_channel = chandef->chan;
-		ieee80211_hw_config(local, 0);
+		ieee80211_hw_config(local, changed);
 	} else {
+		if (changed)
+			ieee80211_hw_config(local, changed);
 		err = drv_add_chanctx(local, ctx);
 		if (err) {
 			kfree(ctx);
-			return ERR_PTR(err);
+			ctx = ERR_PTR(err);
+
+			ieee80211_recalc_idle(local);
+			goto out;
 		}
 	}
 
+	/* and keep the mutex held until the new chanctx is on the list */
 	list_add_rcu(&ctx->list, &local->chanctx_list);
 
-	mutex_lock(&local->mtx);
-	ieee80211_recalc_idle(local);
+ out:
 	mutex_unlock(&local->mtx);
 
 	return ctx;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 388580a..3e2314e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1361,6 +1361,7 @@ int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
 			     enum nl80211_iftype type);
 void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata);
 void ieee80211_remove_interfaces(struct ieee80211_local *local);
+u32 ieee80211_idle_off(struct ieee80211_local *local);
 void ieee80211_recalc_idle(struct ieee80211_local *local);
 void ieee80211_adjust_monitor_flags(struct ieee80211_sub_if_data *sdata,
 				    const int offset);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 3bfe261..58150f8 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -78,7 +78,7 @@ void ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata)
 		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_TXPOWER);
 }
 
-static u32 ieee80211_idle_off(struct ieee80211_local *local)
+u32 ieee80211_idle_off(struct ieee80211_local *local)
 {
 	if (!(local->hw.conf.flags & IEEE80211_CONF_IDLE))
 		return 0;
-- 
1.8.0

