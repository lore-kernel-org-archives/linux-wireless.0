Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:33885 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299AbaCRN7e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 09:59:34 -0400
Received: by mail-ee0-f52.google.com with SMTP id e49so5288266eek.25
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 06:59:32 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 20/21] mac80211: remove old unused channel switching code
Date: Tue, 18 Mar 2014 14:53:23 +0100
Message-Id: <1395150804-24090-21-git-send-email-michal.kazior@tieto.com> (sfid-20140318_145941_694091_4A954214)
In-Reply-To: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_vif_change_channel() has no uses
anymore. sdata->csa_radar_required is also removed
because it is no longer used. Instead reservations
take care of tracking whether an interface
requires radar detection or not.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/cfg.c         |  1 -
 net/mac80211/chan.c        | 64 ----------------------------------------------
 net/mac80211/ieee80211_i.h |  5 ----
 3 files changed, 70 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 3979f2f..de48653 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3350,7 +3350,6 @@ int __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 		return err;
 	}
 
-	sdata->csa_radar_required = params->radar_required;
 	sdata->csa_chandef = params->chandef;
 	sdata->csa_block_tx = params->block_tx;
 	sdata->vif.csa_active = true;
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 6f621ba..2a54dc4 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -800,70 +800,6 @@ int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 	return ret;
 }
 
-static int __ieee80211_vif_change_channel(struct ieee80211_sub_if_data *sdata,
-					  struct ieee80211_chanctx *ctx,
-					  u32 *changed)
-{
-	struct ieee80211_local *local = sdata->local;
-	const struct cfg80211_chan_def *chandef = &sdata->csa_chandef;
-	u32 chanctx_changed = 0;
-
-	if (!cfg80211_chandef_usable(sdata->local->hw.wiphy, chandef,
-				     IEEE80211_CHAN_DISABLED))
-		return -EINVAL;
-
-	if (ieee80211_chanctx_refcount(local, ctx) != 1)
-		return -EINVAL;
-
-	if (sdata->vif.bss_conf.chandef.width != chandef->width) {
-		chanctx_changed = IEEE80211_CHANCTX_CHANGE_WIDTH;
-		*changed |= BSS_CHANGED_BANDWIDTH;
-	}
-
-	sdata->vif.bss_conf.chandef = *chandef;
-	ctx->conf.def = *chandef;
-
-	chanctx_changed |= IEEE80211_CHANCTX_CHANGE_CHANNEL;
-	drv_change_chanctx(local, ctx, chanctx_changed);
-
-	ieee80211_recalc_chanctx_chantype(local, ctx);
-	ieee80211_recalc_smps_chanctx(local, ctx);
-	ieee80211_recalc_radar_chanctx(local, ctx);
-	ieee80211_recalc_chanctx_min_def(local, ctx);
-
-	return 0;
-}
-
-int ieee80211_vif_change_channel(struct ieee80211_sub_if_data *sdata,
-				 u32 *changed)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_chanctx_conf *conf;
-	struct ieee80211_chanctx *ctx;
-	int ret;
-
-	lockdep_assert_held(&local->mtx);
-
-	/* should never be called if not performing a channel switch. */
-	if (WARN_ON(!sdata->vif.csa_active))
-		return -EINVAL;
-
-	mutex_lock(&local->chanctx_mtx);
-	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
-					 lockdep_is_held(&local->chanctx_mtx));
-	if (!conf) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	ctx = container_of(conf, struct ieee80211_chanctx, conf);
-
-	ret = __ieee80211_vif_change_channel(sdata, ctx, changed);
- out:
-	mutex_unlock(&local->chanctx_mtx);
-	return ret;
-}
-
 static void
 __ieee80211_vif_copy_chanctx_to_vlans(struct ieee80211_sub_if_data *sdata,
 				      bool clear)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 82fedd9..3f46c6c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -755,7 +755,6 @@ struct ieee80211_sub_if_data {
 	struct work_struct csa_finalize_work;
 	int csa_counter_offset_beacon;
 	int csa_counter_offset_presp;
-	bool csa_radar_required;
 	bool csa_block_tx; /* write-protected by sdata_lock and local->mtx */
 	struct cfg80211_chan_def csa_chandef;
 
@@ -1795,10 +1794,6 @@ int __must_check
 ieee80211_vif_change_bandwidth(struct ieee80211_sub_if_data *sdata,
 			       const struct cfg80211_chan_def *chandef,
 			       u32 *changed);
-/* NOTE: only use ieee80211_vif_change_channel() for channel switch */
-int __must_check
-ieee80211_vif_change_channel(struct ieee80211_sub_if_data *sdata,
-			     u32 *changed);
 void ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata);
 void ieee80211_vif_vlan_copy_chanctx(struct ieee80211_sub_if_data *sdata);
 void ieee80211_vif_copy_chanctx_to_vlans(struct ieee80211_sub_if_data *sdata,
-- 
1.8.5.3

