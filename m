Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:44025 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbbEZTSC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:18:02 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>, <stable@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/39] iwlwifi: pcie: fix tracking of cmd_in_flight
Date: Tue, 26 May 2015 22:17:16 +0300
Message-Id: <1432667872-18092-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150526_212056_572628_7621F387)
In-Reply-To: <1432667798.26624.3.camel@intel.com>
References: <1432667798.26624.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

The cmd_in_flight tracking was introduced to workaround faulty
power management hardware, by having the driver keep the NIC
awake as long as there are commands in flight. However, some of
the code handling this workaround was unconditionally executed,
which resulted with an inconsistent state where the driver assumed
that the NIC was awake although it wasn't.

Fix this by renaming 'cmd_in_flight' to 'cmd_hold_nic_awake' and
handling the NIC requested awake state only for hardwares for
which the workaround is needed.

CC: <stable@vger.kernel.org> [4.1]
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/internal.h |  6 +++---
 drivers/net/wireless/iwlwifi/pcie/trans.c    |  4 ++--
 drivers/net/wireless/iwlwifi/pcie/tx.c       | 23 +++++++++--------------
 3 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index 01996c9..376b84e 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -1,7 +1,7 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2003 - 2015 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
@@ -320,7 +320,7 @@ struct iwl_trans_pcie {
 
 	/*protect hw register */
 	spinlock_t reg_lock;
-	bool cmd_in_flight;
+	bool cmd_hold_nic_awake;
 	bool ref_cmd_in_flight;
 
 	/* protect ref counter */
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index d894338..1cb1204 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1392,7 +1392,7 @@ static bool iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans, bool silent,
 
 	spin_lock_irqsave(&trans_pcie->reg_lock, *flags);
 
-	if (trans_pcie->cmd_in_flight)
+	if (trans_pcie->cmd_hold_nic_awake)
 		goto out;
 
 	/* this bit wakes up the NIC */
@@ -1458,7 +1458,7 @@ static void iwl_trans_pcie_release_nic_access(struct iwl_trans *trans,
 	 */
 	__acquire(&trans_pcie->reg_lock);
 
-	if (trans_pcie->cmd_in_flight)
+	if (trans_pcie->cmd_hold_nic_awake)
 		goto out;
 
 	__iwl_trans_pcie_clear_bit(trans, CSR_GP_CNTRL,
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 06952aa..5ef8044 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -1039,18 +1039,14 @@ static int iwl_pcie_set_cmd_in_flight(struct iwl_trans *trans,
 		iwl_trans_pcie_ref(trans);
 	}
 
-	if (trans_pcie->cmd_in_flight)
-		return 0;
-
-	trans_pcie->cmd_in_flight = true;
-
 	/*
 	 * wake up the NIC to make sure that the firmware will see the host
 	 * command - we will let the NIC sleep once all the host commands
 	 * returned. This needs to be done only on NICs that have
 	 * apmg_wake_up_wa set.
 	 */
-	if (trans->cfg->base_params->apmg_wake_up_wa) {
+	if (trans->cfg->base_params->apmg_wake_up_wa &&
+	    !trans_pcie->cmd_hold_nic_awake) {
 		__iwl_trans_pcie_set_bit(trans, CSR_GP_CNTRL,
 					 CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 		if (trans->cfg->device_family == IWL_DEVICE_FAMILY_8000)
@@ -1064,10 +1060,10 @@ static int iwl_pcie_set_cmd_in_flight(struct iwl_trans *trans,
 		if (ret < 0) {
 			__iwl_trans_pcie_clear_bit(trans, CSR_GP_CNTRL,
 					CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-			trans_pcie->cmd_in_flight = false;
 			IWL_ERR(trans, "Failed to wake NIC for hcmd\n");
 			return -EIO;
 		}
+		trans_pcie->cmd_hold_nic_awake = true;
 	}
 
 	return 0;
@@ -1085,15 +1081,14 @@ static int iwl_pcie_clear_cmd_in_flight(struct iwl_trans *trans)
 		iwl_trans_pcie_unref(trans);
 	}
 
-	if (WARN_ON(!trans_pcie->cmd_in_flight))
-		return 0;
-
-	trans_pcie->cmd_in_flight = false;
+	if (trans->cfg->base_params->apmg_wake_up_wa) {
+		if (WARN_ON(!trans_pcie->cmd_hold_nic_awake))
+			return 0;
 
-	if (trans->cfg->base_params->apmg_wake_up_wa)
+		trans_pcie->cmd_hold_nic_awake = false;
 		__iwl_trans_pcie_clear_bit(trans, CSR_GP_CNTRL,
-					CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-
+					   CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+	}
 	return 0;
 }
 
-- 
2.1.4

