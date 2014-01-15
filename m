Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:43182 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbaAOMJb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 07:09:31 -0500
Received: by mail-ea0-f173.google.com with SMTP id o10so418105eaj.4
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jan 2014 04:09:28 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 4/9] mac80211: fix sdata->radar_required locking
Date: Wed, 15 Jan 2014 13:04:49 +0100
Message-Id: <1389787494-7361-5-git-send-email-michal.kazior@tieto.com> (sfid-20140115_130943_770524_F6BD5B06)
In-Reply-To: <1389787494-7361-1-git-send-email-michal.kazior@tieto.com>
References: <1389787494-7361-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

radar_required setting wasn't protected by
local->mtx in some places. This should prevent
from scanning/radar detection/roc colliding.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/cfg.c  | 4 ++--
 net/mac80211/ibss.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 2ab5f49..ef679de 100644
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
@@ -3018,8 +3018,8 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 	if (!ieee80211_sdata_running(sdata))
 		goto unlock;
 
-	sdata->radar_required = sdata->csa_radar_required;
 	mutex_lock(&local->mtx);
+	sdata->radar_required = sdata->csa_radar_required;
 	err = ieee80211_vif_change_channel(sdata, &changed);
 	mutex_unlock(&local->mtx);
 	if (WARN_ON(err < 0))
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 5b9c95a..d1dc641 100644
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
1.8.4.rc3

