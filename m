Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:39917 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819Ab0EJW2W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:22 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 03/47] iwlwifi: remove powersave debugfs if it is not supported
Date: Mon, 10 May 2010 15:27:34 -0700
Message-Id: <1273530498-11876-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

For the devices do not have power save support, remove the power save
control related debugfs files.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 0aedbec..f0d9b72 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1612,8 +1612,11 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(interrupt, dir_data, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(qos, dir_data, S_IRUSR);
 	DEBUGFS_ADD_FILE(led, dir_data, S_IRUSR);
-	DEBUGFS_ADD_FILE(sleep_level_override, dir_data, S_IWUSR | S_IRUSR);
-	DEBUGFS_ADD_FILE(current_sleep_command, dir_data, S_IRUSR);
+	if (!priv->cfg->broken_powersave) {
+		DEBUGFS_ADD_FILE(sleep_level_override, dir_data,
+				 S_IWUSR | S_IRUSR);
+		DEBUGFS_ADD_FILE(current_sleep_command, dir_data, S_IRUSR);
+	}
 	DEBUGFS_ADD_FILE(thermal_throttling, dir_data, S_IRUSR);
 	DEBUGFS_ADD_FILE(disable_ht40, dir_data, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(rx_statistics, dir_debug, S_IRUSR);
-- 
1.6.3.3

