Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:49208 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbbGLRId (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jul 2015 13:08:33 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 05/10] iwlwifi: pcie: prepare the device before accessing it
Date: Sun, 12 Jul 2015 20:08:15 +0300
Message-Id: <1436720900-18588-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150712_190846_556411_044D7144)
In-Reply-To: <1436720814.17999.2.camel@intel.com>
References: <1436720814.17999.2.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For 8000 series, we need to access the device to know what
firmware to load. Before we do so, we need to prepare the
device otherwise we might not be able to access the
hardware.

Fixes: c278754a21e6 ("iwlwifi: mvm: support family 8000 B2/C steps")
CC: <stable@vger.kernel.org> [4.1]
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index fe61d0a..6203c4a 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -2551,6 +2551,12 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 		trans->hw_rev = (trans->hw_rev & 0xfff0) |
 				(CSR_HW_REV_STEP(trans->hw_rev << 2) << 2);
 
+		ret = iwl_pcie_prepare_card_hw(trans);
+		if (ret) {
+			IWL_WARN(trans, "Exit HW not ready\n");
+			goto out_pci_disable_msi;
+		}
+
 		/*
 		 * in-order to recognize C step driver should read chip version
 		 * id located at the AUX bus MISC address space.
-- 
2.1.4

