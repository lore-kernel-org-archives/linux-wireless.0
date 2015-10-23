Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9864 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbbJWMbm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 08:31:42 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH v2 1/4] ath10k: use local memory instead of shadow descriptor in ce_send
Date: Fri, 23 Oct 2015 18:01:03 +0530
Message-ID: <1445603466-14138-2-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20151023_143147_518483_04BEC058)
In-Reply-To: <1445603466-14138-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1445603466-14138-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently to avoid uncached memory access while filling up copy engine
descriptors, shadow descriptors are used. This can be optimized further
by removing shadow descriptors. To achieve that first shadow ring
dependency in ce_send is removed by creating local copy of the
descriptor on stack and make a one-shot copy into the "uncached"
descriptor.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
v2:
 * Since ce_send is not using shadow, fix send completion as well.

 drivers/net/wireless/ath/ath10k/ce.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 84220c3..f63376b 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -274,7 +274,7 @@ int ath10k_ce_send_nolock(struct ath10k_ce_pipe *ce_state,
 {
 	struct ath10k *ar = ce_state->ar;
 	struct ath10k_ce_ring *src_ring = ce_state->src_ring;
-	struct ce_desc *desc, *sdesc;
+	struct ce_desc *desc, sdesc;
 	unsigned int nentries_mask = src_ring->nentries_mask;
 	unsigned int sw_index = src_ring->sw_index;
 	unsigned int write_index = src_ring->write_index;
@@ -294,7 +294,6 @@ int ath10k_ce_send_nolock(struct ath10k_ce_pipe *ce_state,
 
 	desc = CE_SRC_RING_TO_DESC(src_ring->base_addr_owner_space,
 				   write_index);
-	sdesc = CE_SRC_RING_TO_DESC(src_ring->shadow_base, write_index);
 
 	desc_flags |= SM(transfer_id, CE_DESC_FLAGS_META_DATA);
 
@@ -303,11 +302,11 @@ int ath10k_ce_send_nolock(struct ath10k_ce_pipe *ce_state,
 	if (flags & CE_SEND_FLAG_BYTE_SWAP)
 		desc_flags |= CE_DESC_FLAGS_BYTE_SWAP;
 
-	sdesc->addr   = __cpu_to_le32(buffer);
-	sdesc->nbytes = __cpu_to_le16(nbytes);
-	sdesc->flags  = __cpu_to_le16(desc_flags);
+	sdesc.addr   = __cpu_to_le32(buffer);
+	sdesc.nbytes = __cpu_to_le16(nbytes);
+	sdesc.flags  = __cpu_to_le16(desc_flags);
 
-	*desc = *sdesc;
+	*desc = sdesc;
 
 	src_ring->per_transfer_context[write_index] = per_transfer_context;
 
@@ -614,7 +613,7 @@ int ath10k_ce_completed_send_next_nolock(struct ath10k_ce_pipe *ce_state,
 	if (read_index == sw_index)
 		return -EIO;
 
-	sbase = src_ring->shadow_base;
+	sbase = src_ring->base_addr_owner_space;
 	sdesc = CE_SRC_RING_TO_DESC(sbase, sw_index);
 
 	/* Return data from completed source descriptor */
-- 
2.6.1

