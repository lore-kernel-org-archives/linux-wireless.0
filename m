Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:34999 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933304Ab3CHInF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Mar 2013 03:43:05 -0500
From: Raja Mani <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qca.qualcomm.com>,
	Pandiyarajan Pitchaimuthu <c_ppitch@qca.qualcomm.com>
Subject: [PATCH] ath6kl: Add rx workqueue for SDIO
Date: Fri, 8 Mar 2013 14:12:28 +0530
Message-ID: <1362732148-26384-1-git-send-email-rmani@qca.qualcomm.com> (sfid-20130308_094311_369203_AF3EBC4A)
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
 drivers/net/wireless/ath/ath6kl/htc.h      |    7 ++++
 drivers/net/wireless/ath/ath6kl/htc_mbox.c |   50 ++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc.h b/drivers/net/wireless/ath/ath6kl/htc.h
index a2c8ff8..485cd89 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.h
+++ b/drivers/net/wireless/ath/ath6kl/htc.h
@@ -620,6 +620,13 @@ struct htc_target {
 	/* counts the number of Tx without bundling continously per AC */
 	u32 ac_tx_count[WMM_NUM_AC];
 
+	/* protects rx_bufq */
+	spinlock_t rx_comp_lock;
+
+	struct workqueue_struct *rx_wq;
+	struct work_struct rx_work;
+	struct list_head rx_bufq;
+
 	struct {
 		struct htc_packet *htc_packet_pool;
 		u8 ctrl_response_buf[HTC_MAX_CTRL_MSG_LEN];
diff --git a/drivers/net/wireless/ath/ath6kl/htc_mbox.c b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
index fbb78df..6cd8213 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_mbox.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
@@ -1897,13 +1897,50 @@ fail_rx:
 	return status;
 }
 
+static void ath6kl_htc_rx_work(struct work_struct *work)
+{
+	struct htc_target *target;
+	struct htc_packet *packet, *tmp_pkt;
+	struct htc_endpoint *endpoint;
+
+	target = container_of(work, struct htc_target, rx_work);
+
+	spin_lock_bh(&target->rx_comp_lock);
+	list_for_each_entry_safe(packet, tmp_pkt, &target->rx_bufq, list) {
+		list_del(&packet->list);
+
+		spin_unlock_bh(&target->rx_comp_lock);
+		endpoint = &target->endpoint[packet->endpoint];
+
+		ath6kl_dbg(ATH6KL_DBG_HTC,
+			   "htc rx complete ep %d packet 0x%p\n",
+			   endpoint->eid, packet);
+
+		endpoint->ep_cb.rx(endpoint->target, packet);
+		spin_lock_bh(&target->rx_comp_lock);
+	}
+	spin_unlock_bh(&target->rx_comp_lock);
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
 		endpoint->ep_cb.rx(endpoint->target, packet);
+	} else {
+		target = endpoint->target;
+
+		spin_lock_bh(&target->rx_comp_lock);
+		list_add_tail(&packet->list, &target->rx_bufq);
+		spin_unlock_bh(&target->rx_comp_lock);
+
+		queue_work(target->rx_wq, &target->rx_work);
+	}
 }
 
 static int ath6kl_htc_rx_bundle(struct htc_target *target,
@@ -2852,13 +2889,24 @@ static void *ath6kl_htc_mbox_create(struct ath6kl *ar)
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
+	spin_lock_init(&target->rx_comp_lock);
 
 	INIT_LIST_HEAD(&target->free_ctrl_txbuf);
 	INIT_LIST_HEAD(&target->free_ctrl_rxbuf);
 	INIT_LIST_HEAD(&target->cred_dist_list);
+	INIT_LIST_HEAD(&target->rx_bufq);
+
+	INIT_WORK(&target->rx_work, ath6kl_htc_rx_work);
 
 	target->dev->ar = ar;
 	target->dev->htc_cnxt = target;
@@ -2885,6 +2933,8 @@ static void ath6kl_htc_mbox_cleanup(struct htc_target *target)
 {
 	struct htc_packet *packet, *tmp_packet;
 
+	destroy_workqueue(target->rx_wq);
+
 	ath6kl_hif_cleanup_scatter(target->dev->ar);
 
 	list_for_each_entry_safe(packet, tmp_packet,
-- 
1.7.1

