Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:33113 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbaFEH4V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 03:56:21 -0400
Received: by mail-we0-f170.google.com with SMTP id u57so634336wes.15
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jun 2014 00:56:20 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/2] ath10k: fix bmi exchange tx/rx race
Date: Thu,  5 Jun 2014 09:48:39 +0200
Message-Id: <1401954520-3365-2-git-send-email-michal.kazior@tieto.com> (sfid-20140605_095623_882983_1064CFF4)
In-Reply-To: <1401954520-3365-1-git-send-email-michal.kazior@tieto.com>
References: <1401954520-3365-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was possible for tx completion not to be
processed. In that case an old stack pointer was
left on copy engine tx ring. Next bmi exchange
would immediately pop it and use complete() on the
completion struct there causing corruption.

Make sure to wait for both tx and rx completions
properly.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 11 +++--------
 drivers/net/wireless/ath/ath10k/pci.h |  3 ++-
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index d0004d5..06840d1 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1362,8 +1362,6 @@ static int ath10k_pci_hif_exchange_bmi_msg(struct ath10k *ar,
 		ath10k_ce_recv_buf_enqueue(ce_rx, &xfer, resp_paddr);
 	}
 
-	init_completion(&xfer.done);
-
 	ret = ath10k_ce_send(ce_tx, &xfer, req_paddr, req_len, -1, 0);
 	if (ret)
 		goto err_resp;
@@ -1414,10 +1412,7 @@ static void ath10k_pci_bmi_send_done(struct ath10k_ce_pipe *ce_state)
 					  &nbytes, &transfer_id))
 		return;
 
-	if (xfer->wait_for_resp)
-		return;
-
-	complete(&xfer->done);
+	xfer->tx_done = true;
 }
 
 static void ath10k_pci_bmi_recv_data(struct ath10k_ce_pipe *ce_state)
@@ -1438,7 +1433,7 @@ static void ath10k_pci_bmi_recv_data(struct ath10k_ce_pipe *ce_state)
 	}
 
 	xfer->resp_len = nbytes;
-	complete(&xfer->done);
+	xfer->rx_done = true;
 }
 
 static int ath10k_pci_bmi_wait(struct ath10k_ce_pipe *tx_pipe,
@@ -1451,7 +1446,7 @@ static int ath10k_pci_bmi_wait(struct ath10k_ce_pipe *tx_pipe,
 		ath10k_pci_bmi_send_done(tx_pipe);
 		ath10k_pci_bmi_recv_data(rx_pipe);
 
-		if (completion_done(&xfer->done))
+		if (xfer->tx_done && (xfer->rx_done == xfer->wait_for_resp))
 			return 0;
 
 		schedule();
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index dfdebb4..9401292 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -38,7 +38,8 @@
 #define DIAG_TRANSFER_LIMIT 2048
 
 struct bmi_xfer {
-	struct completion done;
+	bool tx_done;
+	bool rx_done;
 	bool wait_for_resp;
 	u32 resp_len;
 };
-- 
1.8.5.3

