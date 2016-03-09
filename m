Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:42134 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933551AbcCIRp7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 12:45:59 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/21] iwlwifi: pcie: set RB chunk size back to 64
Date: Wed,  9 Mar 2016 19:45:32 +0200
Message-Id: <1457545550-30677-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160309_184605_331754_15C36F88)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA64B1D@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA64B1D@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

128 byte chunk size is supported only on PCIe and not
on IOSF. For now, change it back to 64 byte.

Reported-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index a310fd2..509f790 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -801,11 +801,10 @@ static void iwl_pcie_rx_mq_hw_init(struct iwl_trans *trans)
 
 	/*
 	 * Activate DMA snooping.
-	 * Set RX DMA chunk size to 128 bit
+	 * Set RX DMA chunk size to 64B
 	 * Default queue is 0
 	 */
 	iwl_write_prph(trans, RFH_GEN_CFG, RFH_GEN_CFG_RFH_DMA_SNOOP |
-		       RFH_GEN_CFG_RB_CHUNK_SIZE |
 		       (DEFAULT_RXQ_NUM << RFH_GEN_CFG_DEFAULT_RXQ_NUM_POS) |
 		       RFH_GEN_CFG_SERVICE_DMA_SNOOP);
 	/* Enable the relevant rx queues */
-- 
2.5.0

