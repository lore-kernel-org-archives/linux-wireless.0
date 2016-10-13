Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:34376 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933191AbcJMQlu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 12:41:50 -0400
Received: by mail-lf0-f65.google.com with SMTP id x23so7787470lfi.1
        for <linux-wireless@vger.kernel.org>; Thu, 13 Oct 2016 09:41:31 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC 5/5] ath6kl: service connect rewrite
Date: Thu, 13 Oct 2016 18:39:29 +0200
Message-Id: <1476376769-4708-6-git-send-email-erik.stromdahl@gmail.com> (sfid-20161013_184200_276453_78D8978D)
In-Reply-To: <1476376769-4708-1-git-send-email-erik.stromdahl@gmail.com>
References: <1476376769-4708-1-git-send-email-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the hardcoded struct
htc_service_connect_req from ath6kl_init_service_ep and adds
an array of struct htc_service_connect_req's to each element
in hw_list.

The rationale behind this patch is to make it possible to select
which services to connect to depending on chipset.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath6kl/core.h     |   3 +
 drivers/net/wireless/ath/ath6kl/htc-ops.h  |   2 +-
 drivers/net/wireless/ath/ath6kl/htc.h      |   2 +-
 drivers/net/wireless/ath/ath6kl/htc_mbox.c |   2 +-
 drivers/net/wireless/ath/ath6kl/htc_pipe.c |   2 +-
 drivers/net/wireless/ath/ath6kl/init.c     | 187 +++++++++++++++++------------
 6 files changed, 117 insertions(+), 81 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index ac25f17..f907ef4 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -799,6 +799,9 @@ struct ath6kl {
 			const char *testscript;
 		} fw;
 
+		const struct htc_service_connect_req *services;
+		u32 service_count;
+
 		const char *fw_board;
 		const char *fw_default_board;
 	} hw;
diff --git a/drivers/net/wireless/ath/ath6kl/htc-ops.h b/drivers/net/wireless/ath/ath6kl/htc-ops.h
index 2d4eed5..80700a4 100644
--- a/drivers/net/wireless/ath/ath6kl/htc-ops.h
+++ b/drivers/net/wireless/ath/ath6kl/htc-ops.h
@@ -36,7 +36,7 @@ static inline int ath6kl_htc_start(struct htc_target *target)
 }
 
 static inline int ath6kl_htc_conn_service(struct htc_target *target,
-					  struct htc_service_connect_req *req,
+					  const struct htc_service_connect_req *req,
 					  struct htc_service_connect_resp *resp)
 {
 	return target->dev->ar->htc_ops->conn_service(target, req, resp);
diff --git a/drivers/net/wireless/ath/ath6kl/htc.h b/drivers/net/wireless/ath/ath6kl/htc.h
index 532b13b..bfff466 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.h
+++ b/drivers/net/wireless/ath/ath6kl/htc.h
@@ -550,7 +550,7 @@ struct ath6kl_htc_ops {
 	int (*wait_target)(struct htc_target *target);
 	int (*start)(struct htc_target *target);
 	int (*conn_service)(struct htc_target *target,
-			    struct htc_service_connect_req *req,
+			    const struct htc_service_connect_req *req,
 			    struct htc_service_connect_resp *resp);
 	int  (*tx)(struct htc_target *target, struct htc_packet *packet);
 	void (*stop)(struct htc_target *target);
diff --git a/drivers/net/wireless/ath/ath6kl/htc_mbox.c b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
index eed3939..24fb9a7 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_mbox.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
@@ -2386,7 +2386,7 @@ static void ath6kl_htc_mbox_flush_rx_buf(struct htc_target *target)
 }
 
 static int ath6kl_htc_mbox_conn_service(struct htc_target *target,
-			    struct htc_service_connect_req *conn_req,
+			    const struct htc_service_connect_req *conn_req,
 			    struct htc_service_connect_resp *conn_resp)
 {
 	struct htc_packet *rx_pkt = NULL;
diff --git a/drivers/net/wireless/ath/ath6kl/htc_pipe.c b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
index 93aac63..9a39f3d 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_pipe.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
@@ -1226,7 +1226,7 @@ static u8 htc_get_credit_alloc(struct htc_target *target, u16 service_id)
 }
 
 static int ath6kl_htc_pipe_conn_service(struct htc_target *target,
-		     struct htc_service_connect_req *conn_req,
+		     const struct htc_service_connect_req *conn_req,
 		     struct htc_service_connect_resp *conn_resp)
 {
 	struct ath6kl *ar = target->dev->ar;
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 58fb227..a4c7abe 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -32,6 +32,94 @@
 #include "hif-ops.h"
 #include "htc-ops.h"
 
+const struct htc_service_connect_req ar600x_services[] = {
+	{
+		.svc_id = WMI_CONTROL_SVC,
+		.ep_cb = {
+			.tx_comp_multi = ath6kl_tx_complete,
+			.rx = ath6kl_rx,
+			.rx_refill = ath6kl_rx_refill,
+			.tx_full = ath6kl_tx_queue_full,
+			.rx_refill_thresh = ATH6KL_MAX_RX_BUFFERS / 4,
+		},
+		.max_txq_depth = MAX_DEFAULT_SEND_QUEUE_DEPTH,
+	},
+	{
+		.svc_id = WMI_DATA_BE_SVC,
+		.conn_flags = HTC_CONN_FLGS_REDUCE_CRED_DRIB |
+			      HTC_CONN_FLGS_THRESH_LVL_HALF,
+		.ep_cb = {
+			.tx_comp_multi = ath6kl_tx_complete,
+			.rx = ath6kl_rx,
+			.rx_refill = ath6kl_rx_refill,
+			.tx_full = ath6kl_tx_queue_full,
+			.rx_refill_thresh = ATH6KL_MAX_RX_BUFFERS / 4,
+			.rx_alloc_thresh = ATH6KL_BUFFER_SIZE,
+			.rx_allocthresh = ath6kl_alloc_amsdu_rxbuf,
+		},
+		.max_txq_depth = MAX_DEFAULT_SEND_QUEUE_DEPTH,
+		.flags = HTC_FLGS_TX_BNDL_PAD_EN,
+		.max_rxmsg_sz = WMI_MAX_TX_DATA_FRAME_LENGTH,
+	},
+	{
+		.svc_id = WMI_DATA_BK_SVC,
+		.conn_flags = HTC_CONN_FLGS_REDUCE_CRED_DRIB |
+			      HTC_CONN_FLGS_THRESH_LVL_HALF,
+		.ep_cb = {
+			.tx_comp_multi = ath6kl_tx_complete,
+			.rx = ath6kl_rx,
+			.rx_refill = ath6kl_rx_refill,
+			.tx_full = ath6kl_tx_queue_full,
+			.rx_refill_thresh = ATH6KL_MAX_RX_BUFFERS / 4,
+			.rx_alloc_thresh = ATH6KL_BUFFER_SIZE,
+			.rx_allocthresh = ath6kl_alloc_amsdu_rxbuf,
+		},
+		.max_txq_depth = MAX_DEFAULT_SEND_QUEUE_DEPTH,
+		.flags = HTC_FLGS_TX_BNDL_PAD_EN,
+		.max_rxmsg_sz = WMI_MAX_TX_DATA_FRAME_LENGTH,
+	},
+	{
+		.svc_id = WMI_DATA_VI_SVC,
+		.conn_flags = HTC_CONN_FLGS_REDUCE_CRED_DRIB |
+			      HTC_CONN_FLGS_THRESH_LVL_HALF,
+		.ep_cb = {
+			.tx_comp_multi = ath6kl_tx_complete,
+			.rx = ath6kl_rx,
+			.rx_refill = ath6kl_rx_refill,
+			.tx_full = ath6kl_tx_queue_full,
+			.rx_refill_thresh = ATH6KL_MAX_RX_BUFFERS / 4,
+			.rx_alloc_thresh = ATH6KL_BUFFER_SIZE,
+			.rx_allocthresh = ath6kl_alloc_amsdu_rxbuf,
+		},
+		.max_txq_depth = MAX_DEFAULT_SEND_QUEUE_DEPTH,
+		.flags = HTC_FLGS_TX_BNDL_PAD_EN,
+		.max_rxmsg_sz = WMI_MAX_TX_DATA_FRAME_LENGTH,
+	},
+	/* VO service, this is currently not mapped to a WMI
+	 * priority stream due to historical reasons. WMI originally
+	 * defined 3 priorities over 3 mailboxes We can change this when
+	 * WMI is reworked so that priorities are not dependent on
+	 * mailboxes.
+	 */
+	{
+		.svc_id = WMI_DATA_VO_SVC,
+		.conn_flags = HTC_CONN_FLGS_REDUCE_CRED_DRIB |
+			      HTC_CONN_FLGS_THRESH_LVL_HALF,
+		.ep_cb = {
+			.tx_comp_multi = ath6kl_tx_complete,
+			.rx = ath6kl_rx,
+			.rx_refill = ath6kl_rx_refill,
+			.tx_full = ath6kl_tx_queue_full,
+			.rx_refill_thresh = ATH6KL_MAX_RX_BUFFERS / 4,
+			.rx_alloc_thresh = ATH6KL_BUFFER_SIZE,
+			.rx_allocthresh = ath6kl_alloc_amsdu_rxbuf,
+		},
+		.max_txq_depth = MAX_DEFAULT_SEND_QUEUE_DEPTH,
+		.flags = HTC_FLGS_TX_BNDL_PAD_EN,
+		.max_rxmsg_sz = WMI_MAX_TX_DATA_FRAME_LENGTH,
+	},
+};
+
 static const struct ath6kl_hw hw_list[] = {
 	{
 		.id				= AR6003_HW_2_0_VERSION,
@@ -57,6 +145,8 @@ static const struct ath6kl_hw hw_list[] = {
 
 		.fw_board		= AR6003_HW_2_0_BOARD_DATA_FILE,
 		.fw_default_board	= AR6003_HW_2_0_DEFAULT_BOARD_DATA_FILE,
+		.services		= ar600x_services,
+		.service_count		= ARRAY_SIZE(ar600x_services),
 	},
 	{
 		.id				= AR6003_HW_2_1_1_VERSION,
@@ -82,6 +172,8 @@ static const struct ath6kl_hw hw_list[] = {
 
 		.fw_board		= AR6003_HW_2_1_1_BOARD_DATA_FILE,
 		.fw_default_board = AR6003_HW_2_1_1_DEFAULT_BOARD_DATA_FILE,
+		.services		= ar600x_services,
+		.service_count		= ARRAY_SIZE(ar600x_services),
 	},
 	{
 		.id				= AR6004_HW_1_0_VERSION,
@@ -102,6 +194,8 @@ static const struct ath6kl_hw hw_list[] = {
 
 		.fw_board		= AR6004_HW_1_0_BOARD_DATA_FILE,
 		.fw_default_board	= AR6004_HW_1_0_DEFAULT_BOARD_DATA_FILE,
+		.services		= ar600x_services,
+		.service_count		= ARRAY_SIZE(ar600x_services),
 	},
 	{
 		.id				= AR6004_HW_1_1_VERSION,
@@ -121,6 +215,8 @@ static const struct ath6kl_hw hw_list[] = {
 
 		.fw_board		= AR6004_HW_1_1_BOARD_DATA_FILE,
 		.fw_default_board	= AR6004_HW_1_1_DEFAULT_BOARD_DATA_FILE,
+		.services		= ar600x_services,
+		.service_count		= ARRAY_SIZE(ar600x_services),
 	},
 	{
 		.id				= AR6004_HW_1_2_VERSION,
@@ -140,6 +236,8 @@ static const struct ath6kl_hw hw_list[] = {
 		},
 		.fw_board		= AR6004_HW_1_2_BOARD_DATA_FILE,
 		.fw_default_board	= AR6004_HW_1_2_DEFAULT_BOARD_DATA_FILE,
+		.services		= ar600x_services,
+		.service_count		= ARRAY_SIZE(ar600x_services),
 	},
 	{
 		.id				= AR6004_HW_1_3_VERSION,
@@ -163,6 +261,8 @@ static const struct ath6kl_hw hw_list[] = {
 
 		.fw_board               = AR6004_HW_1_3_BOARD_DATA_FILE,
 		.fw_default_board       = AR6004_HW_1_3_DEFAULT_BOARD_DATA_FILE,
+		.services		= ar600x_services,
+		.service_count		= ARRAY_SIZE(ar600x_services),
 	},
 	{
 		.id				= AR6004_HW_3_0_VERSION,
@@ -186,6 +286,8 @@ static const struct ath6kl_hw hw_list[] = {
 
 		.fw_board		= AR6004_HW_3_0_BOARD_DATA_FILE,
 		.fw_default_board	= AR6004_HW_3_0_DEFAULT_BOARD_DATA_FILE,
+		.services		= ar600x_services,
+		.service_count		= ARRAY_SIZE(ar600x_services),
 	},
 };
 
@@ -280,8 +382,7 @@ static inline void set_ac2_ep_map(struct ath6kl *ar,
 
 /* connect to a service */
 static int ath6kl_connectservice(struct ath6kl *ar,
-				 struct htc_service_connect_req  *con_req,
-				 char *desc)
+				 const struct htc_service_connect_req  *con_req)
 {
 	int status;
 	struct htc_service_connect_resp response;
@@ -290,8 +391,8 @@ static int ath6kl_connectservice(struct ath6kl *ar,
 
 	status = ath6kl_htc_conn_service(ar->htc_target, con_req, &response);
 	if (status) {
-		ath6kl_err("failed to connect to %s service status:%d\n",
-			   desc, status);
+		ath6kl_err("failed to connect to %x service status: %d\n",
+			   con_req->svc_id, status);
 		return status;
 	}
 
@@ -323,80 +424,12 @@ static int ath6kl_connectservice(struct ath6kl *ar,
 
 static int ath6kl_init_service_ep(struct ath6kl *ar)
 {
-	struct htc_service_connect_req connect;
-
-	memset(&connect, 0, sizeof(connect));
-
-	/* these fields are the same for all service endpoints */
-	connect.ep_cb.tx_comp_multi = ath6kl_tx_complete;
-	connect.ep_cb.rx = ath6kl_rx;
-	connect.ep_cb.rx_refill = ath6kl_rx_refill;
-	connect.ep_cb.tx_full = ath6kl_tx_queue_full;
-
-	/*
-	 * Set the max queue depth so that our ath6kl_tx_queue_full handler
-	 * gets called.
-	*/
-	connect.max_txq_depth = MAX_DEFAULT_SEND_QUEUE_DEPTH;
-	connect.ep_cb.rx_refill_thresh = ATH6KL_MAX_RX_BUFFERS / 4;
-	if (!connect.ep_cb.rx_refill_thresh)
-		connect.ep_cb.rx_refill_thresh++;
-
-	/* connect to control service */
-	connect.svc_id = WMI_CONTROL_SVC;
-	if (ath6kl_connectservice(ar, &connect, "WMI CONTROL"))
-		return -EIO;
-
-	connect.flags |= HTC_FLGS_TX_BNDL_PAD_EN;
-
-	/*
-	 * Limit the HTC message size on the send path, although e can
-	 * receive A-MSDU frames of 4K, we will only send ethernet-sized
-	 * (802.3) frames on the send path.
-	 */
-	connect.max_rxmsg_sz = WMI_MAX_TX_DATA_FRAME_LENGTH;
-
-	/*
-	 * To reduce the amount of committed memory for larger A_MSDU
-	 * frames, use the recv-alloc threshold mechanism for larger
-	 * packets.
-	 */
-	connect.ep_cb.rx_alloc_thresh = ATH6KL_BUFFER_SIZE;
-	connect.ep_cb.rx_allocthresh = ath6kl_alloc_amsdu_rxbuf;
-
-	/*
-	 * For the remaining data services set the connection flag to
-	 * reduce dribbling, if configured to do so.
-	 */
-	connect.conn_flags |= HTC_CONN_FLGS_REDUCE_CRED_DRIB;
-	connect.conn_flags &= ~HTC_CONN_FLGS_THRESH_MASK;
-	connect.conn_flags |= HTC_CONN_FLGS_THRESH_LVL_HALF;
-
-	connect.svc_id = WMI_DATA_BE_SVC;
-
-	if (ath6kl_connectservice(ar, &connect, "WMI DATA BE"))
-		return -EIO;
-
-	/* connect to back-ground map this to WMI LOW_PRI */
-	connect.svc_id = WMI_DATA_BK_SVC;
-	if (ath6kl_connectservice(ar, &connect, "WMI DATA BK"))
-		return -EIO;
-
-	/* connect to Video service, map this to HI PRI */
-	connect.svc_id = WMI_DATA_VI_SVC;
-	if (ath6kl_connectservice(ar, &connect, "WMI DATA VI"))
-		return -EIO;
+	int i;
 
-	/*
-	 * Connect to VO service, this is currently not mapped to a WMI
-	 * priority stream due to historical reasons. WMI originally
-	 * defined 3 priorities over 3 mailboxes We can change this when
-	 * WMI is reworked so that priorities are not dependent on
-	 * mailboxes.
-	 */
-	connect.svc_id = WMI_DATA_VO_SVC;
-	if (ath6kl_connectservice(ar, &connect, "WMI DATA VO"))
-		return -EIO;
+	for (i = 0; i < ar->hw.service_count; i++) {
+		if (ath6kl_connectservice(ar, &ar->hw.services[i]))
+			return -EIO;
+	}
 
 	return 0;
 }
-- 
2.1.4
