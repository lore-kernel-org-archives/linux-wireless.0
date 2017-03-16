Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33166 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751023AbdCPB5n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Mar 2017 21:57:43 -0400
Received: by mail-pg0-f65.google.com with SMTP id y17so4138569pgh.0
        for <linux-wireless@vger.kernel.org>; Wed, 15 Mar 2017 18:57:42 -0700 (PDT)
From: Masashi Honma <masashi.honma@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Masashi Honma <masashi.honma@gmail.com>
Subject: [PATCH 2/2] mac80211: Drop new node with weak power
Date: Thu, 16 Mar 2017 10:57:18 +0900
Message-Id: <1489629438-7087-2-git-send-email-masashi.honma@gmail.com> (sfid-20170316_025745_959671_F183E1E8)
In-Reply-To: <1489629438-7087-1-git-send-email-masashi.honma@gmail.com>
References: <1489629438-7087-1-git-send-email-masashi.honma@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On some practical cases, it is useful to drop new node in the distance.
Because mesh metric is calculated with hop count and without RSSI
information, a node far from local peer and near to destination node
could be used as best path.

For example, the nodes are located in linear. Distance of 0 - 1 and
1 - 2 and 2 - 3 is 20meters. 0 to 3 signal is very weak.

    0 --- 1 --- 2 --- 3

Though most robust path from 0 to 3 is 0 -> 1 -> 2 -> 3,
unfortunately, node 0 could recognize node 3 as neighbor. Then node 3
could be next of node 0. This patch aims to avoid such a case.

Signed-off-by: Masashi Honma <masashi.honma@gmail.com>
---
 net/mac80211/mesh.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 6e7b6a0..281d834 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1100,8 +1100,14 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
 		return;
 
-	if (mesh_matches_local(sdata, &elems))
-		mesh_neighbour_update(sdata, mgmt->sa, &elems);
+	if (mesh_matches_local(sdata, &elems)) {
+		mpl_dbg(sdata, "rssi_threshold=%d,rx_status->signal=%d\n",
+			sdata->u.mesh.mshcfg.rssi_threshold, rx_status->signal);
+		if (!sdata->u.mesh.user_mpm ||
+		    sdata->u.mesh.mshcfg.rssi_threshold == 0 ||
+		    sdata->u.mesh.mshcfg.rssi_threshold < rx_status->signal)
+			mesh_neighbour_update(sdata, mgmt->sa, &elems);
+	}
 
 	if (ifmsh->sync_ops)
 		ifmsh->sync_ops->rx_bcn_presp(sdata,
-- 
2.7.4
