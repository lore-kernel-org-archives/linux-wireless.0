Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mxout1.netvision.net.il ([194.90.9.20]:47609 "EHLO
	mxout1.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965093Ab3FTNqO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jun 2013 09:46:14 -0400
Received: from localhost.localdomain ([82.166.196.250])
 by mxout1.netvision.net.il
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MOP007E628VQQC0@mxout1.netvision.net.il> for
 linux-wireless@vger.kernel.org; Thu, 20 Jun 2013 16:46:13 +0300 (IDT)
From: Kirshenbaum Erez <erezk@wilocity.com>
To: qca_vkondrat@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org,
	Kirshenbaum Erez <erezk@wilocity.com>
Subject: [PATCH 2/2] wil6210: add HW write-back option in TX descriptor
Date: Thu, 20 Jun 2013 15:45:40 +0300
Message-id: <1371732340-4149-1-git-send-email-erezk@wilocity.com> (sfid-20130620_154641_762881_D2787FD3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Map BIT 9 in TX DMA DWARD 0 as HW write back option.
We must turn on this option in the last TX descriptor,
this is required for old HW compatability.
This option indicate to HW that WB is required for this descriptor.

Signed-off-by: Kirshenbaum Erez <erezk@wilocity.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 2 +-
 drivers/net/wireless/ath/wil6210/txrx.h | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index b79ba10..c3e763c 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -709,7 +709,7 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	}
 	/* for the last seg only */
 	d->dma.d0 |= BIT(DMA_CFG_DESC_TX_0_CMD_EOP_POS);
-	d->dma.d0 |= BIT(9); /* BUG: undocumented bit */
+	d->dma.d0 |= BIT(DMA_CFG_DESC_TX_0_CMD_MARK_WB_POS);
 	d->dma.d0 |= BIT(DMA_CFG_DESC_TX_0_CMD_DMA_IT_POS);
 	*_d = *d;
 
diff --git a/drivers/net/wireless/ath/wil6210/txrx.h b/drivers/net/wireless/ath/wil6210/txrx.h
index 23c0781..859aea6 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.h
+++ b/drivers/net/wireless/ath/wil6210/txrx.h
@@ -201,6 +201,10 @@ struct vring_tx_mac {
 #define DMA_CFG_DESC_TX_0_CMD_EOP_LEN 1
 #define DMA_CFG_DESC_TX_0_CMD_EOP_MSK 0x100
 
+#define DMA_CFG_DESC_TX_0_CMD_MARK_WB_POS 9
+#define DMA_CFG_DESC_TX_0_CMD_MARK_WB_LEN 1
+#define DMA_CFG_DESC_TX_0_CMD_MARK_WB_MSK 0x200
+
 #define DMA_CFG_DESC_TX_0_CMD_DMA_IT_POS 10
 #define DMA_CFG_DESC_TX_0_CMD_DMA_IT_LEN 1
 #define DMA_CFG_DESC_TX_0_CMD_DMA_IT_MSK 0x400
-- 
1.7.11.7

