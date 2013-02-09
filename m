Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:50901 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760523Ab3BICWj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 21:22:39 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/4] mwifiex: store card specific data in PCI device table entry
Date: Fri,  8 Feb 2013 18:18:06 -0800
Message-Id: <1360376289-14861-2-git-send-email-bzhao@marvell.com> (sfid-20130209_032426_305053_0FAF1B2C)
In-Reply-To: <1360376289-14861-1-git-send-email-bzhao@marvell.com>
References: <1360376289-14861-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch adds support for storing PCIe device specific data
into driver_data structure of pci_device_id. When a device with
known device_id is probed, we use this driver_data to populate
card specific structres in driver.
This enables to remove device specific defines for scratch
registers, firmware name, FW download block size, etc. from
source code.

This will make addition of support for new chipsets a lot easier.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c |  211 ++++++++++++++++++++---------------
 drivers/net/wireless/mwifiex/pcie.h |  113 ++++++++++++++-----
 2 files changed, 206 insertions(+), 118 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index df88e65..29c539b 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -94,6 +94,13 @@ static int mwifiex_pcie_probe(struct pci_dev *pdev,
 
 	card->dev = pdev;
 
+	if (ent->driver_data) {
+		struct mwifiex_pcie_device *data = (void *)ent->driver_data;
+		card->pcie.firmware = data->firmware;
+		card->pcie.reg = data->reg;
+		card->pcie.blksz_fw_dl = data->blksz_fw_dl;
+	}
+
 	if (mwifiex_add_card(card, &add_remove_card_sem, &pcie_ops,
 			     MWIFIEX_PCIE)) {
 		pr_err("%s failed\n", __func__);
@@ -237,6 +244,7 @@ static DEFINE_PCI_DEVICE_TABLE(mwifiex_ids) = {
 	{
 		PCIE_VENDOR_ID_MARVELL, PCIE_DEVICE_ID_MARVELL_88W8766P,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		.driver_data = (unsigned long) &mwifiex_pcie8766,
 	},
 	{},
 };
@@ -369,6 +377,7 @@ static int mwifiex_pcie_enable_host_int(struct mwifiex_adapter *adapter)
 static int mwifiex_pcie_create_txbd_ring(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
+	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 	int i;
 
 	/*
@@ -377,7 +386,7 @@ static int mwifiex_pcie_create_txbd_ring(struct mwifiex_adapter *adapter)
 	 * starts at zero with rollover bit set
 	 */
 	card->txbd_wrptr = 0;
-	card->txbd_rdptr |= MWIFIEX_BD_FLAG_ROLLOVER_IND;
+	card->txbd_rdptr |= reg->tx_rollover_ind;
 
 	/* allocate shared memory for the BD ring and divide the same in to
 	   several descriptors */
@@ -417,6 +426,7 @@ static int mwifiex_pcie_create_txbd_ring(struct mwifiex_adapter *adapter)
 static int mwifiex_pcie_delete_txbd_ring(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
+	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 	struct sk_buff *skb;
 	int i;
 
@@ -440,7 +450,7 @@ static int mwifiex_pcie_delete_txbd_ring(struct mwifiex_adapter *adapter)
 				    card->txbd_ring_pbase);
 	card->txbd_ring_size = 0;
 	card->txbd_wrptr = 0;
-	card->txbd_rdptr = 0 | MWIFIEX_BD_FLAG_ROLLOVER_IND;
+	card->txbd_rdptr = 0 | reg->tx_rollover_ind;
 	card->txbd_ring_vbase = NULL;
 	card->txbd_ring_pbase = 0;
 
@@ -453,6 +463,7 @@ static int mwifiex_pcie_delete_txbd_ring(struct mwifiex_adapter *adapter)
 static int mwifiex_pcie_create_rxbd_ring(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
+	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 	struct sk_buff *skb;
 	int i;
 	dma_addr_t buf_pa;
@@ -463,7 +474,7 @@ static int mwifiex_pcie_create_rxbd_ring(struct mwifiex_adapter *adapter)
 	 * starts at zero with rollover bit set
 	 */
 	card->rxbd_wrptr = 0;
-	card->rxbd_rdptr |= MWIFIEX_BD_FLAG_ROLLOVER_IND;
+	card->rxbd_rdptr = reg->rx_rollover_ind;
 
 	card->rxbd_ring_size = sizeof(struct mwifiex_pcie_buf_desc) *
 							MWIFIEX_MAX_TXRX_BD;
@@ -526,6 +537,7 @@ static int mwifiex_pcie_create_rxbd_ring(struct mwifiex_adapter *adapter)
 static int mwifiex_pcie_delete_rxbd_ring(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
+	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 	struct sk_buff *skb;
 	int i;
 
@@ -550,7 +562,7 @@ static int mwifiex_pcie_delete_rxbd_ring(struct mwifiex_adapter *adapter)
 				    card->rxbd_ring_pbase);
 	card->rxbd_ring_size = 0;
 	card->rxbd_wrptr = 0;
-	card->rxbd_rdptr = 0 | MWIFIEX_BD_FLAG_ROLLOVER_IND;
+	card->rxbd_rdptr = 0 | reg->rx_rollover_ind;
 	card->rxbd_ring_vbase = NULL;
 	card->rxbd_ring_pbase = 0;
 
@@ -563,6 +575,7 @@ static int mwifiex_pcie_delete_rxbd_ring(struct mwifiex_adapter *adapter)
 static int mwifiex_pcie_create_evtbd_ring(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
+	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 	struct sk_buff *skb;
 	int i;
 	dma_addr_t buf_pa;
@@ -573,7 +586,7 @@ static int mwifiex_pcie_create_evtbd_ring(struct mwifiex_adapter *adapter)
 	 * starts at zero with rollover bit set
 	 */
 	card->evtbd_wrptr = 0;
-	card->evtbd_rdptr |= MWIFIEX_BD_FLAG_ROLLOVER_IND;
+	card->evtbd_rdptr = reg->evt_rollover_ind;
 
 	card->evtbd_ring_size = sizeof(struct mwifiex_pcie_buf_desc) *
 							MWIFIEX_MAX_EVT_BD;
@@ -636,6 +649,7 @@ static int mwifiex_pcie_create_evtbd_ring(struct mwifiex_adapter *adapter)
 static int mwifiex_pcie_delete_evtbd_ring(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
+	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 	struct sk_buff *skb;
 	int i;
 
@@ -658,7 +672,7 @@ static int mwifiex_pcie_delete_evtbd_ring(struct mwifiex_adapter *adapter)
 				    card->evtbd_ring_vbase,
 				    card->evtbd_ring_pbase);
 	card->evtbd_wrptr = 0;
-	card->evtbd_rdptr = 0 | MWIFIEX_BD_FLAG_ROLLOVER_IND;
+	card->evtbd_rdptr = 0 | reg->evt_rollover_ind;
 	card->evtbd_ring_size = 0;
 	card->evtbd_ring_vbase = NULL;
 	card->evtbd_ring_pbase = 0;
@@ -771,12 +785,13 @@ static int mwifiex_pcie_delete_sleep_cookie_buf(struct mwifiex_adapter *adapter)
 static int mwifiex_clean_pcie_ring_buf(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
+	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 	u32 rdptr;
 
 	/* Read the TX ring read pointer set by firmware */
-	if (mwifiex_read_reg(adapter, REG_TXBD_RDPTR, &rdptr)) {
+	if (mwifiex_read_reg(adapter, reg->tx_rdptr, &rdptr)) {
 		dev_err(adapter->dev,
-			"Flush TXBD: failed to read REG_TXBD_RDPTR\n");
+			"Flush TXBD: failed to read reg->tx_rdptr\n");
 		return -1;
 	}
 
@@ -805,14 +820,15 @@ static int mwifiex_pcie_send_data_complete(struct mwifiex_adapter *adapter)
 	dma_addr_t buf_pa;
 	u32 wrdoneidx, rdptr, unmap_count = 0;
 	struct pcie_service_card *card = adapter->card;
+	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 
 	if (!mwifiex_pcie_ok_to_access_hw(adapter))
 		mwifiex_pm_wakeup_card(adapter);
 
 	/* Read the TX ring read pointer set by firmware */
-	if (mwifiex_read_reg(adapter, REG_TXBD_RDPTR, &rdptr)) {
+	if (mwifiex_read_reg(adapter, reg->tx_rdptr, &rdptr)) {
 		dev_err(adapter->dev,
-			"SEND COMP: failed to read REG_TXBD_RDPTR\n");
+			"SEND COMP: failed to read reg->tx_rdptr\n");
 		return -1;
 	}
 
@@ -820,11 +836,11 @@ static int mwifiex_pcie_send_data_complete(struct mwifiex_adapter *adapter)
 		card->txbd_rdptr, rdptr);
 
 	/* free from previous txbd_rdptr to current txbd_rdptr */
-	while (((card->txbd_rdptr & MWIFIEX_TXBD_MASK) !=
-		(rdptr & MWIFIEX_TXBD_MASK)) ||
-	       ((card->txbd_rdptr & MWIFIEX_BD_FLAG_ROLLOVER_IND) !=
-		(rdptr & MWIFIEX_BD_FLAG_ROLLOVER_IND))) {
-		wrdoneidx = card->txbd_rdptr & MWIFIEX_TXBD_MASK;
+	while (((card->txbd_rdptr & reg->tx_mask) !=
+		(rdptr & reg->tx_mask)) ||
+	       ((card->txbd_rdptr & reg->tx_rollover_ind) !=
+		(rdptr & reg->tx_rollover_ind))) {
+		wrdoneidx = card->txbd_rdptr & reg->tx_mask;
 
 		skb = card->tx_buf_list[wrdoneidx];
 		if (skb) {
@@ -850,20 +866,20 @@ static int mwifiex_pcie_send_data_complete(struct mwifiex_adapter *adapter)
 		card->txbd_ring[wrdoneidx]->flags = 0;
 		card->txbd_rdptr++;
 
-		if ((card->txbd_rdptr & MWIFIEX_TXBD_MASK) == num_tx_buffs)
+		if ((card->txbd_rdptr & reg->tx_mask) == num_tx_buffs)
 			card->txbd_rdptr = ((card->txbd_rdptr &
-					    MWIFIEX_BD_FLAG_ROLLOVER_IND) ^
-					    MWIFIEX_BD_FLAG_ROLLOVER_IND);
+					     reg->tx_rollover_ind) ^
+					     reg->tx_rollover_ind);
 	}
 
 	if (unmap_count)
 		adapter->data_sent = false;
 
 	if (card->txbd_flush) {
-		if (((card->txbd_wrptr & MWIFIEX_TXBD_MASK) ==
-		     (card->txbd_rdptr & MWIFIEX_TXBD_MASK)) &&
-		    ((card->txbd_wrptr & MWIFIEX_BD_FLAG_ROLLOVER_IND) !=
-		     (card->txbd_rdptr & MWIFIEX_BD_FLAG_ROLLOVER_IND)))
+		if (((card->txbd_wrptr & reg->tx_mask) ==
+		     (card->txbd_rdptr & reg->tx_mask)) &&
+		    ((card->txbd_wrptr & reg->tx_rollover_ind) !=
+		     (card->txbd_rdptr & reg->tx_rollover_ind)))
 			card->txbd_flush = 0;
 		else
 			mwifiex_clean_pcie_ring_buf(adapter);
@@ -883,6 +899,7 @@ mwifiex_pcie_send_data(struct mwifiex_adapter *adapter, struct sk_buff *skb,
 		       struct mwifiex_tx_param *tx_param)
 {
 	struct pcie_service_card *card = adapter->card;
+	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 	u32 wrindx;
 	int ret;
 	dma_addr_t buf_pa;
@@ -913,7 +930,7 @@ mwifiex_pcie_send_data(struct mwifiex_adapter *adapter, struct sk_buff *skb,
 					   PCI_DMA_TODEVICE))
 			return -1;
 
-		wrindx = card->txbd_wrptr & MWIFIEX_TXBD_MASK;
+		wrindx = card->txbd_wrptr & reg->tx_mask;
 		MWIFIEX_SKB_PACB(skb, &buf_pa);
 		card->tx_buf_list[wrindx] = skb;
 		card->txbd_ring[wrindx]->paddr = buf_pa;
@@ -921,17 +938,17 @@ mwifiex_pcie_send_data(struct mwifiex_adapter *adapter, struct sk_buff *skb,
 		card->txbd_ring[wrindx]->flags = MWIFIEX_BD_FLAG_FIRST_DESC |
 						MWIFIEX_BD_FLAG_LAST_DESC;
 
-		if ((++card->txbd_wrptr & MWIFIEX_TXBD_MASK) ==
+		if ((++card->txbd_wrptr & reg->tx_mask) ==
 							MWIFIEX_MAX_TXRX_BD)
 			card->txbd_wrptr = ((card->txbd_wrptr &
-						MWIFIEX_BD_FLAG_ROLLOVER_IND) ^
-						MWIFIEX_BD_FLAG_ROLLOVER_IND);
+						reg->tx_rollover_ind) ^
+						reg->tx_rollover_ind);
 
-		/* Write the TX ring write pointer in to REG_TXBD_WRPTR */
-		if (mwifiex_write_reg(adapter, REG_TXBD_WRPTR,
+		/* Write the TX ring write pointer in to reg->tx_wrptr */
+		if (mwifiex_write_reg(adapter, reg->tx_wrptr,
 				      card->txbd_wrptr)) {
 			dev_err(adapter->dev,
-				"SEND DATA: failed to write REG_TXBD_WRPTR\n");
+				"SEND DATA: failed to write reg->tx_wrptr\n");
 			ret = -1;
 			goto done_unmap;
 		}
@@ -984,6 +1001,7 @@ done_unmap:
 static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
+	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 	u32 wrptr, rd_index;
 	dma_addr_t buf_pa;
 	int ret = 0;
@@ -993,23 +1011,23 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
 		mwifiex_pm_wakeup_card(adapter);
 
 	/* Read the RX ring Write pointer set by firmware */
-	if (mwifiex_read_reg(adapter, REG_RXBD_WRPTR, &wrptr)) {
+	if (mwifiex_read_reg(adapter, reg->rx_wrptr, &wrptr)) {
 		dev_err(adapter->dev,
-			"RECV DATA: failed to read REG_TXBD_RDPTR\n");
+			"RECV DATA: failed to read reg->rx_wrptr\n");
 		ret = -1;
 		goto done;
 	}
 	card->rxbd_wrptr = wrptr;
 
-	while (((wrptr & MWIFIEX_RXBD_MASK) !=
-		(card->rxbd_rdptr & MWIFIEX_RXBD_MASK)) ||
-	       ((wrptr & MWIFIEX_BD_FLAG_ROLLOVER_IND) ==
-		(card->rxbd_rdptr & MWIFIEX_BD_FLAG_ROLLOVER_IND))) {
+	while (((wrptr & reg->rx_mask) !=
+		(card->rxbd_rdptr & reg->rx_mask)) ||
+	       ((wrptr & reg->rx_rollover_ind) ==
+		(card->rxbd_rdptr & reg->rx_rollover_ind))) {
 		struct sk_buff *skb_data;
 		u16 rx_len;
 		__le16 pkt_len;
 
-		rd_index = card->rxbd_rdptr & MWIFIEX_RXBD_MASK;
+		rd_index = card->rxbd_rdptr & reg->rx_mask;
 		skb_data = card->rx_buf_list[rd_index];
 
 		MWIFIEX_SKB_PACB(skb_data, &buf_pa);
@@ -1051,28 +1069,28 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
 		card->rxbd_ring[rd_index]->len = skb_tmp->len;
 		card->rxbd_ring[rd_index]->flags = 0;
 
-		if ((++card->rxbd_rdptr & MWIFIEX_RXBD_MASK) ==
+		if ((++card->rxbd_rdptr & reg->rx_mask) ==
 							MWIFIEX_MAX_TXRX_BD) {
 			card->rxbd_rdptr = ((card->rxbd_rdptr &
-					     MWIFIEX_BD_FLAG_ROLLOVER_IND) ^
-					    MWIFIEX_BD_FLAG_ROLLOVER_IND);
+					     reg->rx_rollover_ind) ^
+					     reg->rx_rollover_ind);
 		}
 		dev_dbg(adapter->dev, "info: RECV DATA: <Rd: %#x, Wr: %#x>\n",
 			card->rxbd_rdptr, wrptr);
 
-		/* Write the RX ring read pointer in to REG_RXBD_RDPTR */
-		if (mwifiex_write_reg(adapter, REG_RXBD_RDPTR,
+		/* Write the RX ring read pointer in to reg->rx_rdptr */
+		if (mwifiex_write_reg(adapter, reg->rx_rdptr,
 				      card->rxbd_rdptr)) {
 			dev_err(adapter->dev,
-				"RECV DATA: failed to write REG_RXBD_RDPTR\n");
+				"RECV DATA: failed to write reg->rx_rdptr\n");
 			ret = -1;
 			goto done;
 		}
 
 		/* Read the RX ring Write pointer set by firmware */
-		if (mwifiex_read_reg(adapter, REG_RXBD_WRPTR, &wrptr)) {
+		if (mwifiex_read_reg(adapter, reg->rx_wrptr, &wrptr)) {
 			dev_err(adapter->dev,
-				"RECV DATA: failed to read REG_TXBD_RDPTR\n");
+				"RECV DATA: failed to read reg->rx_wrptr\n");
 			ret = -1;
 			goto done;
 		}
@@ -1093,6 +1111,7 @@ mwifiex_pcie_send_boot_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 {
 	dma_addr_t buf_pa;
 	struct pcie_service_card *card = adapter->card;
+	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 
 	if (!(skb->data && skb->len)) {
 		dev_err(adapter->dev,
@@ -1106,9 +1125,10 @@ mwifiex_pcie_send_boot_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 
 	MWIFIEX_SKB_PACB(skb, &buf_pa);
 
-	/* Write the lower 32bits of the physical address to scratch
-	 * register 0 */
-	if (mwifiex_write_reg(adapter, PCIE_SCRATCH_0_REG, (u32)buf_pa)) {
+	/* Write the lower 32bits of the physical address to low command
+	 * address scratch register
+	 */
+	if (mwifiex_write_reg(adapter, reg->cmd_addr_lo, (u32)buf_pa)) {
 		dev_err(adapter->dev,
 			"%s: failed to write download command to boot code.\n",
 			__func__);
@@ -1117,9 +1137,10 @@ mwifiex_pcie_send_boot_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 		return -1;
 	}
 
-	/* Write the upper 32bits of the physical address to scratch
-	 * register 1 */
-	if (mwifiex_write_reg(adapter, PCIE_SCRATCH_1_REG,
+	/* Write the upper 32bits of the physical address to high command
+	 * address scratch register
+	 */
+	if (mwifiex_write_reg(adapter, reg->cmd_addr_hi,
 			      (u32)((u64)buf_pa >> 32))) {
 		dev_err(adapter->dev,
 			"%s: failed to write download command to boot code.\n",
@@ -1129,10 +1150,10 @@ mwifiex_pcie_send_boot_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 		return -1;
 	}
 
-	/* Write the command length to scratch register 2 */
-	if (mwifiex_write_reg(adapter, PCIE_SCRATCH_2_REG, skb->len)) {
+	/* Write the command length to cmd_size scratch register */
+	if (mwifiex_write_reg(adapter, reg->cmd_size, skb->len)) {
 		dev_err(adapter->dev,
-			"%s: failed to write command len to scratch reg 2\n",
+			"%s: failed to write command len to cmd_size scratch reg\n",
 			__func__);
 		pci_unmap_single(card->dev, buf_pa, MWIFIEX_UPLD_SIZE,
 				 PCI_DMA_TODEVICE);
@@ -1158,11 +1179,12 @@ mwifiex_pcie_send_boot_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 static int mwifiex_pcie_init_fw_port(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
+	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 
-	/* Write the RX ring read pointer in to REG_RXBD_RDPTR */
-	if (mwifiex_write_reg(adapter, REG_RXBD_RDPTR, card->rxbd_rdptr | 0)) {
+	/* Write the RX ring read pointer in to reg->rx_rdptr */
+	if (mwifiex_write_reg(adapter, reg->rx_rdptr, card->rxbd_rdptr)) {
 		dev_err(adapter->dev,
-			"RECV DATA: failed to write REG_RXBD_RDPTR\n");
+			"RECV DATA: failed to write reg->rx_rdptr\n");
 		return -1;
 	}
 	return 0;
@@ -1174,6 +1196,7 @@ static int
 mwifiex_pcie_send_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 {
 	struct pcie_service_card *card = adapter->card;
+	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 	int ret = 0;
 	dma_addr_t cmd_buf_pa, cmdrsp_buf_pa;
 	u8 *payload = (u8 *)skb->data;
@@ -1206,7 +1229,7 @@ mwifiex_pcie_send_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 
 	/* To send a command, the driver will:
 		1. Write the 64bit physical address of the data buffer to
-		   SCRATCH1 + SCRATCH0
+		   cmd response address low  + cmd response address high
 		2. Ring the door bell (i.e. set the door bell interrupt)
 
 		In response to door bell interrupt, the firmware will perform
@@ -1218,7 +1241,7 @@ mwifiex_pcie_send_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 		MWIFIEX_SKB_PACB(card->cmdrsp_buf, &cmdrsp_buf_pa);
 		/* Write the lower 32bits of the cmdrsp buffer physical
 		   address */
-		if (mwifiex_write_reg(adapter, REG_CMDRSP_ADDR_LO,
+		if (mwifiex_write_reg(adapter, reg->cmdrsp_addr_lo,
 				      (u32)cmdrsp_buf_pa)) {
 			dev_err(adapter->dev,
 				"Failed to write download cmd to boot code.\n");
@@ -1227,7 +1250,7 @@ mwifiex_pcie_send_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 		}
 		/* Write the upper 32bits of the cmdrsp buffer physical
 		   address */
-		if (mwifiex_write_reg(adapter, REG_CMDRSP_ADDR_HI,
+		if (mwifiex_write_reg(adapter, reg->cmdrsp_addr_hi,
 				      (u32)((u64)cmdrsp_buf_pa >> 32))) {
 			dev_err(adapter->dev,
 				"Failed to write download cmd to boot code.\n");
@@ -1237,15 +1260,16 @@ mwifiex_pcie_send_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 	}
 
 	MWIFIEX_SKB_PACB(card->cmd_buf, &cmd_buf_pa);
-	/* Write the lower 32bits of the physical address to REG_CMD_ADDR_LO */
-	if (mwifiex_write_reg(adapter, REG_CMD_ADDR_LO, (u32)cmd_buf_pa)) {
+	/* Write the lower 32bits of the physical address to reg->cmd_addr_lo */
+	if (mwifiex_write_reg(adapter, reg->cmd_addr_lo,
+			      (u32)cmd_buf_pa)) {
 		dev_err(adapter->dev,
 			"Failed to write download cmd to boot code.\n");
 		ret = -1;
 		goto done;
 	}
-	/* Write the upper 32bits of the physical address to REG_CMD_ADDR_HI */
-	if (mwifiex_write_reg(adapter, REG_CMD_ADDR_HI,
+	/* Write the upper 32bits of the physical address to reg->cmd_addr_hi */
+	if (mwifiex_write_reg(adapter, reg->cmd_addr_hi,
 			      (u32)((u64)cmd_buf_pa >> 32))) {
 		dev_err(adapter->dev,
 			"Failed to write download cmd to boot code.\n");
@@ -1253,10 +1277,11 @@ mwifiex_pcie_send_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 		goto done;
 	}
 
-	/* Write the command length to REG_CMD_SIZE */
-	if (mwifiex_write_reg(adapter, REG_CMD_SIZE, card->cmd_buf->len)) {
+	/* Write the command length to reg->cmd_size */
+	if (mwifiex_write_reg(adapter, reg->cmd_size,
+			      card->cmd_buf->len)) {
 		dev_err(adapter->dev,
-			"Failed to write cmd len to REG_CMD_SIZE\n");
+			"Failed to write cmd len to reg->cmd_size\n");
 		ret = -1;
 		goto done;
 	}
@@ -1283,6 +1308,7 @@ done:
 static int mwifiex_pcie_process_cmd_complete(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
+	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 	struct sk_buff *skb = card->cmdrsp_buf;
 	int count = 0;
 	u16 rx_len;
@@ -1328,14 +1354,14 @@ static int mwifiex_pcie_process_cmd_complete(struct mwifiex_adapter *adapter)
 		/* Clear the cmd-rsp buffer address in scratch registers. This
 		   will prevent firmware from writing to the same response
 		   buffer again. */
-		if (mwifiex_write_reg(adapter, REG_CMDRSP_ADDR_LO, 0)) {
+		if (mwifiex_write_reg(adapter, reg->cmdrsp_addr_lo, 0)) {
 			dev_err(adapter->dev,
 				"cmd_done: failed to clear cmd_rsp_addr_lo\n");
 			return -1;
 		}
 		/* Write the upper 32bits of the cmdrsp buffer physical
 		   address */
-		if (mwifiex_write_reg(adapter, REG_CMDRSP_ADDR_HI, 0)) {
+		if (mwifiex_write_reg(adapter, reg->cmdrsp_addr_hi, 0)) {
 			dev_err(adapter->dev,
 				"cmd_done: failed to clear cmd_rsp_addr_hi\n");
 			return -1;
@@ -1380,6 +1406,7 @@ static int mwifiex_pcie_cmdrsp_complete(struct mwifiex_adapter *adapter,
 static int mwifiex_pcie_process_event_ready(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
+	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 	u32 rdptr = card->evtbd_rdptr & MWIFIEX_EVTBD_MASK;
 	u32 wrptr, event;
 	dma_addr_t buf_pa;
@@ -1399,9 +1426,9 @@ static int mwifiex_pcie_process_event_ready(struct mwifiex_adapter *adapter)
 	}
 
 	/* Read the event ring write pointer set by firmware */
-	if (mwifiex_read_reg(adapter, REG_EVTBD_WRPTR, &wrptr)) {
+	if (mwifiex_read_reg(adapter, reg->evt_wrptr, &wrptr)) {
 		dev_err(adapter->dev,
-			"EventReady: failed to read REG_EVTBD_WRPTR\n");
+			"EventReady: failed to read reg->evt_wrptr\n");
 		return -1;
 	}
 
@@ -1409,8 +1436,8 @@ static int mwifiex_pcie_process_event_ready(struct mwifiex_adapter *adapter)
 		card->evtbd_rdptr, wrptr);
 	if (((wrptr & MWIFIEX_EVTBD_MASK) != (card->evtbd_rdptr
 					      & MWIFIEX_EVTBD_MASK)) ||
-	    ((wrptr & MWIFIEX_BD_FLAG_ROLLOVER_IND) ==
-	     (card->evtbd_rdptr & MWIFIEX_BD_FLAG_ROLLOVER_IND))) {
+	    ((wrptr & reg->evt_rollover_ind) ==
+	     (card->evtbd_rdptr & reg->evt_rollover_ind))) {
 		struct sk_buff *skb_cmd;
 		__le16 data_len = 0;
 		u16 evt_len;
@@ -1462,6 +1489,7 @@ static int mwifiex_pcie_event_complete(struct mwifiex_adapter *adapter,
 				       struct sk_buff *skb)
 {
 	struct pcie_service_card *card = adapter->card;
+	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 	int ret = 0;
 	u32 rdptr = card->evtbd_rdptr & MWIFIEX_EVTBD_MASK;
 	u32 wrptr;
@@ -1477,9 +1505,9 @@ static int mwifiex_pcie_event_complete(struct mwifiex_adapter *adapter,
 	}
 
 	/* Read the event ring write pointer set by firmware */
-	if (mwifiex_read_reg(adapter, REG_EVTBD_WRPTR, &wrptr)) {
+	if (mwifiex_read_reg(adapter, reg->evt_wrptr, &wrptr)) {
 		dev_err(adapter->dev,
-			"event_complete: failed to read REG_EVTBD_WRPTR\n");
+			"event_complete: failed to read reg->evt_wrptr\n");
 		return -1;
 	}
 
@@ -1504,17 +1532,18 @@ static int mwifiex_pcie_event_complete(struct mwifiex_adapter *adapter,
 
 	if ((++card->evtbd_rdptr & MWIFIEX_EVTBD_MASK) == MWIFIEX_MAX_EVT_BD) {
 		card->evtbd_rdptr = ((card->evtbd_rdptr &
-					MWIFIEX_BD_FLAG_ROLLOVER_IND) ^
-					MWIFIEX_BD_FLAG_ROLLOVER_IND);
+					reg->evt_rollover_ind) ^
+					reg->evt_rollover_ind);
 	}
 
 	dev_dbg(adapter->dev, "info: Updated <Rd: 0x%x, Wr: 0x%x>",
 		card->evtbd_rdptr, wrptr);
 
-	/* Write the event ring read pointer in to REG_EVTBD_RDPTR */
-	if (mwifiex_write_reg(adapter, REG_EVTBD_RDPTR, card->evtbd_rdptr)) {
+	/* Write the event ring read pointer in to reg->evt_rdptr */
+	if (mwifiex_write_reg(adapter, reg->evt_rdptr,
+			      card->evtbd_rdptr)) {
 		dev_err(adapter->dev,
-			"event_complete: failed to read REG_EVTBD_RDPTR\n");
+			"event_complete: failed to read reg->evt_rdptr\n");
 		return -1;
 	}
 
@@ -1543,6 +1572,7 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 	u32 block_retry_cnt = 0;
 	dma_addr_t buf_pa;
 	struct pcie_service_card *card = adapter->card;
+	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 
 	if (!firmware || !firmware_len) {
 		dev_err(adapter->dev,
@@ -1574,7 +1604,7 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 			break;
 
 		for (tries = 0; tries < MAX_POLL_TRIES; tries++) {
-			ret = mwifiex_read_reg(adapter, PCIE_SCRATCH_2_REG,
+			ret = mwifiex_read_reg(adapter, reg->cmd_size,
 					       &len);
 			if (ret) {
 				dev_warn(adapter->dev,
@@ -1620,16 +1650,15 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 
 			dev_dbg(adapter->dev, ".");
 
-			tx_blocks = (txlen +
-				     MWIFIEX_PCIE_BLOCK_SIZE_FW_DNLD - 1) /
-				     MWIFIEX_PCIE_BLOCK_SIZE_FW_DNLD;
+			tx_blocks = (txlen + card->pcie.blksz_fw_dl - 1) /
+				    card->pcie.blksz_fw_dl;
 
 			/* Copy payload to buffer */
 			memmove(skb->data, &firmware[offset], txlen);
 		}
 
 		skb_put(skb, MWIFIEX_UPLD_SIZE - skb->len);
-		skb_trim(skb, tx_blocks * MWIFIEX_PCIE_BLOCK_SIZE_FW_DNLD);
+		skb_trim(skb, tx_blocks * card->pcie.blksz_fw_dl);
 
 		/* Send the boot command to device */
 		if (mwifiex_pcie_send_boot_cmd(adapter, skb)) {
@@ -1682,6 +1711,8 @@ mwifiex_check_fw_status(struct mwifiex_adapter *adapter, u32 poll_num)
 {
 	int ret = 0;
 	u32 firmware_stat, winner_status;
+	struct pcie_service_card *card = adapter->card;
+	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 	u32 tries;
 
 	/* Mask spurios interrupts */
@@ -1692,7 +1723,8 @@ mwifiex_check_fw_status(struct mwifiex_adapter *adapter, u32 poll_num)
 	}
 
 	dev_dbg(adapter->dev, "Setting driver ready signature\n");
-	if (mwifiex_write_reg(adapter, REG_DRV_READY, FIRMWARE_READY_PCIE)) {
+	if (mwifiex_write_reg(adapter, reg->drv_rdy,
+			      FIRMWARE_READY_PCIE)) {
 		dev_err(adapter->dev,
 			"Failed to write driver ready signature\n");
 		return -1;
@@ -1700,7 +1732,7 @@ mwifiex_check_fw_status(struct mwifiex_adapter *adapter, u32 poll_num)
 
 	/* Wait for firmware initialization event */
 	for (tries = 0; tries < poll_num; tries++) {
-		if (mwifiex_read_reg(adapter, PCIE_SCRATCH_3_REG,
+		if (mwifiex_read_reg(adapter, reg->fw_status,
 				     &firmware_stat))
 			ret = -1;
 		else
@@ -1717,7 +1749,7 @@ mwifiex_check_fw_status(struct mwifiex_adapter *adapter, u32 poll_num)
 	}
 
 	if (ret) {
-		if (mwifiex_read_reg(adapter, PCIE_SCRATCH_3_REG,
+		if (mwifiex_read_reg(adapter, reg->fw_status,
 				     &winner_status))
 			ret = -1;
 		else if (!winner_status) {
@@ -2061,10 +2093,11 @@ static void mwifiex_pcie_cleanup(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
 	struct pci_dev *pdev = card->dev;
+	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 
 	if (user_rmmod) {
 		dev_dbg(adapter->dev, "Clearing driver ready signature\n");
-		if (mwifiex_write_reg(adapter, REG_DRV_READY, 0x00000000))
+		if (mwifiex_write_reg(adapter, reg->drv_rdy, 0x00000000))
 			dev_err(adapter->dev,
 				"Failed to write driver not-ready signature\n");
 	}
@@ -2102,7 +2135,7 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 	}
 
 	adapter->dev = &pdev->dev;
-	strcpy(adapter->fw_name, PCIE8766_DEFAULT_FW_NAME);
+	strcpy(adapter->fw_name, card->pcie.firmware);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mwifiex/pcie.h b/drivers/net/wireless/mwifiex/pcie.h
index 37eeb2c..7ef660e 100644
--- a/drivers/net/wireless/mwifiex/pcie.h
+++ b/drivers/net/wireless/mwifiex/pcie.h
@@ -75,27 +75,6 @@
 #define MWIFIEX_BD_FLAG_ROLLOVER_IND			BIT(7)
 #define MWIFIEX_BD_FLAG_FIRST_DESC			BIT(0)
 #define MWIFIEX_BD_FLAG_LAST_DESC			BIT(1)
-#define REG_CMD_ADDR_LO					PCIE_SCRATCH_0_REG
-#define REG_CMD_ADDR_HI					PCIE_SCRATCH_1_REG
-#define REG_CMD_SIZE					PCIE_SCRATCH_2_REG
-
-#define REG_CMDRSP_ADDR_LO				PCIE_SCRATCH_4_REG
-#define REG_CMDRSP_ADDR_HI				PCIE_SCRATCH_5_REG
-
-/* TX buffer description read pointer */
-#define REG_TXBD_RDPTR					PCIE_SCRATCH_6_REG
-/* TX buffer description write pointer */
-#define REG_TXBD_WRPTR					PCIE_SCRATCH_7_REG
-/* RX buffer description read pointer */
-#define REG_RXBD_RDPTR					PCIE_SCRATCH_8_REG
-/* RX buffer description write pointer */
-#define REG_RXBD_WRPTR					PCIE_SCRATCH_9_REG
-/* Event buffer description read pointer */
-#define REG_EVTBD_RDPTR					PCIE_SCRATCH_10_REG
-/* Event buffer description write pointer */
-#define REG_EVTBD_WRPTR					PCIE_SCRATCH_11_REG
-/* Driver ready signature write pointer */
-#define REG_DRV_READY					PCIE_SCRATCH_12_REG
 
 /* Max retry number of command write */
 #define MAX_WRITE_IOMEM_RETRY				2
@@ -104,6 +83,78 @@
 /* FW awake cookie after FW ready */
 #define FW_AWAKE_COOKIE						(0xAA55AA55)
 
+struct mwifiex_pcie_card_reg {
+	u16 cmd_addr_lo;
+	u16 cmd_addr_hi;
+	u16 fw_status;
+	u16 cmd_size;
+	u16 cmdrsp_addr_lo;
+	u16 cmdrsp_addr_hi;
+	u16 tx_rdptr;
+	u16 tx_wrptr;
+	u16 rx_rdptr;
+	u16 rx_wrptr;
+	u16 evt_rdptr;
+	u16 evt_wrptr;
+	u16 drv_rdy;
+	u16 tx_start_ptr;
+	u32 tx_mask;
+	u32 tx_wrap_mask;
+	u32 rx_mask;
+	u32 rx_wrap_mask;
+	u32 tx_rollover_ind;
+	u32 rx_rollover_ind;
+	u32 evt_rollover_ind;
+	u8 ring_flag_sop;
+	u8 ring_flag_eop;
+	u8 ring_flag_xs_sop;
+	u8 ring_flag_xs_eop;
+	u32 ring_tx_start_ptr;
+	u8 pfu_enabled;
+};
+
+static const struct mwifiex_pcie_card_reg mwifiex_reg_8766 = {
+	.cmd_addr_lo = PCIE_SCRATCH_0_REG,
+	.cmd_addr_hi = PCIE_SCRATCH_1_REG,
+	.cmd_size = PCIE_SCRATCH_2_REG,
+	.fw_status = PCIE_SCRATCH_3_REG,
+	.cmdrsp_addr_lo = PCIE_SCRATCH_4_REG,
+	.cmdrsp_addr_hi = PCIE_SCRATCH_5_REG,
+	.tx_rdptr = PCIE_SCRATCH_6_REG,
+	.tx_wrptr = PCIE_SCRATCH_7_REG,
+	.rx_rdptr = PCIE_SCRATCH_8_REG,
+	.rx_wrptr = PCIE_SCRATCH_9_REG,
+	.evt_rdptr = PCIE_SCRATCH_10_REG,
+	.evt_wrptr = PCIE_SCRATCH_11_REG,
+	.drv_rdy = PCIE_SCRATCH_12_REG,
+	.tx_start_ptr = 0,
+	.tx_mask = MWIFIEX_TXBD_MASK,
+	.tx_wrap_mask = 0,
+	.rx_mask = MWIFIEX_RXBD_MASK,
+	.rx_wrap_mask = 0,
+	.tx_rollover_ind = MWIFIEX_BD_FLAG_ROLLOVER_IND,
+	.rx_rollover_ind = MWIFIEX_BD_FLAG_ROLLOVER_IND,
+	.evt_rollover_ind = MWIFIEX_BD_FLAG_ROLLOVER_IND,
+	.ring_flag_sop = 0,
+	.ring_flag_eop = 0,
+	.ring_flag_xs_sop = 0,
+	.ring_flag_xs_eop = 0,
+	.ring_tx_start_ptr = 0,
+	.pfu_enabled = 0,
+};
+
+struct mwifiex_pcie_device {
+	const char *firmware;
+	const struct mwifiex_pcie_card_reg *reg;
+	u16 blksz_fw_dl;
+};
+
+static const struct mwifiex_pcie_device mwifiex_pcie8766 = {
+	.firmware       = PCIE8766_DEFAULT_FW_NAME,
+	.reg            = &mwifiex_reg_8766,
+	.blksz_fw_dl = MWIFIEX_PCIE_BLOCK_SIZE_FW_DNLD,
+};
+
 struct mwifiex_pcie_buf_desc {
 	u64 paddr;
 	u16 len;
@@ -113,6 +164,7 @@ struct mwifiex_pcie_buf_desc {
 struct pcie_service_card {
 	struct pci_dev *dev;
 	struct mwifiex_adapter *adapter;
+	struct mwifiex_pcie_device pcie;
 
 	u8 txbd_flush;
 	u32 txbd_wrptr;
@@ -150,10 +202,11 @@ struct pcie_service_card {
 static inline int
 mwifiex_pcie_txbd_empty(struct pcie_service_card *card, u32 rdptr)
 {
-	if (((card->txbd_wrptr & MWIFIEX_TXBD_MASK) ==
-			(rdptr & MWIFIEX_TXBD_MASK)) &&
-	    ((card->txbd_wrptr & MWIFIEX_BD_FLAG_ROLLOVER_IND) !=
-			(rdptr & MWIFIEX_BD_FLAG_ROLLOVER_IND)))
+	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
+
+	if (((card->txbd_wrptr & reg->tx_mask) == (rdptr & reg->tx_mask)) &&
+	    ((card->txbd_wrptr & reg->tx_rollover_ind) !=
+			(rdptr & reg->tx_rollover_ind)))
 		return 1;
 
 	return 0;
@@ -162,10 +215,12 @@ mwifiex_pcie_txbd_empty(struct pcie_service_card *card, u32 rdptr)
 static inline int
 mwifiex_pcie_txbd_not_full(struct pcie_service_card *card)
 {
-	if (((card->txbd_wrptr & MWIFIEX_TXBD_MASK) !=
-	     (card->txbd_rdptr & MWIFIEX_TXBD_MASK)) ||
-	    ((card->txbd_wrptr & MWIFIEX_BD_FLAG_ROLLOVER_IND) !=
-	     (card->txbd_rdptr & MWIFIEX_BD_FLAG_ROLLOVER_IND)))
+	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
+
+	if (((card->txbd_wrptr & reg->tx_mask) !=
+	     (card->txbd_rdptr & reg->tx_mask)) ||
+	    ((card->txbd_wrptr & reg->tx_rollover_ind) !=
+	     (card->txbd_rdptr & reg->tx_rollover_ind)))
 		return 1;
 
 	return 0;
-- 
1.7.0.2

