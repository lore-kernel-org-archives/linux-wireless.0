Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:26419 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073Ab1KJBde (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 20:33:34 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 19/28] iwlwifi: check status before send command
Date: Wed,  9 Nov 2011 16:39:22 -0800
Message-Id: <1320885571-19122-20-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111110_023416_169208_E3815B7E)
In-Reply-To: <1320885571-19122-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1320885571-19122-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check the status before sending host command, if any of the condition
match, cancel the host command before queue

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |   26 +++++++++++----------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index 461e1ae..09a31dc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -1001,6 +1001,20 @@ static int iwl_send_cmd_sync(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 	IWL_DEBUG_INFO(trans, "Attempting to send sync command %s\n",
 			get_cmd_string(cmd->id));
 
+	if (test_bit(STATUS_EXIT_PENDING, &trans->shrd->status))
+		return -EBUSY;
+
+
+	if (test_bit(STATUS_RF_KILL_HW, &trans->shrd->status)) {
+		IWL_ERR(trans, "Command %s aborted: RF KILL Switch\n",
+			       get_cmd_string(cmd->id));
+		return -ECANCELED;
+	}
+	if (test_bit(STATUS_FW_ERROR, &trans->shrd->status)) {
+		IWL_ERR(trans, "Command %s failed: FW Error\n",
+			       get_cmd_string(cmd->id));
+		return -EIO;
+	}
 	set_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status);
 	IWL_DEBUG_INFO(trans, "Setting HCMD_ACTIVE for command %s\n",
 			get_cmd_string(cmd->id));
@@ -1041,18 +1055,6 @@ static int iwl_send_cmd_sync(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 		}
 	}
 
-	if (test_bit(STATUS_RF_KILL_HW, &trans->shrd->status)) {
-		IWL_ERR(trans, "Command %s aborted: RF KILL Switch\n",
-			       get_cmd_string(cmd->id));
-		ret = -ECANCELED;
-		goto fail;
-	}
-	if (test_bit(STATUS_FW_ERROR, &trans->shrd->status)) {
-		IWL_ERR(trans, "Command %s failed: FW Error\n",
-			       get_cmd_string(cmd->id));
-		ret = -EIO;
-		goto fail;
-	}
 	if ((cmd->flags & CMD_WANT_SKB) && !cmd->reply_page) {
 		IWL_ERR(trans, "Error: Response NULL in '%s'\n",
 			  get_cmd_string(cmd->id));
-- 
1.7.0.4

