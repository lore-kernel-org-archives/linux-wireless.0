Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11237 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbaJ1QqS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 12:46:18 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: add tracing for tx ieee80211 header
Date: Tue, 28 Oct 2014 22:18:05 +0530
Message-ID: <1414514885-3694-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20141028_174622_538480_F18A0459)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For packet log, the transmitted frame 802.11 header alone is sufficient.
Recording entire packet is also consuming lot of disk space. To
optimize, add tracepoints for sending tx-ed 802.11 headers alone.

Cc: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt_tx.c |  1 +
 drivers/net/wireless/ath/ath10k/trace.h  | 16 ++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c    |  3 +++
 3 files changed, 20 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index b0df470..91f8fc1 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -565,6 +565,7 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	ath10k_dbg_dump(ar, ATH10K_DBG_HTT_DUMP, NULL, "htt tx msdu: ",
 			msdu->data, msdu->len);
 	trace_ath10k_htt_tx_msdu(ar, msdu->data, msdu->len);
+	trace_ath10k_htt_tx_msdu_hdr(ar, hdr, sizeof(*hdr));
 
 	sg_items[0].transfer_id = 0;
 	sg_items[0].transfer_context = NULL;
diff --git a/drivers/net/wireless/ath/ath10k/trace.h b/drivers/net/wireless/ath/ath10k/trace.h
index b9a2ba6..368376a 100644
--- a/drivers/net/wireless/ath/ath10k/trace.h
+++ b/drivers/net/wireless/ath/ath10k/trace.h
@@ -392,6 +392,22 @@ DEFINE_EVENT(ath10k_data_event, ath10k_htt_rx_desc,
 	     TP_PROTO(struct ath10k *ar, void *data, size_t len),
 	     TP_ARGS(ar, data, len)
 );
+
+DEFINE_EVENT(ath10k_data_event, ath10k_htt_tx_msdu_hdr,
+	     TP_PROTO(struct ath10k *ar, void *data, size_t len),
+	     TP_ARGS(ar, data, len)
+);
+
+DEFINE_EVENT(ath10k_data_event, ath10k_wmi_mgmt_tx_hdr,
+	     TP_PROTO(struct ath10k *ar, void *data, size_t len),
+	     TP_ARGS(ar, data, len)
+);
+
+DEFINE_EVENT(ath10k_data_event, ath10k_wmi_bcn_tx_hdr,
+	     TP_PROTO(struct ath10k *ar, void *data, size_t len),
+	     TP_ARGS(ar, data, len)
+);
+
 #endif /* _TRACE_H_ || TRACE_HEADER_MULTI_READ*/
 
 /* we don't want to use include/trace/events */
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index ae746ce..f169ae8 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -835,6 +835,7 @@ int ath10k_wmi_mgmt_tx(struct ath10k *ar, struct sk_buff *skb)
 		   wmi_skb, wmi_skb->len, fc & IEEE80211_FCTL_FTYPE,
 		   fc & IEEE80211_FCTL_STYPE);
 	trace_ath10k_wmi_mgmt_tx(ar, skb->data, skb->len);
+	trace_ath10k_wmi_mgmt_tx_hdr(ar, hdr, sizeof(*hdr));
 
 	/* Send the management frame buffer to the target */
 	ret = ath10k_wmi_cmd_send(ar, wmi_skb, ar->wmi.cmd->mgmt_tx_cmdid);
@@ -1894,6 +1895,8 @@ static void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 		arvif->beacon_sent = false;
 
 		trace_ath10k_wmi_bcn_tx(ar, bcn->data, bcn->len);
+		trace_ath10k_wmi_bcn_tx_hdr(ar, bcn->data,
+					    sizeof(struct ieee80211_hdr));
 		ath10k_wmi_tx_beacon_nowait(arvif);
 skip:
 		spin_unlock_bh(&ar->data_lock);
-- 
2.1.2

