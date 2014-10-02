Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25477 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbaJBMFw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2014 08:05:52 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 4/4] ath10k: add tracing for tx msdu pktlog event
Date: Thu, 2 Oct 2014 17:36:10 +0530
Message-ID: <1412251570-31096-5-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20141002_140556_198441_79821E8F)
In-Reply-To: <1412251570-31096-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1412251570-31096-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is useful for collecting msdu statistics. For every msdu
entry in the pktlog message, corresponding msdu length is determined.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 48 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h     | 27 ++++++++++++++++++
 drivers/net/wireless/ath/ath10k/trace.h  | 33 ++++++++++++++++++++++
 3 files changed, 108 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index be24071..22ef0f4 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1569,6 +1569,48 @@ static void ath10k_htt_rx_delba(struct ath10k *ar, struct htt_resp *resp)
 	spin_unlock_bh(&ar->data_lock);
 }
 
+static void ath10k_htt_pktlog_msdu(struct ath10k *ar,
+				   struct ath10k_pktlog_hdr *hdr)
+{
+	struct ath10k_htt *htt = &ar->htt;
+	struct sk_buff *msdu;
+	__le32 num_msdu;
+	__le16 *msdu_id;
+	u16 msdu_len[MAX_PKT_INFO_MSDU_ID], id;
+	u32 i;
+
+	num_msdu = __le32_to_cpu(*((u32 *)hdr->payload)) * 2;
+	if (num_msdu >= MAX_PKT_INFO_MSDU_ID)
+		return;
+
+	msdu_id = (u16 *)&hdr->payload[MSDU_ID_INFO_ID_OFFSET];
+	memset(msdu_len, 0, sizeof(msdu_len));
+
+	spin_lock_bh(&htt->tx_lock);
+	for (i = 0; i < num_msdu; i++) {
+		id = __le16_to_cpu(*msdu_id);
+		if (id >= htt->max_num_pending_tx) {
+			msdu_id++;
+			continue;
+		}
+
+		msdu = htt->pending_tx[id];
+		if (!msdu) {
+			msdu_id++;
+			continue;
+		}
+
+		msdu_len[i] =
+			(hdr->flags & ATH10K_PKTLOG_FLG_TYPE_CLONE_S) ?
+			CLONED_PKT_MSDU_LEN_DEFAULT : (u16)msdu->len;
+		msdu_id++;
+	}
+	spin_unlock_bh(&htt->tx_lock);
+	trace_ath10k_htt_pktlog_msdu(ar, hdr->payload,
+				     sizeof(*hdr) + __le16_to_cpu(hdr->size),
+				     msdu_len, sizeof(msdu_len));
+}
+
 void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct ath10k_htt *htt = &ar->htt;
@@ -1680,6 +1722,12 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		struct ath10k_pktlog_hdr *hdr =
 			(struct ath10k_pktlog_hdr *)resp->pktlog_msg.payload;
 
+		if (__le16_to_cpu(hdr->log_type) ==
+				ATH10K_PKTLOG_TYPE_TX_MSDU_ID) {
+			ath10k_htt_pktlog_msdu(ar, hdr);
+			break;
+		}
+
 		trace_ath10k_htt_pktlog(ar, resp->pktlog_msg.payload,
 					sizeof(*hdr) +
 					__le16_to_cpu(hdr->size));
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 4b86ca3..57a4c72 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -80,6 +80,27 @@ enum ath10k_mcast2ucast_mode {
 	ATH10K_MCAST2UCAST_ENABLED = 1,
 };
 
+/* Types of packet log events */
+enum ath10k_pktlog_type {
+	ATH10K_PKTLOG_TYPE_TX_CTRL = 1,
+	ATH10K_PKTLOG_TYPE_TX_STAT,
+	ATH10K_PKTLOG_TYPE_TX_MSDU_ID,
+	ATH10K_PKTLOG_TYPE_TX_FRM_HDR,
+	ATH10K_PKTLOG_TYPE_RX_STAT,
+	ATH10K_PKTLOG_TYPE_RC_FIND,
+	ATH10K_PKTLOG_TYPE_RC_UPDATE,
+	ATH10K_PKTLOG_TYPE_TX_VIRT_ADDR,
+	ATH10K_PKTLOG_TYPE_DBG_PRINT,
+	ATH10K_PKTLOG_TYPE_MAX,
+};
+
+enum ath10k_pktlog_flag_type {
+	ATH10K_PKTLOG_FLG_TYPE_LOCAL_S = 0,
+	ATH10K_PKTLOG_FLG_TYPE_REMOTE_S,
+	ATH10K_PKTLOG_FLG_TYPE_CLONE_S,
+	ATH10K_PKTLOG_FLG_TYPE_UNKNOWN_S
+};
+
 struct ath10k_pktlog_hdr {
 	__le16 flags;
 	__le16 missed_cnt;
@@ -89,6 +110,12 @@ struct ath10k_pktlog_hdr {
 	u8 payload[0];
 } __packed;
 
+#define MAX_PKT_INFO_MSDU_ID 192
+#define MSDU_ID_INFO_ID_OFFSET  ((MAX_PKT_INFO_MSDU_ID >> 3) + 4)
+#define MSDU_ID_INFO_SIZE ((MAX_PKT_INFO_MSDU_ID >> 3) + 4 + \
+			   (MAX_PKT_INFO_MSDU_ID * 2))
+#define CLONED_PKT_MSDU_LEN_DEFAULT 200
+
 /* Target specific defines for MAIN firmware */
 #define TARGET_NUM_VDEVS			8
 #define TARGET_NUM_PEER_AST			2
diff --git a/drivers/net/wireless/ath/ath10k/trace.h b/drivers/net/wireless/ath/ath10k/trace.h
index 3dff799..4f8a20a 100644
--- a/drivers/net/wireless/ath/ath10k/trace.h
+++ b/drivers/net/wireless/ath/ath10k/trace.h
@@ -310,6 +310,39 @@ TRACE_EVENT(ath10k_rx_pktlog,
 		__entry->len
 	 )
 );
+
+TRACE_EVENT(ath10k_htt_pktlog_msdu,
+	    TP_PROTO(struct ath10k *ar, void *buf, u16 buf_len,
+		     void *msdu, u16 msdu_len),
+
+	TP_ARGS(ar, buf, buf_len, msdu, msdu_len),
+
+	TP_STRUCT__entry(
+		__string(device, dev_name(ar->dev))
+		__string(driver, dev_driver_string(ar->dev))
+		__field(u16, buf_len)
+		__dynamic_array(u8, pktlog, buf_len)
+		__field(u16, msdu_len)
+		__dynamic_array(u8, msdu, msdu_len)
+	),
+
+	TP_fast_assign(
+		__assign_str(device, dev_name(ar->dev));
+		__assign_str(driver, dev_driver_string(ar->dev));
+		__entry->buf_len = buf_len;
+		memcpy(__get_dynamic_array(pktlog), buf, buf_len);
+		__entry->msdu_len = msdu_len;
+		memcpy(__get_dynamic_array(msdu), msdu, msdu_len);
+	),
+
+	TP_printk(
+		"%s %s size %hu msdu size %hu",
+		__get_str(driver),
+		__get_str(device),
+		__entry->buf_len,
+		__entry->msdu_len
+	 )
+);
 #endif /* _TRACE_H_ || TRACE_HEADER_MULTI_READ*/
 
 /* we don't want to use include/trace/events */
-- 
2.1.1

