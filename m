Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:55223 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbcESH7U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2016 03:59:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] iwlegacy: avoid warning about missing braces
Date: Thu, 19 May 2016 09:58:49 +0200
Message-Id: <1463644741-529379-1-git-send-email-arnd@arndb.de> (sfid-20160519_095942_743679_0BBDCCBD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

gcc-6 warns about code in il3945_hw_txq_ctx_free() being
somewhat ambiguous:

drivers/net/wireless/intel/iwlegacy/3945.c:1022:5: warning: suggest explicit braces to avoid ambiguous 'else' [-Wparentheses]

This adds a set of curly braces to avoid the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/intel/iwlegacy/3945.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/3945.c b/drivers/net/wireless/intel/iwlegacy/3945.c
index 7bcedbb53d94..209dc9988455 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945.c
@@ -1019,12 +1019,13 @@ il3945_hw_txq_ctx_free(struct il_priv *il)
 	int txq_id;
 
 	/* Tx queues */
-	if (il->txq)
+	if (il->txq) {
 		for (txq_id = 0; txq_id < il->hw_params.max_txq_num; txq_id++)
 			if (txq_id == IL39_CMD_QUEUE_NUM)
 				il_cmd_queue_free(il);
 			else
 				il_tx_queue_free(il, txq_id);
+	}
 
 	/* free tx queue structure */
 	il_free_txq_mem(il);
-- 
2.7.0

