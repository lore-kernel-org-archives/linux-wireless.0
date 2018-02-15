Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59122 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755142AbeBOIt5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Feb 2018 03:49:57 -0500
From: Govind Singh <govinds@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH 09/13] ath10k: Modify hif tx paddr to dma_addr_t type
Date: Thu, 15 Feb 2018 14:19:52 +0530
Message-Id: <1518684592-5773-1-git-send-email-govinds@codeaurora.org> (sfid-20180215_095000_294635_1124FCE4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change type of hif sg tx paddr to dma_addr_t for
supporting target having addressing mode greater than
32 bit.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/hif.h | 2 +-
 drivers/net/wireless/ath/ath10k/pci.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/hif.h b/drivers/net/wireless/ath/ath10k/hif.h
index 6da4e33..7abb13c 100644
--- a/drivers/net/wireless/ath/ath10k/hif.h
+++ b/drivers/net/wireless/ath/ath10k/hif.h
@@ -26,7 +26,7 @@ struct ath10k_hif_sg_item {
 	u16 transfer_id;
 	void *transfer_context; /* NULL = tx completion callback not called */
 	void *vaddr; /* for debugging mostly */
-	u32 paddr;
+	dma_addr_t paddr;
 	u16 len;
 };
 
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 8abaccc..cda8689 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1375,8 +1375,8 @@ int ath10k_pci_hif_tx_sg(struct ath10k *ar, u8 pipe_id,
 
 	for (i = 0; i < n_items - 1; i++) {
 		ath10k_dbg(ar, ATH10K_DBG_PCI,
-			   "pci tx item %d paddr 0x%08x len %d n_items %d\n",
-			   i, items[i].paddr, items[i].len, n_items);
+			   "pci tx item %d paddr %pad len %d n_items %d\n",
+			   i, &items[i].paddr, items[i].len, n_items);
 		ath10k_dbg_dump(ar, ATH10K_DBG_PCI_DUMP, NULL, "pci tx data: ",
 				items[i].vaddr, items[i].len);
 
@@ -1393,8 +1393,8 @@ int ath10k_pci_hif_tx_sg(struct ath10k *ar, u8 pipe_id,
 	/* `i` is equal to `n_items -1` after for() */
 
 	ath10k_dbg(ar, ATH10K_DBG_PCI,
-		   "pci tx item %d paddr 0x%08x len %d n_items %d\n",
-		   i, items[i].paddr, items[i].len, n_items);
+		   "pci tx item %d paddr %pad len %d n_items %d\n",
+		   i, &items[i].paddr, items[i].len, n_items);
 	ath10k_dbg_dump(ar, ATH10K_DBG_PCI_DUMP, NULL, "pci tx data: ",
 			items[i].vaddr, items[i].len);
 
-- 
1.9.1
