Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:37194 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754371AbcK2WAk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Nov 2016 17:00:40 -0500
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Ben Greear <greearb@candelatech.com>
Subject: ath10k: wmi-alloc-chunk should use DMA_BIDIRECTIONAL.
Date: Tue, 29 Nov 2016 14:00:28 -0800
Message-Id: <1480456828-13735-1-git-send-email-greearb@candelatech.com> (sfid-20161129_230217_165000_1D154F54)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

These memory chunks are often used as 'swap' by the NIC,
so it will be both reading and writing to these areas.

This seems to fix errors like this on my x86-64 machine:

kernel: DMAR: DMAR:[DMA Write] Request device [05:00.0] fault addr ff5de000
        DMAR:[fault reason 05] PTE Write access is not set

Tested-by: Marek Behun <kabel@blackhole.sk>
Signed-off-by: Ben Greear <greearb@candelatech.com>

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 9fcb249..c68278a 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4558,7 +4558,7 @@ static int ath10k_wmi_alloc_chunk(struct ath10k *ar, u32 req_id,
 	if (!num_units)
 		return -ENOMEM;
 
-	paddr = dma_map_single(ar->dev, vaddr, pool_size, DMA_TO_DEVICE);
+	paddr = dma_map_single(ar->dev, vaddr, pool_size, DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(ar->dev, paddr)) {
 		kfree(vaddr);
 		return -ENOMEM;
