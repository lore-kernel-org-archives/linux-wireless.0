Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:60494 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985Ab2CYOPq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Mar 2012 10:15:46 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath6kl-devel@qualcomm.com
Subject: [PATCH v2 2/9] ath6kl: Add tx_complete() to struct htc_ep_callbacks
Date: Sun, 25 Mar 2012 17:15:22 +0300
Message-Id: <1332684929-6405-3-git-send-email-kvalo@qca.qualcomm.com> (sfid-20120325_161631_819080_CE754F56)
In-Reply-To: <1332684929-6405-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1332684929-6405-1-git-send-email-kvalo@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is needed by the USB code. Also while at it replace one void pointer
with a properly typed pointer.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    3 ++-
 drivers/net/wireless/ath/ath6kl/htc.c  |    2 +-
 drivers/net/wireless/ath/ath6kl/htc.h  |    1 +
 drivers/net/wireless/ath/ath6kl/txrx.c |    5 +++--
 4 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index f1dd890..6485ef0 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -746,7 +746,8 @@ void init_netdev(struct net_device *dev);
 void ath6kl_cookie_init(struct ath6kl *ar);
 void ath6kl_cookie_cleanup(struct ath6kl *ar);
 void ath6kl_rx(struct htc_target *target, struct htc_packet *packet);
-void ath6kl_tx_complete(void *context, struct list_head *packet_queue);
+void ath6kl_tx_complete(struct htc_target *context,
+			struct list_head *packet_queue);
 enum htc_send_full_action ath6kl_tx_queue_full(struct htc_target *target,
 					       struct htc_packet *packet);
 void ath6kl_stop_txrx(struct ath6kl *ar);
diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index 4849d99..187f449 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -432,7 +432,7 @@ static void htc_tx_complete(struct htc_endpoint *endpoint,
 		   "htc tx complete ep %d pkts %d\n",
 		   endpoint->eid, get_queue_depth(txq));
 
-	ath6kl_tx_complete(endpoint->target->dev->ar, txq);
+	ath6kl_tx_complete(endpoint->target, txq);
 }
 
 static void htc_tx_comp_handler(struct htc_target *target,
diff --git a/drivers/net/wireless/ath/ath6kl/htc.h b/drivers/net/wireless/ath/ath6kl/htc.h
index 5027ccc..7b0c489 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.h
+++ b/drivers/net/wireless/ath/ath6kl/htc.h
@@ -319,6 +319,7 @@ enum htc_send_full_action {
 };
 
 struct htc_ep_callbacks {
+	void (*tx_complete) (struct htc_target *, struct htc_packet *);
 	void (*rx) (struct htc_target *, struct htc_packet *);
 	void (*rx_refill) (struct htc_target *, enum htc_endpoint_id endpoint);
 	enum htc_send_full_action (*tx_full) (struct htc_target *,
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index f85353f..befe305 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -666,9 +666,10 @@ static void ath6kl_tx_clear_node_map(struct ath6kl_vif *vif,
 	}
 }
 
-void ath6kl_tx_complete(void *context, struct list_head *packet_queue)
+void ath6kl_tx_complete(struct htc_target *target,
+			struct list_head *packet_queue)
 {
-	struct ath6kl *ar = context;
+	struct ath6kl *ar = target->dev->ar;
 	struct sk_buff_head skb_queue;
 	struct htc_packet *packet;
 	struct sk_buff *skb;
-- 
1.7.1

