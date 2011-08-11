Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23187 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab1HKGtQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 02:49:16 -0400
From: Kevin Fang <chienf@qca.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>, <kvalo@qca.qualcomm.com>,
	Kevin Fang <chienf@qca.qualcomm.com>
To: <linville@tuxdriver.com>
Subject: [PATCH 5/7] ath6kl: roll back tx complete and tx complete multi for USB
Date: Thu, 11 Aug 2011 14:48:13 +0800
Message-ID: <1313045295-16202-5-git-send-email-kevin.fang@qca.qualcomm.com> (sfid-20110811_084919_585468_4151D4DB)
In-Reply-To: <1313045295-16202-1-git-send-email-kevin.fang@qca.qualcomm.com>
References: <1313045295-16202-1-git-send-email-kevin.fang@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For usb on the AR6004, it needs both tx complete and
tx complete multi function. Therefore roll it back for usb usage.

Signed-off-by: Kevin Fang <kevin.fang@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    3 ++-
 drivers/net/wireless/ath/ath6kl/htc.c  |    2 +-
 drivers/net/wireless/ath/ath6kl/htc.h  |    2 ++
 drivers/net/wireless/ath/ath6kl/init.c |    1 +
 drivers/net/wireless/ath/ath6kl/txrx.c |    5 +++--
 5 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 768c349..f5cebc9 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -495,7 +495,8 @@ void init_netdev(struct net_device *dev);
 void ath6kl_cookie_init(struct ath6kl *ar);
 void ath6kl_cookie_cleanup(struct ath6kl *ar);
 void ath6kl_rx(struct htc_target *target, struct htc_packet *packet);
-void ath6kl_tx_complete(void *context, struct list_head *packet_queue);
+void ath6kl_tx_complete(struct htc_target *context,
+						struct list_head *packet_queue);
 enum htc_send_full_action ath6kl_tx_queue_full(struct htc_target *target,
 					       struct htc_packet *packet);
 void ath6kl_stop_txrx(struct ath6kl *ar);
diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index a8dc5c3..f0c17ad 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -111,7 +111,7 @@ static void htc_tx_complete(struct htc_endpoint *endpoint,
 		   "send complete ep %d, (%d pkts)\n",
 		   endpoint->eid, get_queue_depth(txq));
 
-	ath6kl_tx_complete(endpoint->target->dev->ar, txq);
+	ath6kl_tx_complete(endpoint->target, txq);
 }
 
 static void htc_tx_comp_handler(struct htc_target *target,
diff --git a/drivers/net/wireless/ath/ath6kl/htc.h b/drivers/net/wireless/ath/ath6kl/htc.h
index 8ce0c2c..2f18017 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.h
+++ b/drivers/net/wireless/ath/ath6kl/htc.h
@@ -316,12 +316,14 @@ enum htc_send_full_action {
 };
 
 struct htc_ep_callbacks {
+	void (*tx_complete) (struct htc_target *, struct htc_packet *);
 	void (*rx) (struct htc_target *, struct htc_packet *);
 	void (*rx_refill) (struct htc_target *, enum htc_endpoint_id endpoint);
 	enum htc_send_full_action (*tx_full) (struct htc_target *,
 					      struct htc_packet *);
 	struct htc_packet *(*rx_allocthresh) (struct htc_target *,
 					      enum htc_endpoint_id, int);
+	void (*tx_comp_multi) (struct htc_target *, struct list_head *);
 	int rx_alloc_thresh;
 	int rx_refill_thresh;
 };
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 5cc2697..ef0f97b 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -202,6 +202,7 @@ static int ath6kl_init_service_ep(struct ath6kl *ar)
 	memset(&connect, 0, sizeof(connect));
 
 	/* these fields are the same for all service endpoints */
+	connect.ep_cb.tx_comp_multi = ath6kl_tx_complete;
 	connect.ep_cb.rx = ath6kl_rx;
 	connect.ep_cb.rx_refill = ath6kl_rx_refill;
 	connect.ep_cb.tx_full = ath6kl_tx_queue_full;
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 167bdb9..2712cf0 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -496,9 +496,10 @@ static void ath6kl_tx_clear_node_map(struct ath6kl *ar,
 	}
 }
 
-void ath6kl_tx_complete(void *context, struct list_head *packet_queue)
+void ath6kl_tx_complete(struct htc_target *target,
+				struct list_head *packet_queue)
 {
-	struct ath6kl *ar = context;
+	struct ath6kl *ar = target->dev->ar;
 	struct sk_buff_head skb_queue;
 	struct htc_packet *packet;
 	struct sk_buff *skb;
-- 
1.7.0.4

