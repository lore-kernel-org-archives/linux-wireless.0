Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-blr-02.qualcomm.com ([103.229.18.198]:42510 "EHLO
        alexa-out-blr.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S935099AbeF1JZ1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Jun 2018 05:25:27 -0400
From: Rakesh Pillai <pillair@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: [PATCH 2/2] ath10k: Handle mgmt tx completion event
Date: Thu, 28 Jun 2018 14:48:57 +0530
Message-Id: <1530177537-18487-3-git-send-email-pillair@codeaurora.org> (sfid-20180628_112537_504757_55E29298)
In-Reply-To: <1530177537-18487-1-git-send-email-pillair@codeaurora.org>
References: <1530177537-18487-1-git-send-email-pillair@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WCN3990 transmits management frames via WMI
with reference. Currently, with the management
tx completion not being handled, these frames are
not getting freed even after the transmission status
is returned by the firmware.

The transmitted management frames should be freed
when the firmware sends the over-the-air tx status of
the corresponding management frames.

Handle the wmi mgmt tx completion event and free
the corresponding management frame.

Tested HW: WCN3990
Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1

Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.c    |  1 +
 drivers/net/wireless/ath/ath10k/core.h    |  5 ++
 drivers/net/wireless/ath/ath10k/hw.h      |  1 +
 drivers/net/wireless/ath/ath10k/wmi-ops.h | 12 +++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 65 +++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h | 12 +++++
 drivers/net/wireless/ath/ath10k/wmi.c     | 84 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     |  7 +++
 8 files changed, 185 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 663c1ed..ebc2138 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2109,6 +2109,7 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 		ar->fw_stats_req_mask = WMI_STAT_PDEV | WMI_STAT_VDEV |
 			WMI_STAT_PEER;
 		ar->max_spatial_stream = WMI_MAX_SPATIAL_STREAM;
+		ar->wmi.mgmt_max_num_pending_tx = TARGET_TLV_MGMT_NUM_MSDU_DESC;
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_10_4:
 		ar->max_num_peers = TARGET_10_4_NUM_PEERS;
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 427ee57..9feea02 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -186,6 +186,11 @@ struct ath10k_wmi {
 	const struct wmi_ops *ops;
 	const struct wmi_peer_flags_map *peer_flags;
 
+	u32 mgmt_max_num_pending_tx;
+
+	/* Protected by data_lock */
+	struct idr mgmt_pending_tx;
+
 	u32 num_mem_chunks;
 	u32 rx_decap_mode;
 	struct ath10k_mem_chunk mem_chunks[WMI_MAX_MEM_REQS];
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 7a8da75..fac58c3 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -704,6 +704,7 @@ ath10k_rx_desc_get_l3_pad_bytes(struct ath10k_hw_params *hw,
 #define TARGET_TLV_NUM_TIDS			((TARGET_TLV_NUM_PEERS) * 2)
 #define TARGET_TLV_NUM_MSDU_DESC		(1024 + 32)
 #define TARGET_TLV_NUM_WOW_PATTERNS		22
+#define TARGET_TLV_MGMT_NUM_MSDU_DESC		(50)
 
 /* Target specific defines for WMI-HL-1.0 firmware */
 #define TARGET_HL_10_TLV_NUM_PEERS		14
diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 5ecce04..7fd63bb 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -31,6 +31,8 @@ struct wmi_ops {
 			 struct wmi_scan_ev_arg *arg);
 	int (*pull_mgmt_rx)(struct ath10k *ar, struct sk_buff *skb,
 			    struct wmi_mgmt_rx_ev_arg *arg);
+	int (*pull_mgmt_tx_compl)(struct ath10k *ar, struct sk_buff *skb,
+				  struct wmi_tlv_mgmt_tx_compl_ev_arg *arg);
 	int (*pull_ch_info)(struct ath10k *ar, struct sk_buff *skb,
 			    struct wmi_ch_info_ev_arg *arg);
 	int (*pull_vdev_start)(struct ath10k *ar, struct sk_buff *skb,
@@ -262,6 +264,16 @@ ath10k_wmi_pull_scan(struct ath10k *ar, struct sk_buff *skb,
 }
 
 static inline int
+ath10k_wmi_pull_mgmt_tx_compl(struct ath10k *ar, struct sk_buff *skb,
+			      struct wmi_tlv_mgmt_tx_compl_ev_arg *arg)
+{
+	if (!ar->wmi.ops->pull_mgmt_tx_compl)
+		return -EOPNOTSUPP;
+
+	return ar->wmi.ops->pull_mgmt_tx_compl(ar, skb, arg);
+}
+
+static inline int
 ath10k_wmi_pull_mgmt_rx(struct ath10k *ar, struct sk_buff *skb,
 			struct wmi_mgmt_rx_ev_arg *arg)
 {
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 21eb3a5..dd07a0c 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -618,6 +618,9 @@ static void ath10k_wmi_tlv_op_rx(struct ath10k *ar, struct sk_buff *skb)
 	case WMI_TLV_TDLS_PEER_EVENTID:
 		ath10k_wmi_event_tdls_peer(ar, skb);
 		break;
+	case WMI_TLV_MGMT_TX_COMPLETION_EVENTID:
+		ath10k_wmi_event_mgmt_tx_compl(ar, skb);
+		break;
 	default:
 		ath10k_warn(ar, "Unknown eventid: %d\n", id);
 		break;
@@ -659,6 +662,31 @@ static int ath10k_wmi_tlv_op_pull_scan_ev(struct ath10k *ar,
 	return 0;
 }
 
+static int
+ath10k_wmi_tlv_op_pull_mgmt_tx_compl_ev(struct ath10k *ar, struct sk_buff *skb,
+					struct wmi_tlv_mgmt_tx_compl_ev_arg *arg)
+{
+	const void **tb;
+	const struct wmi_tlv_mgmt_tx_compl_ev *ev;
+	int ret;
+
+	tb = ath10k_wmi_tlv_parse_alloc(ar, skb->data, skb->len, GFP_ATOMIC);
+	if (IS_ERR(tb)) {
+		ret = PTR_ERR(tb);
+		ath10k_warn(ar, "failed to parse tlv: %d\n", ret);
+		return ret;
+	}
+
+	ev = tb[WMI_TLV_TAG_STRUCT_MGMT_TX_COMPL_EVENT];
+
+	arg->desc_id = ev->desc_id;
+	arg->status = ev->status;
+	arg->pdev_id = ev->pdev_id;
+
+	kfree(tb);
+	return 0;
+}
+
 static int ath10k_wmi_tlv_op_pull_mgmt_rx_ev(struct ath10k *ar,
 					     struct sk_buff *skb,
 					     struct wmi_mgmt_rx_ev_arg *arg)
@@ -2610,6 +2638,30 @@ ath10k_wmi_tlv_op_gen_request_stats(struct ath10k *ar, u32 stats_mask)
 	return skb;
 }
 
+static int
+ath10k_wmi_mgmt_tx_alloc_msdu_id(struct ath10k *ar, struct sk_buff *skb,
+				 dma_addr_t paddr)
+{
+	struct ath10k_wmi *wmi = &ar->wmi;
+	struct ath10k_mgmt_tx_pkt_addr *pkt_addr;
+	int ret;
+
+	pkt_addr = kmalloc(sizeof(*pkt_addr), GFP_ATOMIC);
+	if (!pkt_addr)
+		return -ENOMEM;
+
+	pkt_addr->vaddr = skb;
+	pkt_addr->paddr = paddr;
+
+	spin_lock_bh(&ar->data_lock);
+	ret = idr_alloc(&wmi->mgmt_pending_tx, pkt_addr, 0,
+			wmi->mgmt_max_num_pending_tx, GFP_ATOMIC);
+	spin_unlock_bh(&ar->data_lock);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi mgmt tx alloc msdu_id ret %d\n", ret);
+	return ret;
+}
+
 static struct sk_buff *
 ath10k_wmi_tlv_op_gen_mgmt_tx_send(struct ath10k *ar, struct sk_buff *msdu,
 				   dma_addr_t paddr)
@@ -2621,9 +2673,9 @@ ath10k_wmi_tlv_op_gen_mgmt_tx_send(struct ath10k *ar, struct sk_buff *msdu,
 	u32 buf_len = msdu->len;
 	struct wmi_tlv *tlv;
 	struct sk_buff *skb;
+	int len, desc_id;
 	u32 vdev_id;
 	void *ptr;
-	int len;
 
 	if (!cb->vif)
 		return ERR_PTR(-EINVAL);
@@ -2654,13 +2706,17 @@ ath10k_wmi_tlv_op_gen_mgmt_tx_send(struct ath10k *ar, struct sk_buff *msdu,
 	if (!skb)
 		return ERR_PTR(-ENOMEM);
 
+	desc_id = ath10k_wmi_mgmt_tx_alloc_msdu_id(ar, msdu, paddr);
+	if (desc_id < 0)
+		goto err_free_skb;
+
 	ptr = (void *)skb->data;
 	tlv = ptr;
 	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_STRUCT_MGMT_TX_CMD);
 	tlv->len = __cpu_to_le16(sizeof(*cmd));
 	cmd = (void *)tlv->value;
 	cmd->vdev_id = __cpu_to_le32(vdev_id);
-	cmd->desc_id = 0;
+	cmd->desc_id = desc_id;
 	cmd->chanfreq = 0;
 	cmd->buf_len = __cpu_to_le32(buf_len);
 	cmd->frame_len = __cpu_to_le32(msdu->len);
@@ -2677,6 +2733,10 @@ ath10k_wmi_tlv_op_gen_mgmt_tx_send(struct ath10k *ar, struct sk_buff *msdu,
 	memcpy(ptr, msdu->data, buf_len);
 
 	return skb;
+
+err_free_skb:
+	dev_kfree_skb(skb);
+	return ERR_PTR(desc_id);
 }
 
 static struct sk_buff *
@@ -3840,6 +3900,7 @@ static const struct wmi_ops wmi_tlv_ops = {
 
 	.pull_scan = ath10k_wmi_tlv_op_pull_scan_ev,
 	.pull_mgmt_rx = ath10k_wmi_tlv_op_pull_mgmt_rx_ev,
+	.pull_mgmt_tx_compl = ath10k_wmi_tlv_op_pull_mgmt_tx_compl_ev,
 	.pull_ch_info = ath10k_wmi_tlv_op_pull_ch_info_ev,
 	.pull_vdev_start = ath10k_wmi_tlv_op_pull_vdev_start_ev,
 	.pull_peer_kick = ath10k_wmi_tlv_op_pull_peer_kick_ev,
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index 1cb93d0..4f0c20c 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -320,6 +320,7 @@ enum wmi_tlv_event_id {
 	WMI_TLV_TBTTOFFSET_UPDATE_EVENTID,
 	WMI_TLV_OFFLOAD_BCN_TX_STATUS_EVENTID,
 	WMI_TLV_OFFLOAD_PROB_RESP_TX_STATUS_EVENTID,
+	WMI_TLV_MGMT_TX_COMPLETION_EVENTID,
 	WMI_TLV_TX_DELBA_COMPLETE_EVENTID = WMI_TLV_EV(WMI_TLV_GRP_BA_NEG),
 	WMI_TLV_TX_ADDBA_COMPLETE_EVENTID,
 	WMI_TLV_BA_RSP_SSN_EVENTID,
@@ -1573,6 +1574,17 @@ struct wmi_tlv {
 	u8 value[0];
 } __packed;
 
+struct ath10k_mgmt_tx_pkt_addr {
+	void *vaddr;
+	dma_addr_t paddr;
+};
+
+struct wmi_tlv_mgmt_tx_compl_ev {
+	__le32 desc_id;
+	__le32 status;
+	__le32 pdev_id;
+};
+
 #define WMI_TLV_MGMT_RX_NUM_RSSI 4
 
 struct wmi_tlv_mgmt_rx_ev {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 877249a..f23ba5e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2313,6 +2313,58 @@ static bool ath10k_wmi_rx_is_decrypted(struct ath10k *ar,
 	return true;
 }
 
+static int wmi_process_mgmt_tx_comp(struct ath10k *ar, u32 desc_id,
+					u32 status)
+{
+	struct ath10k_mgmt_tx_pkt_addr *pkt_addr;
+	struct ath10k_wmi *wmi = &ar->wmi;
+	struct ieee80211_tx_info *info;
+	struct sk_buff *msdu;
+	int ret;
+
+	spin_lock_bh(&ar->data_lock);
+
+	pkt_addr = idr_find(&wmi->mgmt_pending_tx, desc_id);
+	if (!pkt_addr) {
+		ath10k_warn(ar, "received mgmt tx completion for invalid msdu_id: %d\n",
+			    desc_id);
+		ret = -ENOENT;
+		goto out;
+	}
+
+	msdu = pkt_addr->vaddr;
+	dma_unmap_single(ar->dev, pkt_addr->paddr,
+			 msdu->len, DMA_FROM_DEVICE);
+	info = IEEE80211_SKB_CB(msdu);
+	info->flags |= status;
+	ieee80211_tx_status_irqsafe(ar->hw, msdu);
+
+	ret = 0;
+
+out:
+	idr_remove(&wmi->mgmt_pending_tx, desc_id);
+	spin_unlock_bh(&ar->data_lock);
+	return ret;
+}
+
+int ath10k_wmi_event_mgmt_tx_compl(struct ath10k *ar, struct sk_buff *skb)
+{
+	struct wmi_tlv_mgmt_tx_compl_ev_arg arg;
+	int ret;
+
+	ret = ath10k_wmi_pull_mgmt_tx_compl(ar, skb, &arg);
+	if (ret) {
+		ath10k_warn(ar, "failed to parse mgmt comp event: %d\n", ret);
+		return ret;
+	}
+
+	wmi_process_mgmt_tx_comp(ar, arg.desc_id, arg.status);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv evnt mgmt tx completion\n");
+
+	return 0;
+}
+
 int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_mgmt_rx_ev_arg arg = {};
@@ -9073,6 +9125,11 @@ int ath10k_wmi_attach(struct ath10k *ar)
 	INIT_WORK(&ar->radar_confirmation_work,
 		  ath10k_radar_confirmation_work);
 
+	if (test_bit(ATH10K_FW_FEATURE_MGMT_TX_BY_REF,
+		     ar->running_fw->fw_file.fw_features)) {
+		idr_init(&ar->wmi.mgmt_pending_tx);
+	}
+
 	return 0;
 }
 
@@ -9091,8 +9148,35 @@ void ath10k_wmi_free_host_mem(struct ath10k *ar)
 	ar->wmi.num_mem_chunks = 0;
 }
 
+static int ath10k_wmi_mgmt_tx_clean_up_pending(int msdu_id, void *ptr,
+					       void *ctx)
+{
+	struct ath10k_mgmt_tx_pkt_addr *pkt_addr = ptr;
+	struct ath10k *ar = ctx;
+	struct sk_buff *msdu;
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
+		   "force cleanup mgmt msdu_id %hu\n", msdu_id);
+
+	msdu = pkt_addr->vaddr;
+	dma_unmap_single(ar->dev, pkt_addr->paddr,
+			 msdu->len, DMA_FROM_DEVICE);
+	ieee80211_free_txskb(ar->hw, msdu);
+
+	return 0;
+}
+
 void ath10k_wmi_detach(struct ath10k *ar)
 {
+	if (test_bit(ATH10K_FW_FEATURE_MGMT_TX_BY_REF,
+		     ar->running_fw->fw_file.fw_features)) {
+		spin_lock_bh(&ar->data_lock);
+		idr_for_each(&ar->wmi.mgmt_pending_tx,
+			     ath10k_wmi_mgmt_tx_clean_up_pending, ar);
+		idr_destroy(&ar->wmi.mgmt_pending_tx);
+		spin_unlock_bh(&ar->data_lock);
+	}
+
 	cancel_work_sync(&ar->svc_rdy_work);
 
 	if (ar->svc_rdy_skb)
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index b48db54..1b166aa 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -6599,6 +6599,12 @@ struct wmi_scan_ev_arg {
 	__le32 vdev_id;
 };
 
+struct wmi_tlv_mgmt_tx_compl_ev_arg {
+	__le32 desc_id;
+	__le32 status;
+	__le32 pdev_id;
+};
+
 struct wmi_mgmt_rx_ev_arg {
 	__le32 channel;
 	__le32 snr;
@@ -7070,6 +7076,7 @@ int ath10k_wmi_start_scan_verify(const struct wmi_start_scan_arg *arg);
 
 int ath10k_wmi_event_scan(struct ath10k *ar, struct sk_buff *skb);
 int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb);
+int ath10k_wmi_event_mgmt_tx_compl(struct ath10k *ar, struct sk_buff *skb);
 void ath10k_wmi_event_chan_info(struct ath10k *ar, struct sk_buff *skb);
 void ath10k_wmi_event_echo(struct ath10k *ar, struct sk_buff *skb);
 int ath10k_wmi_event_debug_mesg(struct ath10k *ar, struct sk_buff *skb);
-- 
2.7.4
