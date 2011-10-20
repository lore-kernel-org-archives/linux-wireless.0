Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37571 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249Ab1JTBDk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Oct 2011 21:03:40 -0400
Received: by mail-iy0-f174.google.com with SMTP id k3so2770432iae.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Oct 2011 18:03:40 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: anagar6@uic.edu, devel@lists.open80211s.org,
	Thomas Pedersen <thomas@cozybit.com>,
	johannes@sipsolutions.net, linville@tuxdriver.com
Subject: [PATCH 4/6] mac80211: allow frame aggregation for mesh
Date: Wed, 19 Oct 2011 18:03:24 -0700
Message-Id: <1319072606-28291-5-git-send-email-thomas@cozybit.com> (sfid-20111020_030343_946122_F793A161)
In-Reply-To: <1319072606-28291-1-git-send-email-thomas@cozybit.com>
References: <1319072606-28291-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
Signed-off-by: Ashok Nagarajan <anagar6@uic.edu>
---
 net/mac80211/agg-rx.c |    3 ++-
 net/mac80211/agg-tx.c |    4 +++-
 net/mac80211/ht.c     |    3 ++-
 net/mac80211/rx.c     |    1 +
 4 files changed, 8 insertions(+), 3 deletions(-)

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
index 2ac0339..36c2836 100644
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
@@ -378,6 +379,7 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 	 * by drivers or the standard.
 	 */
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
index 8c03d6e..554b5b7 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2215,6 +2215,7 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 		 * by drivers or the standard.
 		 */
 		if (sdata->vif.type != NL80211_IFTYPE_STATION &&
+		    sdata->vif.type != NL80211_IFTYPE_MESH_POINT &&
 		    sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
 		    sdata->vif.type != NL80211_IFTYPE_AP)
 			break;
-- 
1.7.5.4

