Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:39670 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbaAIREx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jan 2014 12:04:53 -0500
Received: by mail-ee0-f51.google.com with SMTP id b15so1470025eek.10
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jan 2014 09:04:51 -0800 (PST)
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>,
	Marek Puzyniak <marek.puzyniak@tieto.com>
Subject: [PATCH] ath10k: implement and use new beacon method
Date: Thu,  9 Jan 2014 18:04:33 +0100
Message-Id: <1389287073-10939-1-git-send-email-marek.puzyniak@tieto.com> (sfid-20140109_180458_734769_8C2A225E)
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
 drivers/net/wireless/ath/ath10k/core.h |  6 +++
 drivers/net/wireless/ath/ath10k/mac.c  | 11 ++++++
 drivers/net/wireless/ath/ath10k/wmi.c  | 72 +++++++++++++++++++++++-----------
 drivers/net/wireless/ath/ath10k/wmi.h  | 16 ++++++++
 4 files changed, 83 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 035cbf6..6e94579 100644
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
@@ -222,6 +227,7 @@ struct ath10k_vif {
 	u32 beacon_interval;
 	u32 dtim_period;
 	struct sk_buff *beacon;
+	bool beacon_sent;
 
 	struct ath10k *ar;
 	struct ieee80211_vif *vif;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 5b45f3a..98ce775 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -782,6 +782,17 @@ static void ath10k_control_beaconing(struct ath10k_vif *arvif,
 
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
index 3ec6c9a..85681c8 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -560,7 +560,6 @@ err_pull:
 
 static void ath10k_wmi_tx_beacon_nowait(struct ath10k_vif *arvif)
 {
-	struct wmi_bcn_tx_arg arg = {0};
 	int ret;
 
 	lockdep_assert_held(&arvif->ar->data_lock);
@@ -568,18 +567,18 @@ static void ath10k_wmi_tx_beacon_nowait(struct ath10k_vif *arvif)
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
+	ret = ath10k_wmi_beacon_send_ref_nowait(arvif->ar,
+						arvif->vdev_id,
+						arvif->beacon);
 	if (ret)
 		return;
 
-	dev_kfree_skb_any(arvif->beacon);
-	arvif->beacon = NULL;
+	/* We need to retain the arvif->beacon reference for DMA unmapping and
+	 * freeing the skbuff later. */
+	arvif->beacon_sent = true;
 }
 
 static void ath10k_wmi_tx_beacons_iter(void *data, u8 *mac,
@@ -1211,6 +1210,13 @@ static void ath10k_wmi_update_tim(struct ath10k *ar,
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
@@ -1390,13 +1396,20 @@ static void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
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
@@ -3377,25 +3390,40 @@ int ath10k_wmi_peer_assoc(struct ath10k *ar,
 	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->peer_assoc_cmdid);
 }
 
-int ath10k_wmi_beacon_send_nowait(struct ath10k *ar,
-				  const struct wmi_bcn_tx_arg *arg)
+/* This function assumes the beacon is already DMA mapped */
+int ath10k_wmi_beacon_send_ref_nowait(struct ath10k *ar, u32 vdev_id,
+				      struct sk_buff *beacon)
 {
-	struct wmi_bcn_tx_cmd *cmd;
+	struct wmi_bcn_tx_ref_cmd *cmd;
 	struct sk_buff *skb;
 	int ret;
+	struct ieee80211_hdr *hdr;
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
+	cmd->vdev_id = __cpu_to_le32(vdev_id);
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
index 0087d69..cba56ff 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -3391,6 +3391,20 @@ struct wmi_bcn_tx_arg {
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
+	__le32 data_ptr; /* dma pointer */
+	__le32 msdu_id; /* id for host to track */
+	__le32 frame_control;
+	__le32 flags; /* WMI_BCN_TX_REF_FLAG_ */
+} __packed;
+
 /* Beacon filter */
 #define WMI_BCN_FILTER_ALL   0 /* Filter all beacons */
 #define WMI_BCN_FILTER_NONE  1 /* Pass all beacons */
@@ -4167,5 +4181,7 @@ int ath10k_wmi_request_stats(struct ath10k *ar, enum wmi_stats_id stats_id);
 int ath10k_wmi_force_fw_hang(struct ath10k *ar,
 			     enum wmi_force_fw_hang_type type, u32 delay_ms);
 int ath10k_wmi_mgmt_tx(struct ath10k *ar, struct sk_buff *skb);
+int ath10k_wmi_beacon_send_ref_nowait(struct ath10k *ar, u32 vdev_id,
+				      struct sk_buff *beacon);
 
 #endif /* _WMI_H_ */
-- 
1.8.1.2

