Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60528 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448Ab3CYKeh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Mar 2013 06:34:37 -0400
Cc: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qca.qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>,
	Pandiyarajan Pitchaimuthu <c_ppitch@qca.qualcomm.com>
From: Raja Mani <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
Subject: [PATCH v2] ath6kl: Add rx workqueue for SDIO
Date: Mon, 25 Mar 2013 16:04:13 +0530
Message-ID: <1364207653-5137-1-git-send-email-rmani@qca.qualcomm.com> (sfid-20130325_113441_951533_CB108D5E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the current implementation, all RX packets (data and control)
are fetched from the chip and processed in ISR handler context.
ISR handler has to process fetched packets first before it goes
ahead and fetch further packets from the chip. In high throughput
scenario, doing everything (read and process) in one context is
time consuming and it's not quicker way of reading RX packets from
the chip.

This patch lets ISR to read packets (data and control) from the chip
and process control packets alone (EP0 pkts). All data packets are
moved to another queue which is separately processed by another worker
thread. So that, ISR doesn't have to wait to read further packets until
fetched data packets are processed. With this change, significant
improvement is seen both in TCP (around 10 Mpbs) and UDP (around 5 Mpbs)
down-link case.

Signed-off-by: Pandiyarajan Pitchaimuthu <c_ppitch@qca.qualcomm.com>
Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---

V2 changes :

v2 addresses comments given by Kalle and Adrian Chadd.
  * Renamed rx_comp_lock to rx_bufq_lock for consistency.
  * Temp list used to avoid constant unlock/relock while processing packets.

In addition, unprocessed packets in target->rx_bufq are freed in
cleanup function.

 drivers/net/wireless/ath/ath6kl/htc.h      |    6 +++
 drivers/net/wireless/ath/ath6kl/htc_mbox.c |   66 +++++++++++++++++++++++++++-
 2 files changed, 71 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc.h b/drivers/net/wireless/ath/ath6kl/htc.h
index a2c8ff8..7179fb5 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.h
+++ b/drivers/net/wireless/ath/ath6kl/htc.h
@@ -620,6 +620,12 @@ struct htc_target {
 	/* counts the number of Tx without bundling continously per AC */
 	u32 ac_tx_count[WMM_NUM_AC];
 
+	struct workqueue_struct *rx_wq;
+	struct work_struct rx_work;
+
+	struct list_head rx_bufq;
+	spinlock_t rx_bufq_lock;
+
 	struct {
 		struct htc_packet *htc_packet_pool;
 		u8 ctrl_response_buf[HTC_MAX_CTRL_MSG_LEN];
diff --git a/drivers/net/wireless/ath/ath6kl/htc_mbox.c b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
index 65e5b71..10700f4 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_mbox.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
@@ -1909,14 +1909,55 @@ fail_rx:
 	return status;
 }
 
+static void ath6kl_htc_rx_work(struct work_struct *work)
+{
+	struct htc_target *target;
+	struct htc_packet *packet, *tmp_pkt;
+	struct htc_endpoint *endpoint;
+	struct list_head temp_rx_bufq;
+
+	target = container_of(work, struct htc_target, rx_work);
+
+	INIT_LIST_HEAD(&temp_rx_bufq);
+
+	spin_lock_bh(&target->rx_bufq_lock);
+	list_for_each_entry_safe(packet, tmp_pkt, &target->rx_bufq, list) {
+		list_del(&packet->list);
+		list_add_tail(&packet->list, &temp_rx_bufq);
+	}
+	spin_unlock_bh(&target->rx_bufq_lock);
+
+	list_for_each_entry_safe(packet, tmp_pkt, &temp_rx_bufq, list) {
+		list_del(&packet->list);
+		endpoint = &target->endpoint[packet->endpoint];
+
+		ath6kl_dbg(ATH6KL_DBG_HTC,
+			   "htc rx complete ep %d packet 0x%p\n",
+			   endpoint->eid, packet);
+
+		endpoint->ep_cb.rx(endpoint->target, packet);
+	}
+}
+
 static void ath6kl_htc_rx_complete(struct htc_endpoint *endpoint,
 				   struct htc_packet *packet)
 {
+	struct htc_target *target;
+
+	if (endpoint->eid == ENDPOINT_0) {
 		ath6kl_dbg(ATH6KL_DBG_HTC,
 			   "htc rx complete ep %d packet 0x%p\n",
 			   endpoint->eid, packet);
-
 		endpoint->ep_cb.rx(endpoint->target, packet);
+	} else {
+		target = endpoint->target;
+
+		spin_lock_bh(&target->rx_bufq_lock);
+		list_add_tail(&packet->list, &target->rx_bufq);
+		spin_unlock_bh(&target->rx_bufq_lock);
+
+		queue_work(target->rx_wq, &target->rx_work);
+	}
 }
 
 static int ath6kl_htc_rx_bundle(struct htc_target *target,
@@ -2871,13 +2912,24 @@ static void *ath6kl_htc_mbox_create(struct ath6kl *ar)
 		goto err_htc_cleanup;
 	}
 
+	target->rx_wq = create_singlethread_workqueue("htc_rx");
+	if (!target->rx_wq) {
+		ath6kl_err("unable to create rx_wq workqueue\n");
+		status = -ENOMEM;
+		goto err_htc_cleanup;
+	}
+
 	spin_lock_init(&target->htc_lock);
 	spin_lock_init(&target->rx_lock);
 	spin_lock_init(&target->tx_lock);
+	spin_lock_init(&target->rx_bufq_lock);
 
 	INIT_LIST_HEAD(&target->free_ctrl_txbuf);
 	INIT_LIST_HEAD(&target->free_ctrl_rxbuf);
 	INIT_LIST_HEAD(&target->cred_dist_list);
+	INIT_LIST_HEAD(&target->rx_bufq);
+
+	INIT_WORK(&target->rx_work, ath6kl_htc_rx_work);
 
 	target->dev->ar = ar;
 	target->dev->htc_cnxt = target;
@@ -2904,6 +2956,18 @@ static void ath6kl_htc_mbox_cleanup(struct htc_target *target)
 {
 	struct htc_packet *packet, *tmp_packet;
 
+	destroy_workqueue(target->rx_wq);
+
+	if (!list_empty(&target->rx_bufq)) {
+		spin_lock_bh(&target->rx_bufq_lock);
+		list_for_each_entry_safe(packet, tmp_packet,
+					 &target->rx_bufq, list) {
+			list_del(&packet->list);
+			dev_kfree_skb(packet->pkt_cntxt);
+		}
+		spin_unlock_bh(&target->rx_bufq_lock);
+	}
+
 	ath6kl_hif_cleanup_scatter(target->dev->ar);
 
 	list_for_each_entry_safe(packet, tmp_packet,
-- 
1.7.1

