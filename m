Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:32861 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753834AbcK3WpB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Nov 2016 17:45:01 -0500
Received: by mail-pg0-f66.google.com with SMTP id 3so2553268pgd.0
        for <linux-wireless@vger.kernel.org>; Wed, 30 Nov 2016 14:45:01 -0800 (PST)
From: Masashi Honma <masashi.honma@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, me@bobcopeland.com,
        Masashi Honma <masashi.honma@gmail.com>
Subject: [PATCH] mac80211: Remove invalid flag operations in mesh TSF synchronization
Date: Thu,  1 Dec 2016 07:44:49 +0900
Message-Id: <1480545889-3690-1-git-send-email-masashi.honma@gmail.com> (sfid-20161130_234505_229999_A95BA886)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mesh_sync_offset_adjust_tbtt() implements Extensible synchronization
framework ([1] 13.13.2 Extensible synchronization framework). It shall
not operate the flag "TBTT Adjusting subfield" ([1] 8.4.2.100.8 Mesh
Capability), since it is used only for MBCA ([1] 13.13.4 Mesh beacon
collision avoidance, see 13.13.4.4.3 TBTT scanning and adjustment
procedures for detail). So this patch remove the flag operations.

[1] IEEE Std 802.11 2012

Signed-off-by: Masashi Honma <masashi.honma@gmail.com>
---
 net/mac80211/mesh_sync.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/net/mac80211/mesh_sync.c b/net/mac80211/mesh_sync.c
index faca22c..836d791 100644
--- a/net/mac80211/mesh_sync.c
+++ b/net/mac80211/mesh_sync.c
@@ -172,11 +172,9 @@ static void mesh_sync_offset_adjust_tbtt(struct ieee80211_sub_if_data *sdata,
 					 struct beacon_data *beacon)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
-	u8 cap;
 
 	WARN_ON(ifmsh->mesh_sp_id != IEEE80211_SYNC_METHOD_NEIGHBOR_OFFSET);
 	WARN_ON(!rcu_read_lock_held());
-	cap = beacon->meshconf->meshconf_cap;
 
 	spin_lock_bh(&ifmsh->sync_offset_lock);
 
@@ -190,21 +188,13 @@ static void mesh_sync_offset_adjust_tbtt(struct ieee80211_sub_if_data *sdata,
 			  "TBTT : kicking off TBTT adjustment with clockdrift_max=%lld\n",
 			  ifmsh->sync_offset_clockdrift_max);
 		set_bit(MESH_WORK_DRIFT_ADJUST, &ifmsh->wrkq_flags);
-
-		ifmsh->adjusting_tbtt = true;
 	} else {
 		msync_dbg(sdata,
 			  "TBTT : max clockdrift=%lld; too small to adjust\n",
 			  (long long)ifmsh->sync_offset_clockdrift_max);
 		ifmsh->sync_offset_clockdrift_max = 0;
-
-		ifmsh->adjusting_tbtt = false;
 	}
 	spin_unlock_bh(&ifmsh->sync_offset_lock);
-
-	beacon->meshconf->meshconf_cap = ifmsh->adjusting_tbtt ?
-			IEEE80211_MESHCONF_CAPAB_TBTT_ADJUSTING | cap :
-			~IEEE80211_MESHCONF_CAPAB_TBTT_ADJUSTING & cap;
 }
 
 static const struct sync_method sync_methods[] = {
-- 
2.7.4
