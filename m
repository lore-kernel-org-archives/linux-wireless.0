Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:61675 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbaIRHGb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2014 03:06:31 -0400
Received: by mail-wi0-f171.google.com with SMTP id bs8so2484007wib.16
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2014 00:06:30 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: workaround fw beaconing bug
Date: Thu, 18 Sep 2014 08:55:58 +0200
Message-Id: <1411023358-5703-1-git-send-email-michal.kazior@tieto.com> (sfid-20140918_090639_531069_035D0D46)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some firmware revisions don't wait for beacon tx
completion before sending another SWBA event. This
could lead to hardware using old (freed) beacon
data in some cases, e.g. tx credit starvation
combined with missed TBTT. This is very very rare.

On non-IOMMU-enabled hosts this could be a
possible security issue because hw could beacon
some random data on the air.  On IOMMU-enabled
hosts DMAR faults would occur in most cases and
target device would crash.

Since there are no beacon tx completions (implicit
nor explicit) propagated to host the only
workaround for this is to allocate a DMA-coherent
buffer for a lifetime of a vif and use it for all
beacon tx commands. Worst case for this approach
is some beacons may become corrupted, e.g. garbled
IEs or out-of-date TIM bitmap.

Keep the original beacon-related code as-is in
case future firmware revisions solve this problem
so that the old path can be easily re-enabled with
a fw_feature flag.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h |   2 +
 drivers/net/wireless/ath/ath10k/mac.c  | 106 ++++++++++++++++++++++++---------
 drivers/net/wireless/ath/ath10k/mac.h  |   1 +
 drivers/net/wireless/ath/ath10k/wmi.c  |  36 ++++++-----
 4 files changed, 102 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index fe531ea..d1ea936 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -234,6 +234,8 @@ struct ath10k_vif {
 	struct sk_buff *beacon;
 	/* protected by data_lock */
 	bool beacon_sent;
+	void *beacon_buf;
+	dma_addr_t beacon_paddr;
 
 	struct ath10k *ar;
 	struct ieee80211_vif *vif;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 5b35fff..aa6e659 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -480,6 +480,40 @@ static void ath10k_peer_cleanup_all(struct ath10k *ar)
 /* Interface management */
 /************************/
 
+void ath10k_mac_vif_beacon_free(struct ath10k_vif *arvif)
+{
+	struct ath10k *ar = arvif->ar;
+
+	lockdep_assert_held(&ar->data_lock);
+
+	if (!arvif->beacon)
+		return;
+
+	if (!arvif->beacon_buf)
+		dma_unmap_single(ar->dev, ATH10K_SKB_CB(arvif->beacon)->paddr,
+				 arvif->beacon->len, DMA_TO_DEVICE);
+
+	dev_kfree_skb_any(arvif->beacon);
+
+	arvif->beacon = NULL;
+	arvif->beacon_sent = false;
+}
+
+static void ath10k_mac_vif_beacon_cleanup(struct ath10k_vif *arvif)
+{
+	struct ath10k *ar = arvif->ar;
+
+	lockdep_assert_held(&ar->data_lock);
+
+	ath10k_mac_vif_beacon_free(arvif);
+
+	if (arvif->beacon_buf) {
+		dma_free_coherent(ar->dev, IEEE80211_MAX_FRAME_LEN,
+				  arvif->beacon_buf, arvif->beacon_paddr);
+		arvif->beacon_buf = NULL;
+	}
+}
+
 static inline int ath10k_vdev_setup_sync(struct ath10k *ar)
 {
 	int ret;
@@ -910,15 +944,7 @@ static void ath10k_control_beaconing(struct ath10k_vif *arvif,
 		arvif->is_up = false;
 
 		spin_lock_bh(&arvif->ar->data_lock);
-		if (arvif->beacon) {
-			dma_unmap_single(arvif->ar->dev,
-					 ATH10K_SKB_CB(arvif->beacon)->paddr,
-					 arvif->beacon->len, DMA_TO_DEVICE);
-			dev_kfree_skb_any(arvif->beacon);
-
-			arvif->beacon = NULL;
-			arvif->beacon_sent = false;
-		}
+		ath10k_mac_vif_beacon_free(arvif);
 		spin_unlock_bh(&arvif->ar->data_lock);
 
 		return;
@@ -2378,16 +2404,8 @@ void ath10k_halt(struct ath10k *ar)
 	ath10k_hif_power_down(ar);
 
 	spin_lock_bh(&ar->data_lock);
-	list_for_each_entry(arvif, &ar->arvifs, list) {
-		if (!arvif->beacon)
-			continue;
-
-		dma_unmap_single(arvif->ar->dev,
-				 ATH10K_SKB_CB(arvif->beacon)->paddr,
-				 arvif->beacon->len, DMA_TO_DEVICE);
-		dev_kfree_skb_any(arvif->beacon);
-		arvif->beacon = NULL;
-	}
+	list_for_each_entry(arvif, &ar->arvifs, list)
+		ath10k_mac_vif_beacon_cleanup(arvif);
 	spin_unlock_bh(&ar->data_lock);
 }
 
@@ -2806,8 +2824,39 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 		break;
 	}
 
-	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vdev create %d (add interface) type %d subtype %d\n",
-		   arvif->vdev_id, arvif->vdev_type, arvif->vdev_subtype);
+	/* Some firmware revisions don't wait for beacon tx completion before
+	 * sending another SWBA event. This could lead to hardware using old
+	 * (freed) beacon data in some cases, e.g. tx credit starvation
+	 * combined with missed TBTT. This is very very rare.
+	 *
+	 * On non-IOMMU-enabled hosts this could be a possible security issue
+	 * because hw could beacon some random data on the air.  On
+	 * IOMMU-enabled hosts DMAR faults would occur in most cases and target
+	 * device would crash.
+	 *
+	 * Since there are no beacon tx completions (implicit nor explicit)
+	 * propagated to host the only workaround for this is to allocate a
+	 * DMA-coherent buffer for a lifetime of a vif and use it for all
+	 * beacon tx commands. Worst case for this approach is some beacons may
+	 * become corrupted, e.g. have garbled IEs or out-of-date TIM bitmap.
+	 */
+	if (vif->type == NL80211_IFTYPE_ADHOC ||
+	    vif->type == NL80211_IFTYPE_AP) {
+		arvif->beacon_buf = dma_zalloc_coherent(ar->dev,
+							IEEE80211_MAX_FRAME_LEN,
+							&arvif->beacon_paddr,
+							GFP_KERNEL);
+		if (!arvif->beacon_buf) {
+			ret = -ENOMEM;
+			ath10k_warn(ar, "failed to allocate beacon buffer: %d\n",
+				    ret);
+			goto err;
+		}
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vdev create %d (add interface) type %d subtype %d bcnmode %s\n",
+		   arvif->vdev_id, arvif->vdev_type, arvif->vdev_subtype,
+		   arvif->beacon_buf ? "single-buf" : "per-skb");
 
 	ret = ath10k_wmi_vdev_create(ar, arvif->vdev_id, arvif->vdev_type,
 				     arvif->vdev_subtype, vif->addr);
@@ -2914,6 +2963,12 @@ err_vdev_delete:
 	list_del(&arvif->list);
 
 err:
+	if (arvif->beacon_buf) {
+		dma_free_coherent(ar->dev, IEEE80211_MAX_FRAME_LEN,
+				  arvif->beacon_buf, arvif->beacon_paddr);
+		arvif->beacon_buf = NULL;
+	}
+
 	mutex_unlock(&ar->conf_mutex);
 
 	return ret;
@@ -2931,14 +2986,7 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 	cancel_work_sync(&arvif->wep_key_work);
 
 	spin_lock_bh(&ar->data_lock);
-	if (arvif->beacon) {
-		dma_unmap_single(arvif->ar->dev,
-				 ATH10K_SKB_CB(arvif->beacon)->paddr,
-				 arvif->beacon->len, DMA_TO_DEVICE);
-		dev_kfree_skb_any(arvif->beacon);
-		arvif->beacon = NULL;
-	}
-
+	ath10k_mac_vif_beacon_cleanup(arvif);
 	spin_unlock_bh(&ar->data_lock);
 
 	ret = ath10k_spectral_vif_stop(arvif);
diff --git a/drivers/net/wireless/ath/ath10k/mac.h b/drivers/net/wireless/ath/ath10k/mac.h
index 6c80eea..965c511 100644
--- a/drivers/net/wireless/ath/ath10k/mac.h
+++ b/drivers/net/wireless/ath/ath10k/mac.h
@@ -39,6 +39,7 @@ void ath10k_offchan_tx_work(struct work_struct *work);
 void ath10k_mgmt_over_wmi_tx_purge(struct ath10k *ar);
 void ath10k_mgmt_over_wmi_tx_work(struct work_struct *work);
 void ath10k_halt(struct ath10k *ar);
+void ath10k_mac_vif_beacon_free(struct ath10k_vif *arvif);
 
 static inline struct ath10k_vif *ath10k_vif_to_arvif(struct ieee80211_vif *vif)
 {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 3e22134..ce073c1 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1577,6 +1577,7 @@ static void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 	struct wmi_bcn_info *bcn_info;
 	struct ath10k_vif *arvif;
 	struct sk_buff *bcn;
+	dma_addr_t paddr;
 	int ret, vdev_id = 0;
 
 	ev = (struct wmi_host_swba_event *)skb->data;
@@ -1645,22 +1646,29 @@ static void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 				ath10k_warn(ar, "SWBA overrun on vdev %d\n",
 					    arvif->vdev_id);
 
-			dma_unmap_single(arvif->ar->dev,
-					 ATH10K_SKB_CB(arvif->beacon)->paddr,
-					 arvif->beacon->len, DMA_TO_DEVICE);
-			dev_kfree_skb_any(arvif->beacon);
-			arvif->beacon = NULL;
+			ath10k_mac_vif_beacon_free(arvif);
 		}
 
-		ATH10K_SKB_CB(bcn)->paddr = dma_map_single(arvif->ar->dev,
-							   bcn->data, bcn->len,
-							   DMA_TO_DEVICE);
-		ret = dma_mapping_error(arvif->ar->dev,
-					ATH10K_SKB_CB(bcn)->paddr);
-		if (ret) {
-			ath10k_warn(ar, "failed to map beacon: %d\n", ret);
-			dev_kfree_skb_any(bcn);
-			goto skip;
+		if (!arvif->beacon_buf) {
+			paddr = dma_map_single(arvif->ar->dev, bcn->data,
+					       bcn->len, DMA_TO_DEVICE);
+			ret = dma_mapping_error(arvif->ar->dev, paddr);
+			if (ret) {
+				ath10k_warn(ar, "failed to map beacon: %d\n",
+					    ret);
+				dev_kfree_skb_any(bcn);
+				goto skip;
+			}
+
+			ATH10K_SKB_CB(bcn)->paddr = paddr;
+		} else {
+			if (bcn->len > IEEE80211_MAX_FRAME_LEN) {
+				ath10k_warn(ar, "trimming beacon %d -> %d bytes!\n",
+					    bcn->len, IEEE80211_MAX_FRAME_LEN);
+				skb_trim(bcn, IEEE80211_MAX_FRAME_LEN);
+			}
+			memcpy(arvif->beacon_buf, bcn->data, bcn->len);
+			ATH10K_SKB_CB(bcn)->paddr = arvif->beacon_paddr;
 		}
 
 		arvif->beacon = bcn;
-- 
1.8.5.3

