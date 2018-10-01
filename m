Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6B42C0044B
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 12:10:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88DF2208AE
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 12:10:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 88DF2208AE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729137AbeJASrv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 14:47:51 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:54302 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729099AbeJASru (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 14:47:50 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g6x1n-0006wq-Ll; Mon, 01 Oct 2018 15:10:20 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon,  1 Oct 2018 15:09:55 +0300
Message-Id: <20181001121010.29684-2-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181001121010.29684-1-luca@coelho.fi>
References: <20181001121010.29684-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 01/16] iwlwifi: pcie: avoid empty free RB queue
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shaul Triebitz <shaul.triebitz@intel.com>

If all free RB queues are empty, the driver will never restock the
free RB queue.  That's because the restocking happens in the Rx flow,
and if the free queue is empty there will be no Rx.

Although there's a background worker (a.k.a. allocator) allocating
memory for RBs so that the Rx handler can restock them, the worker may
run only after the free queue has become empty (and then it is too
late for restocking as explained above).

There is a solution for that called 'emergency': If the number of used
RB's reaches half the amount of all RB's, the Rx handler will not wait
for the allocator but immediately allocate memory for the used RB's
and restock the free queue.

But, since the used RB's is per queue, it may happen that the used
RB's are spread between the queues such that the emergency check will
fail for each of the queues
(and still run out of RBs, causing the above symptom).

To fix it, move to emergency mode if the sum of *all* used RBs (for
all Rx queues) reaches half the amount of all RB's

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 32 +++++++++++++-------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index d519e7ebdbe8..e965cc588850 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1144,6 +1144,14 @@ void iwl_pcie_rx_free(struct iwl_trans *trans)
 	kfree(trans_pcie->rxq);
 }
 
+static void iwl_pcie_rx_move_to_allocator(struct iwl_rxq *rxq,
+					  struct iwl_rb_allocator *rba)
+{
+	spin_lock(&rba->lock);
+	list_splice_tail_init(&rxq->rx_used, &rba->rbd_empty);
+	spin_unlock(&rba->lock);
+}
+
 /*
  * iwl_pcie_rx_reuse_rbd - Recycle used RBDs
  *
@@ -1175,9 +1183,7 @@ static void iwl_pcie_rx_reuse_rbd(struct iwl_trans *trans,
 	if ((rxq->used_count % RX_CLAIM_REQ_ALLOC) == RX_POST_REQ_ALLOC) {
 		/* Move the 2 RBDs to the allocator ownership.
 		 Allocator has another 6 from pool for the request completion*/
-		spin_lock(&rba->lock);
-		list_splice_tail_init(&rxq->rx_used, &rba->rbd_empty);
-		spin_unlock(&rba->lock);
+		iwl_pcie_rx_move_to_allocator(rxq, rba);
 
 		atomic_inc(&rba->req_pending);
 		queue_work(rba->alloc_wq, &rba->rx_alloc);
@@ -1400,10 +1406,18 @@ static void iwl_pcie_rx_handle(struct iwl_trans *trans, int queue)
 		IWL_DEBUG_RX(trans, "Q %d: HW = SW = %d\n", rxq->id, r);
 
 	while (i != r) {
+		struct iwl_rb_allocator *rba = &trans_pcie->rba;
 		struct iwl_rx_mem_buffer *rxb;
-
-		if (unlikely(rxq->used_count == rxq->queue_size / 2))
+		/* number of RBDs still waiting for page allocation */
+		u32 rb_pending_alloc =
+			atomic_read(&trans_pcie->rba.req_pending) *
+			RX_CLAIM_REQ_ALLOC;
+
+		if (unlikely(rb_pending_alloc >= rxq->queue_size / 2 &&
+			     !emergency)) {
+			iwl_pcie_rx_move_to_allocator(rxq, rba);
 			emergency = true;
+		}
 
 		rxb = iwl_pcie_get_rxb(trans, rxq, i);
 		if (!rxb)
@@ -1425,17 +1439,13 @@ static void iwl_pcie_rx_handle(struct iwl_trans *trans, int queue)
 			iwl_pcie_rx_allocator_get(trans, rxq);
 
 		if (rxq->used_count % RX_CLAIM_REQ_ALLOC == 0 && !emergency) {
-			struct iwl_rb_allocator *rba = &trans_pcie->rba;
-
 			/* Add the remaining empty RBDs for allocator use */
-			spin_lock(&rba->lock);
-			list_splice_tail_init(&rxq->rx_used, &rba->rbd_empty);
-			spin_unlock(&rba->lock);
+			iwl_pcie_rx_move_to_allocator(rxq, rba);
 		} else if (emergency) {
 			count++;
 			if (count == 8) {
 				count = 0;
-				if (rxq->used_count < rxq->queue_size / 3)
+				if (rb_pending_alloc < rxq->queue_size / 3)
 					emergency = false;
 
 				rxq->read = i;
-- 
2.19.0

