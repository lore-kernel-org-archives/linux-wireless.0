Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:52687 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbaL3OTs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 09:19:48 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/33] iwlwifi: pcie: let the Manageability Engine know when we leave
Date: Tue, 30 Dec 2014 16:18:40 +0200
Message-Id: <1419949148-24046-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141230_151956_407020_35F09C5B)
In-Reply-To: <1419948357.21410.4.camel@egrumbacBox>
References: <1419948357.21410.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the driver is unload, the Manageability Engine should
know about that - send an event to inform it about this
event.

Reviewed-by: Reuven Borok <reuven.borok@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-csr.h    |  1 +
 drivers/net/wireless/iwlwifi/iwl-prph.h   |  1 +
 drivers/net/wireless/iwlwifi/pcie/trans.c | 21 ++++++++++++++++++---
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index aff63c3..7f40cf3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -184,6 +184,7 @@
 #define CSR_HW_IF_CONFIG_REG_BIT_NIC_READY	(0x00400000) /* PCI_OWN_SEM */
 #define CSR_HW_IF_CONFIG_REG_BIT_NIC_PREPARE_DONE (0x02000000) /* ME_OWN */
 #define CSR_HW_IF_CONFIG_REG_PREPARE		  (0x08000000) /* WAKE_ME */
+#define CSR_HW_IF_CONFIG_REG_ENABLE_PME		  (0x10000000)
 #define CSR_HW_IF_CONFIG_REG_PERSIST_MODE	  (0x40000000) /* PERSISTENCE */
 
 #define CSR_MBOX_SET_REG_OS_ALIVE		BIT(5)
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index 2df51ea..ea3b970 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -99,6 +99,7 @@
 
 #define APMG_PCIDEV_STT_VAL_PERSIST_DIS	(0x00000200)
 #define APMG_PCIDEV_STT_VAL_L1_ACT_DIS	(0x00000800)
+#define APMG_PCIDEV_STT_VAL_WAKE_ME	(0x00004000)
 
 #define APMG_RTC_INT_STT_RFKILL		(0x10000000)
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 5d79a1f..4b42de3 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -443,10 +443,25 @@ static int iwl_pcie_apm_stop_master(struct iwl_trans *trans)
 	return ret;
 }
 
-static void iwl_pcie_apm_stop(struct iwl_trans *trans)
+static void iwl_pcie_apm_stop(struct iwl_trans *trans, bool op_mode_leave)
 {
 	IWL_DEBUG_INFO(trans, "Stop card, put in low power state\n");
 
+	if (op_mode_leave) {
+		if (!test_bit(STATUS_DEVICE_ENABLED, &trans->status))
+			iwl_pcie_apm_init(trans);
+
+		/* inform ME that we are leaving */
+		if (trans->cfg->device_family == IWL_DEVICE_FAMILY_7000)
+			iwl_set_bits_prph(trans, APMG_PCIDEV_STT_REG,
+					  APMG_PCIDEV_STT_VAL_WAKE_ME);
+		else if (trans->cfg->device_family == IWL_DEVICE_FAMILY_8000)
+			iwl_set_bit(trans, CSR_HW_IF_CONFIG_REG,
+				    CSR_HW_IF_CONFIG_REG_PREPARE |
+				    CSR_HW_IF_CONFIG_REG_ENABLE_PME);
+		mdelay(5);
+	}
+
 	clear_bit(STATUS_DEVICE_ENABLED, &trans->status);
 
 	/* Stop device's DMA activity */
@@ -1010,7 +1025,7 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 		      CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 
 	/* Stop the device, and put it in low power state */
-	iwl_pcie_apm_stop(trans);
+	iwl_pcie_apm_stop(trans, false);
 
 	/* Upon stop, the APM issues an interrupt if HW RF kill is set.
 	 * Clean again the interrupt here
@@ -1187,7 +1202,7 @@ static void iwl_trans_pcie_op_mode_leave(struct iwl_trans *trans)
 	iwl_disable_interrupts(trans);
 	spin_unlock(&trans_pcie->irq_lock);
 
-	iwl_pcie_apm_stop(trans);
+	iwl_pcie_apm_stop(trans, true);
 
 	spin_lock(&trans_pcie->irq_lock);
 	iwl_disable_interrupts(trans);
-- 
1.9.1

