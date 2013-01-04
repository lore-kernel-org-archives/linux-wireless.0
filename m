Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:49154 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751013Ab3ADFZg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jan 2013 00:25:36 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/5] mwifiex: use pci_alloc/free_consistent APIs for PCIe
Date: Thu,  3 Jan 2013 21:21:30 -0800
Message-Id: <1357276892-32759-4-git-send-email-bzhao@marvell.com> (sfid-20130104_062539_906179_304C7B72)
In-Reply-To: <1357276892-32759-1-git-send-email-bzhao@marvell.com>
References: <1357276892-32759-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch uses pci_alloc_consistent and pci_free_consistent
APIs for mwifiex_pcie driver. Consistent DMA memory is allocated
for TX, RX and event rings. Command buffer and command response
buffer also uses map/unmap memory APIs to download commands and
get command responses.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c    |  362 +++++++++++++++++++-------------
 drivers/net/wireless/mwifiex/pcie.h    |    9 +-
 drivers/net/wireless/mwifiex/sta_cmd.c |   10 +-
 drivers/net/wireless/mwifiex/util.h    |    8 +-
 4 files changed, 235 insertions(+), 154 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 191c682..ac20bc4 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -39,17 +39,20 @@ static struct semaphore add_remove_card_sem;
 static int mwifiex_pcie_enable_host_int(struct mwifiex_adapter *adapter);
 static int mwifiex_pcie_resume(struct pci_dev *pdev);
 
-/*
- * This function is called after skb allocation to update
- * "skb->cb" with physical address of data pointer.
- */
-static phys_addr_t *mwifiex_update_sk_buff_pa(struct sk_buff *skb)
+static int
+mwifiex_map_pci_memory(struct mwifiex_adapter *adapter, struct sk_buff *skb,
+		       int size, int flags)
 {
-	phys_addr_t *buf_pa = MWIFIEX_SKB_PACB(skb);
-
-	*buf_pa = (phys_addr_t)virt_to_phys(skb->data);
+	struct pcie_service_card *card = adapter->card;
+	dma_addr_t buf_pa;
 
-	return buf_pa;
+	buf_pa = pci_map_single(card->dev, skb->data, size, flags);
+	if (pci_dma_mapping_error(card->dev, buf_pa)) {
+		dev_err(adapter->dev, "failed to map pci memory!\n");
+		return -1;
+	}
+	memcpy(skb->cb, &buf_pa, sizeof(dma_addr_t));
+	return 0;
 }
 
 /*
@@ -60,8 +63,8 @@ static bool mwifiex_pcie_ok_to_access_hw(struct mwifiex_adapter *adapter)
 	u32 *cookie_addr;
 	struct pcie_service_card *card = adapter->card;
 
-	if (card->sleep_cookie) {
-		cookie_addr = (u32 *)card->sleep_cookie->data;
+	if (card->sleep_cookie_vbase) {
+		cookie_addr = (u32 *)card->sleep_cookie_vbase;
 		dev_dbg(adapter->dev, "info: ACCESS_HW: sleep cookie=0x%x\n",
 			*cookie_addr);
 		if (*cookie_addr == FW_AWAKE_COOKIE)
@@ -366,9 +369,7 @@ static int mwifiex_pcie_enable_host_int(struct mwifiex_adapter *adapter)
 static int mwifiex_pcie_create_txbd_ring(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
-	struct sk_buff *skb;
 	int i;
-	phys_addr_t *buf_pa;
 
 	/*
 	 * driver maintaines the write pointer and firmware maintaines the read
@@ -384,16 +385,18 @@ static int mwifiex_pcie_create_txbd_ring(struct mwifiex_adapter *adapter)
 							MWIFIEX_MAX_TXRX_BD;
 	dev_dbg(adapter->dev, "info: txbd_ring: Allocating %d bytes\n",
 		card->txbd_ring_size);
-	card->txbd_ring_vbase = kzalloc(card->txbd_ring_size, GFP_KERNEL);
+	card->txbd_ring_vbase = pci_alloc_consistent(card->dev,
+						     card->txbd_ring_size,
+						     &card->txbd_ring_pbase);
 	if (!card->txbd_ring_vbase) {
-		dev_err(adapter->dev, "Unable to alloc buffer for txbd ring\n");
+		dev_err(adapter->dev,
+			"allocate consistent memory (%d bytes) failed!\n",
+			card->txbd_ring_size);
 		return -ENOMEM;
 	}
-	card->txbd_ring_pbase = virt_to_phys(card->txbd_ring_vbase);
-
 	dev_dbg(adapter->dev,
 		"info: txbd_ring - base: %p, pbase: %#x:%x, len: %x\n",
-		card->txbd_ring_vbase, (u32)card->txbd_ring_pbase,
+		card->txbd_ring_vbase, (unsigned int)card->txbd_ring_pbase,
 		(u32)((u64)card->txbd_ring_pbase >> 32), card->txbd_ring_size);
 
 	for (i = 0; i < MWIFIEX_MAX_TXRX_BD; i++) {
@@ -402,24 +405,9 @@ static int mwifiex_pcie_create_txbd_ring(struct mwifiex_adapter *adapter)
 				      (sizeof(struct mwifiex_pcie_buf_desc)
 				       * i));
 
-		/* Allocate buffer here so that firmware can DMA data from it */
-		skb = dev_alloc_skb(MWIFIEX_RX_DATA_BUF_SIZE);
-		if (!skb) {
-			dev_err(adapter->dev, "Unable to allocate skb for TX ring.\n");
-			kfree(card->txbd_ring_vbase);
-			return -ENOMEM;
-		}
-		buf_pa = mwifiex_update_sk_buff_pa(skb);
-
-		skb_put(skb, MWIFIEX_RX_DATA_BUF_SIZE);
-		dev_dbg(adapter->dev, "info: TX ring: add new skb base: %p, "
-			"buf_base: %p, buf_pbase: %#x:%x, buf_len: %#x\n",
-			skb, skb->data, (u32)*buf_pa,
-			(u32)(((u64)*buf_pa >> 32)), skb->len);
-
-		card->tx_buf_list[i] = skb;
-		card->txbd_ring[i]->paddr = *buf_pa;
-		card->txbd_ring[i]->len = (u16)skb->len;
+		card->tx_buf_list[i] = NULL;
+		card->txbd_ring[i]->paddr = 0;
+		card->txbd_ring[i]->len = 0;
 		card->txbd_ring[i]->flags = 0;
 	}
 
@@ -429,11 +417,16 @@ static int mwifiex_pcie_create_txbd_ring(struct mwifiex_adapter *adapter)
 static int mwifiex_pcie_delete_txbd_ring(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
+	struct sk_buff *skb;
 	int i;
 
 	for (i = 0; i < MWIFIEX_MAX_TXRX_BD; i++) {
-		if (card->tx_buf_list[i])
-			dev_kfree_skb_any(card->tx_buf_list[i]);
+		if (card->tx_buf_list[i]) {
+			skb = card->tx_buf_list[i];
+			pci_unmap_single(card->dev, card->txbd_ring[i]->paddr,
+					 skb->len, PCI_DMA_TODEVICE);
+			dev_kfree_skb_any(skb);
+		}
 		card->tx_buf_list[i] = NULL;
 		card->txbd_ring[i]->paddr = 0;
 		card->txbd_ring[i]->len = 0;
@@ -441,11 +434,15 @@ static int mwifiex_pcie_delete_txbd_ring(struct mwifiex_adapter *adapter)
 		card->txbd_ring[i] = NULL;
 	}
 
-	kfree(card->txbd_ring_vbase);
+	if (card->txbd_ring_vbase)
+		pci_free_consistent(card->dev, card->txbd_ring_size,
+				    card->txbd_ring_vbase,
+				    card->txbd_ring_pbase);
 	card->txbd_ring_size = 0;
 	card->txbd_wrptr = 0;
 	card->txbd_rdptr = 0 | MWIFIEX_BD_FLAG_ROLLOVER_IND;
 	card->txbd_ring_vbase = NULL;
+	card->txbd_ring_pbase = 0;
 
 	return 0;
 }
@@ -458,7 +455,7 @@ static int mwifiex_pcie_create_rxbd_ring(struct mwifiex_adapter *adapter)
 	struct pcie_service_card *card = adapter->card;
 	struct sk_buff *skb;
 	int i;
-	phys_addr_t *buf_pa;
+	dma_addr_t buf_pa;
 
 	/*
 	 * driver maintaines the read pointer and firmware maintaines the write
@@ -472,13 +469,15 @@ static int mwifiex_pcie_create_rxbd_ring(struct mwifiex_adapter *adapter)
 							MWIFIEX_MAX_TXRX_BD;
 	dev_dbg(adapter->dev, "info: rxbd_ring: Allocating %d bytes\n",
 		card->rxbd_ring_size);
-	card->rxbd_ring_vbase = kzalloc(card->rxbd_ring_size, GFP_KERNEL);
+	card->rxbd_ring_vbase = pci_alloc_consistent(card->dev,
+						     card->rxbd_ring_size,
+						     &card->rxbd_ring_pbase);
 	if (!card->rxbd_ring_vbase) {
-		dev_err(adapter->dev, "Unable to allocate buffer for "
-				"rxbd_ring.\n");
+		dev_err(adapter->dev,
+			"allocate consistent memory (%d bytes) failed!\n",
+			card->rxbd_ring_size);
 		return -ENOMEM;
 	}
-	card->rxbd_ring_pbase = virt_to_phys(card->rxbd_ring_vbase);
 
 	dev_dbg(adapter->dev,
 		"info: rxbd_ring - base: %p, pbase: %#x:%x, len: %#x\n",
@@ -500,16 +499,20 @@ static int mwifiex_pcie_create_rxbd_ring(struct mwifiex_adapter *adapter)
 			kfree(card->rxbd_ring_vbase);
 			return -ENOMEM;
 		}
-		buf_pa = mwifiex_update_sk_buff_pa(skb);
-		skb_put(skb, MWIFIEX_RX_DATA_BUF_SIZE);
+		if (mwifiex_map_pci_memory(adapter, skb,
+					   MWIFIEX_RX_DATA_BUF_SIZE,
+					   PCI_DMA_FROMDEVICE))
+			return -1;
+
+		MWIFIEX_SKB_PACB(skb, &buf_pa);
 
 		dev_dbg(adapter->dev, "info: RX ring: add new skb base: %p, "
 			"buf_base: %p, buf_pbase: %#x:%x, buf_len: %#x\n",
-			skb, skb->data, (u32)*buf_pa, (u32)((u64)*buf_pa >> 32),
+			skb, skb->data, (u32)buf_pa, (u32)((u64)buf_pa >> 32),
 			skb->len);
 
 		card->rx_buf_list[i] = skb;
-		card->rxbd_ring[i]->paddr = *buf_pa;
+		card->rxbd_ring[i]->paddr = buf_pa;
 		card->rxbd_ring[i]->len = (u16)skb->len;
 		card->rxbd_ring[i]->flags = 0;
 	}
@@ -523,11 +526,17 @@ static int mwifiex_pcie_create_rxbd_ring(struct mwifiex_adapter *adapter)
 static int mwifiex_pcie_delete_rxbd_ring(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
+	struct sk_buff *skb;
 	int i;
 
 	for (i = 0; i < MWIFIEX_MAX_TXRX_BD; i++) {
-		if (card->rx_buf_list[i])
-			dev_kfree_skb_any(card->rx_buf_list[i]);
+		if (card->rx_buf_list[i]) {
+			skb = card->rx_buf_list[i];
+			pci_unmap_single(card->dev, card->rxbd_ring[i]->paddr ,
+					 MWIFIEX_RX_DATA_BUF_SIZE,
+					 PCI_DMA_FROMDEVICE);
+			dev_kfree_skb_any(skb);
+		}
 		card->rx_buf_list[i] = NULL;
 		card->rxbd_ring[i]->paddr = 0;
 		card->rxbd_ring[i]->len = 0;
@@ -535,11 +544,15 @@ static int mwifiex_pcie_delete_rxbd_ring(struct mwifiex_adapter *adapter)
 		card->rxbd_ring[i] = NULL;
 	}
 
-	kfree(card->rxbd_ring_vbase);
+	if (card->rxbd_ring_vbase)
+		pci_free_consistent(card->dev, card->rxbd_ring_size,
+				    card->rxbd_ring_vbase,
+				    card->rxbd_ring_pbase);
 	card->rxbd_ring_size = 0;
 	card->rxbd_wrptr = 0;
 	card->rxbd_rdptr = 0 | MWIFIEX_BD_FLAG_ROLLOVER_IND;
 	card->rxbd_ring_vbase = NULL;
+	card->rxbd_ring_pbase = 0;
 
 	return 0;
 }
@@ -552,7 +565,7 @@ static int mwifiex_pcie_create_evtbd_ring(struct mwifiex_adapter *adapter)
 	struct pcie_service_card *card = adapter->card;
 	struct sk_buff *skb;
 	int i;
-	phys_addr_t *buf_pa;
+	dma_addr_t buf_pa;
 
 	/*
 	 * driver maintaines the read pointer and firmware maintaines the write
@@ -566,13 +579,15 @@ static int mwifiex_pcie_create_evtbd_ring(struct mwifiex_adapter *adapter)
 							MWIFIEX_MAX_EVT_BD;
 	dev_dbg(adapter->dev, "info: evtbd_ring: Allocating %d bytes\n",
 		card->evtbd_ring_size);
-	card->evtbd_ring_vbase = kzalloc(card->evtbd_ring_size, GFP_KERNEL);
+	card->evtbd_ring_vbase = pci_alloc_consistent(card->dev,
+						      card->evtbd_ring_size,
+						      &card->evtbd_ring_pbase);
 	if (!card->evtbd_ring_vbase) {
 		dev_err(adapter->dev,
-			"Unable to allocate buffer. Terminating download\n");
+			"allocate consistent memory (%d bytes) failed!\n",
+			card->evtbd_ring_size);
 		return -ENOMEM;
 	}
-	card->evtbd_ring_pbase = virt_to_phys(card->evtbd_ring_vbase);
 
 	dev_dbg(adapter->dev,
 		"info: CMDRSP/EVT bd_ring - base: %p pbase: %#x:%x len: %#x\n",
@@ -594,16 +609,20 @@ static int mwifiex_pcie_create_evtbd_ring(struct mwifiex_adapter *adapter)
 			kfree(card->evtbd_ring_vbase);
 			return -ENOMEM;
 		}
-		buf_pa = mwifiex_update_sk_buff_pa(skb);
 		skb_put(skb, MAX_EVENT_SIZE);
 
+		if (mwifiex_map_pci_memory(adapter, skb, MAX_EVENT_SIZE,
+					   PCI_DMA_FROMDEVICE))
+			return -1;
+
+		MWIFIEX_SKB_PACB(skb, &buf_pa);
 		dev_dbg(adapter->dev, "info: Evt ring: add new skb. base: %p, "
 			"buf_base: %p, buf_pbase: %#x:%x, buf_len: %#x\n",
-			skb, skb->data, (u32)*buf_pa, (u32)((u64)*buf_pa >> 32),
+			skb, skb->data, (u32)buf_pa, (u32)((u64)buf_pa >> 32),
 			skb->len);
 
 		card->evt_buf_list[i] = skb;
-		card->evtbd_ring[i]->paddr = *buf_pa;
+		card->evtbd_ring[i]->paddr = buf_pa;
 		card->evtbd_ring[i]->len = (u16)skb->len;
 		card->evtbd_ring[i]->flags = 0;
 	}
@@ -617,11 +636,16 @@ static int mwifiex_pcie_create_evtbd_ring(struct mwifiex_adapter *adapter)
 static int mwifiex_pcie_delete_evtbd_ring(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
+	struct sk_buff *skb;
 	int i;
 
 	for (i = 0; i < MWIFIEX_MAX_EVT_BD; i++) {
-		if (card->evt_buf_list[i])
-			dev_kfree_skb_any(card->evt_buf_list[i]);
+		if (card->evt_buf_list[i]) {
+			skb = card->evt_buf_list[i];
+			pci_unmap_single(card->dev, card->evtbd_ring[i]->paddr,
+					 MAX_EVENT_SIZE, PCI_DMA_FROMDEVICE);
+			dev_kfree_skb_any(skb);
+		}
 		card->evt_buf_list[i] = NULL;
 		card->evtbd_ring[i]->paddr = 0;
 		card->evtbd_ring[i]->len = 0;
@@ -629,11 +653,15 @@ static int mwifiex_pcie_delete_evtbd_ring(struct mwifiex_adapter *adapter)
 		card->evtbd_ring[i] = NULL;
 	}
 
-	kfree(card->evtbd_ring_vbase);
+	if (card->evtbd_ring_vbase)
+		pci_free_consistent(card->dev, card->evtbd_ring_size,
+				    card->evtbd_ring_vbase,
+				    card->evtbd_ring_pbase);
 	card->evtbd_wrptr = 0;
 	card->evtbd_rdptr = 0 | MWIFIEX_BD_FLAG_ROLLOVER_IND;
 	card->evtbd_ring_size = 0;
 	card->evtbd_ring_vbase = NULL;
+	card->evtbd_ring_pbase = 0;
 
 	return 0;
 }
@@ -653,21 +681,12 @@ static int mwifiex_pcie_alloc_cmdrsp_buf(struct mwifiex_adapter *adapter)
 			"Unable to allocate skb for command response data.\n");
 		return -ENOMEM;
 	}
-	mwifiex_update_sk_buff_pa(skb);
 	skb_put(skb, MWIFIEX_UPLD_SIZE);
-	card->cmdrsp_buf = skb;
+	if (mwifiex_map_pci_memory(adapter, skb, MWIFIEX_UPLD_SIZE,
+				   PCI_DMA_FROMDEVICE))
+		return -1;
 
-	skb = NULL;
-	/* Allocate memory for sending command to firmware */
-	skb = dev_alloc_skb(MWIFIEX_SIZE_OF_CMD_BUFFER);
-	if (!skb) {
-		dev_err(adapter->dev,
-			"Unable to allocate skb for command data.\n");
-		return -ENOMEM;
-	}
-	mwifiex_update_sk_buff_pa(skb);
-	skb_put(skb, MWIFIEX_SIZE_OF_CMD_BUFFER);
-	card->cmd_buf = skb;
+	card->cmdrsp_buf = skb;
 
 	return 0;
 }
@@ -678,18 +697,26 @@ static int mwifiex_pcie_alloc_cmdrsp_buf(struct mwifiex_adapter *adapter)
 static int mwifiex_pcie_delete_cmdrsp_buf(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card;
+	dma_addr_t buf_pa;
 
 	if (!adapter)
 		return 0;
 
 	card = adapter->card;
 
-	if (card && card->cmdrsp_buf)
+	if (card && card->cmdrsp_buf) {
+		MWIFIEX_SKB_PACB(card->cmdrsp_buf, &buf_pa);
+		pci_unmap_single(card->dev, buf_pa, MWIFIEX_UPLD_SIZE,
+				 PCI_DMA_FROMDEVICE);
 		dev_kfree_skb_any(card->cmdrsp_buf);
+	}
 
-	if (card && card->cmd_buf)
+	if (card && card->cmd_buf) {
+		MWIFIEX_SKB_PACB(card->cmd_buf, &buf_pa);
+		pci_unmap_single(card->dev, buf_pa, MWIFIEX_SIZE_OF_CMD_BUFFER,
+				 PCI_DMA_TODEVICE);
 		dev_kfree_skb_any(card->cmd_buf);
-
+	}
 	return 0;
 }
 
@@ -698,27 +725,19 @@ static int mwifiex_pcie_delete_cmdrsp_buf(struct mwifiex_adapter *adapter)
  */
 static int mwifiex_pcie_alloc_sleep_cookie_buf(struct mwifiex_adapter *adapter)
 {
-	struct sk_buff *skb;
 	struct pcie_service_card *card = adapter->card;
 
-	/* Allocate memory for sleep cookie */
-	skb = dev_alloc_skb(sizeof(u32));
-	if (!skb) {
-		dev_err(adapter->dev,
-			"Unable to allocate skb for sleep cookie!\n");
+	card->sleep_cookie_vbase = pci_alloc_consistent(card->dev, sizeof(u32),
+						     &card->sleep_cookie_pbase);
+	if (!card->sleep_cookie_vbase) {
+		dev_err(adapter->dev, "pci_alloc_consistent failed!\n");
 		return -ENOMEM;
 	}
-	mwifiex_update_sk_buff_pa(skb);
-	skb_put(skb, sizeof(u32));
-
 	/* Init val of Sleep Cookie */
-	*(u32 *)skb->data = FW_AWAKE_COOKIE;
+	*(u32 *)card->sleep_cookie_vbase = FW_AWAKE_COOKIE;
 
 	dev_dbg(adapter->dev, "alloc_scook: sleep cookie=0x%x\n",
-		*((u32 *)skb->data));
-
-	/* Save the sleep cookie */
-	card->sleep_cookie = skb;
+		*((u32 *)card->sleep_cookie_vbase));
 
 	return 0;
 }
@@ -735,9 +754,11 @@ static int mwifiex_pcie_delete_sleep_cookie_buf(struct mwifiex_adapter *adapter)
 
 	card = adapter->card;
 
-	if (card && card->sleep_cookie) {
-		dev_kfree_skb_any(card->sleep_cookie);
-		card->sleep_cookie = NULL;
+	if (card && card->sleep_cookie_vbase) {
+		pci_free_consistent(card->dev, sizeof(u32),
+				    card->sleep_cookie_vbase,
+				    card->sleep_cookie_pbase);
+		card->sleep_cookie_vbase = NULL;
 	}
 
 	return 0;
@@ -751,7 +772,7 @@ mwifiex_pcie_send_data(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 {
 	struct pcie_service_card *card = adapter->card;
 	u32 wrindx, rdptr;
-	phys_addr_t *buf_pa;
+	phys_addr_t buf_pa;
 	__le16 *tmp;
 
 	if (!mwifiex_pcie_ok_to_access_hw(adapter))
@@ -785,8 +806,8 @@ mwifiex_pcie_send_data(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 		*tmp = cpu_to_le16(MWIFIEX_TYPE_DATA);
 		skb_put(skb_data, MWIFIEX_RX_DATA_BUF_SIZE - skb_data->len);
 		skb_trim(skb_data, skb->len);
-		buf_pa = MWIFIEX_SKB_PACB(skb_data);
-		card->txbd_ring[wrindx]->paddr = *buf_pa;
+		MWIFIEX_SKB_PACB(skb_data, &buf_pa);
+		card->txbd_ring[wrindx]->paddr = buf_pa;
 		card->txbd_ring[wrindx]->len = (u16)skb_data->len;
 		card->txbd_ring[wrindx]->flags = MWIFIEX_BD_FLAG_FIRST_DESC |
 						MWIFIEX_BD_FLAG_LAST_DESC;
@@ -918,32 +939,41 @@ done:
 static int
 mwifiex_pcie_send_boot_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 {
-	phys_addr_t *buf_pa = MWIFIEX_SKB_PACB(skb);
+	dma_addr_t buf_pa;
+	struct pcie_service_card *card = adapter->card;
 
-	if (!(skb->data && skb->len && *buf_pa)) {
+	if (!(skb->data && skb->len)) {
 		dev_err(adapter->dev,
-			"Invalid parameter in %s <%p, %#x:%x, %x>\n",
-			__func__, skb->data, skb->len,
-			(u32)*buf_pa, (u32)((u64)*buf_pa >> 32));
+			"Invalid parameter in %s <%p. len %d>\n",
+			__func__, skb->data, skb->len);
 		return -1;
 	}
 
+	if (mwifiex_map_pci_memory(adapter, skb, skb->len , PCI_DMA_TODEVICE))
+		return -1;
+
+	MWIFIEX_SKB_PACB(skb, &buf_pa);
+
 	/* Write the lower 32bits of the physical address to scratch
 	 * register 0 */
-	if (mwifiex_write_reg(adapter, PCIE_SCRATCH_0_REG, (u32)*buf_pa)) {
+	if (mwifiex_write_reg(adapter, PCIE_SCRATCH_0_REG, (u32)buf_pa)) {
 		dev_err(adapter->dev,
 			"%s: failed to write download command to boot code.\n",
 			__func__);
+		pci_unmap_single(card->dev, buf_pa, MWIFIEX_UPLD_SIZE,
+				 PCI_DMA_TODEVICE);
 		return -1;
 	}
 
 	/* Write the upper 32bits of the physical address to scratch
 	 * register 1 */
 	if (mwifiex_write_reg(adapter, PCIE_SCRATCH_1_REG,
-			      (u32)((u64)*buf_pa >> 32))) {
+			      (u32)((u64)buf_pa >> 32))) {
 		dev_err(adapter->dev,
 			"%s: failed to write download command to boot code.\n",
 			__func__);
+		pci_unmap_single(card->dev, buf_pa, MWIFIEX_UPLD_SIZE,
+				 PCI_DMA_TODEVICE);
 		return -1;
 	}
 
@@ -952,6 +982,8 @@ mwifiex_pcie_send_boot_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 		dev_err(adapter->dev,
 			"%s: failed to write command len to scratch reg 2\n",
 			__func__);
+		pci_unmap_single(card->dev, buf_pa, MWIFIEX_UPLD_SIZE,
+				 PCI_DMA_TODEVICE);
 		return -1;
 	}
 
@@ -960,6 +992,8 @@ mwifiex_pcie_send_boot_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 			      CPU_INTR_DOOR_BELL)) {
 		dev_err(adapter->dev,
 			"%s: failed to assert door-bell intr\n", __func__);
+		pci_unmap_single(card->dev, buf_pa,
+				 MWIFIEX_UPLD_SIZE, PCI_DMA_TODEVICE);
 		return -1;
 	}
 
@@ -989,8 +1023,8 @@ mwifiex_pcie_send_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 {
 	struct pcie_service_card *card = adapter->card;
 	int ret = 0;
-	phys_addr_t *cmd_buf_pa;
-	phys_addr_t *cmdrsp_buf_pa;
+	dma_addr_t cmd_buf_pa, cmdrsp_buf_pa;
+	u8 *payload = (u8 *)skb->data;
 
 	if (!(skb->data && skb->len)) {
 		dev_err(adapter->dev, "Invalid parameter in %s <%p, %#x>\n",
@@ -1005,17 +1039,18 @@ mwifiex_pcie_send_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 		return -EBUSY;
 	}
 
-	/* Make sure a command buffer is available */
-	if (!card->cmd_buf) {
-		dev_err(adapter->dev, "Command buffer not available\n");
-		return -EBUSY;
-	}
+	if (!mwifiex_pcie_ok_to_access_hw(adapter))
+		mwifiex_pm_wakeup_card(adapter);
 
 	adapter->cmd_sent = true;
-	/* Copy the given skb in to DMA accessable shared buffer */
-	skb_put(card->cmd_buf, MWIFIEX_SIZE_OF_CMD_BUFFER - card->cmd_buf->len);
-	skb_trim(card->cmd_buf, skb->len);
-	memcpy(card->cmd_buf->data, skb->data, skb->len);
+
+	*(__le16 *)&payload[0] = cpu_to_le16((u16)skb->len);
+	*(__le16 *)&payload[2] = cpu_to_le16(MWIFIEX_TYPE_CMD);
+
+	if (mwifiex_map_pci_memory(adapter, skb, skb->len, PCI_DMA_TODEVICE))
+		return -1;
+
+	card->cmd_buf = skb;
 
 	/* To send a command, the driver will:
 		1. Write the 64bit physical address of the data buffer to
@@ -1028,11 +1063,11 @@ mwifiex_pcie_send_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 	*/
 
 	if (card->cmdrsp_buf) {
-		cmdrsp_buf_pa = MWIFIEX_SKB_PACB(card->cmdrsp_buf);
+		MWIFIEX_SKB_PACB(card->cmdrsp_buf, &cmdrsp_buf_pa);
 		/* Write the lower 32bits of the cmdrsp buffer physical
 		   address */
 		if (mwifiex_write_reg(adapter, REG_CMDRSP_ADDR_LO,
-				      (u32)*cmdrsp_buf_pa)) {
+				      (u32)cmdrsp_buf_pa)) {
 			dev_err(adapter->dev,
 				"Failed to write download cmd to boot code.\n");
 			ret = -1;
@@ -1041,7 +1076,7 @@ mwifiex_pcie_send_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 		/* Write the upper 32bits of the cmdrsp buffer physical
 		   address */
 		if (mwifiex_write_reg(adapter, REG_CMDRSP_ADDR_HI,
-				      (u32)((u64)*cmdrsp_buf_pa >> 32))) {
+				      (u32)((u64)cmdrsp_buf_pa >> 32))) {
 			dev_err(adapter->dev,
 				"Failed to write download cmd to boot code.\n");
 			ret = -1;
@@ -1049,9 +1084,9 @@ mwifiex_pcie_send_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 		}
 	}
 
-	cmd_buf_pa = MWIFIEX_SKB_PACB(card->cmd_buf);
+	MWIFIEX_SKB_PACB(card->cmd_buf, &cmd_buf_pa);
 	/* Write the lower 32bits of the physical address to REG_CMD_ADDR_LO */
-	if (mwifiex_write_reg(adapter, REG_CMD_ADDR_LO, (u32)*cmd_buf_pa)) {
+	if (mwifiex_write_reg(adapter, REG_CMD_ADDR_LO, (u32)cmd_buf_pa)) {
 		dev_err(adapter->dev,
 			"Failed to write download cmd to boot code.\n");
 		ret = -1;
@@ -1059,7 +1094,7 @@ mwifiex_pcie_send_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 	}
 	/* Write the upper 32bits of the physical address to REG_CMD_ADDR_HI */
 	if (mwifiex_write_reg(adapter, REG_CMD_ADDR_HI,
-			      (u32)((u64)*cmd_buf_pa >> 32))) {
+			      (u32)((u64)cmd_buf_pa >> 32))) {
 		dev_err(adapter->dev,
 			"Failed to write download cmd to boot code.\n");
 		ret = -1;
@@ -1098,11 +1133,22 @@ static int mwifiex_pcie_process_cmd_complete(struct mwifiex_adapter *adapter)
 	struct pcie_service_card *card = adapter->card;
 	struct sk_buff *skb = card->cmdrsp_buf;
 	int count = 0;
+	u16 rx_len;
+	__le16 pkt_len;
+	dma_addr_t buf_pa;
 
 	dev_dbg(adapter->dev, "info: Rx CMD Response\n");
 
+	MWIFIEX_SKB_PACB(skb, &buf_pa);
+	pci_unmap_single(card->dev, buf_pa, MWIFIEX_UPLD_SIZE,
+			 PCI_DMA_FROMDEVICE);
+
+	pkt_len = *((__le16 *)skb->data);
+	rx_len = le16_to_cpu(pkt_len);
+	skb_trim(skb, rx_len);
+	skb_pull(skb, INTF_HEADER_LEN);
+
 	if (!adapter->curr_cmd) {
-		skb_pull(skb, INTF_HEADER_LEN);
 		if (adapter->ps_state == PS_STATE_SLEEP_CFM) {
 			mwifiex_process_sleep_confirm_resp(adapter, skb->data,
 							   skb->len);
@@ -1115,9 +1161,12 @@ static int mwifiex_pcie_process_cmd_complete(struct mwifiex_adapter *adapter)
 		}
 		memcpy(adapter->upld_buf, skb->data,
 		       min_t(u32, MWIFIEX_SIZE_OF_CMD_BUFFER, skb->len));
-		skb_push(skb, INTF_HEADER_LEN);
+		if (mwifiex_map_pci_memory(adapter, skb, MWIFIEX_UPLD_SIZE,
+					   PCI_DMA_FROMDEVICE))
+			return -1;
+
+		MWIFIEX_SKB_PACB(skb, &buf_pa);
 	} else if (mwifiex_pcie_ok_to_access_hw(adapter)) {
-		skb_pull(skb, INTF_HEADER_LEN);
 		adapter->curr_cmd->resp_skb = skb;
 		adapter->cmd_resp_received = true;
 		/* Take the pointer and set it to CMD node and will
@@ -1151,10 +1200,23 @@ static int mwifiex_pcie_cmdrsp_complete(struct mwifiex_adapter *adapter,
 					struct sk_buff *skb)
 {
 	struct pcie_service_card *card = adapter->card;
+	dma_addr_t buf_pa;
+	struct sk_buff *skb_tmp;
 
 	if (skb) {
 		card->cmdrsp_buf = skb;
 		skb_push(card->cmdrsp_buf, INTF_HEADER_LEN);
+		if (mwifiex_map_pci_memory(adapter, skb, MWIFIEX_UPLD_SIZE,
+					   PCI_DMA_FROMDEVICE))
+			return -1;
+	}
+
+	skb_tmp = card->cmd_buf;
+	if (skb_tmp) {
+		MWIFIEX_SKB_PACB(skb_tmp, &buf_pa);
+		pci_unmap_single(card->dev, buf_pa, MWIFIEX_UPLD_SIZE,
+				 PCI_DMA_FROMDEVICE);
+		card->cmd_buf = NULL;
 	}
 
 	return 0;
@@ -1168,6 +1230,10 @@ static int mwifiex_pcie_process_event_ready(struct mwifiex_adapter *adapter)
 	struct pcie_service_card *card = adapter->card;
 	u32 rdptr = card->evtbd_rdptr & MWIFIEX_EVTBD_MASK;
 	u32 wrptr, event;
+	dma_addr_t buf_pa;
+
+	if (!mwifiex_pcie_ok_to_access_hw(adapter))
+		mwifiex_pm_wakeup_card(adapter);
 
 	if (adapter->event_received) {
 		dev_dbg(adapter->dev, "info: Event being processed, "
@@ -1199,6 +1265,10 @@ static int mwifiex_pcie_process_event_ready(struct mwifiex_adapter *adapter)
 
 		dev_dbg(adapter->dev, "info: Read Index: %d\n", rdptr);
 		skb_cmd = card->evt_buf_list[rdptr];
+		MWIFIEX_SKB_PACB(skb_cmd, &buf_pa);
+		pci_unmap_single(card->dev, buf_pa, MAX_EVENT_SIZE,
+				 PCI_DMA_FROMDEVICE);
+
 		/* Take the pointer and set it to event pointer in adapter
 		   and will return back after event handling callback */
 		card->evt_buf_list[rdptr] = NULL;
@@ -1243,7 +1313,7 @@ static int mwifiex_pcie_event_complete(struct mwifiex_adapter *adapter,
 	int ret = 0;
 	u32 rdptr = card->evtbd_rdptr & MWIFIEX_EVTBD_MASK;
 	u32 wrptr;
-	phys_addr_t *buf_pa;
+	dma_addr_t buf_pa;
 
 	if (!skb)
 		return 0;
@@ -1263,9 +1333,14 @@ static int mwifiex_pcie_event_complete(struct mwifiex_adapter *adapter,
 
 	if (!card->evt_buf_list[rdptr]) {
 		skb_push(skb, INTF_HEADER_LEN);
+		if (mwifiex_map_pci_memory(adapter, skb,
+					   MAX_EVENT_SIZE,
+					   PCI_DMA_FROMDEVICE))
+			return -1;
+		MWIFIEX_SKB_PACB(skb, &buf_pa);
 		card->evt_buf_list[rdptr] = skb;
-		buf_pa = MWIFIEX_SKB_PACB(skb);
-		card->evtbd_ring[rdptr]->paddr = *buf_pa;
+		MWIFIEX_SKB_PACB(skb, &buf_pa);
+		card->evtbd_ring[rdptr]->paddr = buf_pa;
 		card->evtbd_ring[rdptr]->len = (u16)skb->len;
 		card->evtbd_ring[rdptr]->flags = 0;
 		skb = NULL;
@@ -1314,11 +1389,8 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 	struct sk_buff *skb;
 	u32 txlen, tx_blocks = 0, tries, len;
 	u32 block_retry_cnt = 0;
-
-	if (!adapter) {
-		pr_err("adapter structure is not valid\n");
-		return -1;
-	}
+	dma_addr_t buf_pa;
+	struct pcie_service_card *card = adapter->card;
 
 	if (!firmware || !firmware_len) {
 		dev_err(adapter->dev,
@@ -1340,7 +1412,6 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 		ret = -ENOMEM;
 		goto done;
 	}
-	mwifiex_update_sk_buff_pa(skb);
 
 	/* Perform firmware data transfer */
 	do {
@@ -1415,6 +1486,9 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 			ret = -1;
 			goto done;
 		}
+
+		MWIFIEX_SKB_PACB(skb, &buf_pa);
+
 		/* Wait for the command done interrupt */
 		do {
 			if (mwifiex_read_reg(adapter, PCIE_CPU_INT_STATUS,
@@ -1422,11 +1496,17 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 				dev_err(adapter->dev, "%s: Failed to read "
 					"interrupt status during fw dnld.\n",
 					__func__);
+				pci_unmap_single(card->dev, buf_pa, skb->len,
+						 PCI_DMA_TODEVICE);
 				ret = -1;
 				goto done;
 			}
 		} while ((ireg_intr & CPU_INTR_DOOR_BELL) ==
 			 CPU_INTR_DOOR_BELL);
+
+		pci_unmap_single(card->dev, buf_pa, skb->len,
+				 PCI_DMA_TODEVICE);
+
 		offset += txlen;
 	} while (true);
 
@@ -1828,15 +1908,8 @@ static void mwifiex_pcie_cleanup(struct mwifiex_adapter *adapter)
 	struct pcie_service_card *card = adapter->card;
 	struct pci_dev *pdev = card->dev;
 
-	mwifiex_pcie_delete_sleep_cookie_buf(adapter);
-	mwifiex_pcie_delete_cmdrsp_buf(adapter);
-	mwifiex_pcie_delete_evtbd_ring(adapter);
-	mwifiex_pcie_delete_rxbd_ring(adapter);
-	mwifiex_pcie_delete_txbd_ring(adapter);
-	card->cmdrsp_buf = NULL;
-
-	dev_dbg(adapter->dev, "Clearing driver ready signature\n");
 	if (user_rmmod) {
+		dev_dbg(adapter->dev, "Clearing driver ready signature\n");
 		if (mwifiex_write_reg(adapter, REG_DRV_READY, 0x00000000))
 			dev_err(adapter->dev,
 				"Failed to write driver not-ready signature\n");
@@ -1893,6 +1966,13 @@ static void mwifiex_unregister_dev(struct mwifiex_adapter *adapter)
 	if (card) {
 		dev_dbg(adapter->dev, "%s(): calling free_irq()\n", __func__);
 		free_irq(card->dev->irq, card->dev);
+
+		mwifiex_pcie_delete_sleep_cookie_buf(adapter);
+		mwifiex_pcie_delete_cmdrsp_buf(adapter);
+		mwifiex_pcie_delete_evtbd_ring(adapter);
+		mwifiex_pcie_delete_rxbd_ring(adapter);
+		mwifiex_pcie_delete_txbd_ring(adapter);
+		card->cmdrsp_buf = NULL;
 	}
 }
 
diff --git a/drivers/net/wireless/mwifiex/pcie.h b/drivers/net/wireless/mwifiex/pcie.h
index 2f218f9..87201f5 100644
--- a/drivers/net/wireless/mwifiex/pcie.h
+++ b/drivers/net/wireless/mwifiex/pcie.h
@@ -118,7 +118,7 @@ struct pcie_service_card {
 	u32 txbd_rdptr;
 	u32 txbd_ring_size;
 	u8 *txbd_ring_vbase;
-	phys_addr_t txbd_ring_pbase;
+	dma_addr_t txbd_ring_pbase;
 	struct mwifiex_pcie_buf_desc *txbd_ring[MWIFIEX_MAX_TXRX_BD];
 	struct sk_buff *tx_buf_list[MWIFIEX_MAX_TXRX_BD];
 
@@ -126,7 +126,7 @@ struct pcie_service_card {
 	u32 rxbd_rdptr;
 	u32 rxbd_ring_size;
 	u8 *rxbd_ring_vbase;
-	phys_addr_t rxbd_ring_pbase;
+	dma_addr_t rxbd_ring_pbase;
 	struct mwifiex_pcie_buf_desc *rxbd_ring[MWIFIEX_MAX_TXRX_BD];
 	struct sk_buff *rx_buf_list[MWIFIEX_MAX_TXRX_BD];
 
@@ -134,13 +134,14 @@ struct pcie_service_card {
 	u32 evtbd_rdptr;
 	u32 evtbd_ring_size;
 	u8 *evtbd_ring_vbase;
-	phys_addr_t evtbd_ring_pbase;
+	dma_addr_t evtbd_ring_pbase;
 	struct mwifiex_pcie_buf_desc *evtbd_ring[MWIFIEX_MAX_EVT_BD];
 	struct sk_buff *evt_buf_list[MWIFIEX_MAX_EVT_BD];
 
 	struct sk_buff *cmd_buf;
 	struct sk_buff *cmdrsp_buf;
-	struct sk_buff *sleep_cookie;
+	u8 *sleep_cookie_vbase;
+	dma_addr_t sleep_cookie_pbase;
 	void __iomem *pci_mmap;
 	void __iomem *pci_mmap1;
 };
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 5d87195..c460785 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -931,7 +931,6 @@ mwifiex_cmd_pcie_host_spec(struct mwifiex_private *priv,
 	struct host_cmd_ds_pcie_details *host_spec =
 					&cmd->params.pcie_host_spec;
 	struct pcie_service_card *card = priv->adapter->card;
-	phys_addr_t *buf_pa;
 
 	cmd->command = cpu_to_le16(HostCmd_CMD_PCIE_DESC_DETAILS);
 	cmd->size = cpu_to_le16(sizeof(struct
@@ -953,10 +952,11 @@ mwifiex_cmd_pcie_host_spec(struct mwifiex_private *priv,
 	host_spec->evtbd_addr_lo = (u32)(card->evtbd_ring_pbase);
 	host_spec->evtbd_addr_hi = (u32)(((u64)card->evtbd_ring_pbase)>>32);
 	host_spec->evtbd_count = MWIFIEX_MAX_EVT_BD;
-	if (card->sleep_cookie) {
-		buf_pa = MWIFIEX_SKB_PACB(card->sleep_cookie);
-		host_spec->sleep_cookie_addr_lo = (u32) *buf_pa;
-		host_spec->sleep_cookie_addr_hi = (u32) (((u64)*buf_pa) >> 32);
+	if (card->sleep_cookie_vbase) {
+		host_spec->sleep_cookie_addr_lo =
+						(u32)(card->sleep_cookie_pbase);
+		host_spec->sleep_cookie_addr_hi =
+				 (u32)(((u64)(card->sleep_cookie_pbase)) >> 32);
 		dev_dbg(priv->adapter->dev, "sleep_cook_lo phy addr: 0x%x\n",
 			host_spec->sleep_cookie_addr_lo);
 	}
diff --git a/drivers/net/wireless/mwifiex/util.h b/drivers/net/wireless/mwifiex/util.h
index f6d36b9..cb2d058 100644
--- a/drivers/net/wireless/mwifiex/util.h
+++ b/drivers/net/wireless/mwifiex/util.h
@@ -22,16 +22,16 @@
 
 static inline struct mwifiex_rxinfo *MWIFIEX_SKB_RXCB(struct sk_buff *skb)
 {
-	return (struct mwifiex_rxinfo *)(skb->cb + sizeof(phys_addr_t));
+	return (struct mwifiex_rxinfo *)(skb->cb + sizeof(dma_addr_t));
 }
 
 static inline struct mwifiex_txinfo *MWIFIEX_SKB_TXCB(struct sk_buff *skb)
 {
-	return (struct mwifiex_txinfo *)(skb->cb + sizeof(phys_addr_t));
+	return (struct mwifiex_txinfo *)(skb->cb + sizeof(dma_addr_t));
 }
 
-static inline phys_addr_t *MWIFIEX_SKB_PACB(struct sk_buff *skb)
+static inline void MWIFIEX_SKB_PACB(struct sk_buff *skb, dma_addr_t *buf_pa)
 {
-	return (phys_addr_t *)skb->cb;
+	memcpy(buf_pa, skb->cb, sizeof(dma_addr_t));
 }
 #endif /* !_MWIFIEX_UTIL_H_ */
-- 
1.7.0.2

