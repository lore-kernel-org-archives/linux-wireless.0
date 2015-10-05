Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:57181 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750826AbbJEPBf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 11:01:35 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Moshe Harel <moshe.harel@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Oct 2015 17:36:57 +0300
Message-Id: <1444055820-27506-26-git-send-email-luca@coelho.fi> (sfid-20151005_170139_944123_24861632)
In-Reply-To: <1444050759.27220.15.camel@coelho.fi>
References: <1444050759.27220.15.camel@coelho.fi>
Subject: [PATCH 26/29] iwlwifi: nvm: add nvm phy_sku section to debugfs
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Moshe Harel <moshe.harel@intel.com>

The only NVM section not captured in debugfs.

Signed-off-by: Moshe Harel <moshe.harel@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c | 3 +++
 drivers/net/wireless/iwlwifi/mvm/mvm.h     | 1 +
 drivers/net/wireless/iwlwifi/mvm/nvm.c     | 4 ++++
 3 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 3b8481f..9b4fbb8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -1495,6 +1495,9 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 	if (!debugfs_create_blob("nvm_prod", S_IRUSR,
 				  mvm->debugfs_dir, &mvm->nvm_prod_blob))
 		goto err;
+	if (!debugfs_create_blob("nvm_phy_sku", S_IRUSR,
+				 mvm->debugfs_dir, &mvm->nvm_phy_sku_blob))
+		goto err;
 
 	/*
 	 * Create a symlink with mac80211. It will be removed when mac80211
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 99182df..f4e22f5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -688,6 +688,7 @@ struct iwl_mvm {
 	struct debugfs_blob_wrapper nvm_sw_blob;
 	struct debugfs_blob_wrapper nvm_calib_blob;
 	struct debugfs_blob_wrapper nvm_prod_blob;
+	struct debugfs_blob_wrapper nvm_phy_sku_blob;
 
 	struct iwl_mvm_frame_stats drv_rx_stats;
 	spinlock_t drv_stats_lock;
diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index 0b3ffd5..4e4a680 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -564,6 +564,10 @@ int iwl_nvm_init(struct iwl_mvm *mvm, bool read_nvm_from_nic)
 				mvm->nvm_prod_blob.data = temp;
 				mvm->nvm_prod_blob.size  = ret;
 				break;
+			case NVM_SECTION_TYPE_PHY_SKU:
+				mvm->nvm_phy_sku_blob.data = temp;
+				mvm->nvm_phy_sku_blob.size  = ret;
+				break;
 			default:
 				if (section == mvm->cfg->nvm_hw_section_num) {
 					mvm->nvm_hw_blob.data = temp;
-- 
2.5.3

