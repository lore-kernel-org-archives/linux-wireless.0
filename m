Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:7398 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804Ab1GAPxD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 11:53:03 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/11] iwlagn: verify mutex held for sync commands
Date: Fri,  1 Jul 2011 08:19:55 -0700
Message-Id: <1309533605-25774-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110701_175328_971813_671583DA)
In-Reply-To: <1309533605-25774-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1309533605-25774-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Emmanuel noticed that there's no explicit checking
that prevents the driver from attempting to issue
multiple synchronous commands at the same time and
wrote a patch to check. However, his patch warns
only if a collision actually happened, an unlikely
thing since the driver mutex should be held for
synchronous command submissions.

So instead of checking that a collision happened
add a check that the mutex is held which ensures
that collisions can't happen.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    1 -
 drivers/net/wireless/iwlwifi/iwl-hcmd.c |   13 +++----------
 2 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 8ec04f2..ae2ecc2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1301,7 +1301,6 @@ struct iwl_priv {
 
 	/* command queue number */
 	u8 cmd_queue;
-	u8 last_sync_cmd_id;
 
 	/* max number of station keys */
 	u8 sta_key_max_num;
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index e3e5fb6..107b38e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -171,6 +171,8 @@ int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	int cmd_idx;
 	int ret;
 
+	lockdep_assert_held(&priv->mutex);
+
 	if (WARN_ON(cmd->flags & CMD_ASYNC))
 		return -EINVAL;
 
@@ -181,16 +183,7 @@ int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	IWL_DEBUG_INFO(priv, "Attempting to send sync command %s\n",
 			get_cmd_string(cmd->id));
 
-	if (test_and_set_bit(STATUS_HCMD_ACTIVE, &priv->status)) {
-		IWL_ERR(priv, "STATUS_HCMD_ACTIVE already set while sending %s"
-			      ". Previous SYNC cmdn is %s\n",
-			get_cmd_string(cmd->id),
-			get_cmd_string(priv->last_sync_cmd_id));
-		WARN_ON(1);
-	} else {
-		priv->last_sync_cmd_id = cmd->id;
-	}
-
+	set_bit(STATUS_HCMD_ACTIVE, &priv->status);
 	IWL_DEBUG_INFO(priv, "Setting HCMD_ACTIVE for command %s\n",
 			get_cmd_string(cmd->id));
 
-- 
1.7.0.4

