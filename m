Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:34699 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752301AbcKRTYO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 14:24:14 -0500
Received: by mail-qk0-f194.google.com with SMTP id y205so857932qkb.1
        for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2016 11:24:14 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v2 03/11] ath10k: htc: Removal of unused struct members
Date: Fri, 18 Nov 2016 20:22:43 +0100
Message-Id: <1479496971-19174-4-git-send-email-erik.stromdahl@gmail.com> (sfid-20161118_202420_788115_844A81AF)
In-Reply-To: <1479496971-19174-1-git-send-email-erik.stromdahl@gmail.com>
References: <1479496971-19174-1-git-send-email-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removed tx_credits_per_max_message and tx_credit_size
from struct ath10k_htc_ep since they are not used
anywhere in the code.

They are just written, never read.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/htc.c |    6 ------
 drivers/net/wireless/ath/ath10k/htc.h |    2 --
 2 files changed, 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 957e828..79d44de 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -815,12 +815,6 @@ int ath10k_htc_connect_service(struct ath10k_htc *htc,
 	ep->max_tx_queue_depth = conn_req->max_send_queue_depth;
 	ep->max_ep_message_len = __le16_to_cpu(resp_msg->max_msg_size);
 	ep->tx_credits = tx_alloc;
-	ep->tx_credit_size = htc->target_credit_size;
-	ep->tx_credits_per_max_message = ep->max_ep_message_len /
-					 htc->target_credit_size;
-
-	if (ep->max_ep_message_len % htc->target_credit_size)
-		ep->tx_credits_per_max_message++;
 
 	/* copy all the callbacks */
 	ep->ep_ops = conn_req->ep_ops;
diff --git a/drivers/net/wireless/ath/ath10k/htc.h b/drivers/net/wireless/ath/ath10k/htc.h
index b0f9cf3..f94b25a 100644
--- a/drivers/net/wireless/ath/ath10k/htc.h
+++ b/drivers/net/wireless/ath/ath10k/htc.h
@@ -336,8 +336,6 @@ struct ath10k_htc_ep {
 
 	u8 seq_no; /* for debugging */
 	int tx_credits;
-	int tx_credit_size;
-	int tx_credits_per_max_message;
 	bool tx_credit_flow_enabled;
 };
 
-- 
1.7.9.5
