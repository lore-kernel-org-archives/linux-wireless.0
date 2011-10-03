Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26248 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755475Ab1JCL7c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Oct 2011 07:59:32 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V2 4/4] ath6kl: Minor cleanup in msg_look_ahead parameter in ath6kl_htc_rxmsg_pending_handler()
Date: Mon, 3 Oct 2011 17:26:27 +0530
Message-ID: <1317642987-16026-4-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111003_135935_416784_440B5EE1)
In-Reply-To: <1317642987-16026-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1317642987-16026-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is just a four byte information of the received message
from ath6kl_htc_rxmsg_pending_handler(). Remove unnecessary
array representaion.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc.c     |    4 ++--
 drivers/net/wireless/ath/ath6kl/htc.h     |    2 +-
 drivers/net/wireless/ath/ath6kl/htc_hif.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index ca3d084..9a9eae5 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -1770,7 +1770,7 @@ fail_rx:
 }
 
 int ath6kl_htc_rxmsg_pending_handler(struct htc_target *target,
-				     u32 msg_look_ahead[], int *num_pkts)
+				     u32 msg_look_ahead, int *num_pkts)
 {
 	struct htc_packet *packets, *tmp_pkt;
 	struct htc_endpoint *endpoint;
@@ -1787,7 +1787,7 @@ int ath6kl_htc_rxmsg_pending_handler(struct htc_target *target,
 	 * On first entry copy the look_aheads into our temp array for
 	 * processing
 	 */
-	memcpy(look_aheads, msg_look_ahead, sizeof(look_aheads));
+	look_aheads[0] = msg_look_ahead;
 
 	while (true) {
 
diff --git a/drivers/net/wireless/ath/ath6kl/htc.h b/drivers/net/wireless/ath/ath6kl/htc.h
index 8ce0c2c..69d44e3 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.h
+++ b/drivers/net/wireless/ath/ath6kl/htc.h
@@ -563,7 +563,7 @@ int ath6kl_htc_get_rxbuf_num(struct htc_target *target,
 int ath6kl_htc_add_rxbuf_multiple(struct htc_target *target,
 				  struct list_head *pktq);
 int ath6kl_htc_rxmsg_pending_handler(struct htc_target *target,
-				     u32 msg_look_ahead[], int *n_pkts);
+				     u32 msg_look_ahead, int *n_pkts);
 
 static inline void set_htc_pkt_info(struct htc_packet *packet, void *context,
 				    u8 *buf, unsigned int len,
diff --git a/drivers/net/wireless/ath/ath6kl/htc_hif.c b/drivers/net/wireless/ath/ath6kl/htc_hif.c
index 86b1cc7..37a13f0 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_hif.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_hif.c
@@ -417,7 +417,7 @@ static int proc_pending_irqs(struct ath6kl_device *dev, bool *done)
 		 * we rapidly pull packets.
 		 */
 		status = ath6kl_htc_rxmsg_pending_handler(dev->htc_cnxt,
-							  &lk_ahd, &fetched);
+							  lk_ahd, &fetched);
 		if (status)
 			goto out;
 
-- 
1.7.0.4

