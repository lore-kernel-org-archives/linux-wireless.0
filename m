Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:35910 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752672AbcKRTYP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 14:24:15 -0500
Received: by mail-qk0-f194.google.com with SMTP id h201so34193726qke.3
        for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2016 11:24:15 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v2 04/11] ath10k: htc: Changed order of wait target and ep connect
Date: Fri, 18 Nov 2016 20:22:44 +0100
Message-Id: <1479496971-19174-5-git-send-email-erik.stromdahl@gmail.com> (sfid-20161118_205412_794459_8E135DD2)
In-Reply-To: <1479496971-19174-1-git-send-email-erik.stromdahl@gmail.com>
References: <1479496971-19174-1-git-send-email-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes the order in which the driver waits for the
target to become ready and the service connect of the HTC
control service.

The HTC control service is connected before the driver starts
waiting for the HTC ready message.

The HTC ready message contains the total number of transmit
credits the driver can distribute between endpoints.
Since the HTC control service does not use any flow control
it is not necessary to wait for the ready message before
connecting the service.
There will be no credits assigned to this service anyway.
Besides, connecting the HTC control service does not yield
any bus traffic at all.

The ready message will always be transmitted on endpoint 0
(which is always assigned to the HTC control service) so it
makes more sense if HTC control has been connected before the
ready message is received.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/htc.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 79d44de..6ff5837 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -606,6 +606,22 @@ int ath10k_htc_wait_target(struct ath10k_htc *htc)
 	u16 credit_count;
 	u16 credit_size;
 
+	/* setup our pseudo HTC control endpoint connection */
+	memset(&conn_req, 0, sizeof(conn_req));
+	memset(&conn_resp, 0, sizeof(conn_resp));
+	conn_req.ep_ops.ep_tx_complete = ath10k_htc_control_tx_complete;
+	conn_req.ep_ops.ep_rx_complete = ath10k_htc_control_rx_complete;
+	conn_req.max_send_queue_depth = ATH10K_NUM_CONTROL_TX_BUFFERS;
+	conn_req.service_id = ATH10K_HTC_SVC_ID_RSVD_CTRL;
+
+	/* connect fake service */
+	status = ath10k_htc_connect_service(htc, &conn_req, &conn_resp);
+	if (status) {
+		ath10k_err(ar, "could not connect to htc service (%d)\n",
+			   status);
+		return status;
+	}
+
 	time_left = wait_for_completion_timeout(&htc->ctl_resp,
 						ATH10K_HTC_WAIT_TIMEOUT_HZ);
 	if (!time_left) {
@@ -665,22 +681,6 @@ int ath10k_htc_wait_target(struct ath10k_htc *htc)
 
 	ath10k_htc_setup_target_buffer_assignments(htc);
 
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
 
-- 
1.7.9.5
