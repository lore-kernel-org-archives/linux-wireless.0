Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:20654 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754582Ab0A2TyM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2010 14:54:12 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 12/12] iwlwifi: iwl_power_update_mode always hold mutex
Date: Fri, 29 Jan 2010 11:54:02 -0800
Message-Id: <1264794842-8046-13-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1264794842-8046-1-git-send-email-reinette.chatre@intel.com>
References: <1264794842-8046-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

iwl_power_update_mode expects to be called with mutex held, for example to
protect priv->vif. Only one caller currently does not do this, fix this.
Also, add a comment to iwl_power_update_mode to indicate this requirement.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    2 ++
 drivers/net/wireless/iwlwifi/iwl-power.c   |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 5c8377b..d134301 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -815,7 +815,9 @@ static ssize_t iwl_dbgfs_sleep_level_override_write(struct file *file,
 
 	priv->power_data.debug_sleep_level_override = value;
 
+	mutex_lock(&priv->mutex);
 	iwl_power_update_mode(priv, true);
+	mutex_unlock(&priv->mutex);
 
 	return count;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 232dd18..1a1a9f0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -303,7 +303,7 @@ static int iwl_set_power(struct iwl_priv *priv, struct iwl_powertable_cmd *cmd)
 				sizeof(struct iwl_powertable_cmd), cmd);
 }
 
-
+/* priv->mutex must be held */
 int iwl_power_update_mode(struct iwl_priv *priv, bool force)
 {
 	int ret = 0;
-- 
1.6.3.3

