Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:48578 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032704AbdAEWAu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jan 2017 17:00:50 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath10k:  Initialize nbytes to 0
Date: Thu,  5 Jan 2017 14:00:41 -0800
Message-Id: <1483653641-8377-1-git-send-email-greearb@candelatech.com> (sfid-20170105_230105_280560_4513FB3F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

ath10k firmware checks nbytes == 0 as part of determining if DMA
has completed successfully.  To help make this work more often,
have the driver initialize nbytes to zero when freeing the descriptor
slot.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

I am not yet sure if this actually fixes a real problem or not...curious
if others think this is an improvement.

 drivers/net/wireless/ath/ath10k/ce.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index da9998e..15bc7fb 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -595,6 +595,7 @@ int ath10k_ce_completed_send_next_nolock(struct ath10k_ce_pipe *ce_state,
 	unsigned int nentries_mask = src_ring->nentries_mask;
 	unsigned int sw_index = src_ring->sw_index;
 	unsigned int read_index;
+	struct ce_desc *desc;
 
 	if (src_ring->hw_index == sw_index) {
 		/*
@@ -624,6 +625,9 @@ int ath10k_ce_completed_send_next_nolock(struct ath10k_ce_pipe *ce_state,
 
 	/* sanity */
 	src_ring->per_transfer_context[sw_index] = NULL;
+	desc = CE_SRC_RING_TO_DESC(src_ring->base_addr_owner_space,
+				   sw_index);
+	desc->nbytes = 0;
 
 	/* Update sw_index */
 	sw_index = CE_RING_IDX_INCR(nentries_mask, sw_index);
-- 
2.4.11
