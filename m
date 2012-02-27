Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:4551 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755448Ab2B0XTE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 18:19:04 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/24] iwlwifi: rename iwl_remove to iwl_op_mode_dvm_stop
Date: Mon, 27 Feb 2012 14:07:30 -0800
Message-Id: <1330380468-17674-7-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120228_001939_760307_ED7CE190)
In-Reply-To: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

iwl_remove stops the wifi flows, so rename.
Moreover, we can possibly stop the wifi flows even if the driver
is statically compiled in the kernel, so remove the __devexit pragma.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-drv.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 8bb97c9..09f343c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1331,7 +1331,7 @@ out:
 	return err;
 }
 
-void __devexit iwl_remove(struct iwl_priv * priv)
+void iwl_op_mode_dvm_stop(struct iwl_priv *priv)
 {
 	wait_for_completion(&nic(priv)->request_firmware_complete);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index b3876de..db430c7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -94,7 +94,7 @@ int iwl_drv_start(struct iwl_shared *shrd,
 
 void iwl_drv_stop(struct iwl_shared *shrd)
 {
-	iwl_remove(shrd->priv);
+	iwl_op_mode_dvm_stop(shrd->priv);
 
 	kfree(shrd->nic);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index d84beef..392b33a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -535,7 +535,7 @@ enum iwl_rxon_context_id {
 int iwl_op_mode_dvm_start(struct iwl_bus *bus,
 			  const struct iwl_trans_ops *trans_ops,
 			  struct iwl_cfg *cfg);
-void __devexit iwl_remove(struct iwl_priv * priv);
+void iwl_op_mode_dvm_stop(struct iwl_priv *priv);
 struct iwl_device_cmd;
 int __must_check iwl_rx_dispatch(struct iwl_priv *priv,
 				 struct iwl_rx_mem_buffer *rxb,
-- 
1.7.0.4

