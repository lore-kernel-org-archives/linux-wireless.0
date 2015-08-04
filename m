Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37368 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754805AbbHDU7G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 16:59:06 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/37] iwlwifi: pcie: add missing calls to synchronize_irq()
Date: Tue,  4 Aug 2015 23:43:05 +0300
Message-Id: <1438721007-23283-15-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150804_230717_073959_6B3485B5)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In a few places, we were disabling interrupts but didn't
make sure that the interrupt handler has finished running.
Add calls to synchronize_irq() to ensure we finish handling
the interrupts before we free resources or other things that
could lead to a crash if the interrupt were to be handled
later.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 23f2824..4cdfb2f 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1178,6 +1178,8 @@ void iwl_trans_pcie_rf_kill(struct iwl_trans *trans, bool state)
 
 static void iwl_trans_pcie_d3_suspend(struct iwl_trans *trans, bool test)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+
 	iwl_disable_interrupts(trans);
 
 	/*
@@ -1189,6 +1191,8 @@ static void iwl_trans_pcie_d3_suspend(struct iwl_trans *trans, bool test)
 
 	iwl_pcie_disable_ict(trans);
 
+	synchronize_irq(trans_pcie->pci_dev->irq);
+
 	iwl_clear_bit(trans, CSR_GP_CNTRL,
 		      CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 	iwl_clear_bit(trans, CSR_GP_CNTRL,
@@ -1326,7 +1330,10 @@ static void iwl_trans_pcie_op_mode_leave(struct iwl_trans *trans)
 	spin_unlock(&trans_pcie->irq_lock);
 
 	iwl_pcie_disable_ict(trans);
+
 	mutex_unlock(&trans_pcie->mutex);
+
+	synchronize_irq(trans_pcie->pci_dev->irq);
 }
 
 static void iwl_trans_pcie_write8(struct iwl_trans *trans, u32 ofs, u8 val)
-- 
2.1.4

