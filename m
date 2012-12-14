Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57031 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab2LNNq0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2012 08:46:26 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/4] mac80211: assign bss_conf.bssid only once
Date: Fri, 14 Dec 2012 14:46:46 +0100
Message-Id: <1355492806-31673-5-git-send-email-johannes@sipsolutions.net> (sfid-20121214_144631_883938_015574C4)
In-Reply-To: <1355492806-31673-1-git-send-email-johannes@sipsolutions.net>
References: <1355492806-31673-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of checking every time bss_info_changed is called,
assign the pointer once depending on the interface type
and then leave it untouched until the interface type is
changed. This makes the ieee80211_bss_info_change_notify()
now a simple wrapper to call the driver only.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/driver-ops.h |  2 ++
 net/mac80211/iface.c      |  7 +++++++
 net/mac80211/main.c       | 20 --------------------
 net/mac80211/mesh.c       |  3 +++
 net/mac80211/pm.c         |  3 +++
 5 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 7be48a9..a93eba0 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -212,6 +212,8 @@ static inline void drv_bss_info_changed(struct ieee80211_local *local,
 		     sdata->vif.type != NL80211_IFTYPE_AP &&
 		     sdata->vif.type != NL80211_IFTYPE_ADHOC &&
 		     sdata->vif.type != NL80211_IFTYPE_MESH_POINT);
+	WARN_ON_ONCE(sdata->vif.type == NL80211_IFTYPE_P2P_DEVICE &&
+		     changed & ~BSS_CHANGED_IDLE);
 
 	check_sdata_in_driver(sdata);
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index ab47df0..dcf943e 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1233,6 +1233,7 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 	case NL80211_IFTYPE_AP:
 		skb_queue_head_init(&sdata->u.ap.ps.bc_buf);
 		INIT_LIST_HEAD(&sdata->u.ap.vlans);
+		sdata->vif.bss_conf.bssid = sdata->vif.addr;
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
 		type = NL80211_IFTYPE_STATION;
@@ -1240,9 +1241,11 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 		sdata->vif.p2p = true;
 		/* fall through */
 	case NL80211_IFTYPE_STATION:
+		sdata->vif.bss_conf.bssid = sdata->u.mgd.bssid;
 		ieee80211_sta_setup_sdata(sdata);
 		break;
 	case NL80211_IFTYPE_ADHOC:
+		sdata->vif.bss_conf.bssid = sdata->u.ibss.bssid;
 		ieee80211_ibss_setup_sdata(sdata);
 		break;
 	case NL80211_IFTYPE_MESH_POINT:
@@ -1256,8 +1259,12 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 				      MONITOR_FLAG_OTHER_BSS;
 		break;
 	case NL80211_IFTYPE_WDS:
+		sdata->vif.bss_conf.bssid = NULL;
+		break;
 	case NL80211_IFTYPE_AP_VLAN:
+		break;
 	case NL80211_IFTYPE_P2P_DEVICE:
+		sdata->vif.bss_conf.bssid = sdata->vif.addr;
 		break;
 	case NL80211_IFTYPE_UNSPECIFIED:
 	case NUM_NL80211_IFTYPES:
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 282f583..475e85b 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -207,30 +207,10 @@ void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
 				      u32 changed)
 {
 	struct ieee80211_local *local = sdata->local;
-	static const u8 zero[ETH_ALEN] = { 0 };
 
 	if (!changed)
 		return;
 
-	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
-		sdata->vif.bss_conf.bssid = sdata->u.mgd.bssid;
-	} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
-		sdata->vif.bss_conf.bssid = sdata->u.ibss.bssid;
-	else if (sdata->vif.type == NL80211_IFTYPE_AP)
-		sdata->vif.bss_conf.bssid = sdata->vif.addr;
-	else if (sdata->vif.type == NL80211_IFTYPE_WDS)
-		sdata->vif.bss_conf.bssid = NULL;
-	else if (ieee80211_vif_is_mesh(&sdata->vif)) {
-		sdata->vif.bss_conf.bssid = zero;
-	} else if (sdata->vif.type == NL80211_IFTYPE_P2P_DEVICE) {
-		sdata->vif.bss_conf.bssid = sdata->vif.addr;
-		WARN_ONCE(changed & ~(BSS_CHANGED_IDLE),
-			  "P2P Device BSS changed %#x", changed);
-	} else {
-		WARN_ON(1);
-		return;
-	}
-
 	drv_bss_info_changed(local, sdata, &sdata->vif.bss_conf, changed);
 }
 
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index df2e36b..776536a 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -815,6 +815,7 @@ void ieee80211_mesh_notify_scan_completed(struct ieee80211_local *local)
 void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	static u8 zero_addr[ETH_ALEN] = {};
 
 	setup_timer(&ifmsh->housekeeping_timer,
 		    ieee80211_mesh_housekeeping_timer,
@@ -840,4 +841,6 @@ void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
 	INIT_LIST_HEAD(&ifmsh->preq_queue.list);
 	spin_lock_init(&ifmsh->mesh_preq_queue_lock);
 	spin_lock_init(&ifmsh->sync_offset_lock);
+
+	sdata->vif.bss_conf.bssid = zero_addr;
 }
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 3d93cd3..f725622 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -121,6 +121,7 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 
 	/* remove all interfaces */
 	list_for_each_entry(sdata, &local->interfaces, list) {
+		static u8 zero_addr[ETH_ALEN] = {};
 		u32 changed = 0;
 
 		if (!ieee80211_sdata_running(sdata))
@@ -148,6 +149,8 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 
 		sdata->suspend_bss_conf = sdata->vif.bss_conf;
 		memset(&sdata->vif.bss_conf, 0, sizeof(sdata->vif.bss_conf));
+		if (sdata->suspend_bss_conf.bssid)
+			sdata->vif.bss_conf.bssid = zero_addr;
 
 		/* disable beaconing or remove association */
 		ieee80211_bss_info_change_notify(sdata, changed);
-- 
1.8.0

