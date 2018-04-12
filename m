Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38952 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750763AbeDLMPO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Apr 2018 08:15:14 -0400
From: mpubbise@qti.qualcomm.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>
Subject: [PATCH] ath10k: correct target assert problem due to CE5 stuck
Date: Thu, 12 Apr 2018 17:44:59 +0530
Message-Id: <1523535299-29282-1-git-send-email-mpubbise@qti.qualcomm.com> (sfid-20180412_141516_916913_E0FA32B1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Manikanta Pubbisetty <mpubbise@codeaurora.org>

Correct a minor bug in the commit 0628467f97b5 ("ath10k: fix
copy engine 5 destination ring stuck") which introduced a change to fix
firmware assert that happens when ring indices of copy engine 5 are stuck
for a specific duration, problem with this fix is that it did not use
ring arithmatic. As a result,firmware asserts did not go away entirely
athough the frequency of occurrence has reduced. Using ring arithmatic
to fix the issue.

Tested on QCA9984(fw version-10.4-3.4-00082).

Fixes: 0628467f97b5 ("ath10k: fix copy engine 5 destination ring stuck)
Signed-off-by: Manikanta Pubbisetty <mpubbise@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/ce.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index b9def7b..6efa69e 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -615,7 +615,7 @@ void ath10k_ce_rx_update_write_idx(struct ath10k_ce_pipe *pipe, u32 nentries)
 	/* Prevent CE ring stuck issue that will occur when ring is full.
 	 * Make sure that write index is 1 less than read index.
 	 */
-	if ((cur_write_idx + nentries)  == dest_ring->sw_index)
+	if (((cur_write_idx + nentries) & nentries_mask) == dest_ring->sw_index)
 		nentries -= 1;
 
 	write_index = CE_RING_IDX_ADD(nentries_mask, write_index, nentries);
-- 
2.7.4
