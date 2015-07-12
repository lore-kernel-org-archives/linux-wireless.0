Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:20159 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413AbbGLRId (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jul 2015 13:08:33 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: "Dreyfuss, Haim" <haim.dreyfuss@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/10] iwlwifi: pcie: Fix bug in NIC's PM registers access
Date: Sun, 12 Jul 2015 20:08:13 +0300
Message-Id: <1436720900-18588-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150712_190848_450729_1F65C917)
In-Reply-To: <1436720814.17999.2.camel@intel.com>
References: <1436720814.17999.2.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Dreyfuss, Haim" <haim.dreyfuss@intel.com>

While cleanig the access to those hw-dependent registers,
instead of using the product family type, wrong condition was added
mistakenly and enabled 8000 family devices a forbidden access
to HW registers, fix it.

Fixes: 95411d0455cc ("iwlwifi: pcie: Control access to the NIC's PM registers via iwl_cfg")
Signed-off-by: Dreyfuss, Haim <haim.dreyfuss@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 43ae658..608ba1e 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -182,7 +182,7 @@ static void iwl_trans_pcie_write_shr(struct iwl_trans *trans, u32 reg, u32 val)
 
 static void iwl_pcie_set_pwr(struct iwl_trans *trans, bool vaux)
 {
-	if (!trans->cfg->apmg_not_supported)
+	if (trans->cfg->apmg_not_supported)
 		return;
 
 	if (vaux && pci_pme_capable(to_pci_dev(trans->dev), PCI_D3cold))
-- 
2.1.4

