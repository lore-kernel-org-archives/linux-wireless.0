Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:54891 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760542Ab3BICXE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 21:23:04 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 4/4] mwifiex: add PCIe8897 support
Date: Fri,  8 Feb 2013 18:18:09 -0800
Message-Id: <1360376289-14861-5-git-send-email-bzhao@marvell.com> (sfid-20130209_032731_296645_017F3260)
In-Reply-To: <1360376289-14861-1-git-send-email-bzhao@marvell.com>
References: <1360376289-14861-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch adds PCIe8897 support to mwifiex.
In PCIe8897 PFU (pre-fetch unit) is enabled by default.
This patch adds support to accommodate this feaure as well.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Frank Huang <frankh@marvell.com>
---
 drivers/net/wireless/mwifiex/Kconfig |    4 +-
 drivers/net/wireless/mwifiex/pcie.c  |  242 +++++++++++++++++++++++++---------
 drivers/net/wireless/mwifiex/pcie.h  |   99 +++++++++++++-
 3 files changed, 275 insertions(+), 70 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/Kconfig b/drivers/net/wireless/mwifiex/Kconfig
index b2e2772..4f614aa 100644
--- a/drivers/net/wireless/mwifiex/Kconfig
+++ b/drivers/net/wireless/mwifiex/Kconfig
@@ -20,12 +20,12 @@ config MWIFIEX_SDIO
 	  mwifiex_sdio.
 
 config MWIFIEX_PCIE
-	tristate "Marvell WiFi-Ex Driver for PCIE 8766"
+	tristate "Marvell WiFi-Ex Driver for PCIE 8766/8897"
 	depends on MWIFIEX && PCI
 	select FW_LOADER
 	---help---
 	  This adds support for wireless adapters based on Marvell
-	  8766 chipset with PCIe interface.
+	  8766/8897 chipsets with PCIe interface.
 
 	  If you choose to build it as a module, it will be called
 	  mwifiex_pcie.
diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 6c15969..3b9be7c 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -237,15 +237,17 @@ static int mwifiex_pcie_resume(struct pci_dev *pdev)
 	return 0;
 }
 
-#define PCIE_VENDOR_ID_MARVELL              (0x11ab)
-#define PCIE_DEVICE_ID_MARVELL_88W8766P		(0x2b30)
-
 static DEFINE_PCI_DEVICE_TABLE(mwifiex_ids) = {
 	{
 		PCIE_VENDOR_ID_MARVELL, PCIE_DEVICE_ID_MARVELL_88W8766P,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		.driver_data = (unsigned long) &mwifiex_pcie8766,
 	},
+	{
+		PCIE_VENDOR_ID_MARVELL, PCIE_DEVICE_ID_MARVELL_88W8897,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		.driver_data = (unsigned long) &mwifiex_pcie8897,
+	},
 	{},
 };
 
@@ -377,15 +379,24 @@ static int mwifiex_pcie_enable_host_int(struct mwifiex_adapter *adapter)
 static int mwifiex_init_txq_ring(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
+	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 	struct mwifiex_pcie_buf_desc *desc;
+	struct mwifiex_pfu_buf_desc *desc2;
 	int i;
 
 	for (i = 0; i < MWIFIEX_MAX_TXRX_BD; i++) {
 		card->tx_buf_list[i] = NULL;
-		card->txbd_ring[i] = (void *)(card->txbd_ring_vbase +
-				     (sizeof(*desc) * i));
-		desc = card->txbd_ring[i];
-		memset(desc, 0, sizeof(*desc));
+		if (reg->pfu_enabled) {
+			card->txbd_ring[i] = (void *)card->txbd_ring_vbase +
+					     (sizeof(*desc2) * i);
+			desc2 = card->txbd_ring[i];
+			memset(desc2, 0, sizeof(*desc2));
+		} else {
+			card->txbd_ring[i] = (void *)card->txbd_ring_vbase +
+					     (sizeof(*desc) * i);
+			desc = card->txbd_ring[i];
+			memset(desc, 0, sizeof(*desc));
+		}
 	}
 
 	return 0;
@@ -398,8 +409,10 @@ static int mwifiex_init_txq_ring(struct mwifiex_adapter *adapter)
 static int mwifiex_init_rxq_ring(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
+	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 	struct sk_buff *skb;
 	struct mwifiex_pcie_buf_desc *desc;
+	struct mwifiex_pfu_buf_desc *desc2;
 	dma_addr_t buf_pa;
 	int i;
 
@@ -426,12 +439,23 @@ static int mwifiex_init_rxq_ring(struct mwifiex_adapter *adapter)
 			(u32)((u64)buf_pa >> 32));
 
 		card->rx_buf_list[i] = skb;
-		card->rxbd_ring[i] = (void *)(card->rxbd_ring_vbase +
-				     (sizeof(*desc) * i));
-		desc = card->rxbd_ring[i];
-		desc->paddr = buf_pa;
-		desc->len = (u16)skb->len;
-		desc->flags = 0;
+		if (reg->pfu_enabled) {
+			card->rxbd_ring[i] = (void *)card->rxbd_ring_vbase +
+					     (sizeof(*desc2) * i);
+			desc2 = card->rxbd_ring[i];
+			desc2->paddr = buf_pa;
+			desc2->len = (u16)skb->len;
+			desc2->frag_len = (u16)skb->len;
+			desc2->flags = reg->ring_flag_eop | reg->ring_flag_sop;
+			desc2->offset = 0;
+		} else {
+			card->rxbd_ring[i] = (void *)(card->rxbd_ring_vbase +
+					     (sizeof(*desc) * i));
+			desc = card->rxbd_ring[i];
+			desc->paddr = buf_pa;
+			desc->len = (u16)skb->len;
+			desc->flags = 0;
+		}
 	}
 
 	return 0;
@@ -489,20 +513,33 @@ static int mwifiex_pcie_init_evt_ring(struct mwifiex_adapter *adapter)
 static void mwifiex_cleanup_txq_ring(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
+	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 	struct sk_buff *skb;
 	struct mwifiex_pcie_buf_desc *desc;
+	struct mwifiex_pfu_buf_desc *desc2;
 	int i;
 
 	for (i = 0; i < MWIFIEX_MAX_TXRX_BD; i++) {
-		desc = card->txbd_ring[i];
-		if (card->tx_buf_list[i]) {
-			skb = card->tx_buf_list[i];
-			pci_unmap_single(card->dev, desc->paddr, skb->len,
-					 PCI_DMA_TODEVICE);
-			dev_kfree_skb_any(skb);
+		if (reg->pfu_enabled) {
+			desc2 = card->txbd_ring[i];
+			if (card->tx_buf_list[i]) {
+				skb = card->tx_buf_list[i];
+				pci_unmap_single(card->dev, desc2->paddr,
+						 skb->len, PCI_DMA_TODEVICE);
+				dev_kfree_skb_any(skb);
+			}
+			memset(desc2, 0, sizeof(*desc2));
+		} else {
+			desc = card->txbd_ring[i];
+			if (card->tx_buf_list[i]) {
+				skb = card->tx_buf_list[i];
+				pci_unmap_single(card->dev, desc->paddr,
+						 skb->len, PCI_DMA_TODEVICE);
+				dev_kfree_skb_any(skb);
+			}
+			memset(desc, 0, sizeof(*desc));
 		}
 		card->tx_buf_list[i] = NULL;
-		memset(desc, 0, sizeof(*desc));
 	}
 
 	return;
@@ -514,20 +551,33 @@ static void mwifiex_cleanup_txq_ring(struct mwifiex_adapter *adapter)
 static void mwifiex_cleanup_rxq_ring(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
+	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 	struct mwifiex_pcie_buf_desc *desc;
+	struct mwifiex_pfu_buf_desc *desc2;
 	struct sk_buff *skb;
 	int i;
 
 	for (i = 0; i < MWIFIEX_MAX_TXRX_BD; i++) {
-		desc = card->rxbd_ring[i];
-		if (card->rx_buf_list[i]) {
-			skb = card->rx_buf_list[i];
-			pci_unmap_single(card->dev, desc->paddr,
-					 MWIFIEX_RX_DATA_BUF_SIZE,
-					 PCI_DMA_FROMDEVICE);
-			dev_kfree_skb_any(skb);
+		if (reg->pfu_enabled) {
+			desc2 = card->rxbd_ring[i];
+			if (card->rx_buf_list[i]) {
+				skb = card->rx_buf_list[i];
+				pci_unmap_single(card->dev, desc2->paddr,
+						 skb->len, PCI_DMA_TODEVICE);
+				dev_kfree_skb_any(skb);
+			}
+			memset(desc2, 0, sizeof(*desc2));
+		} else {
+			desc = card->rxbd_ring[i];
+			if (card->rx_buf_list[i]) {
+				skb = card->rx_buf_list[i];
+				pci_unmap_single(card->dev, desc->paddr,
+						 skb->len, PCI_DMA_TODEVICE);
+				dev_kfree_skb_any(skb);
+			}
+			memset(desc, 0, sizeof(*desc));
 		}
-		memset(desc, 0, sizeof(*desc));
+		card->rx_buf_list[i] = NULL;
 	}
 
 	return;
@@ -571,12 +621,21 @@ static int mwifiex_pcie_create_txbd_ring(struct mwifiex_adapter *adapter)
 	 * starts at zero with rollover bit set
 	 */
 	card->txbd_wrptr = 0;
-	card->txbd_rdptr |= reg->tx_rollover_ind;
+
+	if (reg->pfu_enabled)
+		card->txbd_rdptr = 0;
+	else
+		card->txbd_rdptr |= reg->tx_rollover_ind;
 
 	/* allocate shared memory for the BD ring and divide the same in to
 	   several descriptors */
-	card->txbd_ring_size = sizeof(struct mwifiex_pcie_buf_desc) *
-							MWIFIEX_MAX_TXRX_BD;
+	if (reg->pfu_enabled)
+		card->txbd_ring_size = sizeof(struct mwifiex_pfu_buf_desc) *
+				       MWIFIEX_MAX_TXRX_BD;
+	else
+		card->txbd_ring_size = sizeof(struct mwifiex_pcie_buf_desc) *
+				       MWIFIEX_MAX_TXRX_BD;
+
 	dev_dbg(adapter->dev, "info: txbd_ring: Allocating %d bytes\n",
 		card->txbd_ring_size);
 	card->txbd_ring_vbase = pci_alloc_consistent(card->dev,
@@ -632,8 +691,13 @@ static int mwifiex_pcie_create_rxbd_ring(struct mwifiex_adapter *adapter)
 	card->rxbd_wrptr = 0;
 	card->rxbd_rdptr = reg->rx_rollover_ind;
 
-	card->rxbd_ring_size = sizeof(struct mwifiex_pcie_buf_desc) *
-							MWIFIEX_MAX_TXRX_BD;
+	if (reg->pfu_enabled)
+		card->rxbd_ring_size = sizeof(struct mwifiex_pfu_buf_desc) *
+				       MWIFIEX_MAX_TXRX_BD;
+	else
+		card->rxbd_ring_size = sizeof(struct mwifiex_pcie_buf_desc) *
+				       MWIFIEX_MAX_TXRX_BD;
+
 	dev_dbg(adapter->dev, "info: rxbd_ring: Allocating %d bytes\n",
 		card->rxbd_ring_size);
 	card->rxbd_ring_vbase = pci_alloc_consistent(card->dev,
@@ -695,7 +759,8 @@ static int mwifiex_pcie_create_evtbd_ring(struct mwifiex_adapter *adapter)
 	card->evtbd_rdptr = reg->evt_rollover_ind;
 
 	card->evtbd_ring_size = sizeof(struct mwifiex_evt_buf_desc) *
-							MWIFIEX_MAX_EVT_BD;
+				MWIFIEX_MAX_EVT_BD;
+
 	dev_dbg(adapter->dev, "info: evtbd_ring: Allocating %d bytes\n",
 		card->evtbd_ring_size);
 	card->evtbd_ring_vbase = pci_alloc_consistent(card->dev,
@@ -875,11 +940,11 @@ static int mwifiex_clean_pcie_ring_buf(struct mwifiex_adapter *adapter)
  */
 static int mwifiex_pcie_send_data_complete(struct mwifiex_adapter *adapter)
 {
-	const u32 num_tx_buffs = MWIFIEX_MAX_TXRX_BD;
 	struct sk_buff *skb;
 	dma_addr_t buf_pa;
-	u32 wrdoneidx, rdptr, unmap_count = 0;
+	u32 wrdoneidx, rdptr, num_tx_buffs, unmap_count = 0;
 	struct mwifiex_pcie_buf_desc *desc;
+	struct mwifiex_pfu_buf_desc *desc2;
 	struct pcie_service_card *card = adapter->card;
 	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 
@@ -896,12 +961,14 @@ static int mwifiex_pcie_send_data_complete(struct mwifiex_adapter *adapter)
 	dev_dbg(adapter->dev, "SEND COMP: rdptr_prev=0x%x, rdptr=0x%x\n",
 		card->txbd_rdptr, rdptr);
 
+	num_tx_buffs = MWIFIEX_MAX_TXRX_BD << reg->tx_start_ptr;
 	/* free from previous txbd_rdptr to current txbd_rdptr */
 	while (((card->txbd_rdptr & reg->tx_mask) !=
 		(rdptr & reg->tx_mask)) ||
 	       ((card->txbd_rdptr & reg->tx_rollover_ind) !=
 		(rdptr & reg->tx_rollover_ind))) {
-		wrdoneidx = card->txbd_rdptr & reg->tx_mask;
+		wrdoneidx = (card->txbd_rdptr & reg->tx_mask) >>
+			    reg->tx_start_ptr;
 
 		skb = card->tx_buf_list[wrdoneidx];
 		if (skb) {
@@ -922,9 +989,23 @@ static int mwifiex_pcie_send_data_complete(struct mwifiex_adapter *adapter)
 		}
 
 		card->tx_buf_list[wrdoneidx] = NULL;
-		desc = card->txbd_ring[wrdoneidx];
-		memset(desc, 0, sizeof(*desc));
-		card->txbd_rdptr++;
+
+		if (reg->pfu_enabled) {
+			desc2 = (void *)card->txbd_ring[wrdoneidx];
+			memset(desc2, 0, sizeof(*desc2));
+		} else {
+			desc = card->txbd_ring[wrdoneidx];
+			memset(desc, 0, sizeof(*desc));
+		}
+		switch (card->dev->device) {
+		case PCIE_DEVICE_ID_MARVELL_88W8766P:
+			card->txbd_rdptr++;
+			break;
+		case PCIE_DEVICE_ID_MARVELL_88W8897:
+			card->txbd_rdptr += reg->ring_tx_start_ptr;
+			break;
+		}
+
 
 		if ((card->txbd_rdptr & reg->tx_mask) == num_tx_buffs)
 			card->txbd_rdptr = ((card->txbd_rdptr &
@@ -960,10 +1041,11 @@ mwifiex_pcie_send_data(struct mwifiex_adapter *adapter, struct sk_buff *skb,
 {
 	struct pcie_service_card *card = adapter->card;
 	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
-	u32 wrindx;
+	u32 wrindx, num_tx_buffs, rx_val;
 	int ret;
 	dma_addr_t buf_pa;
 	struct mwifiex_pcie_buf_desc *desc;
+	struct mwifiex_pfu_buf_desc *desc2;
 	__le16 *tmp;
 
 	if (!(skb->data && skb->len)) {
@@ -975,6 +1057,7 @@ mwifiex_pcie_send_data(struct mwifiex_adapter *adapter, struct sk_buff *skb,
 	if (!mwifiex_pcie_ok_to_access_hw(adapter))
 		mwifiex_pm_wakeup_card(adapter);
 
+	num_tx_buffs = MWIFIEX_MAX_TXRX_BD << reg->tx_start_ptr;
 	dev_dbg(adapter->dev, "info: SEND DATA: <Rd: %#x, Wr: %#x>\n",
 		card->txbd_rdptr, card->txbd_wrptr);
 	if (mwifiex_pcie_txbd_not_full(card)) {
@@ -991,24 +1074,44 @@ mwifiex_pcie_send_data(struct mwifiex_adapter *adapter, struct sk_buff *skb,
 					   PCI_DMA_TODEVICE))
 			return -1;
 
-		wrindx = card->txbd_wrptr & reg->tx_mask;
+		wrindx = (card->txbd_wrptr & reg->tx_mask) >> reg->tx_start_ptr;
 		MWIFIEX_SKB_PACB(skb, &buf_pa);
 		card->tx_buf_list[wrindx] = skb;
-		desc = card->txbd_ring[wrindx];
-		desc->paddr = buf_pa;
-		desc->len = (u16)skb->len;
-		desc->flags = MWIFIEX_BD_FLAG_FIRST_DESC |
-			      MWIFIEX_BD_FLAG_LAST_DESC;
 
-		if ((++card->txbd_wrptr & reg->tx_mask) ==
-							MWIFIEX_MAX_TXRX_BD)
+		if (reg->pfu_enabled) {
+			desc2 = (void *)card->txbd_ring[wrindx];
+			desc2->paddr = buf_pa;
+			desc2->len = (u16)skb->len;
+			desc2->frag_len = (u16)skb->len;
+			desc2->offset = 0;
+			desc2->flags = MWIFIEX_BD_FLAG_FIRST_DESC |
+					 MWIFIEX_BD_FLAG_LAST_DESC;
+		} else {
+			desc = card->txbd_ring[wrindx];
+			desc->paddr = buf_pa;
+			desc->len = (u16)skb->len;
+			desc->flags = MWIFIEX_BD_FLAG_FIRST_DESC |
+				      MWIFIEX_BD_FLAG_LAST_DESC;
+		}
+
+		switch (card->dev->device) {
+		case PCIE_DEVICE_ID_MARVELL_88W8766P:
+			card->txbd_wrptr++;
+			break;
+		case PCIE_DEVICE_ID_MARVELL_88W8897:
+			card->txbd_wrptr += reg->ring_tx_start_ptr;
+			break;
+		}
+
+		if ((card->txbd_wrptr & reg->tx_mask) == num_tx_buffs)
 			card->txbd_wrptr = ((card->txbd_wrptr &
 						reg->tx_rollover_ind) ^
 						reg->tx_rollover_ind);
 
+		rx_val = card->rxbd_rdptr & reg->rx_wrap_mask;
 		/* Write the TX ring write pointer in to reg->tx_wrptr */
 		if (mwifiex_write_reg(adapter, reg->tx_wrptr,
-				      card->txbd_wrptr)) {
+				      card->txbd_wrptr | rx_val)) {
 			dev_err(adapter->dev,
 				"SEND DATA: failed to write reg->tx_wrptr\n");
 			ret = -1;
@@ -1050,7 +1153,11 @@ done_unmap:
 	MWIFIEX_SKB_PACB(skb, &buf_pa);
 	pci_unmap_single(card->dev, buf_pa, skb->len, PCI_DMA_TODEVICE);
 	card->tx_buf_list[wrindx] = NULL;
-	memset(desc, 0, sizeof(*desc));
+	if (reg->pfu_enabled)
+		memset(desc2, 0, sizeof(*desc2));
+	else
+		memset(desc, 0, sizeof(*desc));
+
 	return ret;
 }
 
@@ -1062,11 +1169,12 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
 	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
-	u32 wrptr, rd_index;
+	u32 wrptr, rd_index, tx_val;
 	dma_addr_t buf_pa;
 	int ret = 0;
 	struct sk_buff *skb_tmp = NULL;
 	struct mwifiex_pcie_buf_desc *desc;
+	struct mwifiex_pfu_buf_desc *desc2;
 
 	if (!mwifiex_pcie_ok_to_access_hw(adapter))
 		mwifiex_pm_wakeup_card(adapter);
@@ -1126,10 +1234,20 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
 			"RECV DATA: Attach new sk_buff %p at rxbd_rdidx=%d\n",
 			skb_tmp, rd_index);
 		card->rx_buf_list[rd_index] = skb_tmp;
-		desc = card->rxbd_ring[rd_index];
-		desc->paddr = buf_pa;
-		desc->len = skb_tmp->len;
-		desc->flags = 0;
+
+		if (reg->pfu_enabled) {
+			desc2 = (void *)card->rxbd_ring[rd_index];
+			desc2->paddr = buf_pa;
+			desc2->len = skb_tmp->len;
+			desc2->frag_len = skb_tmp->len;
+			desc2->offset = 0;
+			desc2->flags = reg->ring_flag_sop | reg->ring_flag_eop;
+		} else {
+			desc = card->rxbd_ring[rd_index];
+			desc->paddr = buf_pa;
+			desc->len = skb_tmp->len;
+			desc->flags = 0;
+		}
 
 		if ((++card->rxbd_rdptr & reg->rx_mask) ==
 							MWIFIEX_MAX_TXRX_BD) {
@@ -1140,9 +1258,10 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
 		dev_dbg(adapter->dev, "info: RECV DATA: <Rd: %#x, Wr: %#x>\n",
 			card->rxbd_rdptr, wrptr);
 
+		tx_val = card->txbd_wrptr & reg->tx_wrap_mask;
 		/* Write the RX ring read pointer in to reg->rx_rdptr */
 		if (mwifiex_write_reg(adapter, reg->rx_rdptr,
-				      card->rxbd_rdptr)) {
+				      card->rxbd_rdptr | tx_val)) {
 			dev_err(adapter->dev,
 				"RECV DATA: failed to write reg->rx_rdptr\n");
 			ret = -1;
@@ -1242,9 +1361,11 @@ static int mwifiex_pcie_init_fw_port(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
 	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
+	int tx_wrap = card->txbd_wrptr & reg->tx_wrap_mask;
 
 	/* Write the RX ring read pointer in to reg->rx_rdptr */
-	if (mwifiex_write_reg(adapter, reg->rx_rdptr, card->rxbd_rdptr)) {
+	if (mwifiex_write_reg(adapter, reg->rx_rdptr, card->rxbd_rdptr |
+			      tx_wrap)) {
 		dev_err(adapter->dev,
 			"RECV DATA: failed to write reg->rx_rdptr\n");
 		return -1;
@@ -2259,7 +2380,7 @@ static int mwifiex_pcie_init_module(void)
 {
 	int ret;
 
-	pr_debug("Marvell 8766 PCIe Driver\n");
+	pr_debug("Marvell PCIe Driver\n");
 
 	sema_init(&add_remove_card_sem, 1);
 
@@ -2302,4 +2423,5 @@ MODULE_AUTHOR("Marvell International Ltd.");
 MODULE_DESCRIPTION("Marvell WiFi-Ex PCI-Express Driver version " PCIE_VERSION);
 MODULE_VERSION(PCIE_VERSION);
 MODULE_LICENSE("GPL v2");
-MODULE_FIRMWARE("mrvl/pcie8766_uapsta.bin");
+MODULE_FIRMWARE(PCIE8766_DEFAULT_FW_NAME);
+MODULE_FIRMWARE(PCIE8897_DEFAULT_FW_NAME);
diff --git a/drivers/net/wireless/mwifiex/pcie.h b/drivers/net/wireless/mwifiex/pcie.h
index 7ebdc74..6080615 100644
--- a/drivers/net/wireless/mwifiex/pcie.h
+++ b/drivers/net/wireless/mwifiex/pcie.h
@@ -29,6 +29,11 @@
 #include    "main.h"
 
 #define PCIE8766_DEFAULT_FW_NAME "mrvl/pcie8766_uapsta.bin"
+#define PCIE8897_DEFAULT_FW_NAME "mrvl/pcie8897_uapsta.bin"
+
+#define PCIE_VENDOR_ID_MARVELL              (0x11ab)
+#define PCIE_DEVICE_ID_MARVELL_88W8766P		(0x2b30)
+#define PCIE_DEVICE_ID_MARVELL_88W8897		(0x2b38)
 
 /* Constants for Buffer Descriptor (BD) rings */
 #define MWIFIEX_MAX_TXRX_BD			0x20
@@ -57,6 +62,8 @@
 #define PCIE_SCRATCH_10_REG				0xCE8
 #define PCIE_SCRATCH_11_REG				0xCEC
 #define PCIE_SCRATCH_12_REG				0xCF0
+#define PCIE_RD_DATA_PTR_Q0_Q1                          0xC08C
+#define PCIE_WR_DATA_PTR_Q0_Q1                          0xC05C
 
 #define CPU_INTR_DNLD_RDY				BIT(0)
 #define CPU_INTR_DOOR_BELL				BIT(1)
@@ -75,6 +82,14 @@
 #define MWIFIEX_BD_FLAG_ROLLOVER_IND			BIT(7)
 #define MWIFIEX_BD_FLAG_FIRST_DESC			BIT(0)
 #define MWIFIEX_BD_FLAG_LAST_DESC			BIT(1)
+#define MWIFIEX_BD_FLAG_SOP				BIT(0)
+#define MWIFIEX_BD_FLAG_EOP				BIT(1)
+#define MWIFIEX_BD_FLAG_XS_SOP				BIT(2)
+#define MWIFIEX_BD_FLAG_XS_EOP				BIT(3)
+#define MWIFIEX_BD_FLAG_EVT_ROLLOVER_IND		BIT(7)
+#define MWIFIEX_BD_FLAG_RX_ROLLOVER_IND			BIT(10)
+#define MWIFIEX_BD_FLAG_TX_START_PTR			BIT(16)
+#define MWIFIEX_BD_FLAG_TX_ROLLOVER_IND			BIT(26)
 
 /* Max retry number of command write */
 #define MAX_WRITE_IOMEM_RETRY				2
@@ -143,6 +158,36 @@ static const struct mwifiex_pcie_card_reg mwifiex_reg_8766 = {
 	.pfu_enabled = 0,
 };
 
+static const struct mwifiex_pcie_card_reg mwifiex_reg_8897 = {
+	.cmd_addr_lo = PCIE_SCRATCH_0_REG,
+	.cmd_addr_hi = PCIE_SCRATCH_1_REG,
+	.cmd_size = PCIE_SCRATCH_2_REG,
+	.fw_status = PCIE_SCRATCH_3_REG,
+	.cmdrsp_addr_lo = PCIE_SCRATCH_4_REG,
+	.cmdrsp_addr_hi = PCIE_SCRATCH_5_REG,
+	.tx_rdptr = PCIE_RD_DATA_PTR_Q0_Q1,
+	.tx_wrptr = PCIE_WR_DATA_PTR_Q0_Q1,
+	.rx_rdptr = PCIE_WR_DATA_PTR_Q0_Q1,
+	.rx_wrptr = PCIE_RD_DATA_PTR_Q0_Q1,
+	.evt_rdptr = PCIE_SCRATCH_10_REG,
+	.evt_wrptr = PCIE_SCRATCH_11_REG,
+	.drv_rdy = PCIE_SCRATCH_12_REG,
+	.tx_start_ptr = 16,
+	.tx_mask = 0x03FF0000,
+	.tx_wrap_mask = 0x07FF0000,
+	.rx_mask = 0x000003FF,
+	.rx_wrap_mask = 0x000007FF,
+	.tx_rollover_ind = MWIFIEX_BD_FLAG_TX_ROLLOVER_IND,
+	.rx_rollover_ind = MWIFIEX_BD_FLAG_RX_ROLLOVER_IND,
+	.evt_rollover_ind = MWIFIEX_BD_FLAG_EVT_ROLLOVER_IND,
+	.ring_flag_sop = MWIFIEX_BD_FLAG_SOP,
+	.ring_flag_eop = MWIFIEX_BD_FLAG_EOP,
+	.ring_flag_xs_sop = MWIFIEX_BD_FLAG_XS_SOP,
+	.ring_flag_xs_eop = MWIFIEX_BD_FLAG_XS_EOP,
+	.ring_tx_start_ptr = MWIFIEX_BD_FLAG_TX_START_PTR,
+	.pfu_enabled = 1,
+};
+
 struct mwifiex_pcie_device {
 	const char *firmware;
 	const struct mwifiex_pcie_card_reg *reg;
@@ -155,6 +200,12 @@ static const struct mwifiex_pcie_device mwifiex_pcie8766 = {
 	.blksz_fw_dl = MWIFIEX_PCIE_BLOCK_SIZE_FW_DNLD,
 };
 
+static const struct mwifiex_pcie_device mwifiex_pcie8897 = {
+	.firmware       = PCIE8897_DEFAULT_FW_NAME,
+	.reg            = &mwifiex_reg_8897,
+	.blksz_fw_dl = MWIFIEX_PCIE_BLOCK_SIZE_FW_DNLD,
+};
+
 struct mwifiex_evt_buf_desc {
 	u64 paddr;
 	u16 len;
@@ -167,6 +218,15 @@ struct mwifiex_pcie_buf_desc {
 	u16 flags;
 } __packed;
 
+struct mwifiex_pfu_buf_desc {
+	u16 flags;
+	u16 offset;
+	u16 frag_len;
+	u16 len;
+	u64 paddr;
+	u32 reserved;
+} __packed;
+
 struct pcie_service_card {
 	struct pci_dev *dev;
 	struct mwifiex_adapter *adapter;
@@ -210,10 +270,22 @@ mwifiex_pcie_txbd_empty(struct pcie_service_card *card, u32 rdptr)
 {
 	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 
-	if (((card->txbd_wrptr & reg->tx_mask) == (rdptr & reg->tx_mask)) &&
-	    ((card->txbd_wrptr & reg->tx_rollover_ind) !=
+	switch (card->dev->device) {
+	case PCIE_DEVICE_ID_MARVELL_88W8766P:
+		if (((card->txbd_wrptr & reg->tx_mask) ==
+		     (rdptr & reg->tx_mask)) &&
+		    ((card->txbd_wrptr & reg->tx_rollover_ind) !=
+		     (rdptr & reg->tx_rollover_ind)))
+			return 1;
+		break;
+	case PCIE_DEVICE_ID_MARVELL_88W8897:
+		if (((card->txbd_wrptr & reg->tx_mask) ==
+		     (rdptr & reg->tx_mask)) &&
+		    ((card->txbd_wrptr & reg->tx_rollover_ind) ==
 			(rdptr & reg->tx_rollover_ind)))
-		return 1;
+			return 1;
+		break;
+	}
 
 	return 0;
 }
@@ -223,11 +295,22 @@ mwifiex_pcie_txbd_not_full(struct pcie_service_card *card)
 {
 	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 
-	if (((card->txbd_wrptr & reg->tx_mask) !=
-	     (card->txbd_rdptr & reg->tx_mask)) ||
-	    ((card->txbd_wrptr & reg->tx_rollover_ind) !=
-	     (card->txbd_rdptr & reg->tx_rollover_ind)))
-		return 1;
+	switch (card->dev->device) {
+	case PCIE_DEVICE_ID_MARVELL_88W8766P:
+		if (((card->txbd_wrptr & reg->tx_mask) !=
+		     (card->txbd_rdptr & reg->tx_mask)) ||
+		    ((card->txbd_wrptr & reg->tx_rollover_ind) !=
+		     (card->txbd_rdptr & reg->tx_rollover_ind)))
+			return 1;
+		break;
+	case PCIE_DEVICE_ID_MARVELL_88W8897:
+		if (((card->txbd_wrptr & reg->tx_mask) !=
+		     (card->txbd_rdptr & reg->tx_mask)) ||
+		    ((card->txbd_wrptr & reg->tx_rollover_ind) ==
+		     (card->txbd_rdptr & reg->tx_rollover_ind)))
+			return 1;
+		break;
+	}
 
 	return 0;
 }
-- 
1.7.0.2

