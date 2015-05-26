Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbbEZTTC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:19:02 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Avri Altman <avri.altman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 33/39] iwlwifi: pcie: Remove redundant check for family type
Date: Tue, 26 May 2015 22:17:46 +0300
Message-Id: <1432667872-18092-33-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150526_211925_775876_730D03E5)
In-Reply-To: <1432667798.26624.3.camel@intel.com>
References: <1432667798.26624.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

This check for family type is redundant as the if clause above
checks a family-dependent Boolean (which is not set for family 8000 anyway).

Signed-off-by: Avri Altman <avri.altman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/tx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 5ef8044..2b86c21 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -1049,8 +1049,6 @@ static int iwl_pcie_set_cmd_in_flight(struct iwl_trans *trans,
 	    !trans_pcie->cmd_hold_nic_awake) {
 		__iwl_trans_pcie_set_bit(trans, CSR_GP_CNTRL,
 					 CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-		if (trans->cfg->device_family == IWL_DEVICE_FAMILY_8000)
-			udelay(2);
 
 		ret = iwl_poll_bit(trans, CSR_GP_CNTRL,
 				   CSR_GP_CNTRL_REG_VAL_MAC_ACCESS_EN,
-- 
2.1.4

