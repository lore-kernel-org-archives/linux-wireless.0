Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:34025 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759930AbbAYTbr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 14:31:47 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 01/14] brcmfmac: Relax scheduling of msgbuf worker on high throughput.
Date: Sun, 25 Jan 2015 20:31:30 +0100
Message-ID: <1422214303-7816-2-git-send-email-arend@broadcom.com> (sfid-20150125_204445_740498_95727B2B)
In-Reply-To: <1422214303-7816-1-git-send-email-arend@broadcom.com>
References: <1422214303-7816-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

On every tx the flow worker is triggered. When running high
throughput data this causes an excessive amount of times the worker
gets activated. This patch starts scheduling the worker more relaxed
once outstanding tx has reached a certain depth.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/commonring.h   |  2 ++
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c   | 30 +++++++++++++++++-----
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/commonring.h b/drivers/net/wireless/brcm80211/brcmfmac/commonring.h
index 002336e..3d40401 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/commonring.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/commonring.h
@@ -37,6 +37,8 @@ struct brcmf_commonring {
 	unsigned long flags;
 	bool inited;
 	bool was_full;
+
+	atomic_t outstanding_tx;
 };
 
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
index ee147f5..6262612 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
@@ -73,6 +73,8 @@
 #define BRCMF_MSGBUF_TX_FLUSH_CNT1		32
 #define BRCMF_MSGBUF_TX_FLUSH_CNT2		96
 
+#define BRCMF_MSGBUF_DELAY_TXWORKER_THRS	64
+#define BRCMF_MSGBUF_TRICKLE_TXWORKER_THRS	32
 
 struct msgbuf_common_hdr {
 	u8				msgtype;
@@ -749,6 +751,7 @@ static void brcmf_msgbuf_txflow(struct brcmf_msgbuf *msgbuf, u8 flowid)
 		tx_msghdr->metadata_buf_len = 0;
 		tx_msghdr->metadata_buf_addr.high_addr = 0;
 		tx_msghdr->metadata_buf_addr.low_addr = 0;
+		atomic_inc(&commonring->outstanding_tx);
 		if (count >= BRCMF_MSGBUF_TX_FLUSH_CNT2) {
 			brcmf_commonring_write_complete(commonring);
 			count = 0;
@@ -773,10 +776,16 @@ static void brcmf_msgbuf_txflow_worker(struct work_struct *worker)
 }
 
 
-static int brcmf_msgbuf_schedule_txdata(struct brcmf_msgbuf *msgbuf, u32 flowid)
+static int brcmf_msgbuf_schedule_txdata(struct brcmf_msgbuf *msgbuf, u32 flowid,
+					bool force)
 {
+	struct brcmf_commonring *commonring;
+
 	set_bit(flowid, msgbuf->flow_map);
-	queue_work(msgbuf->txflow_wq, &msgbuf->txflow_work);
+	commonring = msgbuf->flowrings[flowid];
+	if ((force) || (atomic_read(&commonring->outstanding_tx) <
+			BRCMF_MSGBUF_DELAY_TXWORKER_THRS))
+		queue_work(msgbuf->txflow_wq, &msgbuf->txflow_work);
 
 	return 0;
 }
@@ -797,7 +806,7 @@ static int brcmf_msgbuf_txdata(struct brcmf_pub *drvr, int ifidx,
 			return -ENOMEM;
 	}
 	brcmf_flowring_enqueue(flow, flowid, skb);
-	brcmf_msgbuf_schedule_txdata(msgbuf, flowid);
+	brcmf_msgbuf_schedule_txdata(msgbuf, flowid, false);
 
 	return 0;
 }
@@ -854,6 +863,7 @@ brcmf_msgbuf_process_ioctl_complete(struct brcmf_msgbuf *msgbuf, void *buf)
 static void
 brcmf_msgbuf_process_txstatus(struct brcmf_msgbuf *msgbuf, void *buf)
 {
+	struct brcmf_commonring *commonring;
 	struct msgbuf_tx_status *tx_status;
 	u32 idx;
 	struct sk_buff *skb;
@@ -871,6 +881,8 @@ brcmf_msgbuf_process_txstatus(struct brcmf_msgbuf *msgbuf, void *buf)
 	}
 
 	set_bit(flowid, msgbuf->txstatus_done_map);
+	commonring = msgbuf->flowrings[flowid];
+	atomic_dec(&commonring->outstanding_tx);
 
 	brcmf_txfinalize(msgbuf->drvr, skb, tx_status->msg.ifidx, true);
 }
@@ -1181,7 +1193,7 @@ brcmf_msgbuf_process_flow_ring_create_response(struct brcmf_msgbuf *msgbuf,
 
 	brcmf_flowring_open(msgbuf->flow, flowid);
 
-	brcmf_msgbuf_schedule_txdata(msgbuf, flowid);
+	brcmf_msgbuf_schedule_txdata(msgbuf, flowid, true);
 }
 
 
@@ -1280,8 +1292,10 @@ int brcmf_proto_msgbuf_rx_trigger(struct device *dev)
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_pub *drvr = bus_if->drvr;
 	struct brcmf_msgbuf *msgbuf = (struct brcmf_msgbuf *)drvr->proto->pd;
+	struct brcmf_commonring *commonring;
 	void *buf;
 	u32 flowid;
+	int qlen;
 
 	buf = msgbuf->commonrings[BRCMF_D2H_MSGRING_RX_COMPLETE];
 	brcmf_msgbuf_process_rx(msgbuf, buf);
@@ -1293,8 +1307,12 @@ int brcmf_proto_msgbuf_rx_trigger(struct device *dev)
 	for_each_set_bit(flowid, msgbuf->txstatus_done_map,
 			 msgbuf->nrof_flowrings) {
 		clear_bit(flowid, msgbuf->txstatus_done_map);
-		if (brcmf_flowring_qlen(msgbuf->flow, flowid))
-			brcmf_msgbuf_schedule_txdata(msgbuf, flowid);
+		commonring = msgbuf->flowrings[flowid];
+		qlen = brcmf_flowring_qlen(msgbuf->flow, flowid);
+		if ((qlen > BRCMF_MSGBUF_TRICKLE_TXWORKER_THRS) ||
+		    ((qlen) && (atomic_read(&commonring->outstanding_tx) <
+				BRCMF_MSGBUF_TRICKLE_TXWORKER_THRS)))
+			brcmf_msgbuf_schedule_txdata(msgbuf, flowid, true);
 	}
 
 	return 0;
-- 
1.9.1

