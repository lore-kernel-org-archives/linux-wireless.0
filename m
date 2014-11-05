Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62874 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854AbaKENma (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2014 08:42:30 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3] ath10k: handle ieee80211 header and payload tracing separately
Date: Wed, 5 Nov 2014 19:14:31 +0530
Message-ID: <1415195071-30250-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20141105_144239_630931_D86A984C)
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
v2: Move header len processing inside trace
v3: Replace ATH10K_FRM_HDR_LEN by inline function
 drivers/net/wireless/ath/ath10k/htt_rx.c |  4 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c |  3 +-
 drivers/net/wireless/ath/ath10k/trace.h  | 80 +++++++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath10k/wmi.c    |  7 ++-
 4 files changed, 78 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index a691fdf..52c6306 100644
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
@@ -903,6 +901,8 @@ static void ath10k_process_rx(struct ath10k *ar,
 		   !!(status->flag & RX_FLAG_AMSDU_MORE));
 	ath10k_dbg_dump(ar, ATH10K_DBG_HTT_DUMP, NULL, "rx skb: ",
 			skb->data, skb->len);
+	trace_ath10k_rx_hdr(ar, skb->data, skb->len);
+	trace_ath10k_rx_payload(ar, skb->data, skb->len);
 
 	ieee80211_rx(ar->hw, skb);
 }
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index b0df470..1e51249 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -564,7 +564,8 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 		   (u32)skb_cb->paddr, vdev_id, tid);
 	ath10k_dbg_dump(ar, ATH10K_DBG_HTT_DUMP, NULL, "htt tx msdu: ",
 			msdu->data, msdu->len);
-	trace_ath10k_htt_tx_msdu(ar, msdu->data, msdu->len);
+	trace_ath10k_tx_hdr(ar, msdu->data, msdu->len);
+	trace_ath10k_tx_payload(ar, msdu->data, msdu->len);
 
 	sg_items[0].transfer_id = 0;
 	sg_items[0].transfer_context = NULL;
diff --git a/drivers/net/wireless/ath/ath10k/trace.h b/drivers/net/wireless/ath/ath10k/trace.h
index b9a2ba6..ceea566 100644
--- a/drivers/net/wireless/ath/ath10k/trace.h
+++ b/drivers/net/wireless/ath/ath10k/trace.h
@@ -20,6 +20,13 @@
 #include <linux/tracepoint.h>
 #include "core.h"
 
+#if !defined(_TRACE_H_)
+static inline u32 ath10k_frm_hdr_len(void *buf)
+{
+	return ieee80211_hdrlen(((struct ieee80211_hdr *)buf)->frame_control);
+}
+#endif
+
 #define _TRACE_H_
 
 /* create empty functions when tracing is disabled */
@@ -341,7 +348,7 @@ TRACE_EVENT(ath10k_txrx_tx_unref,
 	 )
 );
 
-DECLARE_EVENT_CLASS(ath10k_data_event,
+DECLARE_EVENT_CLASS(ath10k_hdr_event,
 		    TP_PROTO(struct ath10k *ar, void *data, size_t len),
 
 	TP_ARGS(ar, data, len),
@@ -350,14 +357,14 @@ DECLARE_EVENT_CLASS(ath10k_data_event,
 		__string(device, dev_name(ar->dev))
 		__string(driver, dev_driver_string(ar->dev))
 		__field(size_t, len)
-		__dynamic_array(u8, data, len)
+		__dynamic_array(u8, data, ath10k_frm_hdr_len(data))
 	),
 
 	TP_fast_assign(
 		__assign_str(device, dev_name(ar->dev));
 		__assign_str(driver, dev_driver_string(ar->dev));
-		__entry->len = len;
-		memcpy(__get_dynamic_array(data), data, len);
+		__entry->len = ath10k_frm_hdr_len(data);
+		memcpy(__get_dynamic_array(data), data, __entry->len);
 	),
 
 	TP_printk(
@@ -368,30 +375,81 @@ DECLARE_EVENT_CLASS(ath10k_data_event,
 	)
 );
 
-DEFINE_EVENT(ath10k_data_event, ath10k_htt_tx_msdu,
-	     TP_PROTO(struct ath10k *ar, void *data, size_t len),
-	     TP_ARGS(ar, data, len)
+DECLARE_EVENT_CLASS(ath10k_payload_event,
+		    TP_PROTO(struct ath10k *ar, void *data, size_t len),
+
+	TP_ARGS(ar, data, len),
+
+	TP_STRUCT__entry(
+		__string(device, dev_name(ar->dev))
+		__string(driver, dev_driver_string(ar->dev))
+		__field(size_t, len)
+		__dynamic_array(u8, payload, (len - ath10k_frm_hdr_len(data)))
+	),
+
+	TP_fast_assign(
+		__assign_str(device, dev_name(ar->dev));
+		__assign_str(driver, dev_driver_string(ar->dev));
+		__entry->len = len - ath10k_frm_hdr_len(data);
+		memcpy(__get_dynamic_array(payload),
+		       data + ath10k_frm_hdr_len(data), __entry->len);
+	),
+
+	TP_printk(
+		"%s %s len %zu\n",
+		__get_str(driver),
+		__get_str(device),
+		__entry->len
+	)
 );
 
-DEFINE_EVENT(ath10k_data_event, ath10k_htt_rx_pop_msdu,
+DEFINE_EVENT(ath10k_hdr_event, ath10k_tx_hdr,
 	     TP_PROTO(struct ath10k *ar, void *data, size_t len),
 	     TP_ARGS(ar, data, len)
 );
 
-DEFINE_EVENT(ath10k_data_event, ath10k_wmi_mgmt_tx,
+DEFINE_EVENT(ath10k_payload_event, ath10k_tx_payload,
 	     TP_PROTO(struct ath10k *ar, void *data, size_t len),
 	     TP_ARGS(ar, data, len)
 );
 
-DEFINE_EVENT(ath10k_data_event, ath10k_wmi_bcn_tx,
+DEFINE_EVENT(ath10k_hdr_event, ath10k_rx_hdr,
 	     TP_PROTO(struct ath10k *ar, void *data, size_t len),
 	     TP_ARGS(ar, data, len)
 );
 
-DEFINE_EVENT(ath10k_data_event, ath10k_htt_rx_desc,
+DEFINE_EVENT(ath10k_payload_event, ath10k_rx_payload,
 	     TP_PROTO(struct ath10k *ar, void *data, size_t len),
 	     TP_ARGS(ar, data, len)
 );
+
+TRACE_EVENT(ath10k_htt_rx_desc,
+	    TP_PROTO(struct ath10k *ar, void *data, size_t len),
+
+	TP_ARGS(ar, data, len),
+
+	TP_STRUCT__entry(
+		__string(device, dev_name(ar->dev))
+		__string(driver, dev_driver_string(ar->dev))
+		__field(u16, len)
+		__dynamic_array(u8, rxdesc, len)
+	),
+
+	TP_fast_assign(
+		__assign_str(device, dev_name(ar->dev));
+		__assign_str(driver, dev_driver_string(ar->dev));
+		__entry->len = len;
+		memcpy(__get_dynamic_array(rxdesc), data, len);
+	),
+
+	TP_printk(
+		"%s %s rxdesc len %d",
+		__get_str(driver),
+		__get_str(device),
+		__entry->len
+	 )
+);
+
 #endif /* _TRACE_H_ || TRACE_HEADER_MULTI_READ*/
 
 /* we don't want to use include/trace/events */
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index ae746ce..3dcb216 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -834,7 +834,8 @@ int ath10k_wmi_mgmt_tx(struct ath10k *ar, struct sk_buff *skb)
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi mgmt tx skb %p len %d ftype %02x stype %02x\n",
 		   wmi_skb, wmi_skb->len, fc & IEEE80211_FCTL_FTYPE,
 		   fc & IEEE80211_FCTL_STYPE);
-	trace_ath10k_wmi_mgmt_tx(ar, skb->data, skb->len);
+	trace_ath10k_tx_hdr(ar, skb->data, skb->len);
+	trace_ath10k_tx_payload(ar, skb->data, skb->len);
 
 	/* Send the management frame buffer to the target */
 	ret = ath10k_wmi_cmd_send(ar, wmi_skb, ar->wmi.cmd->mgmt_tx_cmdid);
@@ -1893,7 +1894,9 @@ static void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 		arvif->beacon = bcn;
 		arvif->beacon_sent = false;
 
-		trace_ath10k_wmi_bcn_tx(ar, bcn->data, bcn->len);
+		trace_ath10k_tx_hdr(ar, bcn->data, bcn->len);
+		trace_ath10k_tx_payload(ar, bcn->data, bcn->len);
+
 		ath10k_wmi_tx_beacon_nowait(arvif);
 skip:
 		spin_unlock_bh(&ar->data_lock);
-- 
2.1.3

