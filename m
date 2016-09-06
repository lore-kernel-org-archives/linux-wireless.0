Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52295 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933499AbcIFTAK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Sep 2016 15:00:10 -0400
From: Thomas Pedersen <twp@qca.qualcomm.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
        Thomas Pedersen <twp@qca.qualcomm.com>
Subject: [PATCH] mac80211: make mpath path fixing more robust
Date: Tue, 6 Sep 2016 11:59:00 -0700
Message-ID: <1473188340-13620-1-git-send-email-twp@qca.qualcomm.com> (sfid-20160906_210030_826930_3549A6D1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A fixed mpath was not quite being treated as such:

1) if a PERR frame was received, a fixed mpath was
   deactivated.

2) queued path discovery for fixed mpath was potentially
   being considered, changing mpath state.

3) other mpath flags were potentially being inherited when
   fixing the mpath. Just assign PATH_FIXED and SN_VALID.

This solves several issues when fixing a mesh path in one
direction. The reverse direction mpath should probably
also be fixed, or root announcements at least be enabled.

Signed-off-by: Thomas Pedersen <twp@qca.qualcomm.com>
---
 net/mac80211/mesh_hwmp.c    | 3 ++-
 net/mac80211/mesh_pathtbl.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index fa7d37c..b747c96 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -757,6 +757,7 @@ static void hwmp_perr_frame_process(struct ieee80211_sub_if_data *sdata,
 		sta = next_hop_deref_protected(mpath);
 		if (mpath->flags & MESH_PATH_ACTIVE &&
 		    ether_addr_equal(ta, sta->sta.addr) &&
+		    !(mpath->flags & MESH_PATH_FIXED) &&
 		    (!(mpath->flags & MESH_PATH_SN_VALID) ||
 		    SN_GT(target_sn, mpath->sn)  || target_sn == 0)) {
 			mpath->flags &= ~MESH_PATH_ACTIVE;
@@ -1023,7 +1024,7 @@ void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata)
 		goto enddiscovery;
 
 	spin_lock_bh(&mpath->state_lock);
-	if (mpath->flags & MESH_PATH_DELETED) {
+	if (mpath->flags & (MESH_PATH_DELETED | MESH_PATH_FIXED)) {
 		spin_unlock_bh(&mpath->state_lock);
 		goto enddiscovery;
 	}
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 6db2ddf..8e3d2d1 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -826,7 +826,7 @@ void mesh_path_fix_nexthop(struct mesh_path *mpath, struct sta_info *next_hop)
 	mpath->metric = 0;
 	mpath->hop_count = 0;
 	mpath->exp_time = 0;
-	mpath->flags |= MESH_PATH_FIXED;
+	mpath->flags = (MESH_PATH_FIXED | MESH_PATH_SN_VALID);
 	mesh_path_activate(mpath);
 	spin_unlock_bh(&mpath->state_lock);
 	mesh_path_tx_pending(mpath);
-- 
2.1.4
