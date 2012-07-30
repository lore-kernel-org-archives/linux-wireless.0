Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36157 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab2G3Roy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jul 2012 13:44:54 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: manage carrier state in mesh
Date: Mon, 30 Jul 2012 19:44:51 +0200
Message-Id: <1343670291-7144-1-git-send-email-johannes@sipsolutions.net> (sfid-20120730_194459_424244_459C5C47)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of assuming the carrier is on all
the time in mesh manage it with joining
and leaving the mesh.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c |   12 ++++++++----
 net/mac80211/mesh.c  |    4 ++++
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 12025dd..98e448a 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -555,12 +555,16 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 			changed |= ieee80211_reset_erp_info(sdata);
 		ieee80211_bss_info_change_notify(sdata, changed);
 
-		if (sdata->vif.type == NL80211_IFTYPE_STATION ||
-		    sdata->vif.type == NL80211_IFTYPE_ADHOC ||
-		    sdata->vif.type == NL80211_IFTYPE_AP)
+		switch (sdata->vif.type) {
+		case NL80211_IFTYPE_STATION:
+		case NL80211_IFTYPE_ADHOC:
+		case NL80211_IFTYPE_AP:
+		case NL80211_IFTYPE_MESH_POINT:
 			netif_carrier_off(dev);
-		else if (dev)
+			break;
+		default:
 			netif_carrier_on(dev);
+		}
 
 		/*
 		 * set default queue parameters so drivers don't
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index db295e3..0c7d54d 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -634,6 +634,8 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 						BSS_CHANGED_HT |
 						BSS_CHANGED_BASIC_RATES |
 						BSS_CHANGED_BEACON_INT);
+
+	netif_carrier_on(sdata->dev);
 }
 
 void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
@@ -641,6 +643,8 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 
+	netif_carrier_off(sdata->dev);
+
 	ifmsh->mesh_id_len = 0;
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
 	sta_info_flush(local, NULL);
-- 
1.7.10.4

