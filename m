Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:38192 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758265Ab3JOK3s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 06:29:48 -0400
Received: by mail-bk0-f49.google.com with SMTP id w14so63991bkz.36
        for <linux-wireless@vger.kernel.org>; Tue, 15 Oct 2013 03:29:47 -0700 (PDT)
From: Marco Porsch <marco@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Marco Porsch <marco@cozybit.com>
Subject: [PATCH] mac80211: fixes for mesh powersave logic
Date: Tue, 15 Oct 2013 12:29:24 +0200
Message-Id: <1381832964-3684-1-git-send-email-marco@cozybit.com> (sfid-20131015_122952_414896_D4FBE8A3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes errors in the mesh powersave logic which
cause that remote peers do not get peer power mode change
notifications and mesh peer service periods (MPSPs) got
stuck.

When closing a peer link, set the (now invalid) peer-specific
power mode to 'unknown'.

Avoid overhead when local power mode is unchanged.

Reliably clear MPSP flags on peering status update.

Avoid MPSP flags getting stuck by not requesting a further
MPSP ownership if we already are an MPSP owner.

Signed-off-by: Marco Porsch <marco@cozybit.com>
---
 net/mac80211/cfg.c        |  4 ++--
 net/mac80211/mesh_plink.c |  3 ++-
 net/mac80211/mesh_ps.c    | 33 ++++++++++++++++++---------------
 3 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index b0a651c..f1e1944 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1342,8 +1342,8 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 				sta->plink_state = params->plink_state;
 
 				ieee80211_mps_sta_status_update(sta);
-				changed |=
-				      ieee80211_mps_local_status_update(sdata);
+				changed |= ieee80211_mps_set_sta_local_pm(sta,
+						NL80211_MESH_POWER_UNKNOWN);
 				break;
 			default:
 				/*  nothing  */
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 6b65d50..4301aa5 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -222,7 +222,8 @@ static u32 __mesh_plink_deactivate(struct sta_info *sta)
 	mesh_path_flush_by_nexthop(sta);
 
 	ieee80211_mps_sta_status_update(sta);
-	changed |= ieee80211_mps_local_status_update(sdata);
+	changed |= ieee80211_mps_set_sta_local_pm(sta,
+			NL80211_MESH_POWER_UNKNOWN);
 
 	return changed;
 }
diff --git a/net/mac80211/mesh_ps.c b/net/mac80211/mesh_ps.c
index 22290a9..0f79b78 100644
--- a/net/mac80211/mesh_ps.c
+++ b/net/mac80211/mesh_ps.c
@@ -152,6 +152,9 @@ u32 ieee80211_mps_set_sta_local_pm(struct sta_info *sta,
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 
+	if (sta->local_pm == pm)
+		return 0;
+
 	mps_dbg(sdata, "local STA operates in mode %d with %pM\n",
 		pm, sta->sta.addr);
 
@@ -245,6 +248,14 @@ void ieee80211_mps_sta_status_update(struct sta_info *sta)
 
 	do_buffer = (pm != NL80211_MESH_POWER_ACTIVE);
 
+	/* clear the MPSP flags for non-peers or active STA */
+	if (sta->plink_state != NL80211_PLINK_ESTAB) {
+		clear_sta_flag(sta, WLAN_STA_MPSP_OWNER);
+		clear_sta_flag(sta, WLAN_STA_MPSP_RECIPIENT);
+	} else if (!do_buffer) {
+		clear_sta_flag(sta, WLAN_STA_MPSP_OWNER);
+	}
+
 	/* Don't let the same PS state be set twice */
 	if (test_sta_flag(sta, WLAN_STA_PS_STA) == do_buffer)
 		return;
@@ -257,14 +268,6 @@ void ieee80211_mps_sta_status_update(struct sta_info *sta)
 	} else {
 		ieee80211_sta_ps_deliver_wakeup(sta);
 	}
-
-	/* clear the MPSP flags for non-peers or active STA */
-	if (sta->plink_state != NL80211_PLINK_ESTAB) {
-		clear_sta_flag(sta, WLAN_STA_MPSP_OWNER);
-		clear_sta_flag(sta, WLAN_STA_MPSP_RECIPIENT);
-	} else if (!do_buffer) {
-		clear_sta_flag(sta, WLAN_STA_MPSP_OWNER);
-	}
 }
 
 static void mps_set_sta_peer_pm(struct sta_info *sta,
@@ -444,8 +447,7 @@ static void mpsp_qos_null_append(struct sta_info *sta,
  */
 static void mps_frame_deliver(struct sta_info *sta, int n_frames)
 {
-	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_local *local = sta->sdata->local;
 	int ac;
 	struct sk_buff_head frames;
 	struct sk_buff *skb;
@@ -558,10 +560,10 @@ void ieee80211_mpsp_trigger_process(u8 *qc, struct sta_info *sta,
 }
 
 /**
- * ieee80211_mps_frame_release - release buffered frames in response to beacon
+ * ieee80211_mps_frame_release - release frames buffered due to mesh power save
  *
  * @sta: mesh STA
- * @elems: beacon IEs
+ * @elems: IEs of beacon or probe response
  *
  * For peers if we have individually-addressed frames buffered or the peer
  * indicates buffered frames, send a corresponding MPSP trigger frame. Since
@@ -588,9 +590,10 @@ void ieee80211_mps_frame_release(struct sta_info *sta,
 	    (!elems->awake_window || !le16_to_cpu(*elems->awake_window)))
 		return;
 
-	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
-		buffer_local += skb_queue_len(&sta->ps_tx_buf[ac]) +
-				skb_queue_len(&sta->tx_filtered[ac]);
+	if (!test_sta_flag(sta, WLAN_STA_MPSP_OWNER))
+		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
+			buffer_local += skb_queue_len(&sta->ps_tx_buf[ac]) +
+					skb_queue_len(&sta->tx_filtered[ac]);
 
 	if (!has_buffered && !buffer_local)
 		return;
-- 
1.8.1.2

