Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37379 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932069AbbHDU7O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 16:59:14 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 30/37] iwlwifi: call d3_suspend/resume in d0i3 case as well
Date: Tue,  4 Aug 2015 23:43:20 +0300
Message-Id: <1438721007-23283-30-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150804_230717_456421_24CEF66F)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Some CSR registers have to be configured also
in case of suspend/resume with unified image
(which doesn't includes reconfiguration flow).

Reuse the existing d3_suspend/d3_resume trans ops,
while making sure some configurations are a bit
different, according to the wowlan type.

After this change, we no longer need the special
wowlan_d0i3 configurations done in iwl_pci_resume,
as they are already being done in the d3_resume op.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c     |  6 ++++++
 drivers/net/wireless/iwlwifi/pcie/drv.c   | 13 +++--------
 drivers/net/wireless/iwlwifi/pcie/trans.c | 36 +++++++++++++++++++++----------
 3 files changed, 34 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 68d7218..a85be4e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -1187,6 +1187,9 @@ int iwl_mvm_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 		mutex_lock(&mvm->d0i3_suspend_mutex);
 		__set_bit(D0I3_DEFER_WAKEUP, &mvm->d0i3_suspend_flags);
 		mutex_unlock(&mvm->d0i3_suspend_mutex);
+
+		iwl_trans_d3_suspend(mvm->trans, false);
+
 		return 0;
 	}
 
@@ -1949,6 +1952,9 @@ static int iwl_mvm_resume_d3(struct iwl_mvm *mvm)
 static int iwl_mvm_resume_d0i3(struct iwl_mvm *mvm)
 {
 	bool exit_now;
+	enum iwl_d3_status d3_status;
+
+	iwl_trans_d3_resume(mvm->trans, &d3_status, false);
 
 	/*
 	 * make sure to clear D0I3_DEFER_WAKEUP before
diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index dbd2a03..cdf3a0c 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -631,17 +631,10 @@ static int iwl_pci_resume(struct device *device)
 		return 0;
 
 	/*
-	 * On suspend, ict is disabled, and the interrupt mask
-	 * gets cleared. Reconfigure them both in case of d0i3
-	 * image. Otherwise, only enable rfkill interrupt (in
-	 * order to keep track of the rfkill status)
+	 * Enable rfkill interrupt (in order to keep track of
+	 * the rfkill status)
 	 */
-	if (trans->wowlan_d0i3) {
-		iwl_pcie_reset_ict(trans);
-		iwl_enable_interrupts(trans);
-	} else {
-		iwl_enable_rfkill_int(trans);
-	}
+	iwl_enable_rfkill_int(trans);
 
 	hw_rfkill = iwl_is_rfkill_set(trans);
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 46e900e..cbc29cc 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1189,6 +1189,12 @@ static void iwl_trans_pcie_d3_suspend(struct iwl_trans *trans, bool test)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
+	if (trans->wowlan_d0i3) {
+		/* Enable persistence mode to avoid reset */
+		iwl_set_bit(trans, CSR_HW_IF_CONFIG_REG,
+			    CSR_HW_IF_CONFIG_REG_PERSIST_MODE);
+	}
+
 	iwl_disable_interrupts(trans);
 
 	/*
@@ -1207,12 +1213,14 @@ static void iwl_trans_pcie_d3_suspend(struct iwl_trans *trans, bool test)
 	iwl_clear_bit(trans, CSR_GP_CNTRL,
 		      CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 
-	/*
-	 * reset TX queues -- some of their registers reset during S3
-	 * so if we don't reset everything here the D3 image would try
-	 * to execute some invalid memory upon resume
-	 */
-	iwl_trans_pcie_tx_reset(trans);
+	if (!trans->wowlan_d0i3) {
+		/*
+		 * reset TX queues -- some of their registers reset during S3
+		 * so if we don't reset everything here the D3 image would try
+		 * to execute some invalid memory upon resume
+		 */
+		iwl_trans_pcie_tx_reset(trans);
+	}
 
 	iwl_pcie_set_pwr(trans, true);
 }
@@ -1254,12 +1262,18 @@ static int iwl_trans_pcie_d3_resume(struct iwl_trans *trans,
 
 	iwl_pcie_set_pwr(trans, false);
 
-	iwl_trans_pcie_tx_reset(trans);
+	if (trans->wowlan_d0i3) {
+		iwl_clear_bit(trans, CSR_GP_CNTRL,
+			      CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+	} else {
+		iwl_trans_pcie_tx_reset(trans);
 
-	ret = iwl_pcie_rx_init(trans);
-	if (ret) {
-		IWL_ERR(trans, "Failed to resume the device (RX reset)\n");
-		return ret;
+		ret = iwl_pcie_rx_init(trans);
+		if (ret) {
+			IWL_ERR(trans,
+				"Failed to resume the device (RX reset)\n");
+			return ret;
+		}
 	}
 
 	val = iwl_read32(trans, CSR_RESET);
-- 
2.1.4

