Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4720 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900AbbEZTR5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:17:57 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/39] iwlwifi: pcie: don't call set_pwr functions for family 8000
Date: Tue, 26 May 2015 22:17:14 +0300
Message-Id: <1432667872-18092-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150526_212106_631428_2889E564)
In-Reply-To: <1432667798.26624.3.camel@intel.com>
References: <1432667798.26624.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

We should not call the iwl_pcie_set_pwr() functions in the
suspend/resume flows for family 8000, because the register used is
locked in devices from this family.  Doing this causes an NMI
protection error (RT_NMI_INTERRUPT_PREG_PROTECTION).

To fix this, skip those calls if the device family is
IWL_DEVICE_FAMILY_8000.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 8e5be8d..d894338 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1164,7 +1164,8 @@ static void iwl_trans_pcie_d3_suspend(struct iwl_trans *trans, bool test)
 	 */
 	iwl_trans_pcie_tx_reset(trans);
 
-	iwl_pcie_set_pwr(trans, true);
+	if (trans->cfg->device_family != IWL_DEVICE_FAMILY_8000)
+		iwl_pcie_set_pwr(trans, true);
 }
 
 static int iwl_trans_pcie_d3_resume(struct iwl_trans *trans,
@@ -1202,7 +1203,8 @@ static int iwl_trans_pcie_d3_resume(struct iwl_trans *trans,
 		return ret;
 	}
 
-	iwl_pcie_set_pwr(trans, false);
+	if (trans->cfg->device_family != IWL_DEVICE_FAMILY_8000)
+		iwl_pcie_set_pwr(trans, false);
 
 	iwl_trans_pcie_tx_reset(trans);
 
-- 
2.1.4

