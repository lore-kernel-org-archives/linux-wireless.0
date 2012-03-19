Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:34684 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161563Ab2CSQP2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 12:15:28 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath6kl-devel@qualcomm.com
Subject: [PATCH 4/9] ath6kl: add pointer to the skb in htc_packet
Date: Mon, 19 Mar 2012 18:14:59 +0200
Message-Id: <1332173704-18877-5-git-send-email-kvalo@qca.qualcomm.com> (sfid-20120319_171646_862530_89700F24)
In-Reply-To: <1332173704-18877-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1332173704-18877-1-git-send-email-kvalo@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Needed by the USB code.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc.h  |    8 ++++++++
 drivers/net/wireless/ath/ath6kl/txrx.c |    5 +++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc.h b/drivers/net/wireless/ath/ath6kl/htc.h
index 51f2485..e97ebc3 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.h
+++ b/drivers/net/wireless/ath/ath6kl/htc.h
@@ -311,6 +311,14 @@ struct htc_packet {
 
 	void (*completion) (struct htc_target *, struct htc_packet *);
 	struct htc_target *context;
+
+	/*
+	 * optimization for network-oriented data, the HTC packet
+	 * can pass the network buffer corresponding to the HTC packet
+	 * lower layers may optimized the transfer knowing this is
+	 * a network buffer
+	 */
+	struct sk_buff *skb;
 };
 
 enum htc_send_full_action {
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index befe305..53d0334 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -322,6 +322,7 @@ int ath6kl_control_tx(void *devt, struct sk_buff *skb,
 	cookie->map_no = 0;
 	set_htc_pkt_info(&cookie->htc_pkt, cookie, skb->data, skb->len,
 			 eid, ATH6KL_CONTROL_PKT_TAG);
+	cookie->htc_pkt.skb = skb;
 
 	/*
 	 * This interface is asynchronous, if there is an error, cleanup
@@ -490,6 +491,7 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 	cookie->map_no = map_no;
 	set_htc_pkt_info(&cookie->htc_pkt, cookie, skb->data, skb->len,
 			 eid, htc_tag);
+	cookie->htc_pkt.skb = skb;
 
 	ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES, __func__, "tx ",
 			skb->data, skb->len);
@@ -888,6 +890,7 @@ void ath6kl_rx_refill(struct htc_target *target, enum htc_endpoint_id endpoint)
 			skb->data = PTR_ALIGN(skb->data - 4, 4);
 		set_htc_rxpkt_info(packet, skb, skb->data,
 				   ATH6KL_BUFFER_SIZE, endpoint);
+		packet->skb = skb;
 		list_add_tail(&packet->list, &queue);
 	}
 
@@ -910,6 +913,8 @@ void ath6kl_refill_amsdu_rxbufs(struct ath6kl *ar, int count)
 			skb->data = PTR_ALIGN(skb->data - 4, 4);
 		set_htc_rxpkt_info(packet, skb, skb->data,
 				   ATH6KL_AMSDU_BUFFER_SIZE, 0);
+		packet->skb = skb;
+
 		spin_lock_bh(&ar->lock);
 		list_add_tail(&packet->list, &ar->amsdu_rx_buffer_queue);
 		spin_unlock_bh(&ar->lock);
-- 
1.7.1

