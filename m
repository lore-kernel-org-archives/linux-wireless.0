Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33837 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752377AbdEAVnm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 May 2017 17:43:42 -0400
Received: by mail-pf0-f194.google.com with SMTP id g23so29369397pfj.1
        for <linux-wireless@vger.kernel.org>; Mon, 01 May 2017 14:43:42 -0700 (PDT)
From: Adrian Chadd <adrian@freebsd.org>
To: ath10k@lists.infradead.org, Kalle Valo <kvalo@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org
Cc: Adrian Chadd <adrian@freebsd.org>,
        Adrian Chadd <adrian@FreeBSD.org>
Subject: [PATCH] [ath10k] go back to using dma_alloc_coherent() for firmware scratch memory.
Date: Mon,  1 May 2017 14:43:27 -0700
Message-Id: <20170501214327.5621-1-adrian@freebsd.org> (sfid-20170501_234410_279622_E6D1230D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts b057886524be060021e3cfad0ba8458c850330cd in 2015
which converted this allocation from dma_map_coherent() to
kzalloc() / dma_map_single().

The current problem manifests when using later model NICs with larger
(>700KiB) scratch spaces in memory.  Although the kzalloc call
succeeds, the software IOMMU TLB code (via dma_map_single()) panics
because it can't find 700KiB of linear physmem bounce buffers for DMA.
Now, this is a bit of a silly failure mode for the dma map API,
but it's what we currently have to play with.

In these cases, doing kzalloc() works fine, but the dma_map_single()
call fails.

After chatting with Linus briefly about this, it indeed should be
using dma_alloc_coherent() for doing larger device memory allocation
that requires some kind of physical address mapping.

You're not supposed to be using kzalloc and dma_map_* calls for
large memory regions, and I'm guessing not for long-held mappings
either.  Typically dma mappings should be temporary for DMA,
not long held like these.

Now, since hopefully the major annoying underlying problem has also been
addressed (ie, ath10k is no longer tears down all of these allocations
and reallocates them every time the vdevs are brought down) fragmentation
should stop being such a touchy issue.  If it is though, using
dma_alloc_coherent() use gets us access to the CMB APIs too relatively
easily and ideally we would be allocating memory early in boot for
exactly these reasons.

Signed-off-by: Adrian Chadd <adrian@FreeBSD.org>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 35 ++++++++++-------------------------
 1 file changed, 10 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 6afc8d2..cc89f53 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4482,31 +4482,17 @@ static int ath10k_wmi_alloc_chunk(struct ath10k *ar, u32 req_id,
 				  u32 num_units, u32 unit_len)
 {
 	dma_addr_t paddr;
-	u32 pool_size = 0;
+	u32 pool_size;
 	int idx = ar->wmi.num_mem_chunks;
-	void *vaddr = NULL;
-
-	if (ar->wmi.num_mem_chunks == ARRAY_SIZE(ar->wmi.mem_chunks))
-		return -ENOMEM;
+	void *vaddr;
 
-	while (!vaddr && num_units) {
-		pool_size = num_units * round_up(unit_len, 4);
-		if (!pool_size)
-			return -EINVAL;
+	pool_size = num_units * round_up(unit_len, 4);
+	vaddr = dma_alloc_coherent(ar->dev, pool_size, &paddr, GFP_KERNEL);
 
-		vaddr = kzalloc(pool_size, GFP_KERNEL | __GFP_NOWARN);
-		if (!vaddr)
-			num_units /= 2;
-	}
-
-	if (!num_units)
+	if (!vaddr)
 		return -ENOMEM;
 
-	paddr = dma_map_single(ar->dev, vaddr, pool_size, DMA_BIDIRECTIONAL);
-	if (dma_mapping_error(ar->dev, paddr)) {
-		kfree(vaddr);
-		return -ENOMEM;
-	}
+	memset(vaddr, 0, pool_size);
 
 	ar->wmi.mem_chunks[idx].vaddr = vaddr;
 	ar->wmi.mem_chunks[idx].paddr = paddr;
@@ -8290,11 +8276,10 @@ void ath10k_wmi_free_host_mem(struct ath10k *ar)
 
 	/* free the host memory chunks requested by firmware */
 	for (i = 0; i < ar->wmi.num_mem_chunks; i++) {
-		dma_unmap_single(ar->dev,
-				 ar->wmi.mem_chunks[i].paddr,
-				 ar->wmi.mem_chunks[i].len,
-				 DMA_BIDIRECTIONAL);
-		kfree(ar->wmi.mem_chunks[i].vaddr);
+		dma_free_coherent(ar->dev,
+			    ar->wmi.mem_chunks[i].len,
+			    ar->wmi.mem_chunks[i].vaddr,
+			    ar->wmi.mem_chunks[i].paddr);
 	}
 
 	ar->wmi.num_mem_chunks = 0;
-- 
2.10.1 (Apple Git-78)
