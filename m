Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:62180 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab3ENAIN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 May 2013 20:08:13 -0400
Received: by mail-pa0-f42.google.com with SMTP id bj3so3523pad.15
        for <linux-wireless@vger.kernel.org>; Mon, 13 May 2013 17:08:13 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	devel@lists.open80211s.org, javier@cozybit.com, ashok@cozybit.com
Subject: [PATCH] mac80211: Move mesh estab_plinks outside mesh_stats debug group
Date: Mon, 13 May 2013 17:08:04 -0700
Message-Id: <1368490084-10711-1-git-send-email-ashok@cozybit.com> (sfid-20130514_020818_618372_F4B39FE4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As estab_plinks is not a statistics member, don't show its debug information
along with other mesh stat members

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
---
 net/mac80211/debugfs_netdev.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 14abcf4..f83074f 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -471,6 +471,8 @@ __IEEE80211_IF_FILE_W(tsf);
 IEEE80211_IF_FILE(peer, u.wds.remote_addr, MAC);
 
 #ifdef CONFIG_MAC80211_MESH
+IEEE80211_IF_FILE(estab_plinks, u.mesh.estab_plinks, ATOMIC);
+
 /* Mesh stats attributes */
 IEEE80211_IF_FILE(fwded_mcast, u.mesh.mshstats.fwded_mcast, DEC);
 IEEE80211_IF_FILE(fwded_unicast, u.mesh.mshstats.fwded_unicast, DEC);
@@ -480,7 +482,6 @@ IEEE80211_IF_FILE(dropped_frames_congestion,
 		  u.mesh.mshstats.dropped_frames_congestion, DEC);
 IEEE80211_IF_FILE(dropped_frames_no_route,
 		  u.mesh.mshstats.dropped_frames_no_route, DEC);
-IEEE80211_IF_FILE(estab_plinks, u.mesh.estab_plinks, ATOMIC);
 
 /* Mesh parameters */
 IEEE80211_IF_FILE(dot11MeshMaxRetries,
@@ -583,6 +584,7 @@ static void add_wds_files(struct ieee80211_sub_if_data *sdata)
 static void add_mesh_files(struct ieee80211_sub_if_data *sdata)
 {
 	DEBUGFS_ADD_MODE(tsf, 0600);
+	DEBUGFS_ADD_MODE(estab_plinks, 0400);
 }
 
 static void add_mesh_stats(struct ieee80211_sub_if_data *sdata)
@@ -598,7 +600,6 @@ static void add_mesh_stats(struct ieee80211_sub_if_data *sdata)
 	MESHSTATS_ADD(dropped_frames_ttl);
 	MESHSTATS_ADD(dropped_frames_no_route);
 	MESHSTATS_ADD(dropped_frames_congestion);
-	MESHSTATS_ADD(estab_plinks);
 #undef MESHSTATS_ADD
 }
 
-- 
1.7.5.4

