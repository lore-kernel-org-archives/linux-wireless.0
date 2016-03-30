Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:47797 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856AbcC3OFr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:05:47 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/43] iwlwifi: pcie: enable interrupts explicitly on resume
Date: Wed, 30 Mar 2016 17:04:40 +0300
Message-Id: <1459346715-7954-8-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_160550_130490_D326A5D3)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

When entering suspend the driver calls iwl_disable_interrupts() and
then iwl_pcie_disable_ict().
On resume the driver calls only iwl_pcie_reset_ict() without calling
explicitly to iwl_enable_interrupts().
This mostly works since iwl_pcie_reset_ict is calling to
iwl_enable_interrupts, but it doesn't work when there is no ict_table
in MSIx mode.
The result is that driver tries to resume but fails since it doesn't
get the RX interrupt from FW indicating that d0i3 exit was completed.
Fix it by adding an explicit call to enable interrupts.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index eb39c7e..d4306e2 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1321,6 +1321,7 @@ static int iwl_trans_pcie_d3_resume(struct iwl_trans *trans,
 	 * after this call.
 	 */
 	iwl_pcie_reset_ict(trans);
+	iwl_enable_interrupts(trans);
 
 	iwl_set_bit(trans, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 	iwl_set_bit(trans, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
-- 
2.5.0

