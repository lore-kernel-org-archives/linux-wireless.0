Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbaBSIMz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 03:12:55 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 1/3] iwl3945: fix wakeup interrupt
Date: Wed, 19 Feb 2014 09:15:09 +0100
Message-Id: <1392797711-2564-1-git-send-email-sgruszka@redhat.com> (sfid-20140219_091259_315019_93CBCB91)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have only 5 tx queues on 3945, updating il->txq[5] results in
writing random value to HBUS_TARG_WRPTR register.

Additionally use spin lock to protect txq->write_ptr and
txq->need_update fields also modified in TX path.

Tested-by: Pedro Francisco <pedrogfrancisco@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index 0487461..46b32d4 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -1495,12 +1495,14 @@ il3945_irq_tasklet(struct il_priv *il)
 	if (inta & CSR_INT_BIT_WAKEUP) {
 		D_ISR("Wakeup interrupt\n");
 		il_rx_queue_update_write_ptr(il, &il->rxq);
+
+		spin_lock_irqsave(&il->lock, flags);
 		il_txq_update_write_ptr(il, &il->txq[0]);
 		il_txq_update_write_ptr(il, &il->txq[1]);
 		il_txq_update_write_ptr(il, &il->txq[2]);
 		il_txq_update_write_ptr(il, &il->txq[3]);
 		il_txq_update_write_ptr(il, &il->txq[4]);
-		il_txq_update_write_ptr(il, &il->txq[5]);
+		spin_unlock_irqrestore(&il->lock, flags);
 
 		il->isr_stats.wakeup++;
 		handled |= CSR_INT_BIT_WAKEUP;
-- 
1.7.11.7

