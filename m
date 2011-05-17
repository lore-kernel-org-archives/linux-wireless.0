Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57961 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab1EQEqc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 00:46:32 -0400
Received: by pvg12 with SMTP id 12so70068pvg.19
        for <linux-wireless@vger.kernel.org>; Mon, 16 May 2011 21:46:32 -0700 (PDT)
From: Daniel Halperin <dhalperi@cs.washington.edu>
Content-Type: text/plain; charset=us-ascii
Subject: [PATCH] iwlwifi: remove unused parameter from iwl_hcmd_queue_reclaim
Date: Mon, 16 May 2011 21:46:28 -0700
Message-Id: <9506853D-331A-4900-BAA3-61C3CB280AAD@cs.washington.edu> (sfid-20110517_064637_135108_8CFD6EF2)
To: linux-wireless <linux-wireless@vger.kernel.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cmd_index is never used.

Signed-off-by: Daniel Halperin <dhalperi@cs.washington.edu>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 54a935f..686e176 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -746,8 +746,7 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
  * need to be reclaimed. As result, some free space forms.  If there is
  * enough free space (> low mark), wake the stack that feeds us.
  */
-static void iwl_hcmd_queue_reclaim(struct iwl_priv *priv, int txq_id,
-				   int idx, int cmd_idx)
+static void iwl_hcmd_queue_reclaim(struct iwl_priv *priv, int txq_id, int idx)
 {
 	struct iwl_tx_queue *txq = &priv->txq[txq_id];
 	struct iwl_queue *q = &txq->q;
@@ -819,7 +818,7 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 
 	spin_lock_irqsave(&priv->hcmd_lock, flags);
 
-	iwl_hcmd_queue_reclaim(priv, txq_id, index, cmd_index);
+	iwl_hcmd_queue_reclaim(priv, txq_id, index);
 
 	if (!(meta->flags & CMD_ASYNC)) {
 		clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
-- 
1.7.0.4


