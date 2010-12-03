Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45556 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758483Ab0LCI11 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 03:27:27 -0500
Message-Id: <20101203082348.475019559@sipsolutions.net>
Date: Fri, 03 Dec 2010 09:20:41 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>, linux-wireless@vger.kernel.org
Subject: [PATCH 2/5] mac80211: move mesh filter adjusting
References: <20101203082039.131181927@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Logically, the filter adjusting belongs with
starting/stopping mesh, not interface up/down,
so move it there.

Tested-by: Javier Cardona <javier@cozybit.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c |   18 +-----------------
 net/mac80211/mesh.c  |   11 +++++++++++
 2 files changed, 12 insertions(+), 17 deletions(-)

--- wireless-testing.orig/net/mac80211/iface.c	2010-12-02 08:18:47.000000000 +0100
+++ wireless-testing/net/mac80211/iface.c	2010-12-02 22:35:25.000000000 +0100
@@ -197,11 +197,6 @@ static int ieee80211_do_open(struct net_
 		sdata->bss = &sdata->u.ap;
 		break;
 	case NL80211_IFTYPE_MESH_POINT:
-		if (!ieee80211_vif_is_mesh(&sdata->vif))
-			break;
-		/* mesh ifaces must set allmulti to forward mcast traffic */
-		atomic_inc(&local->iff_allmultis);
-		break;
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_ADHOC:
@@ -274,9 +269,6 @@ static int ieee80211_do_open(struct net_
 		}
 
 		if (ieee80211_vif_is_mesh(&sdata->vif)) {
-			local->fif_other_bss++;
-			ieee80211_configure_filter(local);
-
 			ieee80211_start_mesh(sdata);
 		} else if (sdata->vif.type == NL80211_IFTYPE_AP) {
 			local->fif_pspoll++;
@@ -504,16 +496,8 @@ static void ieee80211_do_stop(struct iee
 		ieee80211_configure_filter(local);
 		break;
 	case NL80211_IFTYPE_MESH_POINT:
-		if (ieee80211_vif_is_mesh(&sdata->vif)) {
-			/* other_bss and allmulti are always set on mesh
-			 * ifaces */
-			local->fif_other_bss--;
-			atomic_dec(&local->iff_allmultis);
-
-			ieee80211_configure_filter(local);
-
+		if (ieee80211_vif_is_mesh(&sdata->vif))
 			ieee80211_stop_mesh(sdata);
-		}
 		/* fall through */
 	default:
 		flush_work(&sdata->work);
--- wireless-testing.orig/net/mac80211/mesh.c	2010-12-02 08:18:47.000000000 +0100
+++ wireless-testing/net/mac80211/mesh.c	2010-12-02 22:36:16.000000000 +0100
@@ -513,6 +513,11 @@ void ieee80211_start_mesh(struct ieee802
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee80211_local *local = sdata->local;
 
+	local->fif_other_bss++;
+	/* mesh ifaces must set allmulti to forward mcast traffic */
+	atomic_inc(&local->iff_allmultis);
+	ieee80211_configure_filter(local);
+
 	set_bit(MESH_WORK_HOUSEKEEPING, &ifmsh->wrkq_flags);
 	ieee80211_mesh_root_setup(ifmsh);
 	ieee80211_queue_work(&local->hw, &sdata->work);
@@ -524,6 +529,8 @@ void ieee80211_start_mesh(struct ieee802
 
 void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 {
+	struct ieee80211_local *local = sdata->local;
+
 	del_timer_sync(&sdata->u.mesh.housekeeping_timer);
 	del_timer_sync(&sdata->u.mesh.mesh_path_root_timer);
 	/*
@@ -534,6 +541,10 @@ void ieee80211_stop_mesh(struct ieee8021
 	 * it no longer is.
 	 */
 	cancel_work_sync(&sdata->work);
+
+	local->fif_other_bss--;
+	atomic_dec(&local->iff_allmultis);
+	ieee80211_configure_filter(local);
 }
 
 static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,


