Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753889Ab1BNOdP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 09:33:15 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] iwlwifi: zero fill txq->txb on queue reset
Date: Mon, 14 Feb 2011 15:33:19 +0100
Message-Id: <1297693999-15342-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We allocate txq->txb area with kzalloc, but when reseting queue
during __iwl_down / __iwl_up we we leave old values, let's zero
initialize in such case as well.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index a8935cd..0c8555c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -418,6 +418,8 @@ void iwl_tx_queue_reset(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 
 	if (txq_id == priv->cmd_queue)
 		actual_slots++;
+	else
+		memset(txq->txb, 0, sizeof(txq->txb[0]) * TFD_QUEUE_SIZE_MAX);
 
 	memset(txq->meta, 0, sizeof(struct iwl_cmd_meta) * actual_slots);
 
-- 
1.7.1

