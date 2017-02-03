Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:38016 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753168AbdBCOka (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Feb 2017 09:40:30 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  3 Feb 2017 16:38:04 +0200
Message-Id: <20170203143812.7525-18-luca@coelho.fi> (sfid-20170203_154034_049543_7814D627)
In-Reply-To: <20170203143812.7525-1-luca@coelho.fi>
References: <20170203143812.7525-1-luca@coelho.fi>
Subject: [PATCH 17/25] iwlwifi: pcie: fix the set of DMA memory mask
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Our 9000 device supports 64 bit DMA address for RX only, and
not for TX.
Setting DMA mask to 64 for the whole device is erroneous - we
can do it only for a000 devices where device is capable of
both RX & TX DMA with 64 bit address space.

Fixes: 96a6497bc3ed ("iwlwifi: pcie: add 9000 series multi queue rx DMA support")
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index c1d99d15796d..b28d99f61a35 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2953,16 +2953,12 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 				       PCIE_LINK_STATE_CLKPM);
 	}
 
-	if (cfg->mq_rx_supported)
-		addr_size = 64;
-	else
-		addr_size = 36;
-
 	if (cfg->use_tfh) {
+		addr_size = 64;
 		trans_pcie->max_tbs = IWL_TFH_NUM_TBS;
 		trans_pcie->tfd_size = sizeof(struct iwl_tfh_tfd);
-
 	} else {
+		addr_size = 36;
 		trans_pcie->max_tbs = IWL_NUM_OF_TBS;
 		trans_pcie->tfd_size = sizeof(struct iwl_tfd);
 	}
-- 
2.11.0
