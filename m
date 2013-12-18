Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50518 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab3LRTB7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Dec 2013 14:01:59 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: sw@simonwunderlich.de, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: remove unnecessary iflist_mtx locking
Date: Wed, 18 Dec 2013 20:01:55 +0100
Message-Id: <1387393315-15671-1-git-send-email-johannes@sipsolutions.net> (sfid-20131218_200202_219087_C4056ED1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The radar detection code changed a few times, and due to
the changes some iflist_mtx locking stayed in that isn't
actually necessary - remove it.

One version of the code needed it because an AP interface's
VLAN list was changed to use this, but then we moved the
list handling outside of the chanctx handling and thus the
locking was no longer needed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c   | 2 --
 net/mac80211/iface.c | 2 --
 2 files changed, 4 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index ac18528..bfe54da 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2903,10 +2903,8 @@ static int ieee80211_start_radar_detection(struct wiphy *wiphy,
 	sdata->needed_rx_chains = local->rx_chains;
 	sdata->radar_required = true;
 
-	mutex_lock(&local->iflist_mtx);
 	err = ieee80211_vif_use_channel(sdata, chandef,
 					IEEE80211_CHANCTX_SHARED);
-	mutex_unlock(&local->iflist_mtx);
 	if (err)
 		return err;
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 3d2168c..0c0be90 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -826,9 +826,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	if (sdata->wdev.cac_started) {
 		chandef = sdata->vif.bss_conf.chandef;
 		WARN_ON(local->suspended);
-		mutex_lock(&local->iflist_mtx);
 		ieee80211_vif_release_channel(sdata);
-		mutex_unlock(&local->iflist_mtx);
 		cfg80211_cac_event(sdata->dev, &chandef,
 				   NL80211_RADAR_CAC_ABORTED,
 				   GFP_KERNEL);
-- 
1.8.5.1

