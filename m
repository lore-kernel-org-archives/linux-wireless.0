Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:50504 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760542Ab3BICW7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 21:22:59 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/4] mwifiex: define generic data type for PCIe ring buffers
Date: Fri,  8 Feb 2013 18:18:08 -0800
Message-Id: <1360376289-14861-4-git-send-email-bzhao@marvell.com> (sfid-20130209_032630_191709_41F5A86F)
In-Reply-To: <1360376289-14861-1-git-send-email-bzhao@marvell.com>
References: <1360376289-14861-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch defines PCIe ring buffer array pointer as void instead
of mwifiex_pcie_buf_desc. This will enable us to use same pointers
for ring operations instead of new structures if buffer descriptor
structure changes.

Also split out event buffer descriptor structure from struct
mwifiex_pcie_buf_desc. For PCIe8766 TX/RX buffer descriptor is
same as evevt buffer descriptor. Newer chips could use different
TX/RX buffer descriptor while event descriptor remains the same.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c |   49 ++++++++++++++++++----------------
 drivers/net/wireless/mwifiex/pcie.h |   12 ++++++--
 2 files changed, 35 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 06aae55..6c15969 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -444,7 +444,7 @@ static int mwifiex_init_rxq_ring(struct mwifiex_adapter *adapter)
 static int mwifiex_pcie_init_evt_ring(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
-	struct mwifiex_pcie_buf_desc *desc;
+	struct mwifiex_evt_buf_desc *desc;
 	struct sk_buff *skb;
 	dma_addr_t buf_pa;
 	int i;
@@ -474,7 +474,6 @@ static int mwifiex_pcie_init_evt_ring(struct mwifiex_adapter *adapter)
 		card->evt_buf_list[i] = skb;
 		card->evtbd_ring[i] = (void *)(card->evtbd_ring_vbase +
 				      (sizeof(*desc) * i));
-
 		desc = card->evtbd_ring[i];
 		desc->paddr = buf_pa;
 		desc->len = (u16)skb->len;
@@ -540,7 +539,7 @@ static void mwifiex_cleanup_rxq_ring(struct mwifiex_adapter *adapter)
 static void mwifiex_cleanup_evt_ring(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
-	struct mwifiex_pcie_buf_desc *desc;
+	struct mwifiex_evt_buf_desc *desc;
 	struct sk_buff *skb;
 	int i;
 
@@ -695,7 +694,7 @@ static int mwifiex_pcie_create_evtbd_ring(struct mwifiex_adapter *adapter)
 	card->evtbd_wrptr = 0;
 	card->evtbd_rdptr = reg->evt_rollover_ind;
 
-	card->evtbd_ring_size = sizeof(struct mwifiex_pcie_buf_desc) *
+	card->evtbd_ring_size = sizeof(struct mwifiex_evt_buf_desc) *
 							MWIFIEX_MAX_EVT_BD;
 	dev_dbg(adapter->dev, "info: evtbd_ring: Allocating %d bytes\n",
 		card->evtbd_ring_size);
@@ -880,6 +879,7 @@ static int mwifiex_pcie_send_data_complete(struct mwifiex_adapter *adapter)
 	struct sk_buff *skb;
 	dma_addr_t buf_pa;
 	u32 wrdoneidx, rdptr, unmap_count = 0;
+	struct mwifiex_pcie_buf_desc *desc;
 	struct pcie_service_card *card = adapter->card;
 	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 
@@ -922,9 +922,8 @@ static int mwifiex_pcie_send_data_complete(struct mwifiex_adapter *adapter)
 		}
 
 		card->tx_buf_list[wrdoneidx] = NULL;
-		card->txbd_ring[wrdoneidx]->paddr = 0;
-		card->txbd_ring[wrdoneidx]->len = 0;
-		card->txbd_ring[wrdoneidx]->flags = 0;
+		desc = card->txbd_ring[wrdoneidx];
+		memset(desc, 0, sizeof(*desc));
 		card->txbd_rdptr++;
 
 		if ((card->txbd_rdptr & reg->tx_mask) == num_tx_buffs)
@@ -964,6 +963,7 @@ mwifiex_pcie_send_data(struct mwifiex_adapter *adapter, struct sk_buff *skb,
 	u32 wrindx;
 	int ret;
 	dma_addr_t buf_pa;
+	struct mwifiex_pcie_buf_desc *desc;
 	__le16 *tmp;
 
 	if (!(skb->data && skb->len)) {
@@ -994,10 +994,11 @@ mwifiex_pcie_send_data(struct mwifiex_adapter *adapter, struct sk_buff *skb,
 		wrindx = card->txbd_wrptr & reg->tx_mask;
 		MWIFIEX_SKB_PACB(skb, &buf_pa);
 		card->tx_buf_list[wrindx] = skb;
-		card->txbd_ring[wrindx]->paddr = buf_pa;
-		card->txbd_ring[wrindx]->len = (u16)skb->len;
-		card->txbd_ring[wrindx]->flags = MWIFIEX_BD_FLAG_FIRST_DESC |
-						MWIFIEX_BD_FLAG_LAST_DESC;
+		desc = card->txbd_ring[wrindx];
+		desc->paddr = buf_pa;
+		desc->len = (u16)skb->len;
+		desc->flags = MWIFIEX_BD_FLAG_FIRST_DESC |
+			      MWIFIEX_BD_FLAG_LAST_DESC;
 
 		if ((++card->txbd_wrptr & reg->tx_mask) ==
 							MWIFIEX_MAX_TXRX_BD)
@@ -1049,9 +1050,7 @@ done_unmap:
 	MWIFIEX_SKB_PACB(skb, &buf_pa);
 	pci_unmap_single(card->dev, buf_pa, skb->len, PCI_DMA_TODEVICE);
 	card->tx_buf_list[wrindx] = NULL;
-	card->txbd_ring[wrindx]->paddr = 0;
-	card->txbd_ring[wrindx]->len = 0;
-	card->txbd_ring[wrindx]->flags = 0;
+	memset(desc, 0, sizeof(*desc));
 	return ret;
 }
 
@@ -1067,6 +1066,7 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
 	dma_addr_t buf_pa;
 	int ret = 0;
 	struct sk_buff *skb_tmp = NULL;
+	struct mwifiex_pcie_buf_desc *desc;
 
 	if (!mwifiex_pcie_ok_to_access_hw(adapter))
 		mwifiex_pm_wakeup_card(adapter);
@@ -1126,9 +1126,10 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
 			"RECV DATA: Attach new sk_buff %p at rxbd_rdidx=%d\n",
 			skb_tmp, rd_index);
 		card->rx_buf_list[rd_index] = skb_tmp;
-		card->rxbd_ring[rd_index]->paddr = buf_pa;
-		card->rxbd_ring[rd_index]->len = skb_tmp->len;
-		card->rxbd_ring[rd_index]->flags = 0;
+		desc = card->rxbd_ring[rd_index];
+		desc->paddr = buf_pa;
+		desc->len = skb_tmp->len;
+		desc->flags = 0;
 
 		if ((++card->rxbd_rdptr & reg->rx_mask) ==
 							MWIFIEX_MAX_TXRX_BD) {
@@ -1471,6 +1472,7 @@ static int mwifiex_pcie_process_event_ready(struct mwifiex_adapter *adapter)
 	u32 rdptr = card->evtbd_rdptr & MWIFIEX_EVTBD_MASK;
 	u32 wrptr, event;
 	dma_addr_t buf_pa;
+	struct mwifiex_evt_buf_desc *desc;
 
 	if (!mwifiex_pcie_ok_to_access_hw(adapter))
 		mwifiex_pm_wakeup_card(adapter);
@@ -1512,9 +1514,8 @@ static int mwifiex_pcie_process_event_ready(struct mwifiex_adapter *adapter)
 		/* Take the pointer and set it to event pointer in adapter
 		   and will return back after event handling callback */
 		card->evt_buf_list[rdptr] = NULL;
-		card->evtbd_ring[rdptr]->paddr = 0;
-		card->evtbd_ring[rdptr]->len = 0;
-		card->evtbd_ring[rdptr]->flags = 0;
+		desc = card->evtbd_ring[rdptr];
+		memset(desc, 0, sizeof(*desc));
 
 		event = *(u32 *) &skb_cmd->data[INTF_HEADER_LEN];
 		adapter->event_cause = event;
@@ -1555,6 +1556,7 @@ static int mwifiex_pcie_event_complete(struct mwifiex_adapter *adapter,
 	u32 rdptr = card->evtbd_rdptr & MWIFIEX_EVTBD_MASK;
 	u32 wrptr;
 	dma_addr_t buf_pa;
+	struct mwifiex_evt_buf_desc *desc;
 
 	if (!skb)
 		return 0;
@@ -1581,9 +1583,10 @@ static int mwifiex_pcie_event_complete(struct mwifiex_adapter *adapter,
 		MWIFIEX_SKB_PACB(skb, &buf_pa);
 		card->evt_buf_list[rdptr] = skb;
 		MWIFIEX_SKB_PACB(skb, &buf_pa);
-		card->evtbd_ring[rdptr]->paddr = buf_pa;
-		card->evtbd_ring[rdptr]->len = (u16)skb->len;
-		card->evtbd_ring[rdptr]->flags = 0;
+		desc = card->evtbd_ring[rdptr];
+		desc->paddr = buf_pa;
+		desc->len = (u16)skb->len;
+		desc->flags = 0;
 		skb = NULL;
 	} else {
 		dev_dbg(adapter->dev,
diff --git a/drivers/net/wireless/mwifiex/pcie.h b/drivers/net/wireless/mwifiex/pcie.h
index 7ef660e..7ebdc74 100644
--- a/drivers/net/wireless/mwifiex/pcie.h
+++ b/drivers/net/wireless/mwifiex/pcie.h
@@ -155,6 +155,12 @@ static const struct mwifiex_pcie_device mwifiex_pcie8766 = {
 	.blksz_fw_dl = MWIFIEX_PCIE_BLOCK_SIZE_FW_DNLD,
 };
 
+struct mwifiex_evt_buf_desc {
+	u64 paddr;
+	u16 len;
+	u16 flags;
+} __packed;
+
 struct mwifiex_pcie_buf_desc {
 	u64 paddr;
 	u16 len;
@@ -172,7 +178,7 @@ struct pcie_service_card {
 	u32 txbd_ring_size;
 	u8 *txbd_ring_vbase;
 	dma_addr_t txbd_ring_pbase;
-	struct mwifiex_pcie_buf_desc *txbd_ring[MWIFIEX_MAX_TXRX_BD];
+	void *txbd_ring[MWIFIEX_MAX_TXRX_BD];
 	struct sk_buff *tx_buf_list[MWIFIEX_MAX_TXRX_BD];
 
 	u32 rxbd_wrptr;
@@ -180,7 +186,7 @@ struct pcie_service_card {
 	u32 rxbd_ring_size;
 	u8 *rxbd_ring_vbase;
 	dma_addr_t rxbd_ring_pbase;
-	struct mwifiex_pcie_buf_desc *rxbd_ring[MWIFIEX_MAX_TXRX_BD];
+	void *rxbd_ring[MWIFIEX_MAX_TXRX_BD];
 	struct sk_buff *rx_buf_list[MWIFIEX_MAX_TXRX_BD];
 
 	u32 evtbd_wrptr;
@@ -188,7 +194,7 @@ struct pcie_service_card {
 	u32 evtbd_ring_size;
 	u8 *evtbd_ring_vbase;
 	dma_addr_t evtbd_ring_pbase;
-	struct mwifiex_pcie_buf_desc *evtbd_ring[MWIFIEX_MAX_EVT_BD];
+	void *evtbd_ring[MWIFIEX_MAX_EVT_BD];
 	struct sk_buff *evt_buf_list[MWIFIEX_MAX_EVT_BD];
 
 	struct sk_buff *cmd_buf;
-- 
1.7.0.2

