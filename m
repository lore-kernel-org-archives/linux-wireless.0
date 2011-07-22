Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24908 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab1GVFmi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 01:42:38 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Subject: [PATCH 04/31] ath6kl: Remove useless flags in hif_scatter_req
Date: Fri, 22 Jul 2011 08:41:37 +0300
Message-ID: <1311313324-6766-6-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110722_074255_160974_57625A64)
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
 drivers/net/wireless/ath/ath6kl/hif.h |    1 -
 drivers/net/wireless/ath/ath6kl/htc.c |    6 ------
 drivers/net/wireless/ath/ath6kl/htc.h |    4 ----
 3 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/hif.h b/drivers/net/wireless/ath/ath6kl/hif.h
index a5cdc71..f202f0d 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.h
+++ b/drivers/net/wireless/ath/ath6kl/hif.h
@@ -169,7 +169,6 @@ struct hif_scatter_req {
 	/* total length of entire transfer */
 	u32 len;
 
-	u32 flags;
 	void (*complete) (struct hif_scatter_req *);
 	int status;
 	struct htc_endpoint *ep;
diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index 95c47bb..e65de49 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -1563,12 +1563,6 @@ static int htc_issue_rxpkt_bundle(struct htc_target *target,
 	if (scat_req == NULL)
 		goto fail_rx_pkt;
 
-	scat_req->flags = 0;
-
-	if (part_bundle)
-		scat_req->flags |=
-		    HTC_SCAT_REQ_FLG_PART_BNDL;
-
 	for (i = 0; i < n_scat_pkt; i++) {
 		int pad_len;
 
diff --git a/drivers/net/wireless/ath/ath6kl/htc.h b/drivers/net/wireless/ath/ath6kl/htc.h
index 16fa7a8..ff0ed6f 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.h
+++ b/drivers/net/wireless/ath/ath6kl/htc.h
@@ -119,10 +119,6 @@
 #define HTC_RX_PKT_PART_OF_BUNDLE        (1 << 2)
 #define HTC_RX_PKT_NO_RECYCLE            (1 << 3)
 
-/* scatter request flags */
-
-#define HTC_SCAT_REQ_FLG_PART_BNDL  (1 << 0)
-
 #define NUM_CONTROL_BUFFERS     8
 #define NUM_CONTROL_TX_BUFFERS  2
 #define NUM_CONTROL_RX_BUFFERS  (NUM_CONTROL_BUFFERS - NUM_CONTROL_TX_BUFFERS)
-- 
1.7.1

