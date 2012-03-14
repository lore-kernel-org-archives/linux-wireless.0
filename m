Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:59623 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635Ab2CNU2Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 16:28:16 -0400
Received: by dadp12 with SMTP id p12so3470908dad.11
        for <linux-wireless@vger.kernel.org>; Wed, 14 Mar 2012 13:28:15 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	javier@cozybit.com, ashok@cozybit.com
Subject: [PATCH v3 1/3] mac80211: Record timing offset (Toffset) for all mesh neighbors
Date: Wed, 14 Mar 2012 13:22:45 -0700
Message-Id: <1331756567-5001-1-git-send-email-ashok@cozybit.com> (sfid-20120314_212836_875525_088907EC)
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
 net/mac80211/mesh.c       |    3 ++-
 net/mac80211/mesh.h       |    5 +++--
 net/mac80211/mesh_plink.c |   13 +++++++++++--
 net/mac80211/sta_info.h   |    4 ++++
 4 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index e5fbb7c..492184a 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -652,7 +652,8 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	if (elems.mesh_id && elems.mesh_config &&
 	    mesh_matches_local(&elems, sdata)) {
 		supp_rates = ieee80211_sta_get_rates(local, &elems, band);
-		mesh_neighbour_update(mgmt->sa, supp_rates, sdata, &elems);
+		mesh_neighbour_update(mgmt, supp_rates, sdata, &elems,
+					rx_status);
 	}
 }
 
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 8d53b71..7d5d34b 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -256,9 +256,10 @@ int mesh_path_add_gate(struct mesh_path *mpath);
 int mesh_path_send_to_gates(struct mesh_path *mpath);
 int mesh_gate_num(struct ieee80211_sub_if_data *sdata);
 /* Mesh plinks */
-void mesh_neighbour_update(u8 *hw_addr, u32 rates,
+void mesh_neighbour_update(struct ieee80211_mgmt *mgmt, u32 rates,
 		struct ieee80211_sub_if_data *sdata,
-		struct ieee802_11_elems *ie);
+		struct ieee802_11_elems *ie,
+		struct ieee80211_rx_status *rx_status);
 bool mesh_peer_accepts_plinks(struct ieee802_11_elems *ie);
 void mesh_accept_plinks_update(struct ieee80211_sub_if_data *sdata);
 void mesh_plink_broken(struct sta_info *sta);
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 4e53c4c..8ba5f5e 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -274,12 +274,14 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-void mesh_neighbour_update(u8 *hw_addr, u32 rates,
+void mesh_neighbour_update(struct ieee80211_mgmt *mgmt, u32 rates,
 		struct ieee80211_sub_if_data *sdata,
-		struct ieee802_11_elems *elems)
+		struct ieee802_11_elems *elems,
+		struct ieee80211_rx_status *rx_status)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
+	u8 *hw_addr = mgmt->sa;
 
 	rcu_read_lock();
 
@@ -304,6 +306,13 @@ void mesh_neighbour_update(u8 *hw_addr, u32 rates,
 
 	sta->last_rx = jiffies;
 	sta->sta.supp_rates[local->hw.conf.channel->band] = rates;
+	clear_sta_flag(sta, WLAN_STA_TOFFSET_KNOWN);
+	if (rx_status->flag & RX_FLAG_MACTIME_MPDU) {
+		sta->t_offset = le64_to_cpu(mgmt->u.beacon.timestamp) -
+				rx_status->mactime;
+		set_sta_flag(sta, WLAN_STA_TOFFSET_KNOWN);
+	}
+
 	if (mesh_peer_accepts_plinks(elems) &&
 			sta->plink_state == NL80211_PLINK_LISTEN &&
 			sdata->u.mesh.accepting_plinks &&
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index ab05768..7a607bc 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -55,6 +55,7 @@
  * @WLAN_STA_4ADDR_EVENT: 4-addr event was already sent for this frame.
  * @WLAN_STA_INSERTED: This station is inserted into the hash table.
  * @WLAN_STA_RATE_CONTROL: rate control was initialized for this station.
+ * @WLAN_STA_TOFFSET_KNOWN: toffset calcuated for this station is valid.
  */
 enum ieee80211_sta_info_flags {
 	WLAN_STA_AUTH,
@@ -76,6 +77,7 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_4ADDR_EVENT,
 	WLAN_STA_INSERTED,
 	WLAN_STA_RATE_CONTROL,
+	WLAN_STA_TOFFSET_KNOWN,
 };
 
 #define STA_TID_NUM 16
@@ -264,6 +266,7 @@ struct sta_ampdu_mlme {
  * @plink_timeout: timeout of peer link
  * @plink_timer: peer link watch timer
  * @plink_timer_was_running: used by suspend/resume to restore timers
+ * @t_offset: timing offset relative to this host
  * @debugfs: debug filesystem info
  * @dead: set to true when sta is unlinked
  * @uploaded: set to true when sta is uploaded to the driver
@@ -353,6 +356,7 @@ struct sta_info {
 	enum nl80211_plink_state plink_state;
 	u32 plink_timeout;
 	struct timer_list plink_timer;
+	s64 t_offset;
 #endif
 
 #ifdef CONFIG_MAC80211_DEBUGFS
-- 
1.7.5.4

