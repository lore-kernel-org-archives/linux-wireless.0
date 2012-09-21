Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6151 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374Ab2IUHPg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2012 03:15:36 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Jin Navy <nhjin@qca.qualcomm.com>
Subject: [PATCH] ath6kl: Fix random rx data corruption
Date: Fri, 21 Sep 2012 12:45:24 +0530
Message-ID: <1348211724-24243-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120921_091540_047681_A78DAE36)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The skb->tail pointer of rx buffers is not adjusted
after skb->data pointer is aligned to 4-byte, this
causes random rx data corruption.

Signed-off-by: Jin Navy <nhjin@qca.qualcomm.com>
Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/txrx.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index efee590..f070876 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -888,8 +888,11 @@ void ath6kl_rx_refill(struct htc_target *target, enum htc_endpoint_id endpoint)
 			break;
 
 		packet = (struct htc_packet *) skb->head;
-		if (!IS_ALIGNED((unsigned long) skb->data, 4))
+		if (!IS_ALIGNED((unsigned long) skb->data, 4)) {
+			size_t len = skb_headlen(skb);
 			skb->data = PTR_ALIGN(skb->data - 4, 4);
+			skb_set_tail_pointer(skb, len);
+		}
 		set_htc_rxpkt_info(packet, skb, skb->data,
 				   ATH6KL_BUFFER_SIZE, endpoint);
 		packet->skb = skb;
@@ -911,8 +914,11 @@ void ath6kl_refill_amsdu_rxbufs(struct ath6kl *ar, int count)
 			return;
 
 		packet = (struct htc_packet *) skb->head;
-		if (!IS_ALIGNED((unsigned long) skb->data, 4))
+		if (!IS_ALIGNED((unsigned long) skb->data, 4)) {
+			size_t len = skb_headlen(skb);
 			skb->data = PTR_ALIGN(skb->data - 4, 4);
+			skb_set_tail_pointer(skb, len);
+		}
 		set_htc_rxpkt_info(packet, skb, skb->data,
 				   ATH6KL_AMSDU_BUFFER_SIZE, 0);
 		packet->skb = skb;
-- 
1.7.0.4

