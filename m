Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:29735 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab2DMT1i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Apr 2012 15:27:38 -0400
Date: Fri, 13 Apr 2012 22:27:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] ath6kl: list_first_entry() is never NULL
Message-ID: <20120413192718.GD18505@elgon.mountain> (sfid-20120413_212743_798424_F3D2E0C3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can remove the NULL check here.  It triggers a Smatch warning because
list_first_entry() never is NULL and people who check for it normally
intend to check for list_empty() instead.  In these cases however,
we've already verified that the lists are not empty.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/ath/ath6kl/htc_pipe.c b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
index b277b34..b21a69f 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_pipe.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
@@ -108,8 +108,6 @@ static void get_htc_packet_credit_based(struct htc_target *target,
 
 		/* get packet at head, but don't remove it */
 		packet = list_first_entry(&ep->txq, struct htc_packet, list);
-		if (packet == NULL)
-			break;
 
 		ath6kl_dbg(ATH6KL_DBG_HTC,
 			   "%s: got head packet:0x%p , queue depth: %d\n",
@@ -803,8 +801,6 @@ static int htc_send_packets_multiple(struct htc_target *target,
 
 	/* get first packet to find out which ep the packets will go into */
 	packet = list_first_entry(pkt_queue, struct htc_packet, list);
-	if (packet == NULL)
-		return -EINVAL;
 
 	if (packet->endpoint >= ENDPOINT_MAX) {
 		WARN_ON_ONCE(1);
@@ -1636,10 +1632,6 @@ static int ath6kl_htc_pipe_add_rxbuf_multiple(struct htc_target *target,
 		return -EINVAL;
 
 	first = list_first_entry(pkt_queue, struct htc_packet, list);
-	if (first == NULL) {
-		WARN_ON_ONCE(1);
-		return -EINVAL;
-	}
 
 	if (first->endpoint >= ENDPOINT_MAX) {
 		WARN_ON_ONCE(1);
