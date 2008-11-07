Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:30374 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218AbYKGR6T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2008 12:58:19 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, "Zhu, Yi" <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 13/13] iwlwifi: use Rx single frame mode (one Rx frame per RB)
Date: Fri,  7 Nov 2008 09:58:46 -0800
Message-Id: <1226080726-24860-14-git-send-email-reinette.chatre@intel.com> (sfid-20081107_190902_973855_80D13144)
In-Reply-To: <1226080726-24860-13-git-send-email-reinette.chatre@intel.com>
References: <>
 <1226080726-24860-1-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-2-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-3-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-4-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-5-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-6-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-7-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-8-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-9-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-10-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-11-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-12-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-13-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu, Yi <yi.zhu@intel.com>

The RCSR default value for single frame mode is off (a RB contains more than
one frames). But the driver assumes single frame mode apparently. This patch
enables single frame mode for the hardware. It also adds a BUG_ON to make sure
the allocated skb satisfies the hardware alignment requirement and removes
a useless check.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fh.h |    2 ++
 drivers/net/wireless/iwlwifi/iwl-rx.c |    8 ++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index 2c5f919..e46300c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -266,6 +266,8 @@
 #define FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_NO_INT_VAL    (0x00000000)
 #define FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_INT_HOST_VAL  (0x00001000)
 
+#define FH_RCSR_CHNL0_RX_CONFIG_SINGLE_FRAME	(0x00008000)
+
 
 /**
  * Rx Shared Status Registers (RSSR)
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 516cd11..90e6648 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -218,8 +218,7 @@ int iwl_rx_queue_restock(struct iwl_priv *priv)
 
 	/* If we've added more space for the firmware to place data, tell it.
 	 * Increment device's write pointer in multiples of 8. */
-	if ((write != (rxq->write & ~0x7))
-	    || (abs(rxq->write - rxq->read) > 7)) {
+	if (write != (rxq->write & ~0x7)) {
 		spin_lock_irqsave(&rxq->lock, flags);
 		rxq->need_update = 1;
 		spin_unlock_irqrestore(&rxq->lock, flags);
@@ -268,6 +267,10 @@ void iwl_rx_allocate(struct iwl_priv *priv)
 		/* Get physical address of RB/SKB */
 		rxb->dma_addr = pci_map_single(priv->pci_dev, rxb->skb->data,
 			   priv->hw_params.rx_buf_size, PCI_DMA_FROMDEVICE);
+
+		/* RBD must be 256 bytes aligned and no more than 36 bits */
+		BUG_ON(rxb->dma_addr & (~DMA_BIT_MASK(36) & 0xff));
+
 		list_add_tail(&rxb->list, &rxq->rx_free);
 		rxq->free_count++;
 	}
@@ -431,6 +434,7 @@ int iwl_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 			   FH_RCSR_RX_CONFIG_CHNL_EN_ENABLE_VAL |
 			   FH_RCSR_CHNL0_RX_IGNORE_RXF_EMPTY |
 			   FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_INT_HOST_VAL |
+			   FH_RCSR_CHNL0_RX_CONFIG_SINGLE_FRAME |
 			   rb_size|
 			   (rb_timeout << FH_RCSR_RX_CONFIG_REG_IRQ_RBTH_POS)|
 			   (rfdnlog << FH_RCSR_RX_CONFIG_RBDCB_SIZE_POS));
-- 
1.5.4.3

