Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:37324 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750885AbdGEGFu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Jul 2017 02:05:50 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  5 Jul 2017 09:05:36 +0300
Message-Id: <20170705060539.20737-5-luca@coelho.fi> (sfid-20170705_080554_753363_51923336)
In-Reply-To: <20170705060539.20737-1-luca@coelho.fi>
References: <20170705060539.20737-1-luca@coelho.fi>
Subject: [PATCH 4/7] iwlwifi: missing error code in iwl_trans_pcie_alloc()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Carpenter <dan.carpenter@oracle.com>

We don't set the error code here so we end up returning ERR_PTR(0) which
is NULL.  The caller doesn't expect that so it results in a NULL
dereference.

Fixes: 2e5d4a8f61dc ("iwlwifi: pcie: Add new configuration to enable MSIX")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 92b3a55d0fbc..f95eec52508e 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3150,7 +3150,8 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	init_waitqueue_head(&trans_pcie->d0i3_waitq);
 
 	if (trans_pcie->msix_enabled) {
-		if (iwl_pcie_init_msix_handler(pdev, trans_pcie))
+		ret = iwl_pcie_init_msix_handler(pdev, trans_pcie);
+		if (ret)
 			goto out_no_pci;
 	 } else {
 		ret = iwl_pcie_alloc_ict(trans);
-- 
2.11.0
