Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:36033 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933190AbcJMQlu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 12:41:50 -0400
Received: by mail-lf0-f67.google.com with SMTP id b75so13383957lfg.3
        for <linux-wireless@vger.kernel.org>; Thu, 13 Oct 2016 09:41:22 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC 4/5] ath6kl: Updated credit setup
Date: Thu, 13 Oct 2016 18:39:28 +0200
Message-Id: <1476376769-4708-5-git-send-email-erik.stromdahl@gmail.com> (sfid-20161013_184203_645801_9181240A)
In-Reply-To: <1476376769-4708-1-git-send-email-erik.stromdahl@gmail.com>
References: <1476376769-4708-1-git-send-email-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch simplifies the credit setup and removes a dependency
from htc_mbox.c.

The service priority (the order in which the endpoint credits are
added in target->cred_dist_list) is now determined by the sequence
in which the host connects to services.

The HTC control endpoint will have highest prio (just as before) since
it is the first endpoint that is connected (done in htc_wait_target).
The remaining service prio's will be prioritized in the order in
which they are connected.

The rationale behind this patch is to remove the service
dependecies (the prio list in ath6kl_htc_mbox_credit_setup) from
htc_mbox.c.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath6kl/htc_mbox.c | 50 ++++++------------------------
 1 file changed, 9 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc_mbox.c b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
index 2c4477d..eed3939 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_mbox.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
@@ -29,9 +29,6 @@ static void ath6kl_htc_mbox_cleanup(struct htc_target *target);
 static void ath6kl_htc_mbox_stop(struct htc_target *target);
 static int ath6kl_htc_mbox_add_rxbuf_multiple(struct htc_target *target,
 					      struct list_head *pkt_queue);
-static void ath6kl_htc_set_credit_dist(struct htc_target *target,
-				       struct ath6kl_htc_credit_info *cred_info,
-				       u16 svc_pri_order[], int len);
 
 /* threshold to re-enable Tx bundling for an AC*/
 #define TX_RESUME_BUNDLE_THRESHOLD	1500
@@ -146,18 +143,9 @@ static void ath6kl_credit_init(struct ath6kl_htc_credit_info *cred_info,
 static int ath6kl_htc_mbox_credit_setup(struct htc_target *htc_target,
 			       struct ath6kl_htc_credit_info *cred_info)
 {
-	u16 servicepriority[5];
-
 	memset(cred_info, 0, sizeof(struct ath6kl_htc_credit_info));
 
-	servicepriority[0] = WMI_CONTROL_SVC;  /* highest */
-	servicepriority[1] = WMI_DATA_VO_SVC;
-	servicepriority[2] = WMI_DATA_VI_SVC;
-	servicepriority[3] = WMI_DATA_BE_SVC;
-	servicepriority[4] = WMI_DATA_BK_SVC; /* lowest */
-
-	/* set priority list */
-	ath6kl_htc_set_credit_dist(htc_target, cred_info, servicepriority, 5);
+	htc_target->credit_info = cred_info;
 
 	return 0;
 }
@@ -1094,34 +1082,6 @@ static int htc_setup_tx_complete(struct htc_target *target)
 	return status;
 }
 
-static void ath6kl_htc_set_credit_dist(struct htc_target *target,
-				struct ath6kl_htc_credit_info *credit_info,
-				u16 srvc_pri_order[], int list_len)
-{
-	struct htc_endpoint *endpoint;
-	int i, ep;
-
-	target->credit_info = credit_info;
-
-	list_add_tail(&target->endpoint[ENDPOINT_0].cred_dist.list,
-		      &target->cred_dist_list);
-
-	for (i = 0; i < list_len; i++) {
-		for (ep = ENDPOINT_1; ep < ENDPOINT_MAX; ep++) {
-			endpoint = &target->endpoint[ep];
-			if (endpoint->svc_id == srvc_pri_order[i]) {
-				list_add_tail(&endpoint->cred_dist.list,
-					      &target->cred_dist_list);
-				break;
-			}
-		}
-		if (ep >= ENDPOINT_MAX) {
-			WARN_ON(1);
-			return;
-		}
-	}
-}
-
 static int ath6kl_htc_mbox_tx(struct htc_target *target,
 			      struct htc_packet *packet)
 {
@@ -2575,6 +2535,14 @@ static int ath6kl_htc_mbox_conn_service(struct htc_target *target,
 			   endpoint->svc_id, assigned_ep);
 	}
 
+	/* Add the credit distribution list of the current endpoint
+	 * to target->cred_dist_list.
+	 * The order in which this function is called will determine
+	 * the priority of the services.
+	 */
+	list_add_tail(&endpoint->cred_dist.list,
+		      &target->cred_dist_list);
+
 fail_tx:
 	if (tx_pkt)
 		htc_reclaim_txctrl_buf(target, tx_pkt);
-- 
2.1.4
