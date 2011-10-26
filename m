Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53584 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab1JZVrt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Oct 2011 17:47:49 -0400
Received: by mail-qw0-f46.google.com with SMTP id j40so1925819qab.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Oct 2011 14:47:49 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: devel@lists.open80211s.org, Thomas Pedersen <thomas@cozybit.com>,
	johannes@sipsolutions.net, linville@tuxdriver.com
Subject: [PATCH 5/5] mac80211: allow frame aggregation for mesh
Date: Wed, 26 Oct 2011 14:47:29 -0700
Message-Id: <1319665649-21784-6-git-send-email-thomas@cozybit.com> (sfid-20111026_234755_394610_47CB19BD)
In-Reply-To: <1319665649-21784-1-git-send-email-thomas@cozybit.com>
References: <1319665649-21784-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
Signed-off-by: Ashok Nagarajan <anagar6@uic.edu>

v2:
	Remove outdated comments (Christian)
---
 net/mac80211/agg-rx.c |    3 ++-
 net/mac80211/agg-tx.c |   10 +++-------
 net/mac80211/ht.c     |    3 ++-
 net/mac80211/rx.c     |    7 +------
 4 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 0cde8df..e8af4b0 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -176,7 +176,8 @@ static void ieee80211_send_addba_resp(struct ieee80211_sub_if_data *sdata, u8 *d
 	memcpy(mgmt->da, da, ETH_ALEN);
 	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
 	if (sdata->vif.type == NL80211_IFTYPE_AP ||
-	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
+	    sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
 		memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
 	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		memcpy(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN);
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 2ac0339..fefc7e5 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -77,7 +77,8 @@ static void ieee80211_send_addba_request(struct ieee80211_sub_if_data *sdata,
 	memcpy(mgmt->da, da, ETH_ALEN);
 	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
 	if (sdata->vif.type == NL80211_IFTYPE_AP ||
-	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
+	    sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
 		memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
 	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		memcpy(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN);
@@ -371,13 +372,8 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 	       pubsta->addr, tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 
-	/*
-	 * The aggregation code is not prepared to handle
-	 * anything but STA/AP due to the BSSID handling.
-	 * IBSS could work in the code but isn't supported
-	 * by drivers or the standard.
-	 */
 	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
+	    sdata->vif.type != NL80211_IFTYPE_MESH_POINT &&
 	    sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
 	    sdata->vif.type != NL80211_IFTYPE_AP)
 		return -EINVAL;
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index f80a35c..988c7ec 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -195,7 +195,8 @@ void ieee80211_send_delba(struct ieee80211_sub_if_data *sdata,
 	memcpy(mgmt->da, da, ETH_ALEN);
 	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
 	if (sdata->vif.type == NL80211_IFTYPE_AP ||
-	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
+	    sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
 		memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
 	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		memcpy(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index b867bd5..77d3881 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2203,13 +2203,8 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 
 	switch (mgmt->u.action.category) {
 	case WLAN_CATEGORY_BACK:
-		/*
-		 * The aggregation code is not prepared to handle
-		 * anything but STA/AP due to the BSSID handling;
-		 * IBSS could work in the code but isn't supported
-		 * by drivers or the standard.
-		 */
 		if (sdata->vif.type != NL80211_IFTYPE_STATION &&
+		    sdata->vif.type != NL80211_IFTYPE_MESH_POINT &&
 		    sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
 		    sdata->vif.type != NL80211_IFTYPE_AP)
 			break;
-- 
1.7.5.4

