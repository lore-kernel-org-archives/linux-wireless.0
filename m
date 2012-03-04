Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38078 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755042Ab2CDUnE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:04 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 039/101] iwlwifi: move lockdep assertion into DVM
Date: Sun,  4 Mar 2012 11:28:53 -0800
Message-Id: <1330889395-533-40-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214624_074222_6B1079A8)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The fact that the mutex must be held is an
implementation detail of DVM, but something
has to ensure that no two synchronous cmds
are submitted concurrently. Move the lockdep
assertion into the DVM-specific code, but
also make the transport abort if there are
two concurrently commands.

The assertion is much more useful though as
the transport check can only catch it when
it actually happens, while the assertion
makes sure it can't possibly happen.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c       |    8 ++++++++
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |   11 ++++++++---
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 11f2411..238f824 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1298,6 +1298,14 @@ int iwl_dvm_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 		return -EIO;
 	}
 
+	/*
+	 * Synchronous commands from this op-mode must hold
+	 * the mutex, this ensures we don't try to send two
+	 * (or more) synchronous commands at a time.
+	 */
+	if (cmd->flags & CMD_SYNC)
+		lockdep_assert_held(&priv->shrd->mutex);
+
 	return iwl_trans_send_cmd(trans(priv), cmd);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index c85975e..ca4ceea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -973,8 +973,6 @@ static int iwl_send_cmd_sync(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 	int cmd_idx;
 	int ret;
 
-	lockdep_assert_held(&trans->shrd->mutex);
-
 	IWL_DEBUG_INFO(trans, "Attempting to send sync command %s\n",
 			get_cmd_string(cmd->id));
 
@@ -983,7 +981,14 @@ static int iwl_send_cmd_sync(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 			       get_cmd_string(cmd->id));
 		return -EIO;
 	}
-	set_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status);
+
+	if (WARN_ON(test_and_set_bit(STATUS_HCMD_ACTIVE,
+				     &trans->shrd->status))) {
+		IWL_ERR(trans, "Command %s: a command is already active!\n",
+			get_cmd_string(cmd->id));
+		return -EIO;
+	}
+
 	IWL_DEBUG_INFO(trans, "Setting HCMD_ACTIVE for command %s\n",
 			get_cmd_string(cmd->id));
 
-- 
1.7.0.4

