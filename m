Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:34444 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbaAWLsl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 06:48:41 -0500
Received: by mail-ea0-f174.google.com with SMTP id b10so371987eae.33
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jan 2014 03:48:38 -0800 (PST)
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>,
	Marek Puzyniak <marek.puzyniak@tieto.com>
Subject: [PATCH v2] ath10k: implement and use new beacon method
Date: Thu, 23 Jan 2014 12:48:21 +0100
Message-Id: <1390477701-16843-1-git-send-email-marek.puzyniak@tieto.com> (sfid-20140123_124859_643704_E37704A7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

Until now ath10k used a copy-by-value beacon
submission.

The new method passes a DMA address via WMI
command only. This command contains additional
metadata that fixes AP behaviour with regard
to powersave buffering.

This also fixes strange bug when multicast traffic
would freeze TX indefinitely.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
---

v2:
 -rebased,
 -beacon send function refactored,
 -comments moved before field in structure declaration.


 drivers/net/wireless/ath/ath10k/core.h |  7 ++++
 drivers/net/wireless/ath/ath10k/mac.c  | 11 ++++++
 drivers/net/wireless/ath/ath10k/wmi.c  | 71 +++++++++++++++++++++++-----------
 drivers/net/wireless/ath/ath10k/wmi.h  | 21 +++++++++-
 4 files changed, 86 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index ade1781..1fce243 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -61,6 +61,11 @@ struct ath10k_skb_cb {
 		u8 frag_len;
 		u8 pad_len;
 	} __packed htt;
+
+	struct {
+		bool dtim_zero;
+		bool deliver_cab;
+	} bcn;
 } __packed;
 
 static inline struct ath10k_skb_cb *ATH10K_SKB_CB(struct sk_buff *skb)
@@ -222,6 +227,8 @@ struct ath10k_vif {
 	u32 beacon_interval;
 	u32 dtim_period;
 	struct sk_buff *beacon;
+	/* protected by data_lock */
+	bool beacon_sent;
 
 	struct ath10k *ar;
 	struct ieee80211_vif *vif;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 776e364..5973e43 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -791,6 +791,17 @@ static void ath10k_control_beaconing(struct ath10k_vif *arvif,
 
 	if (!info->enable_beacon) {
 		ath10k_vdev_stop(arvif);
+
+		spin_lock_bh(&arvif->ar->data_lock);
+		if (arvif->beacon) {
+			ath10k_skb_unmap(arvif->ar->dev, arvif->beacon);
+			dev_kfree_skb_any(arvif->beacon);
+
+			arvif->beacon = NULL;
+			arvif->beacon_sent = false;
+		}
+		spin_unlock_bh(&arvif->ar->data_lock);
+
 		return;
 	}
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 712a606..2fbc7ff 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -561,7 +561,6 @@ err_pull:
 
 static void ath10k_wmi_tx_beacon_nowait(struct ath10k_vif *arvif)
 {
-	struct wmi_bcn_tx_arg arg = {0};
 	int ret;
 
 	lockdep_assert_held(&arvif->ar->data_lock);
@@ -569,18 +568,16 @@ static void ath10k_wmi_tx_beacon_nowait(struct ath10k_vif *arvif)
 	if (arvif->beacon == NULL)
 		return;
 
-	arg.vdev_id = arvif->vdev_id;
-	arg.tx_rate = 0;
-	arg.tx_power = 0;
-	arg.bcn = arvif->beacon->data;
-	arg.bcn_len = arvif->beacon->len;
+	if (arvif->beacon_sent)
+		return;
 
-	ret = ath10k_wmi_beacon_send_nowait(arvif->ar, &arg);
+	ret = ath10k_wmi_beacon_send_ref_nowait(arvif);
 	if (ret)
 		return;
 
-	dev_kfree_skb_any(arvif->beacon);
-	arvif->beacon = NULL;
+	/* We need to retain the arvif->beacon reference for DMA unmapping and
+	 * freeing the skbuff later. */
+	arvif->beacon_sent = true;
 }
 
 static void ath10k_wmi_tx_beacons_iter(void *data, u8 *mac,
@@ -1217,6 +1214,13 @@ static void ath10k_wmi_update_tim(struct ath10k *ar,
 	tim->bitmap_ctrl = !!__le32_to_cpu(bcn_info->tim_info.tim_mcast);
 	memcpy(tim->virtual_map, arvif->u.ap.tim_bitmap, pvm_len);
 
+	if (tim->dtim_count == 0) {
+		ATH10K_SKB_CB(bcn)->bcn.dtim_zero = true;
+
+		if (__le32_to_cpu(bcn_info->tim_info.tim_mcast) == 1)
+			ATH10K_SKB_CB(bcn)->bcn.deliver_cab = true;
+	}
+
 	ath10k_dbg(ATH10K_DBG_MGMT, "dtim %d/%d mcast %d pvmlen %d\n",
 		   tim->dtim_count, tim->dtim_period,
 		   tim->bitmap_ctrl, pvm_len);
@@ -1396,13 +1400,20 @@ static void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 		ath10k_wmi_update_noa(ar, arvif, bcn, bcn_info);
 
 		spin_lock_bh(&ar->data_lock);
+
 		if (arvif->beacon) {
-			ath10k_warn("SWBA overrun on vdev %d\n",
-				    arvif->vdev_id);
+			if (!arvif->beacon_sent)
+				ath10k_warn("SWBA overrun on vdev %d\n",
+					    arvif->vdev_id);
+
+			ath10k_skb_unmap(ar->dev, arvif->beacon);
 			dev_kfree_skb_any(arvif->beacon);
 		}
 
+		ath10k_skb_map(ar->dev, bcn);
+
 		arvif->beacon = bcn;
+		arvif->beacon_sent = false;
 
 		ath10k_wmi_tx_beacon_nowait(arvif);
 		spin_unlock_bh(&ar->data_lock);
@@ -3411,25 +3422,41 @@ int ath10k_wmi_peer_assoc(struct ath10k *ar,
 	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->peer_assoc_cmdid);
 }
 
-int ath10k_wmi_beacon_send_nowait(struct ath10k *ar,
-				  const struct wmi_bcn_tx_arg *arg)
+/* This function assumes the beacon is already DMA mapped */
+int ath10k_wmi_beacon_send_ref_nowait(struct ath10k_vif *arvif)
 {
-	struct wmi_bcn_tx_cmd *cmd;
+	struct wmi_bcn_tx_ref_cmd *cmd;
 	struct sk_buff *skb;
+	struct sk_buff *beacon = arvif->beacon;
+	struct ath10k *ar = arvif->ar;
+	struct ieee80211_hdr *hdr;
 	int ret;
+	u16 fc;
 
-	skb = ath10k_wmi_alloc_skb(sizeof(*cmd) + arg->bcn_len);
+	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
 	if (!skb)
 		return -ENOMEM;
 
-	cmd = (struct wmi_bcn_tx_cmd *)skb->data;
-	cmd->hdr.vdev_id  = __cpu_to_le32(arg->vdev_id);
-	cmd->hdr.tx_rate  = __cpu_to_le32(arg->tx_rate);
-	cmd->hdr.tx_power = __cpu_to_le32(arg->tx_power);
-	cmd->hdr.bcn_len  = __cpu_to_le32(arg->bcn_len);
-	memcpy(cmd->bcn, arg->bcn, arg->bcn_len);
+	hdr = (struct ieee80211_hdr *)beacon->data;
+	fc = le16_to_cpu(hdr->frame_control);
+
+	cmd = (struct wmi_bcn_tx_ref_cmd *)skb->data;
+	cmd->vdev_id = __cpu_to_le32(arvif->vdev_id);
+	cmd->data_len = __cpu_to_le32(beacon->len);
+	cmd->data_ptr = __cpu_to_le32(ATH10K_SKB_CB(beacon)->paddr);
+	cmd->msdu_id = 0;
+	cmd->frame_control = __cpu_to_le32(fc);
+	cmd->flags = 0;
+
+	if (ATH10K_SKB_CB(beacon)->bcn.dtim_zero)
+		cmd->flags |= __cpu_to_le32(WMI_BCN_TX_REF_FLAG_DTIM_ZERO);
+
+	if (ATH10K_SKB_CB(beacon)->bcn.deliver_cab)
+		cmd->flags |= __cpu_to_le32(WMI_BCN_TX_REF_FLAG_DELIVER_CAB);
+
+	ret = ath10k_wmi_cmd_send_nowait(ar, skb,
+					 ar->wmi.cmd->pdev_send_bcn_cmdid);
 
-	ret = ath10k_wmi_cmd_send_nowait(ar, skb, ar->wmi.cmd->bcn_tx_cmdid);
 	if (ret)
 		dev_kfree_skb(skb);
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 4b5e7d3..f59be03 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -3403,6 +3403,24 @@ struct wmi_bcn_tx_arg {
 	const void *bcn;
 };
 
+enum wmi_bcn_tx_ref_flags {
+	WMI_BCN_TX_REF_FLAG_DTIM_ZERO = 0x1,
+	WMI_BCN_TX_REF_FLAG_DELIVER_CAB = 0x2,
+};
+
+struct wmi_bcn_tx_ref_cmd {
+	__le32 vdev_id;
+	__le32 data_len;
+	/* physical address of the frame - dma pointer */
+	__le32 data_ptr;
+	/* id for host to track */
+	__le32 msdu_id;
+	/* frame ctrl to setup PPDU desc */
+	__le32 frame_control;
+	/* to control CABQ traffic: WMI_BCN_TX_REF_FLAG_ */
+	__le32 flags;
+} __packed;
+
 /* Beacon filter */
 #define WMI_BCN_FILTER_ALL   0 /* Filter all beacons */
 #define WMI_BCN_FILTER_NONE  1 /* Pass all beacons */
@@ -4219,8 +4237,7 @@ int ath10k_wmi_set_ap_ps_param(struct ath10k *ar, u32 vdev_id, const u8 *mac,
 			       enum wmi_ap_ps_peer_param param_id, u32 value);
 int ath10k_wmi_scan_chan_list(struct ath10k *ar,
 			      const struct wmi_scan_chan_list_arg *arg);
-int ath10k_wmi_beacon_send_nowait(struct ath10k *ar,
-				  const struct wmi_bcn_tx_arg *arg);
+int ath10k_wmi_beacon_send_ref_nowait(struct ath10k_vif *arvif);
 int ath10k_wmi_pdev_set_wmm_params(struct ath10k *ar,
 			const struct wmi_pdev_set_wmm_params_arg *arg);
 int ath10k_wmi_request_stats(struct ath10k *ar, enum wmi_stats_id stats_id);
-- 
1.8.1.2

