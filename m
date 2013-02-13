Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51218 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409Ab3BMNC7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 08:02:59 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: chaitanya.mgit@gmail.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: don't call bss_info_changed on p2p-device/monitor
Date: Wed, 13 Feb 2013 14:02:52 +0100
Message-Id: <1360760572-28364-1-git-send-email-johannes@sipsolutions.net> (sfid-20130213_140303_577453_12828F58)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since the idle decision rework, mac80211 started calling
bss_info_changed() for the driver's monitor interface,
which causes a crash for iwlwifi, but drivers generally
don't expect this to happen. Therefore, avoid it.

While at it, also prevent calling it in such cases and
only print a warning. For the P2P Device interface the
idle will no longer be called (no channel context), so
also prevent that and warn on it.

Reported-by: Chaitanya <chaitanya.mgit@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/chan.c       | 10 ++++++++--
 net/mac80211/driver-ops.h | 17 ++++++++++-------
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 038f249..b2ccb74 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -137,7 +137,10 @@ static int ieee80211_assign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 
 	ieee80211_recalc_txpower(sdata);
 	sdata->vif.bss_conf.idle = false;
-	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_IDLE);
+
+	if (sdata->vif.type != NL80211_IFTYPE_P2P_DEVICE &&
+	    sdata->vif.type != NL80211_IFTYPE_MONITOR)
+		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_IDLE);
 
 	return 0;
 }
@@ -186,7 +189,10 @@ static void ieee80211_unassign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 	rcu_assign_pointer(sdata->vif.chanctx_conf, NULL);
 
 	sdata->vif.bss_conf.idle = true;
-	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_IDLE);
+
+	if (sdata->vif.type != NL80211_IFTYPE_P2P_DEVICE &&
+	    sdata->vif.type != NL80211_IFTYPE_MONITOR)
+		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_IDLE);
 
 	drv_unassign_vif_chanctx(local, sdata, ctx);
 
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 2b08b99..ee56d07 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -207,13 +207,16 @@ static inline void drv_bss_info_changed(struct ieee80211_local *local,
 {
 	might_sleep();
 
-	WARN_ON_ONCE(changed & (BSS_CHANGED_BEACON |
-				BSS_CHANGED_BEACON_ENABLED) &&
-		     sdata->vif.type != NL80211_IFTYPE_AP &&
-		     sdata->vif.type != NL80211_IFTYPE_ADHOC &&
-		     sdata->vif.type != NL80211_IFTYPE_MESH_POINT);
-	WARN_ON_ONCE(sdata->vif.type == NL80211_IFTYPE_P2P_DEVICE &&
-		     changed & ~BSS_CHANGED_IDLE);
+	if (WARN_ON_ONCE(changed & (BSS_CHANGED_BEACON |
+				    BSS_CHANGED_BEACON_ENABLED) &&
+			 sdata->vif.type != NL80211_IFTYPE_AP &&
+			 sdata->vif.type != NL80211_IFTYPE_ADHOC &&
+			 sdata->vif.type != NL80211_IFTYPE_MESH_POINT))
+		return;
+
+	if (WARN_ON_ONCE(sdata->vif.type == NL80211_IFTYPE_P2P_DEVICE ||
+			 sdata->vif.type == NL80211_IFTYPE_MONITOR))
+		return;
 
 	check_sdata_in_driver(sdata);
 
-- 
1.8.0

