Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:47649 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756891Ab3KHOkW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Nov 2013 09:40:22 -0500
From: Luciano Coelho <luciano.coelho@intel.com>
To: linux-wireless@vger.kernel.org, sw@simonwunderlich.de,
	johannes@sipsolutions.net
Subject: [RFC v3 4/4] mac80211: only set CSA beacon when at least one beacon must be transmitted
Date: Fri,  8 Nov 2013 16:39:39 +0200
Message-Id: <1383921579-22373-4-git-send-email-luciano.coelho@intel.com> (sfid-20131108_154030_686693_781D40B4)
In-Reply-To: <1383921579-22373-1-git-send-email-luciano.coelho@intel.com>
References: <1383921579-22373-1-git-send-email-luciano.coelho@intel.com>
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
where it makes more sense.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---

In v3:

* moved the documentation change that explains that the
  channel_switch_beacon() driver op is not called when count <= 1;
  (Johannes)

* call finalize work immediately instead of doing it through the
  workqueue. (Johannes)

* instead of checking (params->count > 1), check the changed variable
  to decide whether to call drv_channel_switch_beacon() (and
  ieee80211_bss_info_change_notify() as well);


 include/net/mac80211.h |  2 ++
 net/mac80211/cfg.c     | 74 +++++++++++++++++++++++++++++++++++++++++---------
 net/mac80211/tx.c      |  9 ------
 3 files changed, 63 insertions(+), 22 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index ec6ed6d..f08c76a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2685,6 +2685,8 @@ enum ieee80211_roc_type {
  *	get the csa counter decremented by mac80211, but must check if it is
  *	1 using ieee80211_csa_is_complete() after the beacon has been
  *	transmitted and then call ieee80211_csa_finish().
+ *	If the CSA count starts as zero or 1, this function will not be called,
+ *	since there won't be any time to beacon before the switch anyway.
  *
  * @join_ibss: Join an IBSS (on an IBSS interface); this is called after all
  *	information in bss_conf is set up and the beacon can be retrieved. A
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 44b2f51..9baf469 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2956,17 +2956,20 @@ cfg80211_beacon_dup(struct cfg80211_beacon_data *beacon)
 	return new_beacon;
 }
 
-void ieee80211_csa_finalize_work(struct work_struct *work)
+void ieee80211_csa_finish(struct ieee80211_vif *vif)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+
+	ieee80211_queue_work(&sdata->local->hw,
+			     &sdata->csa_finalize_work);
+}
+EXPORT_SYMBOL(ieee80211_csa_finish);
+
+static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_sub_if_data *sdata =
-		container_of(work, struct ieee80211_sub_if_data,
-			     csa_finalize_work);
 	struct ieee80211_local *local = sdata->local;
 	int err, changed = 0;
 
-	if (!ieee80211_sdata_running(sdata))
-		return;
-
 	sdata->radar_required = sdata->csa_radar_required;
 	err = ieee80211_vif_change_channel(sdata, &local->csa_chandef,
 					   &changed);
@@ -3014,6 +3017,18 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 	cfg80211_ch_switch_notify(sdata->dev, &local->csa_chandef);
 }
 
+void ieee80211_csa_finalize_work(struct work_struct *work)
+{
+	struct ieee80211_sub_if_data *sdata =
+		container_of(work, struct ieee80211_sub_if_data,
+			     csa_finalize_work);
+
+	if (!ieee80211_sdata_running(sdata))
+		return;
+
+	ieee80211_csa_finalize(sdata);
+}
+
 int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 			     struct cfg80211_csa_settings *params)
 {
@@ -3022,7 +3037,7 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_chanctx *chanctx;
 	struct ieee80211_if_mesh __maybe_unused *ifmsh;
-	int err, num_chanctx;
+	int err, num_chanctx, changed = 0;
 
 	if (!list_empty(&local->roc_list) || local->scanning)
 		return -EBUSY;
@@ -3061,19 +3076,42 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 
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
+			ieee80211_csa_finalize(sdata);
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
@@ -3101,9 +3139,17 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 		    params->chandef.chan->band)
 			return -EINVAL;
 
+		/* see comments and TODO in the NL80211_IFTYPE_AP block */
+		if (params->count <= 1) {
+			ieee80211_csa_finalize(sdata);
+			break;
+		}
+
 		err = ieee80211_ibss_csa_beacon(sdata, params);
 		if (err < 0)
 			return err;
+		changed |= err;
+
 		break;
 #ifdef CONFIG_MAC80211_MESH
 	case NL80211_IFTYPE_MESH_POINT:
@@ -3139,8 +3185,10 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	local->csa_chandef = params->chandef;
 	sdata->vif.csa_active = true;
 
-	ieee80211_bss_info_change_notify(sdata, err);
-	drv_channel_switch_beacon(sdata, &params->chandef);
+	if (changed) {
+		ieee80211_bss_info_change_notify(sdata, changed);
+		drv_channel_switch_beacon(sdata, &params->chandef);
+	}
 
 	return 0;
 }
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 57d9feb..f324ab7 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2372,15 +2372,6 @@ static int ieee80211_beacon_add_tim(struct ieee80211_sub_if_data *sdata,
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

