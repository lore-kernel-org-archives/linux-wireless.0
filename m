Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:38796 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab2L0LxB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Dec 2012 06:53:01 -0500
Subject: [PATCH 4/7] ath6kl: adding tracing points for htc_mbox
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com
Date: Thu, 27 Dec 2012 13:44:41 +0200
Message-ID: <20121227114440.27069.12251.stgit@localhost6.localdomain6> (sfid-20121227_125310_084693_F70AC6DC)
In-Reply-To: <20121227114156.27069.30223.stgit@localhost6.localdomain6>
References: <20121227114156.27069.30223.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add tracing points for htc layer, just dumping the packets to user space.
I wasn't really sure what to do with the status value, it might not always
be accurate, but I included it anyway.

I skipped htc_pipe (and usb) implementation for now. Need to add those
tracepoints later.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc_mbox.c |   21 ++++++++++-
 drivers/net/wireless/ath/ath6kl/trace.h    |   56 ++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc_mbox.c b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
index fbb78df..65e5b71 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_mbox.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
@@ -19,6 +19,8 @@
 #include "hif.h"
 #include "debug.h"
 #include "hif-ops.h"
+#include "trace.h"
+
 #include <asm/unaligned.h>
 
 #define CALC_TXRX_PADDED_LEN(dev, len)  (__ALIGN_MASK((len), (dev)->block_mask))
@@ -537,6 +539,8 @@ static int ath6kl_htc_tx_issue(struct htc_target *target,
 				packet->buf, padded_len,
 				HIF_WR_ASYNC_BLOCK_INC, packet);
 
+	trace_ath6kl_htc_tx(status, packet->endpoint, packet->buf, send_len);
+
 	return status;
 }
 
@@ -757,7 +761,8 @@ static void ath6kl_htc_tx_bundle(struct htc_endpoint *endpoint,
 {
 	struct htc_target *target = endpoint->target;
 	struct hif_scatter_req *scat_req = NULL;
-	int n_scat, n_sent_bundle = 0, tot_pkts_bundle = 0;
+	int n_scat, n_sent_bundle = 0, tot_pkts_bundle = 0, i;
+	struct htc_packet *packet;
 	int status;
 	u32 txb_mask;
 	u8 ac = WMM_NUM_AC;
@@ -832,6 +837,13 @@ static void ath6kl_htc_tx_bundle(struct htc_endpoint *endpoint,
 		ath6kl_dbg(ATH6KL_DBG_HTC,
 			   "htc tx scatter bytes %d entries %d\n",
 			   scat_req->len, scat_req->scat_entries);
+
+		for (i = 0; i < scat_req->scat_entries; i++) {
+			packet = scat_req->scat_list[i].packet;
+			trace_ath6kl_htc_tx(packet->status, packet->endpoint,
+					    packet->buf, packet->act_len);
+		}
+
 		ath6kl_hif_submit_scat_req(target->dev, scat_req, false);
 
 		if (status)
@@ -1903,6 +1915,7 @@ static void ath6kl_htc_rx_complete(struct htc_endpoint *endpoint,
 		ath6kl_dbg(ATH6KL_DBG_HTC,
 			   "htc rx complete ep %d packet 0x%p\n",
 			   endpoint->eid, packet);
+
 		endpoint->ep_cb.rx(endpoint->target, packet);
 }
 
@@ -2011,6 +2024,9 @@ static int ath6kl_htc_rx_process_packets(struct htc_target *target,
 	list_for_each_entry_safe(packet, tmp_pkt, comp_pktq, list) {
 		ep = &target->endpoint[packet->endpoint];
 
+		trace_ath6kl_htc_rx(packet->status, packet->endpoint,
+				    packet->buf, packet->act_len);
+
 		/* process header for each of the recv packet */
 		status = ath6kl_htc_rx_process_hdr(target, packet, lk_ahds,
 						   n_lk_ahd);
@@ -2291,6 +2307,9 @@ static struct htc_packet *htc_wait_for_ctrl_msg(struct htc_target *target)
 	if (ath6kl_htc_rx_packet(target, packet, packet->act_len))
 		goto fail_ctrl_rx;
 
+	trace_ath6kl_htc_rx(packet->status, packet->endpoint,
+			    packet->buf, packet->act_len);
+
 	/* process receive header */
 	packet->status = ath6kl_htc_rx_process_hdr(target, packet, NULL, NULL);
 
diff --git a/drivers/net/wireless/ath/ath6kl/trace.h b/drivers/net/wireless/ath/ath6kl/trace.h
index 6553dc1..f5838e0 100644
--- a/drivers/net/wireless/ath/ath6kl/trace.h
+++ b/drivers/net/wireless/ath/ath6kl/trace.h
@@ -136,6 +136,62 @@ TRACE_EVENT(ath6kl_sdio_irq,
 	)
 );
 
+TRACE_EVENT(ath6kl_htc_rx,
+	TP_PROTO(int status, int endpoint, void *buf,
+		 size_t buf_len),
+
+	TP_ARGS(status, endpoint, buf, buf_len),
+
+	TP_STRUCT__entry(
+		__field(int, status)
+		__field(int, endpoint)
+		__field(size_t, buf_len)
+		__dynamic_array(u8, buf, buf_len)
+	),
+
+	TP_fast_assign(
+		__entry->status = status;
+		__entry->endpoint = endpoint;
+		__entry->buf_len = buf_len;
+		memcpy(__get_dynamic_array(buf), buf, buf_len);
+	),
+
+	TP_printk(
+		"status %d endpoint %d len %d\n",
+		__entry->status,
+		__entry->endpoint,
+		__entry->buf_len
+	)
+);
+
+TRACE_EVENT(ath6kl_htc_tx,
+	TP_PROTO(int status, int endpoint, void *buf,
+		 size_t buf_len),
+
+	TP_ARGS(status, endpoint, buf, buf_len),
+
+	TP_STRUCT__entry(
+		__field(int, status)
+		__field(int, endpoint)
+		__field(size_t, buf_len)
+		__dynamic_array(u8, buf, buf_len)
+	),
+
+	TP_fast_assign(
+		__entry->status = status;
+		__entry->endpoint = endpoint;
+		__entry->buf_len = buf_len;
+		memcpy(__get_dynamic_array(buf), buf, buf_len);
+	),
+
+	TP_printk(
+		"status %d endpoint %d len %d\n",
+		__entry->status,
+		__entry->endpoint,
+		__entry->buf_len
+	)
+);
+
 #endif /* _ ATH6KL_TRACE_H || TRACE_HEADER_MULTI_READ*/
 
 /* we don't want to use include/trace/events */

