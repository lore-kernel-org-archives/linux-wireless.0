Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:32273 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753761AbYBFTUm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2008 14:20:42 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Gregory Greenman <gregory.greenman@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 3/3] iwlwifi: Don't send host commands on rfkill
Date: Wed,  6 Feb 2008 11:20:40 -0800
Message-Id: <1202325640-9577-4-git-send-email-reinette.chatre@intel.com> (sfid-20080206_192054_702873_DBEDC90F)
In-Reply-To: <1202325640-9577-3-git-send-email-reinette.chatre@intel.com>
References: <1202325640-9577-1-git-send-email-reinette.chatre@intel.com>
 <1202325640-9577-2-git-send-email-reinette.chatre@intel.com>
 <1202325640-9577-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gregory Greenman <gregory.greenman@intel.com>

This patch prevents sending host commands when rfkill is on

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    6 ++++++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    5 +++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 3216167..b642aa2 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -681,6 +681,12 @@ static int iwl3945_enqueue_hcmd(struct iwl3945_priv *priv, struct iwl3945_host_c
 	BUG_ON((fix_size > TFD_MAX_PAYLOAD_SIZE) &&
 	       !(cmd->meta.flags & CMD_SIZE_HUGE));
 
+
+	if (iwl3945_is_rfkill(priv)) {
+		IWL_DEBUG_INFO("Not sending command - RF KILL");
+		return -EIO;
+	}
+
 	if (iwl3945_queue_space(q) < ((cmd->meta.flags & CMD_ASYNC) ? 2 : 1)) {
 		IWL_ERROR("No space for Tx\n");
 		return -ENOSPC;
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 846dc16..c771b64 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -686,6 +686,11 @@ static int iwl4965_enqueue_hcmd(struct iwl4965_priv *priv, struct iwl4965_host_c
 	BUG_ON((fix_size > TFD_MAX_PAYLOAD_SIZE) &&
 	       !(cmd->meta.flags & CMD_SIZE_HUGE));
 
+	if (iwl4965_is_rfkill(priv)) {
+		IWL_DEBUG_INFO("Not sending command - RF KILL");
+		return -EIO;
+	}
+
 	if (iwl4965_queue_space(q) < ((cmd->meta.flags & CMD_ASYNC) ? 2 : 1)) {
 		IWL_ERROR("No space for Tx\n");
 		return -ENOSPC;
-- 
1.5.3.4

