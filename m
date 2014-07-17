Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:38595 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979AbaGQMyG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2014 08:54:06 -0400
Received: by mail-we0-f174.google.com with SMTP id x48so2822701wes.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2014 05:54:04 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/2] ath10k: simplify tx helpers
Date: Thu, 17 Jul 2014 14:45:21 +0200
Message-Id: <1405601122-29726-1-git-send-email-michal.kazior@tieto.com> (sfid-20140717_145411_494800_21E3EA6A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It always bugged me how tid is computed and stored
in a temporary var before written to the control
buffer. It was confusing and it made it difficult
to work with tx helpers.

While at it rename the qos workaround function as
it was misleading - it's not a workaround but
preparation for nwifi tx mode.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 49 ++++++++++++++---------------------
 drivers/net/wireless/ath/ath10k/mac.h |  4 +--
 drivers/net/wireless/ath/ath10k/wmi.c |  2 +-
 3 files changed, 23 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index b8314a5..bbce3a0 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1865,13 +1865,10 @@ static u8 ath10k_tx_h_get_vdev_id(struct ath10k *ar,
 	return 0;
 }
 
-/*
- * Frames sent to the FW have to be in "Native Wifi" format.
- * Strip the QoS field from the 802.11 header.
+/* HTT Tx uses Native Wifi tx mode which expects 802.11 frames without QoS
+ * Control in the header.
  */
-static void ath10k_tx_h_qos_workaround(struct ieee80211_hw *hw,
-				       struct ieee80211_tx_control *control,
-				       struct sk_buff *skb)
+static void ath10k_tx_h_nwifi(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	u8 *qos_ctl;
@@ -1919,14 +1916,13 @@ unlock:
 	mutex_unlock(&arvif->ar->conf_mutex);
 }
 
-static void ath10k_tx_h_update_wep_key(struct sk_buff *skb)
+static void ath10k_tx_h_update_wep_key(struct ieee80211_vif *vif,
+				       struct ieee80211_key_conf *key,
+				       struct sk_buff *skb)
 {
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_vif *vif = info->control.vif;
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 	struct ath10k *ar = arvif->ar;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	struct ieee80211_key_conf *key = info->control.hw_key;
 
 	if (!ieee80211_has_protected(hdr->frame_control))
 		return;
@@ -1948,11 +1944,11 @@ static void ath10k_tx_h_update_wep_key(struct sk_buff *skb)
 	ieee80211_queue_work(ar->hw, &arvif->wep_key_work);
 }
 
-static void ath10k_tx_h_add_p2p_noa_ie(struct ath10k *ar, struct sk_buff *skb)
+static void ath10k_tx_h_add_p2p_noa_ie(struct ath10k *ar,
+				       struct ieee80211_vif *vif,
+				       struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_vif *vif = info->control.vif;
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 
 	/* This is case only for P2P_GO */
@@ -2254,33 +2250,28 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 		      struct ieee80211_tx_control *control,
 		      struct sk_buff *skb)
 {
+	struct ath10k *ar = hw->priv;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_vif *vif = info->control.vif;
+	struct ieee80211_key_conf *key = info->control.hw_key;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	struct ath10k *ar = hw->priv;
-	u8 tid, vdev_id;
 
 	/* We should disable CCK RATE due to P2P */
 	if (info->flags & IEEE80211_TX_CTL_NO_CCK_RATE)
 		ath10k_dbg(ATH10K_DBG_MAC, "IEEE80211_TX_CTL_NO_CCK_RATE\n");
 
-	/* we must calculate tid before we apply qos workaround
-	 * as we'd lose the qos control field */
-	tid = ath10k_tx_h_get_tid(hdr);
-	vdev_id = ath10k_tx_h_get_vdev_id(ar, info);
+	ATH10K_SKB_CB(skb)->htt.is_offchan = false;
+	ATH10K_SKB_CB(skb)->htt.tid = ath10k_tx_h_get_tid(hdr);
+	ATH10K_SKB_CB(skb)->vdev_id = ath10k_tx_h_get_vdev_id(ar, info);
 
 	/* it makes no sense to process injected frames like that */
-	if (info->control.vif &&
-	    info->control.vif->type != NL80211_IFTYPE_MONITOR) {
-		ath10k_tx_h_qos_workaround(hw, control, skb);
-		ath10k_tx_h_update_wep_key(skb);
-		ath10k_tx_h_add_p2p_noa_ie(ar, skb);
-		ath10k_tx_h_seq_no(skb);
+	if (vif && vif->type != NL80211_IFTYPE_MONITOR) {
+		ath10k_tx_h_nwifi(hw, skb);
+		ath10k_tx_h_update_wep_key(vif, key, skb);
+		ath10k_tx_h_add_p2p_noa_ie(ar, vif, skb);
+		ath10k_tx_h_seq_no(vif, skb);
 	}
 
-	ATH10K_SKB_CB(skb)->vdev_id = vdev_id;
-	ATH10K_SKB_CB(skb)->htt.is_offchan = false;
-	ATH10K_SKB_CB(skb)->htt.tid = tid;
-
 	if (info->flags & IEEE80211_TX_CTL_TX_OFFCHAN) {
 		spin_lock_bh(&ar->data_lock);
 		ATH10K_SKB_CB(skb)->htt.is_offchan = true;
diff --git a/drivers/net/wireless/ath/ath10k/mac.h b/drivers/net/wireless/ath/ath10k/mac.h
index ba10219..ef4f843 100644
--- a/drivers/net/wireless/ath/ath10k/mac.h
+++ b/drivers/net/wireless/ath/ath10k/mac.h
@@ -43,11 +43,11 @@ static inline struct ath10k_vif *ath10k_vif_to_arvif(struct ieee80211_vif *vif)
 	return (struct ath10k_vif *)vif->drv_priv;
 }
 
-static inline void ath10k_tx_h_seq_no(struct sk_buff *skb)
+static inline void ath10k_tx_h_seq_no(struct ieee80211_vif *vif,
+				      struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	struct ieee80211_vif *vif = info->control.vif;
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 
 	if (info->flags  & IEEE80211_TX_CTL_ASSIGN_SEQ) {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 6f83cae..c2c87c9 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1432,7 +1432,7 @@ static void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 			continue;
 		}
 
-		ath10k_tx_h_seq_no(bcn);
+		ath10k_tx_h_seq_no(arvif->vif, bcn);
 		ath10k_wmi_update_tim(ar, arvif, bcn, bcn_info);
 		ath10k_wmi_update_noa(ar, arvif, bcn, bcn_info);
 
-- 
1.8.5.3

