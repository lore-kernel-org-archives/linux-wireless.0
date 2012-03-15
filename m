Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21225 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161452Ab2COU2G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 16:28:06 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 15/26] iwlwifi: make iwl_nic_error static
Date: Thu, 15 Mar 2012 13:26:55 -0700
Message-Id: <1331843226-29860-16-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120315_212814_149790_DC46A8AB)
In-Reply-To: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

iwl_nic_error is used in iwl-agn.c only, move
it there and make it static.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    7 +++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h  |    1 -
 drivers/net/wireless/iwlwifi/iwl-core.c |    7 -------
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 3c49c04..37060aa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1556,6 +1556,13 @@ static void iwl_op_mode_dvm_stop(struct iwl_op_mode *op_mode)
 	ieee80211_free_hw(priv->hw);
 }
 
+static void iwl_nic_error(struct iwl_op_mode *op_mode)
+{
+	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
+
+	iwlagn_fw_error(priv, false);
+}
+
 static void iwl_cmd_queue_full(struct iwl_op_mode *op_mode)
 {
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 22fc363..882261b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -92,7 +92,6 @@ int __must_check iwl_rx_dispatch(struct iwl_op_mode *op_mode,
 				 struct iwl_rx_cmd_buffer *rxb,
 				 struct iwl_device_cmd *cmd);
 void iwl_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state);
-void iwl_nic_error(struct iwl_op_mode *op_mode);
 
 bool iwl_check_for_ct_kill(struct iwl_priv *priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index e59cb5b..0a9bc98 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1451,13 +1451,6 @@ __le32 iwl_add_beacon_time(struct iwl_priv *priv, u32 base,
 	return cpu_to_le32(res);
 }
 
-void iwl_nic_error(struct iwl_op_mode *op_mode)
-{
-	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
-
-	iwlagn_fw_error(priv, false);
-}
-
 void iwl_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state)
 {
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
-- 
1.7.0.4

