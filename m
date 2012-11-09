Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54762 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab2KIUJE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 15:09:04 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 13/13] iwlwifi: return commands with error on FW error
Date: Fri,  9 Nov 2012 21:08:12 +0100
Message-Id: <1352491692-28994-14-git-send-email-johannes@sipsolutions.net> (sfid-20121109_210909_674414_E843220F)
In-Reply-To: <1352491692-28994-1-git-send-email-johannes@sipsolutions.net>
References: <1352491692-28994-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When a firmware error occurs, don't just abort synchronous
commands but also return an error (-EIO) and block any new
commands as well. Currently, an error is only returned if
WANT_SKB was set which is confusing and can lead to issues.

Blocking is done until a new firmware image is loaded.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/internal.h |  1 +
 drivers/net/wireless/iwlwifi/pcie/rx.c       |  1 +
 drivers/net/wireless/iwlwifi/pcie/trans.c    |  3 +++
 drivers/net/wireless/iwlwifi/pcie/tx.c       | 10 ++++++++++
 4 files changed, 15 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index 847ef1e..1f065c6 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -296,6 +296,7 @@ enum {
 	STATUS_TPOWER_PMI,
 	STATUS_INT_ENABLED,
 	STATUS_RFKILL,
+	STATUS_FW_ERROR,
 };
 
 #define IWL_TRANS_GET_PCIE_TRANS(_iwl_trans) \
diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 25e6f86..11a93ed 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -582,6 +582,7 @@ static void iwl_irq_handle_error(struct iwl_trans *trans)
 	iwl_dump_csr(trans);
 	iwl_dump_fh(trans, NULL);
 
+	set_bit(STATUS_FW_ERROR, &trans_pcie->status);
 	clear_bit(STATUS_HCMD_ACTIVE, &trans_pcie->status);
 	wake_up(&trans_pcie->wait_command_queue);
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 74d4c79..3adbf4c 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1026,6 +1026,7 @@ static int iwl_load_given_ucode(struct iwl_trans *trans,
 static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 				   const struct fw_img *fw)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int ret;
 	bool hw_rfkill;
 
@@ -1035,6 +1036,8 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 		return -EIO;
 	}
 
+	clear_bit(STATUS_FW_ERROR, &trans_pcie->status);
+
 	iwl_enable_rfkill_int(trans);
 
 	/* If platform's RF_KILL switch is NOT set to KILL */
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index ae73bd3..dcc7e12 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -915,6 +915,13 @@ static int iwl_send_cmd_sync(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 		}
 	}
 
+	if (test_bit(STATUS_FW_ERROR, &trans_pcie->status)) {
+		IWL_ERR(trans, "FW error in SYNC CMD %s\n",
+			trans_pcie_get_cmd_string(trans_pcie, cmd->id));
+		ret = -EIO;
+		goto cancel;
+	}
+
 	if (test_bit(STATUS_RFKILL, &trans_pcie->status)) {
 		IWL_DEBUG_RF_KILL(trans, "RFKILL in SYNC CMD... no rsp\n");
 		ret = -ERFKILL;
@@ -954,6 +961,9 @@ int iwl_trans_pcie_send_cmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
+	if (test_bit(STATUS_FW_ERROR, &trans_pcie->status))
+		return -EIO;
+
 	if (test_bit(STATUS_RFKILL, &trans_pcie->status))
 		return -ERFKILL;
 
-- 
1.8.0

