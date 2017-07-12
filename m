Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20489 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933180AbdGLHxQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Jul 2017 03:53:16 -0400
Date: Wed, 12 Jul 2017 10:53:00 +0300
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
Subject: [PATCH] iwlwifi: pcie: Fix error code in iwl_trans_pcie_alloc()
Message-ID: <20170712075300.sbd2vlwqf4rriale@mwanda> (sfid-20170712_095320_702407_211A1D38)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We accidentally forgot to propogate the error code on this path.  It
means we return ERR_PTR(0) which is NULL and it results in a NULL
dereference in the caller.

Fixes: 2e5d4a8f61dc ("iwlwifi: pcie: Add new configuration to enable MSIX")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

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
