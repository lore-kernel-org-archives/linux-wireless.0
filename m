Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:33664 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753016AbdGHTIy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 8 Jul 2017 15:08:54 -0400
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [PATCH] ath10k: sdio: fix compile warning
Date: Sat,  8 Jul 2017 21:08:41 +0200
Message-Id: <1499540921-18521-1-git-send-email-erik.stromdahl@gmail.com> (sfid-20170708_210930_692721_EA16C75A)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As suggested by Arnd Bergmann, replace
"while (time_before_...) {}"
with
"do {} while (time_before_...)"

This fixes the following warnings detected by gcc 4.1.2:

drivers/net/wireless/ath/ath10k/sdio.c: In function
‘ath10k_sdio_mbox_rxmsg_pending_handler’:
drivers/net/wireless/ath/ath10k/sdio.c:676: warning: ‘ret’ may be used uninitialized in this function

...

drivers/net/wireless/ath/ath10k/sdio.c: In function
‘ath10k_sdio_irq_handler’:
drivers/net/wireless/ath/ath10k/sdio.c:1331: warning: ‘ret’ may be used uninitialized in this function

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/sdio.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index 859ed87..48268f0 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -683,7 +683,7 @@ static int ath10k_sdio_mbox_rxmsg_pending_handler(struct ath10k *ar,
 	lookaheads[0] = msg_lookahead;
 
 	timeout = jiffies + SDIO_MBOX_PROCESSING_TIMEOUT_HZ;
-	while (time_before(jiffies, timeout)) {
+	do {
 		/* Try to allocate as many HTC RX packets indicated by
 		 * n_lookaheads.
 		 */
@@ -719,7 +719,7 @@ static int ath10k_sdio_mbox_rxmsg_pending_handler(struct ath10k *ar,
 		 * performance in high throughput situations.
 		 */
 		*done = false;
-	}
+	} while (time_before(jiffies, timeout));
 
 	if (ret && (ret != -ECANCELED))
 		ath10k_warn(ar, "failed to get pending recv messages: %d\n",
@@ -1336,11 +1336,11 @@ static void ath10k_sdio_irq_handler(struct sdio_func *func)
 	sdio_release_host(ar_sdio->func);
 
 	timeout = jiffies + ATH10K_SDIO_HIF_COMMUNICATION_TIMEOUT_HZ;
-	while (time_before(jiffies, timeout) && !done) {
+	do {
 		ret = ath10k_sdio_mbox_proc_pending_irqs(ar, &done);
 		if (ret)
 			break;
-	}
+	} while (time_before(jiffies, timeout) && !done);
 
 	sdio_claim_host(ar_sdio->func);
 
-- 
2.7.4
