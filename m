Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38078 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755031Ab2CDUnD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:03 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 033/101] iwlwifi: move firmware completion wait
Date: Sun,  4 Mar 2012 11:28:47 -0800
Message-Id: <1330889395-533-34-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214624_635003_0BA6A4B1)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This doesn't belong into the op_mode, it has
to be in the drv stop flow instead.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    2 --
 drivers/net/wireless/iwlwifi/iwl-drv.c |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c3b5946..8bb3f17 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1371,8 +1371,6 @@ static void iwl_op_mode_dvm_stop(struct iwl_op_mode *op_mode)
 {
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
 
-	wait_for_completion(&nic(priv)->request_firmware_complete);
-
 	IWL_DEBUG_INFO(priv, "*** UNLOAD DRIVER ***\n");
 
 	iwl_dbgfs_unregister(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 343f41e..1a588f3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -720,6 +720,8 @@ int iwl_drv_start(struct iwl_shared *shrd,
 
 void iwl_drv_stop(struct iwl_shared *shrd)
 {
+	wait_for_completion(&shrd->nic->request_firmware_complete);
+
 	/* op_mode can be NULL if its start failed */
 	if (shrd->nic->op_mode)
 		iwl_op_mode_stop(shrd->nic->op_mode);
-- 
1.7.0.4

