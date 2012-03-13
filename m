Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64507 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab2CMTrj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Mar 2012 15:47:39 -0400
Received: by yhmm54 with SMTP id m54so946448yhm.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Mar 2012 12:47:38 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	javier@cozybit.com, ashok@cozybit.com
Subject: [PATCH v2 1/3] mac80211: Record timing offset (Toffset) for all mesh neighbors
Date: Tue, 13 Mar 2012 12:47:23 -0700
Message-Id: <1331668045-16384-1-git-send-email-ashok@cozybit.com> (sfid-20120313_204748_830801_1F3B412A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

802.11s standard introduced timing offset calculation by mesh stations. The
mesh STA shall calculate the timing offset value with respect to the neighbor
STA with which it maintains synchronization.
	Toffset = timestamp from beacon/probe response frames -
		  frame reception time (mactime).

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh.c       |    8 +++++++-
 net/mac80211/mesh.h       |    2 +-
 net/mac80211/mesh_plink.c |    3 ++-
 net/mac80211/sta_info.h   |    2 ++
 4 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index e5fbb7c..bbf5807 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -621,6 +621,7 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	u32 supp_rates = 0;
 	size_t baselen;
 	int freq;
+	s64 t_offset = 0;
 	enum ieee80211_band band = rx_status->band;
 
 	/* ignore ProbeResp to foreign address */
@@ -649,10 +650,15 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
 		return;
 
+	if (rx_status->flag & RX_FLAG_MACTIME_MPDU)
+		t_offset = le64_to_cpu(mgmt->u.beacon.timestamp) -
+			   rx_status->mactime;
+
 	if (elems.mesh_id && elems.mesh_config &&
 	    mesh_matches_local(&elems, sdata)) {
 		supp_rates = ieee80211_sta_get_rates(local, &elems, band);
-		mesh_neighbour_update(mgmt->sa, supp_rates, sdata, &elems);
+		mesh_neighbour_update(mgmt->sa, supp_rates, sdata, &elems,
+					t_offset);
 	}
 }
 
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 8d53b71..d867cc8 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -258,7 +258,7 @@ int mesh_gate_num(struct ieee80211_sub_if_data *sdata);
 /* Mesh plinks */
 void mesh_neighbour_update(u8 *hw_addr, u32 rates,
 		struct ieee80211_sub_if_data *sdata,
-		struct ieee802_11_elems *ie);
+		struct ieee802_11_elems *ie, s64 t_offset);
 bool mesh_peer_accepts_plinks(struct ieee802_11_elems *ie);
 void mesh_accept_plinks_update(struct ieee80211_sub_if_data *sdata);
 void mesh_plink_broken(struct sta_info *sta);
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 4e53c4c..06e5180 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -276,7 +276,7 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 
 void mesh_neighbour_update(u8 *hw_addr, u32 rates,
 		struct ieee80211_sub_if_data *sdata,
-		struct ieee802_11_elems *elems)
+		struct ieee802_11_elems *elems, s64 t_offset)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
@@ -304,6 +304,7 @@ void mesh_neighbour_update(u8 *hw_addr, u32 rates,
 
 	sta->last_rx = jiffies;
 	sta->sta.supp_rates[local->hw.conf.channel->band] = rates;
+	sta->t_offset = t_offset;
 	if (mesh_peer_accepts_plinks(elems) &&
 			sta->plink_state == NL80211_PLINK_LISTEN &&
 			sdata->u.mesh.accepting_plinks &&
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index ab05768..764eb65 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -264,6 +264,7 @@ struct sta_ampdu_mlme {
  * @plink_timeout: timeout of peer link
  * @plink_timer: peer link watch timer
  * @plink_timer_was_running: used by suspend/resume to restore timers
+ * @t_offset: timing offset relative to this host
  * @debugfs: debug filesystem info
  * @dead: set to true when sta is unlinked
  * @uploaded: set to true when sta is uploaded to the driver
@@ -353,6 +354,7 @@ struct sta_info {
 	enum nl80211_plink_state plink_state;
 	u32 plink_timeout;
 	struct timer_list plink_timer;
+	s64 t_offset;
 #endif
 
 #ifdef CONFIG_MAC80211_DEBUGFS
-- 
1.7.5.4

