Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29054 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933592AbaJ2OH7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 10:07:59 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: handle ieee80211 header and payload tracing separately
Date: Wed, 29 Oct 2014 19:39:38 +0530
Message-ID: <1414591778-19040-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20141029_151355_898518_23CAA0BF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For packet log, the transmitted frame 802.11 header alone is sufficient.
Recording entire packet is also consuming lot of disk space. To optimize
this, tx and rx data tracepoints are splitted into header and payload
tracepoints.

To record tx ieee80211 headers

     trace-cmd record -e ath10k_tx_hdr

To record complete packets

     trace-cmd record -e ath10k_tx_hdr -e ath10k_tx_payload

Cc: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |  5 +++--
 drivers/net/wireless/ath/ath10k/htt_tx.c |  4 +++-
 drivers/net/wireless/ath/ath10k/trace.h  |  9 +++++----
 drivers/net/wireless/ath/ath10k/wmi.c    | 15 ++++++++++++---
 4 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index a691fdf..462f808 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -297,8 +297,6 @@ static inline struct sk_buff *ath10k_htt_rx_netbuf_pop(struct ath10k_htt *htt)
 			 DMA_FROM_DEVICE);
 	ath10k_dbg_dump(ar, ATH10K_DBG_HTT_DUMP, NULL, "htt rx netbuf pop: ",
 			msdu->data, msdu->len + skb_tailroom(msdu));
-	trace_ath10k_htt_rx_pop_msdu(ar, msdu->data, msdu->len +
-				     skb_tailroom(msdu));
 
 	return msdu;
 }
@@ -875,6 +873,7 @@ static void ath10k_process_rx(struct ath10k *ar,
 	struct ieee80211_rx_status *status;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	char tid[32];
+	u32 hdr_len = ieee80211_hdrlen(hdr->frame_control);
 
 	status = IEEE80211_SKB_RXCB(skb);
 	*status = *rx_status;
@@ -903,6 +902,8 @@ static void ath10k_process_rx(struct ath10k *ar,
 		   !!(status->flag & RX_FLAG_AMSDU_MORE));
 	ath10k_dbg_dump(ar, ATH10K_DBG_HTT_DUMP, NULL, "rx skb: ",
 			skb->data, skb->len);
+	trace_ath10k_rx_hdr(ar, hdr, hdr_len);
+	trace_ath10k_rx_payload(ar, skb->data + hdr_len, skb->len - hdr_len);
 
 	ieee80211_rx(ar->hw, skb);
 }
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index b0df470..b19d43b 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -455,6 +455,7 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	dma_addr_t paddr;
 	u32 frags_paddr;
 	bool use_frags;
+	u32 hdr_len = ieee80211_hdrlen(hdr->frame_control);
 
 	res = ath10k_htt_tx_inc_pending(htt);
 	if (res)
@@ -564,7 +565,8 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 		   (u32)skb_cb->paddr, vdev_id, tid);
 	ath10k_dbg_dump(ar, ATH10K_DBG_HTT_DUMP, NULL, "htt tx msdu: ",
 			msdu->data, msdu->len);
-	trace_ath10k_htt_tx_msdu(ar, msdu->data, msdu->len);
+	trace_ath10k_tx_hdr(ar, hdr, hdr_len);
+	trace_ath10k_tx_payload(ar, msdu->data + hdr_len, msdu->len - hdr_len);
 
 	sg_items[0].transfer_id = 0;
 	sg_items[0].transfer_context = NULL;
diff --git a/drivers/net/wireless/ath/ath10k/trace.h b/drivers/net/wireless/ath/ath10k/trace.h
index b9a2ba6..fd9e6bc 100644
--- a/drivers/net/wireless/ath/ath10k/trace.h
+++ b/drivers/net/wireless/ath/ath10k/trace.h
@@ -368,22 +368,22 @@ DECLARE_EVENT_CLASS(ath10k_data_event,
 	)
 );
 
-DEFINE_EVENT(ath10k_data_event, ath10k_htt_tx_msdu,
+DEFINE_EVENT(ath10k_data_event, ath10k_tx_hdr,
 	     TP_PROTO(struct ath10k *ar, void *data, size_t len),
 	     TP_ARGS(ar, data, len)
 );
 
-DEFINE_EVENT(ath10k_data_event, ath10k_htt_rx_pop_msdu,
+DEFINE_EVENT(ath10k_data_event, ath10k_tx_payload,
 	     TP_PROTO(struct ath10k *ar, void *data, size_t len),
 	     TP_ARGS(ar, data, len)
 );
 
-DEFINE_EVENT(ath10k_data_event, ath10k_wmi_mgmt_tx,
+DEFINE_EVENT(ath10k_data_event, ath10k_rx_hdr,
 	     TP_PROTO(struct ath10k *ar, void *data, size_t len),
 	     TP_ARGS(ar, data, len)
 );
 
-DEFINE_EVENT(ath10k_data_event, ath10k_wmi_bcn_tx,
+DEFINE_EVENT(ath10k_data_event, ath10k_rx_payload,
 	     TP_PROTO(struct ath10k *ar, void *data, size_t len),
 	     TP_ARGS(ar, data, len)
 );
@@ -392,6 +392,7 @@ DEFINE_EVENT(ath10k_data_event, ath10k_htt_rx_desc,
 	     TP_PROTO(struct ath10k *ar, void *data, size_t len),
 	     TP_ARGS(ar, data, len)
 );
+
 #endif /* _TRACE_H_ || TRACE_HEADER_MULTI_READ*/
 
 /* we don't want to use include/trace/events */
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index ae746ce..c241446 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -798,9 +798,11 @@ int ath10k_wmi_mgmt_tx(struct ath10k *ar, struct sk_buff *skb)
 	int len;
 	u32 buf_len = skb->len;
 	u16 fc;
+	u32 hdr_len;
 
 	hdr = (struct ieee80211_hdr *)skb->data;
 	fc = le16_to_cpu(hdr->frame_control);
+	hdr_len = ieee80211_hdrlen(hdr->frame_control);
 
 	if (WARN_ON_ONCE(!ieee80211_is_mgmt(hdr->frame_control)))
 		return -EINVAL;
@@ -834,7 +836,8 @@ int ath10k_wmi_mgmt_tx(struct ath10k *ar, struct sk_buff *skb)
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi mgmt tx skb %p len %d ftype %02x stype %02x\n",
 		   wmi_skb, wmi_skb->len, fc & IEEE80211_FCTL_FTYPE,
 		   fc & IEEE80211_FCTL_STYPE);
-	trace_ath10k_wmi_mgmt_tx(ar, skb->data, skb->len);
+	trace_ath10k_tx_hdr(ar, hdr, hdr_len);
+	trace_ath10k_tx_payload(ar, skb->data + hdr_len, skb->len - hdr_len);
 
 	/* Send the management frame buffer to the target */
 	ret = ath10k_wmi_cmd_send(ar, wmi_skb, ar->wmi.cmd->mgmt_tx_cmdid);
@@ -1791,7 +1794,8 @@ cleanup:
 static void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_host_swba_event *ev;
-	u32 map;
+	struct ieee80211_hdr *hdr;
+	u32 map, hdr_len;
 	int i = -1;
 	struct wmi_bcn_info *bcn_info;
 	struct ath10k_vif *arvif;
@@ -1893,7 +1897,12 @@ static void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 		arvif->beacon = bcn;
 		arvif->beacon_sent = false;
 
-		trace_ath10k_wmi_bcn_tx(ar, bcn->data, bcn->len);
+		hdr = (struct ieee80211_hdr *)bcn->data;
+		hdr_len = ieee80211_hdrlen(hdr->frame_control);
+		trace_ath10k_tx_hdr(ar, hdr, hdr_len);
+		trace_ath10k_tx_payload(ar, bcn->data + hdr_len,
+					bcn->len - hdr_len);
+
 		ath10k_wmi_tx_beacon_nowait(arvif);
 skip:
 		spin_unlock_bh(&ar->data_lock);
-- 
2.1.2

