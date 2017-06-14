Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41483 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752486AbdFNKp0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Jun 2017 06:45:26 -0400
Date: Wed, 14 Jun 2017 13:44:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Berg <johannes.berg@intel.com>,
        Haim Dreyfuss <haim.dreyfuss@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sara Sharon <sara.sharon@intel.com>,
        Liad Kaufman <liad.kaufman@intel.com>,
        Sharon Dvir <sharon.dvir@intel.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] iwlwifi: missing error code in iwl_trans_pcie_alloc()
Message-ID: <20170614104450.GN29394@elgon.mountain> (sfid-20170614_124535_370222_03E5ABDC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We don't set the error code here so we end up returning ERR_PTR(0) which
is NULL.  The caller doesn't expect that so it results in a NULL
dereference.

Fixes: 2e5d4a8f61dc ("iwlwifi: pcie: Add new configuration to enable MSIX")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index a3c5d3b195ad..24420314f91b 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3100,7 +3100,8 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	init_waitqueue_head(&trans_pcie->d0i3_waitq);
 
 	if (trans_pcie->msix_enabled) {
-		if (iwl_pcie_init_msix_handler(pdev, trans_pcie))
+		ret = iwl_pcie_init_msix_handler(pdev, trans_pcie);
+		if (ret)
 			goto out_no_pci;
 	 } else {
 		ret = iwl_pcie_alloc_ict(trans);
