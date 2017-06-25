Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35088 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751128AbdFYLNx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Jun 2017 07:13:53 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 25 Jun 2017 14:11:54 +0300
Message-Id: <20170625111158.1792-23-luca@coelho.fi> (sfid-20170625_131355_987971_46EF6F4C)
In-Reply-To: <20170625111158.1792-1-luca@coelho.fi>
References: <20170625111158.1792-1-luca@coelho.fi>
Subject: [PATCH 22/26] iwlwifi: pcie: reduce unwanted noise in the logs
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

The driver prints "L1 Enabled - LTR Enabled" all the time as dev_info,
which is just useless noise in most cases.  Convert this to
IWL_DEBUG_POWER() so we don't pollute the log unnecessarily but still
can get this info on demand.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 106e822308c7..233b6734c237 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -224,9 +224,9 @@ void iwl_pcie_apm_config(struct iwl_trans *trans)
 
 	pcie_capability_read_word(trans_pcie->pci_dev, PCI_EXP_DEVCTL2, &cap);
 	trans->ltr_enabled = cap & PCI_EXP_DEVCTL2_LTR_EN;
-	dev_info(trans->dev, "L1 %sabled - LTR %sabled\n",
-		 (lctl & PCI_EXP_LNKCTL_ASPM_L1) ? "En" : "Dis",
-		 trans->ltr_enabled ? "En" : "Dis");
+	IWL_DEBUG_POWER(trans, "L1 %sabled - LTR %sabled\n",
+			(lctl & PCI_EXP_LNKCTL_ASPM_L1) ? "En" : "Dis",
+			trans->ltr_enabled ? "En" : "Dis");
 }
 
 /*
-- 
2.11.0
