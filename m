Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:51930 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab3KXUHU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 15:07:20 -0500
Received: by mail-wg0-f43.google.com with SMTP id k14so482801wgh.10
        for <linux-wireless@vger.kernel.org>; Sun, 24 Nov 2013 12:07:19 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 23/29] iwlwifi: mvm: dump NVM from debugfs
Date: Sun, 24 Nov 2013 22:06:40 +0200
Message-Id: <1385323606-3603-23-git-send-email-egrumbach@gmail.com> (sfid-20131124_210808_709910_E28D1644)
In-Reply-To: <52925BE7.4050406@gmail.com>
References: <52925BE7.4050406@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This allows to see the content of the NVM the driver reads.
Note that the output is in binary, and requires some
external user space tool to display the data properly.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c |   13 +++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h     |    5 +++++
 drivers/net/wireless/iwlwifi/mvm/nvm.c     |   23 +++++++++++++++++++++++
 3 files changed, 41 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index a9b2d0a..145cd72 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -716,6 +716,19 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 		goto err;
 #endif
 
+	if (!debugfs_create_blob("nvm_hw", S_IRUSR,
+				  mvm->debugfs_dir, &mvm->nvm_hw_blob))
+		goto err;
+	if (!debugfs_create_blob("nvm_sw", S_IRUSR,
+				  mvm->debugfs_dir, &mvm->nvm_sw_blob))
+		goto err;
+	if (!debugfs_create_blob("nvm_calib", S_IRUSR,
+				  mvm->debugfs_dir, &mvm->nvm_calib_blob))
+		goto err;
+	if (!debugfs_create_blob("nvm_prod", S_IRUSR,
+				  mvm->debugfs_dir, &mvm->nvm_prod_blob))
+		goto err;
+
 	/*
 	 * Create a symlink with mac80211. It will be removed when mac80211
 	 * exists (before the opmode exists which removes the target.)
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index e7c97cc..7dc57cf 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -494,6 +494,11 @@ struct iwl_mvm {
 	u32 dbgfs_sram_offset, dbgfs_sram_len;
 	bool disable_power_off;
 	bool disable_power_off_d3;
+
+	struct debugfs_blob_wrapper nvm_hw_blob;
+	struct debugfs_blob_wrapper nvm_sw_blob;
+	struct debugfs_blob_wrapper nvm_calib_blob;
+	struct debugfs_blob_wrapper nvm_prod_blob;
 #endif
 
 	struct iwl_mvm_phy_ctxt phy_ctxts[NUM_PHY_CTX];
diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index 2beffd0..e4596c5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -443,6 +443,29 @@ int iwl_nvm_init(struct iwl_mvm *mvm)
 			}
 			mvm->nvm_sections[section].data = temp;
 			mvm->nvm_sections[section].length = ret;
+
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+			switch (section) {
+			case NVM_SECTION_TYPE_HW:
+				mvm->nvm_hw_blob.data = temp;
+				mvm->nvm_hw_blob.size = ret;
+				break;
+			case NVM_SECTION_TYPE_SW:
+				mvm->nvm_sw_blob.data = temp;
+				mvm->nvm_sw_blob.size  = ret;
+				break;
+			case NVM_SECTION_TYPE_CALIBRATION:
+				mvm->nvm_calib_blob.data = temp;
+				mvm->nvm_calib_blob.size  = ret;
+				break;
+			case NVM_SECTION_TYPE_PRODUCTION:
+				mvm->nvm_prod_blob.data = temp;
+				mvm->nvm_prod_blob.size  = ret;
+				break;
+			default:
+				WARN(1, "section: %d", section);
+			};
+#endif
 		}
 		kfree(nvm_buffer);
 		if (ret < 0)
-- 
1.7.9.5

