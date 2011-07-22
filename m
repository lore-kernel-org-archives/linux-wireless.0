Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54611 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab1GVFnK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 01:43:10 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Subject: [PATCH 16/31] ath6kl: Remove callback msg_pending() and used the function directly
Date: Fri, 22 Jul 2011 08:41:49 +0300
Message-ID: <1311313324-6766-18-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110722_074334_851088_8A04FDD9)
In-Reply-To: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc.c     |    6 ++----
 drivers/net/wireless/ath/ath6kl/htc.h     |    2 ++
 drivers/net/wireless/ath/ath6kl/htc_hif.c |    3 ++-
 drivers/net/wireless/ath/ath6kl/htc_hif.h |    2 --
 4 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index a359332..052dc19 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -1723,9 +1723,8 @@ static int htc_fetch_rxpkts(struct htc_target *target,
 	return status;
 }
 
-static int htc_rxmsg_pending_handler(struct htc_target *target,
-				     u32 msg_look_ahead[],
-				     int *num_pkts)
+int htc_rxmsg_pending_handler(struct htc_target *target, u32 msg_look_ahead[],
+			      int *num_pkts)
 {
 	struct htc_packet *packets, *tmp_pkt;
 	struct htc_endpoint *endpoint;
@@ -2388,7 +2387,6 @@ void *htc_create(struct ath6kl *ar)
 
 	target->dev->ar = ar;
 	target->dev->htc_cnxt = target;
-	target->dev->msg_pending = htc_rxmsg_pending_handler;
 	target->ep_waiting = ENDPOINT_MAX;
 
 	reset_ep_state(target);
diff --git a/drivers/net/wireless/ath/ath6kl/htc.h b/drivers/net/wireless/ath/ath6kl/htc.h
index ff0ed6f..fba226e 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.h
+++ b/drivers/net/wireless/ath/ath6kl/htc.h
@@ -549,6 +549,8 @@ void htc_indicate_activity_change(struct htc_target *target,
 				  enum htc_endpoint_id endpoint, bool active);
 int htc_get_rxbuf_num(struct htc_target *target, enum htc_endpoint_id endpoint);
 int htc_add_rxbuf_multiple(struct htc_target *target, struct list_head *pktq);
+int htc_rxmsg_pending_handler(struct htc_target *target, u32 msg_look_ahead[],
+			      int *n_pkts);
 
 static inline void set_htc_pkt_info(struct htc_packet *packet, void *context,
 				    u8 *buf, unsigned int len,
diff --git a/drivers/net/wireless/ath/ath6kl/htc_hif.c b/drivers/net/wireless/ath/ath6kl/htc_hif.c
index 043f85f..386bc28 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_hif.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_hif.c
@@ -416,7 +416,8 @@ static int proc_pending_irqs(struct ath6kl_device *dev, bool *done)
 		 * improve performance by reducing context switching when
 		 * we rapidly pull packets.
 		 */
-		status = dev->msg_pending(dev->htc_cnxt, &lk_ahd, &fetched);
+		status = htc_rxmsg_pending_handler(dev->htc_cnxt,
+						   &lk_ahd, &fetched);
 		if (status)
 			goto out;
 
diff --git a/drivers/net/wireless/ath/ath6kl/htc_hif.h b/drivers/net/wireless/ath/ath6kl/htc_hif.h
index 5e65f1e..8a8dfdd 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_hif.h
+++ b/drivers/net/wireless/ath/ath6kl/htc_hif.h
@@ -82,8 +82,6 @@ struct ath6kl_device {
 	u32 block_sz;
 	u32 block_mask;
 	struct htc_target *htc_cnxt;
-	int (*msg_pending) (struct htc_target *target, u32 lk_ahds[],
-			    int *npkts_fetched);
 	struct hif_dev_scat_sup_info hif_scat_info;
 	int max_rx_bndl_sz;
 	int max_tx_bndl_sz;
-- 
1.7.1

