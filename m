Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34263 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932966AbcLHBQM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 20:16:12 -0500
Received: by mail-pf0-f195.google.com with SMTP id y68so21305149pfb.1
        for <linux-wireless@vger.kernel.org>; Wed, 07 Dec 2016 17:16:03 -0800 (PST)
From: Masashi Honma <masashi.honma@gmail.com>
To: johannes@sipsolutions.net, me@bobcopeland.com
Cc: linux-wireless@vger.kernel.org,
        Masashi Honma <masashi.honma@gmail.com>
Subject: [PATCH v2 1/2] mac80211: Remove invalid flag operations in mesh TSF synchronization
Date: Thu,  8 Dec 2016 10:15:50 +0900
Message-Id: <1481159751-4097-1-git-send-email-masashi.honma@gmail.com> (sfid-20161208_021616_178371_DA2E20E5)
In-Reply-To: <1480545889-3690-1-git-send-email-masashi.honma@gmail.com>
References: <1480545889-3690-1-git-send-email-masashi.honma@gmail.com>
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
 net/mac80211/mesh_sync.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/net/mac80211/mesh_sync.c b/net/mac80211/mesh_sync.c
index faca22c..75608c0 100644
--- a/net/mac80211/mesh_sync.c
+++ b/net/mac80211/mesh_sync.c
@@ -123,7 +123,6 @@ static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	 */
 
 	if (elems->mesh_config && mesh_peer_tbtt_adjusting(elems)) {
-		clear_sta_flag(sta, WLAN_STA_TOFFSET_KNOWN);
 		msync_dbg(sdata, "STA %pM : is adjusting TBTT\n",
 			  sta->sta.addr);
 		goto no_sync;
@@ -172,11 +171,9 @@ static void mesh_sync_offset_adjust_tbtt(struct ieee80211_sub_if_data *sdata,
 					 struct beacon_data *beacon)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
-	u8 cap;
 
 	WARN_ON(ifmsh->mesh_sp_id != IEEE80211_SYNC_METHOD_NEIGHBOR_OFFSET);
 	WARN_ON(!rcu_read_lock_held());
-	cap = beacon->meshconf->meshconf_cap;
 
 	spin_lock_bh(&ifmsh->sync_offset_lock);
 
@@ -190,21 +187,13 @@ static void mesh_sync_offset_adjust_tbtt(struct ieee80211_sub_if_data *sdata,
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
