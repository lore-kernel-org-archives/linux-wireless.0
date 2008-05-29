Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52678 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbYE2IhO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 04:37:14 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 05/43] iwlwifi: create drivers debugfs dir under wiphy->debugfsdir
Date: Thu, 29 May 2008 16:34:50 +0800
Message-Id: <1212050128-17132-6-git-send-email-yi.zhu@intel.com> (sfid-20080529_103719_428932_329F168F)
In-Reply-To: <1212050128-17132-5-git-send-email-yi.zhu@intel.com>
References: <1212050128-17132-1-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-2-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-3-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-4-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-5-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch creates driver's debugfs tree under wiphy->debugfsdir.
This patch fixes collision in debugfs if two or more NICs are plugged.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index c64e602..29e16ba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -367,6 +367,7 @@ DEBUGFS_READ_FILE_OPS(tx_statistics);
 int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 {
 	struct iwl_debugfs *dbgfs;
+	struct dentry *phyd = priv->hw->wiphy->debugfsdir;
 
 	dbgfs = kzalloc(sizeof(struct iwl_debugfs), GFP_KERNEL);
 	if (!dbgfs) {
@@ -375,7 +376,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 
 	priv->dbgfs = dbgfs;
 	dbgfs->name = name;
-	dbgfs->dir_drv = debugfs_create_dir(name, NULL);
+	dbgfs->dir_drv = debugfs_create_dir(name, phyd);
 	if (!dbgfs->dir_drv || IS_ERR(dbgfs->dir_drv)){
 		goto err;
 	}
-- 
1.5.3.6

