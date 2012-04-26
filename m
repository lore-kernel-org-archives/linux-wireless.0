Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:49196 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756444Ab2DZUlo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 16:41:44 -0400
From: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: mesh: Remove un-needed defines
Date: Thu, 26 Apr 2012 23:41:41 +0300
Message-Id: <1335472901-12323-1-git-send-email-Andrei.Emeltchenko.news@gmail.com> (sfid-20120426_224147_731058_C9729D0A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Emeltchenko <andrei.emeltchenko@intel.com>

ieee80211_vif_is_mesh is already defined as:

<------8<--------------------------------------------------------------
|  static inline bool ieee80211_vif_is_mesh(struct ieee80211_vif *vif)
|  {
|  #ifdef CONFIG_MAC80211_MESH
|          return vif->type == NL80211_IFTYPE_MESH_POINT;
|  #endif
|          return false;
|  }
|
<------8<--------------------------------------------------------------

Signed-off-by: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
---
 net/mac80211/cfg.c      |    4 ----
 net/mac80211/rx.c       |    2 --
 net/mac80211/sta_info.c |    4 ----
 3 files changed, 10 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 677d659..72da59d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -404,7 +404,6 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 	rate_idx_to_bitrate(&sinfo->rxrate, sta, sta->last_rx_rate_idx);
 
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
-#ifdef CONFIG_MAC80211_MESH
 		sinfo->filled |= STATION_INFO_LLID |
 				 STATION_INFO_PLID |
 				 STATION_INFO_PLINK_STATE;
@@ -412,7 +411,6 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 		sinfo->llid = le16_to_cpu(sta->llid);
 		sinfo->plid = le16_to_cpu(sta->plid);
 		sinfo->plink_state = sta->plink_state;
-#endif
 	}
 
 	sinfo->bss_param.flags = 0;
@@ -862,7 +860,6 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 						  &sta->sta.ht_cap);
 
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
-#ifdef CONFIG_MAC80211_MESH
 		if (sdata->u.mesh.security & IEEE80211_MESH_SEC_SECURED)
 			switch (params->plink_state) {
 			case NL80211_PLINK_LISTEN:
@@ -883,7 +880,6 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 				mesh_plink_block(sta);
 				break;
 			}
-#endif
 	}
 
 	return 0;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 760d20c..aabdfe7 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2683,10 +2683,8 @@ static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx)
 		CALL_RXH(ieee80211_rx_h_defragment)
 		CALL_RXH(ieee80211_rx_h_michael_mic_verify)
 		/* must be after MMIC verify so header is counted in MPDU mic */
-#ifdef CONFIG_MAC80211_MESH
 		if (ieee80211_vif_is_mesh(&rx->sdata->vif))
 			CALL_RXH(ieee80211_rx_h_mesh_fwding);
-#endif
 		CALL_RXH(ieee80211_rx_h_amsdu)
 		CALL_RXH(ieee80211_rx_h_data)
 		CALL_RXH(ieee80211_rx_h_ctrl);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 38137cb..af85631 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -742,10 +742,8 @@ int __must_check __sta_info_destroy(struct sta_info *sta)
 		__skb_queue_purge(&sta->tx_filtered[ac]);
 	}
 
-#ifdef CONFIG_MAC80211_MESH
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		mesh_accept_plinks_update(sdata);
-#endif
 
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 	wiphy_debug(local->hw.wiphy, "Removed STA %pM\n", sta->sta.addr);
@@ -757,12 +755,10 @@ int __must_check __sta_info_destroy(struct sta_info *sta)
 	rate_control_remove_sta_debugfs(sta);
 	ieee80211_sta_debugfs_remove(sta);
 
-#ifdef CONFIG_MAC80211_MESH
 	if (ieee80211_vif_is_mesh(&sta->sdata->vif)) {
 		mesh_plink_deactivate(sta);
 		del_timer_sync(&sta->plink_timer);
 	}
-#endif
 
 	/*
 	 * Destroy aggregation state here. It would be nice to wait for the
-- 
1.7.9.5

