Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:43095 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756541AbbAIOBb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2015 09:01:31 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <ath10k-devel@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH] ath10k: Fix potential Rx ring corruption
Date: Fri, 9 Jan 2015 19:27:26 +0530
Message-ID: <1420811846-20660-1-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20150109_150134_370740_E9481A06)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When replenishing Rx buffers driver updates the address of the
buffer and the index of rx buffer in rx ring to the firmware.
Change in order by CPU can cause rx ring corruption. Add memory
barrier before updating rx buffer index to guarantee the order.

This could fix some instances of rx ring corruption due to done
bit in rx attention flag not set.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 9c782a4..baa1c44 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -97,6 +97,11 @@ static int __ath10k_htt_rx_ring_fill_n(struct ath10k_htt *htt, int num)
 	}
 
 fail:
+	/*
+	 * Make sure the rx buffer is updated before available buffer
+	 * index to avoid any potential rx ring corruption.
+	 */
+	mb();
 	*htt->rx_ring.alloc_idx.vaddr = __cpu_to_le32(idx);
 	return ret;
 }
-- 
1.7.9.5

