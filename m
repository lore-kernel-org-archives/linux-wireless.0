Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:33092 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932706AbcJMQlt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 12:41:49 -0400
Received: by mail-lf0-f68.google.com with SMTP id l131so10682132lfl.0
        for <linux-wireless@vger.kernel.org>; Thu, 13 Oct 2016 09:40:56 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC 1/5] ath6kl: HTC mbox tx complete cb support
Date: Thu, 13 Oct 2016 18:39:25 +0200
Message-Id: <1476376769-4708-2-git-send-email-erik.stromdahl@gmail.com> (sfid-20161013_184158_104837_4BFCD888)
In-Reply-To: <1476376769-4708-1-git-send-email-erik.stromdahl@gmail.com>
References: <1476376769-4708-1-git-send-email-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current implementation always call ath6kl_tx_complete
regardless if a tx_complete callback has been associated with the
endpoint or not.

This patch fixes this by calling the associated callback in case
it is present.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath6kl/htc_mbox.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc_mbox.c b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
index 65c31da..6e8c493 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_mbox.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
@@ -445,7 +445,10 @@ static void htc_tx_complete(struct htc_endpoint *endpoint,
 		   "htc tx complete ep %d pkts %d\n",
 		   endpoint->eid, get_queue_depth(txq));
 
-	ath6kl_tx_complete(endpoint->target, txq);
+	if (endpoint->ep_cb.tx_comp_multi)
+		endpoint->ep_cb.tx_comp_multi(endpoint->target, txq);
+	else
+		ath6kl_tx_complete(endpoint->target, txq);
 }
 
 static void htc_tx_comp_handler(struct htc_target *target,
-- 
2.1.4
