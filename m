Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:52954 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876AbaA2HBZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 02:01:25 -0500
Received: by mail-ee0-f44.google.com with SMTP id c13so655556eek.17
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jan 2014 23:01:24 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 4/5] mac80211: fix sdata->radar_required locking
Date: Wed, 29 Jan 2014 07:56:20 +0100
Message-Id: <1390978581-13273-5-git-send-email-michal.kazior@tieto.com> (sfid-20140129_080150_032942_7E979C98)
In-Reply-To: <1390978581-13273-1-git-send-email-michal.kazior@tieto.com>
References: <1390978581-13273-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

radar_required setting wasn't protected by
local->mtx in some places. This should prevent
from scanning/radar detection/roc colliding.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/cfg.c  | 4 ++--
 net/mac80211/chan.c | 2 ++
 net/mac80211/ibss.c | 2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 20d4ee6..18e8687 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -970,9 +970,9 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	/* TODO: make hostapd tell us what it wants */
 	sdata->smps_mode = IEEE80211_SMPS_OFF;
 	sdata->needed_rx_chains = sdata->local->rx_chains;
-	sdata->radar_required = params->radar_required;
 
 	mutex_lock(&local->mtx);
+	sdata->radar_required = params->radar_required;
 	err = ieee80211_vif_use_channel(sdata, &params->chandef,
 					IEEE80211_CHANCTX_SHARED);
 	mutex_unlock(&local->mtx);
@@ -3002,8 +3002,8 @@ static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_local *local = sdata->local;
 	int err, changed = 0;
 
-	sdata->radar_required = sdata->csa_radar_required;
 	mutex_lock(&local->mtx);
+	sdata->radar_required = sdata->csa_radar_required;
 	err = ieee80211_vif_change_channel(sdata, &changed);
 	mutex_unlock(&local->mtx);
 	if (WARN_ON(err < 0))
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index f43613a..42c6592 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -196,6 +196,8 @@ static bool ieee80211_is_radar_required(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata;
 
+	lockdep_assert_held(&local->mtx);
+
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		if (sdata->radar_required) {
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 82d3d14..f01d468 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -303,6 +303,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		mutex_unlock(&local->mtx);
 		return;
 	}
+	sdata->radar_required = radar_required;
 	mutex_unlock(&local->mtx);
 
 	memcpy(ifibss->bssid, bssid, ETH_ALEN);
@@ -318,7 +319,6 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	rcu_assign_pointer(ifibss->presp, presp);
 	mgmt = (void *)presp->head;
 
-	sdata->radar_required = radar_required;
 	sdata->vif.bss_conf.enable_beacon = true;
 	sdata->vif.bss_conf.beacon_int = beacon_int;
 	sdata->vif.bss_conf.basic_rates = basic_rates;
-- 
1.8.5.3

