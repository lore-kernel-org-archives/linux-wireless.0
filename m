Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:40187 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbZHRDxF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 23:53:05 -0400
Date: Tue, 18 Aug 2009 05:53:07 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 13/29] mwl8k: don't touch 'command done' interrupt during firmware load
Message-ID: <20090818035307.GR18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since firmware load commands don't generate 'command done' interrupts
like normal commands do, polling for command done interrupts just
unnecessarily slows down the firmware load process.  Removing this bit
of code speeds up loading a typical firmware image from 840 msec to
180 msec.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   24 +-----------------------
 1 files changed, 1 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index f4b197b..86b6b5d 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -411,7 +411,6 @@ mwl8k_send_fw_load_cmd(struct mwl8k_priv *priv, void *data, int length)
 {
 	void __iomem *regs = priv->regs;
 	dma_addr_t dma_addr;
-	int rc;
 	int loops;
 
 	dma_addr = pci_map_single(priv->pdev, data, length, PCI_DMA_TODEVICE);
@@ -425,7 +424,6 @@ mwl8k_send_fw_load_cmd(struct mwl8k_priv *priv, void *data, int length)
 	iowrite32(MWL8K_H2A_INT_DUMMY,
 		regs + MWL8K_HIU_H2A_INTERRUPT_EVENTS);
 
-	rc = -ETIMEDOUT;
 	loops = 1000;
 	do {
 		u32 int_code;
@@ -433,7 +431,6 @@ mwl8k_send_fw_load_cmd(struct mwl8k_priv *priv, void *data, int length)
 		int_code = ioread32(regs + MWL8K_HIU_INT_CODE);
 		if (int_code == MWL8K_INT_CODE_CMD_FINISHED) {
 			iowrite32(0, regs + MWL8K_HIU_INT_CODE);
-			rc = 0;
 			break;
 		}
 
@@ -442,26 +439,7 @@ mwl8k_send_fw_load_cmd(struct mwl8k_priv *priv, void *data, int length)
 
 	pci_unmap_single(priv->pdev, dma_addr, length, PCI_DMA_TODEVICE);
 
-	/*
-	 * Clear 'command done' interrupt bit.
-	 */
-	loops = 1000;
-	do {
-		u32 status;
-
-		status = ioread32(priv->regs +
-				MWL8K_HIU_A2H_INTERRUPT_STATUS);
-		if (status & MWL8K_A2H_INT_OPC_DONE) {
-			iowrite32(~MWL8K_A2H_INT_OPC_DONE,
-				priv->regs + MWL8K_HIU_A2H_INTERRUPT_STATUS);
-			ioread32(priv->regs + MWL8K_HIU_A2H_INTERRUPT_STATUS);
-			break;
-		}
-
-		udelay(1);
-	} while (--loops);
-
-	return rc;
+	return loops ? 0 : -ETIMEDOUT;
 }
 
 static int mwl8k_load_fw_image(struct mwl8k_priv *priv,
-- 
1.5.6.4
