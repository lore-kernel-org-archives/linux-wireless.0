Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54611 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab1GVFnN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 01:43:13 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Subject: [PATCH 17/31] ath6kl: Move bundle size from ath6kl_device to htc_target
Date: Fri, 22 Jul 2011 08:41:50 +0300
Message-ID: <1311313324-6766-19-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110722_074321_923716_5E87BE01)
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
 drivers/net/wireless/ath/ath6kl/htc.c     |   16 ++++++++--------
 drivers/net/wireless/ath/ath6kl/htc.h     |    2 ++
 drivers/net/wireless/ath/ath6kl/htc_hif.h |    2 --
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index 052dc19..1964059 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -356,7 +356,7 @@ static int htc_setup_send_scat_list(struct htc_target *target,
 	int i, len, rem_scat, cred_pad;
 	int status = 0;
 
-	rem_scat = target->dev->max_tx_bndl_sz;
+	rem_scat = target->max_tx_bndl_sz;
 
 	for (i = 0; i < n_scat; i++) {
 		scat_req->scat_list[i].packet = NULL;
@@ -1532,7 +1532,7 @@ static int htc_issue_rxpkt_bundle(struct htc_target *target,
 {
 	struct hif_scatter_req *scat_req;
 	struct htc_packet *packet;
-	int rem_space = target->dev->max_rx_bndl_sz;
+	int rem_space = target->max_rx_bndl_sz;
 	int n_scat_pkt, status = 0, i, len;
 
 	n_scat_pkt = get_queue_depth(rxq);
@@ -2188,18 +2188,18 @@ static void htc_setup_msg_bndl(struct htc_target *target)
 		   target->msg_per_bndl_max);
 
 	/* Max rx bundle size is limited by the max tx bundle size */
-	target->dev->max_rx_bndl_sz = scat_info->max_xfer_szper_scatreq;
+	target->max_rx_bndl_sz = scat_info->max_xfer_szper_scatreq;
 	/* Max tx bundle size if limited by the extended mbox address range */
-	target->dev->max_tx_bndl_sz = min(HIF_MBOX0_EXT_WIDTH,
-					  scat_info->max_xfer_szper_scatreq);
+	target->max_tx_bndl_sz = min(HIF_MBOX0_EXT_WIDTH,
+				     scat_info->max_xfer_szper_scatreq);
 
 	ath6kl_dbg(ATH6KL_DBG_ANY, "max recv: %d max send: %d\n",
-		   target->dev->max_rx_bndl_sz, target->dev->max_tx_bndl_sz);
+		   target->max_rx_bndl_sz, target->max_tx_bndl_sz);
 
-	if (target->dev->max_tx_bndl_sz)
+	if (target->max_tx_bndl_sz)
 		target->tx_bndl_enable = true;
 
-	if (target->dev->max_rx_bndl_sz)
+	if (target->max_rx_bndl_sz)
 		target->rx_bndl_enable = true;
 
 	if ((target->tgt_cred_sz % target->dev->block_sz) != 0) {
diff --git a/drivers/net/wireless/ath/ath6kl/htc.h b/drivers/net/wireless/ath/ath6kl/htc.h
index fba226e..a8a76a9 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.h
+++ b/drivers/net/wireless/ath/ath6kl/htc.h
@@ -528,6 +528,8 @@ struct htc_target {
 
 	bool tx_bndl_enable;
 	int rx_bndl_enable;
+	int max_rx_bndl_sz;
+	int max_tx_bndl_sz;
 };
 
 void *htc_create(struct ath6kl *ar);
diff --git a/drivers/net/wireless/ath/ath6kl/htc_hif.h b/drivers/net/wireless/ath/ath6kl/htc_hif.h
index 8a8dfdd..024f2b6 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_hif.h
+++ b/drivers/net/wireless/ath/ath6kl/htc_hif.h
@@ -83,8 +83,6 @@ struct ath6kl_device {
 	u32 block_mask;
 	struct htc_target *htc_cnxt;
 	struct hif_dev_scat_sup_info hif_scat_info;
-	int max_rx_bndl_sz;
-	int max_tx_bndl_sz;
 	int chk_irq_status_cnt;
 	struct ath6kl *ar;
 };
-- 
1.7.1

