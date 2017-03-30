Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:36584 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932774AbdC3JTo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Mar 2017 05:19:44 -0400
Received: by mail-pg0-f65.google.com with SMTP id 81so8592989pgh.3
        for <linux-wireless@vger.kernel.org>; Thu, 30 Mar 2017 02:19:43 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>
Subject: [PATCH 2/3] mwifiex: using general print function during device intialization
Date: Thu, 30 Mar 2017 09:19:06 +0000
Message-Id: <1490865547-10208-2-git-send-email-huxinming820@gmail.com> (sfid-20170330_112019_260200_A6E77E57)
In-Reply-To: <1490865547-10208-1-git-send-email-huxinming820@gmail.com>
References: <1490865547-10208-1-git-send-email-huxinming820@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

adapter->dev is initialized after mwifiex_register done, before that
print message by general pr_* function

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 78 ++++++++++++-----------------
 drivers/net/wireless/marvell/mwifiex/sdio.c |  3 +-
 2 files changed, 34 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index e381def..59cb01a 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -60,7 +60,7 @@ static int mwifiex_pcie_probe_of(struct device *dev)
 
 	mapping.addr = pci_map_single(card->dev, skb->data, size, flags);
 	if (pci_dma_mapping_error(card->dev, mapping.addr)) {
-		mwifiex_dbg(adapter, ERROR, "failed to map pci memory!\n");
+		pr_err("failed to map pci memory!\n");
 		return -1;
 	}
 	mapping.len = size;
@@ -594,7 +594,7 @@ static int mwifiex_init_rxq_ring(struct mwifiex_adapter *adapter)
 		skb = mwifiex_alloc_dma_align_buf(MWIFIEX_RX_DATA_BUF_SIZE,
 						  GFP_KERNEL);
 		if (!skb) {
-			mwifiex_dbg(adapter, ERROR,
+			pr_err(
 				    "Unable to allocate skb for RX ring.\n");
 			kfree(card->rxbd_ring_vbase);
 			return -ENOMEM;
@@ -651,8 +651,7 @@ static int mwifiex_pcie_init_evt_ring(struct mwifiex_adapter *adapter)
 		/* Allocate skb here so that firmware can DMA data from it */
 		skb = dev_alloc_skb(MAX_EVENT_SIZE);
 		if (!skb) {
-			mwifiex_dbg(adapter, ERROR,
-				    "Unable to allocate skb for EVENT buf.\n");
+			pr_err("Unable to allocate skb for EVENT buf.\n");
 			kfree(card->evtbd_ring_vbase);
 			return -ENOMEM;
 		}
@@ -818,16 +817,14 @@ static int mwifiex_pcie_create_txbd_ring(struct mwifiex_adapter *adapter)
 						     card->txbd_ring_size,
 						     &card->txbd_ring_pbase);
 	if (!card->txbd_ring_vbase) {
-		mwifiex_dbg(adapter, ERROR,
-			    "allocate consistent memory (%d bytes) failed!\n",
-			    card->txbd_ring_size);
+		pr_err("allocate consistent memory (%d bytes) failed!\n",
+		       card->txbd_ring_size);
 		return -ENOMEM;
 	}
-	mwifiex_dbg(adapter, DATA,
-		    "info: txbd_ring - base: %p, pbase: %#x:%x, len: %x\n",
-		    card->txbd_ring_vbase, (unsigned int)card->txbd_ring_pbase,
-		    (u32)((u64)card->txbd_ring_pbase >> 32),
-		    card->txbd_ring_size);
+	pr_notice("info: txbd_ring - base: %p, pbase: %#x:%x, len: %x\n",
+		  card->txbd_ring_vbase, (unsigned int)card->txbd_ring_pbase,
+		  (u32)((u64)card->txbd_ring_pbase >> 32),
+		  card->txbd_ring_size);
 
 	return mwifiex_init_txq_ring(adapter);
 }
@@ -875,24 +872,21 @@ static int mwifiex_pcie_create_rxbd_ring(struct mwifiex_adapter *adapter)
 		card->rxbd_ring_size = sizeof(struct mwifiex_pcie_buf_desc) *
 				       MWIFIEX_MAX_TXRX_BD;
 
-	mwifiex_dbg(adapter, INFO,
-		    "info: rxbd_ring: Allocating %d bytes\n",
-		    card->rxbd_ring_size);
+	pr_info("info: rxbd_ring: Allocating %d bytes\n",
+		card->rxbd_ring_size);
 	card->rxbd_ring_vbase = pci_alloc_consistent(card->dev,
 						     card->rxbd_ring_size,
 						     &card->rxbd_ring_pbase);
 	if (!card->rxbd_ring_vbase) {
-		mwifiex_dbg(adapter, ERROR,
-			    "allocate consistent memory (%d bytes) failed!\n",
-			    card->rxbd_ring_size);
+		pr_err("allocate consistent memory (%d bytes) failed!\n",
+		       card->rxbd_ring_size);
 		return -ENOMEM;
 	}
 
-	mwifiex_dbg(adapter, DATA,
-		    "info: rxbd_ring - base: %p, pbase: %#x:%x, len: %#x\n",
-		    card->rxbd_ring_vbase, (u32)card->rxbd_ring_pbase,
-		    (u32)((u64)card->rxbd_ring_pbase >> 32),
-		    card->rxbd_ring_size);
+	pr_notice("info: rxbd_ring - base: %p, pbase: %#x:%x, len: %#x\n",
+		  card->rxbd_ring_vbase, (u32)card->rxbd_ring_pbase,
+		  (u32)((u64)card->rxbd_ring_pbase >> 32),
+		  card->rxbd_ring_size);
 
 	return mwifiex_init_rxq_ring(adapter);
 }
@@ -939,24 +933,21 @@ static int mwifiex_pcie_create_evtbd_ring(struct mwifiex_adapter *adapter)
 	card->evtbd_ring_size = sizeof(struct mwifiex_evt_buf_desc) *
 				MWIFIEX_MAX_EVT_BD;
 
-	mwifiex_dbg(adapter, INFO,
-		    "info: evtbd_ring: Allocating %d bytes\n",
+	pr_info("info: evtbd_ring: Allocating %d bytes\n",
 		card->evtbd_ring_size);
 	card->evtbd_ring_vbase = pci_alloc_consistent(card->dev,
 						      card->evtbd_ring_size,
 						      &card->evtbd_ring_pbase);
 	if (!card->evtbd_ring_vbase) {
-		mwifiex_dbg(adapter, ERROR,
-			    "allocate consistent memory (%d bytes) failed!\n",
-			    card->evtbd_ring_size);
+		pr_err("allocate consistent memory (%d bytes) failed!\n",
+		       card->evtbd_ring_size);
 		return -ENOMEM;
 	}
 
-	mwifiex_dbg(adapter, EVENT,
-		    "info: CMDRSP/EVT bd_ring - base: %p pbase: %#x:%x len: %#x\n",
-		    card->evtbd_ring_vbase, (u32)card->evtbd_ring_pbase,
-		    (u32)((u64)card->evtbd_ring_pbase >> 32),
-		    card->evtbd_ring_size);
+	pr_notice("info: CMDRSP/EVT bd_ring - base: %p pbase: %#x:%x len: %#x\n",
+		  card->evtbd_ring_vbase, (u32)card->evtbd_ring_pbase,
+		  (u32)((u64)card->evtbd_ring_pbase >> 32),
+		  card->evtbd_ring_size);
 
 	return mwifiex_pcie_init_evt_ring(adapter);
 }
@@ -995,8 +986,7 @@ static int mwifiex_pcie_alloc_cmdrsp_buf(struct mwifiex_adapter *adapter)
 	/* Allocate memory for receiving command response data */
 	skb = dev_alloc_skb(MWIFIEX_UPLD_SIZE);
 	if (!skb) {
-		mwifiex_dbg(adapter, ERROR,
-			    "Unable to allocate skb for command response data.\n");
+		pr_err("Unable to allocate skb for command response data.\n");
 		return -ENOMEM;
 	}
 	skb_put(skb, MWIFIEX_UPLD_SIZE);
@@ -1045,17 +1035,15 @@ static int mwifiex_pcie_alloc_sleep_cookie_buf(struct mwifiex_adapter *adapter)
 	card->sleep_cookie_vbase = pci_alloc_consistent(card->dev, sizeof(u32),
 						     &card->sleep_cookie_pbase);
 	if (!card->sleep_cookie_vbase) {
-		mwifiex_dbg(adapter, ERROR,
-			    "pci_alloc_consistent failed!\n");
+		pr_err("pci_alloc_consistent failed!\n");
 		return -ENOMEM;
 	}
 	/* Init val of Sleep Cookie */
 	tmp = FW_AWAKE_COOKIE;
 	put_unaligned(tmp, card->sleep_cookie_vbase);
 
-	mwifiex_dbg(adapter, INFO,
-		    "alloc_scook: sleep cookie=0x%x\n",
-		    get_unaligned(card->sleep_cookie_vbase));
+	pr_info("alloc_scook: sleep cookie=0x%x\n",
+		get_unaligned(card->sleep_cookie_vbase));
 
 	return 0;
 }
@@ -3069,32 +3057,32 @@ static void mwifiex_pcie_up_dev(struct mwifiex_adapter *adapter)
 	card->cmdrsp_buf = NULL;
 	ret = mwifiex_pcie_create_txbd_ring(adapter);
 	if (ret) {
-		mwifiex_dbg(adapter, ERROR, "Failed to create txbd ring\n");
+		pr_err("Failed to create txbd ring\n");
 		goto err_cre_txbd;
 	}
 
 	ret = mwifiex_pcie_create_rxbd_ring(adapter);
 	if (ret) {
-		mwifiex_dbg(adapter, ERROR, "Failed to create rxbd ring\n");
+		pr_err("Failed to create rxbd ring\n");
 		goto err_cre_rxbd;
 	}
 
 	ret = mwifiex_pcie_create_evtbd_ring(adapter);
 	if (ret) {
-		mwifiex_dbg(adapter, ERROR, "Failed to create evtbd ring\n");
+		pr_err("Failed to create evtbd ring\n");
 		goto err_cre_evtbd;
 	}
 
 	ret = mwifiex_pcie_alloc_cmdrsp_buf(adapter);
 	if (ret) {
-		mwifiex_dbg(adapter, ERROR, "Failed to allocate cmdbuf buffer\n");
+		pr_err("Failed to allocate cmdbuf buffer\n");
 		goto err_alloc_cmdbuf;
 	}
 
 	if (reg->sleep_cookie) {
 		ret = mwifiex_pcie_alloc_sleep_cookie_buf(adapter);
 		if (ret) {
-			mwifiex_dbg(adapter, ERROR, "Failed to allocate sleep_cookie buffer\n");
+			pr_err("Failed to allocate sleep_cookie buffer\n");
 			goto err_alloc_cookie;
 		}
 	} else {
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 58d3da0..596282e 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -631,8 +631,7 @@ static int mwifiex_init_sdio_ioport(struct mwifiex_adapter *adapter)
 	else
 		return -1;
 cont:
-	mwifiex_dbg(adapter, INFO,
-		    "info: SDIO FUNC1 IO port: %#x\n", adapter->ioport);
+	pr_info("info: SDIO FUNC1 IO port: %#x\n", adapter->ioport);
 
 	/* Set Host interrupt reset to read to clear */
 	if (!mwifiex_read_reg(adapter, card->reg->host_int_rsr_reg, &reg))
-- 
1.8.1.4
