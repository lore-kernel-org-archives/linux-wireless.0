Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:35527 "EHLO
	mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646AbbKBOEL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2015 09:04:11 -0500
Received: by lfbn126 with SMTP id n126so61802185lfb.2
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2015 06:04:09 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 7/8] ath10k: replace vdev_id and tid in skb cb
Date: Mon,  2 Nov 2015 15:03:07 +0100
Message-Id: <1446472988-2603-8-git-send-email-michal.kazior@tieto.com> (sfid-20151102_150416_662484_F0B34A4C)
In-Reply-To: <1446472988-2603-1-git-send-email-michal.kazior@tieto.com>
References: <1446472988-2603-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This prepares the driver for future ieee80211_txq
and wake_tx_queue() support.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h   |  4 ++--
 drivers/net/wireless/ath/ath10k/htt_tx.c | 35 +++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/mac.c    | 40 +++++---------------------------
 drivers/net/wireless/ath/ath10k/wmi.c    | 10 +++++++-
 4 files changed, 49 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 59ec9a8098d0..728a5cbe9dfd 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -85,16 +85,16 @@ enum ath10k_skb_flags {
 	ATH10K_SKB_F_NO_HWCRYPT = BIT(0),
 	ATH10K_SKB_F_DTIM_ZERO = BIT(1),
 	ATH10K_SKB_F_DELIVER_CAB = BIT(2),
+	ATH10K_SKB_F_QOS = BIT(3),
 };
 
 struct ath10k_skb_cb {
 	dma_addr_t paddr;
 	u8 flags;
 	u8 eid;
-	u8 vdev_id;
+	struct ieee80211_vif *vif;
 
 	struct {
-		u8 tid;
 		struct ath10k_htt_txbuf *txbuf;
 		u32 txbuf_paddr;
 	} __packed htt;
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index a572576bf6c4..a6fd96a18023 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -439,6 +439,35 @@ int ath10k_htt_h2t_aggr_cfg_msg(struct ath10k_htt *htt,
 	return 0;
 }
 
+static u8 ath10k_htt_tx_get_vdev_id(struct ath10k *ar, struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ath10k_skb_cb *cb = ATH10K_SKB_CB(skb);
+	struct ath10k_vif *arvif = (void *)cb->vif->drv_priv;
+
+	if (info->flags & IEEE80211_TX_CTL_TX_OFFCHAN)
+		return ar->scan.vdev_id;
+	else if (cb->vif)
+		return arvif->vdev_id;
+	else if (ar->monitor_started)
+		return ar->monitor_vdev_id;
+	else
+		return 0;
+}
+
+static u8 ath10k_htt_tx_get_tid(struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr = (void *)skb->data;
+	struct ath10k_skb_cb *cb = ATH10K_SKB_CB(skb);
+
+	if (ieee80211_is_mgmt(hdr->frame_control))
+		return HTT_DATA_TX_EXT_TID_MGMT;
+	else if (cb->flags & ATH10K_SKB_F_QOS)
+		return skb->priority % IEEE80211_QOS_CTL_TID_MASK;
+	else
+		return HTT_DATA_TX_EXT_TID_NON_QOS_MCAST_BCAST;
+}
+
 int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 {
 	struct ath10k *ar = htt->ar;
@@ -446,7 +475,7 @@ int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	struct sk_buff *txdesc = NULL;
 	struct htt_cmd *cmd;
 	struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(msdu);
-	u8 vdev_id = skb_cb->vdev_id;
+	u8 vdev_id = ath10k_htt_tx_get_vdev_id(ar, msdu);
 	int len = 0;
 	int msdu_id = -1;
 	int res;
@@ -535,8 +564,8 @@ int ath10k_htt_tx(struct ath10k_htt *htt, enum ath10k_hw_txrx_mode txmode,
 	struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(msdu);
 	struct ath10k_hif_sg_item sg_items[2];
 	struct htt_data_tx_desc_frag *frags;
-	u8 vdev_id = skb_cb->vdev_id;
-	u8 tid = skb_cb->htt.tid;
+	u8 vdev_id = ath10k_htt_tx_get_vdev_id(ar, msdu);
+	u8 tid = ath10k_htt_tx_get_tid(msdu);
 	int prefetch_len;
 	int res;
 	u8 flags0 = 0;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 105a2e61c2ae..20b6639b978c 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3112,32 +3112,6 @@ void ath10k_mac_handle_tx_pause_vdev(struct ath10k *ar, u32 vdev_id,
 	spin_unlock_bh(&ar->htt.tx_lock);
 }
 
-static u8 ath10k_tx_h_get_tid(struct ieee80211_hdr *hdr)
-{
-	if (ieee80211_is_mgmt(hdr->frame_control))
-		return HTT_DATA_TX_EXT_TID_MGMT;
-
-	if (!ieee80211_is_data_qos(hdr->frame_control))
-		return HTT_DATA_TX_EXT_TID_NON_QOS_MCAST_BCAST;
-
-	if (!is_unicast_ether_addr(ieee80211_get_DA(hdr)))
-		return HTT_DATA_TX_EXT_TID_NON_QOS_MCAST_BCAST;
-
-	return ieee80211_get_qos_ctl(hdr)[0] & IEEE80211_QOS_CTL_TID_MASK;
-}
-
-static u8 ath10k_tx_h_get_vdev_id(struct ath10k *ar, struct ieee80211_vif *vif)
-{
-	if (vif)
-		return ath10k_vif_to_arvif(vif)->vdev_id;
-
-	if (ar->monitor_started)
-		return ar->monitor_vdev_id;
-
-	ath10k_warn(ar, "failed to resolve vdev id\n");
-	return 0;
-}
-
 static enum ath10k_hw_txrx_mode
 ath10k_mac_tx_h_get_txmode(struct ath10k *ar,
 			   struct ieee80211_vif *vif,
@@ -3234,7 +3208,7 @@ static void ath10k_tx_h_nwifi(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 */
 	hdr = (void *)skb->data;
 	if (ieee80211_is_qos_nullfunc(hdr->frame_control))
-		cb->htt.tid = HTT_DATA_TX_EXT_TID_NON_QOS_MCAST_BCAST;
+		cb->flags &= ~ATH10K_SKB_F_QOS;
 
 	hdr->frame_control &= ~__cpu_to_le16(IEEE80211_STYPE_QOS_DATA);
 }
@@ -3402,9 +3376,9 @@ void ath10k_offchan_tx_work(struct work_struct *work)
 
 		hdr = (struct ieee80211_hdr *)skb->data;
 		peer_addr = ieee80211_get_DA(hdr);
-		vdev_id = ATH10K_SKB_CB(skb)->vdev_id;
 
 		spin_lock_bh(&ar->data_lock);
+		vdev_id = ar->scan.vdev_id;
 		peer = ath10k_peer_find(ar, vdev_id, peer_addr);
 		spin_unlock_bh(&ar->data_lock);
 
@@ -3678,8 +3652,10 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 	if (!ath10k_tx_h_use_hwcrypto(vif, skb))
 		skb_cb->flags |= ATH10K_SKB_F_NO_HWCRYPT;
 
-	skb_cb->htt.tid = ath10k_tx_h_get_tid(hdr);
-	skb_cb->vdev_id = ath10k_tx_h_get_vdev_id(ar, vif);
+	if (ieee80211_is_data_qos(hdr->frame_control))
+		skb_cb->flags |= ATH10K_SKB_F_QOS;
+
+	skb_cb->vif = vif;
 
 	switch (txmode) {
 	case ATH10K_HW_TXRX_MGMT:
@@ -3700,10 +3676,6 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 	}
 
 	if (info->flags & IEEE80211_TX_CTL_TX_OFFCHAN) {
-		spin_lock_bh(&ar->data_lock);
-		ATH10K_SKB_CB(skb)->vdev_id = ar->scan.vdev_id;
-		spin_unlock_bh(&ar->data_lock);
-
 		if (ath10k_mac_need_offchan_tx_work(ar)) {
 			ath10k_dbg(ar, ATH10K_DBG_MAC, "queued offchannel skb %p\n",
 				   skb);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 022d42d29486..65bce46b39a5 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1759,16 +1759,24 @@ int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id)
 static struct sk_buff *
 ath10k_wmi_op_gen_mgmt_tx(struct ath10k *ar, struct sk_buff *msdu)
 {
+	struct ath10k_skb_cb *cb = ATH10K_SKB_CB(msdu);
+	struct ath10k_vif *arvif = (void *)cb->vif->drv_priv;
 	struct wmi_mgmt_tx_cmd *cmd;
 	struct ieee80211_hdr *hdr;
 	struct sk_buff *skb;
 	int len;
+	u32 vdev_id;
 	u32 buf_len = msdu->len;
 	u16 fc;
 
 	hdr = (struct ieee80211_hdr *)msdu->data;
 	fc = le16_to_cpu(hdr->frame_control);
 
+	if (cb->vif)
+		vdev_id = arvif->vdev_id;
+	else
+		vdev_id = 0;
+
 	if (WARN_ON_ONCE(!ieee80211_is_mgmt(hdr->frame_control)))
 		return ERR_PTR(-EINVAL);
 
@@ -1790,7 +1798,7 @@ ath10k_wmi_op_gen_mgmt_tx(struct ath10k *ar, struct sk_buff *msdu)
 
 	cmd = (struct wmi_mgmt_tx_cmd *)skb->data;
 
-	cmd->hdr.vdev_id = __cpu_to_le32(ATH10K_SKB_CB(msdu)->vdev_id);
+	cmd->hdr.vdev_id = __cpu_to_le32(vdev_id);
 	cmd->hdr.tx_rate = 0;
 	cmd->hdr.tx_power = 0;
 	cmd->hdr.buf_len = __cpu_to_le32(buf_len);
-- 
2.1.4

