Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22751 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750895AbcLGFDT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 00:03:19 -0500
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
        "Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH] ath10k: Avoid potential page alloc BUG_ON in tx free path
Date: Wed, 7 Dec 2016 10:30:32 +0530
Message-ID: <1481086832-17281-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20161207_060323_650720_89BEB873)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

'ath10k_htt_tx_free_cont_txbuf' and 'ath10k_htt_tx_free_cont_frag_desc'
have NULL pointer checks to avoid crash if they are called twice
but this is as of now not sufficient as these pointers are not assigned
to NULL once the contiguous DMA memory allocation is freed, fix this.
Though this may not be hit with the explicity check of state variable
'tx_mem_allocated' check, good to have this addressed as well.

Below BUG_ON is hit when the above scenario is simulated
with kernel debugging enabled

 page:f6d09a00 count:0 mapcount:-127 mapping:  (null)
index:0x0
 flags: 0x40000000()
 page dumped because: VM_BUG_ON_PAGE(page_ref_count(page)
== 0)
 ------------[ cut here ]------------
 kernel BUG at ./include/linux/mm.h:445!
 invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
 EIP is at put_page_testzero.part.88+0xd/0xf
 Call Trace:
  [<c118a2cc>] __free_pages+0x3c/0x40
  [<c118a30e>] free_pages+0x3e/0x50
  [<c10222b4>] dma_generic_free_coherent+0x24/0x30
  [<f8c1d9a8>] ath10k_htt_tx_free_cont_txbuf+0xf8/0x140

  [<f8c1e2a9>] ath10k_htt_tx_destroy+0x29/0xa0

  [<f8c143e0>] ath10k_core_destroy+0x60/0x80 [ath10k_core]
  [<f8acd7e9>] ath10k_pci_remove+0x79/0xa0 [ath10k_pci]
  [<c13ed7a8>] pci_device_remove+0x38/0xb0
  [<c14d3492>] __device_release_driver+0x72/0x100
  [<c14d36b7>] driver_detach+0x97/0xa0
  [<c14d29c0>] bus_remove_driver+0x40/0x80
  [<c14d427a>] driver_unregister+0x2a/0x60
  [<c13ec768>] pci_unregister_driver+0x18/0x70
  [<f8aced4f>] ath10k_pci_exit+0xd/0x2be [ath10k_pci]
  [<c1101e78>] SyS_delete_module+0x158/0x210
  [<c11b34f1>] ? __might_fault+0x41/0xa0
  [<c11b353b>] ? __might_fault+0x8b/0xa0
  [<c1001a4b>] do_fast_syscall_32+0x9b/0x1c0
  [<c178da34>] sysenter_past_esp+0x45/0x74

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt_tx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 27e49db..86b427f 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -239,6 +239,7 @@ static void ath10k_htt_tx_free_cont_txbuf(struct ath10k_htt *htt)
 
 	size = htt->max_num_pending_tx * sizeof(struct ath10k_htt_txbuf);
 	dma_free_coherent(ar->dev, size, htt->txbuf.vaddr, htt->txbuf.paddr);
+	htt->txbuf.vaddr = NULL;
 }
 
 static int ath10k_htt_tx_alloc_cont_txbuf(struct ath10k_htt *htt)
@@ -268,6 +269,7 @@ static void ath10k_htt_tx_free_cont_frag_desc(struct ath10k_htt *htt)
 			  size,
 			  htt->frag_desc.vaddr,
 			  htt->frag_desc.paddr);
+	htt->frag_desc.vaddr = NULL;
 }
 
 static int ath10k_htt_tx_alloc_cont_frag_desc(struct ath10k_htt *htt)
-- 
1.9.1
