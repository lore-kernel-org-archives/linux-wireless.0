Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:36697 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759002AbcAUNpo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 08:45:44 -0500
Received: by mail-lb0-f177.google.com with SMTP id oh2so23416745lbb.3
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2016 05:45:43 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 05/13] ath10k: add fast peer_map lookup
Date: Thu, 21 Jan 2016 14:46:38 +0100
Message-Id: <1453384006-31907-6-git-send-email-michal.kazior@tieto.com> (sfid-20160121_144555_086738_9FDE12A0)
In-Reply-To: <1453384006-31907-1-git-send-email-michal.kazior@tieto.com>
References: <1453384006-31907-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The pull-push functionality of 10.4 will be based
on peer_id and tid. These will need to be mapped,
eventually, to ieee80211_txq to be used with
ieee80211_tx_dequeue().

Iterating over existing stations every time
peer_id needs to be mapped to a station would be
inefficient wrt CPU time.

The new firmware, which will be the only user of
the code flow-wise, will guarantee to use low
peer_ids first so despite peer_map's apparent huge
size d-cache thrashing should not be a problem.

Older firmware hot paths will effectively not use
peer_map.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h |  4 ++
 drivers/net/wireless/ath/ath10k/mac.c  | 71 +++++++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/txrx.c |  2 +
 3 files changed, 71 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 4b19c71bf6a5..bc0e546c79d4 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -293,6 +293,9 @@ struct ath10k_dfs_stats {
 
 struct ath10k_peer {
 	struct list_head list;
+	struct ieee80211_vif *vif;
+	struct ieee80211_sta *sta;
+
 	int vdev_id;
 	u8 addr[ETH_ALEN];
 	DECLARE_BITMAP(peer_ids, ATH10K_MAX_NUM_PEER_IDS);
@@ -780,6 +783,7 @@ struct ath10k {
 
 	struct list_head arvifs;
 	struct list_head peers;
+	struct ath10k_peer *peer_map[ATH10K_MAX_NUM_PEER_IDS];
 	wait_queue_head_t peer_mapping_wq;
 
 	/* protected by conf_mutex */
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index ec4fae8dcb92..00789afa5dec 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -618,10 +618,15 @@ ath10k_mac_get_any_chandef_iter(struct ieee80211_hw *hw,
 	*def = &conf->def;
 }
 
-static int ath10k_peer_create(struct ath10k *ar, u32 vdev_id, const u8 *addr,
+static int ath10k_peer_create(struct ath10k *ar,
+			      struct ieee80211_vif *vif,
+			      struct ieee80211_sta *sta,
+			      u32 vdev_id,
+			      const u8 *addr,
 			      enum wmi_peer_type peer_type)
 {
 	struct ath10k_vif *arvif;
+	struct ath10k_peer *peer;
 	int num_peers = 0;
 	int ret;
 
@@ -650,6 +655,22 @@ static int ath10k_peer_create(struct ath10k *ar, u32 vdev_id, const u8 *addr,
 		return ret;
 	}
 
+	spin_lock_bh(&ar->data_lock);
+
+	peer = ath10k_peer_find(ar, vdev_id, addr);
+	if (!peer) {
+		ath10k_warn(ar, "failed to find peer %pM on vdev %i after creation\n",
+			    addr, vdev_id);
+		ath10k_wmi_peer_delete(ar, vdev_id, addr);
+		spin_unlock_bh(&ar->data_lock);
+		return -ENOENT;
+	}
+
+	peer->vif = vif;
+	peer->sta = sta;
+
+	spin_unlock_bh(&ar->data_lock);
+
 	ar->num_peers++;
 
 	return 0;
@@ -731,6 +752,7 @@ static int ath10k_peer_delete(struct ath10k *ar, u32 vdev_id, const u8 *addr)
 static void ath10k_peer_cleanup(struct ath10k *ar, u32 vdev_id)
 {
 	struct ath10k_peer *peer, *tmp;
+	int peer_id;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
@@ -742,6 +764,11 @@ static void ath10k_peer_cleanup(struct ath10k *ar, u32 vdev_id)
 		ath10k_warn(ar, "removing stale peer %pM from vdev_id %d\n",
 			    peer->addr, vdev_id);
 
+		for_each_set_bit(peer_id, peer->peer_ids,
+				 ATH10K_MAX_NUM_PEER_IDS) {
+			ar->peer_map[peer_id] = NULL;
+		}
+
 		list_del(&peer->list);
 		kfree(peer);
 		ar->num_peers--;
@@ -3510,7 +3537,8 @@ void ath10k_offchan_tx_work(struct work_struct *work)
 				   peer_addr, vdev_id);
 
 		if (!peer) {
-			ret = ath10k_peer_create(ar, vdev_id, peer_addr,
+			ret = ath10k_peer_create(ar, NULL, NULL, vdev_id,
+						 peer_addr,
 						 WMI_PEER_TYPE_DEFAULT);
 			if (ret)
 				ath10k_warn(ar, "failed to create peer %pM on vdev %d: %d\n",
@@ -4599,8 +4627,8 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 
 	if (arvif->vdev_type == WMI_VDEV_TYPE_AP ||
 	    arvif->vdev_type == WMI_VDEV_TYPE_IBSS) {
-		ret = ath10k_peer_create(ar, arvif->vdev_id, vif->addr,
-					 WMI_PEER_TYPE_DEFAULT);
+		ret = ath10k_peer_create(ar, vif, NULL, arvif->vdev_id,
+					 vif->addr, WMI_PEER_TYPE_DEFAULT);
 		if (ret) {
 			ath10k_warn(ar, "failed to create vdev %i peer for AP/IBSS: %d\n",
 				    arvif->vdev_id, ret);
@@ -4734,7 +4762,9 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 {
 	struct ath10k *ar = hw->priv;
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
+	struct ath10k_peer *peer;
 	int ret;
+	int i;
 
 	cancel_work_sync(&arvif->ap_csa_work);
 	cancel_delayed_work_sync(&arvif->connection_loss_work);
@@ -4788,6 +4818,20 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 		spin_unlock_bh(&ar->data_lock);
 	}
 
+	spin_lock_bh(&ar->data_lock);
+	for (i = 0; i < ARRAY_SIZE(ar->peer_map); i++) {
+		peer = ar->peer_map[i];
+		if (!peer)
+			continue;
+
+		if (peer->vif == vif) {
+			ath10k_warn(ar, "found vif peer %pM entry on vdev %i after it was supposedly removed\n",
+				    vif->addr, arvif->vdev_id);
+			peer->vif = NULL;
+		}
+	}
+	spin_unlock_bh(&ar->data_lock);
+
 	ath10k_peer_cleanup(ar, arvif->vdev_id);
 
 	if (vif->type == NL80211_IFTYPE_MONITOR) {
@@ -5507,6 +5551,7 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 	struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
 	struct ath10k_peer *peer;
 	int ret = 0;
+	int i;
 
 	if (old_state == IEEE80211_STA_NOTEXIST &&
 	    new_state == IEEE80211_STA_NONE) {
@@ -5547,8 +5592,8 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 		if (sta->tdls)
 			peer_type = WMI_PEER_TYPE_TDLS;
 
-		ret = ath10k_peer_create(ar, arvif->vdev_id, sta->addr,
-					 peer_type);
+		ret = ath10k_peer_create(ar, vif, sta, arvif->vdev_id,
+					 sta->addr, peer_type);
 		if (ret) {
 			ath10k_warn(ar, "failed to add peer %pM for vdev %d when adding a new sta: %i\n",
 				    sta->addr, arvif->vdev_id, ret);
@@ -5636,6 +5681,20 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 
 		ath10k_mac_dec_num_stations(arvif, sta);
 
+		spin_lock_bh(&ar->data_lock);
+		for (i = 0; i < ARRAY_SIZE(ar->peer_map); i++) {
+			peer = ar->peer_map[i];
+			if (!peer)
+				continue;
+
+			if (peer->sta == sta) {
+				ath10k_warn(ar, "found sta peer %pM entry on vdev %i after it was supposedly removed\n",
+					    sta->addr, arvif->vdev_id);
+				peer->sta = NULL;
+			}
+		}
+		spin_unlock_bh(&ar->data_lock);
+
 		if (!sta->tdls)
 			goto exit;
 
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 118586ece20e..202e5192235b 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -203,6 +203,7 @@ void ath10k_peer_map_event(struct ath10k_htt *htt,
 	ath10k_dbg(ar, ATH10K_DBG_HTT, "htt peer map vdev %d peer %pM id %d\n",
 		   ev->vdev_id, ev->addr, ev->peer_id);
 
+	ar->peer_map[ev->peer_id] = peer;
 	set_bit(ev->peer_id, peer->peer_ids);
 exit:
 	spin_unlock_bh(&ar->data_lock);
@@ -225,6 +226,7 @@ void ath10k_peer_unmap_event(struct ath10k_htt *htt,
 	ath10k_dbg(ar, ATH10K_DBG_HTT, "htt peer unmap vdev %d peer %pM id %d\n",
 		   peer->vdev_id, peer->addr, ev->peer_id);
 
+	ar->peer_map[ev->peer_id] = NULL;
 	clear_bit(ev->peer_id, peer->peer_ids);
 
 	if (bitmap_empty(peer->peer_ids, ATH10K_MAX_NUM_PEER_IDS)) {
-- 
2.1.4

