Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:36539 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750877AbdCQGAD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Mar 2017 02:00:03 -0400
Received: by mail-pg0-f66.google.com with SMTP id 81so486086pgh.3
        for <linux-wireless@vger.kernel.org>; Thu, 16 Mar 2017 23:00:03 -0700 (PDT)
From: Masashi Honma <masashi.honma@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Masashi Honma <masashi.honma@gmail.com>
Subject: [PATCH v2] mac80211: Use rssi_threshold even though user_mpm=1
Date: Fri, 17 Mar 2017 14:59:44 +0900
Message-Id: <1489730384-2799-1-git-send-email-masashi.honma@gmail.com> (sfid-20170317_070006_207100_563EB2F1)
In-Reply-To: <1489629438-7087-1-git-send-email-masashi.honma@gmail.com>
References: <1489629438-7087-1-git-send-email-masashi.honma@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously the meshcfg.rssi_threshold did not work with user_mpm=1.

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
