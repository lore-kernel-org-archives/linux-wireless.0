Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41798 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488Ab1FRQFb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2011 12:05:31 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 18/25] iwlagn: warn about nested SYNC commands
Date: Sat, 18 Jun 2011 08:34:24 -0700
Message-Id: <1308411271-26093-19-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110618_180558_166798_E27083E7)
In-Reply-To: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since there is no protection around SYNC host command mechanism, at least WARN
when collision happens between two SYNC host comamnds. I am not sure there is a
real  issue (beyond the HCMD_ACTIVE flag maintenance) with having two SYNC host
commands at the same time, but at least now, we will know about it.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    1 +
 drivers/net/wireless/iwlwifi/iwl-hcmd.c |   11 ++++++++++-
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 34f9d0f..2d13d89 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1300,6 +1300,7 @@ struct iwl_priv {
 
 	/* command queue number */
 	u8 cmd_queue;
+	u8 last_sync_cmd_id;
 
 	/* max number of station keys */
 	u8 sta_key_max_num;
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index 76f9966..7cdb1ec 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -181,7 +181,16 @@ int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	IWL_DEBUG_INFO(priv, "Attempting to send sync command %s\n",
 			get_cmd_string(cmd->id));
 
-	set_bit(STATUS_HCMD_ACTIVE, &priv->status);
+	if (test_and_set_bit(STATUS_HCMD_ACTIVE, &priv->status)) {
+		IWL_ERR(priv, "STATUS_HCMD_ACTIVE already set while sending %s"
+			      ". Previous SYNC cmdn is %s\n",
+			get_cmd_string(cmd->id),
+			get_cmd_string(priv->last_sync_cmd_id));
+		WARN_ON(1);
+	} else {
+		priv->last_sync_cmd_id = cmd->id;
+	}
+
 	IWL_DEBUG_INFO(priv, "Setting HCMD_ACTIVE for command %s\n",
 			get_cmd_string(cmd->id));
 
-- 
1.7.0.4

