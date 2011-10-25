Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1254 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932324Ab1JYKO6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 06:14:58 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <nataraja@qca.qualcomm.com>,
	<athiruve@qca.qualcomm.com>
Subject: [PATCH 22/34] ath6kl: Use interface index from wmi data headr
Date: Tue, 25 Oct 2011 15:40:18 +0530
Message-ID: <1319537430-12459-23-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111025_121739_857214_DA5A51B3)
In-Reply-To: <1319537430-12459-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1319537430-12459-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Interface index is passed in wmi data header as well, use it
to get the corresponding vif structure.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    2 +-
 drivers/net/wireless/ath/ath6kl/main.c |    5 +--
 drivers/net/wireless/ath/ath6kl/txrx.c |   56 ++++++++++++++++++++++++--------
 drivers/net/wireless/ath/ath6kl/wmi.c  |   16 ++++----
 drivers/net/wireless/ath/ath6kl/wmi.h  |   21 +++++++++++-
 5 files changed, 73 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 3a0a651..bc8364f 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -608,7 +608,7 @@ struct htc_packet *ath6kl_alloc_amsdu_rxbuf(struct htc_target *target,
 void aggr_module_destroy(struct aggr_info *aggr_info);
 void aggr_reset_state(struct aggr_info *aggr_info);
 
-struct ath6kl_sta *ath6kl_find_sta(struct ath6kl *ar, u8 * node_addr);
+struct ath6kl_sta *ath6kl_find_sta(struct ath6kl_vif *vif, u8 * node_addr);
 struct ath6kl_sta *ath6kl_find_sta_by_aid(struct ath6kl *ar, u8 aid);
 
 void ath6kl_ready_event(void *devt, u8 * datap, u32 sw_ver, u32 abi_ver);
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index bf8eebf..a9ed8a0 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -20,10 +20,9 @@
 #include "target.h"
 #include "debug.h"
 
-struct ath6kl_sta *ath6kl_find_sta(struct ath6kl *ar, u8 *node_addr)
+struct ath6kl_sta *ath6kl_find_sta(struct ath6kl_vif *vif, u8 *node_addr)
 {
-	/* TODO: Findout vif */
-	struct ath6kl_vif *vif = ar->vif;
+	struct ath6kl *ar = vif->ar;
 	struct ath6kl_sta *conn = NULL;
 	u8 i, max_conn;
 
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 7e2d601..e4a6d8f 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -77,14 +77,13 @@ static u8 ath6kl_ibss_map_epid(struct sk_buff *skb, struct net_device *dev,
 	return ar->node_map[ep_map].ep_id;
 }
 
-static bool ath6kl_powersave_ap(struct ath6kl *ar, struct sk_buff *skb,
+static bool ath6kl_powersave_ap(struct ath6kl_vif *vif, struct sk_buff *skb,
 				bool *more_data)
 {
 	struct ethhdr *datap = (struct ethhdr *) skb->data;
 	struct ath6kl_sta *conn = NULL;
 	bool ps_queued = false, is_psq_empty = false;
-	/* TODO: Findout vif */
-	struct ath6kl_vif *vif = ar->vif;
+	struct ath6kl *ar = vif->ar;
 
 	if (is_multicast_ether_addr(datap->h_dest)) {
 		u8 ctr = 0;
@@ -134,7 +133,7 @@ static bool ath6kl_powersave_ap(struct ath6kl *ar, struct sk_buff *skb,
 			}
 		}
 	} else {
-		conn = ath6kl_find_sta(ar, datap->h_dest);
+		conn = ath6kl_find_sta(vif, datap->h_dest);
 		if (!conn) {
 			dev_kfree_skb(skb);
 
@@ -261,7 +260,7 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 
 	/* AP mode Power saving processing */
 	if (vif->nw_type == AP_NETWORK) {
-		if (ath6kl_powersave_ap(ar, skb, &more_data))
+		if (ath6kl_powersave_ap(vif, skb, &more_data))
 			return 0;
 	}
 
@@ -277,7 +276,8 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 		}
 
 		if (ath6kl_wmi_data_hdr_add(ar->wmi, skb, DATA_MSGTYPE,
-					    more_data, 0, 0, NULL)) {
+					    more_data, 0, 0, NULL,
+					    vif->fw_vif_idx)) {
 			ath6kl_err("wmi_data_hdr_add failed\n");
 			goto fail_tx;
 		}
@@ -534,6 +534,7 @@ void ath6kl_tx_complete(void *context, struct list_head *packet_queue)
 	enum htc_endpoint_id eid;
 	bool wake_event = false;
 	bool flushing = false;
+	u8 if_idx;
 	/* TODO: Findout vif */
 	struct ath6kl_vif *vif = ar->vif;
 
@@ -581,6 +582,20 @@ void ath6kl_tx_complete(void *context, struct list_head *packet_queue)
 				wake_event = true;
 		}
 
+		if (eid == ar->ctrl_ep) {
+			if_idx = wmi_cmd_hdr_get_if_idx(
+				(struct wmi_cmd_hdr *) skb->data);
+		} else {
+			if_idx = wmi_data_hdr_get_if_idx(
+				(struct wmi_data_hdr *) skb->data);
+		}
+
+		vif = ath6kl_get_vif_by_index(ar, if_idx);
+		if (!vif) {
+			ath6kl_free_cookie(ar, ath6kl_cookie);
+			continue;
+		}
+
 		if (status) {
 			if (status == -ECANCELED)
 				/* a packet was flushed  */
@@ -1053,10 +1068,9 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 	struct ath6kl_sta *conn = NULL;
 	struct sk_buff *skb1 = NULL;
 	struct ethhdr *datap = NULL;
-	/* TODO: Findout vif */
-	struct ath6kl_vif *vif = ar->vif;
+	struct ath6kl_vif *vif;
 	u16 seq_no, offset;
-	u8 tid;
+	u8 tid, if_idx;
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_RX,
 		   "%s: ar=0x%p eid=%d, skb=0x%p, data=0x%p, len=0x%x status:%d",
@@ -1064,7 +1078,23 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 		   packet->act_len, status);
 
 	if (status || !(skb->data + HTC_HDR_LENGTH)) {
-		vif->net_stats.rx_errors++;
+		dev_kfree_skb(skb);
+		return;
+	}
+
+	skb_put(skb, packet->act_len + HTC_HDR_LENGTH);
+	skb_pull(skb, HTC_HDR_LENGTH);
+
+	if (ept == ar->ctrl_ep) {
+		if_idx =
+		wmi_cmd_hdr_get_if_idx((struct wmi_cmd_hdr *) skb->data);
+	} else {
+		if_idx =
+		wmi_data_hdr_get_if_idx((struct wmi_data_hdr *) skb->data);
+	}
+
+	vif = ath6kl_get_vif_by_index(ar, if_idx);
+	if (!vif) {
 		dev_kfree_skb(skb);
 		return;
 	}
@@ -1080,8 +1110,6 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 
 	spin_unlock_bh(&ar->lock);
 
-	skb_put(skb, packet->act_len + HTC_HDR_LENGTH);
-	skb_pull(skb, HTC_HDR_LENGTH);
 
 	ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES, __func__, "rx ",
 			skb->data, skb->len);
@@ -1143,7 +1171,7 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 		}
 
 		datap = (struct ethhdr *) (skb->data + offset);
-		conn = ath6kl_find_sta(ar, datap->h_source);
+		conn = ath6kl_find_sta(vif, datap->h_source);
 
 		if (!conn) {
 			dev_kfree_skb(skb);
@@ -1250,7 +1278,7 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 			 * frame to it on the air else send the
 			 * frame up the stack.
 			 */
-			conn = ath6kl_find_sta(ar, datap->h_dest);
+			conn = ath6kl_find_sta(vif, datap->h_dest);
 
 			if (conn && ar->intra_bss) {
 				skb1 = skb;
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index ed092b7..ed95c2a 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -81,7 +81,7 @@ enum htc_endpoint_id ath6kl_wmi_get_control_ep(struct wmi *wmi)
 	return wmi->ep_id;
 }
 
-static struct ath6kl_vif *ath6kl_get_vif_by_index(struct ath6kl *ar, u8 if_idx)
+struct ath6kl_vif *ath6kl_get_vif_by_index(struct ath6kl *ar, u8 if_idx)
 {
 	if (WARN_ON(if_idx > (MAX_NUM_VIF - 1)))
 		return NULL;
@@ -170,12 +170,12 @@ static int ath6kl_wmi_meta_add(struct wmi *wmi, struct sk_buff *skb,
 int ath6kl_wmi_data_hdr_add(struct wmi *wmi, struct sk_buff *skb,
 			    u8 msg_type, bool more_data,
 			    enum wmi_data_hdr_data_type data_type,
-			    u8 meta_ver, void *tx_meta_info)
+			    u8 meta_ver, void *tx_meta_info, u8 if_idx)
 {
 	struct wmi_data_hdr *data_hdr;
 	int ret;
 
-	if (WARN_ON(skb == NULL))
+	if (WARN_ON(skb == NULL || (if_idx > MAX_NUM_VIF - 1)))
 		return -EINVAL;
 
 	if (tx_meta_info) {
@@ -197,7 +197,7 @@ int ath6kl_wmi_data_hdr_add(struct wmi *wmi, struct sk_buff *skb,
 		    WMI_DATA_HDR_MORE_MASK << WMI_DATA_HDR_MORE_SHIFT;
 
 	data_hdr->info2 = cpu_to_le16(meta_ver << WMI_DATA_HDR_META_SHIFT);
-	data_hdr->info3 = 0;
+	data_hdr->info3 = cpu_to_le16(if_idx & WMI_DATA_HDR_IF_IDX_MASK);
 
 	return 0;
 }
@@ -1631,7 +1631,7 @@ int ath6kl_wmi_cmd_send(struct wmi *wmi, u8 if_idx, struct sk_buff *skb,
 	/* Only for OPT_TX_CMD, use BE endpoint. */
 	if (cmd_id == WMI_OPT_TX_FRAME_CMDID) {
 		ret = ath6kl_wmi_data_hdr_add(wmi, skb, OPT_MSGTYPE,
-					      false, false, 0, NULL);
+					      false, false, 0, NULL, if_idx);
 		if (ret) {
 			dev_kfree_skb(skb);
 			return ret;
@@ -2098,7 +2098,7 @@ int ath6kl_wmi_setpmkid_cmd(struct wmi *wmi, u8 if_idx, const u8 *bssid,
 }
 
 static int ath6kl_wmi_data_sync_send(struct wmi *wmi, struct sk_buff *skb,
-			      enum htc_endpoint_id ep_id)
+			      enum htc_endpoint_id ep_id, u8 if_idx)
 {
 	struct wmi_data_hdr *data_hdr;
 	int ret;
@@ -2110,7 +2110,7 @@ static int ath6kl_wmi_data_sync_send(struct wmi *wmi, struct sk_buff *skb,
 
 	data_hdr = (struct wmi_data_hdr *) skb->data;
 	data_hdr->info = SYNC_MSGTYPE << WMI_DATA_HDR_MSG_TYPE_SHIFT;
-	data_hdr->info3 = 0;
+	data_hdr->info3 = cpu_to_le16(if_idx & WMI_DATA_HDR_IF_IDX_MASK);
 
 	ret = ath6kl_control_tx(wmi->parent_dev, skb, ep_id);
 
@@ -2192,7 +2192,7 @@ static int ath6kl_wmi_sync_point(struct wmi *wmi, u8 if_idx)
 					       traffic_class);
 		ret =
 		    ath6kl_wmi_data_sync_send(wmi, data_sync_bufs[index].skb,
-					      ep_id);
+					      ep_id, if_idx);
 
 		if (ret)
 			break;
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index d2c9510..621189b 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -173,6 +173,8 @@ enum wmi_data_hdr_data_type {
 #define WMI_DATA_HDR_META_MASK      0x7
 #define WMI_DATA_HDR_META_SHIFT     13
 
+#define WMI_DATA_HDR_IF_IDX_MASK    0xF
+
 struct wmi_data_hdr {
 	s8 rssi;
 
@@ -197,6 +199,12 @@ struct wmi_data_hdr {
 	 * b15:b13      - META_DATA_VERSION 0 - 7
 	 */
 	__le16 info2;
+
+	/*
+	 * usage of info3, 16-bit:
+	 * b3:b0	- Interface index
+	 * b15:b4	- Reserved
+	 */
 	__le16 info3;
 } __packed;
 
@@ -239,6 +247,11 @@ static inline u8 wmi_data_hdr_get_meta(struct wmi_data_hdr *dhdr)
 			       WMI_DATA_HDR_META_MASK;
 }
 
+static inline u8 wmi_data_hdr_get_if_idx(struct wmi_data_hdr *dhdr)
+{
+	return le16_to_cpu(dhdr->info3) & WMI_DATA_HDR_IF_IDX_MASK;
+}
+
 /* Tx meta version definitions */
 #define WMI_MAX_TX_META_SZ	12
 #define WMI_META_VERSION_1	0x01
@@ -303,6 +316,11 @@ struct wmi_cmd_hdr {
 	__le16 reserved;
 } __packed;
 
+static inline u8 wmi_cmd_hdr_get_if_idx(struct wmi_cmd_hdr *chdr)
+{
+	return le16_to_cpu(chdr->info1) & WMI_CMD_HDR_IF_ID_MASK;
+}
+
 /* List of WMI commands */
 enum wmi_cmd_id {
 	WMI_CONNECT_CMDID = 0x0001,
@@ -2167,7 +2185,7 @@ int ath6kl_wmi_dix_2_dot3(struct wmi *wmi, struct sk_buff *skb);
 int ath6kl_wmi_data_hdr_add(struct wmi *wmi, struct sk_buff *skb,
 			    u8 msg_type, bool more_data,
 			    enum wmi_data_hdr_data_type data_type,
-			    u8 meta_ver, void *tx_meta_info);
+			    u8 meta_ver, void *tx_meta_info, u8 if_idx);
 
 int ath6kl_wmi_dot11_hdr_remove(struct wmi *wmi, struct sk_buff *skb);
 int ath6kl_wmi_dot3_2_dix(struct sk_buff *skb);
@@ -2292,6 +2310,7 @@ int ath6kl_wmi_cancel_remain_on_chnl_cmd(struct wmi *wmi, u8 if_idx);
 int ath6kl_wmi_set_appie_cmd(struct wmi *wmi, u8 if_idx, u8 mgmt_frm_type,
 			     const u8 *ie, u8 ie_len);
 
+struct ath6kl_vif *ath6kl_get_vif_by_index(struct ath6kl *ar, u8 if_idx);
 void *ath6kl_wmi_init(struct ath6kl *devt);
 void ath6kl_wmi_shutdown(struct wmi *wmi);
 
-- 
1.7.0.4

