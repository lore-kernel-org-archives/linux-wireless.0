Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:34241 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753716AbdBUQQW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 11:16:22 -0500
Received: by mail-lf0-f66.google.com with SMTP id h67so3751931lfg.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Feb 2017 08:16:21 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v4 03/21] ath10k: htc: move htc ctrl ep connect to htc_init
Date: Tue, 21 Feb 2017 17:15:23 +0100
Message-Id: <1487693741-10042-4-git-send-email-erik.stromdahl@gmail.com> (sfid-20170221_171650_145944_F2CB416B)
In-Reply-To: <1487693741-10042-1-git-send-email-erik.stromdahl@gmail.com>
References: <1487693741-10042-1-git-send-email-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch moves the HTC ctrl service connect from
htc_wait_target to htc_init.

This is done in order to make sure the htc ctrl service
is setup properly before hif_start is called.

The reason for this is that we want the HTC ctrl service
callback to be initialized before the target sends the
HTC ready message.

The ready message will always be transmitted on endpoint 0
(which is always assigned to the HTC control service) so it
makes more sense if HTC control has been connected before the
ready message is received.

Since the service to pipe mapping is done as a part of
the service connect, the get_default_pipe call is redundant
and was removed.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/htc.c | 39 +++++++++++++++--------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index e72f385..f39eef6 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -584,8 +584,6 @@ int ath10k_htc_wait_target(struct ath10k_htc *htc)
 	struct ath10k *ar = htc->ar;
 	int i, status = 0;
 	unsigned long time_left;
-	struct ath10k_htc_svc_conn_req conn_req;
-	struct ath10k_htc_svc_conn_resp conn_resp;
 	struct ath10k_htc_msg *msg;
 	u16 message_id;
 	u16 credit_count;
@@ -648,22 +646,6 @@ int ath10k_htc_wait_target(struct ath10k_htc *htc)
 		return -ECOMM;
 	}
 
-	/* setup our pseudo HTC control endpoint connection */
-	memset(&conn_req, 0, sizeof(conn_req));
-	memset(&conn_resp, 0, sizeof(conn_resp));
-	conn_req.ep_ops.ep_tx_complete = ath10k_htc_control_tx_complete;
-	conn_req.ep_ops.ep_rx_complete = ath10k_htc_control_rx_complete;
-	conn_req.max_send_queue_depth = ATH10K_NUM_CONTROL_TX_BUFFERS;
-	conn_req.service_id = ATH10K_HTC_SVC_ID_RSVD_CTRL;
-
-	/* connect fake service */
-	status = ath10k_htc_connect_service(htc, &conn_req, &conn_resp);
-	if (status) {
-		ath10k_err(ar, "could not connect to htc service (%d)\n",
-			   status);
-		return status;
-	}
-
 	return 0;
 }
 
@@ -873,8 +855,10 @@ int ath10k_htc_start(struct ath10k_htc *htc)
 /* registered target arrival callback from the HIF layer */
 int ath10k_htc_init(struct ath10k *ar)
 {
-	struct ath10k_htc_ep *ep = NULL;
+	int status;
 	struct ath10k_htc *htc = &ar->htc;
+	struct ath10k_htc_svc_conn_req conn_req;
+	struct ath10k_htc_svc_conn_resp conn_resp;
 
 	spin_lock_init(&htc->tx_lock);
 
@@ -882,10 +866,21 @@ int ath10k_htc_init(struct ath10k *ar)
 
 	htc->ar = ar;
 
-	/* Get HIF default pipe for HTC message exchange */
-	ep = &htc->endpoint[ATH10K_HTC_EP_0];
+	/* setup our pseudo HTC control endpoint connection */
+	memset(&conn_req, 0, sizeof(conn_req));
+	memset(&conn_resp, 0, sizeof(conn_resp));
+	conn_req.ep_ops.ep_tx_complete = ath10k_htc_control_tx_complete;
+	conn_req.ep_ops.ep_rx_complete = ath10k_htc_control_rx_complete;
+	conn_req.max_send_queue_depth = ATH10K_NUM_CONTROL_TX_BUFFERS;
+	conn_req.service_id = ATH10K_HTC_SVC_ID_RSVD_CTRL;
 
-	ath10k_hif_get_default_pipe(ar, &ep->ul_pipe_id, &ep->dl_pipe_id);
+	/* connect fake service */
+	status = ath10k_htc_connect_service(htc, &conn_req, &conn_resp);
+	if (status) {
+		ath10k_err(ar, "could not connect to htc service (%d)\n",
+			   status);
+		return status;
+	}
 
 	init_completion(&htc->ctl_resp);
 
-- 
2.7.4
