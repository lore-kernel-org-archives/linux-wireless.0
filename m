Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:36190 "EHLO
	mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbcCRCYP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 22:24:15 -0400
Received: by mail-pf0-f178.google.com with SMTP id u190so146135248pfb.3
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 19:24:14 -0700 (PDT)
From: Julian Calaby <julian.calaby@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Markus Elfring <elfring@users.sourceforge.net>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Jia-Ju Bai <baijiaju1990@163.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org
Subject: [PATCH 09/19] iwl4965: Fix a null pointer dereference in il_tx_queue_free and il_cmd_queue_free
Date: Fri, 18 Mar 2016 13:24:06 +1100
Message-Id: <81035f8a7a40653b5ec61e1e6dcb02d1a0db92a6.1458262312.git.julian.calaby@gmail.com> (sfid-20160318_032417_894417_B9C7735A)
In-Reply-To: <cover.1458262312.git.julian.calaby@gmail.com>
References: <cover.1458262312.git.julian.calaby@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jia-Ju Bai <baijiaju1990@163.com>

If "txq->cmd = kzalloc(...)" in il_tx_queue_init fails,
"kfree(txq->cmd[i])" in il_tx_queue_free and il_cmd_queue_free
in iwl4965_hw_txq_ctx_free will causes a null pointer dereference,
because txq->cmd is NULL at that time.

This patch fixes this problem by adding a if-check before kfree.
To avoid double free in il_tx_queue_free and il_cmd_queue_free
caused by the fixing, txq->meta and txq->cmd in error handling code
of il_tx_queue_init are assigned null values.
Otherwise, a double free will occur.

This patch has been tested in real device, and it actually fixes the bug.
Thanks Stanislaw for his suggestion.

Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
---
 drivers/net/wireless/intel/iwlegacy/common.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/common.c b/drivers/net/wireless/intel/iwlegacy/common.c
index c3afaf7..2cc3d42 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.c
+++ b/drivers/net/wireless/intel/iwlegacy/common.c
@@ -2792,8 +2792,10 @@ il_tx_queue_free(struct il_priv *il, int txq_id)
 	il_tx_queue_unmap(il, txq_id);
 
 	/* De-alloc array of command/tx buffers */
-	for (i = 0; i < TFD_TX_CMD_SLOTS; i++)
-		kfree(txq->cmd[i]);
+	if (txq->cmd) {
+		for (i = 0; i < TFD_TX_CMD_SLOTS; i++)
+			kfree(txq->cmd[i]);
+	}
 
 	/* De-alloc circular buffer of TFDs */
 	if (txq->q.n_bd)
@@ -2871,8 +2873,10 @@ il_cmd_queue_free(struct il_priv *il)
 	il_cmd_queue_unmap(il);
 
 	/* De-alloc array of command/tx buffers */
-	for (i = 0; i <= TFD_CMD_SLOTS; i++)
-		kfree(txq->cmd[i]);
+	if (txq->cmd) {
+		for (i = 0; i <= TFD_CMD_SLOTS; i++)
+			kfree(txq->cmd[i]);
+	}
 
 	/* De-alloc circular buffer of TFDs */
 	if (txq->q.n_bd)
@@ -3078,7 +3082,9 @@ err:
 		kfree(txq->cmd[i]);
 out_free_arrays:
 	kfree(txq->meta);
+	txq->meta = NULL;
 	kfree(txq->cmd);
+	txq->cmd = NULL;
 
 	return -ENOMEM;
 }
-- 
2.7.0

