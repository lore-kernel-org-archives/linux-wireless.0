Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52898 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031061Ab2CFUsm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 15:48:42 -0500
Received: by gghe5 with SMTP id e5so1758599ggh.19
        for <linux-wireless@vger.kernel.org>; Tue, 06 Mar 2012 12:48:41 -0800 (PST)
MIME-Version: 1.0
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: dan.carpenter@oracle.com, Ashok Nagarajan <ashok@cozybit.com>
Subject: [PATCH] mac80211: Fix potential null pointer dereferencing
Date: Tue,  6 Mar 2012 12:48:30 -0800
Message-Id: <1331066910-6041-1-git-send-email-ashok@cozybit.com> (sfid-20120306_214846_739103_45F41814)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch "{nl,cfg,mac}80211: Implement RSSI threshold for mesh peering"
has a potential null pointer dereferencing problem. Thanks to Dan Carpenter
for pointing out. This patch will fix the issue.

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
---
 net/mac80211/mesh_plink.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 80ce527..4e53c4c 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -31,10 +31,11 @@
 #define dot11MeshHoldingTimeout(s) (s->u.mesh.mshcfg.dot11MeshHoldingTimeout)
 #define dot11MeshMaxPeerLinks(s) (s->u.mesh.mshcfg.dot11MeshMaxPeerLinks)
 
-#define sta_meets_rssi_threshold(sta, sdata) \
+/* We only need a valid sta if user configured a minimum rssi_threshold. */
+#define rssi_threshold_check(sta, sdata) \
 		(sdata->u.mesh.mshcfg.rssi_threshold == 0 ||\
-		(s8) -ewma_read(&sta->avg_signal) > \
-		sdata->u.mesh.mshcfg.rssi_threshold)
+		(sta && (s8) -ewma_read(&sta->avg_signal) > \
+		sdata->u.mesh.mshcfg.rssi_threshold))
 
 enum plink_event {
 	PLINK_UNDEFINED,
@@ -307,7 +308,7 @@ void mesh_neighbour_update(u8 *hw_addr, u32 rates,
 			sta->plink_state == NL80211_PLINK_LISTEN &&
 			sdata->u.mesh.accepting_plinks &&
 			sdata->u.mesh.mshcfg.auto_open_plinks &&
-			sta_meets_rssi_threshold(sta, sdata))
+			rssi_threshold_check(sta, sdata))
 		mesh_plink_open(sta);
 
 	rcu_read_unlock();
@@ -538,9 +539,9 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 	}
 
 	if (ftype == WLAN_SP_MESH_PEERING_OPEN &&
-	    !sta_meets_rssi_threshold(sta, sdata)) {
+	    !rssi_threshold_check(sta, sdata)) {
 		mpl_dbg("Mesh plink: %pM does not meet rssi threshold\n",
-			sta->sta.addr);
+			mgmt->sa);
 		rcu_read_unlock();
 		return;
 	}
-- 
1.7.5.4

