Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06E33C282CB
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 10:47:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D70DB21919
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 10:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbfBHKrW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 05:47:22 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:56946 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727134AbfBHKrW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 05:47:22 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gs3gl-0002jg-Au; Fri, 08 Feb 2019 12:47:20 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  8 Feb 2019 12:46:54 +0200
Message-Id: <20190208104712.16210-3-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190208104712.16210-1-luca@coelho.fi>
References: <20190208104712.16210-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 02/20] iwlwifi: pcie: fix TX while flushing
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

When flushing TX queues no new TX should go into the system.
However, in the following scenario we get TX:
1. Queues are stopped and there are packets in overflow queue
2. Station is removed and flush begins
3. Flush empties space, and reclaim path TXes SKB from overflow
   queue.

Note that the fact the queues are stopped during the process
doesn't matter - the packet will be TXed since the TX path
doesn't care if TX queues are stopped or not, just if there is
space in the queue, which there is, since we just freed a
packet.

A fix here is rather complicated, since the flow is very racy.

Change code not to warn if we are TXing from overflow TX.
In case there is TX from both overflow TX and TX path we will
miss a warning we optimally had, but we can live with that.

Make sure we don't return before overflow queue is empty, otherwise
we will think queues are empty, but they will be refilled, resulting
with assert.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Fixes: 3955525d5d17 ("iwlwifi: pcie: buffer packets to avoid overflowing Tx queues")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../wireless/intel/iwlwifi/pcie/internal.h    |  2 ++
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 24 +++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  | 10 ++++++++
 3 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 9e1bcafad786..0ecd90d050e6 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -400,6 +400,8 @@ struct iwl_txq {
 	u32 id;
 	int low_mark;
 	int high_mark;
+
+	bool overflow_tx;
 };
 
 static inline dma_addr_t
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 6c30c88fc41e..4b31b0cdbd09 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2240,6 +2240,7 @@ static int iwl_trans_pcie_wait_txq_empty(struct iwl_trans *trans, int txq_idx)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_txq *txq;
 	unsigned long now = jiffies;
+	bool overflow_tx;
 	u8 wr_ptr;
 
 	/* Make sure the NIC is still alive in the bus */
@@ -2251,18 +2252,37 @@ static int iwl_trans_pcie_wait_txq_empty(struct iwl_trans *trans, int txq_idx)
 
 	IWL_DEBUG_TX_QUEUES(trans, "Emptying queue %d...\n", txq_idx);
 	txq = trans_pcie->txq[txq_idx];
+
+	spin_lock_bh(&txq->lock);
+	overflow_tx = txq->overflow_tx ||
+		      !skb_queue_empty(&txq->overflow_q);
+	spin_unlock_bh(&txq->lock);
+
 	wr_ptr = READ_ONCE(txq->write_ptr);
 
-	while (txq->read_ptr != READ_ONCE(txq->write_ptr) &&
+	while ((txq->read_ptr != READ_ONCE(txq->write_ptr) ||
+		overflow_tx) &&
 	       !time_after(jiffies,
 			   now + msecs_to_jiffies(IWL_FLUSH_WAIT_MS))) {
 		u8 write_ptr = READ_ONCE(txq->write_ptr);
 
-		if (WARN_ONCE(wr_ptr != write_ptr,
+		/*
+		 * If write pointer moved during the wait, warn only
+		 * if the TX came from op mode. In case TX came from
+		 * trans layer (overflow TX) don't warn.
+		 */
+		if (WARN_ONCE(wr_ptr != write_ptr && !overflow_tx,
 			      "WR pointer moved while flushing %d -> %d\n",
 			      wr_ptr, write_ptr))
 			return -ETIMEDOUT;
+		wr_ptr = write_ptr;
+
 		usleep_range(1000, 2000);
+
+		spin_lock_bh(&txq->lock);
+		overflow_tx = txq->overflow_tx ||
+			      !skb_queue_empty(&txq->overflow_q);
+		spin_unlock_bh(&txq->lock);
 	}
 
 	if (txq->read_ptr != txq->write_ptr) {
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index d8773e0a6062..9fbd37d23e85 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -1181,6 +1181,15 @@ void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 		__skb_queue_head_init(&overflow_skbs);
 		skb_queue_splice_init(&txq->overflow_q, &overflow_skbs);
 
+		/*
+		 * We are going to transmit from the overflow queue.
+		 * Remember this state so that wait_for_txq_empty will know we
+		 * are adding more packets to the TFD queue. It cannot rely on
+		 * the state of &txq->overflow_q, as we just emptied it, but
+		 * haven't TXed the content yet.
+		 */
+		txq->overflow_tx = true;
+
 		/*
 		 * This is tricky: we are in reclaim path which is non
 		 * re-entrant, so noone will try to take the access the
@@ -1209,6 +1218,7 @@ void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 			iwl_wake_queue(trans, txq);
 
 		spin_lock_bh(&txq->lock);
+		txq->overflow_tx = false;
 	}
 
 	if (txq->read_ptr == txq->write_ptr) {
-- 
2.20.1

