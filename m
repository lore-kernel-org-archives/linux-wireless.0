Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31084 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab1I2PBd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 11:01:33 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/4] ath6kl: Avoid processing failed rx packets
Date: Thu, 29 Sep 2011 20:31:15 +0530
Message-ID: <1317308476-16204-3-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110929_170136_987321_7FDFCCAD)
In-Reply-To: <1317308476-16204-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1317308476-16204-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is not necessary to process an htc_packet which is allocated for rx
but failed in sdio rx.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc.c |   48 +++++++++++++++++++++++---------
 1 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index 4a03dac..ca3d084 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -1687,11 +1687,15 @@ static int ath6kl_htc_rx_fetch(struct htc_target *target,
 	int fetched_pkts;
 	bool part_bundle = false;
 	int status = 0;
+	struct list_head tmp_rxq;
+	struct htc_packet *packet, *tmp_pkt;
 
 	/* now go fetch the list of HTC packets */
 	while (!list_empty(rx_pktq)) {
 		fetched_pkts = 0;
 
+		INIT_LIST_HEAD(&tmp_rxq);
+
 		if (target->rx_bndl_enable && (get_queue_depth(rx_pktq) > 1)) {
 			/*
 			 * There are enough packets to attempt a
@@ -1699,18 +1703,19 @@ static int ath6kl_htc_rx_fetch(struct htc_target *target,
 			 * allowed.
 			 */
 			status = ath6kl_htc_rx_bundle(target, rx_pktq,
-						      comp_pktq,
+						      &tmp_rxq,
 						      &fetched_pkts,
 						      part_bundle);
 			if (status)
-				return status;
+				goto fail_rx;
 
 			if (!list_empty(rx_pktq))
 				part_bundle = true;
+
+			list_splice_tail_init(&tmp_rxq, comp_pktq);
 		}
 
 		if (!fetched_pkts) {
-			struct htc_packet *packet;
 
 			packet = list_first_entry(rx_pktq, struct htc_packet,
 						   list);
@@ -1730,13 +1735,37 @@ static int ath6kl_htc_rx_fetch(struct htc_target *target,
 			/* go fetch the packet */
 			status = ath6kl_htc_rx_packet(target, packet,
 						      packet->act_len);
+
+			list_move_tail(&packet->list, &tmp_rxq);
+
 			if (status)
-				return status;
+				goto fail_rx;
 
-			list_move_tail(&packet->list, comp_pktq);
+			list_splice_tail_init(&tmp_rxq, comp_pktq);
 		}
 	}
 
+	return 0;
+
+fail_rx:
+
+	/*
+	 * Cleanup any packets we allocated but didn't use to
+	 * actually fetch any packets.
+	 */
+
+	list_for_each_entry_safe(packet, tmp_pkt, rx_pktq, list) {
+		list_del(&packet->list);
+		htc_reclaim_rxbuf(target, packet,
+				&target->endpoint[packet->endpoint]);
+	}
+
+	list_for_each_entry_safe(packet, tmp_pkt, &tmp_rxq, list) {
+		list_del(&packet->list);
+		htc_reclaim_rxbuf(target, packet,
+				&target->endpoint[packet->endpoint]);
+	}
+
 	return status;
 }
 
@@ -1826,15 +1855,6 @@ int ath6kl_htc_rxmsg_pending_handler(struct htc_target *target,
 	if (status) {
 		ath6kl_err("failed to get pending recv messages: %d\n",
 			   status);
-		/*
-		 * Cleanup any packets we allocated but didn't use to
-		 * actually fetch any packets.
-		 */
-		list_for_each_entry_safe(packets, tmp_pkt, &rx_pktq, list) {
-			list_del(&packets->list);
-			htc_reclaim_rxbuf(target, packets,
-					&target->endpoint[packets->endpoint]);
-		}
 
 		/* cleanup any packets in sync completion queue */
 		list_for_each_entry_safe(packets, tmp_pkt, &comp_pktq, list) {
-- 
1.7.0.4

