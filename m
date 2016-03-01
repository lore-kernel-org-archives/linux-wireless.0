Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:33789 "EHLO
	mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbcCAKcO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 05:32:14 -0500
Received: by mail-lf0-f51.google.com with SMTP id v124so17122193lff.0
        for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2016 02:32:13 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 04/11] ath10k: maintain peer_id for each sta and vif
Date: Tue,  1 Mar 2016 11:32:49 +0100
Message-Id: <1456828376-2795-5-git-send-email-michal.kazior@tieto.com> (sfid-20160301_113220_273948_EDB268BD)
In-Reply-To: <1456828376-2795-1-git-send-email-michal.kazior@tieto.com>
References: <1453384006-31907-1-git-send-email-michal.kazior@tieto.com>
 <1456828376-2795-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 10.4.3 firmware with congestion control
guarantees that each peer has only a single
peer_id mapping.

The 1:1 mapping isn't the case for older firmwares
(e.g. 10.4.1, 10.2, 10.1) but it should not
matter. This 1:1 mapping is going to be only used
by future code which inherently (flow-wise) is for
10.4.3.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h |  2 ++
 drivers/net/wireless/ath/ath10k/mac.c  | 38 ++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index a62b62a62266..523585e85f35 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -313,6 +313,7 @@ struct ath10k_sta {
 	u32 bw;
 	u32 nss;
 	u32 smps;
+	u16 peer_id;
 
 	struct work_struct update_wk;
 
@@ -335,6 +336,7 @@ struct ath10k_vif {
 	struct list_head list;
 
 	u32 vdev_id;
+	u16 peer_id;
 	enum wmi_vdev_type vdev_type;
 	enum wmi_vdev_subtype vdev_subtype;
 	u32 beacon_interval;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 140ad250ea69..72b8f177445d 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4421,6 +4421,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 {
 	struct ath10k *ar = hw->priv;
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
+	struct ath10k_peer *peer;
 	enum wmi_sta_powersave_param param;
 	int ret = 0;
 	u32 value;
@@ -4620,6 +4621,24 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 				    arvif->vdev_id, ret);
 			goto err_vdev_delete;
 		}
+
+		spin_lock_bh(&ar->data_lock);
+
+		peer = ath10k_peer_find(ar, arvif->vdev_id, vif->addr);
+		if (!peer) {
+			ath10k_warn(ar, "failed to lookup peer %pM on vdev %i\n",
+				    vif->addr, arvif->vdev_id);
+			spin_unlock_bh(&ar->data_lock);
+			ret = -ENOENT;
+			goto err_peer_delete;
+		}
+
+		arvif->peer_id = find_first_bit(peer->peer_ids,
+						ATH10K_MAX_NUM_PEER_IDS);
+
+		spin_unlock_bh(&ar->data_lock);
+	} else {
+		arvif->peer_id = HTT_INVALID_PEERID;
 	}
 
 	if (arvif->vdev_type == WMI_VDEV_TYPE_AP) {
@@ -5501,6 +5520,7 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 	struct ath10k *ar = hw->priv;
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 	struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
+	struct ath10k_peer *peer;
 	int ret = 0;
 
 	if (old_state == IEEE80211_STA_NOTEXIST &&
@@ -5551,6 +5571,24 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 			goto exit;
 		}
 
+		spin_lock_bh(&ar->data_lock);
+
+		peer = ath10k_peer_find(ar, arvif->vdev_id, sta->addr);
+		if (!peer) {
+			ath10k_warn(ar, "failed to lookup peer %pM on vdev %i\n",
+				    vif->addr, arvif->vdev_id);
+			spin_unlock_bh(&ar->data_lock);
+			ath10k_peer_delete(ar, arvif->vdev_id, sta->addr);
+			ath10k_mac_dec_num_stations(arvif, sta);
+			ret = -ENOENT;
+			goto exit;
+		}
+
+		arsta->peer_id = find_first_bit(peer->peer_ids,
+						ATH10K_MAX_NUM_PEER_IDS);
+
+		spin_unlock_bh(&ar->data_lock);
+
 		if (!sta->tdls)
 			goto exit;
 
-- 
2.1.4

