Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22154 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab1HVPK0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 11:10:26 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <kvalo@adurom.com>
Subject: [PATCH 3/3] ath6kl: Avoid rolling back of entire scatter setup in case of failure
Date: Mon, 22 Aug 2011 20:40:22 +0530
Message-ID: <1314025822-8004-3-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110822_171029_861014_EDCA5EF7)
In-Reply-To: <1314025822-8004-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1314025822-8004-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Current tx scatter gather implementation rolls back the entire
scatter setup in case of a failure in setting up just one packet
into the bundle. Instead of dopping the whole scatter setup,
send the packets available just before the failure one using
scatter gather I/O.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index dc575a8..77e548c 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -381,13 +381,7 @@ static int htc_setup_send_scat_list(struct htc_target *target,
 
 		cred_pad = htc_get_credit_padding(target->tgt_cred_sz,
 						  &len, endpoint);
-		if (cred_pad < 0) {
-			status = -EINVAL;
-			break;
-		}
-
-		if (rem_scat < len) {
-			/* exceeds what we can transfer */
+		if (cred_pad < 0 || rem_scat < len) {
 			status = -ENOSPC;
 			break;
 		}
@@ -416,7 +410,7 @@ static int htc_setup_send_scat_list(struct htc_target *target,
 	}
 
 	/* Roll back scatter setup in case of any failure */
-	if (status || (scat_req->scat_entries < HTC_MIN_HTC_MSGS_TO_BUNDLE)) {
+	if (scat_req->scat_entries < HTC_MIN_HTC_MSGS_TO_BUNDLE) {
 		for (i = scat_req->scat_entries - 1; i >= 0; i--) {
 			packet = scat_req->scat_list[i].packet;
 			if (packet) {
@@ -424,10 +418,10 @@ static int htc_setup_send_scat_list(struct htc_target *target,
 				list_add(&packet->list, queue);
 			}
 		}
-		return -EINVAL;
+		return -EAGAIN;
 	}
 
-	return 0;
+	return status;
 }
 
 /*
@@ -447,8 +441,10 @@ static void htc_issue_send_bundle(struct htc_endpoint *endpoint,
 	struct htc_target *target = endpoint->target;
 	struct hif_scatter_req *scat_req = NULL;
 	int n_scat, n_sent_bundle = 0, tot_pkts_bundle = 0;
+	int status;
 
 	while (true) {
+		status = 0;
 		n_scat = get_queue_depth(queue);
 		n_scat = min(n_scat, target->msg_per_bndl_max);
 
@@ -471,8 +467,9 @@ static void htc_issue_send_bundle(struct htc_endpoint *endpoint,
 		scat_req->len = 0;
 		scat_req->scat_entries = 0;
 
-		if (htc_setup_send_scat_list(target, endpoint, scat_req,
-					     n_scat, queue)) {
+		status = htc_setup_send_scat_list(target, endpoint,
+						  scat_req, n_scat, queue);
+		if (status == -EAGAIN) {
 			hif_scatter_req_add(target->dev->ar, scat_req);
 			break;
 		}
@@ -486,6 +483,9 @@ static void htc_issue_send_bundle(struct htc_endpoint *endpoint,
 			   "send scatter total bytes: %d , entries: %d\n",
 			   scat_req->len, scat_req->scat_entries);
 		ath6kldev_submit_scat_req(target->dev, scat_req, false);
+
+		if (status)
+			break;
 	}
 
 	*sent_bundle = n_sent_bundle;
-- 
1.7.0.4

