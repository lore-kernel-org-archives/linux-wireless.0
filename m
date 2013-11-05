Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:36569 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab3KEUzA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 15:55:00 -0500
From: Luciano Coelho <luciano.coelho@intel.com>
To: linux-wireless@vger.kernel.org, sw@simonwunderlich.de
Cc: johannes@sipsolutions.net
Subject: [RFC v2 2/2] mac80211: only set CSA beacon when at least one beacon must be transmitted
Date: Tue,  5 Nov 2013 22:54:14 +0200
Message-Id: <1383684854-21663-2-git-send-email-luciano.coelho@intel.com> (sfid-20131105_215504_432041_AD218800)
In-Reply-To: <1383684854-21663-1-git-send-email-luciano.coelho@intel.com>
References: <1383684854-21663-1-git-send-email-luciano.coelho@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With a CSA count of 0, we won't transmit any CSA beacons, because the
switch will happen before the next TBTT.  To avoid extra work and
potential confusion in the drivers, complete the CSA immediately,
instead of waiting for the driver to call ieee80211_csa_finish().

To keep things simpler, we also switch immediately when the CSA count
is 1, while in theory we should delay the switch until just before the
next TBTT.

Additionally, move the ieee80211_csa_finish() function to cfg.c,
where it makes more sense (and since we call it from cfg.c now).

Cc: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
Simon, I think with this we won't need any changes in ath9k, right?
---
 net/mac80211/cfg.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++------
 net/mac80211/tx.c  |  9 ---------
 2 files changed, 48 insertions(+), 15 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index b0a651c..fe5de2c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2854,6 +2854,15 @@ cfg80211_beacon_dup(struct cfg80211_beacon_data *beacon)
 	return new_beacon;
 }
 
+void ieee80211_csa_finish(struct ieee80211_vif *vif)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+
+	ieee80211_queue_work(&sdata->local->hw,
+			     &sdata->csa_finalize_work);
+}
+EXPORT_SYMBOL(ieee80211_csa_finish);
+
 void ieee80211_csa_finalize_work(struct work_struct *work)
 {
 	struct ieee80211_sub_if_data *sdata =
@@ -2912,7 +2921,7 @@ static int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_chanctx *chanctx;
-	int err, num_chanctx;
+	int err, num_chanctx, changed = 0;
 
 	if (!list_empty(&local->roc_list) || local->scanning)
 		return -EBUSY;
@@ -2951,19 +2960,42 @@ static int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP:
-		sdata->csa_counter_offset_beacon =
-			params->counter_offset_beacon;
-		sdata->csa_counter_offset_presp = params->counter_offset_presp;
 		sdata->u.ap.next_beacon =
 			cfg80211_beacon_dup(&params->beacon_after);
 		if (!sdata->u.ap.next_beacon)
 			return -ENOMEM;
 
+		/*
+		 * With a count of 0, we don't have to wait for any
+		 * TBTT before switching, so complete the CSA
+		 * immediately.  In theory, with a count == 1 we
+		 * should delay the switch until just before the next
+		 * TBTT, but that would complicate things so we switch
+		 * immediately too.  If we would delay the switch
+		 * until the next TBTT, we would have to set the probe
+		 * response here.
+		 *
+		 * TODO: A channel switch with count <= 1 without
+		 * sending a CSA action frame is kind of useless,
+		 * because the clients won't know we're changing
+		 * channels.  The action frame must be implemented
+		 * either here or in the userspace.
+		 */
+		if (params->count <= 1) {
+			ieee80211_csa_finish(&sdata->vif);
+			break;
+		}
+
+		sdata->csa_counter_offset_beacon =
+			params->counter_offset_beacon;
+		sdata->csa_counter_offset_presp = params->counter_offset_presp;
 		err = ieee80211_assign_beacon(sdata, &params->beacon_csa);
 		if (err < 0) {
 			kfree(sdata->u.ap.next_beacon);
 			return err;
 		}
+		changed |= err;
+
 		break;
 	case NL80211_IFTYPE_ADHOC:
 		if (!sdata->vif.bss_conf.ibss_joined)
@@ -2991,9 +3023,17 @@ static int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 		    params->chandef.chan->band)
 			return -EINVAL;
 
+		/* see comments and TODO in the NL80211_IFTYPE_AP block */
+		if (params->count <= 1) {
+			ieee80211_csa_finish(&sdata->vif);
+			break;
+		}
+
 		err = ieee80211_ibss_csa_beacon(sdata, params);
 		if (err < 0)
 			return err;
+		changed |= err;
+
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -3009,8 +3049,10 @@ static int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	local->csa_chandef = params->chandef;
 	sdata->vif.csa_active = true;
 
-	ieee80211_bss_info_change_notify(sdata, err);
-	drv_channel_switch_beacon(sdata, &params->chandef);
+	ieee80211_bss_info_change_notify(sdata, changed);
+
+	if (params->count > 1)
+		drv_channel_switch_beacon(sdata, &params->chandef);
 
 	return 0;
 }
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 1e0d40f..ac4b79f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2343,15 +2343,6 @@ static int ieee80211_beacon_add_tim(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-void ieee80211_csa_finish(struct ieee80211_vif *vif)
-{
-	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
-
-	ieee80211_queue_work(&sdata->local->hw,
-			     &sdata->csa_finalize_work);
-}
-EXPORT_SYMBOL(ieee80211_csa_finish);
-
 static void ieee80211_update_csa(struct ieee80211_sub_if_data *sdata,
 				 struct beacon_data *beacon)
 {
-- 
1.8.4.rc3

