Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:56016 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764Ab3KURUl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Nov 2013 12:20:41 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCHv2 2/5] mac80211: modify beacon using sdata/wdev-lock, not rtnl lock
Date: Thu, 21 Nov 2013 18:19:50 +0100
Message-Id: <1385054393-17238-3-git-send-email-sw@simonwunderlich.de> (sfid-20131121_182047_772995_69568429)
In-Reply-To: <1385054393-17238-1-git-send-email-sw@simonwunderlich.de>
References: <1385054393-17238-1-git-send-email-sw@simonwunderlich.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The csa finalize worker needs to change the beacon information (for
different modes). These are normally protected under rtnl lock, but the
csa finalize worker is called by drivers and should not acquire the RTNL
lock. Therefore change access protection for beacons to sdata/wdev lock.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
Changes to PATCH:
 * split into cfg80211/mac80211 patch

Changes to RFC:
 * move locking from mac80211 to cfg80211 (thanks Johannes)
---
 net/mac80211/cfg.c         |   20 ++++++++++++--------
 net/mac80211/ieee80211_i.h |    3 +++
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1f07aa6..1cdf2fb 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -857,7 +857,7 @@ static int ieee80211_set_probe_resp(struct ieee80211_sub_if_data *sdata,
 	if (!resp || !resp_len)
 		return 1;
 
-	old = rtnl_dereference(sdata->u.ap.probe_resp);
+	old = sdata_dereference(sdata->u.ap.probe_resp, sdata);
 
 	new = kzalloc(sizeof(struct probe_resp) + resp_len, GFP_KERNEL);
 	if (!new)
@@ -881,7 +881,8 @@ int ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 	int size, err;
 	u32 changed = BSS_CHANGED_BEACON;
 
-	old = rtnl_dereference(sdata->u.ap.beacon);
+	old = sdata_dereference(sdata->u.ap.beacon, sdata);
+
 
 	/* Need to have a beacon head if we don't have one yet */
 	if (!params->head && !old)
@@ -958,7 +959,7 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 		      BSS_CHANGED_P2P_PS;
 	int err;
 
-	old = rtnl_dereference(sdata->u.ap.beacon);
+	old = sdata_dereference(sdata->u.ap.beacon, sdata);
 	if (old)
 		return -EALREADY;
 
@@ -1020,7 +1021,8 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 
 	err = drv_start_ap(sdata->local, sdata);
 	if (err) {
-		old = rtnl_dereference(sdata->u.ap.beacon);
+		old = sdata_dereference(sdata->u.ap.beacon, sdata);
+
 		if (old)
 			kfree_rcu(old, rcu_head);
 		RCU_INIT_POINTER(sdata->u.ap.beacon, NULL);
@@ -1051,7 +1053,7 @@ static int ieee80211_change_beacon(struct wiphy *wiphy, struct net_device *dev,
 	if (sdata->vif.csa_active)
 		return -EBUSY;
 
-	old = rtnl_dereference(sdata->u.ap.beacon);
+	old = sdata_dereference(sdata->u.ap.beacon, sdata);
 	if (!old)
 		return -ENOENT;
 
@@ -1071,10 +1073,10 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	struct probe_resp *old_probe_resp;
 	struct cfg80211_chan_def chandef;
 
-	old_beacon = rtnl_dereference(sdata->u.ap.beacon);
+	old_beacon = sdata_dereference(sdata->u.ap.beacon, sdata);
 	if (!old_beacon)
 		return -ENOENT;
-	old_probe_resp = rtnl_dereference(sdata->u.ap.probe_resp);
+	old_probe_resp = sdata_dereference(sdata->u.ap.probe_resp, sdata);
 
 	/* abort any running channel switch */
 	sdata->vif.csa_active = false;
@@ -1975,7 +1977,7 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 	enum ieee80211_band band;
 	u32 changed = 0;
 
-	if (!rtnl_dereference(sdata->u.ap.beacon))
+	if (!sdata_dereference(sdata->u.ap.beacon, sdata))
 		return -ENOENT;
 
 	band = ieee80211_get_sdata_band(sdata);
@@ -3045,6 +3047,8 @@ static int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_if_mesh __maybe_unused *ifmsh;
 	int err, num_chanctx;
 
+	lockdep_assert_held(&sdata->wdev.mtx);
+
 	if (!list_empty(&local->roc_list) || local->scanning)
 		return -EBUSY;
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 61ccf0d..01e4d9b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -812,6 +812,9 @@ static inline void sdata_unlock(struct ieee80211_sub_if_data *sdata)
 	__release(&sdata->wdev.mtx);
 }
 
+#define sdata_dereference(p, sdata) \
+	rcu_dereference_protected(p, &sdata->wdev.mtx)
+
 static inline void
 sdata_assert_lock(struct ieee80211_sub_if_data *sdata)
 {
-- 
1.7.10.4

