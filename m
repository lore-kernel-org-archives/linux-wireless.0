Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:37438 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215Ab3KKSfE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 13:35:04 -0500
Received: by mail-ee0-f43.google.com with SMTP id b47so2614402eek.2
        for <linux-wireless@vger.kernel.org>; Mon, 11 Nov 2013 10:35:02 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: move csa_chandef to sdata
Date: Mon, 11 Nov 2013 20:34:54 +0200
Message-Id: <1384194894-26935-1-git-send-email-egrumbach@gmail.com> (sfid-20131111_193519_126819_EE2CC3C1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

There is no reason why we should have only one channel switch
announcement at a time for a single phy.  When support for channel
switch with multiple contexts and multiple vifs per context is
implemented, we will need the chandef data for each vif.  Move the
csa_chandef structure to sdata to prepare for this.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
[Fixed compilation with mesh]
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/cfg.c         |    9 ++++-----
 net/mac80211/chan.c        |    2 +-
 net/mac80211/ibss.c        |    6 +++---
 net/mac80211/ieee80211_i.h |    3 +--
 net/mac80211/mesh.c        |    2 +-
 net/mac80211/mlme.c        |    9 ++++-----
 6 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 95667b0..a91526d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2968,13 +2968,12 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 		return;
 
 	sdata->radar_required = sdata->csa_radar_required;
-	err = ieee80211_vif_change_channel(sdata, &local->csa_chandef,
-					   &changed);
+	err = ieee80211_vif_change_channel(sdata, &changed);
 	if (WARN_ON(err < 0))
 		return;
 
 	if (!local->use_chanctx) {
-		local->_oper_chandef = local->csa_chandef;
+		local->_oper_chandef = sdata->csa_chandef;
 		ieee80211_hw_config(local, 0);
 	}
 
@@ -3011,7 +3010,7 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 					IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_CSA);
 
-	cfg80211_ch_switch_notify(sdata->dev, &local->csa_chandef);
+	cfg80211_ch_switch_notify(sdata->dev, &sdata->csa_chandef);
 }
 
 static int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
@@ -3136,7 +3135,7 @@ static int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 				IEEE80211_MAX_QUEUE_MAP,
 				IEEE80211_QUEUE_STOP_REASON_CSA);
 
-	local->csa_chandef = params->chandef;
+	sdata->csa_chandef = params->chandef;
 	sdata->vif.csa_active = true;
 
 	ieee80211_bss_info_change_notify(sdata, err);
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index d9d1181..a57d5d9 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -549,12 +549,12 @@ int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 }
 
 int ieee80211_vif_change_channel(struct ieee80211_sub_if_data *sdata,
-				 const struct cfg80211_chan_def *chandef,
 				 u32 *changed)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_chanctx_conf *conf;
 	struct ieee80211_chanctx *ctx;
+	const struct cfg80211_chan_def *chandef = &sdata->csa_chandef;
 	int ret;
 	u32 chanctx_changed = 0;
 
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 531be04..0f1fb5d 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -550,12 +550,12 @@ int ieee80211_ibss_finish_csa(struct ieee80211_sub_if_data *sdata)
 					capability);
 		/* XXX: should not really modify cfg80211 data */
 		if (cbss) {
-			cbss->channel = sdata->local->csa_chandef.chan;
+			cbss->channel = sdata->csa_chandef.chan;
 			cfg80211_put_bss(sdata->local->hw.wiphy, cbss);
 		}
 	}
 
-	ifibss->chandef = sdata->local->csa_chandef;
+	ifibss->chandef = sdata->csa_chandef;
 
 	/* generate the beacon */
 	err = ieee80211_ibss_csa_beacon(sdata, NULL);
@@ -922,7 +922,7 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 				IEEE80211_MAX_QUEUE_MAP,
 				IEEE80211_QUEUE_STOP_REASON_CSA);
 
-	sdata->local->csa_chandef = params.chandef;
+	sdata->csa_chandef = params.chandef;
 	sdata->vif.csa_active = true;
 
 	ieee80211_bss_info_change_notify(sdata, err);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ca0fe3d..ce9d3bf 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -735,6 +735,7 @@ struct ieee80211_sub_if_data {
 	int csa_counter_offset_beacon;
 	int csa_counter_offset_presp;
 	bool csa_radar_required;
+	struct cfg80211_chan_def csa_chandef;
 
 	/* used to reconfigure hardware SM PS */
 	struct work_struct recalc_smps;
@@ -1093,7 +1094,6 @@ struct ieee80211_local {
 	enum mac80211_scan_state next_scan_state;
 	struct delayed_work scan_work;
 	struct ieee80211_sub_if_data __rcu *scan_sdata;
-	struct cfg80211_chan_def csa_chandef;
 	/* For backward compatibility only -- do not use */
 	struct cfg80211_chan_def _oper_chandef;
 
@@ -1731,7 +1731,6 @@ ieee80211_vif_change_bandwidth(struct ieee80211_sub_if_data *sdata,
 /* NOTE: only use ieee80211_vif_change_channel() for channel switch */
 int __must_check
 ieee80211_vif_change_channel(struct ieee80211_sub_if_data *sdata,
-			     const struct cfg80211_chan_def *chandef,
 			     u32 *changed);
 void ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata);
 void ieee80211_vif_vlan_copy_chanctx(struct ieee80211_sub_if_data *sdata);
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 896fe3b..d2f9f97 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -959,7 +959,7 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
 				IEEE80211_MAX_QUEUE_MAP,
 				IEEE80211_QUEUE_STOP_REASON_CSA);
 
-	sdata->local->csa_chandef = params.chandef;
+	sdata->csa_chandef = params.chandef;
 	sdata->vif.csa_active = true;
 
 	ieee80211_bss_info_change_notify(sdata, err);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d7504ab..ba0d8e9 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -886,8 +886,7 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 	if (!ifmgd->associated)
 		goto out;
 
-	ret = ieee80211_vif_change_channel(sdata, &local->csa_chandef,
-					   &changed);
+	ret = ieee80211_vif_change_channel(sdata, &changed);
 	if (ret) {
 		sdata_info(sdata,
 			   "vif channel switch failed, disconnecting\n");
@@ -897,7 +896,7 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 	}
 
 	if (!local->use_chanctx) {
-		local->_oper_chandef = local->csa_chandef;
+		local->_oper_chandef = sdata->csa_chandef;
 		/* Call "hw_config" only if doing sw channel switch.
 		 * Otherwise update the channel directly
 		 */
@@ -908,7 +907,7 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 	}
 
 	/* XXX: shouldn't really modify cfg80211-owned data! */
-	ifmgd->associated->channel = local->csa_chandef.chan;
+	ifmgd->associated->channel = sdata->csa_chandef.chan;
 
 	/* XXX: wait for a beacon first? */
 	ieee80211_wake_queues_by_reason(&local->hw,
@@ -1035,7 +1034,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	}
 	mutex_unlock(&local->chanctx_mtx);
 
-	local->csa_chandef = csa_ie.chandef;
+	sdata->csa_chandef = csa_ie.chandef;
 
 	if (csa_ie.mode)
 		ieee80211_stop_queues_by_reason(&local->hw,
-- 
1.7.9.5

