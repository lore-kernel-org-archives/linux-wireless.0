Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60828 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752922AbcGCTtG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jul 2016 15:49:06 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
Date: Sun,  3 Jul 2016 22:48:48 +0300
Message-Id: <1467575332-32112-9-git-send-email-luca@coelho.fi> (sfid-20160703_214918_562619_9848EC8E)
In-Reply-To: <467405215.1837.15.camel@coelho.fi>
References: <467405215.1837.15.camel@coelho.fi>
Subject: [PATCH 09/13] iwlwifi: pcie: set RB chunk size per bus
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

For 9000 devices we can have PCIe bus for discrete
devices and IOSF bus for integrated devices.
PCIe supports maximum transfer size of 128B while IOSF
bus supports maximum transfer size of 64B.
Configure RB size accordingly.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h  | 4 +++-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 8 ++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
index 270f39e..f08cdee 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
@@ -384,7 +384,9 @@ static inline unsigned int FH_MEM_CBBC_QUEUE(unsigned int chnl)
 #define RFH_GEN_CFG	0xA09800
 #define RFH_GEN_CFG_SERVICE_DMA_SNOOP	BIT(0)
 #define RFH_GEN_CFG_RFH_DMA_SNOOP	BIT(1)
-#define RFH_GEN_CFG_RB_CHUNK_SIZE	BIT(4) /* 0 - 64B, 1- 128B */
+#define RFH_GEN_CFG_RB_CHUNK_SIZE_POS	4
+#define RFH_GEN_CFG_RB_CHUNK_SIZE_128	1
+#define RFH_GEN_CFG_RB_CHUNK_SIZE_64	0
 #define RFH_GEN_CFG_DEFAULT_RXQ_NUM_MASK 0xF00
 #define RFH_GEN_CFG_DEFAULT_RXQ_NUM_POS 8
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index f1e309d..27ff74d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -848,13 +848,17 @@ static void iwl_pcie_rx_mq_hw_init(struct iwl_trans *trans)
 
 	/*
 	 * Activate DMA snooping.
-	 * Set RX DMA chunk size to 64B
+	 * Set RX DMA chunk size to 64B for IOSF and 128B for PCIe
 	 * Default queue is 0
 	 */
 	iwl_write_prph_no_grab(trans, RFH_GEN_CFG, RFH_GEN_CFG_RFH_DMA_SNOOP |
 			       (DEFAULT_RXQ_NUM <<
 				RFH_GEN_CFG_DEFAULT_RXQ_NUM_POS) |
-			       RFH_GEN_CFG_SERVICE_DMA_SNOOP);
+			       RFH_GEN_CFG_SERVICE_DMA_SNOOP |
+			       (trans->cfg->integrated ?
+				RFH_GEN_CFG_RB_CHUNK_SIZE_64 :
+				RFH_GEN_CFG_RB_CHUNK_SIZE_128) <<
+			       RFH_GEN_CFG_RB_CHUNK_SIZE_POS);
 	/* Enable the relevant rx queues */
 	iwl_write_prph_no_grab(trans, RFH_RXF_RXQ_ACTIVE, enabled);
 
-- 
2.8.1

