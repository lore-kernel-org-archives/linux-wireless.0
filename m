Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3865 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755939AbcIUK6c (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Sep 2016 06:58:32 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
        "Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] ath10k: fix copy engine 5 destination ring stuck
Date: Wed, 21 Sep 2016 16:28:06 +0530
Message-ID: <20160921105806.23980-1-rmanohar@qti.qualcomm.com> (sfid-20160921_125836_308668_6B62B3DC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware is running watchdog timer for tracking copy engine ring index
and write index. Whenever both indices are stuck at same location for
given duration, watchdog will be trigger to assert target. While
updating copy engine destination ring write index, driver ensures that
write index will not be same as read index by finding delta between these
two indices (CE_RING_DELTA).

HTT target to host copy engine (CE5) is special case where ring buffers
will be reused and delta check is not applied while updating write index.
In rare scenario, whenever CE5 ring is full, both indices will be referring
same location and this is causing CE ring stuck issue as explained
above. This issue is originally reported on IPQ4019 during long hour stress
testing and during veriwave max clients testsuites. The same issue is
also observed in other chips as well. Fix this by ensuring that write
index is one less than read index which means that full ring is
available for receiving data.

Cc: stable@vger.kernel.org
Tested-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/ce.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 65d8d714e917..00d3f93058db 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -433,6 +433,13 @@ void ath10k_ce_rx_update_write_idx(struct ath10k_ce_pipe *pipe, u32 nentries)
 	unsigned int nentries_mask = dest_ring->nentries_mask;
 	unsigned int write_index = dest_ring->write_index;
 	u32 ctrl_addr = pipe->ctrl_addr;
+	u32 cur_write_idx = ath10k_ce_dest_ring_write_index_get(ar, ctrl_addr);
+
+	/* Prevent CE ring stuck issue that will occur when ring is full.
+	 * Make sure that write index is 1 less than read index.
+	 */
+	if ((cur_write_idx + nentries)  == dest_ring->sw_index)
+		nentries -= 1;
 
 	write_index = CE_RING_IDX_ADD(nentries_mask, write_index, nentries);
 	ath10k_ce_dest_ring_write_index_set(ar, ctrl_addr, write_index);
-- 
2.10.0
