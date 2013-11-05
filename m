Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:56142 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830Ab3KETWu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 14:22:50 -0500
Received: by mail-pa0-f45.google.com with SMTP id kp14so9357464pab.32
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 11:22:49 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bob Copeland <me@bobcopeland.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Subject: [PATCH 06/17] mac80211: mesh: rewrite rssi_threshold_check in C
Date: Tue,  5 Nov 2013 11:16:54 -0800
Message-Id: <1383679025-7150-6-git-send-email-thomas@cozybit.com> (sfid-20131105_202301_756566_D6FA744F)
In-Reply-To: <1383679025-7150-1-git-send-email-thomas@cozybit.com>
References: <1383679025-7150-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bob Copeland <me@bobcopeland.com>

Use C instead of cpp for type checking.  Also swap the arguments
into the usual sdata -> sta order.

Signed-off-by: Bob Copeland <bob@cozybit.com>
---
 net/mac80211/mesh_plink.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 5048658..36b6cff 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -19,12 +19,6 @@
 #define mod_plink_timer(s, t) (mod_timer(&s->plink_timer, \
 				jiffies + HZ * t / 1000))
 
-/* We only need a valid sta if user configured a minimum rssi_threshold. */
-#define rssi_threshold_check(sta, sdata) \
-		(sdata->u.mesh.mshcfg.rssi_threshold == 0 ||\
-		(sta && (s8) -ewma_read(&sta->avg_signal) > \
-		sdata->u.mesh.mshcfg.rssi_threshold))
-
 enum plink_event {
 	PLINK_UNDEFINED,
 	OPN_ACPT,
@@ -63,6 +57,16 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 			       enum ieee80211_self_protected_actioncode action,
 			       u8 *da, __le16 llid, __le16 plid, __le16 reason);
 
+
+/* We only need a valid sta if user configured a minimum rssi_threshold. */
+static bool rssi_threshold_check(struct ieee80211_sub_if_data *sdata,
+				 struct sta_info *sta)
+{
+	s32 rssi_threshold = sdata->u.mesh.mshcfg.rssi_threshold;
+	return rssi_threshold == 0 ||
+	       (sta && (s8) -ewma_read(&sta->avg_signal) > rssi_threshold);
+}
+
 /**
  * mesh_plink_fsm_restart - restart a mesh peer link finite state machine
  *
@@ -518,7 +522,7 @@ void mesh_neighbour_update(struct ieee80211_sub_if_data *sdata,
 	    sta->plink_state == NL80211_PLINK_LISTEN &&
 	    sdata->u.mesh.accepting_plinks &&
 	    sdata->u.mesh.mshcfg.auto_open_plinks &&
-	    rssi_threshold_check(sta, sdata))
+	    rssi_threshold_check(sdata, sta))
 		changed = mesh_plink_open(sta);
 
 	ieee80211_mps_frame_release(sta, elems);
@@ -776,7 +780,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 			mesh_matches_local(sdata, &elems);
 
 	if (ftype == WLAN_SP_MESH_PEERING_OPEN &&
-	    !rssi_threshold_check(sta, sdata)) {
+	    !rssi_threshold_check(sdata, sta)) {
 		mpl_dbg(sdata, "Mesh plink: %pM does not meet rssi threshold\n",
 			mgmt->sa);
 		rcu_read_unlock();
-- 
1.8.4.rc3

