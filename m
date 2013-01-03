Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48379 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab3ACOpw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 09:45:52 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/12] iwlwifi: let the op_mode run a FW while in RFKILL
Date: Thu,  3 Jan 2013 15:46:08 +0100
Message-Id: <1357224376-27803-4-git-send-email-johannes@sipsolutions.net> (sfid-20130103_154555_625034_E9796903)
In-Reply-To: <1357224376-27803-1-git-send-email-johannes@sipsolutions.net>
References: <1357224324.9741.20.camel@jlt4.sipsolutions.net>
 <1357224376-27803-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

In some cases, the fw should run even if the NIC is in
RFKILL. Make the API more flexible to allow that.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/ucode.c  | 2 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h  | 8 +++++---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 4 ++--
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/ucode.c b/drivers/net/wireless/iwlwifi/dvm/ucode.c
index ecf700b..ebec13a 100644
--- a/drivers/net/wireless/iwlwifi/dvm/ucode.c
+++ b/drivers/net/wireless/iwlwifi/dvm/ucode.c
@@ -343,7 +343,7 @@ int iwl_load_ucode_wait_alive(struct iwl_priv *priv,
 				   alive_cmd, ARRAY_SIZE(alive_cmd),
 				   iwl_alive_fn, &alive_data);
 
-	ret = iwl_trans_start_fw(priv->trans, fw);
+	ret = iwl_trans_start_fw(priv->trans, fw, false);
 	if (ret) {
 		priv->cur_ucode = old_type;
 		iwl_remove_notification(&priv->notif_wait, &alive_wait);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 15b4700..16a82b5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -399,7 +399,8 @@ struct iwl_trans_ops {
 
 	int (*start_hw)(struct iwl_trans *iwl_trans);
 	void (*stop_hw)(struct iwl_trans *iwl_trans, bool op_mode_leaving);
-	int (*start_fw)(struct iwl_trans *trans, const struct fw_img *fw);
+	int (*start_fw)(struct iwl_trans *trans, const struct fw_img *fw,
+			bool run_in_rfkill);
 	void (*fw_alive)(struct iwl_trans *trans, u32 scd_addr);
 	void (*stop_device)(struct iwl_trans *trans);
 
@@ -531,13 +532,14 @@ static inline void iwl_trans_fw_alive(struct iwl_trans *trans, u32 scd_addr)
 }
 
 static inline int iwl_trans_start_fw(struct iwl_trans *trans,
-				     const struct fw_img *fw)
+				     const struct fw_img *fw,
+				     bool run_in_rfkill)
 {
 	might_sleep();
 
 	WARN_ON_ONCE(!trans->rx_mpdu_cmd);
 
-	return trans->ops->start_fw(trans, fw);
+	return trans->ops->start_fw(trans, fw, run_in_rfkill);
 }
 
 static inline void iwl_trans_stop_device(struct iwl_trans *trans)
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index ab179ce..e67e179 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -435,7 +435,7 @@ static int iwl_pcie_load_given_ucode(struct iwl_trans *trans,
 }
 
 static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
-				   const struct fw_img *fw)
+				   const struct fw_img *fw, bool run_in_rfkill)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int ret;
@@ -454,7 +454,7 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 	/* If platform's RF_KILL switch is NOT set to KILL */
 	hw_rfkill = iwl_is_rfkill_set(trans);
 	iwl_op_mode_hw_rf_kill(trans->op_mode, hw_rfkill);
-	if (hw_rfkill)
+	if (hw_rfkill && !run_in_rfkill)
 		return -ERFKILL;
 
 	iwl_write32(trans, CSR_INT, 0xFFFFFFFF);
-- 
1.8.0

