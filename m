Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:49780 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927AbaA2HB2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 02:01:28 -0500
Received: by mail-ee0-f48.google.com with SMTP id t10so657566eei.35
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jan 2014 23:01:25 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 5/5] mac80211: add missing CSA locking
Date: Wed, 29 Jan 2014 07:56:21 +0100
Message-Id: <1390978581-13273-6-git-send-email-michal.kazior@tieto.com> (sfid-20140129_080149_423080_F80071F5)
In-Reply-To: <1390978581-13273-1-git-send-email-michal.kazior@tieto.com>
References: <1390978581-13273-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch adds a missing sdata lock and adds a few
lockdeps for easier maintenance.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/cfg.c   | 7 ++++++-
 net/mac80211/ibss.c  | 2 ++
 net/mac80211/iface.c | 2 ++
 net/mac80211/mesh.c  | 2 ++
 4 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 18e8687..d7f805e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1053,6 +1053,7 @@ static int ieee80211_change_beacon(struct wiphy *wiphy, struct net_device *dev,
 	int err;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	sdata_assert_lock(sdata);
 
 	/* don't allow changing the beacon while CSA is in place - offset
 	 * of channel switch counter may change
@@ -1080,6 +1081,8 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	struct probe_resp *old_probe_resp;
 	struct cfg80211_chan_def chandef;
 
+	sdata_assert_lock(sdata);
+
 	old_beacon = sdata_dereference(sdata->u.ap.beacon, sdata);
 	if (!old_beacon)
 		return -ENOENT;
@@ -3002,6 +3005,8 @@ static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_local *local = sdata->local;
 	int err, changed = 0;
 
+	sdata_assert_lock(sdata);
+
 	mutex_lock(&local->mtx);
 	sdata->radar_required = sdata->csa_radar_required;
 	err = ieee80211_vif_change_channel(sdata, &changed);
@@ -3086,7 +3091,7 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_if_mesh __maybe_unused *ifmsh;
 	int err, num_chanctx, changed = 0;
 
-	lockdep_assert_held(&sdata->wdev.mtx);
+	sdata_assert_lock(sdata);
 
 	if (!list_empty(&local->roc_list) || local->scanning)
 		return -EBUSY;
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index f01d468..b2da79f 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -795,6 +795,8 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	int err;
 	u32 sta_flags;
 
+	sdata_assert_lock(sdata);
+
 	sta_flags = IEEE80211_STA_DISABLE_VHT;
 	switch (ifibss->chandef.width) {
 	case NL80211_CHAN_WIDTH_5:
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 0aa9675..5f25d30 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -822,7 +822,9 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	cancel_work_sync(&local->dynamic_ps_enable_work);
 
 	cancel_work_sync(&sdata->recalc_smps);
+	sdata_lock(sdata);
 	sdata->vif.csa_active = false;
+	sdata_unlock(sdata);
 	cancel_work_sync(&sdata->csa_finalize_work);
 
 	cancel_delayed_work_sync(&sdata->dfs_cac_timer_work);
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index bd55115..f70e9cd 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -864,6 +864,8 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
 	int err;
 	u32 sta_flags;
 
+	sdata_assert_lock(sdata);
+
 	sta_flags = IEEE80211_STA_DISABLE_VHT;
 	switch (sdata->vif.bss_conf.chandef.width) {
 	case NL80211_CHAN_WIDTH_20_NOHT:
-- 
1.8.5.3

